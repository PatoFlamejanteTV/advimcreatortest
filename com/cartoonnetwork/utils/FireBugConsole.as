package com.cartoonnetwork.utils
{
   import flash.external.ExternalInterface;
   
   public class FireBugConsole
   {
      
      public static var logSubmit:Boolean = true;
      
      public function FireBugConsole()
      {
         super();
      }
      
      public static function log(param1:Object) : void
      {
         ExternalInterface.call("console.log","",param1);
      }
      
      protected function logGen(param1:*, param2:String) : void
      {
      }
   }
}

