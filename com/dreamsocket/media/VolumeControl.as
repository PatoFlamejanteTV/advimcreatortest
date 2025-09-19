package com.dreamsocket.media
{
   import com.dreamsocket.events.VolumeEvent;
   import flash.events.EventDispatcher;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   
   public class VolumeControl extends EventDispatcher implements IAudible
   {
      
      protected var m_audibleClients:Dictionary;
      
      protected var m_transformClients:Dictionary;
      
      protected var m_mute:Boolean;
      
      protected var m_sndTransform:SoundTransform;
      
      protected var m_volume:Number;
      
      public function VolumeControl()
      {
         super();
         this.m_audibleClients = new Dictionary(true);
         this.m_transformClients = new Dictionary(true);
         this.m_mute = false;
         this.m_volume = 1;
         this.m_sndTransform = new SoundTransform(this.m_volume);
      }
      
      public function get muted() : Boolean
      {
         return this.m_mute;
      }
      
      public function set muted(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         if(param1 != this.m_mute)
         {
            this.m_mute = param1;
            this.m_sndTransform.volume = param1 ? 0 : this.m_volume;
            this.updateTransforms();
            for(_loc2_ in this.m_audibleClients)
            {
               _loc2_.muted = param1;
            }
            this.dispatchEvent(new VolumeEvent(param1 ? VolumeEvent.VOLUME_MUTED : VolumeEvent.VOLUME_UNMUTED,this.volume,param1));
         }
      }
      
      public function get soundTransform() : SoundTransform
      {
         return this.m_sndTransform;
      }
      
      public function get volume() : Number
      {
         return this.m_volume;
      }
      
      public function set volume(param1:Number) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Number = Math.max(0,Math.min(1,param1));
         if(_loc2_ != this.m_volume)
         {
            this.m_volume = _loc2_;
            this.m_sndTransform.volume = this.muted ? 0 : _loc2_;
            this.updateTransforms();
            for(_loc3_ in this.m_audibleClients)
            {
               _loc3_.volume = _loc2_;
            }
            if(this.hasEventListener(VolumeEvent.VOLUME_CHANGED))
            {
               this.dispatchEvent(new VolumeEvent(VolumeEvent.VOLUME_CHANGED,_loc2_,this.muted));
            }
         }
      }
      
      public function addClient(param1:Object) : void
      {
         if(param1 is IAudible)
         {
            this.m_audibleClients[param1] = true;
            IAudible(param1).volume = this.volume;
            IAudible(param1).muted = this.muted;
         }
         else
         {
            if(!param1.hasOwnProperty("soundTransform"))
            {
               throw new TypeError("Type does not have a soundTransform property");
            }
            this.m_transformClients[param1] = true;
            param1.soundTransform = this.m_sndTransform;
         }
      }
      
      public function removeClient(param1:Object) : void
      {
         delete this.m_audibleClients[param1];
         delete this.m_transformClients[param1];
      }
      
      protected function updateTransforms() : void
      {
         var _loc1_:Object = null;
         for(_loc1_ in this.m_transformClients)
         {
            _loc1_.soundTransform = this.m_sndTransform;
         }
      }
   }
}

