package com.dreamsocket.services
{
   public class Fault extends Error
   {
      
      protected var m_code:String;
      
      protected var m_detail:String;
      
      protected var m_string:String;
      
      protected var m_rootCause:Object;
      
      public function Fault(param1:String, param2:String, param3:String = null)
      {
         super();
         this.m_code = param1;
         this.m_string = param2;
         this.m_detail = param3;
      }
      
      public function get faultCode() : String
      {
         return this.m_code;
      }
      
      public function get faultString() : String
      {
         return this.m_string;
      }
      
      public function get faultDetail() : String
      {
         return this.m_detail;
      }
      
      public function set rootCause(param1:Object) : void
      {
         this.m_rootCause = param1;
      }
      
      public function get rootCause() : Object
      {
         return this.m_rootCause;
      }
      
      public function toString() : String
      {
         var _loc1_:* = "";
         _loc1_ += "[Fault";
         _loc1_ += " faultCode=" + this.faultCode;
         _loc1_ += " faultDetail=" + this.faultDetail;
         _loc1_ += " faultString=" + this.faultString;
         return _loc1_ + "]";
      }
   }
}

