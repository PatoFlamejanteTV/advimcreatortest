package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class BufferTimeEvent extends Event
   {
      
      public static const BUFFER_TIME_STARTED:String = "bufferTimeStarted";
      
      public static const BUFFER_TIME_STOPPED:String = "bufferTimeStopped";
      
      public static const BUFFER_TIME_PROGRESS:String = "bufferTimeProgress";
      
      protected var m_progress:Number;
      
      public function BufferTimeEvent(param1:String, param2:Number, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.m_progress = param2;
      }
      
      public function get progress() : Number
      {
         return this.m_progress;
      }
      
      override public function clone() : Event
      {
         return new BufferTimeEvent(this.type,this.progress,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("BufferTimeEvent","type","progress","bubbles","cancelable");
      }
   }
}

