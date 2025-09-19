package com.dreamsocket.events
{
   import flash.events.Event;
   
   public class NetInfoEvent extends Event
   {
      
      public static const NET_INFO_PLAY_STATUS:String = "netInfoPlayStatus";
      
      public static const NET_INFO_CUE_POINT:String = "netInfoCuePoint";
      
      public static const NET_INFO_FCSUBSCRIBE:String = "netInfoFCSubscribe";
      
      public static const NET_INFO_FCUNSUBSCRIBE:String = "netInfoFCUnsubscribe";
      
      public static const NET_INFO_IMAGE_DATA:String = "netInfoImageData";
      
      public static const NET_INFO_META_DATA:String = "netInfoMetaData";
      
      public static const NET_INFO_TEXT_DATA:String = "netInfoTextData";
      
      public static const NET_INFO_XMP_DATA:String = "netInfoXMPData";
      
      protected var m_info:Object;
      
      public function NetInfoEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.m_info = param2;
      }
      
      public function get info() : Object
      {
         return this.m_info;
      }
      
      override public function clone() : Event
      {
         return new NetInfoEvent(this.type,this.m_info,this.bubbles,this.cancelable);
      }
      
      override public function toString() : String
      {
         return this.formatToString("NetInfoEvent","type","bubbles","cancelable");
      }
   }
}

