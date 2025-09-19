package com.dreamsocket.media
{
   public interface IAudible
   {
      
      function get volume() : Number;
      
      function set volume(param1:Number) : void;
      
      function get muted() : Boolean;
      
      function set muted(param1:Boolean) : void;
   }
}

