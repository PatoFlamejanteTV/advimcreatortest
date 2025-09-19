package com.dreamsocket.media
{
   public class MediaSourceSelector implements IMediaSourceSelector
   {
      
      protected var m_playbackResolver:IPlaybackResolver;
      
      public function MediaSourceSelector(param1:IPlaybackResolver = null)
      {
         super();
         this.m_playbackResolver = param1 == null ? new PlaybackResolver() : param1;
      }
      
      public function selectSource(param1:IMediaObject, param2:Boolean = false) : IMediaSource
      {
         if(param1 == null || param1.sources.length == 0 || param1.sources[0].url == null)
         {
            return null;
         }
         var _loc3_:IMediaSource = param1.sources[0];
         this.m_playbackResolver.resolvePlayback(_loc3_);
         return _loc3_;
      }
   }
}

