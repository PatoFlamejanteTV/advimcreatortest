package com.dreamsocket.tracking
{
   public class Track implements ITrack
   {
      
      protected var m_data:*;
      
      protected var m_type:String;
      
      public function Track(param1:String, param2:* = null)
      {
         super();
         this.m_type = param1;
         this.m_data = param2;
      }
      
      public function get data() : *
      {
         return this.m_data;
      }
      
      public function get type() : String
      {
         return this.m_type;
      }
   }
}

