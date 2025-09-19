package com.dreamsocket.core
{
   import com.dreamsocket.utils.Version;
   
   public class MediaFramework
   {
      
      protected static var k_VERSION:Version = new Version(uint("%MEDIACOMPONENTS_MAJOR%"),uint("%MEDIACOMPONENTS_MINOR%"),uint("%MEDIACOMPONENTS_REVISION%"),String("%MEDIACOMPONENTS_BUILD%"));
      
      public function MediaFramework()
      {
         super();
      }
      
      public static function get version() : Version
      {
         return k_VERSION;
      }
   }
}

