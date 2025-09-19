package com.dreamsocket.services
{
   import com.dreamsocket.net.http.*;
   import com.dreamsocket.services.events.FaultEvent;
   import com.dreamsocket.services.events.ResultEvent;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   
   public class HTTPService extends EventDispatcher implements IService
   {
      
      protected var m_contentType:String;
      
      protected var m_dataFormat:String;
      
      protected var m_headers:Object;
      
      protected var m_lastResult:Object;
      
      protected var m_loader:URLLoader;
      
      protected var m_method:String;
      
      protected var m_responder:MultiResponder;
      
      protected var m_request:Object;
      
      protected var m_timeoutTimer:Timer;
      
      protected var m_rootUrl:String;
      
      protected var m_url:String;
      
      protected var m_dataEncoder:Function;
      
      protected var m_dataDecoder:Function;
      
      public function HTTPService(param1:String = "")
      {
         super(this);
         this.m_dataEncoder = this.encodeData;
         this.m_rootUrl = param1;
         this.m_dataFormat = HTTPDataFormat.TEXT;
         this.m_headers = {};
         this.m_contentType = HTTPContentType.FORM;
         this.m_method = HTTPRequestMethod.GET;
         this.m_request = {};
         this.m_url = "";
         this.m_timeoutTimer = new Timer(0,1);
      }
      
      public function set contentType(param1:String) : void
      {
         this.m_contentType = param1;
      }
      
      public function get contentType() : String
      {
         return this.m_contentType;
      }
      
      public function set headers(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 is Array)
         {
            this.m_headers = (param1 as Array).concat();
         }
         else
         {
            this.m_headers = {};
            for(_loc2_ in param1)
            {
               this.m_headers[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function get headers() : Object
      {
         return this.m_headers;
      }
      
      public function get lastResult() : Object
      {
         return this.m_lastResult;
      }
      
      public function set method(param1:String) : void
      {
         this.m_method = param1;
      }
      
      public function get method() : String
      {
         return this.m_method;
      }
      
      public function get resultFormat() : String
      {
         return this.m_dataFormat;
      }
      
      public function set resultFormat(param1:String) : void
      {
         this.m_dataFormat = param1;
      }
      
      public function set request(param1:Object) : void
      {
         var _loc2_:String = null;
         this.m_request = {};
         for(_loc2_ in param1)
         {
            this.m_request[_loc2_] = param1[_loc2_];
         }
      }
      
      public function get request() : Object
      {
         return this.m_request;
      }
      
      public function set requestTimeout(param1:Number) : void
      {
         this.m_timeoutTimer.delay = param1;
      }
      
      public function get requestTimeout() : Number
      {
         return this.m_timeoutTimer.delay;
      }
      
      public function set rootURL(param1:String) : void
      {
         this.m_rootUrl = param1;
      }
      
      public function get rootURL() : String
      {
         return this.m_rootUrl;
      }
      
      public function set url(param1:String) : void
      {
         this.m_url = param1;
      }
      
      public function get url() : String
      {
         return this.m_url;
      }
      
      public function set dataDecoder(param1:Function) : void
      {
         this.m_dataDecoder = param1;
      }
      
      public function set dataEncoder(param1:Function) : void
      {
         this.m_dataEncoder = param1;
      }
      
      public function cancel() : void
      {
         this.disconnect();
      }
      
      public function disconnect() : void
      {
         this.m_timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeout);
         this.m_timeoutTimer.stop();
         this.m_timeoutTimer.reset();
         if(this.m_loader != null)
         {
            try
            {
               this.m_loader.close();
            }
            catch(e:*)
            {
            }
            this.m_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
            this.m_loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this.m_loader.removeEventListener(Event.COMPLETE,this.onData);
            this.m_loader = null;
         }
         this.m_lastResult = null;
         this.m_responder = null;
      }
      
      public function send(param1:Object = null) : MultiResponder
      {
         var _loc3_:String = null;
         var _loc4_:XML = null;
         var _loc5_:URLVariables = null;
         var _loc2_:URLRequest = new URLRequest();
         _loc2_.url = this.getURL();
         this.disconnect();
         this.m_loader = new URLLoader();
         if(param1 != null)
         {
            this.request = param1;
         }
         _loc2_.method = this.m_method;
         if(this.m_contentType == HTTPContentType.XML)
         {
            _loc4_ = this.m_dataEncoder(this.m_request);
            _loc2_.data = _loc4_.toString();
            _loc2_.method = HTTPRequestMethod.POST;
         }
         else
         {
            _loc5_ = new URLVariables();
            for(_loc3_ in this.m_request)
            {
               _loc5_[_loc3_] = this.m_request[_loc3_];
            }
            if(_loc5_.toString().length > 0)
            {
               _loc2_.data = _loc5_;
            }
         }
         if(this.m_headers is Array && this.m_headers.length > 0)
         {
            _loc2_.requestHeaders = this.m_headers as Array;
            _loc2_.method = HTTPRequestMethod.POST;
         }
         else
         {
            for(_loc3_ in this.m_headers)
            {
               _loc2_.requestHeaders.push(new URLRequestHeader(_loc3_,this.m_headers[_loc3_]));
               _loc2_.method = HTTPRequestMethod.POST;
            }
         }
         if(this.m_timeoutTimer.delay > 0)
         {
            this.m_timeoutTimer.addEventListener(TimerEvent.TIMER,this.onTimeout,false,0,true);
            this.m_timeoutTimer.start();
         }
         this.m_loader.dataFormat = HTTPDataFormat.TEXT;
         this.m_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
         this.m_loader.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
         this.m_loader.addEventListener(Event.COMPLETE,this.onData,false,0,true);
         this.m_loader.load(_loc2_);
         this.m_responder = new MultiResponder();
         return this.m_responder;
      }
      
      protected function encodeData(param1:Object) : XML
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc2_:* = "<request>";
         for(_loc4_ in param1)
         {
            _loc2_ += "<" + _loc4_ + ">" + this.m_request[_loc4_] + "</" + _loc4_ + ">";
         }
         _loc2_ += "</request>";
         return new XML(_loc2_);
      }
      
      protected function getURL() : String
      {
         var _loc1_:String = this.m_url == null ? "" : this.m_url;
         if(_loc1_.indexOf("://") == -1)
         {
            _loc1_ = this.m_rootUrl + _loc1_;
         }
         return _loc1_;
      }
      
      protected function sendFault(param1:FaultEvent, param2:MultiResponder) : void
      {
         this.dispatchEvent(param1);
         param2.fault(param1);
      }
      
      protected function sendResult(param1:ResultEvent, param2:MultiResponder) : void
      {
         this.m_lastResult = ResultEvent(param1).result;
         this.dispatchEvent(param1);
         param2.result(param1);
      }
      
      protected function onData(param1:Event) : void
      {
         var evt:Event = null;
         var x:XML = null;
         var decoder:URLVariables = null;
         var p_evt:Event = param1;
         var data:* = this.m_loader.data;
         var responder:MultiResponder = this.m_responder;
         this.disconnect();
         switch(this.m_dataFormat)
         {
            case HTTPDataFormat.XML:
               try
               {
                  x = new XML(data);
                  evt = new ResultEvent(ResultEvent.RESULT,false,this.m_dataDecoder == null ? x : this.m_dataDecoder(x));
               }
               catch(err:TypeError)
               {
                  evt = new FaultEvent(FaultEvent.FAULT,false,new Fault(String(err.errorID),err.name,err.message));
               }
               break;
            case HTTPDataFormat.VARIABLES:
               try
               {
                  decoder = new URLVariables();
                  decoder.decode(data);
                  data = decoder;
                  evt = new ResultEvent(ResultEvent.RESULT,false,data);
               }
               catch(err:Error)
               {
                  evt = new FaultEvent(FaultEvent.FAULT,false,new Fault(String(err.errorID),err.name,err.message));
               }
               break;
            case HTTPDataFormat.TEXT:
               evt = new ResultEvent(ResultEvent.RESULT,false,data);
         }
         if(evt is FaultEvent)
         {
            this.sendFault(FaultEvent(evt),responder);
         }
         else if(evt is ResultEvent)
         {
            this.sendResult(ResultEvent(evt),responder);
         }
      }
      
      protected function onTimeout(param1:TimerEvent) : void
      {
         var _loc2_:Fault = new Fault(String(408),"RequestTimeout",this.m_url + ":Timed out");
         var _loc3_:FaultEvent = new FaultEvent(FaultEvent.FAULT,false,_loc2_);
         var _loc4_:MultiResponder = this.m_responder;
         this.disconnect();
         this.sendFault(_loc3_,_loc4_);
      }
      
      protected function onError(param1:ErrorEvent) : void
      {
         var _loc2_:Fault = new Fault(String(param1.type),param1.type,param1.text);
         var _loc3_:FaultEvent = new FaultEvent(FaultEvent.FAULT,false,_loc2_);
         var _loc4_:MultiResponder = this.m_responder;
         _loc2_.rootCause = param1;
         this.disconnect();
         this.sendFault(_loc3_,_loc4_);
      }
   }
}

