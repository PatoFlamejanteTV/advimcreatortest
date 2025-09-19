package com.dreamsocket.ads.freewheel
{
   import tv.freewheel.ad.behavior.IAdManager;
   import tv.freewheel.ad.behavior.IConstants;
   
   public class FreeWheelUtil
   {
      
      public function FreeWheelUtil()
      {
         super();
      }
      
      public static function isAdLinear(param1:IAdManager, param2:String) : Boolean
      {
         var _loc3_:IConstants = param1.getConstants();
         switch(param1.getSlotByCustomId(param2).getTimePositionClass())
         {
            case _loc3_.TIME_POSITION_CLASS_MIDROLL:
            case _loc3_.TIME_POSITION_CLASS_POSTROLL:
            case _loc3_.TIME_POSITION_CLASS_PREROLL:
               return true;
            default:
               return false;
         }
      }
   }
}

