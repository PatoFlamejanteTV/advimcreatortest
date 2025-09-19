package com.dreamsocket.text
{
   public class PropertyStringUtil
   {
      
      public function PropertyStringUtil()
      {
         super();
      }
      
      public static function evalParamString(param1:*, param2:String = null) : String
      {
         var p_data:* = param1;
         var p_value:String = param2;
         return p_value.replace(/{.*?}/gi,function():String
         {
            return PropertyStringUtil.evalPropertyString(p_data,arguments[0].replace(/{|}/gi,""));
         });
      }
      
      protected static function evalPropertyString(param1:*, param2:String = null) : *
      {
         var parts:Array = null;
         var key:String = null;
         var i:uint = 0;
         var len:uint = 0;
         var p_data:* = param1;
         var p_value:String = param2;
         var val:String = p_value == null ? "" : p_value;
         var currPart:* = p_data;
         parts = val.split(".");
         key = parts.shift();
         switch(key)
         {
            case "cacheID":
               currPart = new Date().valueOf();
               break;
            case "data":
               try
               {
                  i = 0;
                  len = parts.length;
                  if(len != 0)
                  {
                     while(i < len)
                     {
                        currPart = currPart[parts[i]];
                        i++;
                     }
                  }
               }
               catch(error:Error)
               {
                  currPart = null;
               }
         }
         return currPart;
      }
   }
}

