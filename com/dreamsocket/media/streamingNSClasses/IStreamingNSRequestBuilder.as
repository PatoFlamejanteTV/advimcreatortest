package com.dreamsocket.media.streamingNSClasses
{
   public interface IStreamingNSRequestBuilder
   {
      
      function createRequest(param1:String) : StreamingNSRequest;
      
      function reconfigureRequest(param1:StreamingNSRequest) : Boolean;
   }
}

