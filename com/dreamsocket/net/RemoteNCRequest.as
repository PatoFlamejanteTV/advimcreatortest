package com.dreamsocket.net
{
   public class RemoteNCRequest
   {
      
      public var app:String;
      
      public var client:Object;
      
      public var port:String;
      
      public var protocol:String;
      
      public var URL:String;
      
      public var server:String;
      
      public function RemoteNCRequest()
      {
         super();
      }
      
      public function clone() : RemoteNCRequest
      {
         var _loc1_:RemoteNCRequest = null;
         _loc1_.app = this.app;
         _loc1_.client = this.client;
         _loc1_.port = _loc1_.port;
         _loc1_.protocol = _loc1_.protocol;
         _loc1_.server = _loc1_.server;
         _loc1_.URL = _loc1_.URL;
         return _loc1_;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "NCRequest\n";
         _loc1_ += "\t" + "app:" + this.app + "\n";
         _loc1_ += "\t" + "port:" + this.port + "\n";
         _loc1_ += "\t" + "protocol:" + this.protocol + "\n";
         _loc1_ += "\t" + "server:" + this.server + "\n";
         return _loc1_ + ("\t" + "URL:" + this.URL + "\n");
      }
   }
}

