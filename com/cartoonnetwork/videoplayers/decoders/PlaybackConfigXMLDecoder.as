package com.cartoonnetwork.videoplayers.decoders
{
   import com.cartoonnetwork.videoplayers.data.PlaybackConfig;
   
   public class PlaybackConfigXMLDecoder
   {
      
      public function PlaybackConfigXMLDecoder()
      {
         super();
      }
      
      public function decode(param1:XML) : PlaybackConfig
      {
         var _loc2_:PlaybackConfig = new PlaybackConfig();
         if(param1 == null)
         {
            return _loc2_;
         }
         _loc2_.autoPlay = param1.autoPlay != "false";
         _loc2_.muteOnAutoPlay = param1.muteOnAutoPlay == "true";
         _loc2_.continuousPlay = param1.continuousPlay == "true";
         return _loc2_;
      }
   }
}

