package com.dreamsocket.tracking.omniture
{
   import flash.utils.Dictionary;
   
   public class OmnitureTrackerConfig
   {
      
      public var enabled:Boolean;
      
      public var params:OmnitureParams;
      
      public var trackHandlers:Dictionary;
      
      public function OmnitureTrackerConfig()
      {
         super();
         this.params = new OmnitureParams();
         this.trackHandlers = new Dictionary();
      }
   }
}

