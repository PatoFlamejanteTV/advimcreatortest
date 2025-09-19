package com.dreamsocket.cues
{
   import com.dreamsocket.events.CueRangeEvent;
   import flash.events.EventDispatcher;
   
   public class BaseCueRangeManager extends EventDispatcher
   {
      
      protected var m_activeCues:Array;
      
      protected var m_cues:Array;
      
      protected var m_dirtyIndex:int;
      
      protected var m_enabled:Boolean;
      
      protected var m_index:int;
      
      protected var m_time:Number;
      
      protected var m_tolerance:Number;
      
      public function BaseCueRangeManager()
      {
         super();
         this.m_activeCues = [];
         this.m_cues = [];
         this.m_dirtyIndex = -1;
         this.m_enabled = true;
         this.m_index = 0;
         this.m_time = 0;
         this.m_tolerance = 0.5;
      }
      
      public function get cueRanges() : Array
      {
         return this.m_cues.concat();
      }
      
      public function set cueRanges(param1:Array) : void
      {
         this.m_cues = [];
         this.addCueRanges(param1);
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this.m_enabled = param1;
      }
      
      public function get enabled() : Boolean
      {
         return this.m_enabled;
      }
      
      public function set time(param1:Number) : void
      {
         if(param1 != this.m_time)
         {
            if(this.m_dirtyIndex == -1)
            {
               if(param1 < this.m_time)
               {
                  this.m_dirtyIndex = 0;
                  this.checkActiveCues();
                  return;
               }
               if(Math.abs(this.m_time - param1) > 1)
               {
                  this.m_dirtyIndex = this.m_index;
                  this.checkActiveCues();
                  return;
               }
            }
            this.m_time = param1;
            if(!this.m_enabled)
            {
               return;
            }
            if(this.m_dirtyIndex != -1)
            {
               this.m_index = this.getIndex(param1,param1);
               this.m_dirtyIndex = -1;
            }
            this.addActiveCues();
            this.checkActiveCues();
         }
      }
      
      public function get time() : Number
      {
         return this.m_time;
      }
      
      public function addCueRange(param1:ICueRange) : void
      {
         var _loc2_:int = this.m_cues.length ? int(this.getIndex(param1.start,param1.end)) : 0;
         if(_loc2_ < this.m_index && param1.containsValue(this.m_time))
         {
            this.m_index = _loc2_;
         }
         this.m_cues.splice(_loc2_,0,new ManagedCueRange(param1));
      }
      
      public function addCueRanges(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = param1.length;
         while(_loc2_ < _loc3_)
         {
            this.addCueRange(param1[_loc2_++] as ICueRange);
         }
      }
      
      public function getCueRange(param1:String) : ICueRange
      {
         var _loc2_:int = int(this.m_cues.length);
         while(_loc2_--)
         {
            if(this.m_cues[_loc2_].cueRange.ID == param1)
            {
               return this.m_cues[_loc2_].cueRange;
            }
         }
         return null;
      }
      
      public function removeCueRange(param1:ICueRange) : Boolean
      {
         var _loc2_:int = int(this.m_cues.length);
         while(_loc2_--)
         {
            if(this.m_cues[_loc2_].cueRange == param1)
            {
               this.m_cues.splice(_loc2_,1);
               if(_loc2_ == this.m_index)
               {
                  this.m_index = Math.max(this.m_index - 1,0);
               }
               return true;
            }
         }
         return false;
      }
      
      public function removeCueRanges(param1:String) : void
      {
         var _loc2_:int = int(this.m_cues.length);
         while(_loc2_--)
         {
            if(this.m_cues[_loc2_].cueRange.className == param1)
            {
               this.m_cues.splice(_loc2_,1);
               if(_loc2_ == this.m_index)
               {
                  this.m_index = Math.max(this.m_index - 1,0);
               }
            }
         }
      }
      
      public function reset() : void
      {
         this.m_index = 0;
         this.m_dirtyIndex = -1;
         this.m_time = 0;
         this.checkActiveCues();
      }
      
      public function clear() : void
      {
         this.m_cues.splice(0);
         this.m_index = 0;
         this.m_dirtyIndex = -1;
      }
      
      protected function addActiveCues() : void
      {
         var _loc3_:ICueRange = null;
         var _loc4_:ManagedCueRange = null;
         var _loc5_:String = null;
         var _loc7_:* = false;
         var _loc1_:uint = uint(this.m_index);
         var _loc2_:uint = this.m_cues.length;
         var _loc6_:Number = this.m_time + this.m_tolerance;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.m_cues[this.m_index];
            _loc3_ = _loc4_.cueRange as ICueRange;
            if(_loc3_.start == _loc3_.end)
            {
               _loc7_ = _loc3_.start <= _loc6_;
            }
            else
            {
               _loc7_ = _loc3_.containsValue(_loc6_);
            }
            if(!_loc7_)
            {
               break;
            }
            if(!_loc4_.active)
            {
               _loc4_.active = true;
               this.m_activeCues.push(_loc4_);
               _loc3_ = ICueRange(ManagedCueRange(this.m_cues[_loc1_]).cueRange);
               _loc5_ = _loc3_.enterEventType == null ? CueRangeEvent.CUE_RANGE_ENTERED : _loc3_.enterEventType;
               this.dispatchEvent(new CueRangeEvent(_loc5_,_loc3_));
            }
            this.m_index = Math.min(this.m_cues.length - 1,this.m_index + 1);
            _loc1_++;
         }
      }
      
      protected function checkActiveCues() : void
      {
         var _loc4_:ICueRange = null;
         var _loc5_:String = null;
         var _loc1_:uint = 0;
         var _loc2_:uint = this.m_activeCues.length;
         var _loc3_:Number = this.m_time + this.m_tolerance;
         while(_loc1_ < _loc2_)
         {
            if(!this.m_activeCues[_loc1_].cueRange.containsValue(_loc3_))
            {
               this.m_activeCues[_loc1_].active = false;
               _loc4_ = ICueRange(ManagedCueRange(this.m_activeCues[_loc1_]).cueRange);
               _loc5_ = _loc4_.exitEventType == null ? CueRangeEvent.CUE_RANGE_EXITED : _loc4_.exitEventType;
               this.m_activeCues.splice(_loc1_,1);
               _loc2_--;
               this.dispatchEvent(new CueRangeEvent(_loc5_,_loc4_));
            }
            else
            {
               _loc1_++;
            }
         }
      }
      
      protected function getIndex(param1:Number, param2:Number) : uint
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = this.m_cues.length;
         while(_loc3_ < _loc4_)
         {
            if(ICueRange(ManagedCueRange(this.m_cues[_loc3_]).cueRange).compareValues(param1,param2) == 1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return this.m_cues.length;
      }
   }
}

