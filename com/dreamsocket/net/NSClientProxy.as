package com.dreamsocket.net
{
   import com.dreamsocket.events.NetInfoEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public dynamic class NSClientProxy extends Proxy implements IEventDispatcher
   {
      
      protected var m_client:Object;
      
      protected var m_evtMgr:EventDispatcher;
      
      public function NSClientProxy(param1:Object = null)
      {
         super();
         this.m_client = param1;
         this.m_evtMgr = new EventDispatcher(this);
      }
      
      public function get proxiedClient() : Object
      {
         return this.m_client;
      }
      
      public function set proxiedClient(param1:Object) : void
      {
         this.m_client = param1;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this.m_evtMgr.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this.m_evtMgr.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this.m_evtMgr.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this.m_evtMgr.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this.m_evtMgr.willTrigger(param1);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this.m_client[param1];
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         var p_name:* = param1;
         var p_value:* = param2;
         try
         {
            if(this.m_client != null)
            {
               this.m_client[p_name] = p_value;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         var p_method:* = param1;
         var p_args:Array = rest;
         if(this.m_client == null)
         {
            return null;
         }
         try
         {
            return this.m_client[p_method].apply(this.m_client,p_args);
         }
         catch(e:Error)
         {
            return null;
         }
      }
      
      public function onCuePoint(param1:Object) : void
      {
         this.m_evtMgr.dispatchEvent(new NetInfoEvent(NetInfoEvent.NET_INFO_CUE_POINT,param1));
         if(this.m_client != null && this.m_client.onCuePoint != null)
         {
            this.m_client.onCuePoint(param1);
         }
      }
      
      public function onImageData(param1:Object) : void
      {
         this.m_evtMgr.dispatchEvent(new NetInfoEvent(NetInfoEvent.NET_INFO_IMAGE_DATA,param1));
         if(this.m_client != null && this.m_client.onImageData != null)
         {
            this.m_client.onImageData(param1);
         }
      }
      
      public function onMetaData(param1:Object) : void
      {
         this.m_evtMgr.dispatchEvent(new NetInfoEvent(NetInfoEvent.NET_INFO_META_DATA,param1));
         if(this.m_client != null && this.m_client.onMetaData != null)
         {
            this.m_client.onMetaData(param1);
         }
      }
      
      public function onPlayStatus(param1:Object) : void
      {
         this.m_evtMgr.dispatchEvent(new NetInfoEvent(NetInfoEvent.NET_INFO_PLAY_STATUS,param1));
         if(this.m_client != null && this.m_client.onPlayStatus != null)
         {
            this.m_client.onPlayStatus(param1);
         }
      }
      
      public function onTextData(param1:Object) : void
      {
         this.m_evtMgr.dispatchEvent(new NetInfoEvent(NetInfoEvent.NET_INFO_TEXT_DATA,param1));
         if(this.m_client != null && this.m_client.onTextData != null)
         {
            this.m_client.onTextData(param1);
         }
      }
      
      public function onXMPData(param1:Object) : void
      {
         this.m_evtMgr.dispatchEvent(new NetInfoEvent(NetInfoEvent.NET_INFO_XMP_DATA,param1));
         if(this.m_client != null && this.m_client.onXMPData != null)
         {
            this.m_client.onXMPData(param1);
         }
      }
   }
}

