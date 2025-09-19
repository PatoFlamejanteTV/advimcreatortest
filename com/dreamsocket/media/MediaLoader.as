package com.dreamsocket.media
{
   import com.dreamsocket.data.IRange;
   import com.dreamsocket.data.Range;
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   
   public class MediaLoader extends AbstractMediaLoader
   {
      
      protected static const k_MONITOR_BUFFER_INTERVAL:uint = 75;
      
      protected var m_bufferMonitor:Timer;
      
      protected var m_bytesDownloaded:Range;
      
      protected var m_bytesTotal:int;
      
      protected var m_downloading:Boolean;
      
      protected var m_height:Number;
      
      protected var m_loader:Loader;
      
      protected var m_sourceURL:String;
      
      protected var m_width:Number;
      
      protected var ui_media:Sprite;
      
      public function MediaLoader()
      {
         super();
         this.m_bytesDownloaded = new Range(0,0);
         this.m_bytesTotal = 0;
         this.m_downloading = false;
         this.m_sourceWidth = 0;
         this.m_sourceHeight = 0;
         this.m_width = 0;
         this.m_height = 0;
         this.m_bufferMonitor = new Timer(MediaLoader.k_MONITOR_BUFFER_INTERVAL);
         this.m_bufferMonitor.addEventListener(TimerEvent.TIMER,this.onMonitorLoad,false,0,true);
         this.createChildren();
      }
      
      public function get bytesDownloaded() : IRange
      {
         return this.m_bytesDownloaded;
      }
      
      public function get bytesTotal() : uint
      {
         return this.m_bytesTotal;
      }
      
      public function get content() : DisplayObject
      {
         if(this.m_loader != null)
         {
            try
            {
               return this.m_loader.content;
            }
            catch(error:Error)
            {
            }
         }
         return null;
      }
      
      public function get downloading() : Boolean
      {
         return this.m_downloading;
      }
      
      override public function get height() : Number
      {
         return this.m_height;
      }
      
      override public function set height(param1:Number) : void
      {
         this.m_height = param1;
         if(this.ui_media != null)
         {
            this.ui_media.height = param1;
         }
      }
      
      public function set url(param1:String) : void
      {
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         if(param1 != this.m_sourceURL)
         {
            this.close();
            this.m_sourceURL = param1;
            this.m_sourceWidth = 0;
            this.m_sourceHeight = 0;
         }
         this.load();
      }
      
      public function get url() : String
      {
         return this.m_sourceURL;
      }
      
      override public function get width() : Number
      {
         return this.m_width;
      }
      
      override public function set width(param1:Number) : void
      {
         this.m_width = param1;
         if(this.ui_media != null)
         {
            this.ui_media.width = param1;
         }
      }
      
      public function load() : void
      {
         if(this.m_loader == null && this.m_sourceURL != null)
         {
            this.m_bufferMonitor.start();
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_OPENING));
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_LOADING));
            this.m_loader = new Loader();
            this.m_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
            this.m_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
            this.m_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.dispatchEvent,false,0,true);
            this.m_loader.contentLoaderInfo.addEventListener(Event.INIT,this.onInit,false,0,true);
            try
            {
               this.m_loader.load(new URLRequest(this.m_sourceURL));
            }
            catch(e:Error)
            {
               if(e is SecurityError)
               {
                  this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,e));
               }
            }
            this.ui_media.addChild(this.m_loader);
         }
      }
      
      public function close() : void
      {
         var _loc1_:* = this.m_loader != null;
         this.stopDownload();
         if(_loc1_)
         {
            this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_CLOSED));
         }
      }
      
      public function destroy() : void
      {
         this.close();
         this.m_sourceWidth = 0;
         this.m_sourceHeight = 0;
         this.m_sourceURL = null;
      }
      
      protected function clearDownloadEvents() : void
      {
         this.m_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.m_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.m_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.dispatchEvent);
         this.m_loader.contentLoaderInfo.removeEventListener(Event.INIT,this.onInit);
      }
      
      protected function createChildren() : void
      {
         this.ui_media = new Sprite();
         this.addChild(this.ui_media);
      }
      
      protected function setDownloading(param1:Boolean, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         if(param1 != this.m_downloading)
         {
            _loc3_ = isNaN(param2) ? 0 : param2;
            this.m_downloading = param1;
            this.dispatchEvent(new DownloadEvent(param1 ? DownloadEvent.DOWNLOAD_STARTED : DownloadEvent.DOWNLOAD_STOPPED,_loc3_));
         }
      }
      
      protected function stopDownload() : void
      {
         this.m_bufferMonitor.stop();
         this.setDownloading(false,this.m_bytesDownloaded.end / this.m_bytesTotal);
         this.m_width = 0;
         this.m_height = 0;
         if(this.m_bytesDownloaded.end > 0)
         {
            this.m_bytesDownloaded.end = 0;
            this.m_bytesTotal = 0;
            this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,0,0));
         }
         if(this.m_loader == null)
         {
            return;
         }
         this.clearDownloadEvents();
         this.ui_media.removeChild(this.m_loader);
         try
         {
            this.m_loader.close();
         }
         catch(error:*)
         {
         }
         try
         {
            this.m_loader.unload();
         }
         catch(e:*)
         {
         }
         this.m_loader = null;
      }
      
      protected function onInit(param1:Event) : void
      {
         this.clearDownloadEvents();
         this.m_loader.contentLoaderInfo.removeEventListener(Event.INIT,this.onInit);
         this.m_sourceWidth = this.m_loader.width;
         this.m_sourceHeight = this.m_loader.height;
         this.ui_media.width = this.m_sourceWidth;
         this.ui_media.height = this.m_sourceHeight;
         this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_READY));
      }
      
      protected function onIOError(param1:IOErrorEvent) : void
      {
         this.stopDownload();
         this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_IO_EXCEPTION,new IOError(param1.text)));
      }
      
      protected function onMonitorLoad(param1:TimerEvent) : void
      {
         var _loc2_:Loader = this.m_loader;
         if(_loc2_ == null || _loc2_.contentLoaderInfo == null)
         {
            return;
         }
         var _loc3_:int = int(_loc2_.contentLoaderInfo.bytesLoaded);
         var _loc4_:int = int(_loc2_.contentLoaderInfo.bytesTotal);
         var _loc5_:Number = _loc3_ / _loc4_;
         if(!isNaN(_loc3_) && _loc3_ > this.m_bytesDownloaded.end)
         {
            if(!this.m_downloading)
            {
               this.setDownloading(true,_loc5_);
            }
            this.m_bytesTotal = _loc4_;
            this.m_bytesDownloaded.end = _loc3_;
            this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,_loc5_));
            if(_loc5_ == 1 && !this.m_loader.contentLoaderInfo.hasEventListener(Event.INIT))
            {
               this.setDownloading(false,_loc5_);
               this.m_bufferMonitor.stop();
            }
         }
      }
      
      protected function onSecurityError(param1:SecurityErrorEvent) : void
      {
         this.stopDownload();
         this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,new SecurityError(param1.text)));
      }
   }
}

