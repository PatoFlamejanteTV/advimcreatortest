package com.dreamsocket.media.streamingNSClasses
{
   public class StreamingNSRequestFactory implements IStreamingNSRequestBuilder
   {
      
      protected static var k_instance:StreamingNSRequestFactory;
      
      protected var m_builders:Array;
      
      public function StreamingNSRequestFactory()
      {
         super();
         this.m_builders = [];
      }
      
      public static function getInstance() : StreamingNSRequestFactory
      {
         if(k_instance == null)
         {
            k_instance = new StreamingNSRequestFactory();
            k_instance.addBuilder("*","*","mp3",new StreamingNSRequestBuilder({
               "allowNCReuse":true,
               "addStreamExtension":false,
               "addStreamType":true,
               "createTypeUsingExtension":true
            }));
            k_instance.addBuilder("*","*","*",new StreamingNSRequestBuilder({
               "allowNCReuse":true,
               "addStreamExtension":true,
               "addStreamType":true,
               "createTypeUsingExtension":true
            }));
            k_instance.addBuilder("*","*","flv",new StreamingNSRequestBuilder({
               "allowNCReuse":true,
               "addStreamExtension":false,
               "addStreamType":false,
               "createTypeUsingExtension":true
            }));
         }
         return k_instance;
      }
      
      public function get builderList() : Array
      {
         return this.m_builders.slice(0);
      }
      
      public function addBuilder(param1:String, param2:String, param3:String, param4:StreamingNSRequestBuilder) : void
      {
         this.m_builders.push(new StreamingNSRequestFactoryItem(param1,param2,param3,param4));
      }
      
      public function createRequest(param1:String) : StreamingNSRequest
      {
         return this.getBuilderForURL(param1).createRequest(param1);
      }
      
      public function reconfigureRequest(param1:StreamingNSRequest) : Boolean
      {
         return this.getBuilderForURL(param1.URL).reconfigureRequest(param1);
      }
      
      public function getBuilderForURL(param1:String) : IStreamingNSRequestBuilder
      {
         var _loc3_:int = 0;
         var _loc5_:StreamingNSRequestFactoryItem = null;
         var _loc7_:* = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:* = false;
         var _loc11_:Boolean = false;
         var _loc12_:* = false;
         var _loc2_:IStreamingNSRequestBuilder = new StreamingNSRequestBuilder({
            "useStreamExtension":true,
            "useStreamType":true
         });
         var _loc4_:int = -1;
         var _loc6_:int = int(this.m_builders.length);
         while(_loc6_--)
         {
            _loc5_ = StreamingNSRequestFactoryItem(this.m_builders[_loc6_]);
            _loc8_ = Boolean(param1.indexOf(_loc5_.server) != -1);
            _loc7_ = _loc5_.server == "*";
            _loc9_ = Boolean(param1.indexOf(_loc5_.app) != -1);
            _loc10_ = _loc5_.app == "*";
            _loc11_ = Boolean(param1.indexOf("." + _loc5_.fileType) != -1) || Boolean(param1.indexOf(_loc5_.fileType + ":") != -1);
            _loc12_ = _loc5_.fileType == "*";
            if(_loc8_ && _loc9_ && _loc11_)
            {
               return _loc5_.requestBuilder;
            }
            if(!(!_loc9_ && !_loc10_ || !_loc8_ && !_loc7_ || !_loc11_ && !_loc12_))
            {
               if(_loc7_ && _loc9_ && _loc11_)
               {
                  _loc3_ = 7;
               }
               else if(_loc8_ && _loc9_ && _loc12_)
               {
                  _loc3_ = 6;
               }
               else if(_loc7_ && _loc9_ && _loc12_)
               {
                  _loc3_ = 5;
               }
               else if(_loc8_ && _loc10_ && _loc11_)
               {
                  _loc3_ = 4;
               }
               else if(_loc8_ && _loc10_ && _loc12_)
               {
                  _loc3_ = 3;
               }
               else if(_loc7_ && _loc10_ && _loc11_)
               {
                  _loc3_ = 2;
               }
               else
               {
                  _loc3_ = 1;
               }
               if(_loc3_ > _loc4_)
               {
                  _loc4_ = _loc3_;
                  _loc2_ = _loc5_.requestBuilder;
               }
            }
         }
         return _loc2_;
      }
   }
}

