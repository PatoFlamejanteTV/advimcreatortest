package com.dreamsocket.tracking
{
   import flash.utils.Dictionary;
   
   public class TrackingManager
   {
      
      protected static var k_enabled:Boolean = true;
      
      protected static var k_trackers:Dictionary = new Dictionary();
      
      public function TrackingManager()
      {
         super();
      }
      
      public static function get enabled() : Boolean
      {
         return k_enabled;
      }
      
      public static function set enabled(param1:Boolean) : void
      {
         k_enabled = param1;
      }
      
      public static function track(param1:ITrack) : void
      {
         var _loc2_:Object = null;
         if(!k_enabled)
         {
            return;
         }
         for each(_loc2_ in k_trackers)
         {
            ITracker(_loc2_).track(param1);
         }
      }
      
      public static function addTracker(param1:String, param2:ITracker) : void
      {
         k_trackers[param1] = param2;
      }
      
      public static function getTracker(param1:String) : ITracker
      {
         return k_trackers[param1] as ITracker;
      }
      
      public static function removeTracker(param1:String) : void
      {
         delete k_trackers[param1];
      }
   }
}

