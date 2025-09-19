package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class MediaExceptionEvent extends ExceptionEvent
   {
      
      public static const MEDIA_ASYNC_EXCEPTION:String = "mediaAsyncException";
      
      public static const MEDIA_IO_EXCEPTION:String = "mediaIOException";
      
      public static const MEDIA_SECURITY_EXCEPTION:String = "mediaSecurityException";
      
      public function MediaExceptionEvent(param1:String, param2:Error, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new MediaExceptionEvent(this.type,new Error(this.cause.message,this.cause.errorID),this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("MediaExceptionEvent","type","code","message","bubbles","eventPhase");
      }
   }
}

