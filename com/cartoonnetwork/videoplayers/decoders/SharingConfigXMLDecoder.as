package com.cartoonnetwork.videoplayers.decoders
{
   import com.cartoonnetwork.videoplayers.data.SharingConfig;
   
   public class SharingConfigXMLDecoder
   {
      
      public function SharingConfigXMLDecoder()
      {
         super();
      }
      
      public function decode(param1:XML) : SharingConfig
      {
         var _loc2_:SharingConfig = new SharingConfig();
         if(param1 == null)
         {
            return _loc2_;
         }
         _loc2_.embedCode = param1.embedCode;
         return _loc2_;
      }
   }
}

