package com.dreamsocket.services.events
{
   import flash.events.Event;
   
   public class FaultEvent extends Event
   {
      
      public static const FAULT:String = "fault";
      
      protected var m_fault:Object;
      
      public function FaultEvent(param1:String, param2:Boolean, param3:Object)
      {
         super(param1,param2);
         this.m_fault = param3;
      }
      
      public function get fault() : Object
      {
         return this.m_fault;
      }
      
      override public function clone() : Event
      {
         return new FaultEvent(this.type,this.bubbles,this.m_fault);
      }
      
      override public function toString() : String
      {
         return this.formatToString("FaultEvent","type","fault","bubbles","eventPhase");
      }
   }
}

