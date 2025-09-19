package com.dreamsocket.flash.components
{
   import com.dreamsocket.flash.components.views.IDEPlaybackView;
   import com.dreamsocket.flash.components.views.MediaLoaderView;
   import com.dreamsocket.media.MediaLoader;
   
   public class SoundWithImageComponent extends SoundComponent
   {
      
      public static const PLAYBACK_TYPE:String = "SoundWithImageComponent";
      
      private var m_iconID:String = "com.dreamsocket.flash.components.livePreview.SoundWithImageIcon";
      
      protected var ui_loader:MediaLoader;
      
      public function SoundWithImageComponent()
      {
         super();
      }
      
      override public function get playbackType() : String
      {
         return SoundWithImageComponent.PLAYBACK_TYPE;
      }
      
      override public function close() : void
      {
         super.close();
         if(this.ui_loader != null)
         {
            this.ui_loader.close();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.isLivePreview())
         {
            return;
         }
         if(this.m_media != null && this.m_media.poster != null)
         {
            this.ui_loader.url = this.m_media.poster;
         }
         else
         {
            this.ui_loader.close();
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:MediaLoaderView = null;
         super.createChildren();
         if(this.isLivePreview())
         {
            this.removeChild(this.ui_livePreview);
            this.ui_livePreview = new IDEPlaybackView(this.width,this.height,this.playbackType,this.m_iconID,false);
            this.addChild(this.ui_livePreview);
         }
         else
         {
            this.ui_loader = new MediaLoader();
            _loc1_ = new MediaLoaderView();
            _loc1_.loader = MediaLoader(this.ui_loader);
            this.addChild(_loc1_);
            this.ui_view = _loc1_;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:MediaLoaderView = null;
         super.updateDisplayList(param1,param2);
         if(!this.isLivePreview())
         {
            _loc3_ = MediaLoaderView(this.ui_view);
            _loc3_.verticalAlign = this.verticalAlign;
            _loc3_.horizontalAlign = this.horizontalAlign;
            _loc3_.scaleMode = this.scaleMode;
            _loc3_.setActualSize(param1,param2);
            _loc3_.validateDisplayList();
         }
      }
   }
}

