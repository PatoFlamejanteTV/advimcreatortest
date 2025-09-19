package com.cartoonnetwork.videoplayers.ads
{
   import com.cartoonnetwork.videoplayers.data.MediaContext;
   import com.dreamsocket.ads.freewheel.FreeWheelUtil;
   import com.dreamsocket.tracking.Track;
   import com.dreamsocket.tracking.TrackingManager;
   import tv.freewheel.ad.behavior.IAdManager;
   import tv.freewheel.ad.behavior.IConstants;
   import tv.freewheel.ad.behavior.IEvent;
   
   public class FreeWheelTrackManager
   {
      
      protected var m_adMgr:IAdManager;
      
      protected var m_adConsts:IConstants;
      
      protected var m_mediaContext:MediaContext;
      
      public function FreeWheelTrackManager()
      {
         super();
      }
      
      public function get adManager() : IAdManager
      {
         return this.m_adMgr;
      }
      
      public function set adManager(param1:IAdManager) : void
      {
         if(param1 != this.m_adMgr)
         {
            if(this.m_adMgr != null)
            {
               this.m_adMgr.removeEventListener(this.m_adConsts.EVENT_RENDERER,this.onRendererEvent);
               this.m_adMgr.removeEventListener(this.m_adConsts.EVENT_SLOT_STARTED,this.onSlotStarted);
               this.m_adMgr.removeEventListener(this.m_adConsts.EVENT_SLOT_ENDED,this.onSlotEnded);
            }
            this.m_adMgr = param1;
            if(param1 != null)
            {
               this.m_adConsts = param1.getConstants();
               this.m_adMgr.addEventListener(this.m_adConsts.EVENT_RENDERER,this.onRendererEvent);
               this.m_adMgr.addEventListener(this.m_adConsts.EVENT_SLOT_STARTED,this.onSlotStarted);
               this.m_adMgr.addEventListener(this.m_adConsts.EVENT_SLOT_ENDED,this.onSlotEnded);
            }
         }
      }
      
      public function get mediaContext() : MediaContext
      {
         return this.m_mediaContext;
      }
      
      public function set mediaContext(param1:MediaContext) : void
      {
         this.m_mediaContext = param1;
      }
      
      protected function performTrack(param1:String, param2:String) : void
      {
         TrackingManager.track(new Track(param1,{
            "adID":param2,
            "context":this.m_mediaContext
         }));
      }
      
      protected function onSlotEnded(param1:IEvent) : void
      {
         if(!FreeWheelUtil.isAdLinear(this.m_adMgr,param1.slotCustomId))
         {
            return;
         }
         this.performTrack("adSlotEnded",String(param1.creativeId));
      }
      
      protected function onSlotStarted(param1:IEvent) : void
      {
         if(!FreeWheelUtil.isAdLinear(this.m_adMgr,param1.slotCustomId))
         {
            return;
         }
         this.performTrack("adSlotStarted",String(param1.creativeId));
         this.performTrack("adRequested",String(param1.creativeId));
      }
      
      protected function onRendererEvent(param1:IEvent) : void
      {
         if(!FreeWheelUtil.isAdLinear(this.m_adMgr,param1.slotCustomId))
         {
            return;
         }
         switch(param1.subType)
         {
            case String(this.m_adConsts.RENDERER_EVENT_IMPRESSION):
               this.performTrack("adStarted",String(param1.creativeId));
               break;
            case String(this.m_adConsts.RENDERER_EVENT_MIDPOINT):
               this.performTrack("adMidComplete",String(param1.creativeId));
               break;
            case String(this.m_adConsts.RENDERER_EVENT_COMPLETE):
               this.performTrack("adEnded",String(param1.creativeId));
         }
      }
   }
}

