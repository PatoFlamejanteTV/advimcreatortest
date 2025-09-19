package tv.freewheel.ad.behavior
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class IAdManager
   {
      
      protected var pool2:Dictionary;
      
      protected var pool:Dictionary;
      
      protected var constants:IConstants;
      
      internal var proxied:Object;
      
      public function IAdManager(param1:Object)
      {
         super();
         this.proxied = param1;
         pool = new Dictionary();
         pool2 = new Dictionary();
      }
      
      public function setVisitorHttpHeader(param1:String, param2:String) : void
      {
         this.proxied.setVisitorHttpHeader(param1,param2);
      }
      
      public function addRenderer(param1:String, param2:String = null, param3:String = null, param4:String = null, param5:String = null, param6:Object = null, param7:String = null) : void
      {
         this.proxied.addRenderer(param1,param2,param3,param4,param5,param6,param7);
      }
      
      public function finalizeRendererStateTransition(param1:Object) : void
      {
         this.proxied.finalizeRendererStateTransition(param1);
      }
      
      public function setParameterObject(param1:String, param2:Object, param3:uint) : void
      {
         this.proxied.setParameterObject(param1,param2,param3);
      }
      
      public function setRequestDuration(param1:Number) : void
      {
         this.proxied.setRequestDuration(param1);
      }
      
      public function setVideoPlayer(param1:uint) : void
      {
         this.proxied.setVideoPlayer(param1);
      }
      
      public function registerVideoDisplay(param1:Sprite) : void
      {
         this.proxied.registerVideoDisplay(param1);
      }
      
      public function getTemporalSlots() : Array
      {
         var _loc1_:Array = this.proxied.getTemporalSlots().slice();
         var _loc2_:Array = new Array();
         while(_loc1_.length)
         {
            _loc2_.push(this._ISlot(_loc1_.pop()));
         }
         return _loc2_;
      }
      
      public function addTemporalSlot(param1:String, param2:String, param3:Number, param4:String = null, param5:uint = 0, param6:Number = 0, param7:Object = null, param8:String = null, param9:String = null, param10:Number = 0, param11:uint = 0, param12:Sprite = null) : ISlot
      {
         var _loc13_:Object = this.proxied.addTemporalSlot(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         return _loc13_ ? this._ISlot(_loc13_) : null;
      }
      
      public function getParameterObject(param1:String, param2:uint = 0) : Object
      {
         return this.proxied.getParameterObject(param1,param2);
      }
      
      public function getAdVolume() : uint
      {
         return this.proxied.getAdVolume();
      }
      
      public function setRequestMode(param1:String) : void
      {
         this.proxied.setRequestMode(param1);
      }
      
      public function setAdPlayState(param1:Boolean) : void
      {
         this.proxied.setAdPlayState(param1);
      }
      
      public function getConstants() : IConstants
      {
         var _loc1_:Object = this.proxied.getConstants();
         return _loc1_ ? this._IConstants(_loc1_) : null;
      }
      
      public function setCapability(param1:String, param2:*, param3:Object = null) : Boolean
      {
         return this.proxied.setCapability(param1,param2,param3);
      }
      
      public function getVideoPlayerNonTemporalSlots() : Array
      {
         var _loc1_:Array = this.proxied.getVideoPlayerNonTemporalSlots().slice();
         var _loc2_:Array = new Array();
         while(_loc1_.length)
         {
            _loc2_.push(this._ISlot(_loc1_.pop()));
         }
         return _loc2_;
      }
      
      public function setAdVolume(param1:uint) : void
      {
         this.proxied.setAdVolume(param1);
      }
      
      public function getActiveSlots() : Array
      {
         var _loc1_:Array = this.proxied.getActiveSlots().slice();
         var _loc2_:Array = new Array();
         while(_loc1_.length)
         {
            _loc2_.push(this._ISlot(_loc1_.pop()));
         }
         return _loc2_;
      }
      
      public function getVersion() : uint
      {
         return this.proxied.getVersion();
      }
      
      public function addCandidateAd(param1:uint) : void
      {
         this.proxied.addCandidateAd(param1);
      }
      
      public function dispose() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         this.proxied.dispose();
         for(_loc1_ in pool2)
         {
            pool2[_loc1_].proxied = null;
            delete pool2[_loc1_];
         }
         for(_loc2_ in pool)
         {
            delete pool[_loc2_];
         }
         constants = null;
         proxied = null;
      }
      
      public function registerPlayheadTimeCallback(param1:Function) : void
      {
         this.proxied.registerPlayheadTimeCallback(param1);
      }
      
      public function setVisitor(param1:String, param2:String = null, param3:uint = 0, param4:String = null) : void
      {
         this.proxied.setVisitor(param1,param2,param3,param4);
      }
      
      public function setEventCallbackKeyValue(param1:String, param2:String) : void
      {
         this.proxied.setEventCallbackKeyValue(param1,param2);
      }
      
      public function addSiteSectionNonTemporalSlot(param1:String, param2:uint, param3:uint, param4:String = null, param5:Boolean = true, param6:* = 0, param7:String = null, param8:Object = null, param9:String = null, param10:String = null, param11:Sprite = null, param12:Array = null) : ISlot
      {
         var _loc13_:Object = this.proxied.addSiteSectionNonTemporalSlot(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         return _loc13_ ? this._ISlot(_loc13_) : null;
      }
      
      public function setRendererConfiguration(param1:String, param2:String = null) : void
      {
         this.proxied.setRendererConfiguration(param1,param2);
      }
      
      protected function _IConstants(param1:Object) : IConstants
      {
         if(!constants)
         {
            constants = new IConstants(param1);
         }
         return constants;
      }
      
      public function setVideoAsset(param1:String, param2:Number, param3:String = null, param4:Boolean = true, param5:Number = 0, param6:uint = 0, param7:uint = 0, param8:uint = 0, param9:String = null) : void
      {
         this.proxied.setVideoAsset(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public function getVideoDisplay() : Sprite
      {
         return this.proxied.getVideoDisplay();
      }
      
      public function setLiveMode(param1:Boolean) : void
      {
         this.proxied.setLiveMode(param1);
      }
      
      public function debugInitialize(param1:Object) : void
      {
         this.proxied.debugInitialize(param1);
      }
      
      public function setServer(param1:String = null) : void
      {
         this.proxied.setServer(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         if(param2 != null && Boolean(pool[param2]))
         {
            this.proxied.removeEventListener(param1,pool[param2]);
         }
      }
      
      public function registerRendererStateTransitionCallback(param1:uint, param2:Function) : void
      {
         this.proxied.registerRendererStateTransitionCallback(param1,param2);
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         var event:String = param1;
         var handler:Function = param2;
         if(handler != null && !pool[handler])
         {
            pool[handler] = function(param1:Object):void
            {
               handler(new IEvent(param1));
            };
         }
         this.proxied.addEventListener(event,pool[handler]);
      }
      
      public function addVideoPlayerNonTemporalSlot(param1:String, param2:Sprite, param3:uint, param4:uint, param5:String = null, param6:int = 0, param7:int = 0, param8:Boolean = true, param9:String = null, param10:Object = null, param11:String = null, param12:String = null, param13:* = null, param14:Array = null) : ISlot
      {
         var _loc15_:Object = this.proxied.addVideoPlayerNonTemporalSlot(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14);
         return _loc15_ ? this._ISlot(_loc15_) : null;
      }
      
      public function setKeyValue(param1:String, param2:String) : void
      {
         this.proxied.setKeyValue(param1,param2);
      }
      
      public function submitRequest(param1:Number = 0, param2:uint = 0) : void
      {
         this.proxied.submitRequest(param1,param2);
      }
      
      public function startSubsession(param1:uint) : void
      {
         this.proxied.startSubsession(param1);
      }
      
      public function refresh() : void
      {
         var _loc1_:Object = null;
         this.proxied.refresh();
         for(_loc1_ in pool2)
         {
            pool2[_loc1_].proxied = null;
            delete pool2[_loc1_];
         }
      }
      
      public function setSiteSection(param1:String, param2:Number = 0, param3:uint = 0, param4:uint = 0, param5:uint = 0) : void
      {
         this.proxied.setSiteSection(param1,param2,param3,param4,param5);
      }
      
      public function getVideoDisplaySize() : Rectangle
      {
         return this.proxied.getVideoDisplaySize();
      }
      
      public function setVideoPlayStatus(param1:uint) : void
      {
         this.proxied.setVideoPlayStatus(param1);
      }
      
      public function addSlotsByUrl(param1:String) : void
      {
         this.proxied.addSlotsByUrl(param1);
      }
      
      public function scanSlotsOnPage(param1:Number = 0, param2:Function = null, param3:Boolean = false) : Array
      {
         var _this:* = undefined;
         var maxWaitSeconds:Number = param1;
         var onComplete:Function = param2;
         var keepInitialAds:Boolean = param3;
         _this = this;
         var r:Array = this.proxied.scanSlotsOnPage(maxWaitSeconds,onComplete != null ? function(param1:Array):void
         {
            var _loc2_:* = new Array();
            var _loc3_:* = param1.slice();
            while(_loc3_.length)
            {
               _loc2_.push(_this._ISlot(_loc3_.pop()));
            }
            onComplete(_loc2_);
         } : null,keepInitialAds).slice();
         var a:Array = new Array();
         while(r.length)
         {
            a.push(this._ISlot(r.pop()));
         }
         return a;
      }
      
      public function setProfile(param1:String, param2:String = null, param3:String = null, param4:String = null) : void
      {
         this.proxied.setProfile(param1,param2,param3,param4);
      }
      
      protected function _ISlot(param1:Object) : ISlot
      {
         if(!pool2[param1])
         {
            pool2[param1] = new ISlot(param1);
         }
         return pool2[param1];
      }
      
      public function setVideoDisplaySize(param1:int, param2:int, param3:uint, param4:uint, param5:int, param6:int, param7:uint, param8:uint) : void
      {
         this.proxied.setVideoDisplaySize(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function setNetwork(param1:uint) : void
      {
         this.proxied.setNetwork(param1);
      }
      
      public function getSiteSectionNonTemporalSlots() : Array
      {
         var _loc1_:Array = this.proxied.getSiteSectionNonTemporalSlots().slice();
         var _loc2_:Array = new Array();
         while(_loc1_.length)
         {
            _loc2_.push(this._ISlot(_loc1_.pop()));
         }
         return _loc2_;
      }
      
      public function getParameter(param1:String, param2:uint = 0) : String
      {
         return this.proxied.getParameter(param1,param2);
      }
      
      public function setCustomDistributor(param1:String, param2:String, param3:String) : void
      {
         this.proxied.setCustomDistributor(param1,param2,param3);
      }
      
      public function setParameter(param1:String, param2:String, param3:uint) : void
      {
         this.proxied.setParameter(param1,param2,param3);
      }
      
      public function getSlotByCustomId(param1:String) : ISlot
      {
         var _loc2_:Object = this.proxied.getSlotByCustomId(param1);
         return _loc2_ ? this._ISlot(_loc2_) : null;
      }
      
      public function setVideoAssetCurrentTimePosition(param1:Number) : void
      {
         this.proxied.setVideoAssetCurrentTimePosition(param1);
      }
   }
}

