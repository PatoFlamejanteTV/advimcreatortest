package com.dreamsocket.flash.components
{
   import com.dreamsocket.flash.components.core.FlashUIComponent;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class ScrollingLabelComponent extends FlashUIComponent
   {
      
      protected var m_enabled:Boolean;
      
      protected var m_text:String;
      
      protected var m_scrollTimer:Timer;
      
      protected var m_scrollSpeed:Number;
      
      protected var m_scrollDelay:Number;
      
      public var ui_bgrnd:Sprite;
      
      public var ui_guideTxt:TextField;
      
      protected var ui_ltTxt:TextField;
      
      protected var ui_rtTxt:TextField;
      
      public function ScrollingLabelComponent()
      {
         super();
         this.m_enabled = true;
         this.m_text = "";
         this.m_scrollSpeed = 40;
         this.m_scrollDelay = 1000;
         this.m_scrollTimer = new Timer(this.m_scrollDelay);
         this.m_scrollTimer.addEventListener(TimerEvent.TIMER,this.onUpdateScroll);
      }
      
      public function set text(param1:String) : void
      {
         if(param1 != this.m_text)
         {
            this.m_text = param1;
            this.invalidateProperties();
            this.invalidateDisplayList();
         }
      }
      
      public function set speed(param1:Number) : void
      {
         this.m_scrollSpeed = param1;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(param1 != this.m_enabled)
         {
            this.m_enabled = param1;
            this.invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         this.ui_guideTxt.htmlText = this.m_text;
      }
      
      override protected function createChildren() : void
      {
         this.ui_ltTxt = new TextField();
         this.ui_ltTxt.antiAliasType = AntiAliasType.ADVANCED;
         this.ui_ltTxt.defaultTextFormat = this.ui_guideTxt.defaultTextFormat;
         this.ui_ltTxt.autoSize = TextFieldAutoSize.LEFT;
         this.ui_ltTxt.embedFonts = true;
         this.ui_ltTxt.selectable = false;
         this.ui_rtTxt = new TextField();
         this.ui_rtTxt.antiAliasType = AntiAliasType.ADVANCED;
         this.ui_rtTxt.defaultTextFormat = this.ui_guideTxt.defaultTextFormat;
         this.ui_rtTxt.autoSize = TextFieldAutoSize.LEFT;
         this.ui_rtTxt.embedFonts = true;
         this.ui_rtTxt.selectable = false;
         this.ui_guideTxt.selectable = false;
         this.scrollRect = new Rectangle(0,0,this.width,this.height);
      }
      
      protected function renderText() : void
      {
         this.m_scrollTimer.stop();
         if(this.ui_guideTxt.maxScrollH > 1 && this.m_enabled)
         {
            if(this.contains(this.ui_guideTxt))
            {
               this.removeChild(this.ui_guideTxt);
            }
            if(this.contains(this.ui_rtTxt))
            {
               this.removeChild(this.ui_rtTxt);
            }
            this.addChild(this.ui_ltTxt);
            this.ui_rtTxt.x = this.ui_ltTxt.x = 0;
            this.ui_ltTxt.htmlText = this.ui_rtTxt.htmlText = this.m_text;
            this.m_scrollTimer.delay = this.m_scrollDelay;
            this.m_scrollTimer.start();
         }
         else
         {
            if(this.contains(this.ui_rtTxt))
            {
               this.removeChild(this.ui_rtTxt);
            }
            if(this.contains(this.ui_rtTxt))
            {
               this.removeChild(this.ui_rtTxt);
            }
            this.ui_ltTxt.htmlText = this.ui_rtTxt.htmlText = "";
            this.addChild(this.ui_guideTxt);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Rectangle = this.scrollRect;
         this.ui_bgrnd.width = param1;
         this.ui_guideTxt.width = param1;
         _loc3_.width = this.width;
         this.scrollRect = _loc3_;
         this.renderText();
      }
      
      protected function onUpdateScroll(param1:TimerEvent) : void
      {
         var _loc2_:TextField = this.ui_ltTxt;
         var _loc3_:TextField = this.ui_rtTxt;
         this.addChild(_loc3_);
         --_loc2_.x;
         _loc3_.x = Math.round(_loc2_.x + _loc2_.width);
         if(_loc2_.x <= -_loc2_.width)
         {
            _loc2_.x = Math.round(_loc3_.x + _loc3_.width);
            this.ui_ltTxt = _loc3_;
            this.ui_rtTxt = _loc2_;
         }
         param1.updateAfterEvent();
         this.m_scrollTimer.delay = this.m_scrollSpeed;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.m_scrollTimer.stop();
      }
   }
}

