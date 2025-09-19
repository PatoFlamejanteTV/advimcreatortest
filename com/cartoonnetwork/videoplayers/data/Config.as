package com.cartoonnetwork.videoplayers.data
{
   import com.cartoonnetwork.videoplayers.ads.AdConfig;
   import com.cartoonnetwork.videoplayers.tracking.TrackingConfig;
   
   public class Config
   {
      
      protected static var k_instance:Config;
      
      public var ads:AdConfig;
      
      public var playback:PlaybackConfig;
      
      public var serviceConfigURL:String;
      
      public var sharing:SharingConfig;
      
      public var tracking:TrackingConfig;
      
      public function Config()
      {
         super();
      }
      
      public static function getInstance() : Config
      {
         if(Config.k_instance == null)
         {
            Config.k_instance = new Config();
         }
         return Config.k_instance;
      }
   }
}

