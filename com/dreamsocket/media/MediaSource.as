package com.dreamsocket.media
{
   public class MediaSource implements IMediaSource
   {
      
      protected var m_base:String;
      
      protected var m_duration:Number;
      
      protected var m_ID:String;
      
      protected var m_playback:String;
      
      protected var m_scaleMode:String;
      
      protected var m_URL:String;
      
      public function MediaSource(param1:String = null, param2:String = null)
      {
         super();
         this.m_URL = param1;
         this.m_playback = param2;
      }
      
      public function get base() : String
      {
         return this.m_base;
      }
      
      public function set base(param1:String) : void
      {
         this.m_base = param1;
      }
      
      public function get ID() : String
      {
         return this.m_ID;
      }
      
      public function set ID(param1:String) : void
      {
         this.m_ID = param1;
      }
      
      public function get duration() : Number
      {
         return this.m_duration;
      }
      
      public function set duration(param1:Number) : void
      {
         this.m_duration = param1;
      }
      
      public function get playback() : String
      {
         return this.m_playback;
      }
      
      public function set playback(param1:String) : void
      {
         this.m_playback = param1;
      }
      
      public function get scaleMode() : String
      {
         return this.m_scaleMode;
      }
      
      public function set scaleMode(param1:String) : void
      {
         this.m_scaleMode = param1;
      }
      
      public function get url() : String
      {
         return this.m_URL;
      }
      
      public function set url(param1:String) : void
      {
         this.m_URL = param1;
      }
   }
}

