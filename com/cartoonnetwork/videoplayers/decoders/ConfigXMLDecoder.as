package com.cartoonnetwork.videoplayers.decoders
{
   import com.cartoonnetwork.videoplayers.ads.AdConfigXMLDecoder;
   import com.cartoonnetwork.videoplayers.data.Config;
   import com.cartoonnetwork.videoplayers.tracking.TrackingConfigXMLDecoder;
   
   public class ConfigXMLDecoder
   {
      
      public function ConfigXMLDecoder()
      {
         super();
      }
      
      public function decode(param1:XML) : Config
      {
         var _loc2_:Config = Config.getInstance();
         _loc2_.serviceConfigURL = param1.serviceConfigURL;
         _loc2_.ads = new AdConfigXMLDecoder().decode(param1.ads[0]);
         _loc2_.playback = new PlaybackConfigXMLDecoder().decode(param1.playback[0]);
         _loc2_.sharing = new SharingConfigXMLDecoder().decode(param1.sharing[0]);
         _loc2_.tracking = new TrackingConfigXMLDecoder().decode(param1.tracking[0]);
         return _loc2_;
      }
   }
}

