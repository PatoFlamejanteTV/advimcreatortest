package com.dreamsocket.tracking.url
{
   import flash.utils.Dictionary;
   
   public class URLTrackerConfig
   {
      
      public var enabled:Boolean;
      
      public var trackHandlers:Dictionary;
      
      public function URLTrackerConfig()
      {
         super();
         this.trackHandlers = new Dictionary();
      }
   }
}

