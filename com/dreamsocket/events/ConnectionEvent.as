package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class ConnectionEvent extends Event
   {
      
      public static const CONNECTION_CLOSED:String = "connectionClosed";
      
      public static const CONNECTION_REQUESTED:String = "connectionRequested";
      
      public static const CONNECTION_OPENED:String = "connectionOpened";
      
      public function ConnectionEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new ConnectionEvent(this.type,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("ConnectionEvent","type","bubbles","eventPhase");
      }
   }
}

