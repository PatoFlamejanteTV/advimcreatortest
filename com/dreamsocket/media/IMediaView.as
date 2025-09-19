package com.dreamsocket.media
{
   import flash.geom.Rectangle;
   
   public interface IMediaView
   {
      
      function get containerRect() : Rectangle;
      
      function get contentRect() : Rectangle;
   }
}

