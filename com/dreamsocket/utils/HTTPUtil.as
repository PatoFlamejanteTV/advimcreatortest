package com.dreamsocket.utils
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.Security;
   import flash.utils.Dictionary;
   
   public class HTTPUtil
   {
      
      public static var allowLocalQueryStrings:Boolean = false;
      
      protected static var k_pings:Dictionary = new Dictionary();
      
      public function HTTPUtil()
      {
         super();
      }
      
      public static function pingURL(param1:String, param2:Boolean = true, param3:Number = 0) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc4_:URLLoader = new URLLoader();
         var _loc5_:String = param1;
         if(param2 && (HTTPUtil.allowLocalQueryStrings || Security.sandboxType == Security.REMOTE))
         {
            _loc5_ = HTTPUtil.resolveUniqueURL(param1,param3);
         }
         _loc4_.load(new URLRequest(_loc5_));
         _loc4_.addEventListener(Event.COMPLETE,HTTPUtil.onPingResult);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,HTTPUtil.onPingResult);
         _loc4_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,HTTPUtil.onPingResult);
         HTTPUtil.k_pings[_loc4_] = true;
      }
      
      public static function addQueryParam(param1:String, param2:String, param3:String, param4:String = null) : String
      {
         if(HTTPUtil.allowLocalQueryStrings || Security.sandboxType == Security.REMOTE)
         {
            if(param4 == null)
            {
               param1 += param1.indexOf("?") != -1 ? "&" + param2 + "=" : "?" + param2 + "=";
            }
            else
            {
               param1 += param4 + param2 + "=";
            }
            param1 += param3 != null ? escape(param3) : "";
         }
         return param1;
      }
      
      public static function resolveUniqueURL(param1:String, param2:Number = 0) : String
      {
         var _loc3_:String = param1;
         if((HTTPUtil.allowLocalQueryStrings || Security.sandboxType == Security.REMOTE) && param1.indexOf("&cacheID=") == -1 && param1.indexOf("?cacheID=") == -1)
         {
            _loc3_ = HTTPUtil.addQueryParam(param1,"cacheID",HTTPUtil.getUniqueCacheID(param2));
         }
         return _loc3_;
      }
      
      public static function getUniqueCacheID(param1:Number = 0) : String
      {
         var _loc3_:String = null;
         var _loc2_:Date = new Date();
         var _loc4_:Number = 60 * _loc2_.getUTCMinutes() + _loc2_.getUTCSeconds();
         if(param1 == 0)
         {
            _loc3_ = String(_loc2_.valueOf());
         }
         else
         {
            _loc3_ = _loc2_.getUTCFullYear() + "" + _loc2_.getUTCMonth() + "" + _loc2_.getUTCDate() + "" + _loc2_.getUTCHours() + "-" + Math.floor(_loc4_ / param1);
         }
         return _loc3_;
      }
      
      protected static function onPingResult(param1:Event) : void
      {
         URLLoader(param1.target).removeEventListener(Event.COMPLETE,HTTPUtil.onPingResult);
         URLLoader(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,HTTPUtil.onPingResult);
         URLLoader(param1.target).removeEventListener(SecurityErrorEvent.SECURITY_ERROR,HTTPUtil.onPingResult);
         delete HTTPUtil.k_pings[param1.target];
      }
   }
}

