package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class ExceptionEvent extends Event
   {
      
      public static const EXCEPTION:String = "exception";
      
      protected var m_cause:Error;
      
      public function ExceptionEvent(param1:String, param2:Error, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.m_cause = param2;
      }
      
      public function get cause() : Error
      {
         return this.m_cause;
      }
      
      public function get code() : int
      {
         return this.m_cause.errorID;
      }
      
      public function get message() : String
      {
         return this.m_cause.message;
      }
      
      override public function clone() : Event
      {
         return new ExceptionEvent(this.type,new Error(this.cause.message,this.cause.errorID),this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("ExceptionEvent","type","code","message","bubbles","cancelable");
      }
   }
}

