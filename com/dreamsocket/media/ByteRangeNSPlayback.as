package com.dreamsocket.media
{
   import com.dreamsocket.events.BufferTimeEvent;
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.NetInfoEvent;
   import com.dreamsocket.events.PlayEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import flash.media.Video;
   
   public class ByteRangeNSPlayback extends ProgressiveNSPlayback
   {
      
      public function ByteRangeNSPlayback()
      {
         super();
      }
      
      override protected function createStream() : void
      {
         var _loc1_:ByteRangeNS = new ByteRangeNS(this.m_nc);
         this.m_playback = _loc1_;
         _loc1_.addEventListener(BufferTimeEvent.BUFFER_TIME_STARTED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(BufferTimeEvent.BUFFER_TIME_PROGRESS,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(BufferTimeEvent.BUFFER_TIME_STOPPED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(DownloadEvent.DOWNLOAD_STARTED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(DownloadEvent.DOWNLOAD_PROGRESS,this.onDownloadProgress,false,0,true);
         _loc1_.addEventListener(DownloadEvent.DOWNLOAD_STOPPED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(MediaRequestEvent.MEDIA_REQUEST_CLOSED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(MediaRequestEvent.MEDIA_REQUEST_LOADING,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(MediaRequestEvent.MEDIA_REQUEST_OPENING,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(MediaRequestEvent.MEDIA_REQUEST_READY,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_CUE_POINT,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_IMAGE_DATA,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_PLAY_STATUS,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_TEXT_DATA,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_XMP_DATA,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(PlayEvent.PLAY_ENDED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(PlayEvent.PLAY_PAUSED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(PlayEvent.PLAY_RESUMED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(PlayEvent.PLAY_STARTED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(PlayEvent.PLAY_STOPPED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(StateChangeEvent.STATE_CHANGED,this.onStateChanged,false,0,true);
         _loc1_.addEventListener(TimeEvent.TIME_DURATION_CHANGED,this.onTimeDurationChanged,false,0,true);
         _loc1_.addEventListener(TimeEvent.TIME_POSITION_CHANGED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(TimeEvent.TIME_SEEKABLE_CHANGED,this.onTimeSeekableChanged,false,0,true);
         _loc1_.addEventListener(MediaExceptionEvent.MEDIA_ASYNC_EXCEPTION,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(MediaExceptionEvent.MEDIA_IO_EXCEPTION,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,this.dispatchEvent,false,0,true);
         _loc1_.autoPlay = this.autoPlay;
         _loc1_.autoRewind = this.autoRewind;
         _loc1_.bufferTimePreferred = this.m_bufferTimePreferred;
         _loc1_.soundTransform = this.m_sndTransform;
         _loc1_.url = this.m_sourceURL;
         if(this.m_videoHost.value != null)
         {
            Video(this.m_videoHost.value).attachNetStream(_loc1_);
         }
      }
   }
}

