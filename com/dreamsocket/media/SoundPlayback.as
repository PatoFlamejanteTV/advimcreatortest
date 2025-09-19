package com.dreamsocket.media
{
   import com.dreamsocket.data.IRange;
   import com.dreamsocket.data.Range;
   import com.dreamsocket.events.BufferTimeEvent;
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.NetInfoEvent;
   import com.dreamsocket.events.PlayEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundLoaderContext;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   
   public class SoundPlayback extends EventDispatcher implements IPlayback
   {
      
      public static var defaultSourceSelector:IMediaSourceSelector = new MediaSourceSelector();
      
      protected static const k_MONITOR_LOAD_INTERVAL:uint = 75;
      
      protected static const k_MONITOR_PLAY_INTERVAL:Number = 75;
      
      protected var m_snd:Sound;
      
      protected var m_sndTransform:SoundTransform;
      
      protected var m_channel:SoundChannel;
      
      protected var m_autoPlay:Boolean;
      
      protected var m_autoRewind:Boolean;
      
      protected var m_buffering:Boolean;
      
      protected var m_bufferMonitor:Timer;
      
      protected var m_bufferTimePreferred:Number;
      
      protected var m_bytesTotal:int;
      
      protected var m_bytesDownloaded:Range;
      
      protected var m_currState:String;
      
      protected var m_currTime:Number;
      
      protected var m_downloadComplete:Boolean;
      
      protected var m_downloading:Boolean;
      
      protected var m_duration:Number;
      
      protected var m_lastBufferLen:Number;
      
      protected var m_ready:Boolean;
      
      protected var m_media:IMediaObject;
      
      protected var m_metadata:Object;
      
      protected var m_playMonitor:Timer;
      
      protected var m_playPaused:Boolean;
      
      protected var m_playStarted:Boolean;
      
      protected var m_prevState:String;
      
      protected var m_sourceSelector:IMediaSourceSelector;
      
      protected var m_timeDownloaded:Range;
      
      protected var m_timeSeekable:Range;
      
      protected var m_sourceURL:String;
      
      public function SoundPlayback()
      {
         super();
         this.m_autoPlay = true;
         this.m_autoRewind = false;
         this.m_bufferTimePreferred = 5;
         this.m_bytesDownloaded = new Range(0,0);
         this.m_bytesTotal = 0;
         this.m_currState = MediaState.CLOSED;
         this.m_currTime = 0;
         this.m_downloadComplete = false;
         this.m_duration = 0;
         this.m_lastBufferLen = 0;
         this.m_ready = false;
         this.m_media = new MediaObject();
         this.m_playPaused = !this.m_autoPlay;
         this.m_playStarted = false;
         this.m_prevState = MediaState.CLOSED;
         this.m_timeDownloaded = new Range(0,0);
         this.m_timeSeekable = new Range(0,0);
         this.m_snd = new Sound();
         this.m_snd.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
         this.m_snd.addEventListener(Event.ID3,this.onID3,false,0,true);
         this.m_snd.addEventListener(Event.COMPLETE,this.onSoundLoad,false,0,true);
         this.m_sndTransform = new SoundTransform();
         this.m_bufferMonitor = new Timer(SoundPlayback.k_MONITOR_PLAY_INTERVAL);
         this.m_bufferMonitor.addEventListener(TimerEvent.TIMER,this.onMonitorBuffer,false,0,true);
         this.m_playMonitor = new Timer(SoundPlayback.k_MONITOR_PLAY_INTERVAL);
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
         return this.m_buffering;
      }
      
      public function get bufferTimeRemaining() : Number
      {
         return (this.m_snd.length - this.m_currTime * 1000) / 1000;
      }
      
      public function set bufferTimePreferred(param1:Number) : void
      {
         this.m_bufferTimePreferred = param1;
      }
      
      public function get bufferTimePreferred() : Number
      {
         return this.m_bufferTimePreferred;
      }
      
      public function get bytesDownloaded() : IRange
      {
         return this.m_bytesDownloaded;
      }
      
      public function get bytesTotal() : uint
      {
         return this.m_bytesTotal;
      }
      
      public function get currentTime() : Number
      {
         return this.m_currTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
         var _loc2_:Number = Math.max(0,Math.min(this.m_snd.length / 1000,param1));
         if(_loc2_ == this.m_currTime || _loc2_ > this.m_snd.length)
         {
            return;
         }
         switch(this.m_currState)
         {
            case MediaState.PLAYING:
               this.doSeek(_loc2_);
               break;
            case MediaState.BUFFERING:
            case MediaState.ENDED:
            case MediaState.PAUSED:
            case MediaState.STOPPED:
               this.m_currTime = _loc2_;
         }
         if(this.m_currState == MediaState.STOPPED || this.m_currState == MediaState.ENDED)
         {
            this.setState(MediaState.PAUSED);
         }
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
            this.m_metadata = null;
            this.m_playPaused = !this.autoPlay;
            this.m_sourceURL = _loc2_.url;
            if(_loc3_)
            {
               this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
            }
         }
         this.load();
      }
      
      public function set sourceSelector(param1:IMediaSourceSelector) : void
      {
         this.m_sourceSelector = param1;
      }
      
      public function get metadata() : Object
      {
         return this.m_metadata;
      }
      
      public function get paused() : Boolean
      {
         return this.m_playPaused;
      }
      
      public function get state() : String
      {
         return this.m_currState;
      }
      
      public function get soundTransform() : SoundTransform
      {
         return this.m_sndTransform;
      }
      
      public function set soundTransform(param1:SoundTransform) : void
      {
         this.m_sndTransform = param1;
         if(this.m_channel != null)
         {
            this.m_channel.soundTransform = this.m_sndTransform;
         }
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
         var _loc2_:IMediaObject = this.media;
         if(param1 != null && param1 != this.m_sourceURL)
         {
            _loc2_ = new MediaObject(new MediaSource(param1),null,param1);
         }
         this.media = _loc2_;
      }
      
      public function close() : void
      {
         if(this.m_currState == MediaState.CLOSED || this.m_currState == MediaState.ERROR)
         {
            return;
         }
         this.stopPlay();
         this.stopDownload();
         this.m_playPaused = !this.autoPlay;
         this.m_playStarted = false;
         this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_CLOSED));
         this.setState(MediaState.CLOSED);
      }
      
      public function destroy() : void
      {
         this.close();
         this.m_duration = 0;
         this.m_media = new MediaObject();
         this.m_metadata = null;
      }
      
      public function load() : void
      {
         if(!this.m_downloading && !this.m_downloadComplete && this.m_sourceURL != null)
         {
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_OPENING));
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_LOADING));
            this.m_bufferMonitor.start();
            this.setState(MediaState.LOADING);
            try
            {
               this.m_snd.load(new URLRequest(this.m_sourceURL),new SoundLoaderContext(500));
            }
            catch(e:Error)
            {
               if(e is SecurityError)
               {
                  this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,e));
                  this.setState(MediaState.ERROR);
               }
               else if(e is IOError)
               {
                  this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_IO_EXCEPTION,e));
                  this.setState(MediaState.ERROR);
               }
            }
         }
      }
      
      public function pause() : void
      {
         this.m_playPaused = true;
         this.m_playMonitor.reset();
         this.m_playMonitor.stop();
         if(this.m_channel != null)
         {
            this.m_channel.stop();
         }
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
         var _loc1_:Boolean = this.m_currState == MediaState.PAUSED || this.m_currState == MediaState.ENDED;
         this.m_playPaused = false;
         if(this.m_currState == MediaState.STOPPED || this.m_currState == MediaState.CLOSED)
         {
            if(this.m_sourceURL != null && !this.m_downloadComplete && !this.m_downloading)
            {
               this.load();
            }
            else if(this.m_downloadComplete || this.m_downloading)
            {
               _loc1_ = true;
            }
         }
         if(_loc1_)
         {
            if(!this.buffering)
            {
               if(this.m_currState == MediaState.ENDED)
               {
                  this.doSeek(0);
               }
               else
               {
                  this.doSeek(this.currentTime);
               }
            }
            else
            {
               this.setState(MediaState.BUFFERING);
            }
            if(this.m_playStarted)
            {
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_RESUMED));
            }
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
      
      protected function doSeek(param1:Number) : void
      {
         var _loc2_:Number = this.m_downloading ? Math.max(0,this.m_snd.length - 1000) : this.m_duration * 1000;
         var _loc3_:Number = Math.min(_loc2_,param1 * 1000);
         if(this.m_buffering)
         {
            return;
         }
         if(this.m_channel != null)
         {
            this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.onPlayComplete);
            this.m_channel.stop();
         }
         this.m_channel = this.m_snd.play(_loc3_);
         this.m_channel.addEventListener(Event.SOUND_COMPLETE,this.onPlayComplete,false,0,true);
         this.m_channel.soundTransform = this.m_sndTransform;
      }
      
      protected function processBuffer() : void
      {
         var _loc1_:Number = this.bufferTimePreferred;
         var _loc2_:Number = this.bufferTimeRemaining;
         var _loc3_:Boolean = _loc2_ >= _loc1_ || this.m_downloadComplete;
         var _loc4_:Boolean = _loc2_ < 1 || !this.m_ready && !_loc3_;
         if((_loc4_) && !this.m_buffering)
         {
            this.setBuffering(true,0);
            if(!this.m_playPaused)
            {
               this.setState(MediaState.BUFFERING);
               if(this.m_channel != null)
               {
                  this.m_channel.stop();
               }
            }
         }
         else if((_loc3_ || this.m_downloadComplete) && this.m_buffering)
         {
            this.setBuffering(false,1);
            this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,1));
            if(!this.m_playPaused)
            {
               this.doSeek(this.m_currTime);
               this.setState(MediaState.PLAYING);
            }
         }
         if(this.m_lastBufferLen != _loc2_ && this.buffering)
         {
            this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,_loc2_ / this.bufferTimePreferred));
         }
         this.m_lastBufferLen = _loc2_;
      }
      
      protected function processLoad(param1:Boolean = false) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:Number = this.m_snd.bytesLoaded;
         var _loc3_:Number = this.m_snd.bytesTotal;
         var _loc4_:Number = _loc2_ / _loc3_;
         if(!isNaN(_loc4_) && _loc4_ > 0 && this.m_bytesDownloaded.end != _loc2_)
         {
            _loc6_ = this.m_duration;
            _loc7_ = this.m_snd.length / 1000;
            this.m_downloadComplete = _loc4_ == 1;
            this.processBuffer();
            this.setDownloading(true,_loc4_);
            if(param1)
            {
               _loc6_ = _loc7_;
            }
            else
            {
               _loc5_ = Math.round(_loc3_ / (_loc2_ / this.m_snd.length) / 1000);
               if(_loc5_ != this.m_duration && Math.abs(_loc5_ - this.m_duration) > 2)
               {
                  _loc6_ = _loc5_;
               }
            }
            if(_loc6_ != this.m_duration)
            {
               this.m_duration = _loc6_;
               this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
            }
            if(this.m_timeDownloaded.end != _loc7_)
            {
               this.m_timeDownloaded.end = _loc7_;
               this.m_timeSeekable.end = _loc7_;
               this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
            }
            this.m_bytesTotal = _loc3_;
            this.m_bytesDownloaded.end = _loc2_;
            this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,_loc4_));
            if(!this.m_ready)
            {
               this.m_ready = true;
               this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_READY));
               if(!this.m_playPaused)
               {
                  this.m_playMonitor.start();
                  this.doSeek(0);
               }
               else
               {
                  this.stopPlay();
                  this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_STOPPED));
                  this.setState(MediaState.STOPPED);
               }
            }
            if(param1)
            {
               this.processBuffer();
               this.setBuffering(false,_loc4_);
               this.setDownloading(false,_loc4_);
               this.m_bufferMonitor.stop();
            }
         }
      }
      
      protected function setBuffering(param1:Boolean, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         if(param1 != this.m_buffering)
         {
            _loc3_ = isNaN(param2) ? 0 : Math.min(1,param2);
            this.m_buffering = param1;
            this.dispatchEvent(new BufferTimeEvent(param1 ? BufferTimeEvent.BUFFER_TIME_STARTED : BufferTimeEvent.BUFFER_TIME_STOPPED,_loc3_));
         }
      }
      
      protected function setDownloading(param1:Boolean, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         if(param1 != this.m_downloading)
         {
            _loc3_ = isNaN(param2) ? 0 : param2;
            this.m_downloading = param1;
            this.dispatchEvent(new DownloadEvent(param1 ? DownloadEvent.DOWNLOAD_STARTED : DownloadEvent.DOWNLOAD_STOPPED,_loc3_));
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
         var pct:Number = NaN;
         this.m_bufferMonitor.stop();
         if(this.m_downloadComplete || this.m_downloading)
         {
            pct = this.m_bytesDownloaded.end / this.m_bytesTotal;
            this.setBuffering(false,pct);
            this.setDownloading(false,pct);
            this.m_ready = false;
            this.m_bytesTotal = 0;
            this.m_bytesDownloaded.end = 0;
            this.m_downloadComplete = false;
            this.m_lastBufferLen = 0;
            this.m_timeDownloaded.end = 0;
            this.m_timeSeekable.end = 0;
            this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,0));
            this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,0,0));
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
         }
         try
         {
            if(this.m_channel != null)
            {
               this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.onPlayComplete);
               this.m_channel.stop();
               this.m_channel = null;
            }
            this.m_snd.removeEventListener(Event.COMPLETE,this.onSoundLoad);
            this.m_snd.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.m_snd.removeEventListener(Event.ID3,this.onID3);
            this.m_snd.close();
         }
         catch(p_e:Error)
         {
         }
         this.m_snd = new Sound();
         this.m_snd.addEventListener(Event.COMPLETE,this.onSoundLoad,false,0,true);
         this.m_snd.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
         this.m_snd.addEventListener(Event.ID3,this.onID3,false,0,true);
      }
      
      protected function stopPlay() : void
      {
         this.m_playMonitor.reset();
         this.m_playMonitor.stop();
         this.m_playPaused = true;
         if(this.m_channel != null)
         {
            this.m_channel.stop();
         }
         if(this.m_currTime != 0)
         {
            this.m_currTime = 0;
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
         }
      }
      
      protected function onID3(param1:Event) : void
      {
         var p_evt:Event = param1;
         if(this.m_metadata == null)
         {
            try
            {
               this.m_metadata = this.m_snd.id3;
               this.dispatchEvent(new NetInfoEvent(NetInfoEvent.NET_INFO_META_DATA,this.m_metadata));
            }
            catch(e:Error)
            {
               this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,e));
            }
         }
      }
      
      protected function onIOError(param1:IOErrorEvent) : void
      {
         this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_IO_EXCEPTION,new IOError(param1.text)));
         this.setState(MediaState.ERROR);
      }
      
      protected function onMonitorBuffer(param1:TimerEvent) : void
      {
         this.processLoad();
      }
      
      protected function onMonitorPlay(param1:TimerEvent) : void
      {
         var _loc2_:Number = this.m_channel != null ? this.m_channel.position / 1000 : 0;
         if(this.m_currTime != _loc2_ && !isNaN(_loc2_) && !this.m_buffering)
         {
            this.m_currTime = _loc2_;
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
            if(!this.m_playStarted)
            {
               this.m_playStarted = true;
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_STARTED));
            }
            this.setState(MediaState.PLAYING);
         }
      }
      
      protected function onPlayComplete(param1:Event) : void
      {
         this.m_currTime = this.m_snd.length / 1000;
         this.m_playMonitor.reset();
         this.m_playMonitor.stop();
         this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_ENDED));
         if(this.m_autoRewind)
         {
            this.stop();
         }
         else
         {
            this.m_playPaused = true;
            this.setState(MediaState.ENDED);
         }
      }
      
      protected function onSoundLoad(param1:Event) : void
      {
         this.processLoad(true);
      }
   }
}

