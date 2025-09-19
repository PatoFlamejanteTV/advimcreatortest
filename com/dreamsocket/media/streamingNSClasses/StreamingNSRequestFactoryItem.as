package com.dreamsocket.media.streamingNSClasses
{
   public class StreamingNSRequestFactoryItem
   {
      
      public var app:String;
      
      public var fileType:String;
      
      public var server:String;
      
      public var requestBuilder:StreamingNSRequestBuilder;
      
      public function StreamingNSRequestFactoryItem(param1:String, param2:String, param3:String, param4:StreamingNSRequestBuilder)
      {
         super();
         this.server = param1;
         this.app = param2;
         this.fileType = param3;
         this.requestBuilder = param4;
      }
   }
}

