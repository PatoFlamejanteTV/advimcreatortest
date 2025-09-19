package com.dreamsocket.tracking.omniture
{
   import flash.utils.Dictionary;
   
   public class OmnitureTrackerConfigXMLDecoder
   {
      
      public function OmnitureTrackerConfigXMLDecoder()
      {
         super();
      }
      
      public function decode(param1:XML) : OmnitureTrackerConfig
      {
         var _loc2_:OmnitureTrackerConfig = new OmnitureTrackerConfig();
         _loc2_.enabled = param1.enabled.toString() != "false";
         this.setParams(_loc2_.params,param1.params[0]);
         this.setTrackHandlers(_loc2_.trackHandlers,param1.trackHandlers.trackHandler);
         return _loc2_;
      }
      
      public function setParams(param1:OmnitureParams, param2:XML) : void
      {
         var _loc3_:XML = null;
         if(param2 == null)
         {
            return;
         }
         if(param2.debugTracking.toString().length)
         {
            param1.debugTracking = param2.debugTracking.toString() == "true";
         }
         if(param2.trackLocal.toString().length)
         {
            param1.trackLocal = param2.trackLocal.toString() == "true";
         }
         if(param2.account.toString().length)
         {
            param1.account = param2.account.toString();
         }
         if(param2.dc.toString().length)
         {
            param1.dc = param2.dc.toString();
         }
         if(param2.pageName.toString().length)
         {
            param1.pageName = param2.pageName.toString();
         }
         if(param2.pageURL.toString().length)
         {
            param1.pageURL = param2.pageURL.toString();
         }
         if(param2.visitorNameSpace.toString().length)
         {
            param1.visitorNameSpace = param2.visitorNameSpace.toString();
         }
         if(param2.autoTrack.length())
         {
            param1.autoTrack = param2.autoTrack.toString() == "true";
         }
         if(param2.charSet.length())
         {
            param1.charSet = param2.charSet.toString();
         }
         if(param2.cookieDomainPeriods.length())
         {
            param1.cookieDomainPeriods = int(param2.cookieDomainPeriods.toString());
         }
         if(param2.cookieLifetime.length())
         {
            param1.cookieLifetime = param2.cookieLifetime.toString();
         }
         if(param2.currencyCode.length())
         {
            param1.currencyCode = param2.currencyCode.toString();
         }
         if(param2.delayTracking.length())
         {
            param1.delayTracking = Number(param2.delayTracking.toString());
         }
         if(param2.linkLeaveQueryString.length())
         {
            param1.linkLeaveQueryString = param2.linkLeaveQueryString.toString() == true;
         }
         if(param2.pageType.length())
         {
            param1.pageType = param2.pageType.toString();
         }
         if(param2.referrer.length())
         {
            param1.referrer = param2.referrer.toString();
         }
         if(param2.trackClickMap.length())
         {
            param1.trackClickMap = param2.trackClickMap.toString() == "true";
         }
         if(param2.trackingServer.length())
         {
            param1.trackingServer = param2.trackingServer.toString();
         }
         if(param2.trackingServerBase.length())
         {
            param1.trackingServerBase = param2.trackingServerBase.toString();
         }
         if(param2.trackingServerSecure.length())
         {
            param1.trackingServerSecure = param2.trackingServerSecure.toString();
         }
         if(param2.vmk.length())
         {
            param1.vmk = param2.vmk.toString();
         }
         for each(_loc3_ in param2.*)
         {
            if(param1[_loc3_.name()] == undefined)
            {
               param1[_loc3_.name()] = _loc3_.toString();
            }
         }
      }
      
      public function setTrackHandlers(param1:Dictionary, param2:XMLList) : void
      {
         var _loc3_:OmnitureTrackHandler = null;
         var _loc4_:XML = null;
         var _loc5_:String = null;
         for each(_loc4_ in param2)
         {
            _loc5_ = _loc4_.ID.toString();
            if(_loc5_.length > 0)
            {
               _loc3_ = new OmnitureTrackHandler();
               _loc3_.ID = _loc5_;
               if(_loc4_.method.toString().length > 0)
               {
                  _loc3_.method = _loc4_.method.toString();
               }
               if(_loc4_.name.toString().length > 0)
               {
                  _loc3_.name = _loc4_.name.toString();
               }
               if(_loc4_.type.toString().length > 0)
               {
                  _loc3_.type = _loc4_.type.toString();
               }
               if(_loc4_.URL.toString().length > 0)
               {
                  _loc3_.URL = _loc4_.URL.toString();
               }
               this.setParams(_loc3_.params,_loc4_.params[0]);
               param1[_loc5_] = _loc3_;
            }
         }
      }
   }
}

