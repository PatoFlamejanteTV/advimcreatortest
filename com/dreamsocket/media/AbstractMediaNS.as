package com.dreamsocket.media
{
   import com.dreamsocket.data.IRange;
   import com.dreamsocket.data.Range;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.net.NSClientProxy;
   import flash.errors.IOError;
   import flash.events.AsyncErrorEvent;
   import flash.events.IOErrorEvent;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   
   public class AbstractMediaNS extends NetStream
   {
      
      protected var m_autoPlay:Boolean;
      
      protected var m_autoRewind:Boolean;
      
      protected var m_bufferTimePreferred:Number;
      
      protected var m_connection:NetConnection;
      
      protected var m_clientProxy:NSClientProxy;
      
      protected var m_currState:String;
      
      protected var m_buffering:Boolean;
      
      protected var m_bytesDownloaded:Range;
      
      protected var m_downloading:Boolean;
      
      protected var m_duration:Number;
      
      protected var m_media:IMediaObject;
      
      protected var m_metadata:Object;
      
      protected var m_playPaused:Boolean;
      
      protected var m_playStarted:Boolean;
      
      protected var m_prevState:String;
      
      protected var m_sourceURL:String;
      
      protected var m_sourceWidth:Number;
      
      protected var m_sourceHeight:Number;
      
      protected var m_timeDownloaded:Range;
      
      protected var m_timeSeekable:Range;
      
      public function AbstractMediaNS(param1:NetConnection)
      {
         super(param1);
         this.m_autoPlay = true;
         this.m_autoRewind = false;
         this.m_clientProxy = new NSClientProxy();
         this.m_connection = param1;
         this.m_currState = MediaState.CLOSED;
         this.m_bytesDownloaded = new Range(0,0);
         this.m_downloading = false;
         this.m_duration = 0;
         this.m_prevState = MediaState.CLOSED;
         this.m_playPaused = !this.autoPlay;
         this.m_playStarted = false;
         this.m_timeDownloaded = new Range(0,0);
         this.m_timeSeekable = new Range(0,0);
         this.m_sourceWidth = 0;
         this.m_sourceHeight = 0;
         super.client = this.m_clientProxy;
         this.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError);
         this.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
      }
      
      public function get autoPlay() : Boolean
      {
         return this.m_autoPlay;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
         this.m_autoPlay = param1;
      }
      
      public function get autoRewind() : Boolean
      {
         return this.m_autoRewind;
      }
      
      public function set autoRewind(param1:Boolean) : void
      {
         this.m_autoRewind = param1;
      }
      
      public function get buffering() : Boolean
      {
         return this.m_buffering;
      }
      
      public function get bufferTimeRemaining() : Number
      {
         return this.bufferLength;
      }
      
      public function get bufferTimePreferred() : Number
      {
         return this.m_bufferTimePreferred;
      }
      
      public function set bufferTimePreferred(param1:Number) : void
      {
         this.m_bufferTimePreferred = param1;
         this.bufferTime = param1;
      }
      
      public function get bytesDownloaded() : IRange
      {
         return this.m_bytesDownloaded;
      }
      
      override public function set client(param1:Object) : void
      {
         super.client.proxiedClient = param1;
      }
      
      override public function get client() : Object
      {
         return super.client.proxiedClient;
      }
      
      public function get currentTime() : Number
      {
         return this.time;
      }
      
      public function set currentTime(param1:Number) : void
      {
         this.seek(param1);
      }
      
      public function get downloading() : Boolean
      {
         return this.m_downloading;
      }
      
      public function get duration() : Number
      {
         return this.m_duration;
      }
      
      public function get media() : IMediaObject
      {
         return this.m_media;
      }
      
      public function set media(param1:IMediaObject) : void
      {
      }
      
      public function get metadata() : Object
      {
         return this.m_metadata;
      }
      
      public function get paused() : Boolean
      {
         return this.m_playPaused;
      }
      
      public function get state() : String
      {
         return this.m_currState;
      }
      
      public function get sourceWidth() : Number
      {
         return this.m_sourceWidth;
      }
      
      public function get sourceHeight() : Number
      {
         return this.m_sourceHeight;
      }
      
      public function get timeDownloaded() : IRange
      {
         return this.m_timeDownloaded;
      }
      
      public function get timeSeekable() : IRange
      {
         return this.m_timeSeekable;
      }
      
      public function get url() : String
      {
         return this.m_sourceURL;
      }
      
      public function set url(param1:String) : void
      {
         var _loc2_:IMediaObject = this.media;
         if(param1 != null && param1 != this.m_sourceURL)
         {
            _loc2_ = new MediaObject(new MediaSource(param1),null,param1);
         }
         this.media = _loc2_;
      }
      
      public function destroy() : void
      {
      }
      
      public function load() : void
      {
      }
      
      override public function play(... rest) : void
      {
         this.resume();
      }
      
      public function stop() : void
      {
      }
      
      protected function doBaseClose() : void
      {
         super.close();
      }
      
      protected function doBasePause() : void
      {
         super.pause();
      }
      
      protected function doBasePlay(... rest) : void
      {
         var p_args:Array = rest;
         try
         {
            super.play.apply(this,p_args);
         }
         catch(e:Error)
         {
            if(e is SecurityError)
            {
               this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,e));
               this.setState(MediaState.ERROR);
            }
            else if(!(e is ArgumentError))
            {
               this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_IO_EXCEPTION,e));
               this.setState(MediaState.ERROR);
            }
         }
      }
      
      protected function doBaseResume() : void
      {
         super.resume();
      }
      
      protected function doBaseSeek(param1:Number) : void
      {
         super.seek(param1);
      }
      
      protected function setState(param1:String) : void
      {
         if(param1 != this.m_currState)
         {
            this.m_prevState = this.m_currState;
            this.m_currState = param1;
            this.dispatchEvent(new StateChangeEvent(StateChangeEvent.STATE_CHANGED,this.m_currState,this.m_prevState));
         }
      }
      
      protected function onAsyncError(param1:AsyncErrorEvent) : void
      {
         this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_ASYNC_EXCEPTION,param1.error));
      }
      
      protected function onIOError(param1:IOErrorEvent) : void
      {
         this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_IO_EXCEPTION,new IOError(param1.text)));
         this.setState(MediaState.ERROR);
      }
   }
}

