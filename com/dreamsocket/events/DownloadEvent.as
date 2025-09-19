package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class DownloadEvent extends Event
   {
      
      public static const DOWNLOAD_STARTED:String = "downloadStarted";
      
      public static const DOWNLOAD_PROGRESS:String = "downloadProgress";
      
      public static const DOWNLOAD_STOPPED:String = "downloadStopped";
      
      protected var m_currProgress:Number;
      
      protected var m_totalProgress:Number;
      
      public function DownloadEvent(param1:String, param2:Number, param3:Number = NaN, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.m_currProgress = param2;
         this.m_totalProgress = isNaN(param3) ? param2 : param3;
      }
      
      public function get currentProgress() : Number
      {
         return this.m_currProgress;
      }
      
      public function get totalProgress() : Number
      {
         return this.m_totalProgress;
      }
      
      override public function clone() : Event
      {
         return new DownloadEvent(this.type,this.currentProgress,this.totalProgress,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("DownloadEvent","type","currentProgress","totalProgress","bubbles","cancelable");
      }
   }
}

