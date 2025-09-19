package com.dreamsocket.media
{
   import com.dreamsocket.data.IRange;
   import com.dreamsocket.data.Range;
   import com.dreamsocket.events.BufferTimeEvent;
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.PlayEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TimedImagePlayback extends MediaLoader implements IPlayback
   {
      
      public static var defaultSourceSelector:IMediaSourceSelector = new MediaSourceSelector();
      
      public static var defaultDuration:Number = 5;
      
      protected static const k_MONITOR_PLAY_INTERVAL:Number = 75;
      
      protected var m_autoRewind:Boolean;
      
      protected var m_autoPlay:Boolean;
      
      protected var m_bufferTimePreferred:Number;
      
      protected var m_bufferTimeRemaining:Number;
      
      protected var m_currState:String;
      
      protected var m_currTime:Number;
      
      protected var m_duration:Number;
      
      protected var m_media:IMediaObject;
      
      protected var m_playMonitor:Timer;
      
      protected var m_playPaused:Boolean;
      
      protected var m_playStarted:Boolean;
      
      protected var m_prevState:String;
      
      protected var m_sourceSelector:IMediaSourceSelector;
      
      protected var m_startTime:Number;
      
      protected var m_timeDownloaded:Range;
      
      protected var m_timeSeekable:Range;
      
      public function TimedImagePlayback()
      {
         super();
         this.m_autoRewind = false;
         this.m_autoPlay = true;
         this.m_bufferTimeRemaining = 0;
         this.m_bufferTimePreferred = 5;
         this.m_currState = MediaState.CLOSED;
         this.m_currTime = 0;
         this.m_duration = 0;
         this.m_media = new MediaObject(new MediaSource());
         this.m_playPaused = false;
         this.m_prevState = MediaState.CLOSED;
         this.m_playStarted = false;
         this.m_startTime = 0;
         this.m_timeSeekable = new Range(0,0);
         this.m_playMonitor = new Timer(TimedImagePlayback.k_MONITOR_PLAY_INTERVAL);
         this.m_playMonitor.addEventListener(TimerEvent.TIMER,this.onMonitorPlay,false,0,true);
      }
      
      public function get autoPlay() : Boolean
      {
         return this.m_autoPlay;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
         this.m_autoPlay = param1;
      }
      
      public function get autoRewind() : Boolean
      {
         return this.m_autoRewind;
      }
      
      public function set autoRewind(param1:Boolean) : void
      {
         this.m_autoRewind = param1;
      }
      
      public function get buffering() : Boolean
      {
         return this.m_downloading;
      }
      
      public function get bufferTimeRemaining() : Number
      {
         return this.m_bufferTimeRemaining;
      }
      
      public function get bufferTimePreferred() : Number
      {
         return this.m_bufferTimePreferred;
      }
      
      public function set bufferTimePreferred(param1:Number) : void
      {
         this.m_bufferTimePreferred = param1;
      }
      
      public function get currentTime() : Number
      {
         return this.m_currTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
         switch(this.m_currState)
         {
            case MediaState.PLAYING:
            case MediaState.BUFFERING:
            case MediaState.ENDED:
            case MediaState.PAUSED:
            case MediaState.STOPPED:
               this.seek(param1);
               if(Boolean(MediaState.STOPPED) || this.m_currState == MediaState.ENDED)
               {
                  this.setState(MediaState.PAUSED);
               }
         }
      }
      
      public function get duration() : Number
      {
         return this.m_duration;
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
            this.m_media = param1;
            this.m_playPaused = !this.autoPlay;
            this.m_sourceURL = _loc2_.url;
            this.m_sourceWidth = 0;
            this.m_sourceHeight = 0;
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
            if(!isNaN(_loc2_.duration))
            {
               this.m_duration = _loc2_.duration;
            }
            else
            {
               this.m_duration = TimedImagePlayback.defaultDuration;
            }
         }
         this.load();
      }
      
      public function get paused() : Boolean
      {
         return this.m_playPaused;
      }
      
      public function set sourceSelector(param1:IMediaSourceSelector) : void
      {
         this.m_sourceSelector = param1;
      }
      
      public function get state() : String
      {
         return this.m_currState;
      }
      
      public function get timeDownloaded() : IRange
      {
         return this.m_timeSeekable;
      }
      
      public function get timeSeekable() : IRange
      {
         return this.m_timeSeekable;
      }
      
      override public function get url() : String
      {
         return this.m_sourceURL;
      }
      
      override public function set url(param1:String) : void
      {
         var _loc2_:IMediaObject = this.media;
         if(param1 != null && param1 != this.m_sourceURL)
         {
            _loc2_ = new MediaObject(new MediaSource(param1),null,param1);
         }
         this.media = _loc2_;
      }
      
      override public function close() : void
      {
         if(this.m_currState == MediaState.CLOSED || this.m_currState == MediaState.ERROR)
         {
            return;
         }
         this.stopPlay();
         this.m_playPaused = !this.m_autoPlay;
         this.m_playStarted = false;
         this.m_timeSeekable.end = 0;
         this.m_bufferTimeRemaining = 0;
         this.stopDownload();
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
         this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,0));
         this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_CLOSED));
         this.setState(MediaState.CLOSED);
      }
      
      override public function destroy() : void
      {
         this.close();
         this.m_duration = 0;
         this.m_media = new MediaObject(new MediaSource());
         super.destroy();
      }
      
      override public function load() : void
      {
         var _loc1_:Boolean = this.m_loader == null && this.m_sourceURL != null;
         super.load();
         if(_loc1_)
         {
            this.setState(MediaState.LOADING);
         }
      }
      
      public function pause() : void
      {
         this.m_playPaused = true;
         this.m_playMonitor.reset();
         this.m_playMonitor.stop();
         switch(this.m_currState)
         {
            case MediaState.PLAYING:
            case MediaState.BUFFERING:
               this.setState(MediaState.PAUSED);
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_PAUSED));
         }
      }
      
      public function play() : void
      {
         var _loc1_:* = this.m_currState == MediaState.PAUSED;
         var _loc2_:Boolean = this.m_bytesDownloaded.end == this.m_bytesTotal && this.m_bytesTotal > 0;
         this.m_playPaused = false;
         if(this.state == MediaState.ENDED)
         {
            _loc1_ = true;
            this.seek(0);
         }
         if(this.state == MediaState.STOPPED || this.state == MediaState.CLOSED)
         {
            if(this.m_sourceURL != null && !_loc2_ && !this.m_downloading)
            {
               this.load();
            }
            else if(_loc2_)
            {
               _loc1_ = true;
            }
         }
         if(_loc1_)
         {
            if(this.m_playStarted)
            {
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_RESUMED));
            }
            this.setState(MediaState.PLAYING);
            this.m_startTime = getTimer() - this.m_currTime * 1000;
            this.m_playMonitor.start();
         }
      }
      
      public function stop() : void
      {
         switch(this.m_currState)
         {
            case MediaState.ENDED:
            case MediaState.PLAYING:
            case MediaState.PAUSED:
            case MediaState.PLAYING:
            case MediaState.BUFFERING:
               this.stopPlay();
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_STOPPED));
               this.setState(MediaState.STOPPED);
               break;
            case MediaState.LOADING:
               this.m_playPaused = true;
         }
      }
      
      protected function seek(param1:Number) : void
      {
         this.m_currTime = Math.min(this.duration,param1);
         this.m_startTime = getTimer() - this.m_currTime * 1000;
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
      }
      
      override protected function setDownloading(param1:Boolean, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         if(param1 != this.m_downloading)
         {
            _loc3_ = isNaN(param2) ? 0 : param2;
            this.m_downloading = param1;
            if(param1)
            {
               this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_STARTED,_loc3_));
               this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_STARTED,_loc3_));
            }
            else
            {
               this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_STOPPED,_loc3_));
               this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_STOPPED,_loc3_));
            }
         }
      }
      
      protected function setState(param1:String) : void
      {
         if(param1 != this.m_currState)
         {
            this.m_prevState = this.m_currState;
            this.m_currState = param1;
            this.dispatchEvent(new StateChangeEvent(StateChangeEvent.STATE_CHANGED,this.m_currState,this.m_prevState));
         }
      }
      
      protected function stopPlay() : void
      {
         this.m_playMonitor.reset();
         this.m_playMonitor.stop();
         this.m_playPaused = true;
         if(this.m_currTime != 0)
         {
            this.m_currTime = 0;
            this.m_startTime = 0;
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
         }
      }
      
      override protected function onInit(param1:Event) : void
      {
         this.m_timeSeekable.end = this.duration;
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
         super.onInit(param1);
         if(!this.m_playPaused)
         {
            this.setState(MediaState.PLAYING);
            this.m_startTime = getTimer() - this.m_currTime * 1000;
            this.m_playMonitor.start();
         }
         else
         {
            this.stopPlay();
            this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_STOPPED));
            this.setState(MediaState.STOPPED);
         }
      }
      
      override protected function onIOError(param1:IOErrorEvent) : void
      {
         super.onIOError(param1);
         this.setState(MediaState.ERROR);
      }
      
      override protected function onMonitorLoad(param1:TimerEvent) : void
      {
         var _loc2_:Loader = this.m_loader;
         if(_loc2_ == null || _loc2_.contentLoaderInfo == null)
         {
            return;
         }
         var _loc3_:int = int(_loc2_.contentLoaderInfo.bytesLoaded);
         var _loc4_:int = int(_loc2_.contentLoaderInfo.bytesTotal);
         var _loc5_:Number = _loc3_ / _loc4_;
         if(!isNaN(_loc5_) && _loc3_ > this.m_bytesDownloaded.end)
         {
            if(!this.m_downloading)
            {
               this.setDownloading(true,_loc5_);
            }
            this.m_bufferTimeRemaining = _loc5_ * this.m_bufferTimePreferred;
            this.m_bytesTotal = _loc4_;
            this.m_bytesDownloaded.end = _loc3_;
            if(_loc5_ == 1)
            {
               this.m_timeSeekable.end = this.duration;
            }
            this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,_loc5_));
            this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,_loc5_));
            if(_loc5_ == 1)
            {
               this.setDownloading(false,_loc5_);
               this.m_bufferMonitor.stop();
            }
         }
      }
      
      protected function onMonitorPlay(param1:TimerEvent) : void
      {
         var _loc2_:Number = Math.min(this.m_duration,(getTimer() - this.m_startTime) / 1000);
         if(_loc2_ != this.m_currTime)
         {
            this.m_currTime = _loc2_;
            if(!this.m_playStarted)
            {
               this.m_playStarted = true;
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_STARTED));
            }
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
         }
         if(this.m_currTime >= this.m_duration)
         {
            this.m_playMonitor.reset();
            this.m_playMonitor.stop();
            this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_ENDED));
            if(this.m_autoRewind)
            {
               this.stop();
            }
            else
            {
               this.setState(MediaState.ENDED);
            }
         }
      }
      
      override protected function onSecurityError(param1:SecurityErrorEvent) : void
      {
         super.onSecurityError(param1);
         this.setState(MediaState.ERROR);
      }
   }
}

