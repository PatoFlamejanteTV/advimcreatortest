package tv.freewheel.ad.behavior
{
   public class IEvent
   {
      
      internal var proxied:Object;
      
      public function IEvent(param1:Object)
      {
         super();
         this.proxied = param1;
      }
      
      public function get type() : String
      {
         return this.proxied.type;
      }
      
      public function get adPause() : Boolean
      {
         return this.proxied.adPause;
      }
      
      public function get success() : Boolean
      {
         return this.proxied.success;
      }
      
      public function get level() : int
      {
         return this.proxied.level;
      }
      
      public function get message() : String
      {
         return this.proxied.message;
      }
      
      public function get details() : Object
      {
         return this.proxied.details;
      }
      
      public function get subType() : String
      {
         return this.proxied.subType;
      }
      
      public function get creativeId() : int
      {
         return this.proxied.creativeId;
      }
      
      public function get domain() : String
      {
         return this.proxied.domain;
      }
      
      public function get code() : int
      {
         return this.proxied.code;
      }
      
      public function get serverMessages() : Array
      {
         return this.proxied.serverMessages;
      }
      
      public function get slotCustomId() : String
      {
         return this.proxied.slotCustomId;
      }
      
      public function get videoPause() : Boolean
      {
         return this.proxied.videoPause;
      }
      
      public function get adId() : int
      {
         return this.proxied.adId;
      }
   }
}

