package com.dreamsocket.media.streamingNSClasses
{
   import com.dreamsocket.events.NetInfoEvent;
   import flash.events.EventDispatcher;
   
   public dynamic class StreamingNSNCClient extends EventDispatcher
   {
      
      protected var m_latency:Number;
      
      protected var m_payload:Number;
      
      protected var m_bandwidth:Number;
      
      public function StreamingNSNCClient()
      {
         super();
         this.m_payload = 0;
         this.m_bandwidth = 0;
      }
      
      public function close() : void
      {
      }
      
      public function _onbwcheck(param1:Object, param2:Number) : Number
      {
         return param2;
      }
      
      public function _onbwdone(param1:Number, param2:Number) : void
      {
         this.m_bandwidth = param2;
         this.m_latency = param1;
      }
      
      public function onBWDone(... rest) : void
      {
         if(!isNaN(rest[0]))
         {
            this.m_bandwidth = rest[0];
         }
      }
      
      public function onBWCheck(... rest) : Number
      {
         return ++this.m_payload;
      }
      
      public function onFCSubscribe(param1:Object) : void
      {
         this.dispatchEvent(new NetInfoEvent(NetInfoEvent.NET_INFO_FCSUBSCRIBE,param1));
      }
      
      public function onFCUnsubscribe(param1:Object) : void
      {
         this.dispatchEvent(new NetInfoEvent(NetInfoEvent.NET_INFO_FCUNSUBSCRIBE,param1));
      }
   }
}

