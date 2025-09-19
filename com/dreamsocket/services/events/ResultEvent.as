package com.dreamsocket.services.events
{
   import flash.events.Event;
   
   public class ResultEvent extends Event
   {
      
      public static const RESULT:String = "result";
      
      protected var m_result:Object;
      
      public function ResultEvent(param1:String, param2:Boolean, param3:Object)
      {
         super(param1,param2);
         this.m_result = param3;
      }
      
      public function get result() : Object
      {
         return this.m_result;
      }
      
      override public function clone() : Event
      {
         return new ResultEvent(this.type,this.bubbles,this.m_result);
      }
      
      override public function toString() : String
      {
         return this.formatToString("ResultEvent","type","bubbles","eventPhase");
      }
   }
}

