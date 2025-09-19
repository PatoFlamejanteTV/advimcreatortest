package com.cartoonnetwork.videoplayers.tracking
{
   import com.dreamsocket.tracking.omniture.OmnitureTrackerConfig;
   import com.dreamsocket.tracking.url.URLTrackerConfig;
   
   public class TrackingConfig
   {
      
      public var enabled:Boolean;
      
      public var omniture:OmnitureTrackerConfig;
      
      public var URL:URLTrackerConfig;
      
      public function TrackingConfig()
      {
         super();
      }
   }
}

