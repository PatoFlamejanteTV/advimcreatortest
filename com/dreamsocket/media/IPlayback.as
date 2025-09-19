package com.dreamsocket.media
{
   import com.dreamsocket.data.IRange;
   import flash.events.IEventDispatcher;
   
   public interface IPlayback extends IEventDispatcher
   {
      
      function get autoPlay() : Boolean;
      
      function set autoPlay(param1:Boolean) : void;
      
      function get autoRewind() : Boolean;
      
      function set autoRewind(param1:Boolean) : void;
      
      function get buffering() : Boolean;
      
      function get bufferTimePreferred() : Number;
      
      function set bufferTimePreferred(param1:Number) : void;
      
      function get bufferTimeRemaining() : Number;
      
      function get bytesTotal() : uint;
      
      function get bytesDownloaded() : IRange;
      
      function get currentTime() : Number;
      
      function set currentTime(param1:Number) : void;
      
      function get downloading() : Boolean;
      
      function get duration() : Number;
      
      function get media() : IMediaObject;
      
      function set media(param1:IMediaObject) : void;
      
      function get paused() : Boolean;
      
      function get timeDownloaded() : IRange;
      
      function get timeSeekable() : IRange;
      
      function get state() : String;
      
      function get url() : String;
      
      function set url(param1:String) : void;
      
      function close() : void;
      
      function destroy() : void;
      
      function load() : void;
      
      function pause() : void;
      
      function play() : void;
      
      function stop() : void;
   }
}

