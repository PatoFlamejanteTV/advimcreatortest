package com.dreamsocket.events
{
   import com.dreamsocket.cues.ICueRange;
   import flash.events.Event;
   
   public class CueRangeEvent extends Event
   {
      
      public static const CUE_RANGE_ENTERED:String = "cueRangeEntered";
      
      public static const CUE_RANGE_EXITED:String = "cueRangeExited";
      
      protected var m_cueRange:ICueRange;
      
      public function CueRangeEvent(param1:String, param2:ICueRange, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.m_cueRange = param2;
      }
      
      public function get cueRange() : ICueRange
      {
         return this.m_cueRange;
      }
      
      override public function clone() : Event
      {
         return new CueRangeEvent(this.type,this.cueRange,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("CueRangeEvent","type","bubbles","cancelable");
      }
   }
}

