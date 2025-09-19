package com.dreamsocket.media
{
   import com.dreamsocket.events.BufferTimeEvent;
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.NetInfoEvent;
   import com.dreamsocket.events.PlayEvent;
   import com.dreamsocket.events.TimeEvent;
   import flash.errors.IOError;
   import flash.events.NetStatusEvent;
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import flash.utils.Timer;
   
   public class ProgressiveNS extends AbstractMediaNS
   {
      
      public static var defaultSourceSelector:IMediaSourceSelector = new MediaSourceSelector();
      
      protected static const k_CONN:NetConnection = new NetConnection();
      
      protected static const k_MONITOR_BUFFER_INTERVAL:Number = 75;
      
      protected static const k_MONITOR_PLAY_INTERVAL:Number = 75;
      
      protected var m_bufferTimeModified:Boolean;
      
      protected var m_bufferFull:Boolean;
      
      protected var m_currBufferTime:Number;
      
      protected var m_currTime:Number;
      
      protected var m_downloadComplete:Boolean;
      
      protected var m_lastBufferLen:Number;
      
      protected var m_monitorTimeCt:Number;
      
      protected var m_quickStartBufferTime:Number;
      
      protected var m_ready:Boolean;
      
      protected var m_sourceSelector:IMediaSourceSelector;
      
      protected var m_timePriorSeek:Number;
      
      protected var m_timeSeekedTo:Number;
      
      protected var m_bufferMonitor:Timer;
      
      protected var m_playMonitor:Timer;
      
      public function ProgressiveNS(param1:NetConnection = null)
      {
         var _loc2_:NetConnection = param1 ? param1 : ProgressiveNS.k_CONN;
         _loc2_.connect(null);
         super(_loc2_);
         this.m_buffering = false;
         this.m_bufferTimeModified = false;
         this.m_bufferFull = false;
         this.m_bufferTimePreferred = 10;
         this.m_currBufferTime = 10;
         this.m_currTime = 0;
         this.m_downloadComplete = false;
         this.m_lastBufferLen = 0;
         this.m_timePriorSeek = 0;
         this.m_monitorTimeCt = 0;
         this.m_quickStartBufferTime = 2;
         this.m_ready = false;
         this.m_sourceSelector = defaultSourceSelector;
         this.m_timeSeekedTo = 0;
         this.bufferTime = 0.1;
         this.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false,0,true);
         this.m_clientProxy.addEventListener(NetInfoEvent.NET_INFO_CUE_POINT,this.dispatchEvent);
         this.m_clientProxy.addEventListener(NetInfoEvent.NET_INFO_META_DATA,this.onMetaData);
         this.m_clientProxy.addEventListener(NetInfoEvent.NET_INFO_IMAGE_DATA,this.dispatchEvent);
         this.m_clientProxy.addEventListener(NetInfoEvent.NET_INFO_TEXT_DATA,this.dispatchEvent);
         this.m_clientProxy.addEventListener(NetInfoEvent.NET_INFO_XMP_DATA,this.dispatchEvent);
         this.m_bufferMonitor = new Timer(ProgressiveNS.k_MONITOR_BUFFER_INTERVAL);
         this.m_bufferMonitor.addEventListener(TimerEvent.TIMER,this.onMonitorBuffer,false,0,true);
         this.m_playMonitor = new Timer(ProgressiveNS.k_MONITOR_PLAY_INTERVAL);
         this.m_playMonitor.addEventListener(TimerEvent.TIMER,this.onMonitorPlay,false,0,true);
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
         this.stopPlay();
         this.stopDownload();
         this.m_bufferTimeModified = false;
         this.m_playStarted = false;
         this.m_playPaused = !this.autoPlay;
         this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_CLOSED));
         this.setState(MediaState.CLOSED);
      }
      
      override public function destroy() : void
      {
         this.close();
         this.m_duration = 0;
         this.m_metadata = null;
         this.m_sourceURL = null;
         this.m_sourceWidth = 0;
         this.m_sourceHeight = 0;
      }
      
      override public function load() : void
      {
         if(!this.m_downloading && !this.m_downloadComplete && this.m_sourceURL != null)
         {
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_LOADING));
            this.bufferTime = 0.1;
            this.m_bufferMonitor.start();
            this.setState(MediaState.LOADING);
            this.doBasePlay(this.m_sourceURL);
            this.doBasePause();
         }
      }
      
      override public function pause() : void
      {
         this.doBasePause();
         this.m_playPaused = true;
         this.m_playMonitor.stop();
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
            if(this.m_sourceURL != null && !this.m_downloadComplete && !this.m_downloading)
            {
               this.load();
            }
            else if(this.m_metadata != null && (this.m_downloadComplete || this.m_downloading))
            {
               _loc1_ = true;
            }
         }
         if(_loc1_)
         {
            if(this.m_currState == MediaState.ENDED)
            {
               this.doSeek(0);
            }
            if(this.m_playStarted)
            {
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_RESUMED));
            }
            if(this.m_buffering)
            {
               this.setState(MediaState.BUFFERING);
            }
            this.doBaseResume();
            this.m_playMonitor.start();
         }
      }
      
      override public function seek(param1:Number) : void
      {
         this.m_timePriorSeek = this.currentTime;
         if(this.m_currState == MediaState.STOPPED || this.m_currState == MediaState.ENDED)
         {
            this.m_monitorTimeCt = 0;
            this.setState(MediaState.PAUSED);
         }
         if(this.metadata != null)
         {
            this.doSeek(param1);
         }
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
         this.m_timeSeekedTo = param1;
         this.doBaseSeek(param1);
      }
      
      protected function processBuffer() : void
      {
         if(this.m_bufferFull || !this.m_downloading)
         {
            return;
         }
         var _loc1_:Number = this.bufferLength;
         var _loc2_:Number = Math.min(this.m_currBufferTime,this.duration - this.currentTime);
         var _loc3_:Number = isNaN(this.bufferTimeRemaining / _loc2_) ? 0 : this.bufferTimeRemaining / _loc2_;
         if(_loc1_ != this.m_lastBufferLen)
         {
            if(_loc1_ > this.m_lastBufferLen && _loc1_ < _loc2_ && !this.m_downloadComplete)
            {
               if(this.m_currState == MediaState.PLAYING || this.m_currState == MediaState.LOADING && !this.m_playPaused)
               {
                  this.setState(MediaState.BUFFERING);
               }
               this.setBuffering(true);
               this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,_loc3_));
            }
            else if(this.bufferTime == this.m_currBufferTime && !this.m_bufferTimeModified && !this.m_playPaused)
            {
               this.m_bufferTimeModified = true;
               this.doBaseResume();
            }
            else if(_loc1_ > _loc2_)
            {
               this.setBuffering(false);
               this.m_bufferFull = true;
            }
            this.m_lastBufferLen = _loc1_;
         }
      }
      
      protected function processLoad() : void
      {
         var _loc1_:Number = this.bytesLoaded + this.m_bytesDownloaded.start;
         var _loc2_:Number = this.bytesTotal;
         var _loc3_:Number = Math.min(1,_loc1_ / _loc2_);
         if(!isNaN(_loc3_) && this.bytesLoaded > 0 && this.m_bytesDownloaded.length != this.bytesLoaded)
         {
            this.m_downloadComplete = _loc3_ == 1;
            this.setDownloading(true);
            this.m_bytesDownloaded.end = _loc1_;
            if(this.m_metadata != null && this.duration * _loc3_ > this.m_timeDownloaded.end)
            {
               this.m_timeDownloaded.end = this.duration * _loc3_;
               this.updateSeekableTime(this.m_timeDownloaded.end);
            }
            this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,Math.min(1,this.m_bytesDownloaded.length / (this.bytesTotal - this.bytesDownloaded.start)),Math.min(1,this.bytesLoaded / _loc2_)));
            this.processBuffer();
            if(this.m_downloadComplete)
            {
               this.m_bufferFull = true;
               this.m_bufferMonitor.stop();
               this.m_bufferTimeModified = true;
               this.setBuffering(false);
               this.setDownloading(false);
            }
         }
      }
      
      protected function processPlayComplete() : void
      {
         if(isNaN(this.bytesLoaded) || this.downloading)
         {
            return;
         }
         if(this.m_currState != MediaState.ENDED)
         {
            this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_ENDED));
            if(this.m_autoRewind)
            {
               this.stop();
            }
            else
            {
               this.doBasePause();
               this.m_playMonitor.stop();
               this.m_playPaused = true;
               this.setState(MediaState.ENDED);
            }
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
            this.dispatchEvent(new BufferTimeEvent(param1 ? BufferTimeEvent.BUFFER_TIME_STARTED : BufferTimeEvent.BUFFER_TIME_STOPPED,_loc3_));
         }
      }
      
      protected function setDownloading(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1 != this.m_downloading)
         {
            _loc2_ = this.m_bytesDownloaded.length / (this.bytesTotal - this.bytesDownloaded.start);
            _loc3_ = this.bytesLoaded / this.bytesTotal;
            _loc2_ = isNaN(_loc2_) ? 0 : _loc2_;
            _loc3_ = isNaN(_loc3_) ? 0 : _loc3_;
            this.m_downloading = param1;
            this.dispatchEvent(new DownloadEvent(param1 ? DownloadEvent.DOWNLOAD_STARTED : DownloadEvent.DOWNLOAD_STOPPED,_loc2_,_loc3_));
         }
      }
      
      override protected function setState(param1:String) : void
      {
         super.setState(param1);
         if(param1 == MediaState.ERROR)
         {
            this.m_bufferMonitor.stop();
         }
      }
      
      protected function stopDownload() : void
      {
         this.doBaseClose();
         this.m_bufferMonitor.stop();
         if(this.downloading || this.m_downloadComplete)
         {
            this.setBuffering(false);
            this.setDownloading(false);
            this.m_bytesDownloaded.start = 0;
            this.m_bytesDownloaded.end = 0;
            this.m_bufferFull = false;
            this.m_downloadComplete = false;
            this.m_lastBufferLen = 0;
            this.m_timePriorSeek = 0;
            this.m_monitorTimeCt = 0;
            this.m_ready = false;
            this.m_timeDownloaded.start = 0;
            this.m_timeDownloaded.end = 0;
            this.m_timeSeekable.end = 0;
            this.dispatchEvent(new BufferTimeEvent(BufferTimeEvent.BUFFER_TIME_PROGRESS,0));
            this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,0,0));
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
         }
      }
      
      protected function stopPlay() : void
      {
         this.m_playMonitor.reset();
         this.m_playMonitor.stop();
         this.m_playPaused = true;
         if(this.currentTime != 0)
         {
            this.m_currTime = 0;
            this.doSeek(0);
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
         }
         this.doBasePause();
      }
      
      protected function updateSeekableTime(param1:Number) : void
      {
         this.m_timeSeekable.end = param1;
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
      }
      
      protected function onMetaData(param1:NetInfoEvent) : void
      {
         var _loc2_:Object = param1.info;
         if(_loc2_ != null && this.m_metadata == null)
         {
            this.m_metadata = _loc2_;
            this.m_duration = _loc2_.duration;
            this.m_sourceWidth = _loc2_.width;
            this.m_sourceHeight = _loc2_.height;
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
            this.dispatchEvent(new NetInfoEvent(NetInfoEvent.NET_INFO_META_DATA,_loc2_));
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_READY));
         }
         if(!this.m_ready && this.m_metadata != null)
         {
            this.m_ready = true;
            this.m_currBufferTime = this.bufferTimePreferred;
            this.bufferTime = this.bufferTimePreferred;
            if(this.m_downloadComplete)
            {
               this.updateSeekableTime(this.m_duration);
            }
            if(!this.m_playPaused)
            {
               this.m_playMonitor.start();
               this.doBaseResume();
            }
            else
            {
               this.stopPlay();
               this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_STOPPED));
               this.setState(MediaState.STOPPED);
            }
         }
      }
      
      protected function onMonitorBuffer(param1:TimerEvent) : void
      {
         this.processLoad();
      }
      
      protected function onMonitorPlay(param1:TimerEvent) : void
      {
         var _loc2_:Number = this.time;
         if(!isNaN(_loc2_) && this.m_currTime != _loc2_)
         {
            if(this.m_monitorTimeCt > 0)
            {
               this.m_currTime = _loc2_;
               this.m_monitorTimeCt = 0;
               this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
            }
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
         else if(this.duration - this.currentTime < 1 && this.m_monitorTimeCt > 10)
         {
            this.processPlayComplete();
         }
         else if(this.m_monitorTimeCt > 10)
         {
            this.m_bufferFull = false;
         }
         ++this.m_monitorTimeCt;
      }
      
      protected function onNetStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:String = param1.info.code;
         switch(_loc2_)
         {
            case "NetStream.Play.FileStructureInvalid":
            case "NetStream.Play.NoSupportedTrackFound":
            case "NetStream.Play.StreamNotFound":
               this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_IO_EXCEPTION,new IOError(_loc2_)));
               this.setState(MediaState.ERROR);
               break;
            case "NetStream.Seek.Notify":
               if(this.m_timeSeekedTo != this.m_currTime && this.m_playPaused)
               {
                  this.m_currTime = this.m_timeSeekedTo;
                  this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
               }
               break;
            case "NetStream.Seek.InvalidTime":
               this.doBaseSeek(this.m_timePriorSeek);
               break;
            case "NetStream.Buffer.Full":
               this.m_bufferFull = true;
               this.m_currBufferTime = this.m_bufferTimePreferred;
               this.bufferTime = this.m_bufferTimePreferred;
               this.setBuffering(false);
               break;
            case "NetStream.Buffer.Empty":
               this.m_bufferFull = this.m_downloadComplete;
               this.m_currBufferTime = this.m_quickStartBufferTime;
               this.bufferTime = this.m_currBufferTime;
               this.setBuffering(this.bytesLoaded != this.bytesTotal);
         }
      }
   }
}

