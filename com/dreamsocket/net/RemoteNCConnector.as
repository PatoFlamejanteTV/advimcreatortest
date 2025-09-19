package com.dreamsocket.net
{
   import com.dreamsocket.events.ConnectionEvent;
   import com.dreamsocket.events.ConnectionExceptionEvent;
   import com.dreamsocket.utils.URLUtil;
   import flash.errors.IOError;
   import flash.events.AsyncErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import flash.net.ObjectEncoding;
   import flash.utils.Timer;
   
   public class RemoteNCConnector extends EventDispatcher
   {
      
      public static var defaultTimeout:uint = 60000;
      
      public static var defaultConnectionSequence:Array = [{
         "protocol":"rtmp",
         "port":"1935"
      },{
         "protocol":"rtmpt",
         "port":"80"
      },{
         "protocol":"rtmp",
         "port":"443"
      },{
         "protocol":"rtmps",
         "port":"443"
      }];
      
      protected static const k_ATTEMPT_DELAY:uint = 1500;
      
      protected var m_client:Object;
      
      protected var m_conn:NetConnection;
      
      protected var m_connAttempt:uint;
      
      protected var m_connParams:Array;
      
      protected var m_objectEncoding:uint;
      
      protected var m_possibleConns:Array;
      
      protected var m_connTypes:Array;
      
      protected var m_attemptTimer:Timer;
      
      protected var m_timeoutTimer:Timer;
      
      protected var m_url:String;
      
      protected var m_request:RemoteNCRequest;
      
      public function RemoteNCConnector()
      {
         super();
         this.m_url = "";
         this.m_objectEncoding = ObjectEncoding.AMF0;
         this.m_connAttempt = 0;
         this.m_attemptTimer = new Timer(RemoteNCConnector.k_ATTEMPT_DELAY,1);
         this.m_attemptTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onAttemptTimeout,false,0,true);
         this.m_timeoutTimer = new Timer(RemoteNCConnector.defaultTimeout);
         this.m_timeoutTimer.addEventListener(TimerEvent.TIMER,this.onConnectTimeout,false,0,true);
      }
      
      public function get netConnection() : NetConnection
      {
         return this.m_conn;
      }
      
      public function get client() : Object
      {
         return this.m_client;
      }
      
      public function set client(param1:Object) : void
      {
         this.m_client = param1;
         if(this.m_conn != null)
         {
            this.m_conn.client = param1;
         }
      }
      
      public function get connected() : Boolean
      {
         return this.m_conn == null ? false : this.m_conn.connected;
      }
      
      public function get objectEncoding() : uint
      {
         return this.m_objectEncoding;
      }
      
      public function set objectEncoding(param1:uint) : void
      {
         this.m_objectEncoding = param1;
      }
      
      public function get timeout() : Number
      {
         return this.m_timeoutTimer.delay;
      }
      
      public function set timeout(param1:Number) : void
      {
         this.m_timeoutTimer.delay = param1;
      }
      
      public function get uri() : String
      {
         return this.m_url;
      }
      
      public function close() : void
      {
         this.cleanConnections();
         if(this.m_conn != null)
         {
            this.m_conn.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError);
            this.m_conn.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.m_conn.removeEventListener(NetStatusEvent.NET_STATUS,this.onConnectedStatus);
            this.m_conn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.m_conn.close();
            this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_CLOSED));
         }
      }
      
      public function connect(... rest) : Boolean
      {
         var _loc2_:String = rest[0].toString();
         if(_loc2_ == this.m_url && this.m_conn != null && this.m_conn.connected)
         {
            return true;
         }
         this.close();
         this.m_conn = null;
         this.m_connAttempt = 0;
         this.m_connParams = rest.concat();
         this.m_url = _loc2_;
         if(rest[0] is RemoteNCRequest)
         {
            this.m_request = this.m_request.clone();
         }
         else
         {
            this.m_request = new RemoteNCRequest();
            this.m_request.protocol = URLUtil.getProtocol(_loc2_);
            this.m_request.server = URLUtil.getServer(_loc2_);
            this.m_request.port = URLUtil.getPort(_loc2_);
            this.m_request.app = URLUtil.getBasePath(_loc2_);
         }
         this.m_connTypes = RemoteNCConnector.defaultConnectionSequence.concat();
         this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_REQUESTED));
         this.doConnect();
         return false;
      }
      
      public function reconnect() : void
      {
         if(this.m_conn != null && !this.m_conn.connected)
         {
            this.cleanConnections();
            try
            {
               this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_REQUESTED));
               this.m_conn.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError,false,0,true);
               this.m_conn.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
               this.m_conn.addEventListener(NetStatusEvent.NET_STATUS,this.onConnectedStatus,false,0,true);
               this.m_conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
               this.m_conn.connect.apply(this.m_conn,this.m_connParams);
            }
            catch(e:Error)
            {
               if(e is SecurityError)
               {
                  this.dispatchEvent(new ConnectionExceptionEvent(ConnectionExceptionEvent.CONNECTION_SECURITY_EXCEPTION,e));
               }
               else if(e is IOError)
               {
                  this.dispatchEvent(new ConnectionExceptionEvent(ConnectionExceptionEvent.CONNECTION_IO_EXCEPTION,e));
               }
            }
         }
      }
      
      protected function doConnect() : void
      {
         this.m_timeoutTimer.reset();
         this.m_timeoutTimer.start();
         this.createPossibleConnections();
         this.attemptNextConnection();
      }
      
      protected function attemptNextConnection() : void
      {
         var url:String;
         var connParams:Array;
         var protocol:String = null;
         var port:String = null;
         var i:uint = 0;
         var len:uint = 0;
         this.m_attemptTimer.stop();
         this.m_attemptTimer.reset();
         url = "";
         connParams = this.m_connParams.concat();
         if(this.m_connAttempt == 0)
         {
            protocol = this.m_request.protocol;
            port = this.m_request.port;
            if(port == null)
            {
               port = NCDefaultPortRegistry.getInstance().getPort(protocol);
            }
            i = 0;
            len = this.m_connTypes.length;
            while(i < len)
            {
               if(this.m_connTypes[i].protocol == protocol && this.m_connTypes[i].port == port)
               {
                  this.m_connTypes.unshift(this.m_connTypes.splice(i,1)[0]);
                  break;
               }
               i++;
            }
         }
         else
         {
            protocol = this.m_connTypes[this.m_connAttempt].protocol;
            port = this.m_connTypes[this.m_connAttempt].port;
         }
         url += protocol + ":/";
         url += this.m_request.server == null ? "" : "/" + this.m_request.server;
         url += ":" + port;
         url += this.m_request.app == null ? "" : this.m_request.app;
         connParams[0] = url;
         try
         {
            this.m_possibleConns[this.m_connAttempt].connect.apply(this.m_possibleConns[this.m_connAttempt],connParams);
         }
         catch(e:Error)
         {
         }
         if(this.m_connAttempt < RemoteNCConnector.defaultConnectionSequence.length - 1)
         {
            this.m_attemptTimer.start();
         }
         ++this.m_connAttempt;
      }
      
      protected function cleanConnections() : void
      {
         var _loc1_:NetConnection = null;
         var _loc2_:uint = 0;
         this.m_attemptTimer.stop();
         this.m_attemptTimer.reset();
         this.m_timeoutTimer.stop();
         this.m_timeoutTimer.reset();
         if(this.m_possibleConns != null)
         {
            _loc2_ = this.m_possibleConns.length;
            while(_loc2_--)
            {
               _loc1_ = NetConnection(this.m_possibleConns[_loc2_]);
               if(_loc1_ != null)
               {
                  _loc1_.removeEventListener(NetStatusEvent.NET_STATUS,this.onConnectStatus);
                  if(_loc1_.client.pending)
                  {
                     _loc1_.addEventListener(NetStatusEvent.NET_STATUS,this.onDisconnectStatus,false,0,true);
                  }
                  else
                  {
                     _loc1_.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError);
                     _loc1_.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
                     _loc1_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
                     _loc1_.close();
                  }
               }
               this.m_possibleConns[_loc2_] = null;
            }
            this.m_possibleConns = null;
         }
      }
      
      protected function createPossibleConnections() : void
      {
         var _loc2_:NetConnection = null;
         var _loc1_:uint = RemoteNCConnector.defaultConnectionSequence.length;
         this.m_possibleConns = [];
         while(_loc1_--)
         {
            _loc2_ = this.m_possibleConns[_loc1_] = new NetConnection();
            _loc2_.client = {
               "pending":true,
               "index":_loc1_
            };
            _loc2_.objectEncoding = this.m_objectEncoding;
            _loc2_.addEventListener(NetStatusEvent.NET_STATUS,this.onConnectStatus,false,0,true);
            _loc2_.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError,false,0,true);
            _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
            _loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
         }
      }
      
      protected function onAttemptTimeout(param1:TimerEvent) : void
      {
         this.attemptNextConnection();
      }
      
      protected function onConnectTimeout(param1:Event = null) : void
      {
         this.cleanConnections();
         this.dispatchEvent(new ConnectionExceptionEvent(ConnectionExceptionEvent.CONNECTION_IO_EXCEPTION,new IOError("NetConnection.Connection.Timeout")));
      }
      
      protected function onConnectStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:String = param1.info.code;
         param1.target.client.pending = false;
         if(param1.info.code == "NetConnection.Connect.Closed")
         {
            return;
         }
         if(_loc2_ == "NetConnection.Connect.Success")
         {
            this.m_conn = NetConnection(param1.target);
            this.m_conn.removeEventListener(NetStatusEvent.NET_STATUS,this.onConnectStatus);
            this.m_conn.addEventListener(NetStatusEvent.NET_STATUS,this.onConnectedStatus,false,0,true);
            if(this.client != null)
            {
               this.m_conn.client = this.client;
            }
            this.m_possibleConns[NetConnection(param1.target).client.index] = null;
            this.cleanConnections();
            this.m_connParams[0] = NetConnection(param1.target).uri;
            this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_OPENED));
         }
         else if(NetConnection(param1.target).uri == null || (_loc2_ == "NetConnection.Connect.Failed" || _loc2_ == "NetConnection.Connect.Rejected" || _loc2_ == "NetConnection.Connect.InvalidApp") && this.m_connAttempt == RemoteNCConnector.defaultConnectionSequence.length)
         {
            this.dispatchEvent(new ConnectionExceptionEvent(ConnectionExceptionEvent.CONNECTION_IO_EXCEPTION,new IOError(param1.info.code)));
            this.cleanConnections();
         }
      }
      
      protected function onConnectedStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:String = param1.info.code;
         switch(_loc2_)
         {
            case "NetConnection.Connect.Success":
               this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_OPENED));
               break;
            case "NetConnection.Connect.AppShutdown":
            case "NetConnection.Connect.Closed":
               this.close();
               break;
            case "NetConnection.Connect.Failed":
            case "NetConnection.Connect.Rejected":
            case "NetConnection.Connect.InvalidApp":
               this.m_conn.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError);
               this.m_conn.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
               this.m_conn.removeEventListener(NetStatusEvent.NET_STATUS,this.onConnectedStatus);
               this.m_conn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
               this.m_conn.close();
               this.dispatchEvent(new ConnectionExceptionEvent(ConnectionExceptionEvent.CONNECTION_IO_EXCEPTION,new IOError(_loc2_)));
               break;
            case "NetConnection.Call.BadVersion":
            case "NetConnection.Call.Failed":
            case "NetConnection.Call.Prohibited":
               this.dispatchEvent(new ConnectionExceptionEvent(ConnectionExceptionEvent.CONNECTION_ASYNC_EXCEPTION,new Error(_loc2_)));
         }
      }
      
      protected function onDisconnectStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:NetConnection = null;
         if(param1.info.code == "NetConnection.Connect.Success")
         {
            _loc2_ = param1.target as NetConnection;
            _loc2_.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            _loc2_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            _loc2_.removeEventListener(NetStatusEvent.NET_STATUS,this.onDisconnectStatus);
            _loc2_.close();
         }
      }
      
      protected function onAsyncError(param1:AsyncErrorEvent) : void
      {
         this.dispatchEvent(new ConnectionExceptionEvent(ConnectionExceptionEvent.CONNECTION_ASYNC_EXCEPTION,param1.error));
      }
      
      protected function onIOError(param1:IOErrorEvent) : void
      {
         if(param1.target.client != null && Boolean(param1.target.client.hasOwnProperty("pending")))
         {
            param1.target.client.pending = false;
         }
         this.dispatchEvent(new ConnectionExceptionEvent(ConnectionExceptionEvent.CONNECTION_IO_EXCEPTION,new IOError(param1.text)));
         this.cleanConnections();
      }
      
      protected function onSecurityError(param1:SecurityErrorEvent) : void
      {
         if(param1.target.client != null && Boolean(param1.target.client.hasOwnProperty("pending")))
         {
            param1.target.client.pending = false;
         }
         this.dispatchEvent(new ConnectionExceptionEvent(ConnectionExceptionEvent.CONNECTION_SECURITY_EXCEPTION,new SecurityError(param1.text)));
         this.cleanConnections();
      }
   }
}

