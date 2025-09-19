package com.dreamsocket.media.streamingNSClasses
{
   public class StreamingNSFileTypeRegistry
   {
      
      protected static var k_instance:StreamingNSFileTypeRegistry;
      
      protected var m_aliases:Object;
      
      public function StreamingNSFileTypeRegistry()
      {
         super();
         this.m_aliases = {};
         this.m_aliases["mp3"] = "mp3";
         this.m_aliases["flv"] = "flv";
         this.m_aliases["mp4"] = "mp4";
         this.m_aliases["m4a"] = "mp4";
         this.m_aliases["mp4v"] = "mp4";
         this.m_aliases["f4a"] = "mp4";
         this.m_aliases["f4b"] = "mp4";
         this.m_aliases["f4v"] = "mp4";
         this.m_aliases["mov"] = "mp4";
         this.m_aliases["3gp"] = "mp4";
         this.m_aliases["3g2"] = "mp4";
      }
      
      public static function getInstance() : StreamingNSFileTypeRegistry
      {
         if(k_instance == null)
         {
            k_instance = new StreamingNSFileTypeRegistry();
         }
         return k_instance;
      }
      
      public function registerFileType(param1:String, param2:String) : void
      {
         this.m_aliases[param1] = param2;
      }
      
      public function containsFileType(param1:String) : Boolean
      {
         return this.m_aliases[param1] != null;
      }
      
      public function getFileTypeAlias(param1:String) : String
      {
         return this.m_aliases[param1];
      }
   }
}

