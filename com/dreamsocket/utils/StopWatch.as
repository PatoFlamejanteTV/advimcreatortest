package com.dreamsocket.utils
{
   import flash.utils.getTimer;
   
   public class StopWatch
   {
      
      protected var m_running:Boolean;
      
      protected var m_startTime:int;
      
      protected var m_timeElapsed:int;
      
      public function StopWatch()
      {
         super();
         this.m_running = false;
         this.m_startTime = 0;
         this.m_timeElapsed = 0;
      }
      
      public function get running() : Boolean
      {
         return this.m_running;
      }
      
      public function get time() : int
      {
         if(this.running)
         {
            this.m_timeElapsed = getTimer() - this.m_startTime;
         }
         return this.m_timeElapsed;
      }
      
      public function set time(param1:int) : void
      {
         this.m_startTime = getTimer() - param1;
         this.m_timeElapsed = param1;
      }
      
      public function reset() : void
      {
         this.m_running = false;
         this.m_startTime = 0;
         this.m_timeElapsed = 0;
      }
      
      public function start() : void
      {
         if(!this.running)
         {
            this.m_startTime = getTimer() - this.m_timeElapsed;
            this.m_running = true;
         }
      }
      
      public function stop() : void
      {
         if(this.running)
         {
            this.m_timeElapsed = getTimer() - this.m_startTime;
            this.m_running = false;
         }
      }
   }
}

