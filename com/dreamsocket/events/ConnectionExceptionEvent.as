package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class ConnectionExceptionEvent extends ExceptionEvent
   {
      
      public static const CONNECTION_ASYNC_EXCEPTION:String = "connectionAsyncException";
      
      public static const CONNECTION_IO_EXCEPTION:String = "connectionIOException";
      
      public static const CONNECTION_SECURITY_EXCEPTION:String = "connectionSecurityException";
      
      public function ConnectionExceptionEvent(param1:String, param2:Error, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new ConnectionExceptionEvent(this.type,new Error(this.cause.message,this.cause.errorID),this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("ConnectionExceptionEvent","type","code","message","bubbles","cancelable");
      }
   }
}

