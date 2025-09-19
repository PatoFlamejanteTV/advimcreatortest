package com.dreamsocket.flash.components.core
{
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class FlashUIComponent extends Sprite
   {
      
      protected var m_callLaterMethods:Array;
      
      protected var m_callLaterHash:Dictionary;
      
      protected var m_childrenCreated:Boolean;
      
      protected var m_invalidTypes:Object;
      
      protected var m_isLivePreview:Boolean;
      
      protected var m_validating:Boolean;
      
      protected var m_width:Number;
      
      protected var m_height:Number;
      
      public function FlashUIComponent()
      {
         super();
         var _loc1_:Number = this.rotation;
         this.m_childrenCreated = false;
         this.m_isLivePreview = this.isLivePreview();
         this.rotation = 0;
         this.m_width = super.width;
         this.m_height = super.height;
         this.scaleX = this.scaleY = 1;
         this.rotation = _loc1_;
         this.focusRect = false;
         this.m_validating = false;
         this.m_invalidTypes = {};
         if(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         this.addEventListener(Event.UNLOAD,this.onUnloadEvent,false,0,true);
         this.invalidateProperties();
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      override public function set height(param1:Number) : void
      {
         if(this.m_height == param1)
         {
            return;
         }
         this.setActualSize(this.width,param1);
      }
      
      override public function get height() : Number
      {
         return this.m_height;
      }
      
      override public function set width(param1:Number) : void
      {
         if(this.m_width == param1)
         {
            return;
         }
         this.setActualSize(param1,this.m_height);
      }
      
      override public function get width() : Number
      {
         return this.m_width;
      }
      
      public function destroy() : void
      {
         this.cancelAllCallLaters();
      }
      
      public function getFocus() : InteractiveObject
      {
         if(stage)
         {
            return stage.focus;
         }
         return null;
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function setActualSize(param1:Number, param2:Number) : void
      {
         var _loc3_:Boolean = false;
         if(!isNaN(param1) && this.m_width != param1)
         {
            _loc3_ = true;
            this.m_width = param1;
         }
         if(!isNaN(param2) && this.m_height != param2)
         {
            _loc3_ = true;
            this.m_height = param2;
         }
         if(_loc3_)
         {
            this.invalidate(InvalidationType.SIZE,true);
            this.invalidate(InvalidationType.DISPLAY_LIST,true);
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this.setActualSize(param1,param2);
         this.validateNow();
      }
      
      public function setFocus() : void
      {
         if(this.stage)
         {
            this.stage.focus = this;
         }
      }
      
      public function validateDisplayList() : void
      {
         if(this.isInvalid(InvalidationType.DISPLAY_LIST))
         {
            this.validate(InvalidationType.DISPLAY_LIST);
            this.updateDisplayList(this.m_width,this.m_height);
         }
      }
      
      public function validateNow() : void
      {
         if(!this.m_childrenCreated)
         {
            this.m_childrenCreated = true;
            this.createChildren();
         }
         this.validateProperties();
         this.validateSize();
         this.validateDisplayList();
      }
      
      public function validateProperties() : void
      {
         if(this.isInvalid(InvalidationType.DATA))
         {
            this.validate(InvalidationType.DATA);
            this.commitProperties();
         }
      }
      
      public function validateSize() : void
      {
         if(this.isInvalid(InvalidationType.SIZE))
         {
            this.validate(InvalidationType.SIZE);
            this.measure();
         }
      }
      
      protected function callLater(param1:Function) : void
      {
         if(this.m_validating)
         {
            return;
         }
         if(this.m_callLaterMethods == null)
         {
            this.m_callLaterMethods = new Array();
            this.m_callLaterHash = new Dictionary(true);
         }
         if(this.m_callLaterHash[param1] == null)
         {
            this.m_callLaterHash[param1] = true;
            this.m_callLaterMethods.push(param1);
            if(this.stage != null)
            {
               this.stage.addEventListener(Event.ENTER_FRAME,this.doLaterDispatcher,false,0,true);
               this.stage.invalidate();
            }
            else
            {
               this.addEventListener(Event.ADDED_TO_STAGE,this.doLaterDispatcher,false,0,true);
            }
         }
      }
      
      protected function cancelAllCallLaters() : void
      {
         if(this.stage != null)
         {
            this.stage.removeEventListener(Event.ENTER_FRAME,this.doLaterDispatcher);
            this.stage.removeEventListener(Event.ADDED_TO_STAGE,this.doLaterDispatcher);
         }
         this.m_callLaterMethods = null;
         this.m_callLaterHash = null;
      }
      
      protected function commitProperties() : void
      {
      }
      
      protected function createChildren() : void
      {
      }
      
      protected function doLaterDispatcher(param1:Event) : void
      {
         var _loc3_:Function = null;
         if(param1.type == Event.ADDED_TO_STAGE)
         {
            this.removeEventListener(Event.ADDED_TO_STAGE,this.doLaterDispatcher);
            this.stage.addEventListener(Event.ENTER_FRAME,this.doLaterDispatcher,false,0,true);
            this.stage.invalidate();
            return;
         }
         Stage(param1.target).removeEventListener(Event.ENTER_FRAME,this.doLaterDispatcher);
         if(this.stage == null)
         {
            this.addEventListener(Event.ADDED_TO_STAGE,this.doLaterDispatcher,false,0,true);
            return;
         }
         this.m_validating = true;
         var _loc2_:Array = this.m_callLaterMethods.concat();
         this.cancelAllCallLaters();
         if(_loc2_.length > 0)
         {
            while(true)
            {
               _loc3_ = _loc2_.shift();
               if(_loc3_ == null)
               {
                  break;
               }
               _loc3_();
            }
         }
         this.m_validating = false;
      }
      
      protected function invalidate(param1:String, param2:Boolean = true) : void
      {
         this.m_invalidTypes[param1] = true;
         if(param2)
         {
            this.callLater(this.validateNow);
         }
      }
      
      protected function invalidateDisplayList() : void
      {
         this.invalidate(InvalidationType.DISPLAY_LIST);
      }
      
      protected function invalidateProperties() : void
      {
         this.invalidate(InvalidationType.DATA);
      }
      
      protected function invalidateSize() : void
      {
         this.invalidate(InvalidationType.SIZE);
      }
      
      protected function isInvalid(param1:String, ... rest) : Boolean
      {
         if(this.m_invalidTypes[param1] != null || Boolean(this.m_invalidTypes[InvalidationType.ALL]))
         {
            return true;
         }
         var _loc3_:Number = Number(rest.length);
         while(_loc3_--)
         {
            if(this.m_invalidTypes[rest[_loc3_]] != null)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function isLivePreview() : Boolean
      {
         var className:String = null;
         if(this.parent == null)
         {
            return false;
         }
         try
         {
            className = getQualifiedClassName(parent);
         }
         catch(e:Error)
         {
         }
         return className == "fl.livepreview::LivePreviewParent";
      }
      
      protected function measure() : void
      {
      }
      
      protected function updateDisplayList(param1:Number, param2:Number) : void
      {
      }
      
      protected function validate(param1:String) : void
      {
         delete this.m_invalidTypes[param1];
      }
      
      protected function onUnloadEvent(param1:Event) : void
      {
         this.destroy();
      }
   }
}

