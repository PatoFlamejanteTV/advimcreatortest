package com.cartoonnetwork.events
{
   import flash.events.Event;
   
   public class SiteLoaderEvent extends Event
   {
      
      public static const COMPLETE:String = "SiteLoaderEvent.COMPLETE";
      
      public static const PROGRESS:String = "SiteLoaderEvent.PROGRESS";
      
      public static const ERROR:String = "SiteLoaderEvent.ERROR";
      
      public var percent:Number;
      
      public function SiteLoaderEvent(param1:String, param2:Boolean = false, param3:Number = 0)
      {
         super(param1,param2);
         this.percent = param3;
      }
      
      override public function toString() : String
      {
         var _loc1_:String = null;
         if(type == PROGRESS)
         {
            _loc1_ = formatToString("SiteLoaderEvent","type","bubbles","cancelable","eventPhase","percent");
         }
         else
         {
            _loc1_ = formatToString("SiteLoaderEvent","type","bubbles","cancelable","eventPhase");
         }
         return _loc1_;
      }
   }
}

