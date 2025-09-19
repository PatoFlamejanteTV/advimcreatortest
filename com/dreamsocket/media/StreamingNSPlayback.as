package com.dreamsocket.media
{
   import com.dreamsocket.events.BufferTimeEvent;
   import com.dreamsocket.events.ConnectionEvent;
   import com.dreamsocket.events.ConnectionExceptionEvent;
   import com.dreamsocket.events.ExceptionEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.NetInfoEvent;
   import com.dreamsocket.events.PlayEvent;
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.events.TimeEvent;
   import com.dreamsocket.media.streamingNSClasses.IStreamingNSRequestBuilder;
   import com.dreamsocket.media.streamingNSClasses.StreamingNSRequest;
   import com.dreamsocket.media.streamingNSClasses.StreamingNSRequestFactory;
   import com.dreamsocket.net.RemoteNCConnector;
   import flash.media.Video;
   import flash.net.NetConnection;
   
   public class StreamingNSPlayback extends AbstractNSPlayback
   {
      
      public static var defaultRequestBuilder:IStreamingNSRequestBuilder = StreamingNSRequestFactory.getInstance();
      
      protected var m_ncConnector:RemoteNCConnector;
      
      protected var m_nsRequest:StreamingNSRequest;
      
      protected var m_nsRequestBuilder:IStreamingNSRequestBuilder;
      
      public function StreamingNSPlayback()
      {
         super();
         this.m_nsRequest = new StreamingNSRequest();
         this.m_nsRequestBuilder = StreamingNSPlayback.defaultRequestBuilder;
         this.m_ncConnector = new RemoteNCConnector();
         this.m_ncConnector.addEventListener(ConnectionEvent.CONNECTION_CLOSED,this.dispatchEvent);
         this.m_ncConnector.addEventListener(ConnectionEvent.CONNECTION_REQUESTED,this.dispatchEvent);
         this.m_ncConnector.addEventListener(ConnectionEvent.CONNECTION_OPENED,this.onConnectionSuccess);
         this.m_ncConnector.addEventListener(ConnectionExceptionEvent.CONNECTION_ASYNC_EXCEPTION,this.onConnectionException);
         this.m_ncConnector.addEventListener(ConnectionExceptionEvent.CONNECTION_IO_EXCEPTION,this.onConnectionException);
         this.m_ncConnector.addEventListener(ConnectionExceptionEvent.CONNECTION_SECURITY_EXCEPTION,this.onConnectionException);
      }
      
      override public function get netConnection() : NetConnection
      {
         return this.m_ncConnector.netConnection;
      }
      
      public function get request() : StreamingNSRequest
      {
         return this.m_nsRequest;
      }
      
      public function get requestBuilder() : IStreamingNSRequestBuilder
      {
         return this.m_nsRequestBuilder;
      }
      
      public function set requestBuilder(param1:IStreamingNSRequestBuilder) : void
      {
         this.m_nsRequestBuilder = param1;
      }
      
      override public function close() : void
      {
         if(this.state == MediaState.CLOSED || this.state == MediaState.ERROR)
         {
            return;
         }
         if(this.m_playback != null)
         {
            this.m_playback.close();
         }
         this.closeStream();
         if(!this.m_nsRequest.allowNCReuse)
         {
            this.m_ncConnector.close();
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.m_ncConnector.close();
      }
      
      override public function load() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:* = false;
         var _loc6_:StreamingNSRequest = null;
         if(this.m_playback == null && this.m_sourceURL != null)
         {
            _loc1_ = Boolean(this.m_ncConnector.connected && this.request.allowNCReuse);
            _loc2_ = Boolean(this.m_nsRequest.URL == this.m_sourceURL);
            _loc3_ = true;
            _loc4_ = true;
            _loc5_ = true;
            if(!_loc2_)
            {
               _loc6_ = this.m_nsRequestBuilder.createRequest(this.m_sourceURL);
               _loc5_ = this.m_nsRequest.streamExtension == _loc6_.streamExtension;
               _loc3_ = _loc6_.ncRequest.app == this.m_nsRequest.ncRequest.app && this.m_nsRequest.ncRequest.app != null;
               _loc4_ = _loc6_.streamName == this.m_nsRequest.streamName && this.m_nsRequest.streamName != null;
               this.m_nsRequest = _loc6_;
            }
            if((_loc2_ || _loc3_) && !_loc1_ && this.m_ncConnector.netConnection != null && this.request.allowNCReuse)
            {
               this.m_ncConnector.reconnect();
            }
            else if(_loc3_ && _loc1_)
            {
               this.close();
               this.createStream();
            }
            else if(!_loc3_ || !_loc5_ || this.m_ncConnector.netConnection == null || !this.request.allowNCReuse)
            {
               this.close();
               this.m_ncConnector.close();
               this.m_ncConnector.connect(this.m_nsRequest.ncRequest.URL);
            }
            if(this.m_currState != MediaState.LOADING)
            {
               this.m_prevState = this.m_currState;
               this.m_currState = MediaState.LOADING;
               this.dispatchEvent(new StateChangeEvent(StateChangeEvent.STATE_CHANGED,this.m_currState,this.m_prevState));
            }
         }
      }
      
      protected function closeStream() : void
      {
         this.m_playPaused = !this.autoPlay;
         this.m_timeSeekable.end = 0;
         if(this.m_playback != null)
         {
            this.m_playback.removeEventListener(BufferTimeEvent.BUFFER_TIME_STARTED,this.dispatchEvent);
            this.m_playback.removeEventListener(BufferTimeEvent.BUFFER_TIME_PROGRESS,this.dispatchEvent);
            this.m_playback.removeEventListener(BufferTimeEvent.BUFFER_TIME_STOPPED,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_CLOSED,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_LOADING,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_OPENING,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaRequestEvent.MEDIA_REQUEST_READY,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_CUE_POINT,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_IMAGE_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_PLAY_STATUS,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_TEXT_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(NetInfoEvent.NET_INFO_XMP_DATA,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_ENDED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_PAUSED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_RESUMED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_STARTED,this.dispatchEvent);
            this.m_playback.removeEventListener(PlayEvent.PLAY_STOPPED,this.dispatchEvent);
            this.m_playback.removeEventListener(StateChangeEvent.STATE_CHANGED,this.onStateChanged);
            this.m_playback.removeEventListener(TimeEvent.TIME_DURATION_CHANGED,this.onTimeDurationChanged);
            this.m_playback.removeEventListener(TimeEvent.TIME_POSITION_CHANGED,this.dispatchEvent);
            this.m_playback.removeEventListener(TimeEvent.TIME_SEEKABLE_CHANGED,this.onTimeSeekableChanged);
            this.m_playback.removeEventListener(MediaExceptionEvent.MEDIA_ASYNC_EXCEPTION,this.dispatchEvent);
            this.m_playback.removeEventListener(MediaExceptionEvent.MEDIA_IO_EXCEPTION,this.onStreamException);
            this.m_playback.removeEventListener(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,this.onStreamException);
            if(this.m_videoHost.value != null)
            {
               Video(this.m_videoHost.value).attachNetStream(null);
            }
            this.m_playback = null;
         }
      }
      
      protected function createStream() : void
      {
         var _loc1_:StreamingNS = new StreamingNS(this.m_ncConnector.netConnection);
         this.m_playback = _loc1_;
         _loc1_.addEventListener(BufferTimeEvent.BUFFER_TIME_STARTED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(BufferTimeEvent.BUFFER_TIME_PROGRESS,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(BufferTimeEvent.BUFFER_TIME_STOPPED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(MediaRequestEvent.MEDIA_REQUEST_CLOSED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(MediaRequestEvent.MEDIA_REQUEST_LOADING,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(MediaRequestEvent.MEDIA_REQUEST_OPENING,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(MediaRequestEvent.MEDIA_REQUEST_READY,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_CUE_POINT,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_IMAGE_DATA,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_META_DATA,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_PLAY_STATUS,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_TEXT_DATA,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(NetInfoEvent.NET_INFO_XMP_DATA,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(PlayEvent.PLAY_ENDED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(PlayEvent.PLAY_PAUSED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(PlayEvent.PLAY_RESUMED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(PlayEvent.PLAY_STARTED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(PlayEvent.PLAY_STOPPED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(StateChangeEvent.STATE_CHANGED,this.onStateChanged,false,0,true);
         _loc1_.addEventListener(TimeEvent.TIME_DURATION_CHANGED,this.onTimeDurationChanged,false,0,true);
         _loc1_.addEventListener(TimeEvent.TIME_POSITION_CHANGED,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(TimeEvent.TIME_SEEKABLE_CHANGED,this.onTimeSeekableChanged,false,0,true);
         _loc1_.addEventListener(MediaExceptionEvent.MEDIA_ASYNC_EXCEPTION,this.dispatchEvent,false,0,true);
         _loc1_.addEventListener(MediaExceptionEvent.MEDIA_IO_EXCEPTION,this.onStreamException,false,0,true);
         _loc1_.addEventListener(MediaExceptionEvent.MEDIA_SECURITY_EXCEPTION,this.onStreamException,false,0,true);
         _loc1_.autoPlay = this.autoPlay;
         _loc1_.autoRewind = this.autoRewind;
         _loc1_.bufferTimePreferred = this.m_bufferTimePreferred;
         _loc1_.soundTransform = this.m_sndTransform;
         _loc1_.url = this.request.streamPath;
         if(this.m_videoHost.value != null)
         {
            Video(this.m_videoHost.value).attachNetStream(_loc1_);
         }
      }
      
      protected function reconfigureURLAndRetry(param1:ExceptionEvent) : void
      {
         this.closeStream();
         this.m_ncConnector.close();
         if(this.m_nsRequestBuilder.reconfigureRequest(this.m_nsRequest))
         {
            this.m_ncConnector.connect(this.m_nsRequest.ncRequest.URL);
         }
         else
         {
            if(param1 is ConnectionExceptionEvent)
            {
               this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_IO_EXCEPTION,param1.cause));
            }
            else
            {
               this.dispatchEvent(param1);
            }
            this.m_prevState = this.m_currState;
            this.m_currState = MediaState.ERROR;
            this.dispatchEvent(new StateChangeEvent(StateChangeEvent.STATE_CHANGED,this.m_currState,this.m_prevState));
         }
      }
      
      protected function onConnectionSuccess(param1:ConnectionEvent) : void
      {
         this.dispatchEvent(param1.clone());
         if(this.request.ncRequest.client != null)
         {
            this.m_ncConnector.client = this.request.ncRequest.client;
         }
         this.createStream();
      }
      
      protected function onConnectionException(param1:ConnectionExceptionEvent) : void
      {
         this.reconfigureURLAndRetry(param1);
      }
      
      protected function onStateChanged(param1:StateChangeEvent) : void
      {
         if(param1.newState == MediaState.ERROR || param1.newState == this.m_currState)
         {
            return;
         }
         this.m_prevState = String(param1.oldState);
         this.m_currState = String(param1.newState);
         this.dispatchEvent(param1);
      }
      
      protected function onStreamException(param1:MediaExceptionEvent) : void
      {
         this.reconfigureURLAndRetry(param1);
      }
      
      protected function onTimeDurationChanged(param1:TimeEvent) : void
      {
         var _loc2_:Number = Number(param1.target.duration);
         if(_loc2_ == this.m_duration)
         {
            return;
         }
         this.m_duration = _loc2_;
         this.dispatchEvent(new TimeEvent(TimeEvent.TIME_DURATION_CHANGED));
      }
      
      protected function onTimeSeekableChanged(param1:TimeEvent) : void
      {
         this.m_timeSeekable.start = this.m_playback.timeSeekable.start;
         this.m_timeSeekable.end = this.m_playback.timeSeekable.end;
         this.dispatchEvent(param1.clone());
      }
   }
}

