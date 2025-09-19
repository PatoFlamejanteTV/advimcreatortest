package com.dreamsocket.utils
{
   public class Version
   {
      
      public var build:String;
      
      public var major:uint;
      
      public var minor:uint;
      
      public var revision:uint;
      
      public function Version(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:String = "0")
      {
         super();
         this.major = param1;
         this.minor = param2;
         this.build = param4;
         this.revision = param3;
      }
      
      public function equals(param1:*) : Boolean
      {
         if(!(param1 is Version))
         {
            return false;
         }
         return param1.major == this.major && param1.minor == this.minor && param1.revision == this.revision;
      }
      
      public function toString() : String
      {
         return this.major + "." + this.minor + "." + "." + this.revision;
      }
   }
}

