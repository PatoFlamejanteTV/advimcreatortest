package com.cartoonnetwork.videoplayers.ads
{
   import com.cartoonnetwork.videoplayers.data.CNMediaObject;
   import com.dreamsocket.ads.freewheel.UIAdManager;
   import com.dreamsocket.ads.freewheel.UIAdManagerEvent;
   import com.dreamsocket.flash.components.mediaClasses.AbstractPlaybackComponent;
   
   public class UICartoonAdManager extends UIAdManager
   {
      
      protected var m_adMessage:UIAdMessage;
      
      protected var m_fwTrackMgr:FreeWheelTrackManager;
      
      public function UICartoonAdManager(param1:AbstractPlaybackComponent)
      {
         super(param1);
         this.m_fwTrackMgr = new FreeWheelTrackManager();
         this.m_adMessage = new UIAdMessage();
         this.m_adMessage.playback = this.m_fwPlayback;
         this.m_adMessage.visible = false;
         this.addChild(this.m_adMessage);
         this.addEventListener(UIAdManagerEvent.AD_PLAYLIST_REQUESTED,this.onAdsRequested);
      }
      
      override protected function teardownAdManager() : void
      {
         super.teardownAdManager();
         this.m_fwTrackMgr.adManager = null;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.m_adMessage.width = param1;
      }
      
      override protected function onAdManagerLoaded(param1:Boolean, param2:String) : void
      {
         super.onAdManagerLoaded(param1,param2);
         if(param1)
         {
            this.m_fwTrackMgr.adManager = this.m_fwAdMgr;
         }
      }
      
      protected function onAdsRequested(param1:UIAdManagerEvent) : void
      {
         this.m_fwTrackMgr.mediaContext = CNMediaObject(this.media).context;
      }
   }
}

