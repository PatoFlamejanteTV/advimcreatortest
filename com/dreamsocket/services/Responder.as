package com.dreamsocket.services
{
   public class Responder implements IResponder
   {
      
      private var m_fault:Function;
      
      private var m_result:Function;
      
      public function Responder(param1:Function, param2:Function)
      {
         super();
         this.m_result = param1;
         this.m_fault = param2;
      }
      
      public function fault(param1:Object) : void
      {
         this.m_fault(param1);
      }
      
      public function result(param1:Object) : void
      {
         this.m_result(param1);
      }
   }
}

