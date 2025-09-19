package com.dreamsocket.media
{
   import com.dreamsocket.events.DownloadEvent;
   import com.dreamsocket.events.MediaExceptionEvent;
   import com.dreamsocket.events.MediaRequestEvent;
   import com.dreamsocket.events.NetInfoEvent;
   import com.dreamsocket.events.TimeEvent;
   import com.dreamsocket.media.byteRangeNSClasses.ByteRangeNSRequest;
   import com.dreamsocket.media.byteRangeNSClasses.ByteRangeNSRequestFactory;
   import com.dreamsocket.media.byteRangeNSClasses.IByteRangeNSRequestBuilder;
   import flash.errors.IOError;
   import flash.net.NetConnection;
   
   public class ByteRangeNS extends ProgressiveNS
   {
      
      public static var defaultRequestBuilder:IByteRangeNSRequestBuilder = ByteRangeNSRequestFactory.getInstance();
      
      protected var m_bytesTotal:Number;
      
      protected var m_timeOffset:Number;
      
      protected var m_requestBuilder:IByteRangeNSRequestBuilder;
      
      public function ByteRangeNS(param1:NetConnection = null)
      {
         super(param1);
         this.m_timeOffset = 0;
      }
      
      override public function get bytesTotal() : uint
      {
         return isNaN(this.m_bytesTotal) ? super.bytesTotal : uint(this.m_bytesTotal);
      }
      
      override public function get currentTime() : Number
      {
         return this.m_currTime + this.m_timeOffset;
      }
      
      override public function set currentTime(param1:Number) : void
      {
         super.currentTime = param1;
      }
      
      public function set requestBuilder(param1:IByteRangeNSRequestBuilder) : void
      {
         this.m_requestBuilder = param1;
      }
      
      override public function close() : void
      {
         this.m_bytesTotal = NaN;
         this.m_timeOffset = 0;
         super.close();
      }
      
      override public function load() : void
      {
         var _loc1_:ByteRangeNSRequest = null;
         if(!this.m_downloading && !this.m_downloadComplete && this.m_sourceURL != null)
         {
            if(this.m_requestBuilder == null)
            {
               this.m_requestBuilder = ByteRangeNS.defaultRequestBuilder;
            }
            _loc1_ = this.m_requestBuilder.createRequest(this.m_sourceURL,0,0) as ByteRangeNSRequest;
            if(_loc1_ != null)
            {
               this.m_bufferMonitor.start();
               this.bufferTime = 0.1;
               this.dispatchEvent(new MediaRequestEvent(MediaRequestEvent.MEDIA_REQUEST_LOADING));
               this.setState(MediaState.LOADING);
               this.doBasePlay(_loc1_.URL);
               this.doBasePause();
            }
            else
            {
               this.dispatchEvent(new MediaExceptionEvent(MediaExceptionEvent.MEDIA_IO_EXCEPTION,new IOError("Unable to build ByteRangeNSRequest")));
               this.setState(MediaState.ERROR);
            }
         }
      }
      
      override protected function doSeek(param1:Number) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         if(this.m_metadata == null)
         {
            return;
         }
         var _loc2_:* = this.m_metadata.seekpoints != null;
         this.m_timeSeekedTo = param1;
         var _loc3_:Array = this.m_metadata.seekpoints;
         if(_loc3_ != null)
         {
            _loc4_ = this.m_metadata.keyframes = {
               "times":[],
               "filepositions":[]
            };
            _loc5_ = _loc3_.length;
            while(_loc5_--)
            {
               _loc4_.filepositions[_loc5_] = Number(_loc3_[_loc5_].offset);
               _loc4_.times[_loc5_] = Number(_loc3_[_loc5_].time);
            }
         }
         _loc4_ = this.m_metadata.keyframes;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Array = _loc4_.times;
         var _loc9_:Number = Math.min(this.bytesTotal - this.m_bytesDownloaded.start,this.bytesLoaded);
         this.m_timePriorSeek = this.currentTime;
         if(param1 == 0)
         {
            _loc6_ = 0;
            _loc7_ = 0;
         }
         else
         {
            _loc5_ = _loc8_.length;
            while(_loc5_--)
            {
               if(_loc8_[_loc5_] <= param1 && _loc8_[_loc5_ + 1] >= param1)
               {
                  _loc7_ = Number(_loc4_.times[_loc5_]);
                  _loc6_ = Number(_loc4_.filepositions[_loc5_]);
                  break;
               }
            }
            if(_loc2_)
            {
               this.m_timeOffset = _loc7_;
            }
         }
         if(_loc6_ < _loc9_ + this.m_bytesDownloaded.start && _loc6_ >= this.m_bytesDownloaded.start)
         {
            super.doSeek(_loc7_);
         }
         else
         {
            this.m_monitorTimeCt = 0;
            this.m_bytesDownloaded.start = _loc6_;
            this.m_bytesDownloaded.end = _loc6_;
            this.m_timeDownloaded.start = _loc7_;
            this.m_timeDownloaded.end = _loc7_;
            this.doBasePlay(this.m_requestBuilder.createRequest(this.m_sourceURL,_loc6_,_loc7_).URL);
            this.m_currTime = _loc2_ ? 0 : _loc7_;
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_POSITION_CHANGED));
            this.dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_PROGRESS,0,0));
            if(this.m_playPaused)
            {
               this.doBasePause();
            }
            this.m_bufferFull = false;
            this.m_bufferMonitor.start();
         }
      }
      
      override protected function processLoad() : void
      {
         if(super.bytesLoaded > 0)
         {
            if(isNaN(this.m_bytesTotal))
            {
               this.m_bytesTotal = super.bytesTotal;
            }
         }
         super.processLoad();
      }
      
      override protected function updateSeekableTime(param1:Number) : void
      {
      }
      
      override protected function onMetaData(param1:NetInfoEvent) : void
      {
         var _loc2_:Object = param1.info;
         if(!this.m_ready)
         {
            this.m_timeSeekable.end = _loc2_.duration;
            this.dispatchEvent(new TimeEvent(TimeEvent.TIME_SEEKABLE_CHANGED));
         }
         super.onMetaData(param1);
      }
   }
}

