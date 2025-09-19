package com.dreamsocket.media
{
   import com.dreamsocket.data.IRange;
   import com.dreamsocket.data.Range;
   import com.dreamsocket.events.TimeEvent;
   import com.dreamsocket.utils.WeakReference;
   import flash.events.EventDispatcher;
   import flash.media.SoundTransform;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   
   public class AbstractNSPlayback extends EventDispatcher implements INSPlayback
   {
      
      public static var defaultSourceSelector:IMediaSourceSelector = new MediaSourceSelector();
      
      protected var m_autoPlay:Boolean;
      
      protected var m_autoRewind:Boolean;
      
      protected var m_bufferTimePreferred:Number;
      
      protected var m_bytesDownloaded:Range;
      
      protected var m_currState:String;
      
      protected var m_duration:Number;
      
      protected var m_media:IMediaObject;
      
      protected var m_playback:AbstractMediaNS;
      
      protected var m_playPaused:Boolean;
      
      protected var m_prevState:String;
      
      protected var m_sourceSelector:IMediaSourceSelector;
      
      protected var m_timeDownloaded:Range;
      
      protected var m_timeSeekable:Range;
      
      protected var m_sourceURL:String;
      
      protected var m_sndTransform:SoundTransform;
      
      protected var m_videoHost:WeakReference;
      
      public function AbstractNSPlayback()
      {
         super();
         this.m_autoPlay = true;
         this.m_autoRewind = false;
         this.m_bufferTimePreferred = 5;
         this.m_bytesDownloaded = new Range(0,0);
         this.m_currState = MediaState.CLOSED;
         this.m_duration = this.m_duration;
         this.m_media = new MediaObject();
         this.m_playPaused = !this.autoPlay;
         this.m_prevState = MediaState.CLOSED;
         this.m_sndTransform = new SoundTransform();
         this.m_sourceSelector = defaultSourceSelector;
         this.m_timeDownloaded = new Range(0,0);
         this.m_timeSeekable = new Range(0,0);
         this.m_videoHost = new WeakReference();
      }
      
      public function get autoPlay() : Boolean
      {
         return this.m_autoPlay;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
         this.m_autoPlay = param1;
         if(this.m_playback != null)
         {
            this.m_playback.autoPlay = param1;
         }
      }
      
      public function get autoRewind() : Boolean
      {
         return this.m_autoRewind;
      }
      
      public function set autoRewind(param1:Boolean) : void
      {
         this.m_autoRewind = param1;
         if(this.m_playback != null)
         {
            this.m_playback.autoRewind = param1;
         }
      }
      
      public function get buffering() : Boolean
      {
         return this.m_playback == null ? false : this.m_playback.buffering;
      }
      
      public function get bufferTimePreferred() : Number
      {
         return this.m_bufferTimePreferred;
      }
      
      public function set bufferTimePreferred(param1:Number) : void
      {
         this.m_bufferTimePreferred = param1;
         if(this.m_playback != null)
         {
            this.m_playback.bufferTimePreferred = param1;
         }
      }
      
      public function get bufferTimeRemaining() : Number
      {
         return this.m_playback == null ? 0 : this.m_playback.bufferTimeRemaining;
      }
      
      public function get bytesTotal() : uint
      {
         return this.m_playback == null ? 0 : this.m_playback.bytesTotal;
      }
      
      public function get bytesDownloaded() : IRange
      {
         return this.m_bytesDownloaded;
      }
      
      public function get currentTime() : Number
      {
         return this.m_playback == null ? 0 : this.m_playback.currentTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
         if(this.m_playback != null)
         {
            this.m_playback.currentTime = param1;
         }
      }
      
      public function get downloading() : Boolean
      {
         return this.m_playback == null ? false : this.m_playback.downloading;
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
         var _loc3_:* = false;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:IMediaSource = this.m_sourceSelector.selectSource(param1);
         if(_loc2_ == null || _loc2_.url == null)
         {
            return;
         }
         if(this.media == null || _loc2_.url != this.m_sourceURL)
         {
            _loc3_ = this.m_duration != 0;
            this.close();
            this.m_duration = 0;
            this.m_playPaused = !this.autoPlay;
            this.m_media = param1;
            this.m_sourceURL = _loc2_.url;
            if(_loc3_)
            {
               this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
            }
         }
         this.load();
      }
      
      public function get metadata() : Object
      {
         return this.m_playback == null ? null : AbstractMediaNS(this.m_playback).metadata;
      }
      
      public function get netConnection() : NetConnection
      {
         return null;
      }
      
      public function get netStream() : NetStream
      {
         return this.m_playback as NetStream;
      }
      
      public function get paused() : Boolean
      {
         return this.m_playback != null ? this.m_playback.paused : this.m_playPaused;
      }
      
      public function get soundTransform() : SoundTransform
      {
         return this.m_sndTransform;
      }
      
      public function set soundTransform(param1:SoundTransform) : void
      {
         this.m_sndTransform = param1;
         if(this.m_playback != null)
         {
            NetStream(this.m_playback).soundTransform = this.m_sndTransform;
         }
      }
      
      public function get sourceWidth() : Number
      {
         return this.m_playback == null ? 0 : AbstractMediaNS(this.m_playback).sourceWidth;
      }
      
      public function get sourceHeight() : Number
      {
         return this.m_playback == null ? 0 : AbstractMediaNS(this.m_playback).sourceHeight;
      }
      
      public function set sourceSelector(param1:IMediaSourceSelector) : void
      {
         this.m_sourceSelector = param1;
      }
      
      public function get state() : String
      {
         return this.m_playback == null ? this.m_currState : this.m_playback.state;
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
      
      public function attachVideoHost(param1:Video) : void
      {
         var _loc2_:Video = Video(this.m_videoHost.value);
         if(param1 != _loc2_)
         {
            if(_loc2_ != null)
            {
               _loc2_.attachNetStream(null);
            }
            this.m_videoHost.value = param1;
            if(param1 != null && this.m_playback != null)
            {
               param1.attachNetStream(this.m_playback);
            }
         }
      }
      
      public function close() : void
      {
         if(this.state == MediaState.CLOSED || this.state == MediaState.ERROR)
         {
            return;
         }
         if(this.m_playback != null)
         {
            this.m_playback.close();
         }
      }
      
      public function destroy() : void
      {
         this.close();
         this.m_media = new MediaObject();
         this.m_sourceURL = null;
         if(this.m_playback != null)
         {
            this.m_playback.destroy();
         }
      }
      
      public function load() : void
      {
         if(this.m_playback != null)
         {
            this.m_playback.load();
         }
      }
      
      public function pause() : void
      {
         this.m_playPaused = true;
         if(this.m_playback != null)
         {
            this.m_playback.pause();
         }
      }
      
      public function play() : void
      {
         this.m_playPaused = false;
         if(this.m_playback != null)
         {
            this.m_playback.play();
         }
      }
      
      public function stop() : void
      {
         if(this.m_playback != null)
         {
            this.m_playback.stop();
         }
      }
   }
}

