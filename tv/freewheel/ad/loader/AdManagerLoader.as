package tv.freewheel.ad.loader
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.system.SecurityDomain;
   import tv.freewheel.ad.behavior.IAdManager;
   import tv.freewheel.ad.behavior.IEvent;
   
   public class AdManagerLoader extends Sprite
   {
      
      public static var forceAdManagerUrl:String;
      
      private static const Tag:String = "3.0.1";
      
      private static const Revision:String = "4580";
      
      private static const Timestamp:String = "1004200837";
      
      private static const Caller:String = "AS3-" + Tag + "-r" + Revision + "-" + Timestamp;
      
      public static const LEVEL_DEBUG:String = "VERBOSE";
      
      public static const LEVEL_INFO:String = "INFO";
      
      public static const LEVEL_WARNING:String = "WARN";
      
      public static const LEVEL_ERROR:String = "ERROR";
      
      public static const LEVEL_QUIET:String = "QUIET";
      
      private static var AdManagerTagInjected:Boolean = injectAdManagerTag();
      
      private var __adManagerMC:MovieClip;
      
      private var __parent:Sprite;
      
      private var __loader:Loader;
      
      private var __isLocalLoad:Boolean;
      
      private var __logLevel:String;
      
      private var __logLevelMap:Object;
      
      private var __importIEvent:IEvent;
      
      private var __loadComplete:Function;
      
      public function AdManagerLoader()
      {
         super();
         log(Caller);
         this.__logLevelMap = {
            "VERBOSE":0,
            "INFO":1,
            "WARN":2,
            "ERROR":3,
            "QUIET":4
         };
      }
      
      private static function getDomain(param1:String) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:String = param1;
         if(_loc2_.lastIndexOf("/") > 8)
         {
            _loc2_ = _loc2_.substr(0,_loc2_.indexOf("/",8));
            if(_loc2_.indexOf("/") > -1)
            {
               _loc2_ = _loc2_.substr(_loc2_.lastIndexOf("/") + 1);
            }
         }
         return _loc2_;
      }
      
      private static function log(param1:String) : void
      {
         trace("--FreeWheel-- AdManagerLoader " + param1);
      }
      
      private static function getLibraryVersion() : uint
      {
         var _loc1_:Array = Tag.toLowerCase().split("trunk").join("99").split("x").join("99").split(".");
         while(_loc1_.length < 4)
         {
            _loc1_.push("0");
         }
         return uint(256 * 256 * 256 * _loc1_[0] + 256 * 256 * _loc1_[1] + 256 * _loc1_[2] + 1 * _loc1_[3]);
      }
      
      private static function injectAdManagerTag() : Boolean
      {
         if(!ExternalInterface.available)
         {
            log("injectAdManagerTag() failed: ExternalInterface not available");
            return false;
         }
         try
         {
            forceAdManagerUrl = ExternalInterface.call("function(){if (!window._fw_admanager) window._fw_admanager = {}; window._fw_admanager.loaderVersion=\'" + Caller + "\'; var u = document.cookie.match(\'(?:^|;)\\\\s*_fw_cfg=([^;]*)\'); return u ? decodeURIComponent(u[1]) : null;}");
            if(Boolean(forceAdManagerUrl) && forceAdManagerUrl.indexOf("://") == -1)
            {
               forceAdManagerUrl = null;
            }
            if(forceAdManagerUrl)
            {
               log("AdManager URL forced to " + forceAdManagerUrl);
            }
         }
         catch(e:Error)
         {
            log("injectAdManagerTag() failed: " + e.message);
            return false;
         }
         log("injectAdManagerTag() succeeded.");
         return true;
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         this.__loadComplete(false,"Security Error: " + param1.toString());
      }
      
      public function loadAdManager(param1:Sprite, param2:Function, param3:String, param4:String, param5:Number) : void
      {
         var adManagerUrl:String;
         var loaderContext:LoaderContext;
         var __loaderRequestURL:URLRequest;
         var _parent:Sprite = param1;
         var _loadComplete:Function = param2;
         var _logLevel:String = param3;
         var _urlOverride:String = param4;
         var _cacheBuster:Number = param5;
         log("loadAdManager(" + _urlOverride + ")");
         if(null == _loadComplete)
         {
            _loadComplete = function(param1:Boolean, param2:String):void
            {
               log("Warning: load complete callback is not specified");
            };
         }
         this.__parent = _parent;
         this.__loadComplete = _loadComplete;
         this.__logLevel = _logLevel;
         this.__loader = new Loader();
         this.__loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
         this.__loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         this.__loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
         adManagerUrl = _urlOverride;
         if(forceAdManagerUrl != null)
         {
            adManagerUrl = forceAdManagerUrl;
         }
         if(adManagerUrl != null && adManagerUrl.indexOf("://") != -1)
         {
            Security.allowDomain(getDomain(adManagerUrl));
         }
         if(Security.sandboxType == Security.REMOTE)
         {
            adManagerUrl += "?logLevel=" + _logLevel;
            if(!isNaN(_cacheBuster))
            {
               adManagerUrl += "&cb=" + _cacheBuster;
            }
         }
         else
         {
            this.__isLocalLoad = true;
         }
         __loaderRequestURL = new URLRequest(adManagerUrl);
         log("load from " + adManagerUrl);
         loaderContext = new LoaderContext();
         loaderContext.applicationDomain = new ApplicationDomain();
         switch(Security.sandboxType)
         {
            case Security.LOCAL_TRUSTED:
            case Security.LOCAL_WITH_FILE:
            case Security.LOCAL_WITH_NETWORK:
               this.__loader.load(__loaderRequestURL,loaderContext);
               break;
            case Security.REMOTE:
               loaderContext.securityDomain = SecurityDomain.currentDomain;
               this.__loader.load(__loaderRequestURL,loaderContext);
         }
         if(this.__parent is MovieClip)
         {
            this.__parent.addChild(this.__loader);
         }
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         this.__loadComplete(false,"IO Error: " + param1.toString());
      }
      
      public function disposeAdManager(param1:IAdManager) : void
      {
         log("disposeAdManager()");
         if(param1)
         {
            param1.dispose();
         }
         else
         {
            log("Error: runtime library not loaded.");
         }
      }
      
      private function completeHandler(param1:Event) : void
      {
         log("load complete");
         if(this.__loader.contentLoaderInfo.actionScriptVersion == 2)
         {
            this.__loadComplete(false,"Error: wrong AVM version.");
            return;
         }
         this.__adManagerMC = MovieClip(this.__loader.content);
         if(Boolean(this.__parent) && Boolean(this.__parent.stage))
         {
            this.__adManagerMC.initialize({"stageUrl":this.__parent.stage.loaderInfo.url});
         }
         if(this.__isLocalLoad)
         {
            this.__adManagerMC.initialize({"logLevel":this.__logLevelMap[this.__logLevel]});
         }
         this.__loadComplete(true,"Ready.");
      }
      
      public function loadAdManagerByProfile(param1:Sprite, param2:Function, param3:String, param4:String, param5:Number = 0) : void
      {
         log("loadAdManagerByProfile(" + param4 + ")");
         var _loc6_:String = "http://adm.fwmrm.net/p/";
         var _loc7_:String = "/AdManager.swf";
         var _loc8_:String = _loc6_ + param4 + _loc7_;
         this.loadAdManager(param1,param2,param3,_loc8_,param5);
      }
      
      public function newAdManager() : IAdManager
      {
         log("newAdManager()");
         if(this.__adManagerMC)
         {
            return new IAdManager(this.__adManagerMC.getNewInstance(getLibraryVersion()));
         }
         log("Error: runtime library not loaded.");
         return null;
      }
   }
}

