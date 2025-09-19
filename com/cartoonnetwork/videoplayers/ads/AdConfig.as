package com.cartoonnetwork.videoplayers.ads
{
   import com.dreamsocket.ads.freewheel.FreeWheelConfig;
   
   public class AdConfig
   {
      
      public var enabled:Boolean;
      
      public var freewheel:FreeWheelConfig;
      
      public function AdConfig()
      {
         super();
         this.freewheel = new FreeWheelConfig();
      }
   }
}

