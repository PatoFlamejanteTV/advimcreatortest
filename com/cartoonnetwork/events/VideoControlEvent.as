package com.cartoonnetwork.events
{
   import flash.events.Event;
   
   public class VideoControlEvent extends Event
   {
      
      public static const PLAY:String = "VideoControlEvent.Play";
      
      public static const PAUSE:String = "VideoControlEvent.Pause";
      
      public static const STOP:String = "VideoControlEvent.Stop";
      
      public static const NEXT:String = "VideoControlEvent.Next";
      
      public static const PREV:String = "VideoControlEvent.Prev";
      
      public static const IN:String = "VideoControlEvent.In";
      
      public static const OUT:String = "VideoControlEvent.Out";
      
      public static const ACTIVE:String = "VideoControlEvent.Active";
      
      public static const VOLUME:String = "VideoControlEvent.Volume";
      
      public static const SCRUB:String = "VideoControlEvent.Scrub";
      
      public static const SCRUB_COMPLETE:String = "VideoControlEvent.ScrubComplete";
      
      public static const SCRUB_START:String = "VideoControlEvent.ScrubStart";
      
      public static const SHOW_MENU:String = "VideoControlEvent.SHOW_MENU";
      
      public static const CLOSE_MENU:String = "VideoControlEvent.CLOSE_MENU";
      
      public static const REPLAY:String = "VideoControlEvent.Replay";
      
      public static const FULLSCREEN:String = "VideoControlEvent.FullScreen";
      
      public static const SHOW_CONTROLS:String = "VideoControlEvent.SHOW_CONTROLS";
      
      public static const HIDE_CONTROLS:String = "VideoControlEvent.HIDE_CONTROLS";
      
      public static const EXIT_FULLSCREEN:String = "VideoControlEvent.Exit_FullScreen";
      
      public static const CUEPOINT:String = "VideoControlEvent.CuePoint";
      
      public static const SEEK:String = "VideoControlEvent.Seek";
      
      public var data:Object;
      
      public function VideoControlEvent(param1:String, param2:Boolean = false, param3:Object = null)
      {
         super(param1,param2);
         this.data = param3;
      }
      
      override public function toString() : String
      {
         var _loc1_:String = null;
         return formatToString("VideoControlEvent","type","bubbles","cancelable","eventPhase","data");
      }
   }
}

