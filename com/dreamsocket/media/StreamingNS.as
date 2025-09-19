package com.dreamsocket.media
{
   import com.dreamsocket.events.BufferTimeEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.NetInfoEvent;
   import com.dreamsocket.events.PlayEvent;
   import com.dreamsocket.events.TimeEvent;
   import flash.errors.IOError;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import flash.net.Responder;
   import flash.utils.Timer;
   
   public class StreamingNS extends AbstractMediaNS
   {
      
      public static var defaultSourceSelector:IMediaSourceSelector = new MediaSourceSelector();
      
      protected static const k_MONITOR_PLAY_INTERVAL:Number = 75;
      
      protected var m_bufferFull:Boolean;
      
      protected var m_bufferTime:Number;
      
      protected var m_currBufferTime:Number;
      
      protected var m_seeking:Boolean;
      
      protected var m_sourceSelector:IMediaSourceSelector;
      
      protected var m_quickStartBufferTime:uint;
      
      protected var m_ready:Boolean;
      
      protected var m_requestOpen:Boolean;
      
      protected var m_lastBufferLen:Number;
      
      protected var m_currTime:Number;
      
      protected var m_monitor:Timer;
      
      public function StreamingNS(param1:NetConnection)
      {
         super(param1);
         this.m_buffering = false;
         this.m_currTime = 0;
         this.m_currBufferTime = 2;
         this.m_lastBufferLen = 0;
         this.m_bufferTimePreferred = 10;
         this.m_quickStartBufferTime = this.m_currBufferTime;
         this.m_requestOpen = false;
         this.m_seeking = false;
         this.m_sourceSelector = defaultSourceSelector;
         this.bufferTime = this.m_quickStartBufferTime;
         this.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false,0,true);
         this.m_clientProxy.addEventListener(NetInfoEvent.NET_INFO_CUE_POINT,this.dispatchEvent);
         this.m_clientProxy.addEventListener(NetInfoEvent.NET_INFO_META_DATA,this.onMetaData);
         this.m_clientProxy.addEventListener(NetInfoEvent.NET_INFO_IMAGE_DATA,this.dispatchEvent);
         this.m_clientProxy.addEventListener(NetInfoEvent.NET_INFO_TEXT_DATA,this.dispatchEvent);
         this.m_clientProxy.addEventListener(NetInfoEvent.NET_INFO_XMP_DATA,this.dispatchEvent);
         this.m_clientProxy.addEventListener(NetInfoEvent.NET_INFO_PLAY_STATUS,this.onPlayStatus);
         this.m_monitor = new Timer(StreamingNS.k_MONITOR_PLAY_INTERVAL);
         this.m_monitor.addEventListener(TimerEvent.TIMER,this.onMonitorStream,false,0,true);
      }
      
      override public function get currentTime() : Number
      {
         return this.m_currTime;
      }
      
      override public function get media() : IMediaObject
      {
         return this.m_media;
      }
      
      override public function set media(param1:IMediaObject) : void
      {
         var _loc4_:* = false;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:IMediaSource = this.m_sourceSelector.selectSource(param1);
         if(_loc2_ == null || _loc2_.url == null)
         {
            return;
         }
         var _loc3_:String = _loc2_.url.replace(_loc2_.base,"");
         if(this.media == null || _loc3_ != this.m_sourceURL)
         {
            _loc4_ = this.m_duration != 0;
            this.close();
            this.m_duration = 0;
            this.m_metadata = null;
            this.m_playPaused = !this.autoPlay;
            this.m_sourceWidth = 0;
            this.m_sourceHeight = 0;
            this.m_media = param1;
            this.m_sourceURL = _loc3_;
            if(_loc4_)
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
      
      override public function close() : void
      {
         if(this.m_currState == MediaState.CLOSED || this.m_currState == MediaState.ERROR)
         {
            return;
         }
         this.m_monitor.stop();
         this.bufferTime = this.m_quickStartBufferTime;
         this.m_currBufferTime = this.m_quickStartBufferTime;
         this.m_currTime = 0;
         this.m_bufferFull = false;
         this.m_lastBufferLen = 0;
         this.m_playPaused = !this.autoPlay;
         this.m_playStarted = false;
         this.m_ready = false;
         this.m_requestOpen = false;
         this.m_seeking = false;
         this.m_timeSeekable.end = 0;
         this.setBuffering(false);
         this.doBaseClose();
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
         this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,0));
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
         this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_CLOSED));
         this.setState(MediaState.CLOSED);
      }
      
      override public function destroy() : void
      {
         this.close();
         this.m_duration = 0;
         this.m_media = new MediaObject();
         this.m_metadata = null;
         this.m_sourceURL = null;
         this.m_sourceWidth = 0;
         this.m_sourceHeight = 0;
      }
      
      override public function load() : void
      {
         if(!this.m_requestOpen && this.m_sourceURL != null)
         {
            this.m_requestOpen = true;
            this.m_ready = false;
            trace("loading! " + this.m_sourceURL);
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_LOADING));
            this.setState(MediaState.LOADING);
            this.m_monitor.start();
            this.doBasePlay(this.m_sourceURL,0);
            this.m_connection.call("getStreamLength",new Responder(this.setTimeDuration,null),this.m_sourceURL);
         }
      }
      
      override public function pause() : void
      {
         this.m_playPaused = true;
         if(this.m_ready && !this.m_seeking)
         {
            this.doBasePause();
         }
         switch(this.m_currState)
         {
            case MediaState.PLAYING:
            case MediaState.BUFFERING:
               this.setState(MediaState.PAUSED);
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_PAUSED));
         }
      }
      
      override public function resume() : void
      {
         var _loc1_:Boolean = this.m_currState == MediaState.PAUSED || this.m_currState == MediaState.ENDED;
         this.m_playPaused = false;
         if(this.m_currState == MediaState.STOPPED || this.m_currState == MediaState.CLOSED)
         {
            if(this.m_sourceURL != null && !this.m_requestOpen)
            {
               this.load();
            }
            else if(this.m_ready)
            {
               _loc1_ = true;
            }
         }
         if(_loc1_ && this.m_ready)
         {
            if(this.m_playStarted)
            {
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_RESUMED));
            }
            if(this.m_currState == MediaState.ENDED)
            {
               this.doSeek(0);
            }
            if(!this.m_seeking)
            {
               this.doBaseResume();
            }
            this.m_monitor.start();
         }
      }
      
      override public function seek(param1:Number) : void
      {
         if(this.m_currState == MediaState.STOPPED || this.m_currState == MediaState.ENDED)
         {
            this.setState(MediaState.PAUSED);
         }
         this.doSeek(param1);
      }
      
      override public function stop() : void
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
         if(this.m_currState == MediaState.ERROR || this.m_currState == MediaState.LOADING || this.m_currState == MediaState.CLOSED || this.m_currTime == param1 || param1 > this.m_timeSeekable.end || param1 < this.m_timeSeekable.start || !this.m_ready)
         {
            return;
         }
         this.m_currTime = param1;
         this.m_seeking = true;
         this.m_currBufferTime = this.m_quickStartBufferTime;
         this.setTimeBuffer(param1,this.m_currBufferTime);
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
         this.doBaseSeek(param1);
      }
      
      protected function processPlayComplete() : void
      {
         if(this.m_currState == MediaState.ENDED)
         {
            return;
         }
         this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_ENDED));
         if(this.m_autoRewind)
         {
            this.stop();
         }
         else
         {
            this.m_playPaused = true;
            this.doBasePause();
            this.setState(MediaState.ENDED);
         }
      }
      
      protected function processBuffer() : void
      {
         if(this.m_bufferFull)
         {
            return;
         }
         var _loc1_:Number = this.bufferLength;
         var _loc2_:Number = this.bufferTime;
         var _loc3_:Number = isNaN(this.bufferTimeRemaining / _loc2_) ? 0 : this.bufferTimeRemaining / _loc2_;
         if(_loc1_ != this.m_lastBufferLen)
         {
            if(_loc1_ == 0 || _loc1_ > this.m_lastBufferLen && _loc1_ < _loc2_)
            {
               if(this.m_currState == MediaState.PLAYING || this.m_currState == MediaState.LOADING && !this.m_playPaused)
               {
                  this.setState(MediaState.BUFFERING);
               }
               this.setBuffering(true);
               this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,_loc3_));
            }
            this.m_lastBufferLen = _loc1_;
         }
      }
      
      protected function processTime() : void
      {
         if(this.m_playPaused || this.m_seeking)
         {
            return;
         }
         var _loc1_:Number = this.time;
         if(!isNaN(_loc1_) && this.m_currTime != _loc1_)
         {
            this.m_currTime = _loc1_;
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
            if(!this.m_bufferFull)
            {
               return;
            }
            if(!this.m_playStarted)
            {
               this.m_playStarted = true;
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_STARTED));
            }
            this.setState(MediaState.PLAYING);
         }
      }
      
      protected function setBuffering(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1 != this.m_buffering)
         {
            _loc2_ = Math.min(this.bufferTime,this.duration - this.currentTime);
            _loc3_ = this.bufferTimeRemaining / _loc2_;
            _loc3_ = isNaN(_loc3_) ? 0 : Math.min(1,_loc3_);
            this.m_buffering = param1;
            this.dispatchEvent(new BufferTimeEvent(this.m_buffering ? BufferTimeEvent.BUFFER_TIME_STARTED : BufferTimeEvent.BUFFER_TIME_STOPPED,_loc3_));
         }
      }
      
      protected function setReady() : void
      {
         if(!this.m_ready)
         {
            this.m_ready = true;
            if(this.m_playPaused)
            {
               this.stopPlay();
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_STOPPED));
               this.setState(MediaState.STOPPED);
            }
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_READY));
         }
      }
      
      override protected function setState(param1:String) : void
      {
         super.setState(param1);
         if(param1 == MediaState.ERROR)
         {
            this.m_requestOpen = false;
            this.m_monitor.stop();
         }
      }
      
      protected function setTimeBuffer(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = this.m_duration - param1;
         if(_loc3_ < param2)
         {
            this.bufferTime = _loc3_ / 2;
         }
         else
         {
            this.bufferTime = param2;
         }
      }
      
      protected function setTimeDuration(param1:Number) : void
      {
         if(isNaN(param1) || Math.round(param1) == Math.round(this.m_duration))
         {
            return;
         }
         this.m_duration = param1;
         this.m_timeSeekable.end = param1;
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
         this.setReady();
      }
      
      protected function stopPlay() : void
      {
         this.m_playPaused = true;
         if(!this.m_seeking)
         {
            this.doBasePause();
         }
         this.doSeek(0);
      }
      
      override protected function onIOError(param1:IOErrorEvent) : void
      {
         this.m_requestOpen = false;
         super.onIOError(param1);
      }
      
      protected function onMetaData(param1:NetInfoEvent) : void
      {
         var _loc2_:Object = param1.info;
         if(_loc2_ != null && this.m_metadata == null)
         {
            this.m_metadata = _loc2_;
            this.m_sourceWidth = _loc2_.width;
            this.m_sourceHeight = _loc2_.height;
            this.setTimeDuration(_loc2_.duration);
            this.dispatchEvent(new NetInfoEvent(NetInfoEvent.NET_INFO_META_DATA,_loc2_));
         }
         this.setReady();
      }
      
      protected function onMonitorStream(param1:TimerEvent) : void
      {
         this.processBuffer();
         this.processTime();
      }
      
      protected function onNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetStream.Seek.Notify":
               this.m_seeking = false;
               if(this.m_playPaused)
               {
                  this.doBasePause();
               }
               else
               {
                  this.doBaseResume();
               }
               break;
            case "NetStream.Play.Start":
               this.m_bufferFull = false;
               if(!this.m_playPaused)
               {
                  this.setBuffering(true);
                  this.setState(MediaState.BUFFERING);
                  this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,0));
               }
               break;
            case "NetStream.Play.FileStructureInvalid":
            case "NetStream.Play.NoSupportedTrackFound":
            case "NetStream.Play.StreamNotFound":
            case "NetStream.Play.Failed":
               this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_IO_EXCEPTION,new IOError(param1.info.code)));
               this.setState(MediaState.ERROR);
               break;
            case "NetStream.Buffer.Full":
               this.m_bufferFull = true;
               this.m_currBufferTime = this.m_bufferTimePreferred;
               this.setTimeBuffer(this.time,this.m_currBufferTime);
               if(this.m_buffering)
               {
                  this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,1));
                  this.setBuffering(false);
               }
               break;
            case "NetStream.Buffer.Empty":
               this.m_currBufferTime = this.m_quickStartBufferTime;
               this.setTimeBuffer(this.time,this.m_currBufferTime);
               if(this.duration - this.bufferTime > this.currentTime)
               {
                  this.m_bufferFull = false;
                  this.setBuffering(true);
               }
         }
      }
      
      protected function onPlayStatus(param1:NetInfoEvent) : void
      {
         if(param1.info.code == "NetStream.Play.Complete")
         {
            this.processPlayComplete();
         }
         this.dispatchEvent(param1);
      }
   }
}

