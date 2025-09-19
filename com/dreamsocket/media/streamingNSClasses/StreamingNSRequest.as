package com.dreamsocket.media.streamingNSClasses
{
   import com.dreamsocket.net.RemoteNCRequest;
   
   public class StreamingNSRequest
   {
      
      public var allowNCReuse:Boolean;
      
      public var client:Object;
      
      public var streamName:String;
      
      public var streamExtension:String;
      
      public var streamPath:String;
      
      public var streamType:String;
      
      public var ncRequest:RemoteNCRequest;
      
      public var queryParameters:String;
      
      public var URL:String;
      
      public function StreamingNSRequest()
      {
         super();
         this.allowNCReuse = true;
         this.ncRequest = new RemoteNCRequest();
         this.ncRequest.client = new StreamingNSNCClient();
      }
      
      public function clone() : StreamingNSRequest
      {
         var _loc1_:StreamingNSRequest = null;
         _loc1_.allowNCReuse = this.allowNCReuse;
         _loc1_.client = this.client;
         _loc1_.ncRequest = this.ncRequest.clone();
         _loc1_.queryParameters = this.queryParameters;
         _loc1_.streamExtension = this.streamExtension;
         _loc1_.streamName = this.streamName;
         _loc1_.streamPath = this.streamPath;
         _loc1_.streamType = this.streamType;
         _loc1_.URL = this.URL;
         return _loc1_;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "StreamingNSRequest\n";
         _loc1_ += "\t" + "allowNCReuse:" + this.allowNCReuse + "\n";
         _loc1_ += "\t" + "ncRequest:" + this.ncRequest.toString() + "\n";
         _loc1_ += "\t" + "queryParameters:" + this.queryParameters + "\n";
         _loc1_ += "\t" + "streamExtension:" + this.streamExtension + "\n";
         _loc1_ += "\t" + "streamName:" + this.streamName + "\n";
         _loc1_ += "\t" + "streamPath:" + this.streamPath + "\n";
         _loc1_ += "\t" + "streamType:" + this.streamType + "\n";
         return _loc1_ + ("\t" + "URL:" + this.URL + "\n");
      }
   }
}

