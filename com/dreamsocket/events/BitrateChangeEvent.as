package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class BitrateChangeEvent extends Event
   {
      
      public static const BITRATE_CHANGED:String = "bitrateChanged";
      
      protected var m_newValue:Number;
      
      protected var m_oldValue:Number;
      
      public function BitrateChangeEvent(param1:String, param2:Number, param3:Number = 0, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.m_newValue = param2;
         this.m_oldValue = param3;
      }
      
      public function get newValue() : Number
      {
         return this.m_newValue;
      }
      
      public function get oldValue() : Number
      {
         return this.m_oldValue;
      }
      
      override public function clone() : Event
      {
         return new BitrateChangeEvent(this.type,this.newValue,this.oldValue,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("BitrateChangeEvent","type","newValue","oldValue","bubbles","cancelable");
      }
   }
}

