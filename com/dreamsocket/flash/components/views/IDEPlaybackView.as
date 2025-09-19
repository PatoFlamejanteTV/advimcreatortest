package com.dreamsocket.flash.components.views
{
   import com.dreamsocket.core.MediaFramework;
   import com.dreamsocket.utils.Version;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getDefinitionByName;
   
   public class IDEPlaybackView extends Sprite
   {
      
      protected var m_componentName:String;
      
      protected var m_showSize:Boolean;
      
      protected var m_containerUI:Sprite;
      
      protected var m_componentTxtUI:TextField;
      
      protected var m_iconUI:DisplayObject;
      
      protected var m_sizeTxtUI:TextField;
      
      protected var m_bgrndUI:Sprite;
      
      protected var m_maskUI:Sprite;
      
      public function IDEPlaybackView(param1:Number, param2:Number, param3:String, param4:String = null, param5:Boolean = true)
      {
         var p_width:Number = param1;
         var p_height:Number = param2;
         var p_componentName:String = param3;
         var p_icon:String = param4;
         var p_showSize:Boolean = param5;
         super();
         this.m_componentName = p_componentName;
         this.m_showSize = p_showSize;
         try
         {
            this.m_iconUI = new (getDefinitionByName(p_icon))() as DisplayObject;
         }
         catch(e:Error)
         {
         }
         this.createChildren();
         this.setActualSize(p_width,p_height);
      }
      
      public function setActualSize(param1:Number, param2:Number) : void
      {
         if(this.m_showSize)
         {
            this.m_sizeTxtUI.htmlText = "<font color=\"#FFFFFF\">SIZE: </font><font color=\"#CCCCCC\">" + param1 + " X " + param2 + "</font>";
         }
         this.m_maskUI.width = param1;
         this.m_maskUI.height = param2;
         this.m_bgrndUI.width = param1;
         this.m_bgrndUI.height = param2;
         this.m_sizeTxtUI.width = param1 - 20;
         this.m_componentTxtUI.width = param1 - 20;
         if(this.m_iconUI != null)
         {
            this.m_iconUI.x = param1 / 2 - this.m_iconUI.width / 2;
            this.m_iconUI.y = param2 / 2 - this.m_iconUI.height / 2;
         }
      }
      
      protected function createChildren() : void
      {
         this.m_maskUI = new Sprite();
         this.m_maskUI.graphics.beginFill(0);
         this.m_maskUI.graphics.drawRect(0,0,1,1);
         this.m_maskUI.graphics.endFill();
         this.addChild(this.m_maskUI);
         this.m_containerUI = new Sprite();
         this.m_containerUI.mask = this.m_maskUI;
         this.addChild(this.m_containerUI);
         this.m_bgrndUI = new Sprite();
         this.m_bgrndUI.graphics.beginFill(0);
         this.m_bgrndUI.graphics.drawRect(0,0,1,1);
         this.m_bgrndUI.graphics.endFill();
         this.m_bgrndUI.alpha = 0.5;
         this.m_containerUI.addChild(this.m_bgrndUI);
         this.m_sizeTxtUI = new TextField();
         this.m_sizeTxtUI.defaultTextFormat = new TextFormat("_sans");
         this.m_sizeTxtUI.x = 10;
         this.m_sizeTxtUI.y = 30;
         this.m_containerUI.addChild(this.m_sizeTxtUI);
         this.m_componentTxtUI = new TextField();
         this.m_componentTxtUI.defaultTextFormat = new TextFormat("_sans");
         this.m_componentTxtUI.x = 10;
         this.m_componentTxtUI.y = 15;
         this.m_containerUI.addChild(this.m_componentTxtUI);
         if(this.m_iconUI != null)
         {
            this.m_containerUI.addChild(this.m_iconUI);
         }
         var _loc1_:Version = MediaFramework.version;
         var _loc2_:* = _loc1_.major + "." + _loc1_.minor + "." + _loc1_.revision + "(FlashAS3)";
         this.m_componentTxtUI.htmlText = "<font color=\"#FFFFFF\">" + this.m_componentName + ": </font><font color=\"#CCCCCC\">" + _loc2_ + "</font>";
      }
   }
}

