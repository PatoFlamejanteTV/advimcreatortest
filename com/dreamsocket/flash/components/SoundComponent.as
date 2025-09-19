package com.dreamsocket.flash.components
{
   import com.dreamsocket.flash.components.mediaClasses.AbstractPlaybackComponent;
   import com.dreamsocket.flash.components.views.IDEPlaybackView;
   import com.dreamsocket.media.SoundPlayback;
   
   public class SoundComponent extends AbstractPlaybackComponent
   {
      
      public static const PLAYBACK_TYPE:String = "SoundComponent";
      
      private var m_iconID:String = "com.dreamsocket.flash.components.livePreview.SoundIcon";
      
      protected var ui_livePreview:IDEPlaybackView;
      
      public function SoundComponent()
      {
         super();
      }
      
      override public function get playbackType() : String
      {
         return SoundComponent.PLAYBACK_TYPE;
      }
      
      override protected function commitProperties() : void
      {
         if(this.m_invalidSource && !this.isLivePreview())
         {
            this.m_playback.media = this.media;
            this.m_invalidSource = false;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.isLivePreview())
         {
            this.ui_livePreview = new IDEPlaybackView(this.width,this.height,this.playbackType,this.m_iconID,false);
            this.addChild(this.ui_livePreview);
         }
         else
         {
            this.m_playback = new SoundPlayback();
            this.configurePlayback();
            this.m_volumeControl.addClient(this.m_playback);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(this.isLivePreview())
         {
            this.ui_livePreview.setActualSize(param1,param2);
         }
      }
   }
}

