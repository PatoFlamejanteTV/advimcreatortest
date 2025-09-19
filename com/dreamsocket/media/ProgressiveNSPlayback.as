package com.dreamsocket.media
{
   import com.dreamsocket.events.BufferTimeEvent;
   import com.dreamsocket.events.ConnectionEvent;
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.NetInfoEvent;
   import com.dreamsocket.events.PlayEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import flash.media.SoundTransform;
   import flash.media.Video;
   import flash.net.NetConnection;
   
   public class ProgressiveNSPlayback extends AbstractNSPlayback
   {
      
      protected var m_nc:NetConnection;
      
      public function ProgressiveNSPlayback()
      {
         super();
         this.m_sndTransform = new SoundTransform();
         this.m_nc = new NetConnection();
         this.m_nc.connect(null);
      }
      
      override public function get netConnection() : NetConnection
      {
         return this.m_nc;
      }
      
      override public function close() : void
      {
         if(this.state == MediaState.CLOSED || this.state == MediaState.ERROR)
         {
            return;
         }
         if(this.m_playback != null)
         {
            this.m_playback.close();
         }
         this.closeStream();
      }
      
      override public function load() : void
      {
         if(this.m_playback == null && this.m_sourceURL != null)
         {
            this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_REQUESTED));
            this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_OPENED));
            this.createStream();
         }
      }
      
      protected function closeStream() : void
      {
         this.m_playPaused = !this.autoPlay;
         if(this.m_playback != null)
         {
            this.m_playback.removeEventListener(BufferTimeEvent.BUFFER_TIME_STARTED,this.dispatchEvent);
            this.m_playback.removeEventListener(BufferTimeEvent.BUFFER_TIME_PROGRESS,this.dispatchEvent);
            this.m_playback.removeEventListener(BufferTimeEvent.BUFFER_TIME_STOPPED,this.dispatchEvent);
            this.m_playback.removeEventListener(DownloadEvent.DOWNLOAD_STARTED,this.dispatchEvent);
            this.m_playback.removeEventListener(DownloadEvent.DOWNLOAD_PROGRESS,this.onDownloadProgress);
            this.m_playback.removeEventListener(DownloadEvent.DOWNLOAD_STOPPED,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_CLOSED,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_LOADING,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_OPENING,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_READY,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_CUE_POINT,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_IMAGE_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_PLAY_STATUS,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_TEXT_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_XMP_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_ENDED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_PAUSED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_RESUMED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_STARTED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_STOPPED,this.dispatchEvent);
            this.m_playback.removeEventListener(StateChangeEvent.STATE_CHANGED,this.onStateChanged);
            this.m_playback.removeEventListener(TimeEvent.TIME_DURATION_CHANGED,this.onTimeDurationChanged);
            this.m_playback.removeEventListener(TimeEvent.TIME_POSITION_CHANGED,this.dispatchEvent);
            this.m_playback.removeEventListener(TimeEvent.TIME_SEEKABLE_CHANGED,this.onTimeSeekableChanged);
            this.m_playback.removeEventListener(MediaExceptionEvent.MEDIA_ASYNC_EXCEPTION,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaExceptionEvent.MEDIA_IO_EXCEPTION,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,this.dispatchEvent);
            if(this.m_videoHost.value != null)
            {
               Video(this.m_videoHost.value).attachNetStream(null);
            }
            this.m_playback = null;
         }
      }
      
      protected function createStream() : void
      {
         var _loc1_:ProgressiveNS = new ProgressiveNS(this.m_nc);
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
      
      protected function onDownloadProgress(param1:DownloadEvent) : void
      {
         this.m_bytesDownloaded.start = this.m_playback.bytesDownloaded.start;
         this.m_bytesDownloaded.end = this.m_playback.bytesDownloaded.end;
         this.m_timeDownloaded.start = this.m_playback.timeDownloaded.start;
         this.m_timeDownloaded.end = this.m_playback.timeDownloaded.end;
         this.dispatchEvent(param1);
      }
      
      protected function onStateChanged(param1:StateChangeEvent) : void
      {
         if(param1.newState == this.m_currState)
         {
            return;
         }
         if(param1.newState == MediaState.ERROR)
         {
            this.closeStream();
         }
         this.m_prevState = String(param1.oldState);
         this.m_currState = String(param1.newState);
         this.dispatchEvent(param1);
      }
      
      protected function onTimeDurationChanged(param1:TimeEvent) : void
      {
         var _loc2_:Number = Number(param1.target.duration);
         if(_loc2_ == this.m_duration)
         {
            return;
         }
         this.m_duration = _loc2_;
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
      }
      
      protected function onTimeSeekableChanged(param1:TimeEvent) : void
      {
         this.m_timeSeekable.start = this.m_playback.timeSeekable.start;
         this.m_timeSeekable.end = this.m_playback.timeSeekable.end;
         this.dispatchEvent(param1.clone());
      }
   }
}

