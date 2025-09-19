package com.dreamsocket.media
{
   public interface IMediaSource
   {
      
      function get base() : String;
      
      function set base(param1:String) : void;
      
      function get duration() : Number;
      
      function set duration(param1:Number) : void;
      
      function get playback() : String;
      
      function set playback(param1:String) : void;
      
      function get url() : String;
      
      function set url(param1:String) : void;
   }
}

