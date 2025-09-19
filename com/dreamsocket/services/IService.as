package com.dreamsocket.services
{
   public interface IService
   {
      
      function cancel() : void;
      
      function send(param1:Object = null) : MultiResponder;
   }
}

