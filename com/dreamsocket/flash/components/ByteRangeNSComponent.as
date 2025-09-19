package com.dreamsocket.flash.components
{
   import com.dreamsocket.flash.components.views.IDEPlaybackView;
   import com.dreamsocket.flash.components.views.NSPlaybackView;
   import com.dreamsocket.media.ByteRangeNSPlayback;
   import com.dreamsocket.media.byteRangeNSClasses.ByteRangeNSRequestBuilder;
   
   public class ByteRangeNSComponent extends ProgressiveNSComponent
   {
      
      public static const PLAYBACK_TYPE:String = "ByteRangeNSComponent";
      
      private var m_iconID:String = "com.dreamsocket.flash.components.livePreview.ByteRangeNSIcon";
      
      public function ByteRangeNSComponent()
      {
         super();
         var _loc1_:Array = [ByteRangeNSRequestBuilder];
      }
      
      override public function get playbackType() : String
      {
         return ByteRangeNSComponent.PLAYBACK_TYPE;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:NSPlaybackView = null;
         super.createChildren();
         if(this.isLivePreview())
         {
            this.removeChild(this.ui_livePreview);
            this.ui_livePreview = new IDEPlaybackView(this.width,this.height,this.playbackType,this.m_iconID);
            this.addChild(this.ui_livePreview);
         }
         else
         {
            this.m_playback = new ByteRangeNSPlayback();
            this.configurePlayback();
            this.m_volumeControl.addClient(this.m_playback);
            _loc1_ = new NSPlaybackView();
            _loc1_.playback = ByteRangeNSPlayback(this.m_playback);
            this.addChild(_loc1_);
            this.ui_view = _loc1_;
         }
      }
   }
}

