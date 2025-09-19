package com.dreamsocket.utils
{
   import flash.utils.Dictionary;
   
   public class WeakReference
   {
      
      protected var m_value:Dictionary;
      
      public function WeakReference(param1:Object = null)
      {
         super();
         this.m_value = new Dictionary(true);
         this.m_value[0] = param1;
      }
      
      public function get value() : Object
      {
         return this.m_value[0];
      }
      
      public function set value(param1:Object) : void
      {
         this.m_value[0] = param1;
      }
      
      public function clear() : void
      {
         delete this.m_value[0];
      }
   }
}

