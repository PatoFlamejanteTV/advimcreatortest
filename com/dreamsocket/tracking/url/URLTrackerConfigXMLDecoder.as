package com.dreamsocket.tracking.url
{
   import flash.utils.Dictionary;
   
   public class URLTrackerConfigXMLDecoder
   {
      
      public function URLTrackerConfigXMLDecoder()
      {
         super();
      }
      
      public function decode(param1:XML) : URLTrackerConfig
      {
         var _loc4_:XML = null;
         var _loc2_:URLTrackerConfig = new URLTrackerConfig();
         var _loc3_:XMLList = param1.trackHandlers.trackHandler;
         var _loc5_:Dictionary = _loc2_.trackHandlers;
         for each(_loc4_ in _loc3_)
         {
            this.addTrack(_loc5_,_loc4_);
         }
         _loc2_.enabled = param1.enabled.toString() != "false";
         return _loc2_;
      }
      
      protected function addTrack(param1:Dictionary, param2:XML) : void
      {
         var _loc4_:XML = null;
         var _loc5_:URLTrackHandler = null;
         var _loc3_:String = param2.ID.toString();
         if(_loc3_.length > 0)
         {
            _loc5_ = new URLTrackHandler();
            for each(_loc4_ in param2.URLs.URL)
            {
               _loc5_.URLs.push(_loc4_.toString());
            }
            param1[_loc3_] = _loc5_;
         }
      }
   }
}

