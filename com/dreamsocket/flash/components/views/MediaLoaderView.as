package com.dreamsocket.flash.components.views
{
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.flash.components.core.FlashUIComponent;
   import com.dreamsocket.layout.HorizontalAlign;
   import com.dreamsocket.layout.VerticalAlign;
   import com.dreamsocket.media.AbstractMediaLoader;
   import com.dreamsocket.media.IMediaView;
   import com.dreamsocket.media.ScaleMode;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class MediaLoaderView extends FlashUIComponent implements IMediaView
   {
      
      protected var ui_media:AbstractMediaLoader;
      
      protected var ui_bgrnd:Sprite;
      
      protected var m_containerRect:Rectangle;
      
      protected var m_contentRect:Rectangle;
      
      protected var m_scaleMode:String;
      
      protected var m_vAlign:String;
      
      protected var m_hAlign:String;
      
      public function MediaLoaderView()
      {
         super();
         this.m_containerRect = new Rectangle();
         this.m_contentRect = new Rectangle();
         this.m_hAlign = HorizontalAlign.CENTER;
         this.m_scaleMode = ScaleMode.UNIFORM;
         this.m_vAlign = VerticalAlign.MIDDLE;
      }
      
      public function get containerRect() : Rectangle
      {
         return this.m_containerRect;
      }
      
      public function get contentRect() : Rectangle
      {
         return this.m_contentRect;
      }
      
      public function get loader() : AbstractMediaLoader
      {
         return this.ui_media;
      }
      
      public function set loader(param1:AbstractMediaLoader) : void
      {
         if(this.isLivePreview())
         {
            return;
         }
         if(param1 != this.ui_media)
         {
            if(this.ui_media != null)
            {
               this.removeChild(this.ui_media);
               this.ui_media.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_READY,this.onMediaReady);
            }
            this.ui_media = param1;
            this.ui_media.addEventListener(MediaRequestEvent.MEDIA_REQUEST_READY,this.onMediaReady,false,0,true);
            this.addChild(this.ui_media);
            this.invalidateDisplayList();
         }
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
         if(this.ui_media != null)
         {
            this.removeChild(this.ui_media);
            this.ui_media.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_READY,this.onMediaReady);
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Graphics = null;
         super.createChildren();
         this.ui_bgrnd = new Sprite();
         _loc1_ = this.ui_bgrnd.graphics;
         _loc1_.beginFill(0);
         _loc1_.drawRect(0,0,1,1);
         _loc1_.endFill();
         this.ui_bgrnd.width = this.width;
         this.ui_bgrnd.height = this.height;
         this.scrollRect = new Rectangle(0,0,this.width,this.height);
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
         if(this.ui_media != null && this.ui_media.sourceWidth > 0)
         {
            _loc6_ = this.ui_media.sourceWidth;
            _loc7_ = this.ui_media.sourceHeight;
            this.removeChild(this.ui_media);
            this.addChild(this.ui_media);
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
         var _loc5_:Rectangle = this.scrollRect;
         _loc5_.width = _loc3_;
         _loc5_.height = _loc4_;
         this.scrollRect = _loc5_;
         if(this.ui_bgrnd)
         {
            this.ui_bgrnd.width = _loc3_;
            this.ui_bgrnd.height = _loc4_;
         }
         if(this.ui_media)
         {
            this.setContentRect(Math.max(0,this.ui_media.x),Math.max(0,this.ui_media.y),Math.min(this.ui_media.width,_loc3_),Math.min(this.ui_media.height,_loc4_));
         }
         this.setContainerRect();
      }
      
      protected function onMediaReady(param1:MediaRequestEvent) : void
      {
         this.invalidateDisplayList();
         this.validateDisplayList();
      }
   }
}

