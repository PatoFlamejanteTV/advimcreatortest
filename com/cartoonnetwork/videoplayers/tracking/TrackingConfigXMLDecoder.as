package com.cartoonnetwork.videoplayers.tracking
{
   import com.dreamsocket.tracking.omniture.OmnitureTrackerConfigXMLDecoder;
   import com.dreamsocket.tracking.url.URLTrackerConfigXMLDecoder;
   
   public class TrackingConfigXMLDecoder
   {
      
      public function TrackingConfigXMLDecoder()
      {
         super();
      }
      
      public function decode(param1:XML) : TrackingConfig
      {
         var _loc2_:TrackingConfig = new TrackingConfig();
         _loc2_.enabled = param1.enabled != "false";
         if(param1.omniture[0] != null)
         {
            _loc2_.omniture = new OmnitureTrackerConfigXMLDecoder().decode(param1.omniture[0]);
         }
         if(param1.URL[0] != null)
         {
            _loc2_.URL = new URLTrackerConfigXMLDecoder().decode(param1.URL[0]);
         }
         return _loc2_;
      }
   }
}

