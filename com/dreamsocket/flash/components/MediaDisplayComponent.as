package com.dreamsocket.flash.components
{
   import com.dreamsocket.events.BufferTimeEvent;
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.NetInfoEvent;
   import com.dreamsocket.events.PlayEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import com.dreamsocket.flash.components.mediaClasses.AbstractPlaybackComponent;
   import com.dreamsocket.flash.components.views.IDEPlaybackView;
   import com.dreamsocket.media.IMediaObject;
   import com.dreamsocket.media.IMediaSource;
   import com.dreamsocket.media.IMediaSourceSelector;
   import com.dreamsocket.media.MediaSourceSelector;
   import com.dreamsocket.utils.ClassFactory;
   import flash.display.Sprite;
   
   public class MediaDisplayComponent extends AbstractPlaybackComponent
   {
      
      public static const PLAYBACK_TYPE:String = "MediaDisplayComponent";
      
      public static var defaultSourceSelector:IMediaSourceSelector = new MediaSourceSelector();
      
      private var m_iconID:String = "com.dreamsocket.flash.components.livePreview.MediaDisplayIcon";
      
      protected var m_autoDetectPlaybackType:Boolean;
      
      protected var m_invalidPlaybackType:Boolean;
      
      protected var m_playbackFactory:ClassFactory;
      
      protected var m_playbackType:String;
      
      protected var ui_playbackContainer:Sprite;
      
      protected var ui_livePreview:IDEPlaybackView;
      
      protected var ui_mask:Sprite;
      
      public function MediaDisplayComponent()
      {
         super();
         this.m_autoDetectPlaybackType = true;
         this.m_invalidPlaybackType = false;
         this.m_sourceSelector = MediaDisplayComponent.defaultSourceSelector;
         this.m_playbackFactory = new ClassFactory();
         this.m_playbackFactory.registerClass(ProgressiveNSComponent,ProgressiveNSComponent.PLAYBACK_TYPE,["progressivens","progressiveflv","progressivempeg4"]);
         this.m_playbackFactory.registerClass(ByteRangeNSComponent,ByteRangeNSComponent.PLAYBACK_TYPE,["byterangens","byterangeflv","byterangempeg4"]);
         this.m_playbackFactory.registerClass(SoundComponent,SoundComponent.PLAYBACK_TYPE,["sound","progressivemp3"]);
         this.m_playbackFactory.registerClass(SoundWithImageComponent,SoundWithImageComponent.PLAYBACK_TYPE,["soundwithimage","progressivemp3image"]);
         this.m_playbackFactory.registerClass(StreamingNSComponent,StreamingNSComponent.PLAYBACK_TYPE,["streamingns","streamingflv","streamingmp3","streamingmpeg4"]);
         this.m_playbackFactory.registerClass(TimedImageComponent,TimedImageComponent.PLAYBACK_TYPE,["timedimage","image","swf"]);
         this.m_playbackFactory.registerClass(TimelineSWFComponent,TimelineSWFComponent.PLAYBACK_TYPE,["timelineswf"]);
      }
      
      public function get autoDetectPlayback() : Boolean
      {
         return this.m_autoDetectPlaybackType;
      }
      
      public function set autoDetectPlayback(param1:Boolean) : void
      {
         this.m_autoDetectPlaybackType = param1;
      }
      
      override public function get media() : IMediaObject
      {
         return this.m_media;
      }
      
      override public function set media(param1:IMediaObject) : void
      {
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
            this.m_sourceURL = _loc2_.url;
            this.playbackType = _loc2_.playback;
            this.m_invalidSource = true;
            this.invalidateProperties();
         }
         this.m_media = param1;
      }
      
      override public function get playbackType() : String
      {
         return this.m_playbackType;
      }
      
      public function set playbackType(param1:String) : void
      {
         if(this.isLivePreview())
         {
            return;
         }
         var _loc2_:String = this.m_playbackFactory.getRegisteredNameByAlias(param1);
         if(_loc2_ != null && param1 != this.playbackType)
         {
            this.m_invalidPlaybackType = true;
            this.m_playbackType = param1;
            this.invalidateProperties();
         }
      }
      
      override public function destroy() : void
      {
         this.destroyPlayback();
         super.destroy();
      }
      
      override protected function commitProperties() : void
      {
         if(this.m_invalidPlaybackType)
         {
            if(this.m_playback == null || AbstractPlaybackComponent(this.m_playback).playbackType != this.playbackType)
            {
               this.renderPlayback();
            }
            this.m_invalidPlaybackType = false;
         }
         if(this.m_invalidSource)
         {
            if(this.m_playback != null)
            {
               this.m_playback.media = this.media;
               AbstractPlaybackComponent(this.m_playback).validateNow();
            }
            this.m_invalidSource = false;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.ui_mask = new Sprite();
         this.ui_mask.graphics.beginFill(0);
         this.ui_mask.graphics.drawRect(0,0,1,1);
         this.ui_mask.graphics.endFill();
         this.ui_mask.width = this.width;
         this.ui_mask.height = this.height;
         this.addChild(this.ui_mask);
         if(this.isLivePreview())
         {
            this.ui_livePreview = new IDEPlaybackView(this.width,this.height,MediaDisplayComponent.PLAYBACK_TYPE,this.m_iconID);
            this.addChild(this.ui_livePreview);
         }
         this.ui_playbackContainer = new Sprite();
         this.ui_playbackContainer.mask = this.ui_mask;
         this.addChild(this.ui_playbackContainer);
      }
      
      protected function destroyPlayback() : void
      {
         if(this.m_playback != null)
         {
            this.m_playback.destroy();
            this.m_playback.removeEventListener(BufferTimeEvent.BUFFER_TIME_STARTED,this.dispatchEvent);
            this.m_playback.removeEventListener(BufferTimeEvent.BUFFER_TIME_PROGRESS,this.dispatchEvent);
            this.m_playback.removeEventListener(BufferTimeEvent.BUFFER_TIME_STOPPED,this.dispatchEvent);
            this.m_playback.removeEventListener(DownloadEvent.DOWNLOAD_STARTED,this.dispatchEvent);
            this.m_playback.removeEventListener(DownloadEvent.DOWNLOAD_PROGRESS,this.onDownloadProgress);
            this.m_playback.removeEventListener(DownloadEvent.DOWNLOAD_STOPPED,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaExceptionEvent.MEDIA_ASYNC_EXCEPTION,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaExceptionEvent.MEDIA_IO_EXCEPTION,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_CLOSED,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_LOADING,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_OPENING,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_READY,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_CUE_POINT,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_IMAGE_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_PLAY_STATUS,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_TEXT_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_XMP_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_ENDED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_PAUSED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_RESUMED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_STARTED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_STOPPED,this.dispatchEvent);
            this.m_playback.removeEventListener(StateChangeEvent.STATE_CHANGED,this.onStateChanged);
            this.m_playback.removeEventListener(TimeEvent.TIME_DURATION_CHANGED,this.onTimeDurationChanged);
            this.m_playback.removeEventListener(TimeEvent.TIME_POSITION_CHANGED,this.dispatchEvent);
            this.m_playback.removeEventListener(TimeEvent.TIME_SEEKABLE_CHANGED,this.onTimeSeekableChanged);
            this.removeChild(AbstractPlaybackComponent(this.m_playback));
            this.m_volumeControl.removeClient(this.m_playback);
            this.m_playback = null;
            this.ui_view = null;
         }
      }
      
      protected function renderPlayback() : void
      {
         this.destroyPlayback();
         if(this.m_playbackType == null)
         {
            return;
         }
         this.m_playback = AbstractPlaybackComponent(this.m_playbackFactory.createInstance(this.m_playbackType));
         this.configurePlayback();
         this.ui_view = AbstractPlaybackComponent(this.m_playback).view;
         AbstractPlaybackComponent(this.m_playback).horizontalAlign = this.horizontalAlign;
         AbstractPlaybackComponent(this.m_playback).verticalAlign = this.verticalAlign;
         AbstractPlaybackComponent(this.m_playback).scaleMode = this.scaleMode;
         AbstractPlaybackComponent(this.m_playback).setActualSize(this.width,this.height);
         this.m_volumeControl.addClient(this.m_playback);
         this.addChild(AbstractPlaybackComponent(this.m_playback));
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = param1;
         var _loc4_:Number = param2;
         if(this.m_playback != null)
         {
            AbstractPlaybackComponent(this.m_playback).horizontalAlign = this.horizontalAlign;
            AbstractPlaybackComponent(this.m_playback).verticalAlign = this.verticalAlign;
            AbstractPlaybackComponent(this.m_playback).scaleMode = this.scaleMode;
            AbstractPlaybackComponent(this.m_playback).setActualSize(_loc3_,_loc4_);
            AbstractPlaybackComponent(this.m_playback).validateDisplayList();
         }
         this.ui_mask.width = _loc3_;
         this.ui_mask.height = _loc4_;
         if(this.isLivePreview())
         {
            this.ui_livePreview.setActualSize(_loc3_,_loc4_);
         }
      }
   }
}

