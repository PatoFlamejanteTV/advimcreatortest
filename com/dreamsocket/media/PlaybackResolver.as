package com.dreamsocket.media
{
   public class PlaybackResolver implements IPlaybackResolver
   {
      
      public function PlaybackResolver()
      {
         super();
      }
      
      public function resolvePlayback(param1:IMediaSource) : void
      {
         var _loc5_:String = null;
         if(param1 == null || param1.url == null || param1.playback != null)
         {
            return;
         }
         var _loc2_:String = param1.url;
         var _loc3_:String = param1.url.substring(0,_loc2_.indexOf(":")).toLowerCase();
         var _loc4_:String = _loc2_.substring(_loc2_.lastIndexOf(".") + 1).toLowerCase();
         if(_loc3_.indexOf("rtmp") != -1)
         {
            _loc5_ = "streamingns";
         }
         else
         {
            switch(_loc4_)
            {
               case "mp3":
                  _loc5_ = "progressivemp3";
                  break;
               case "jpg":
               case "gif":
               case "png":
               case "jpeg":
                  _loc5_ = "image";
                  break;
               case "swf":
                  _loc5_ = "timelineswf";
                  break;
               default:
                  _loc5_ = "progressivens";
            }
         }
         param1.playback = _loc5_;
      }
   }
}

