package com.dreamsocket.flash.components
{
   import com.dreamsocket.flash.components.mediaClasses.AbstractPlaybackComponent;
   import com.dreamsocket.flash.components.views.IDEPlaybackView;
   import com.dreamsocket.flash.components.views.MediaLoaderView;
   import com.dreamsocket.media.TimedImagePlayback;
   
   public class TimedImageComponent extends AbstractPlaybackComponent
   {
      
      public static const PLAYBACK_TYPE:String = "TimedImageComponent";
      
      private var m_iconID:String = "com.dreamsocket.flash.components.livePreview.TimedImageIcon";
      
      protected var ui_livePreview:IDEPlaybackView;
      
      public function TimedImageComponent()
      {
         super();
      }
      
      override public function get playbackType() : String
      {
         return TimedImageComponent.PLAYBACK_TYPE;
      }
      
      override protected function commitProperties() : void
      {
         if(this.m_invalidSource)
         {
            this.m_playback.media = this.media;
            this.m_invalidSource = false;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:MediaLoaderView = null;
         super.createChildren();
         if(this.isLivePreview())
         {
            this.ui_livePreview = new IDEPlaybackView(this.width,this.height,this.playbackType,this.m_iconID);
            this.addChild(this.ui_livePreview);
         }
         else
         {
            this.m_playback = new TimedImagePlayback();
            this.configurePlayback();
            this.m_volumeControl.addClient(this.m_playback);
            _loc1_ = new MediaLoaderView();
            _loc1_.loader = TimedImagePlayback(this.m_playback);
            this.addChild(_loc1_);
            this.ui_view = _loc1_;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:MediaLoaderView = null;
         super.updateDisplayList(param1,param2);
         if(this.isLivePreview())
         {
            this.ui_livePreview.setActualSize(param1,param2);
         }
         else
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

