package com.dreamsocket.cues
{
   public class ManagedCueRange
   {
      
      public var cueRange:ICueRange;
      
      public var active:Boolean;
      
      public function ManagedCueRange(param1:ICueRange)
      {
         super();
         this.cueRange = param1;
         this.active = false;
      }
   }
}

