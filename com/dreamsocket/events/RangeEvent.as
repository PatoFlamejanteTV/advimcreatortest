package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class RangeEvent extends Event
   {
      
      public static const RANGE_START_CHANGED:String = "rangeStartChanged";
      
      public static const RANGE_END_CHANGED:String = "rangeEndChanged";
      
      protected var m_min:Number;
      
      protected var m_max:Number;
      
      public function RangeEvent(param1:String, param2:Number, param3:Number, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.m_min = param2;
         this.m_max = param3;
      }
      
      public function get start() : Number
      {
         return this.m_min;
      }
      
      public function get end() : Number
      {
         return this.m_max;
      }
      
      override public function clone() : Event
      {
         return new RangeEvent(this.type,this.start,this.end,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("RangeEvent","type","start","end","bubbles","cancelable");
      }
   }
}

