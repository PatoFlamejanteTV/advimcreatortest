package com.cartoonnetwork.videoplayers.data
{
   import com.dreamsocket.media.MediaObject;
   import com.dreamsocket.media.MediaSource;
   
   public class CNMediaObject extends MediaObject
   {
      
      protected var m_context:MediaContext;
      
      public function CNMediaObject(param1:String = null)
      {
         super(new MediaSource(param1));
         this.context = new MediaContext();
      }
      
      public function get context() : MediaContext
      {
         return this.m_context;
      }
      
      public function set context(param1:MediaContext) : void
      {
         this.m_context = param1;
      }
   }
}

