package com.dreamsocket.media
{
   import com.dreamsocket.events.StateChangeEvent;
   import com.dreamsocket.utils.StopWatch;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PlaybackMetricsManager extends EventDispatcher
   {
      
      protected var m_playback:IPlayback;
      
      protected var m_lastTimeTracked:int;
      
      protected var m_viewedMonitor:Timer;
      
      protected var m_viewedMonitorDelay:int;
      
      protected var m_viewedDuration:StopWatch;
      
      public function PlaybackMetricsManager()
      {
         super();
         this.m_lastTimeTracked = 0;
         this.m_viewedDuration = new StopWatch();
         this.m_viewedMonitor = new Timer(500);
         this.m_viewedMonitor.addEventListener(TimerEvent.TIMER,this.onMonitorUpdated);
      }
      
      public function get monitorDelay() : Number
      {
         return this.m_viewedMonitor.delay;
      }
      
      public function set monitorDelay(param1:Number) : void
      {
         this.m_viewedMonitor.delay = param1;
      }
      
      public function get playback() : IPlayback
      {
         return this.m_playback;
      }
      
      public function set playback(param1:IPlayback) : void
      {
         if(param1 != this.m_playback)
         {
            if(this.m_playback != null)
            {
               this.m_playback.removeEventListener(StateChangeEvent.STATE_CHANGED,this.onMediaStateChanged);
            }
            this.m_playback = param1;
            if(param1 == null)
            {
               return;
            }
            param1.addEventListener(StateChangeEvent.STATE_CHANGED,this.onMediaStateChanged,false,0,true);
         }
      }
      
      public function get timeSpent() : Number
      {
         return this.m_viewedDuration.time / 1000;
      }
      
      public function start() : void
      {
         if(this.m_playback != null && this.m_playback.state == MediaState.PLAYING)
         {
            this.m_viewedDuration.start();
            this.m_viewedMonitor.start();
         }
      }
      
      public function stop() : void
      {
         this.m_viewedDuration.stop();
         this.m_viewedMonitor.stop();
      }
      
      public function reset() : void
      {
         this.m_lastTimeTracked = 0;
         this.m_viewedDuration.reset();
         this.m_viewedMonitor.reset();
      }
      
      protected function onMediaStateChanged(param1:StateChangeEvent) : void
      {
         switch(param1.newState)
         {
            case MediaState.PLAYING:
               this.start();
               break;
            case MediaState.ERROR:
            case MediaState.CLOSED:
               this.reset();
               break;
            default:
               this.stop();
         }
      }
      
      protected function onMonitorUpdated(param1:TimerEvent) : void
      {
         this.m_viewedDuration.time;
         this.dispatchEvent(new Event(Event.CHANGE));
      }
   }
}

