package com.dreamsocket.ads.freewheel
{
   import com.dreamsocket.cues.BaseCueRangeManager;
   import com.dreamsocket.cues.CueRange;
   import com.dreamsocket.data.Map;
   import com.dreamsocket.events.CueRangeEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import com.dreamsocket.flash.components.core.FlashUIComponent;
   import com.dreamsocket.flash.components.mediaClasses.AbstractPlaybackComponent;
   import com.dreamsocket.media.IMediaObject;
   import com.dreamsocket.media.IMediaView;
   import com.dreamsocket.media.IPlayback;
   import com.dreamsocket.media.MediaDeliveryType;
   import com.dreamsocket.media.MediaState;
   import com.dreamsocket.media.PlaybackMetricsManager;
   import com.dreamsocket.text.PropertyStringUtil;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.geom.Rectangle;
   import flash.system.Security;
   import flash.utils.Dictionary;
   import tv.freewheel.ad.behavior.IAdManager;
   import tv.freewheel.ad.behavior.IConstants;
   import tv.freewheel.ad.behavior.IEvent;
   import tv.freewheel.ad.behavior.ISlot;
   import tv.freewheel.ad.loader.AdManagerLoader;
   
   public class UIAdManager extends FlashUIComponent
   {
      
      protected var m_config:FreeWheelConfig;
      
      protected var m_contentMedia:IMediaObject;
      
      protected var m_contentMetricsMgr:PlaybackMetricsManager;
      
      protected var m_contentPlayback:AbstractPlaybackComponent;
      
      protected var m_cueMgr:BaseCueRangeManager;
      
      protected var m_invalidAdContext:Boolean;
      
      protected var m_invalidContent:Boolean;
      
      protected var m_resetExclusivity:Boolean;
      
      protected var m_adProcessing:Boolean;
      
      protected var m_adContainer:Sprite;
      
      protected var m_adSlots:Map;
      
      protected var m_linerAdPlaying:Boolean;
      
      protected var m_prerollsPlayed:Dictionary;
      
      protected var m_fwAdMgr:IAdManager;
      
      protected var m_fwAdMgrContainer:Sprite;
      
      protected var m_fwAdMgrLoader:AdManagerLoader;
      
      protected var m_fwAdMgrLoaded:Boolean;
      
      protected var m_fwAdMgrLoadCompleted:Boolean;
      
      protected var m_fwConst:IConstants;
      
      protected var m_fwPlayback:FreeWheelAdPlayback;
      
      protected var m_nonLinearAds:Object;
      
      protected var m_prerollSlots:Array;
      
      protected var m_postrollSlots:Array;
      
      public function UIAdManager(param1:AbstractPlaybackComponent)
      {
         super();
         this.m_adSlots = new Map();
         this.m_nonLinearAds = {};
         this.m_prerollSlots = [];
         this.m_postrollSlots = [];
         this.m_contentPlayback = param1;
         this.m_contentPlayback.addEventListener(StateChangeEvent.STATE_CHANGED,this.onMediaStateChanged);
         this.m_contentPlayback.addEventListener(TimeEvent.TIME_POSITION_CHANGED,this.onTimePositionChanged);
         this.m_contentMetricsMgr = new PlaybackMetricsManager();
         this.m_contentMetricsMgr.addEventListener(Event.CHANGE,this.onMediaMetricsChanged);
         this.m_cueMgr = new BaseCueRangeManager();
         this.m_cueMgr.addEventListener(CueRangeEvent.CUE_RANGE_ENTERED,this.onCuePointEncountered);
         this.m_fwAdMgrContainer = new Sprite();
         this.m_fwPlayback = new FreeWheelAdPlayback();
         this.m_prerollsPlayed = new Dictionary();
         this.m_adContainer = new Sprite();
         this.addChild(this.m_adContainer);
      }
      
      public function get adPlayback() : IPlayback
      {
         return this.m_fwPlayback;
      }
      
      public function get adProcessing() : Boolean
      {
         return this.m_adProcessing;
      }
      
      public function get config() : FreeWheelConfig
      {
         return this.m_config;
      }
      
      public function set config(param1:FreeWheelConfig) : void
      {
         if(param1 != this.m_config)
         {
            this.m_config = param1;
            this.loadAdManager();
         }
      }
      
      public function get contentPlayback() : IPlayback
      {
         return this.m_contentPlayback;
      }
      
      public function get initialized() : Boolean
      {
         return this.m_fwAdMgrLoadCompleted;
      }
      
      public function get linearAdPlaying() : Boolean
      {
         return this.m_linerAdPlaying;
      }
      
      public function get media() : IMediaObject
      {
         return this.m_contentMedia;
      }
      
      public function getAd(param1:IMediaObject) : void
      {
         if(param1 != this.m_contentMedia)
         {
            this.m_contentMedia = param1;
            this.m_invalidAdContext = true;
            this.m_invalidContent = true;
            this.m_resetExclusivity = true;
            this.m_contentPlayback.close();
            if(this.m_config != null && (this.m_config.enabled && this.m_config.enabled) && !(this.m_fwAdMgrLoadCompleted && this.m_fwAdMgr == null))
            {
               this.requestAd();
            }
            else
            {
               this.m_invalidAdContext = false;
               this.m_invalidContent = false;
               this.m_resetExclusivity = false;
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("console.log","","GETAD");
               }
               this.playContent();
            }
         }
      }
      
      public function set media(param1:IMediaObject) : void
      {
         if(param1 != this.m_contentMedia)
         {
            this.m_contentMedia = param1;
            this.m_invalidAdContext = true;
            this.m_invalidContent = true;
            this.m_resetExclusivity = true;
            this.m_contentPlayback.close();
            if(this.m_config != null && (this.m_config.enabled && this.m_config.enabled) && !(this.m_fwAdMgrLoadCompleted && this.m_fwAdMgr == null))
            {
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("console.log","","set media");
               }
               this.requestAd();
            }
            else
            {
               this.m_invalidAdContext = false;
               this.m_invalidContent = false;
               this.m_resetExclusivity = false;
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("console.log","","media");
               }
               this.playContent();
            }
         }
      }
      
      public function get monitorContentTimeEnabled() : Boolean
      {
         return this.m_cueMgr.enabled;
      }
      
      public function set monitorContentTimeEnabled(param1:Boolean) : void
      {
         this.m_cueMgr.enabled = param1;
      }
      
      public function addNonLinerAd(param1:NonLinearAd) : void
      {
         this.m_nonLinearAds[param1.ID] = param1;
         if(this.m_fwAdMgrLoaded)
         {
            this.m_fwAdMgr.addVideoPlayerNonTemporalSlot(param1.ID,param1.container,param1.width,param1.height);
         }
      }
      
      protected function addNonLinearAds() : void
      {
         var _loc1_:String = null;
         var _loc2_:NonLinearAd = null;
         for(_loc1_ in this.m_nonLinearAds)
         {
            _loc2_ = NonLinearAd(this.m_nonLinearAds[_loc1_]);
            this.m_fwAdMgr.addVideoPlayerNonTemporalSlot(_loc2_.ID,_loc2_.container,_loc2_.width,_loc2_.height);
         }
      }
      
      protected function getContentTime() : Number
      {
         if(this.m_contentPlayback != null)
         {
            return this.m_contentPlayback.currentTime;
         }
         return NaN;
      }
      
      protected function loadAdManager() : void
      {
         if(this.m_fwAdMgrLoader != null)
         {
            return;
         }
         var _loc1_:FreeWheelConfig = this.m_config;
         this.dispatchEvent(new UIAdManagerEvent(UIAdManagerEvent.AD_MANAGER_INIT_REQUESTED));
         if(_loc1_.enabled)
         {
            this.m_fwAdMgrLoader = new AdManagerLoader();
            this.m_fwAdMgrLoader.loadAdManager(this.m_fwAdMgrContainer,this.onAdManagerLoaded,_loc1_.logLevel,_loc1_.componentURL,_loc1_.version);
         }
         else
         {
            this.dispatchEvent(new UIAdManagerEvent(UIAdManagerEvent.AD_MANAGER_INIT_SUCCEEDED,true));
         }
      }
      
      protected function requestAd() : void
      {
         if(!this.m_fwAdMgrLoadCompleted || this.m_adProcessing || this.m_contentMedia == null || !this.m_invalidAdContext)
         {
            return;
         }
         if(!this.m_fwAdMgrLoaded)
         {
            this.playContent();
            return;
         }
         var _loc1_:FreeWheelConfig = this.m_config;
         var _loc2_:Number = Number(PropertyStringUtil.evalParamString(this.media,_loc1_.videoDuration));
         this.m_cueMgr.clear();
         this.m_adSlots.clear();
         this.m_prerollSlots = [];
         this.m_postrollSlots = [];
         if(this.m_resetExclusivity)
         {
            this.m_fwAdMgr.setCapability(this.m_fwConst.CAPABILITY_RESET_EXCLUSIVITY,this.m_fwConst.CAPABILITY_STATUS_ON);
         }
         this.m_fwAdMgr.refresh();
         this.m_fwAdMgr.setRequestMode(this.m_fwConst.REQUEST_MODE_ON_DEMAND);
         this.m_fwAdMgr.setSiteSection(PropertyStringUtil.evalParamString(this.media,_loc1_.videoSectionID),new Date().valueOf());
         this.m_fwAdMgr.setVideoAsset(PropertyStringUtil.evalParamString(this.media,_loc1_.videoAssetID),_loc2_,null,true,new Date().valueOf(),_loc1_.networkID,0,0,isNaN(_loc2_) ? this.m_fwConst.VIDEO_ASSET_DURATION_TYPE_VARIABLE : this.m_fwConst.VIDEO_ASSET_DURATION_TYPE_EXACT);
         this.m_contentMetricsMgr.playback = null;
         this.m_contentMetricsMgr.reset();
         if(this.m_config.externalAdsEnabled)
         {
            this.m_fwAdMgr.scanSlotsOnPage();
         }
         this.m_invalidAdContext = false;
         this.m_invalidContent = false;
         this.m_resetExclusivity = false;
         this.m_adProcessing = true;
         this.m_fwAdMgr.submitRequest();
         this.m_fwAdMgr.setCapability(this.m_fwConst.CAPABILITY_RESET_EXCLUSIVITY,this.m_fwConst.CAPABILITY_STATUS_OFF);
         this.dispatchEvent(new UIAdManagerEvent(UIAdManagerEvent.AD_PLAYLIST_REQUESTED,true));
      }
      
      protected function playContent() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("console.log","","PLAY CONTENT Triggered");
            ExternalInterface.call("endAd");
         }
         trace("* * * * * * * PLAY CONTENT * * * * * * *");
      }
      
      protected function setAdContainerSize() : void
      {
         var _loc2_:Rectangle = null;
         if(this.m_contentPlayback == null)
         {
            return;
         }
         var _loc1_:IMediaView = this.m_contentPlayback.view;
         if(_loc1_)
         {
            _loc2_ = _loc1_.contentRect;
         }
         else
         {
            _loc2_ = new Rectangle(0,0,this.m_contentPlayback.width,this.m_contentPlayback.height);
         }
         if(this.m_fwAdMgr)
         {
            this.m_fwAdMgr.setVideoDisplaySize(0,0,this.width,this.height,_loc2_.x,_loc2_.y,_loc2_.width,_loc2_.height);
         }
      }
      
      protected function teardownAdManager() : void
      {
         if(this.m_fwAdMgr != null)
         {
            this.m_adSlots.clear();
            this.m_prerollSlots = [];
            this.m_postrollSlots = [];
            this.m_fwAdMgr.removeEventListener(this.m_fwConst.EVENT_REQUEST_COMPLETE,this.onAdRequestCompleted);
            this.m_fwAdMgr.removeEventListener(this.m_fwConst.EVENT_SLOT_STARTED,this.onAdSlotStarted);
            this.m_fwAdMgr.removeEventListener(this.m_fwConst.EVENT_SLOT_ENDED,this.onAdSlotEnded);
            this.m_fwAdMgr.removeEventListener(this.m_fwConst.EVENT_PAUSESTATECHANGE_REQUEST,this.onSetPauseStateRequested);
            this.m_fwAdMgr.removeEventListener(this.m_fwConst.EVENT_ALLOWED_DOMAIN_REQUEST,this.onAllowDomainRequested);
            this.m_fwAdMgrLoader.disposeAdManager(this.m_fwAdMgr);
            this.m_fwPlayback.adManager = null;
         }
      }
      
      protected function triggerNonTemporals() : void
      {
         var _loc1_:Array = this.m_fwAdMgr.getVideoPlayerNonTemporalSlots();
         var _loc2_:Array = this.m_fwAdMgr.getSiteSectionNonTemporalSlots();
         var _loc3_:Array = [];
         if(_loc1_ != null)
         {
            _loc3_ = _loc3_.concat(_loc1_);
         }
         if(_loc2_ != null)
         {
            _loc3_ = _loc3_.concat(_loc2_);
         }
         var _loc4_:int = int(_loc3_.length);
         while(_loc4_--)
         {
            _loc3_[_loc4_].play();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.setAdContainerSize();
      }
      
      protected function onAdManagerLoaded(param1:Boolean, param2:String) : void
      {
         var _loc3_:FreeWheelConfig = null;
         this.m_fwAdMgrLoadCompleted = true;
         this.m_fwAdMgrLoaded = param1;
         if(param1)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("console.log","","Ad Manager Loaded");
            }
            _loc3_ = this.m_config;
            this.m_fwAdMgr = this.m_fwAdMgrLoader.newAdManager();
            this.m_fwConst = this.m_fwAdMgr.getConstants();
            this.m_fwPlayback.adManager = this.m_fwAdMgr;
            this.m_fwAdMgr.setServer(_loc3_.server);
            this.m_fwAdMgr.setNetwork(_loc3_.networkID);
            this.m_fwAdMgr.registerVideoDisplay(this.m_adContainer);
            this.m_fwAdMgr.setProfile(_loc3_.profile);
            this.m_fwAdMgr.registerPlayheadTimeCallback(this.getContentTime);
            this.addNonLinearAds();
            if(_loc3_.rendererConfigURL != null)
            {
               this.m_fwAdMgr.setRendererConfiguration(_loc3_.rendererConfigURL);
            }
            this.m_fwAdMgr.addEventListener(this.m_fwConst.EVENT_REQUEST_COMPLETE,this.onAdRequestCompleted);
            this.m_fwAdMgr.addEventListener(this.m_fwConst.EVENT_SLOT_ENDED,this.onAdSlotEnded);
            this.m_fwAdMgr.addEventListener(this.m_fwConst.EVENT_SLOT_STARTED,this.onAdSlotStarted);
            this.m_fwAdMgr.addEventListener(this.m_fwConst.EVENT_PAUSESTATECHANGE_REQUEST,this.onSetPauseStateRequested);
            this.m_fwAdMgr.addEventListener(this.m_fwConst.EVENT_ALLOWED_DOMAIN_REQUEST,this.onAllowDomainRequested);
            this.dispatchEvent(new UIAdManagerEvent(UIAdManagerEvent.AD_MANAGER_INIT_SUCCEEDED,true));
            this.requestAd();
         }
         else
         {
            trace(param2);
            this.dispatchEvent(new UIAdManagerEvent(UIAdManagerEvent.AD_MANAGER_INIT_FAILED,param2));
            if(ExternalInterface.available)
            {
               ExternalInterface.call("console.log","","Ad Manager Loaded");
            }
            this.playContent();
         }
      }
      
      protected function onAdSlotEnded(param1:IEvent) : void
      {
         var _loc2_:ISlot = this.m_fwAdMgr.getSlotByCustomId(param1.slotCustomId);
         this.m_adProcessing = false;
         if(FreeWheelUtil.isAdLinear(this.m_fwAdMgr,param1.slotCustomId))
         {
            this.m_linerAdPlaying = false;
            this.dispatchEvent(new UIAdManagerEvent(UIAdManagerEvent.AD_PLAY_ENDED,param1.slotCustomId));
            this.dispatchEvent(new UIAdManagerEvent(UIAdManagerEvent.AD_PLAYLIST_ENDED,param1.slotCustomId));
         }
         if(this.m_invalidAdContext)
         {
            this.requestAd();
         }
         else if(_loc2_.getTimePositionClass() == this.m_fwConst.TIME_POSITION_CLASS_PREROLL)
         {
            if(this.m_prerollSlots.length)
            {
               ISlot(this.m_prerollSlots.shift()).play();
               this.setAdContainerSize();
            }
            else
            {
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("console.log","","AD SLOT ENDED");
               }
               this.playContent();
            }
         }
         else if(_loc2_.getTimePositionClass() == this.m_fwConst.TIME_POSITION_CLASS_POSTROLL)
         {
            if(this.m_postrollSlots.length)
            {
               ISlot(this.m_postrollSlots.shift()).play();
               this.setAdContainerSize();
            }
         }
      }
      
      protected function onAdSlotStarted(param1:IEvent) : void
      {
         if(FreeWheelUtil.isAdLinear(this.m_fwAdMgr,param1.slotCustomId))
         {
            this.m_linerAdPlaying = true;
            this.dispatchEvent(new UIAdManagerEvent(UIAdManagerEvent.AD_PLAY_STARTED,param1.slotCustomId));
         }
      }
      
      protected function onAllowDomainRequested(param1:IEvent) : void
      {
         Security.allowDomain(param1.domain);
      }
      
      protected function onAdRequestCompleted(param1:IEvent) : void
      {
         var _loc4_:ISlot = null;
         if(!param1.success)
         {
            this.dispatchEvent(new UIAdManagerEvent(UIAdManagerEvent.AD_PLAYLIST_FAILED,param1.serverMessages));
            return;
         }
         this.dispatchEvent(new UIAdManagerEvent(UIAdManagerEvent.AD_PLAYLIST_LOADED,true));
         var _loc2_:Array = this.m_fwAdMgr.getTemporalSlots();
         var _loc3_:uint = _loc2_.length;
         while(_loc3_--)
         {
            _loc4_ = ISlot(_loc2_[_loc3_]);
            if(_loc4_.getTimePositionClass() == this.m_fwConst.TIME_POSITION_CLASS_PREROLL)
            {
               if(!this.m_prerollsPlayed[this.m_contentMedia.id])
               {
                  this.m_prerollSlots.push(_loc4_);
               }
            }
            else if(_loc4_.getTimePositionClass() == this.m_fwConst.TIME_POSITION_CLASS_POSTROLL)
            {
               this.m_postrollSlots.push(_loc4_);
            }
            else
            {
               this.m_cueMgr.addCueRange(new CueRange(_loc4_.getCustomId(),_loc4_.getTimePosition()));
               this.m_adSlots.put(_loc4_.getCustomId(),true);
            }
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.call("console.log","",{"adRequestComplete":param1});
         }
         this.triggerNonTemporals();
         if(this.m_prerollSlots.length)
         {
            this.m_prerollsPlayed[this.m_contentMedia.id] = true;
            this.setAdContainerSize();
            ISlot(this.m_prerollSlots.shift()).play();
         }
         else
         {
            this.m_adProcessing = false;
            if(ExternalInterface.available)
            {
               ExternalInterface.call("console.log","","AD REQUEST COMPLETE");
            }
            this.playContent();
         }
      }
      
      protected function onSetPauseStateRequested(param1:IEvent) : void
      {
         if(param1.videoPause)
         {
            this.m_contentPlayback.pause();
         }
         else if(this.m_contentPlayback.state != MediaState.ENDED)
         {
            this.m_contentPlayback.play();
         }
      }
      
      protected function onCuePointEncountered(param1:CueRangeEvent) : void
      {
         this.m_cueMgr.removeCueRange(param1.cueRange);
         var _loc2_:ISlot = this.m_fwAdMgr.getSlotByCustomId(String(param1.cueRange.ID));
         if(_loc2_ != null)
         {
            this.m_adSlots.remove(_loc2_.getCustomId());
            this.setAdContainerSize();
            _loc2_.play();
         }
      }
      
      protected function onMediaMetricsChanged(param1:Event) : void
      {
         this.m_cueMgr.time = this.m_contentMetricsMgr.timeSpent;
         if(this.m_contentMetricsMgr.timeSpent >= this.m_config.liveAdRefreshRate)
         {
            this.m_invalidAdContext = true;
            this.requestAd();
         }
      }
      
      protected function onMediaStateChanged(param1:StateChangeEvent) : void
      {
         if(this.m_config == null || !this.m_config.enabled || !this.m_config.enabled || !this.m_fwAdMgrLoaded)
         {
            return;
         }
         switch(param1.newState)
         {
            case MediaState.CLOSED:
               this.m_fwAdMgr.setVideoPlayStatus(this.m_fwConst.VIDEO_STATUS_STOPPED);
               break;
            case MediaState.ENDED:
               if(this.m_postrollSlots.length)
               {
                  this.setAdContainerSize();
                  ISlot(this.m_postrollSlots.shift()).play();
               }
               this.m_fwAdMgr.setVideoPlayStatus(this.m_fwConst.VIDEO_STATUS_COMPLETED);
               break;
            case MediaState.PAUSED:
               this.m_fwAdMgr.setVideoPlayStatus(this.m_fwConst.VIDEO_STATUS_PAUSED);
               break;
            case MediaState.PLAYING:
               this.m_fwAdMgr.setVideoPlayStatus(this.m_fwConst.VIDEO_STATUS_PLAYING);
         }
      }
      
      protected function onTimePositionChanged(param1:TimeEvent) : void
      {
         if(this.m_contentMedia.deliveryType != MediaDeliveryType.DVR)
         {
            this.m_cueMgr.time = this.m_contentPlayback.currentTime;
         }
      }
   }
}

