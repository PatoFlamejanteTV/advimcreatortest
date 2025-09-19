package com.dreamsocket.media
{
   import flash.display.Sprite;
   
   public class AbstractMediaLoader extends Sprite
   {
      
      protected var m_sourceWidth:int;
      
      protected var m_sourceHeight:int;
      
      public function AbstractMediaLoader()
      {
         super();
      }
      
      public function get sourceWidth() : int
      {
         return this.m_sourceWidth;
      }
      
      public function get sourceHeight() : int
      {
         return this.m_sourceHeight;
      }
   }
}

