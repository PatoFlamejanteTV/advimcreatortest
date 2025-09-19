package com.cartoonnetwork.apps.fwplayer
{
   import com.cartoonnetwork.events.VideoControlEvent;
   import com.cartoonnetwork.utils.FireBugConsole;
   import com.cartoonnetwork.videoplayers.ads.UICartoonAdManager;
   import com.cartoonnetwork.videoplayers.data.CNMediaObject;
   import com.cartoonnetwork.videoplayers.data.MediaContext;
   import com.cartoonnetwork.videoplayers.services.GetConfigDelegate;
   import com.dreamsocket.ads.freewheel.UIAdManager;
   import com.dreamsocket.ads.freewheel.UIAdManagerEvent;
   import com.dreamsocket.events.BufferTimeEvent;
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import com.dreamsocket.flash.components.MediaDisplayComponent;
   import com.dreamsocket.media.ScaleMode;
   import com.dreamsocket.services.Responder;
   import com.dreamsocket.services.events.ResultEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   
   public class UIVideoController extends Sprite
   {
      
      protected var m_contentPlayback:MediaDisplayComponent;
      
      protected var vidContainer:Sprite;
      
      private var m_adMgr:UIAdManager;
      
      private var m_configService:GetConfigDelegate;
      
      private var adActive:Boolean = false;
      
      private const m_width:uint = 600;
      
      private const m_height:uint = 400;
      
      public var targetIndex:int;
      
      public var freeWheelSectionID:String = "";
      
      public function UIVideoController()
      {
         var _loc1_:String = null;
         var _loc2_:RegExp = null;
         var _loc3_:RegExp = null;
         var _loc4_:RegExp = null;
         var _loc5_:String = null;
         super();
         this.vidContainer = new Sprite();
         addChild(this.vidContainer);
         this.m_contentPlayback = new MediaDisplayComponent();
         this.vidContainer.addChild(this.m_contentPlayback);
         this.m_contentPlayback.x = 1;
         this.m_contentPlayback.y = 1;
         this.m_contentPlayback.z = 1;
         this.m_contentPlayback.autoPlay = true;
         this.m_contentPlayback.autoRewind = false;
         this.m_contentPlayback.scaleMode = ScaleMode.UNIFORM;
         this.m_contentPlayback.setActualSize(this.m_width,this.m_height);
         this.m_adMgr = new UICartoonAdManager(this.m_contentPlayback);
         this.m_adMgr.setActualSize(this.m_width,this.m_height);
         this.m_adMgr.z = 2;
         this.m_adMgr.addEventListener(UIAdManagerEvent.AD_MANAGER_INIT_SUCCEEDED,this.onAdManagerInitialized);
         this.m_adMgr.addEventListener(UIAdManagerEvent.AD_MANAGER_INIT_FAILED,this.onAdManagerInitialized);
         this.m_adMgr.addEventListener(UIAdManagerEvent.AD_PLAY_STARTED,this.onLinearAdStarted);
         this.m_adMgr.addEventListener(UIAdManagerEvent.AD_PLAY_ENDED,this.onLinearAdEnded);
         this.vidContainer.addChild(this.m_adMgr);
         this.m_contentPlayback.addEventListener(BufferTimeEvent.BUFFER_TIME_STARTED,this.onBuffer);
         this.m_contentPlayback.addEventListener(BufferTimeEvent.BUFFER_TIME_PROGRESS,this.onBuffer);
         this.m_contentPlayback.addEventListener(BufferTimeEvent.BUFFER_TIME_STOPPED,this.onBuffer);
         this.m_contentPlayback.addEventListener(StateChangeEvent.STATE_CHANGED,this.onStateChanged);
         this.m_adMgr.adPlayback.addEventListener(TimeEvent.TIME_POSITION_CHANGED,this.onADTimePositionChanged);
         this.m_contentPlayback.addEventListener(DownloadEvent.DOWNLOAD_STARTED,this.onEvent);
         this.m_contentPlayback.addEventListener(DownloadEvent.DOWNLOAD_PROGRESS,this.onDownloadProgress);
         this.m_contentPlayback.addEventListener(MediaExceptionEvent.MEDIA_ASYNC_EXCEPTION,this.onEvent);
         this.m_contentPlayback.addEventListener(MediaExceptionEvent.MEDIA_IO_EXCEPTION,this.onError);
         this.m_contentPlayback.addEventListener(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,this.onEvent);
         this.m_configService = new GetConfigDelegate("/tools/xml/player_configs/player_games.xml");
         if(ExternalInterface.available)
         {
            _loc1_ = new String(ExternalInterface.call(" function(){ return document.location.href.toString();}"));
            _loc2_ = /fusionfall/g;
            _loc3_ = /gamecreator/g;
            _loc4_ = /stage/g;
            _loc5_ = _loc1_.toLowerCase();
            trace(_loc5_.search(_loc2_));
            FireBugConsole.log({
               "log":"Firebug url FOUND?",
               "val":_loc5_.search(_loc2_)
            });
            FireBugConsole.log({
               "log":"Firebug url",
               "val":_loc5_
            });
            if(_loc5_.search(_loc2_) != -1 || _loc5_.search(_loc3_) != -1 || _loc5_.search(_loc4_) != -1)
            {
               this.m_configService = new GetConfigDelegate("http://www.cartoonnetwork.com/tools/xml/player_configs/player_games.xml");
            }
         }
         this.m_configService.send().addResponder(new Responder(this.onConfigLoaded,this.onError));
      }
      
      public function close() : void
      {
         this.m_contentPlayback.stop();
      }
      
      protected function onConfigLoaded(param1:ResultEvent) : void
      {
         this.m_adMgr.config = param1.result.ads.freewheel;
         var _loc2_:CNMediaObject = new CNMediaObject("");
         var _loc3_:MediaContext = _loc2_.context;
         _loc2_.duration = 60;
         _loc3_.episodeID = "cn-all-games";
         if(ExternalInterface.available)
         {
            this.freeWheelSectionID = new String(ExternalInterface.call(" function(){ return freeWheelSectionID.toString();}"));
         }
         FireBugConsole.log({
            "log":"Section ID",
            "val":this.freeWheelSectionID
         });
         _loc3_.sectionID = this.freeWheelSectionID;
         this.m_adMgr.media = _loc2_;
      }
      
      protected function onError(param1:Event) : void
      {
      }
      
      protected function onAdManagerInitialized(param1:UIAdManagerEvent) : void
      {
         FireBugConsole.log({"log":"onAdManagerInitialized"});
         trace("* * * * * * * INIT AD * * * * * * *");
      }
      
      protected function onAdMuteToggled(param1:Event) : void
      {
         this.m_contentPlayback.muted = param1.target.selected;
      }
      
      protected function onLinearAdStarted(param1:UIAdManagerEvent) : void
      {
         FireBugConsole.log({"log":"onLinearAdStarted"});
         if(this.m_contentPlayback.state != "ended")
         {
         }
         trace("* * * * * AD STARTED",this.m_contentPlayback.state);
         this.adActive = true;
      }
      
      protected function onLinearAdEnded(param1:UIAdManagerEvent) : void
      {
         FireBugConsole.log({"log":"onLinearAdEnded"});
         if(ExternalInterface.available)
         {
            ExternalInterface.call("endAd");
         }
         this.adActive = false;
      }
      
      protected function onStateChanged(param1:StateChangeEvent) : void
      {
      }
      
      protected function onADTimePositionChanged(param1:TimeEvent) : void
      {
         if(this.m_adMgr.adPlayback.duration > this.m_adMgr.adPlayback.currentTime)
         {
         }
      }
      
      protected function onDownloadProgress(param1:DownloadEvent) : void
      {
         trace(param1);
      }
      
      protected function onBuffer(param1:BufferTimeEvent) : void
      {
      }
      
      protected function onSeek(param1:VideoControlEvent) : void
      {
         trace("SEEK onSeek");
      }
      
      protected function onSeekComplete(param1:VideoControlEvent) : void
      {
         trace("SEEK onSeekComplete");
      }
      
      internal function onEvent(param1:Object) : void
      {
         trace(param1);
      }
   }
}

