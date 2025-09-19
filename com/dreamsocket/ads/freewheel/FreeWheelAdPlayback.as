package com.dreamsocket.ads.freewheel
{
   import com.dreamsocket.ads.IAd;
   import com.dreamsocket.data.IRange;
   import com.dreamsocket.data.Range;
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.PlayEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import com.dreamsocket.media.IAudible;
   import com.dreamsocket.media.IMediaObject;
   import com.dreamsocket.media.IPlayback;
   import com.dreamsocket.media.MediaState;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import tv.freewheel.ad.behavior.IAdManager;
   import tv.freewheel.ad.behavior.IConstants;
   import tv.freewheel.ad.behavior.IEvent;
   import tv.freewheel.ad.behavior.ISlot;
   
   public class FreeWheelAdPlayback extends EventDispatcher implements IAd, IPlayback, IAudible
   {
      
      protected var m_ad:ISlot;
      
      protected var m_adMgr:IAdManager;
      
      protected var m_adConst:IConstants;
      
      protected var m_bytesDownloaded:Range;
      
      protected var m_currState:String;
      
      protected var m_currTime:Number;
      
      protected var m_downloading:Boolean;
      
      protected var m_duration:Number;
      
      protected var m_monitor:Timer;
      
      protected var m_muted:Boolean;
      
      protected var m_paused:Boolean;
      
      protected var m_playStarted:Boolean;
      
      protected var m_prevState:String;
      
      protected var m_timeDownloaded:Range;
      
      protected var m_volume:Number;
      
      public function FreeWheelAdPlayback()
      {
         super();
         this.m_currState = MediaState.CLOSED;
         this.m_prevState = MediaState.CLOSED;
         this.m_currTime = 0;
         this.m_bytesDownloaded = new Range();
         this.m_duration = 0;
         this.m_timeDownloaded = new Range();
         this.m_volume = 1;
         this.m_monitor = new Timer(100);
         this.m_monitor.addEventListener(TimerEvent.TIMER,this.onMonitorAd);
      }
      
      public function set adManager(param1:IAdManager) : void
      {
         if(param1 != this.m_adMgr)
         {
            this.destroyAdManager();
            this.m_adMgr = param1;
            if(param1 != null)
            {
               this.m_adConst = this.m_adMgr.getConstants();
               this.m_adMgr.setAdVolume(this.muted ? 0 : uint(this.m_volume * 100));
               this.m_adMgr.addEventListener(this.m_adConst.EVENT_SLOT_STARTED,this.onAdRequested);
               this.m_adMgr.addEventListener(this.m_adConst.EVENT_SLOT_ENDED,this.onAdEnded);
               this.m_adMgr.addEventListener(this.m_adConst.EVENT_RENDERER,this.onAdEventFired);
            }
         }
      }
      
      public function get adManager() : IAdManager
      {
         return this.m_adMgr;
      }
      
      public function get autoPlay() : Boolean
      {
         return true;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
      }
      
      public function get autoRewind() : Boolean
      {
         return true;
      }
      
      public function set autoRewind(param1:Boolean) : void
      {
      }
      
      public function get bufferTimePreferred() : Number
      {
         return 0;
      }
      
      public function set bufferTimePreferred(param1:Number) : void
      {
      }
      
      public function get bufferTimeRemaining() : Number
      {
         return 0;
      }
      
      public function get buffering() : Boolean
      {
         return false;
      }
      
      public function get bytesDownloaded() : IRange
      {
         return this.m_bytesDownloaded;
      }
      
      public function get bytesTotal() : uint
      {
         return this.m_ad ? uint(this.m_ad.getTotalBytes(true)) : 0;
      }
      
      public function get currentTime() : Number
      {
         return this.m_currTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
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
         return null;
      }
      
      public function set media(param1:IMediaObject) : void
      {
      }
      
      public function get muted() : Boolean
      {
         return this.m_muted;
      }
      
      public function set muted(param1:Boolean) : void
      {
         if(param1 != this.m_muted)
         {
            if(this.m_adMgr)
            {
               this.m_adMgr.setAdVolume(param1 ? uint(this.m_volume * 100) : 0);
            }
         }
      }
      
      public function get paused() : Boolean
      {
         return this.m_paused;
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
         return null;
      }
      
      public function set url(param1:String) : void
      {
      }
      
      public function get volume() : Number
      {
         return this.m_volume;
      }
      
      public function set volume(param1:Number) : void
      {
         var _loc2_:Number = Math.max(0,Math.min(1,param1));
         if(_loc2_ != this.m_volume)
         {
            this.m_volume = _loc2_;
            if(this.m_adMgr)
            {
               this.m_adMgr.setAdVolume(_loc2_ * 100);
            }
         }
      }
      
      public function close() : void
      {
         if(this.m_ad)
         {
            this.m_ad.stop();
            this.destroyAd();
         }
      }
      
      public function destroy() : void
      {
         this.close();
         this.destroyAdManager();
      }
      
      public function load() : void
      {
      }
      
      public function pause() : void
      {
         if(this.m_ad)
         {
            this.m_ad.pause(true);
            this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_PAUSED));
         }
      }
      
      public function play() : void
      {
         if(this.m_ad)
         {
            this.m_ad.pause(false);
            if(this.m_currState == MediaState.PAUSED)
            {
               this.setState(MediaState.PLAYING);
            }
         }
      }
      
      public function stop() : void
      {
         this.close();
      }
      
      protected function destroyAd() : void
      {
         if(this.m_ad == null)
         {
            return;
         }
         this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_ENDED));
         this.m_ad = null;
         this.m_bytesDownloaded.end = 0;
         this.m_currTime = 0;
         this.m_duration = 0;
         this.m_timeDownloaded.end = 0;
         this.m_paused = false;
         this.m_playStarted = false;
         this.setDownloading(false);
         this.setState(MediaState.CLOSED);
         this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_CLOSED));
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
         this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,0));
         this.m_monitor.stop();
      }
      
      protected function destroyAdManager() : void
      {
         if(this.m_adMgr)
         {
            this.m_adMgr.removeEventListener(this.m_adConst.EVENT_SLOT_STARTED,this.onAdRequested);
            this.m_adMgr.removeEventListener(this.m_adConst.EVENT_SLOT_ENDED,this.onAdEnded);
            this.m_adMgr.removeEventListener(this.m_adConst.EVENT_RENDERER,this.onAdEventFired);
         }
         this.m_adMgr = null;
      }
      
      protected function processDownload() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = this.m_ad.getBytesLoaded(true);
         var _loc2_:Number = this.m_ad.getTotalDuration(true);
         if(_loc1_ != this.m_bytesDownloaded.end)
         {
            this.m_bytesDownloaded.end = _loc1_;
            this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,_loc1_ / this.bytesTotal));
            if(_loc2_ != 0)
            {
               _loc3_ = Math.max(0,this.m_bytesDownloaded.end / this.bytesTotal) * this.duration;
               if(!isNaN(_loc2_) && _loc2_ != this.m_duration)
               {
                  this.m_duration = _loc2_;
                  this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
               }
               if(_loc3_ != this.m_timeDownloaded.end)
               {
                  this.m_timeDownloaded.end = _loc3_;
                  this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
               }
            }
         }
         else
         {
            this.setDownloading(false);
         }
      }
      
      protected function processTime() : void
      {
         var _loc1_:Number = this.m_ad.getPlayheadTime(true);
         if(this.m_currTime == 0 && _loc1_ > 1)
         {
            return;
         }
         if(_loc1_ != -1 && _loc1_ != this.m_currTime)
         {
            if(this.m_currState != MediaState.PLAYING)
            {
               this.setState(MediaState.PLAYING);
               if(this.m_playStarted)
               {
                  this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_RESUMED));
               }
               else
               {
                  this.dispatchEvent(new PlayEvent(PlayEvent.PLAY_STARTED));
               }
            }
            this.m_currTime = this.m_ad.getPlayheadTime(true);
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
         }
      }
      
      protected function setDownloading(param1:Boolean) : void
      {
         if(param1 != this.m_downloading)
         {
            this.m_downloading = param1;
            this.dispatchEvent(new DownloadEvent(this.m_downloading ? DownloadEvent.DOWNLOAD_STARTED : DownloadEvent.DOWNLOAD_STOPPED,this.bytesDownloaded.end / this.bytesTotal));
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
      
      protected function onAdEnded(param1:IEvent) : void
      {
         this.destroyAd();
      }
      
      protected function onAdEventFired(param1:IEvent) : void
      {
         if(this.m_ad == null)
         {
            return;
         }
         if(param1.subType == String(this.m_adConst.RENDERER_EVENT_IMPRESSION))
         {
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_READY));
            this.setState(MediaState.PLAYING);
         }
      }
      
      protected function onAdRequested(param1:IEvent) : void
      {
         var _loc2_:ISlot = this.m_adMgr.getSlotByCustomId(param1.slotCustomId);
         if(FreeWheelUtil.isAdLinear(this.m_adMgr,param1.slotCustomId))
         {
            this.m_ad = _loc2_;
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_OPENING));
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_LOADING));
            this.setState(MediaState.LOADING);
            this.setDownloading(true);
            this.m_monitor.start();
         }
      }
      
      protected function onMonitorAd(param1:TimerEvent) : void
      {
         this.processDownload();
         this.processTime();
      }
   }
}

