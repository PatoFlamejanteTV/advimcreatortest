package com.dreamsocket.media
{
   public interface IMediaSourceSelector
   {
      
      function selectSource(param1:IMediaObject, param2:Boolean = false) : IMediaSource;
   }
}

