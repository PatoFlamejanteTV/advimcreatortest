package com.dreamsocket.media.byteRangeNSClasses
{
   import flash.utils.Dictionary;
   
   public class ByteRangeNSRequestFactory implements IByteRangeNSRequestBuilder
   {
      
      protected static var k_instance:ByteRangeNSRequestFactory;
      
      protected var m_builders:Dictionary;
      
      public function ByteRangeNSRequestFactory()
      {
         super();
         this.m_builders = new Dictionary();
      }
      
      public static function getInstance() : ByteRangeNSRequestFactory
      {
         if(k_instance == null)
         {
            k_instance = new ByteRangeNSRequestFactory();
         }
         return k_instance;
      }
      
      public function addBuilder(param1:String, param2:IByteRangeNSRequestBuilder) : void
      {
         this.m_builders[param1] = param2;
      }
      
      public function createRequest(param1:String, param2:Number, param3:Number) : ByteRangeNSRequest
      {
         var _loc4_:String = null;
         for(_loc4_ in this.m_builders)
         {
            if(param1.indexOf(_loc4_) != -1)
            {
               return IByteRangeNSRequestBuilder(this.m_builders[_loc4_]).createRequest(param1,param2,param3);
            }
         }
         if(this.m_builders["*"] != null)
         {
            return IByteRangeNSRequestBuilder(this.m_builders["*"]).createRequest(param1,param2,param3);
         }
         return null;
      }
   }
}

