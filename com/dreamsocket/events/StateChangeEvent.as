package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class StateChangeEvent extends Event
   {
      
      public static const STATE_CHANGED:String = "stateChanged";
      
      protected var m_newState:Object;
      
      protected var m_oldState:Object;
      
      public function StateChangeEvent(param1:String, param2:Object, param3:Object, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.m_newState = param2;
         this.m_oldState = param3;
      }
      
      public function get newState() : Object
      {
         return this.m_newState;
      }
      
      public function get oldState() : Object
      {
         return this.m_oldState;
      }
      
      override public function clone() : Event
      {
         return new StateChangeEvent(this.type,this.newState,this.oldState,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("StateChangeEvent","type","newState","oldState","bubbles","cancelable");
      }
   }
}

