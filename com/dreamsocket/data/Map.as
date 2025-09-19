package com.dreamsocket.data
{
   import flash.utils.Dictionary;
   
   public class Map
   {
      
      private var m_values:Dictionary;
      
      private var m_length:uint;
      
      public function Map()
      {
         super();
         this.m_values = new Dictionary(true);
         this.m_length = 0;
      }
      
      public function get size() : uint
      {
         return this.m_length;
      }
      
      public function get values() : Dictionary
      {
         var _loc1_:String = null;
         var _loc2_:Dictionary = new Dictionary(true);
         for(_loc1_ in this.m_values)
         {
            _loc2_[_loc1_] = this.m_values[_loc1_];
         }
         return _loc2_;
      }
      
      public function containsKey(param1:String) : Boolean
      {
         return this.m_values[param1] != null;
      }
      
      public function get(param1:Object) : Object
      {
         return this.m_values[param1];
      }
      
      public function equals(param1:Map) : Boolean
      {
         var _loc2_:String = null;
         if(param1.size != this.size)
         {
            return false;
         }
         for(_loc2_ in param1.m_values)
         {
            if(this.m_values[_loc2_] != param1.get(_loc2_))
            {
               return false;
            }
         }
         return true;
      }
      
      public function get isEmpty() : Boolean
      {
         return this.m_length == 0;
      }
      
      public function put(param1:Object, param2:Object) : Object
      {
         var _loc3_:Object = this.m_values[param1];
         this.m_values[param1] = param2;
         if(_loc3_ == null)
         {
            ++this.m_length;
         }
         return _loc3_;
      }
      
      public function putAll(param1:Map) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1.m_values)
         {
            this.put(_loc2_,param1.m_values[_loc2_]);
         }
      }
      
      public function remove(param1:String) : Object
      {
         var _loc2_:Object = null;
         if(this.containsKey(param1))
         {
            _loc2_ = this.m_values[param1];
            delete this.m_values[param1];
            --this.m_length;
         }
         return _loc2_;
      }
      
      public function clear() : void
      {
         this.m_values = new Dictionary(true);
         this.m_length = 0;
      }
   }
}

