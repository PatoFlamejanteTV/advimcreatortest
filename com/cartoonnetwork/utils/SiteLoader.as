package com.cartoonnetwork.utils
{
   import com.cartoonnetwork.events.SiteLoaderEvent;
   import flash.display.LoaderInfo;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SiteLoader extends EventDispatcher
   {
      
      protected var a_o:Object;
      
      protected var _swfInfo:LoaderInfo;
      
      protected var _loadTimer:Timer;
      
      public function SiteLoader(param1:*)
      {
         super();
         this.a_o = param1;
         this._swfInfo = LoaderInfo(this.a_o.root.loaderInfo);
         this._loadTimer = new Timer(200,0);
         this._loadTimer.addEventListener(TimerEvent.TIMER,this.onEnterFRAME,false,0,true);
         this._loadTimer.start();
      }
      
      public function onEnterFRAME(param1:TimerEvent) : void
      {
         var _loc2_:Number = Math.round(this._swfInfo.bytesLoaded / this._swfInfo.bytesTotal * 100);
         dispatchEvent(new SiteLoaderEvent(SiteLoaderEvent.PROGRESS,false,_loc2_));
         if(_loc2_ == 100)
         {
            this._loadTimer.stop();
            this._loadTimer.removeEventListener(TimerEvent.TIMER,this.onEnterFRAME);
            this.onComplete();
         }
      }
      
      public function onComplete() : void
      {
         trace("SiteLoader onComplete");
         dispatchEvent(new SiteLoaderEvent(SiteLoaderEvent.COMPLETE));
      }
   }
}

