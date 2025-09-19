package com.dreamsocket.media
{
   public interface IMediaObject
   {
      
      function get creationStartDate() : Number;
      
      function set creationStartDate(param1:Number) : void;
      
      function get deliveryType() : String;
      
      function set deliveryType(param1:String) : void;
      
      function get duration() : Number;
      
      function set duration(param1:Number) : void;
      
      function get id() : String;
      
      function set id(param1:String) : void;
      
      function get sources() : Array;
      
      function set sources(param1:Array) : void;
      
      function get poster() : String;
      
      function set poster(param1:String) : void;
   }
}

