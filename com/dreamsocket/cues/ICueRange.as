package com.dreamsocket.cues
{
   import com.dreamsocket.data.IRange;
   
   public interface ICueRange extends IRange
   {
      
      function get className() : String;
      
      function get enterEventType() : String;
      
      function get exitEventType() : String;
      
      function get ID() : Object;
      
      function compareValues(param1:Number, param2:Number) : Number;
      
      function containsValue(param1:Number) : Boolean;
   }
}

