package com.dreamsocket.media
{
   public class MediaObject implements IMediaObject
   {
      
      protected var m_creationStartDate:Number;
      
      protected var m_deliveryType:String;
      
      protected var m_duration:Number;
      
      protected var m_id:String;
      
      protected var m_poster:String;
      
      protected var m_sources:Array;
      
      public function MediaObject(param1:IMediaSource = null, param2:String = null, param3:String = null)
      {
         super();
         this.m_sources = [param1 != null ? param1 : new MediaSource()];
         this.m_poster = param2;
         this.m_id = param3 == null ? this.m_sources[0].url : param3;
      }
      
      public function get creationStartDate() : Number
      {
         return this.m_creationStartDate;
      }
      
      public function set creationStartDate(param1:Number) : void
      {
         this.m_creationStartDate = param1;
      }
      
      public function get deliveryType() : String
      {
         return this.m_deliveryType;
      }
      
      public function set deliveryType(param1:String) : void
      {
         this.m_deliveryType = param1;
      }
      
      public function get duration() : Number
      {
         return this.m_duration;
      }
      
      public function set duration(param1:Number) : void
      {
         this.m_duration = param1;
      }
      
      public function get id() : String
      {
         return this.m_id;
      }
      
      public function set id(param1:String) : void
      {
         this.m_id = param1;
      }
      
      public function get poster() : String
      {
         return this.m_poster;
      }
      
      public function set poster(param1:String) : void
      {
         this.m_poster = param1;
      }
      
      public function get sources() : Array
      {
         return this.m_sources;
      }
      
      public function set sources(param1:Array) : void
      {
         this.m_sources = param1;
      }
   }
}

