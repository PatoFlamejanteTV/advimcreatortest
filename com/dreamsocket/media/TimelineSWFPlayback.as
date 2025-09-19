package com.dreamsocket.media
{
   import com.dreamsocket.data.IRange;
   import com.dreamsocket.data.Range;
   import com.dreamsocket.events.BufferTimeEvent;
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.PlayEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class TimelineSWFPlayback extends AbstractMediaLoader implements IPlayback
   {
      
      public static var defaultSourceSelector:IMediaSourceSelector = new MediaSourceSelector();
      
      public static var frameRate:int = 24;
      
      protected var m_autoPlay:Boolean;
      
      protected var m_autoRewind:Boolean;
      
      protected var m_buffering:Boolean;
      
      protected var m_bufferTimePreferred:Number;
      
      protected var m_bytesDownloaded:Range;
      
      protected var m_bytesTotal:int;
      
      protected var m_initialFrameLoaded:Boolean;
      
      protected var m_currState:String;
      
      protected var m_currFrame:int;
      
      protected var m_downloadComplete:Boolean;
      
      protected var m_downloading:Boolean;
      
      protected var m_duration:Number;
      
      protected var m_height:Number;
      
      protected var m_lastBufferLen:Number;
      
      protected var m_loader:Loader;
      
      protected var m_loaderContext:LoaderContext;
      
      protected var m_media:IMediaObject;
      
      protected var m_playPaused:Boolean;
      
      protected var m_playStarted:Boolean;
      
      protected var m_prevState:String;
      
      protected var m_ready:Boolean;
      
      protected var m_sourceSelector:IMediaSourceSelector;
      
      protected var m_sourceURL:String;
      
      protected var m_timeDownloaded:Range;
      
      protected var m_width:Number;
      
      protected var ui_media:Sprite;
      
      public function TimelineSWFPlayback()
      {
         super();
         this.m_autoPlay = true;
         this.m_autoRewind = false;
         this.m_bufferTimePreferred = 5;
         this.m_bytesDownloaded = new Range(0,0);
         this.m_bytesTotal = 0;
         this.m_initialFrameLoaded = false;
         this.m_currState = MediaState.CLOSED;
         this.m_currFrame = 0;
         this.m_downloadComplete = false;
         this.m_duration = 0;
         this.m_lastBufferLen = 0;
         this.m_media = new MediaObject();
         this.m_playPaused = this.m_autoPlay;
         this.m_playStarted = false;
         this.m_prevState = MediaState.CLOSED;
         this.m_ready = false;
         this.m_sourceHeight = 0;
         this.m_sourceWidth = 0;
         this.m_timeDownloaded = new Range(0,0);
         this.m_width = 0;
         this.m_height = 0;
         this.m_loaderContext = new LoaderContext();
         this.ui_media = new Sprite();
         this.addChild(this.ui_media);
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
         return this.m_buffering;
      }
      
      public function get bufferTimeRemaining() : Number
      {
         return this.content == null ? 0 : (this.content.framesLoaded - this.content.currentFrame) / this.getFrameRate();
      }
      
      public function set bufferTimePreferred(param1:Number) : void
      {
         this.m_bufferTimePreferred = param1;
      }
      
      public function get bufferTimePreferred() : Number
      {
         return this.m_bufferTimePreferred;
      }
      
      public function get bytesTotal() : uint
      {
         return this.m_bytesTotal;
      }
      
      public function get bytesDownloaded() : IRange
      {
         return this.m_bytesDownloaded;
      }
      
      public function get content() : MovieClip
      {
         if(this.m_loader != null)
         {
            return MovieClip(this.m_loader.content);
         }
         return null;
      }
      
      public function get currentTime() : Number
      {
         return this.content == null || this.content.currentFrame == 1 ? 0 : this.content.currentFrame / this.getFrameRate();
      }
      
      public function set currentTime(param1:Number) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = this.content;
         if(_loc3_ == null)
         {
            return;
         }
         if(param1 <= 0 || isNaN(param1))
         {
            _loc2_ = 1;
         }
         else
         {
            _loc2_ = Math.min(_loc3_.framesLoaded,Math.round(param1 * this.getFrameRate()));
         }
         if(_loc2_ == _loc3_.currentFrame)
         {
            return;
         }
         if(this.m_currState == MediaState.STOPPED || this.m_currState == MediaState.ENDED)
         {
            this.setState(MediaState.PAUSED);
         }
         switch(this.m_currState)
         {
            case MediaState.PLAYING:
            case MediaState.BUFFERING:
            case MediaState.ENDED:
            case MediaState.PAUSED:
            case MediaState.STOPPED:
               if(this.m_playPaused || this.m_buffering)
               {
                  _loc3_.gotoAndStop(_loc2_);
               }
               else if(this.m_currState == MediaState.PLAYING)
               {
                  _loc3_.gotoAndPlay(_loc2_);
               }
         }
         this.m_currFrame = _loc2_;
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
      }
      
      public function get downloading() : Boolean
      {
         return this.m_downloading;
      }
      
      public function get duration() : Number
      {
         return this.m_duration;
      }
      
      override public function get height() : Number
      {
         return this.m_height;
      }
      
      override public function set height(param1:Number) : void
      {
         this.m_height = param1;
         if(this.ui_media != null && this.m_ready)
         {
            this.ui_media.height = param1;
         }
      }
      
      public function get media() : IMediaObject
      {
         return this.m_media;
      }
      
      public function set media(param1:IMediaObject) : void
      {
         var _loc3_:* = false;
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
            _loc3_ = this.m_duration != 0;
            this.close();
            this.m_duration = 0;
            this.m_media = param1;
            this.m_playPaused = !this.autoPlay;
            this.m_sourceHeight = 0;
            this.m_sourceWidth = 0;
            this.m_sourceURL = _loc2_.url;
            if(_loc3_)
            {
               this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
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
         return this.m_timeDownloaded;
      }
      
      public function get timeSeekable() : IRange
      {
         return this.m_timeDownloaded;
      }
      
      public function get url() : String
      {
         return this.m_sourceURL;
      }
      
      public function set url(param1:String) : void
      {
         var _loc2_:IMediaObject = this.media;
         if(param1 != null && param1 != this.m_sourceURL)
         {
            _loc2_ = new MediaObject(new MediaSource(param1),null,param1);
         }
         this.media = _loc2_;
      }
      
      override public function get width() : Number
      {
         return this.m_width;
      }
      
      override public function set width(param1:Number) : void
      {
         this.m_width = param1;
         if(this.ui_media != null && this.m_ready)
         {
            this.ui_media.width = param1;
         }
      }
      
      public function close() : void
      {
         if(this.m_currState == MediaState.CLOSED || this.m_currState == MediaState.ERROR)
         {
            return;
         }
         this.stopPlay();
         this.stopDownload();
         this.m_playStarted = false;
         this.m_playPaused = !this.autoPlay;
         this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_CLOSED));
         this.setState(MediaState.CLOSED);
      }
      
      public function destroy() : void
      {
         this.close();
         this.m_duration = 0;
         this.m_media = new MediaObject();
         this.m_sourceHeight = 0;
         this.m_sourceWidth = 0;
         this.m_sourceURL = null;
      }
      
      public function load() : void
      {
         if(this.m_sourceURL != null && !this.m_downloading && !this.m_downloadComplete)
         {
            this.m_loader = new Loader();
            this.m_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
            this.m_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
            this.addEventListener(Event.ENTER_FRAME,this.onMonitorBuffer,false,0,true);
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_OPENING));
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_LOADING));
            this.setState(MediaState.LOADING);
            try
            {
               this.m_loader.load(new URLRequest(this.m_sourceURL),this.m_loaderContext);
            }
            catch(e:Error)
            {
               if(e is SecurityError)
               {
                  this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,e));
                  this.setState(MediaState.ERROR);
               }
            }
            this.ui_media.addChild(this.m_loader);
         }
      }
      
      public function pause() : void
      {
         this.m_playPaused = true;
         if(this.content == null || !this.m_ready)
         {
            return;
         }
         this.removeEventListener(Event.ENTER_FRAME,this.onMonitorPlay);
         this.content.stop();
         switch(this.m_currState)
         {
            case MediaState.BUFFERING:
            case MediaState.PLAYING:
               this.setState(MediaState.PAUSED);
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_PAUSED));
         }
      }
      
      public function play() : void
      {
         var _loc1_:MovieClip = this.content;
         var _loc2_:Boolean = this.m_currState == MediaState.PAUSED || this.m_currState == MediaState.ENDED;
         this.m_playPaused = false;
         if(_loc1_ == null || !this.m_ready)
         {
            return;
         }
         if(this.m_currState == MediaState.STOPPED || this.m_currState == MediaState.CLOSED)
         {
            if(this.m_sourceURL != null && !this.m_downloadComplete && !this.m_downloading)
            {
               this.load();
            }
            else if(this.m_downloadComplete || this.m_downloading)
            {
               _loc2_ = true;
            }
         }
         if(_loc2_)
         {
            if(!this.buffering)
            {
               _loc1_.play();
               this.setState(MediaState.PLAYING);
            }
            else
            {
               this.setState(MediaState.BUFFERING);
            }
            if(this.m_playStarted)
            {
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_RESUMED));
            }
            this.addEventListener(Event.ENTER_FRAME,this.onMonitorPlay,false,0,true);
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
      
      protected function getFrameRate() : int
      {
         return this.stage == null ? TimelineSWFPlayback.frameRate : int(this.stage.frameRate);
      }
      
      protected function processBuffer() : void
      {
         var _loc1_:MovieClip = this.content;
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:Number = Math.min(this.duration - this.currentTime,this.bufferTimePreferred);
         var _loc3_:Number = this.bufferTimeRemaining;
         var _loc4_:Boolean = _loc3_ >= _loc2_ || _loc1_.totalFrames == _loc1_.framesLoaded;
         var _loc5_:* = _loc3_ < 1;
         if((_loc5_) && !this.m_buffering)
         {
            this.setBuffering(true);
            if(!this.m_playPaused && this.m_ready)
            {
               this.setState(MediaState.BUFFERING);
               _loc1_.stop();
            }
         }
         else if(_loc4_ && this.m_buffering)
         {
            this.setBuffering(false);
            this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,1));
            if(!this.m_playPaused && this.m_ready)
            {
               _loc1_.play();
               this.setState(MediaState.PLAYING);
            }
         }
         if(this.m_lastBufferLen != _loc3_ && this.buffering)
         {
            this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,_loc3_ / this.bufferTimePreferred));
         }
         this.m_lastBufferLen = _loc3_;
      }
      
      protected function processLoad() : void
      {
         if(this.m_loader == null || this.m_loader.contentLoaderInfo == null)
         {
            return;
         }
         var _loc1_:Number = this.m_loader.contentLoaderInfo.bytesLoaded;
         var _loc2_:Number = this.m_loader.contentLoaderInfo.bytesTotal;
         var _loc3_:MovieClip = this.content;
         if(isNaN(_loc1_) || _loc1_ <= 0 || _loc3_ == null || _loc1_ == this.m_bytesDownloaded.length)
         {
            return;
         }
         this.setDownloading(true);
         this.m_bytesTotal = _loc2_;
         this.m_bytesDownloaded.end = _loc1_;
         this.m_timeDownloaded.end = _loc3_.framesLoaded / this.getFrameRate();
         this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,_loc1_ / _loc2_));
         this.processBuffer();
         this.processReady();
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
         if(_loc1_ >= _loc2_)
         {
            this.m_downloadComplete = true;
            this.setBuffering(false);
            this.setDownloading(false);
            this.removeEventListener(Event.ENTER_FRAME,this.onMonitorBuffer);
            if(!this.m_playPaused)
            {
               _loc3_.play();
            }
         }
      }
      
      protected function processPlayComplete() : void
      {
         var _loc1_:MovieClip = this.content;
         this.removeEventListener(Event.ENTER_FRAME,this.onMonitorPlay);
         this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_ENDED));
         if(this.m_autoRewind)
         {
            this.stop();
         }
         else
         {
            _loc1_.stop();
            this.m_playPaused = true;
            this.setState(MediaState.ENDED);
         }
      }
      
      protected function processReady() : void
      {
         var _loc1_:MovieClip = this.content;
         if(this.m_ready)
         {
            return;
         }
         if(!this.m_initialFrameLoaded && _loc1_.framesLoaded >= 1)
         {
            _loc1_.gotoAndStop(1);
            this.m_initialFrameLoaded = true;
         }
         if(!this.m_ready && _loc1_.width > 0 && _loc1_.height > 0)
         {
            this.m_ready = true;
            this.m_sourceWidth = _loc1_.width;
            this.m_sourceHeight = _loc1_.height;
            this.ui_media.width = this.m_sourceWidth;
            this.ui_media.height = this.m_sourceHeight;
            this.m_duration = this.content.totalFrames / this.getFrameRate();
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_READY));
            if(!this.m_playPaused)
            {
               this.addEventListener(Event.ENTER_FRAME,this.onMonitorPlay,false,0,true);
               if(!this.m_buffering)
               {
                  _loc1_.play();
               }
               else
               {
                  this.setState(MediaState.BUFFERING);
               }
            }
            else
            {
               this.stopPlay();
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_STOPPED));
               this.setState(MediaState.STOPPED);
            }
         }
      }
      
      protected function setBuffering(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         if(param1 != this.m_buffering)
         {
            _loc2_ = Math.min(this.m_bufferTimePreferred,this.duration - this.currentTime) / this.bufferTimeRemaining;
            _loc2_ = isNaN(_loc2_) ? 0 : Math.min(1,_loc2_);
            this.m_buffering = param1;
            this.dispatchEvent(new BufferTimeEvent(param1 ? BufferTimeEvent.BUFFER_TIME_STARTED : BufferTimeEvent.BUFFER_TIME_STOPPED,_loc2_));
         }
      }
      
      protected function setDownloading(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         if(param1 != this.m_downloading)
         {
            _loc2_ = this.m_bytesDownloaded.end / this.m_bytesTotal;
            _loc2_ = isNaN(_loc2_) ? 0 : _loc2_;
            this.m_downloading = param1;
            this.dispatchEvent(new DownloadEvent(param1 ? DownloadEvent.DOWNLOAD_STARTED : DownloadEvent.DOWNLOAD_STOPPED,_loc2_));
         }
      }
      
      protected function setState(param1:String) : void
      {
         if(param1 != this.m_currState)
         {
            if(param1 == MediaState.ERROR)
            {
               this.stopDownload();
            }
            this.m_prevState = this.m_currState;
            this.m_currState = param1;
            this.dispatchEvent(new StateChangeEvent(StateChangeEvent.STATE_CHANGED,this.m_currState,this.m_prevState));
         }
      }
      
      protected function stopDownload() : void
      {
         var c:MovieClip = null;
         var snd:SoundTransform = null;
         this.ui_media.width = 0;
         this.ui_media.height = 0;
         this.m_width = 0;
         this.m_height = 0;
         this.removeEventListener(Event.ENTER_FRAME,this.onMonitorBuffer);
         if(this.m_loader != null)
         {
            this.m_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.m_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.ui_media.removeChild(this.m_loader);
            try
            {
               this.m_loader.close();
            }
            catch(error:*)
            {
            }
            try
            {
               c = this.content;
               snd = this.content.soundTransform;
               snd.volume = 0;
               c.stop();
               c.soundTransform = snd;
               c.destroy();
            }
            catch(error:*)
            {
            }
            try
            {
               this.m_loader.unload();
            }
            catch(e:*)
            {
            }
            this.m_loader = null;
         }
         if(this.m_downloading || this.m_downloadComplete)
         {
            this.setBuffering(false);
            this.setDownloading(false);
            this.m_bytesDownloaded.end = 0;
            this.m_bytesTotal = 0;
            this.m_initialFrameLoaded = false;
            this.m_downloadComplete = false;
            this.m_lastBufferLen = 0;
            this.m_ready = false;
            this.m_timeDownloaded.end = 0;
            this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,0));
            this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,0,0));
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
         }
      }
      
      protected function stopPlay() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onMonitorPlay);
         this.m_playPaused = true;
         if(this.m_currFrame != 1)
         {
            if(this.content != null)
            {
               this.content.gotoAndStop(1);
            }
            this.m_currFrame = 1;
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
         }
      }
      
      protected function onIOError(param1:IOErrorEvent) : void
      {
         this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_IO_EXCEPTION,new IOError(param1.text)));
         this.setState(MediaState.ERROR);
      }
      
      protected function onMonitorBuffer(param1:Event) : void
      {
         this.processLoad();
      }
      
      protected function onMonitorPlay(param1:Event) : void
      {
         var _loc2_:MovieClip = this.content;
         if(_loc2_ == null || this.m_buffering)
         {
            return;
         }
         if(this.m_currFrame != _loc2_.currentFrame)
         {
            this.m_currFrame = _loc2_.currentFrame;
            if(!this.m_playStarted)
            {
               this.m_playStarted = true;
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_STARTED));
            }
            this.setState(MediaState.PLAYING);
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
         }
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            this.processPlayComplete();
         }
      }
      
      protected function onSecurityError(param1:SecurityErrorEvent) : void
      {
         this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,new SecurityError(param1.text)));
         this.setState(MediaState.ERROR);
      }
   }
}

