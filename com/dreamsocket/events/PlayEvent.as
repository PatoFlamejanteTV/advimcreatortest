package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class PlayEvent extends Event
   {
      
      public static const PLAY_PAUSED:String = "playPaused";
      
      public static const PLAY_RESUMED:String = "playResumed";
      
      public static const PLAY_STARTED:String = "playStarted";
      
      public static const PLAY_STOPPED:String = "playStopped";
      
      public static const PLAY_ENDED:String = "playEnded";
      
      public function PlayEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new PlayEvent(this.type,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("PlayEvent","type","bubbles","cancelable");
      }
   }
}

