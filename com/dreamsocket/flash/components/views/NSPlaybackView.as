package com.dreamsocket.flash.components.views
{
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.flash.components.core.FlashUIComponent;
   import com.dreamsocket.layout.HorizontalAlign;
   import com.dreamsocket.layout.VerticalAlign;
   import com.dreamsocket.media.IMediaView;
   import com.dreamsocket.media.INSPlayback;
   import com.dreamsocket.media.MediaState;
   import com.dreamsocket.media.ScaleMode;
   import flash.display.BlendMode;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.media.Video;
   
   public class NSPlaybackView extends FlashUIComponent implements IMediaView
   {
      
      protected var m_containerRect:Rectangle;
      
      protected var m_contentRect:Rectangle;
      
      protected var m_invalidPlayback:Boolean;
      
      protected var m_playback:INSPlayback;
      
      protected var m_scaleMode:String;
      
      protected var m_vAlign:String;
      
      protected var m_hAlign:String;
      
      protected var ui_media:Video;
      
      protected var ui_overlay:Sprite;
      
      public function NSPlaybackView()
      {
         super();
         this.m_containerRect = new Rectangle();
         this.m_contentRect = new Rectangle();
         this.m_hAlign = HorizontalAlign.CENTER;
         this.m_scaleMode = ScaleMode.UNIFORM;
         this.m_vAlign = VerticalAlign.MIDDLE;
         this.scrollRect = new Rectangle(0,0,this.width,this.height);
      }
      
      public function get containerRect() : Rectangle
      {
         return this.m_containerRect;
      }
      
      public function get contentRect() : Rectangle
      {
         return this.m_contentRect;
      }
      
      public function get horizontalAlign() : String
      {
         return this.m_hAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this.isLivePreview())
         {
            return;
         }
         if(param1 != this.m_hAlign)
         {
            this.m_hAlign = param1;
            this.invalidateDisplayList();
         }
      }
      
      public function get playback() : INSPlayback
      {
         return this.m_playback;
      }
      
      public function set playback(param1:INSPlayback) : void
      {
         if(this.isLivePreview())
         {
            return;
         }
         if(param1 != this.m_playback)
         {
            this.clearPlayback();
            if(param1 != null)
            {
               this.m_playback = param1;
               this.m_playback.addEventListener(MediaExceptionEvent.MEDIA_IO_EXCEPTION,this.onMediaClosed,false,0,true);
               this.m_playback.addEventListener(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,this.onMediaClosed,false,0,true);
               this.m_playback.addEventListener(MediaRequestEvent.MEDIA_REQUEST_CLOSED,this.onMediaClosed,false,0,true);
               this.m_playback.addEventListener(MediaRequestEvent.MEDIA_REQUEST_LOADING,this.onMediaLoading,false,0,true);
               this.m_invalidPlayback = true;
               this.invalidateProperties();
               if(this.m_playback.state != MediaState.LOADING)
               {
                  this.invalidateDisplayList();
               }
            }
         }
      }
      
      public function get verticalAlign() : String
      {
         return this.m_vAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this.isLivePreview())
         {
            return;
         }
         if(param1 != this.m_vAlign)
         {
            this.m_vAlign = param1;
            this.invalidateDisplayList();
         }
      }
      
      public function get scaleMode() : String
      {
         return this.m_scaleMode;
      }
      
      public function set scaleMode(param1:String) : void
      {
         if(this.isLivePreview())
         {
            return;
         }
         if(param1 != this.m_scaleMode)
         {
            this.m_scaleMode = param1;
            this.invalidateDisplayList();
         }
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         this.setContainerRect();
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         this.setContainerRect();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.clearVideo();
         this.clearPlayback();
      }
      
      protected function clearPlayback() : void
      {
         if(this.m_playback != null)
         {
            this.m_playback.removeEventListener(MediaExceptionEvent.MEDIA_IO_EXCEPTION,this.onMediaClosed);
            this.m_playback.removeEventListener(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,this.onMediaClosed);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_CLOSED,this.onMediaClosed);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_LOADING,this.onMediaLoading);
            this.m_playback = null;
         }
      }
      
      protected function clearVideo() : void
      {
         if(this.ui_media != null)
         {
            this.ui_media.clear();
            this.ui_media.attachNetStream(null);
            this.removeChild(this.ui_media);
         }
         this.ui_media = new Video();
         this.ui_media.width = 0;
         this.ui_media.height = 0;
         this.ui_media.visible = false;
         this.ui_media.smoothing = true;
         this.addChild(this.ui_media);
         this.setContentRect(0,0,0,0);
         this.removeEventListener(Event.ENTER_FRAME,this.onMonitorSize);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_invalidPlayback)
         {
            this.clearVideo();
            this.ui_media.attachNetStream(this.m_playback.netStream);
            if(this.m_playback.state != MediaState.CLOSED && this.m_playback.state != MediaState.ERROR)
            {
               this.addEventListener(Event.ENTER_FRAME,this.onMonitorSize);
               this.onMonitorSize();
            }
            this.m_invalidPlayback = false;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Graphics = null;
         super.createChildren();
         this.ui_overlay = new Sprite();
         this.ui_overlay.blendMode = BlendMode.ERASE;
         _loc1_ = this.ui_overlay.graphics;
         _loc1_.beginFill(0);
         _loc1_.drawRect(0,0,this.width,height);
         _loc1_.endFill();
         this.addChild(this.ui_overlay);
      }
      
      protected function setContainerRect() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.m_containerRect.x != this.x)
         {
            _loc1_ = true;
            this.m_containerRect.x = this.x;
         }
         if(this.m_containerRect.y != this.y)
         {
            _loc1_ = true;
            this.m_containerRect.y = this.y;
         }
         if(this.m_containerRect.width != this.width)
         {
            _loc1_ = true;
            this.m_containerRect.width = this.width;
         }
         if(this.m_containerRect.height != this.height)
         {
            _loc1_ = true;
            this.m_containerRect.height = this.height;
         }
         return _loc1_;
      }
      
      protected function setContentRect(param1:int, param2:int, param3:int, param4:int) : Boolean
      {
         var _loc5_:Boolean = false;
         if(this.m_contentRect.x != param1)
         {
            _loc5_ = true;
            this.m_contentRect.x = param1;
         }
         if(this.m_contentRect.y != param2)
         {
            _loc5_ = true;
            this.m_contentRect.y = param2;
         }
         if(this.m_contentRect.width != param3)
         {
            _loc5_ = true;
            this.m_contentRect.width = param3;
         }
         if(this.m_contentRect.height != param4)
         {
            _loc5_ = true;
            this.m_contentRect.height = param4;
         }
         return _loc5_;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super.updateDisplayList(param1,param2);
         if(this.scrollRect == null)
         {
            return;
         }
         var _loc3_:Number = param1;
         var _loc4_:Number = param2;
         var _loc5_:Rectangle = this.scrollRect;
         _loc5_.width = param1;
         _loc5_.height = param2;
         this.scrollRect = _loc5_;
         if(this.ui_media != null && this.ui_media.videoWidth > 0)
         {
            _loc6_ = this.ui_media.videoWidth;
            _loc7_ = this.ui_media.videoHeight;
            switch(this.m_scaleMode)
            {
               case ScaleMode.FILL:
                  this.ui_media.width = _loc3_;
                  this.ui_media.height = _loc4_;
                  break;
               case ScaleMode.UNIFORM_DOWN:
                  _loc8_ = _loc3_ / _loc6_;
                  _loc9_ = _loc4_ / _loc7_;
                  _loc10_ = Math.min(1,_loc8_ > _loc9_ ? _loc9_ : _loc8_);
                  this.ui_media.width = Math.max(1,_loc6_ * _loc10_);
                  this.ui_media.height = Math.max(1,_loc7_ * _loc10_);
                  break;
               case ScaleMode.UNIFORM:
                  _loc8_ = _loc3_ / _loc6_;
                  _loc9_ = _loc4_ / _loc7_;
                  _loc10_ = _loc8_ > _loc9_ ? _loc9_ : _loc8_;
                  this.ui_media.width = Math.max(1,_loc6_ * _loc10_);
                  this.ui_media.height = Math.max(1,_loc7_ * _loc10_);
                  break;
               default:
                  this.ui_media.width = _loc6_;
                  this.ui_media.height = _loc7_;
            }
            switch(this.m_hAlign)
            {
               case HorizontalAlign.LEFT:
                  this.ui_media.x = 0;
                  break;
               case HorizontalAlign.RIGHT:
                  this.ui_media.x = _loc3_ - this.ui_media.width;
                  break;
               default:
                  this.ui_media.x = (_loc3_ - this.ui_media.width) / 2;
            }
            switch(this.m_vAlign)
            {
               case VerticalAlign.TOP:
                  this.ui_media.y = 0;
                  break;
               case VerticalAlign.BOTTOM:
                  this.ui_media.y = _loc4_ - this.ui_media.height;
                  break;
               default:
                  this.ui_media.y = (_loc4_ - this.ui_media.height) / 2;
            }
         }
         if(this.ui_overlay)
         {
            this.ui_overlay.width = _loc3_;
            this.ui_overlay.height = _loc4_;
         }
         if(this.ui_media)
         {
            this.setContentRect(Math.max(0,this.ui_media.x),Math.max(0,this.ui_media.y),Math.min(this.ui_media.width,_loc3_),Math.min(this.ui_media.height,_loc4_));
         }
         this.setContainerRect();
      }
      
      protected function onMediaClosed(param1:Event) : void
      {
         this.clearVideo();
      }
      
      protected function onMediaLoading(param1:MediaRequestEvent) : void
      {
         if(this.ui_media != null)
         {
            this.ui_media.attachNetStream(this.m_playback.netStream);
         }
         this.addEventListener(Event.ENTER_FRAME,this.onMonitorSize);
      }
      
      protected function onMonitorSize(param1:Event = null) : void
      {
         if(this.ui_media != null && this.ui_media.videoWidth > 0)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onMonitorSize);
            this.invalidateDisplayList();
            this.validateDisplayList();
            this.ui_media.visible = true;
         }
      }
   }
}

