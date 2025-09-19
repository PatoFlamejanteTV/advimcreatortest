package com.dreamsocket.net
{
   public class NCDefaultPortRegistry
   {
      
      protected static var k_instance:NCDefaultPortRegistry;
      
      protected var m_lookup:Object;
      
      public function NCDefaultPortRegistry()
      {
         super();
         this.m_lookup = {
            "rtmp":"1935",
            "rtmpe":"1935",
            "rtmpt":"80",
            "rtmpte":"80",
            "rtmps":"443"
         };
      }
      
      public static function getInstance() : NCDefaultPortRegistry
      {
         if(k_instance == null)
         {
            k_instance = new NCDefaultPortRegistry();
         }
         return k_instance;
      }
      
      public function registerPort(param1:String, param2:String) : void
      {
         this.m_lookup[param1.toLowerCase()] = param2;
      }
      
      public function getPort(param1:String) : String
      {
         return this.m_lookup[param1.toLowerCase()];
      }
   }
}

