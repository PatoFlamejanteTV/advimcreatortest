package com.dreamsocket.tracking.omniture
{
   public class OmnitureTrackHandler
   {
      
      public var ID:String;
      
      public var method:String;
      
      public var name:String;
      
      public var params:OmnitureParams;
      
      public var type:String;
      
      public var URL:String;
      
      public function OmnitureTrackHandler()
      {
         super();
         this.params = new OmnitureParams();
      }
   }
}

