package com.dreamsocket.media.byteRangeNSClasses
{
   public class ByteRangeNSRequestBuilder implements IByteRangeNSRequestBuilder
   {
      
      public static var defaultFormatString:String = "${FILE_URL}?start=${FILE_POS}";
      
      protected var m_base:String;
      
      protected var m_formatStr:String;
      
      public function ByteRangeNSRequestBuilder(param1:String, param2:String = null)
      {
         super();
         this.m_base = param1;
         this.m_formatStr = param2 == null ? ByteRangeNSRequestBuilder.defaultFormatString : param2;
      }
      
      public function get base() : String
      {
         return this.m_base;
      }
      
      public function set base(param1:String) : void
      {
         this.m_base = param1;
      }
      
      public function get formatString() : String
      {
         return this.m_formatStr;
      }
      
      public function set formatString(param1:String) : void
      {
         this.m_formatStr = param1;
      }
      
      public function createRequest(param1:String, param2:Number, param3:Number) : ByteRangeNSRequest
      {
         var _loc4_:ByteRangeNSRequest = new ByteRangeNSRequest();
         var _loc5_:String = param1.replace(this.m_base,"");
         _loc4_.URL = this.m_formatStr.replace("${FILE_URL}",_loc5_);
         _loc4_.URL = _loc4_.URL.replace("${FILE_POS}",param2);
         _loc4_.URL = _loc4_.URL.replace("${KEYFRAME_TIME}",param3);
         return _loc4_;
      }
   }
}

