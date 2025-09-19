package com.dreamsocket.ads.freewheel
{
   public class FreeWheelConfigXMLDecoder
   {
      
      public function FreeWheelConfigXMLDecoder()
      {
         super();
      }
      
      public function decode(param1:XML) : FreeWheelConfig
      {
         var _loc2_:FreeWheelConfig = new FreeWheelConfig();
         if(param1 == null)
         {
            return _loc2_;
         }
         _loc2_.enabled = param1.enabled == "true";
         _loc2_.externalAdsEnabled = param1.externalAdsEnabled == "true";
         if(param1.componentURL.toString().length)
         {
            _loc2_.componentURL = param1.componentURL.toString();
         }
         if(param1.logLevel.toString().length)
         {
            _loc2_.logLevel = param1.logLevel.toString();
         }
         if(param1.networkID.toString().length)
         {
            _loc2_.networkID = uint(param1.networkID.toString());
         }
         if(param1.profile.toString().length)
         {
            _loc2_.profile = param1.profile.toString();
         }
         if(param1.rendererConfigURL.toString().length)
         {
            _loc2_.rendererConfigURL = param1.rendererConfigURL.toString();
         }
         if(param1.server.toString().length)
         {
            _loc2_.server = param1.server.toString();
         }
         if(param1.version.toString().length)
         {
            _loc2_.version = int(param1.version.toString());
         }
         if(param1.videoAssetID.toString().length)
         {
            _loc2_.videoAssetID = param1.videoAssetID.toString();
         }
         if(param1.liveAdRefreshRate.toString().length)
         {
            _loc2_.liveAdRefreshRate = Number(param1.liveAdRefreshRate.toString());
         }
         else
         {
            _loc2_.liveAdRefreshRate = 900;
         }
         if(param1.videoDuration.toString().length)
         {
            _loc2_.videoDuration = param1.videoDuration.toString();
         }
         if(param1.videoSectionID.toString().length)
         {
            _loc2_.videoSectionID = param1.videoSectionID.toString();
         }
         return _loc2_;
      }
   }
}

