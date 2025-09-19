package com.dreamsocket.media
{
   import flash.net.NetConnection;
   import flash.net.NetStream;
   
   public interface INSPlayback extends IPlayback
   {
      
      function get netConnection() : NetConnection;
      
      function get netStream() : NetStream;
   }
}

