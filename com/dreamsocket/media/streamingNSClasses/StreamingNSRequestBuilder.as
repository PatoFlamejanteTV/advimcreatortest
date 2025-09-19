package com.dreamsocket.media.streamingNSClasses
{
   import com.dreamsocket.net.RemoteNCRequest;
   import com.dreamsocket.utils.URLUtil;
   
   public class StreamingNSRequestBuilder implements IStreamingNSRequestBuilder
   {
      
      public var addStreamExtension:Boolean;
      
      public var addStreamType:Boolean;
      
      public var addQueryToNCRequest:Boolean;
      
      public var addQueryToNSRequest:Boolean;
      
      public var allowNCReuse:Boolean;
      
      public var app:String;
      
      public var createTypeUsingExtension:Boolean;
      
      public var port:String;
      
      public var queryParameters:String;
      
      public var server:String;
      
      public function StreamingNSRequestBuilder(param1:Object)
      {
         super();
         this.allowNCReuse = param1.allowNCReuse == null ? true : Boolean(param1.allowNCReuse);
         this.addQueryToNCRequest = param1.addQueryToNCRequest == true;
         this.addQueryToNSRequest = param1.addQueryToNSRequest == true;
         this.app = param1.app;
         this.createTypeUsingExtension = param1.createTypeUsingExtension == true;
         this.server = param1.server;
         this.addStreamType = param1.addStreamType == true;
         this.addStreamExtension = param1.addStreamExtension == true;
         this.queryParameters = param1.queryParameters;
      }
      
      public function createRequest(param1:String) : StreamingNSRequest
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc2_:StreamingNSRequest = new StreamingNSRequest();
         var _loc3_:RemoteNCRequest = _loc2_.ncRequest;
         var _loc4_:String = URLUtil.getBasePath(param1);
         var _loc5_:Array = _loc4_ == null ? [] : _loc4_.slice(0,_loc4_.indexOf("?") == -1 ? _loc4_.length : Number(_loc4_.indexOf("?"))).split("/");
         if(this.app != null && this.app.charAt(0) != "/")
         {
            this.app = "/" + this.app;
         }
         if(this.app != null && this.app.charAt(this.app.length - 1) != "/")
         {
            this.app += "/";
         }
         _loc2_.streamPath = String(_loc5_.pop());
         _loc2_.URL = param1;
         _loc3_.server = this.server != null && param1.indexOf(this.server) != -1 ? this.server : URLUtil.getServer(param1);
         _loc3_.protocol = URLUtil.getProtocol(param1);
         _loc3_.port = this.port != null ? this.port : URLUtil.getPort(param1);
         _loc2_.queryParameters = URLUtil.getQuery(param1);
         _loc3_.app = this.app != null && param1.indexOf(this.app) != -1 ? this.app : String(_loc5_.join("/")) + "/";
         _loc2_.allowNCReuse = this.allowNCReuse;
         _loc6_ = param1.substring(param1.indexOf(_loc3_.app) + _loc3_.app.length,param1.indexOf("?") != -1 ? Number(param1.indexOf("?")) : param1.length);
         _loc8_ = _loc6_.lastIndexOf(":") == -1 ? null : _loc6_.slice(0,_loc6_.lastIndexOf(":"));
         _loc6_ = _loc6_.split(_loc8_ + ":").join("");
         _loc7_ = _loc6_.lastIndexOf(".") == -1 ? null : _loc6_.slice(_loc6_.lastIndexOf(".") + 1);
         _loc2_.streamExtension = _loc7_ != null ? _loc7_.toLowerCase() : null;
         _loc2_.streamName = _loc6_.split("." + _loc7_).join("");
         _loc2_.streamType = _loc8_;
         this.createStreamAndNCPaths(_loc2_);
         return _loc2_;
      }
      
      public function reconfigureRequest(param1:StreamingNSRequest) : Boolean
      {
         var _loc2_:RemoteNCRequest = param1.ncRequest;
         var _loc3_:Number = Number(_loc2_.app.substr(0,_loc2_.app.length - 1).lastIndexOf("/"));
         if(_loc2_.app == null || Boolean(_loc2_.app.split("/").length < 4))
         {
            return false;
         }
         param1.streamName = _loc2_.app.slice(_loc3_ + 1) + param1.streamName;
         _loc2_.app = _loc2_.app.slice(0,_loc3_ + 1);
         this.createStreamAndNCPaths(param1);
         return true;
      }
      
      protected function createStreamAndNCPaths(param1:StreamingNSRequest) : void
      {
         var _loc2_:StreamingNSFileTypeRegistry = StreamingNSFileTypeRegistry.getInstance();
         var _loc3_:RemoteNCRequest = param1.ncRequest;
         param1.streamPath = param1.streamName;
         if(this.addStreamType)
         {
            if(param1.streamType != null && _loc2_.containsFileType(param1.streamType))
            {
               param1.streamPath = _loc2_.getFileTypeAlias(param1.streamType) + ":" + param1.streamName;
            }
            else if(this.createTypeUsingExtension && param1.streamExtension != null && _loc2_.containsFileType(param1.streamExtension))
            {
               param1.streamPath = _loc2_.getFileTypeAlias(param1.streamExtension) + ":" + param1.streamName;
            }
         }
         if(this.addStreamExtension && param1.streamExtension != null)
         {
            param1.streamPath += "." + param1.streamExtension;
         }
         if(this.addQueryToNSRequest && param1.queryParameters != null)
         {
            param1.streamPath += param1.queryParameters;
         }
         var _loc4_:* = _loc3_.protocol + "://";
         _loc4_ = _loc4_ + (_loc3_.server == null ? "" : _loc3_.server);
         _loc4_ = _loc4_ + (_loc3_.port != null ? ":" + _loc3_.port : "");
         _loc4_ = _loc4_ + _loc3_.app;
         _loc3_.URL = _loc4_;
         if(this.addQueryToNCRequest && param1.queryParameters != null)
         {
            _loc3_.URL += param1.queryParameters;
         }
      }
   }
}

