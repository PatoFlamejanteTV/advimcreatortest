package com.cartoonnetwork.videoplayers.services
{
   import com.cartoonnetwork.videoplayers.decoders.ConfigXMLDecoder;
   import com.dreamsocket.net.http.HTTPDataFormat;
   import com.dreamsocket.services.HTTPService;
   import com.dreamsocket.services.IService;
   import com.dreamsocket.services.MultiResponder;
   import com.dreamsocket.utils.HTTPUtil;
   
   public class GetConfigDelegate implements IService
   {
      
      protected var m_baseURL:String;
      
      protected var m_call:HTTPService;
      
      public function GetConfigDelegate(param1:String)
      {
         super();
         this.m_baseURL = param1;
      }
      
      public function cancel() : void
      {
         this.m_call.disconnect();
      }
      
      public function send(param1:Object = null) : MultiResponder
      {
         this.m_call = new HTTPService();
         this.m_call.url = HTTPUtil.resolveUniqueURL(this.m_baseURL);
         this.m_call.dataDecoder = new ConfigXMLDecoder().decode;
         this.m_call.resultFormat = HTTPDataFormat.XML;
         return this.m_call.send();
      }
   }
}

