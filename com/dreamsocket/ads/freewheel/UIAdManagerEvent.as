package com.dreamsocket.ads.freewheel
{
   import flash.events.Event;
   
   public class UIAdManagerEvent extends Event
   {
      
      public static const AD_MANAGER_INIT_REQUESTED:String = "adManagerInitRequested";
      
      public static const AD_MANAGER_INIT_SUCCEEDED:String = "adManagerInitSucceeded";
      
      public static const AD_MANAGER_INIT_FAILED:String = "adManagerInitFailed";
      
      public static const AD_PLAYLIST_REQUESTED:String = "adPlaylistRequested";
      
      public static const AD_PLAYLIST_LOADED:String = "adPlaylistLoaded";
      
      public static const AD_PLAYLIST_FAILED:String = "adPlaylistFailed";
      
      public static const AD_PLAYLIST_STARTED:String = "adPlaylistStarted";
      
      public static const AD_PLAYLIST_ENDED:String = "adPlaylistEnded";
      
      public static const AD_PLAY_FAILED:String = "adPlayFailed";
      
      public static const AD_PLAY_ENDED:String = "adPlayEnded";
      
      public static const AD_PLAY_STARTED:String = "adPlayStarted";
      
      protected var m_data:*;
      
      public function UIAdManagerEvent(param1:String, param2:* = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.m_data = param2;
      }
      
      public function get data() : *
      {
         return this.m_data;
      }
      
      override public function clone() : Event
      {
         return new UIAdManagerEvent(this.type,this.data,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("UIAdManagerEvent","type","bubbles","cancelable");
      }
   }
}

