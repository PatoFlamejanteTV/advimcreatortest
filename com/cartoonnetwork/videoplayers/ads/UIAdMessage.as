package com.cartoonnetwork.videoplayers.ads
{
   import com.cartoonnetwork.videoplayers.core.IPlaybackControls;
   import com.dreamsocket.ads.IAd;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import com.dreamsocket.flash.components.ScrollingLabelComponent;
   import com.dreamsocket.media.IPlayback;
   import com.dreamsocket.media.MediaState;
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class UIAdMessage extends ScrollingLabelComponent implements IPlaybackControls
   {
      
      protected var m_playback:IPlayback;
      
      public function UIAdMessage()
      {
         super();
      }
      
      public function set playback(param1:IPlayback) : void
      {
         if(param1 != this.m_playback)
         {
            if(this.m_playback != null)
            {
               this.m_playback.removeEventListener(StateChangeEvent.STATE_CHANGED,this.onStateChanged);
               this.m_playback.removeEventListener(TimeEvent.TIME_POSITION_CHANGED,this.onTimePositionChanged);
            }
            this.m_playback = param1;
            this.m_playback.addEventListener(StateChangeEvent.STATE_CHANGED,this.onStateChanged,false,0,true);
            this.m_playback.addEventListener(TimeEvent.TIME_POSITION_CHANGED,this.onTimePositionChanged,false,0,true);
         }
      }
      
      override protected function createChildren() : void
      {
         this.ui_bgrnd = new Sprite();
         this.ui_bgrnd.graphics.beginFill(0);
         this.ui_bgrnd.graphics.drawRect(0,0,this.width,this.height);
         this.ui_bgrnd.graphics.endFill();
         this.ui_bgrnd.alpha = 0.5;
         this.addChild(this.ui_bgrnd);
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.align = TextFormatAlign.CENTER;
         _loc1_.font = "Arial";
         _loc1_.size = 11;
         _loc1_.color = 16777215;
         this.ui_guideTxt = new TextField();
         this.ui_guideTxt.antiAliasType = AntiAliasType.ADVANCED;
         this.ui_guideTxt.embedFonts = true;
         this.ui_guideTxt.defaultTextFormat = _loc1_;
         super.createChildren();
      }
      
      protected function onStateChanged(param1:StateChangeEvent) : void
      {
         switch(param1.newState)
         {
            case MediaState.PLAYING:
               this.visible = this.m_playback is IAd;
               break;
            case MediaState.CLOSED:
            case MediaState.ENDED:
               this.visible = false;
         }
      }
      
      protected function onTimePositionChanged(param1:TimeEvent) : void
      {
         if(this.m_playback.duration == 0 || this.m_playback.currentTime == 0 || !(this.m_playback is IAd))
         {
            return;
         }
         var _loc2_:Number = Math.max(1,int(this.m_playback.duration - this.m_playback.currentTime));
         var _loc3_:* = "";
         _loc3_ += "ADVERTISEMENT: YOUR GAME WILL LOAD IN ";
         _loc3_ += String(_loc2_) + " ";
         _loc3_ += _loc2_ > 1 ? "SECONDS" : "SECOND";
         this.text = _loc3_;
      }
   }
}

