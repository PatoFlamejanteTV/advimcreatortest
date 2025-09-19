package com.dreamsocket.formatters
{
   public class TimeFormatter implements IFormatter
   {
      
      protected var m_formatStr:String;
      
      protected var m_prefixWithZeroes:Boolean;
      
      public function TimeFormatter(param1:String = null, param2:Boolean = true)
      {
         super();
         this.m_formatStr = param1 == null ? "${M}:${S}" : param1;
         this.m_prefixWithZeroes = param2;
      }
      
      public function get formatString() : String
      {
         return this.m_formatStr;
      }
      
      public function set formatString(param1:String) : void
      {
         this.m_formatStr = param1;
      }
      
      public function format(param1:Object) : String
      {
         var _loc2_:Number = Math.floor(Number(param1));
         var _loc3_:Number = Math.floor(_loc2_ / 60);
         var _loc4_:Number = Math.floor(_loc3_ / 60);
         var _loc5_:String = this.m_formatStr;
         _loc2_ %= 60;
         _loc3_ %= 60;
         _loc4_ %= 60;
         var _loc6_:String = _loc3_ < 10 && this.m_prefixWithZeroes ? "0" + _loc3_ : String(_loc3_);
         var _loc7_:String = _loc2_ < 10 && this.m_prefixWithZeroes ? "0" + _loc2_ : String(_loc2_);
         var _loc8_:String = _loc4_ < 10 && this.m_prefixWithZeroes ? "0" + _loc4_ : String(_loc4_);
         if(_loc5_.indexOf("${M}") > -1)
         {
            _loc5_ = _loc5_.split("${M}").join(_loc6_);
         }
         if(_loc5_.indexOf("${S}") > -1)
         {
            _loc5_ = _loc5_.split("${S}").join(_loc7_);
         }
         if(_loc5_.indexOf("${H}") > -1)
         {
            _loc5_ = _loc5_.split("${H}").join(_loc8_);
         }
         return _loc5_;
      }
   }
}

