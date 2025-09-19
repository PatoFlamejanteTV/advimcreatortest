package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class TimeEvent extends Event
   {
      
      public static const TIME_DURATION_CHANGED:String = "timeDurationChanged";
      
      public static const TIME_POSITION_CHANGED:String = "timePositionChanged";
      
      public static const TIME_SEEKABLE_CHANGED:String = "timeSeekableChanged";
      
      public function TimeEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new TimeEvent(this.type,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("TimeEvent","type","bubbles","eventPhase");
      }
   }
}

