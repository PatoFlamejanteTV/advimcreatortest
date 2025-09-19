package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class VolumeEvent extends Event
   {
      
      public static const VOLUME_MUTED:String = "volumeMuted";
      
      public static const VOLUME_UNMUTED:String = "volumeUnmuted";
      
      public static const VOLUME_CHANGED:String = "volumeChanged";
      
      protected var m_muted:Boolean;
      
      protected var m_volume:Number;
      
      public function VolumeEvent(param1:String, param2:Number, param3:Boolean, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.m_muted = param3;
         this.m_volume = param2;
      }
      
      public function get muted() : Boolean
      {
         return this.m_muted;
      }
      
      public function get volume() : Number
      {
         return this.m_volume;
      }
      
      override public function clone() : Event
      {
         return new VolumeEvent(this.type,this.volume,this.muted,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("VolumeEvent","type","volume","muted");
      }
   }
}

