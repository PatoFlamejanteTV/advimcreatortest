package com.dreamsocket.services
{
   public class MultiResponder implements IResponder
   {
      
      private var m_responders:Array;
      
      public function MultiResponder()
      {
         super();
         this.m_responders = [];
      }
      
      public function get responders() : Array
      {
         return this.m_responders;
      }
      
      public function addResponder(param1:IResponder) : void
      {
         if(!this.hasResponder(param1))
         {
            this.m_responders.push(param1);
         }
      }
      
      public function hasResponder(param1:IResponder) : Boolean
      {
         var _loc2_:int = int(this.m_responders.length);
         while(_loc2_--)
         {
            if(this.m_responders[_loc2_] == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function result(param1:Object) : void
      {
         var _loc2_:int = int(this.m_responders.length);
         while(_loc2_--)
         {
            this.m_responders[_loc2_].result(param1);
         }
      }
      
      public function fault(param1:Object) : void
      {
         var _loc2_:int = int(this.m_responders.length);
         while(_loc2_--)
         {
            this.m_responders[_loc2_].fault(param1);
         }
      }
   }
}

