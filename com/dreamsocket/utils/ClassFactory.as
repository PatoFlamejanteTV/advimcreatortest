package com.dreamsocket.utils
{
   public class ClassFactory
   {
      
      protected var m_classes:Object;
      
      protected var m_aliases:Object;
      
      public function ClassFactory()
      {
         super();
         this.m_classes = {};
         this.m_aliases = {};
      }
      
      public function createInstance(param1:String) : Object
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Class = this.m_classes[this.m_aliases[param1.toLowerCase()]];
         if(_loc2_ == null)
         {
            return null;
         }
         return new _loc2_();
      }
      
      public function getRegisteredNameByAlias(param1:String) : String
      {
         if(param1 == null)
         {
            return null;
         }
         return this.m_aliases[param1.toLowerCase()];
      }
      
      public function registerClass(param1:Class, param2:String, param3:Array = null) : void
      {
         var _loc5_:Number = NaN;
         var _loc4_:String = param2.toLowerCase();
         this.m_classes[_loc4_] = param1;
         this.m_aliases[_loc4_] = _loc4_;
         if(param3 != null)
         {
            _loc5_ = param3.length;
            while(_loc5_--)
            {
               this.m_aliases[param3[_loc5_].toLowerCase()] = _loc4_;
            }
         }
      }
      
      public function registerClassAlias(param1:String, param2:String) : void
      {
         this.m_aliases[param2.toLowerCase()] = param1.toLowerCase();
      }
   }
}

