package com.dreamsocket.cues
{
   import com.dreamsocket.data.IRange;
   import com.dreamsocket.data.Range;
   
   public class CueRange extends Range implements ICueRange
   {
      
      protected var m_className:String;
      
      protected var m_data:*;
      
      protected var m_enterEventType:String;
      
      protected var m_exitEventType:String;
      
      protected var m_ID:Object;
      
      public function CueRange(param1:Object, param2:Number, param3:Number = NaN, param4:* = null, param5:String = "dynamic")
      {
         super(param2,isNaN(param3) ? param2 : param3);
         this.m_ID = param1;
         this.m_data = param4;
         this.m_className = param5;
      }
      
      public function get className() : String
      {
         return this.m_className;
      }
      
      public function get data() : *
      {
         return this.m_data;
      }
      
      public function set data(param1:*) : void
      {
         this.m_data = param1;
      }
      
      public function get enterEventType() : String
      {
         return this.m_enterEventType;
      }
      
      public function set enterEventType(param1:String) : void
      {
         this.m_enterEventType = param1;
      }
      
      public function get exitEventType() : String
      {
         return this.m_exitEventType;
      }
      
      public function set exitEventType(param1:String) : void
      {
         this.m_exitEventType = param1;
      }
      
      public function get ID() : Object
      {
         return this.m_ID;
      }
      
      override public function clone() : IRange
      {
         var _loc1_:CueRange = null;
         _loc1_ = new CueRange(_loc1_.ID,_loc1_.start,_loc1_.end,_loc1_.className);
         _loc1_.enterEventType = this.enterEventType;
         _loc1_.exitEventType = this.exitEventType;
         return _loc1_;
      }
      
      override public function toString() : String
      {
         var _loc1_:* = "";
         _loc1_ += "[CuePointRange (";
         _loc1_ += "ID:" + this.ID + " ";
         _loc1_ += "start:" + this.start + " ";
         _loc1_ += "end:" + this.end + " ";
         _loc1_ += "className:" + this.className + " ";
         _loc1_ += "enterEventType:" + this.enterEventType + " ";
         _loc1_ += "exitEventType:" + this.exitEventType + " ";
         return _loc1_ + ")]";
      }
   }
}

