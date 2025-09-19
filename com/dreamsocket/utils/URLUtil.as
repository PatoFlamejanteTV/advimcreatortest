package com.dreamsocket.utils
{
   public class URLUtil
   {
      
      public function URLUtil()
      {
         super();
      }
      
      public static function getPort(param1:String = "") : String
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = Number(param1.indexOf("://"));
         if(_loc2_ >= 0)
         {
            _loc2_ += 3;
            _loc3_ = Number(param1.indexOf(":",_loc2_));
            _loc4_ = Number(param1.indexOf("/",_loc2_));
            if(_loc4_ < 0 && _loc3_ >= 0)
            {
               return param1.slice(_loc3_ + 1);
            }
            if(_loc3_ >= 0 && _loc3_ < _loc4_)
            {
               return param1.slice(_loc3_ + 1,_loc4_);
            }
         }
         return null;
      }
      
      public static function getProtocol(param1:String = "") : String
      {
         var _loc2_:Number = Number(param1.indexOf(":/"));
         if(_loc2_ >= 0)
         {
            return param1.slice(0,_loc2_).toLowerCase();
         }
         return null;
      }
      
      public static function getQuery(param1:String) : String
      {
         var _loc2_:Number = Number(param1.indexOf("?"));
         if(_loc2_ >= 0)
         {
            return param1.slice(_loc2_);
         }
         return null;
      }
      
      public static function getServer(param1:String = "") : String
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = Number(param1.indexOf("://"));
         if(_loc2_ >= 0)
         {
            _loc2_ += 3;
            _loc3_ = Number(param1.indexOf(":",_loc2_));
            _loc4_ = Number(param1.indexOf("/",_loc2_));
            if(_loc4_ < 0)
            {
               if(_loc3_ < 0)
               {
                  return param1.slice(_loc2_);
               }
               return param1.slice(0,_loc3_);
            }
            if(_loc3_ >= 0 && _loc3_ < _loc4_)
            {
               return param1.slice(_loc2_,_loc3_);
            }
            return param1.slice(_loc2_,_loc4_);
         }
         return null;
      }
      
      public static function getBasePath(param1:String = "") : String
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = Number(param1.indexOf(":/"));
         if(_loc2_ >= 0)
         {
            if(param1.indexOf("://") < 0)
            {
               return param1.slice(_loc2_ + 1);
            }
            _loc3_ = Number(param1.indexOf("/",_loc2_ + 3));
            if(_loc3_ >= 0)
            {
               return param1.slice(_loc3_);
            }
         }
         return null;
      }
      
      public static function replaceProtocol(param1:String = "", param2:String = "") : String
      {
         var _loc3_:Number = Number(param1.indexOf(":/"));
         if(_loc3_ >= 0)
         {
            return param2 + param1.slice(_loc3_).toLowerCase();
         }
         return param1;
      }
      
      public static function replacePort(param1:String = "", param2:String = "") : String
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:Number = Number(param1.indexOf("://"));
         if(_loc3_ >= 0)
         {
            _loc3_ += 3;
            _loc4_ = Number(param1.indexOf(":",_loc3_));
            _loc5_ = Number(param1.indexOf("/",_loc3_));
            if(_loc5_ < 0 && _loc4_ >= 0)
            {
               return param1.slice(0,_loc4_) + ":" + param2;
            }
            if(_loc4_ >= 0 && _loc4_ < _loc5_)
            {
               return param1.slice(0,_loc4_) + ":" + param2 + param1.slice(_loc5_);
            }
            if(_loc5_ >= 0)
            {
               return param1.slice(0,_loc5_) + ":" + param2 + param1.slice(_loc5_);
            }
         }
         return param1;
      }
   }
}

