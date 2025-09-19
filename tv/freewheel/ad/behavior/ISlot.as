package tv.freewheel.ad.behavior
{
   import flash.display.Sprite;
   
   public class ISlot
   {
      
      internal var proxied:Object;
      
      public function ISlot(param1:Object)
      {
         super();
         this.proxied = param1;
      }
      
      public function stop(param1:Boolean = false) : void
      {
         if(this.proxied)
         {
            this.proxied.stop(param1);
         }
      }
      
      public function pause(param1:Boolean = true) : void
      {
         if(this.proxied)
         {
            this.proxied.pause(param1);
         }
      }
      
      public function preload() : void
      {
         if(this.proxied)
         {
            this.proxied.preload();
         }
      }
      
      public function getParameter(param1:String) : String
      {
         return this.proxied ? this.proxied.getParameter(param1) : null;
      }
      
      public function getTimePositionClass() : String
      {
         return this.proxied ? this.proxied.getTimePositionClass() : null;
      }
      
      public function getEventCallbackURLs() : Array
      {
         return this.proxied ? this.proxied.getEventCallbackURLs() : null;
      }
      
      public function isActive() : Boolean
      {
         return this.proxied ? Boolean(this.proxied.isActive()) : false;
      }
      
      public function getTotalDuration(param1:Boolean = false) : Number
      {
         return this.proxied ? Number(this.proxied.getTotalDuration(param1)) : 0;
      }
      
      public function hasCompanion() : Boolean
      {
         return this.proxied ? Boolean(this.proxied.hasCompanion()) : false;
      }
      
      public function getTimePosition() : Number
      {
         return this.proxied ? Number(this.proxied.getTimePosition()) : 0;
      }
      
      public function getTotalBytes(param1:Boolean = false) : int
      {
         return this.proxied ? int(this.proxied.getTotalBytes(param1)) : 0;
      }
      
      public function getWidth() : uint
      {
         return this.proxied ? uint(this.proxied.getWidth()) : 0;
      }
      
      public function getBytesLoaded(param1:Boolean = false) : int
      {
         return this.proxied ? int(this.proxied.getBytesLoaded(param1)) : 0;
      }
      
      public function getHeight() : uint
      {
         return this.proxied ? uint(this.proxied.getHeight()) : 0;
      }
      
      public function getCustomId() : String
      {
         return this.proxied ? this.proxied.getCustomId() : null;
      }
      
      public function getAdInstances() : Array
      {
         return this.proxied ? this.proxied.getAdInstances() : null;
      }
      
      public function setParameter(param1:String, param2:String) : void
      {
         if(this.proxied)
         {
            this.proxied.setParameter(param1,param2);
         }
      }
      
      public function getPhysicalLocation() : String
      {
         return this.proxied ? this.proxied.getPhysicalLocation() : null;
      }
      
      public function setBase(param1:Sprite) : void
      {
         if(this.proxied)
         {
            this.proxied.setBase(param1);
         }
      }
      
      public function getType() : String
      {
         return this.proxied ? this.proxied.getType() : null;
      }
      
      public function play() : void
      {
         if(this.proxied)
         {
            this.proxied.play();
         }
      }
      
      public function getAdCount() : uint
      {
         return this.proxied ? uint(this.proxied.getAdCount()) : 0;
      }
      
      public function getPlayheadTime(param1:Boolean = false) : Number
      {
         return this.proxied ? Number(this.proxied.getPlayheadTime(param1)) : 0;
      }
      
      public function playCompanion() : void
      {
         if(this.proxied)
         {
            this.proxied.playCompanion();
         }
      }
      
      public function skipCurrentAd() : void
      {
         if(this.proxied)
         {
            this.proxied.skipCurrentAd();
         }
      }
      
      public function setBounds(param1:int, param2:int, param3:uint, param4:uint) : void
      {
         if(this.proxied)
         {
            this.proxied.setBounds(param1,param2,param3,param4);
         }
      }
   }
}

