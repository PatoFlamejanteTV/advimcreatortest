package com.cartoonnetwork.videoplayers.ads
{
   import com.dreamsocket.ads.freewheel.FreeWheelConfigXMLDecoder;
   
   public class AdConfigXMLDecoder
   {
      
      public function AdConfigXMLDecoder()
      {
         super();
      }
      
      public function decode(param1:XML) : AdConfig
      {
         var _loc2_:AdConfig = new AdConfig();
         _loc2_.enabled = param1.enabled == "true";
         _loc2_.freewheel = new FreeWheelConfigXMLDecoder().decode(param1.freewheel[0]);
         _loc2_.freewheel.enabled = _loc2_.enabled && _loc2_.freewheel.enabled;
         return _loc2_;
      }
   }
}

