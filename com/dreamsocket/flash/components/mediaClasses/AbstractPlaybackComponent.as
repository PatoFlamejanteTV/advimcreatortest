package com.dreamsocket.flash.components.mediaClasses
{
   import com.dreamsocket.data.IRange;
   import com.dreamsocket.data.Range;
   import com.dreamsocket.events.BitrateChangeEvent;
   import com.dreamsocket.events.BufferTimeEvent;
   import com.dreamsocket.events.ConnectionEvent;
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.NetInfoEvent;
   import com.dreamsocket.events.PlayEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import com.dreamsocket.events.VolumeEvent;
   import com.dreamsocket.flash.components.core.FlashUIComponent;
   import com.dreamsocket.formatters.TimeFormatter;
   import com.dreamsocket.layout.HorizontalAlign;
   import com.dreamsocket.layout.VerticalAlign;
   import com.dreamsocket.media.IAudible;
   import com.dreamsocket.media.IMediaObject;
   import com.dreamsocket.media.IMediaSource;
   import com.dreamsocket.media.IMediaSourceSelector;
   import com.dreamsocket.media.IMediaView;
   import com.dreamsocket.media.IPlayback;
   import com.dreamsocket.media.MediaObject;
   import com.dreamsocket.media.MediaSource;
   import com.dreamsocket.media.MediaSourceSelector;
   import com.dreamsocket.media.MediaState;
   import com.dreamsocket.media.ScaleMode;
   import com.dreamsocket.media.VolumeControl;
   
   public class AbstractPlaybackComponent extends FlashUIComponent implements IPlayback, IAudible
   {
      
      public static var defaultSourceSelector:IMediaSourceSelector = new MediaSourceSelector();
      
      protected var m_hAlign:String;
      
      protected var m_invalidSource:Boolean;
      
      protected var m_scaleMode:String;
      
      protected var m_vAlign:String;
      
      protected var m_volumeControl:VolumeControl;
      
      protected var m_autoPlay:Boolean;
      
      protected var m_autoRewind:Boolean;
      
      protected var m_bufferTimePreferred:Number;
      
      protected var m_bytesDownloaded:Range;
      
      protected var m_currState:String;
      
      protected var m_duration:Number;
      
      protected var m_media:IMediaObject;
      
      protected var m_playPaused:Boolean;
      
      protected var m_prevState:String;
      
      protected var m_sourceSelector:IMediaSourceSelector;
      
      protected var m_timeDownloaded:Range;
      
      protected var m_timeSeekable:Range;
      
      protected var m_sourceURL:String;
      
      protected var m_playback:IPlayback;
      
      protected var ui_view:IMediaView;
      
      public function AbstractPlaybackComponent()
      {
         super();
         var _loc1_:Array = [TimeFormatter];
         this.m_hAlign = HorizontalAlign.CENTER;
         this.m_scaleMode = ScaleMode.UNIFORM;
         this.m_vAlign = VerticalAlign.MIDDLE;
         this.m_volumeControl = new VolumeControl();
         this.m_volumeControl.addEventListener(VolumeEvent.VOLUME_CHANGED,this.dispatchEvent);
         this.m_volumeControl.addEventListener(VolumeEvent.VOLUME_MUTED,this.dispatchEvent);
         this.m_volumeControl.addEventListener(VolumeEvent.VOLUME_UNMUTED,this.dispatchEvent);
         this.m_autoPlay = true;
         this.m_autoRewind = false;
         this.m_bufferTimePreferred = 5;
         this.m_bytesDownloaded = new Range(0,0);
         this.m_currState = MediaState.CLOSED;
         this.m_duration = 0;
         this.m_media = new MediaObject();
         this.m_playPaused = !this.autoPlay;
         this.m_prevState = MediaState.CLOSED;
         this.m_sourceSelector = defaultSourceSelector;
         this.m_timeDownloaded = new Range(0,0);
         this.m_timeSeekable = new Range(0,0);
      }
      
      public function get autoPlay() : Boolean
      {
         return this.m_autoPlay;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
         this.m_autoPlay = param1;
         if(this.m_playback != null)
         {
            this.m_playback.autoPlay = param1;
         }
      }
      
      public function get autoRewind() : Boolean
      {
         return this.m_autoRewind;
      }
      
      public function set autoRewind(param1:Boolean) : void
      {
         this.m_autoRewind = param1;
         if(this.m_playback != null)
         {
            this.m_playback.autoRewind = param1;
         }
      }
      
      public function get buffering() : Boolean
      {
         return this.m_playback == null ? false : this.m_playback.buffering;
      }
      
      public function get bufferTimePreferred() : Number
      {
         return this.m_bufferTimePreferred;
      }
      
      public function set bufferTimePreferred(param1:Number) : void
      {
         this.m_bufferTimePreferred = param1;
         if(this.m_playback != null)
         {
            this.m_playback.bufferTimePreferred = param1;
         }
      }
      
      public function get bufferTimeRemaining() : Number
      {
         return this.m_playback == null ? 0 : this.m_playback.bufferTimeRemaining;
      }
      
      public function get bytesTotal() : uint
      {
         return this.m_playback == null ? 0 : this.m_playback.bytesTotal;
      }
      
      public function get bytesDownloaded() : IRange
      {
         return this.m_bytesDownloaded;
      }
      
      public function get currentTime() : Number
      {
         return this.m_playback == null ? 0 : this.m_playback.currentTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
         if(this.m_playback != null)
         {
            this.m_playback.currentTime = param1;
         }
      }
      
      public function get downloading() : Boolean
      {
         return this.m_playback == null ? false : this.m_playback.downloading;
      }
      
      public function get duration() : Number
      {
         return this.m_duration;
      }
      
      public function get horizontalAlign() : String
      {
         return this.m_hAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this.isLivePreview())
         {
            return;
         }
         if(param1 != this.m_hAlign)
         {
            this.m_hAlign = param1;
            this.invalidateDisplayList();
         }
      }
      
      public function get media() : IMediaObject
      {
         return this.m_media;
      }
      
      public function set media(param1:IMediaObject) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:IMediaSource = this.m_sourceSelector.selectSource(param1);
         if(_loc2_ == null || _loc2_.url == null)
         {
            return;
         }
         if(this.media == null || _loc2_.url != this.m_sourceURL)
         {
            this.close();
            this.m_duration = 0;
            this.m_playPaused = !this.autoPlay;
            this.m_media = param1;
            this.m_sourceURL = _loc2_.url;
            this.m_invalidSource = true;
            this.invalidateProperties();
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
         }
         else if(_loc2_.url == this.m_sourceURL && this.state == MediaState.CLOSED)
         {
            this.load();
         }
      }
      
      public function get paused() : Boolean
      {
         return this.m_playback != null ? this.m_playback.paused : this.m_playPaused;
      }
      
      public function get playback() : IPlayback
      {
         return this.m_playback;
      }
      
      public function get playbackType() : String
      {
         return null;
      }
      
      public function get scaleMode() : String
      {
         return this.m_scaleMode;
      }
      
      public function set scaleMode(param1:String) : void
      {
         if(param1 != this.m_scaleMode)
         {
            this.m_scaleMode = param1;
            this.invalidateDisplayList();
         }
      }
      
      public function set sourceSelector(param1:IMediaSourceSelector) : void
      {
         this.m_sourceSelector = param1;
      }
      
      public function get state() : String
      {
         return this.m_playback == null ? this.m_currState : this.m_playback.state;
      }
      
      public function get timeDownloaded() : IRange
      {
         return this.m_timeDownloaded;
      }
      
      public function get timeSeekable() : IRange
      {
         return this.m_timeSeekable;
      }
      
      public function get url() : String
      {
         return this.m_sourceURL;
      }
      
      public function set url(param1:String) : void
      {
         if(this.isLivePreview() || param1 == null)
         {
            return;
         }
         if(param1 == this.m_sourceURL)
         {
            if(this.state == MediaState.CLOSED && !this.m_invalidSource)
            {
               this.load();
            }
         }
         else
         {
            this.media = new MediaObject(new MediaSource(param1),null,param1);
         }
      }
      
      public function get verticalAlign() : String
      {
         return this.m_vAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this.isLivePreview())
         {
            return;
         }
         if(param1 != this.m_vAlign)
         {
            this.m_vAlign = param1;
            this.invalidateDisplayList();
         }
      }
      
      public function get view() : IMediaView
      {
         return this.ui_view;
      }
      
      public function get volume() : Number
      {
         return this.m_volumeControl.volume;
      }
      
      public function set volume(param1:Number) : void
      {
         this.m_volumeControl.volume = param1;
      }
      
      public function get muted() : Boolean
      {
         return this.m_volumeControl.muted;
      }
      
      public function set muted(param1:Boolean) : void
      {
         this.m_volumeControl.muted = param1;
      }
      
      public function close() : void
      {
         if(this.state == MediaState.CLOSED || this.state == MediaState.ERROR)
         {
            return;
         }
         if(this.m_playback != null)
         {
            this.m_playback.close();
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.close();
         this.m_media = new MediaObject();
         this.m_sourceURL = null;
         if(this.m_playback != null)
         {
            this.m_playback.destroy();
         }
      }
      
      public function load() : void
      {
         if(this.m_playback != null)
         {
            this.m_playback.load();
         }
      }
      
      public function pause() : void
      {
         this.m_playPaused = true;
         if(this.m_playback != null)
         {
            this.m_playback.pause();
         }
      }
      
      public function play() : void
      {
         this.m_playPaused = false;
         if(this.m_playback != null)
         {
            this.m_playback.play();
         }
      }
      
      public function stop() : void
      {
         if(this.m_playback != null)
         {
            this.m_playback.stop();
         }
      }
      
      protected function configurePlayback() : void
      {
         this.m_playback.addEventListener(BitrateChangeEvent.BITRATE_CHANGED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(BufferTimeEvent.BUFFER_TIME_STARTED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(BufferTimeEvent.BUFFER_TIME_PROGRESS,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(BufferTimeEvent.BUFFER_TIME_STOPPED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(ConnectionEvent.CONNECTION_CLOSED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(ConnectionEvent.CONNECTION_REQUESTED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(ConnectionEvent.CONNECTION_OPENED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(DownloadEvent.DOWNLOAD_STARTED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(DownloadEvent.DOWNLOAD_PROGRESS,this.onDownloadProgress,false,0,true);
         this.m_playback.addEventListener(DownloadEvent.DOWNLOAD_STOPPED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(MediaRequestEvent.MEDIA_REQUEST_CLOSED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(MediaRequestEvent.MEDIA_REQUEST_LOADING,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(MediaRequestEvent.MEDIA_REQUEST_OPENING,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(MediaRequestEvent.MEDIA_REQUEST_READY,this.onMediaReady,false,0,true);
         this.m_playback.addEventListener(NetInfoEvent.NET_INFO_CUE_POINT,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(NetInfoEvent.NET_INFO_IMAGE_DATA,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(NetInfoEvent.NET_INFO_PLAY_STATUS,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(NetInfoEvent.NET_INFO_TEXT_DATA,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(NetInfoEvent.NET_INFO_XMP_DATA,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(PlayEvent.PLAY_ENDED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(PlayEvent.PLAY_PAUSED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(PlayEvent.PLAY_RESUMED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(PlayEvent.PLAY_STARTED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(PlayEvent.PLAY_STOPPED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(StateChangeEvent.STATE_CHANGED,this.onStateChanged,false,0,true);
         this.m_playback.addEventListener(TimeEvent.TIME_DURATION_CHANGED,this.onTimeDurationChanged,false,0,true);
         this.m_playback.addEventListener(TimeEvent.TIME_POSITION_CHANGED,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(TimeEvent.TIME_SEEKABLE_CHANGED,this.onTimeSeekableChanged,false,0,true);
         this.m_playback.addEventListener(MediaExceptionEvent.MEDIA_ASYNC_EXCEPTION,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(MediaExceptionEvent.MEDIA_IO_EXCEPTION,this.dispatchEvent,false,0,true);
         this.m_playback.addEventListener(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,this.dispatchEvent,false,0,true);
         this.m_playback.autoPlay = this.autoPlay;
         this.m_playback.autoRewind = this.autoRewind;
         this.m_playback.bufferTimePreferred = this.m_bufferTimePreferred;
      }
      
      protected function onDownloadProgress(param1:DownloadEvent) : void
      {
         this.m_bytesDownloaded.start = this.m_playback.bytesDownloaded.start;
         this.m_bytesDownloaded.end = this.m_playback.bytesDownloaded.end;
         this.m_timeDownloaded.start = this.m_playback.timeDownloaded.start;
         this.m_timeDownloaded.end = this.m_playback.timeDownloaded.end;
         this.dispatchEvent(param1);
      }
      
      protected function onMediaReady(param1:MediaRequestEvent) : void
      {
         this.invalidateDisplayList();
         this.validateDisplayList();
         this.dispatchEvent(param1);
      }
      
      protected function onStateChanged(param1:StateChangeEvent) : void
      {
         if(param1.newState == this.m_currState)
         {
            return;
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

