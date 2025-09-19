package com.dreamsocket.data
{
   public interface IRange
   {
      
      function get start() : Number;
      
      function get end() : Number;
      
      function get length() : Number;
      
      function clone() : IRange;
      
      function toString() : String;
   }
}

