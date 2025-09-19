package com.dreamsocket.data
{
   import com.dreamsocket.events.RangeEvent;
   import flash.events.EventDispatcher;
   
   public class Range extends EventDispatcher implements IRange
   {
      
      protected var m_start:Number;
      
      protected var m_end:Number;
      
      public function Range(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.m_start = param1;
         this.m_end = param2;
      }
      
      public function get length() : Number
      {
         return this.m_end - this.m_start;
      }
      
      public function get start() : Number
      {
         return this.m_start;
      }
      
      public function set start(param1:Number) : void
      {
         if(param1 != this.m_start)
         {
            this.m_start = param1;
            if(this.hasEventListener(RangeEvent.RANGE_START_CHANGED))
            {
               this.dispatchEvent(new RangeEvent(RangeEvent.RANGE_START_CHANGED,param1,this.end));
            }
         }
      }
      
      public function get end() : Number
      {
         return this.m_end;
      }
      
      public function set end(param1:Number) : void
      {
         if(param1 != this.m_end)
         {
            this.m_end = param1;
            if(this.hasEventListener(RangeEvent.RANGE_END_CHANGED))
            {
               this.dispatchEvent(new RangeEvent(RangeEvent.RANGE_END_CHANGED,this.start,param1));
            }
         }
      }
      
      public function clone() : IRange
      {
         return new Range(this.start,this.end);
      }
      
      public function compare(param1:IRange) : int
      {
         if(this.start == param1.start && this.end == param1.end)
         {
            return 0;
         }
         if(this.start <= param1.start && this.end < param1.end)
         {
            return -1;
         }
         return 1;
      }
      
      public function compareValues(param1:Number, param2:Number) : Number
      {
         if(this.start == param1 && this.end == param2)
         {
            return 0;
         }
         if(this.start > param1 || this.start == param1 && this.end > param2)
         {
            return 1;
         }
         return -1;
      }
      
      public function containsValue(param1:Number) : Boolean
      {
         return param1 >= this.start && param1 <= this.end;
      }
      
      override public function toString() : String
      {
         return "[Range (" + this.start + ", " + this.end + ")]";
      }
   }
}

