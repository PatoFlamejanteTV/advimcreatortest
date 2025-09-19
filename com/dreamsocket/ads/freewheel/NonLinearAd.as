package com.dreamsocket.ads.freewheel
{
   import flash.display.Sprite;
   
   public class NonLinearAd
   {
      
      public var ID:String;
      
      public var container:Sprite;
      
      public var width:int;
      
      public var height:int;
      
      public function NonLinearAd(param1:String = null, param2:Sprite = null, param3:int = 0, param4:int = 0)
      {
         super();
         this.ID = param1;
         this.container = param2;
         this.width = param3;
         this.height = param4;
      }
   }
}

