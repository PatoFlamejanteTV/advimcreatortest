package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class MediaRequestEvent extends Event
   {
      
      public static const MEDIA_REQUEST_CLOSED:String = "mediaRequestClosed";
      
      public static const MEDIA_REQUEST_OPENING:String = "mediaRequestOpening";
      
      public static const MEDIA_REQUEST_LOADING:String = "mediaRequestLoading";
      
      public static const MEDIA_REQUEST_READY:String = "mediaRequestReady";
      
      public function MediaRequestEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new MediaRequestEvent(this.type,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("MediaRequestEvent","type","bubbles","cancelable");
      }
   }
}

