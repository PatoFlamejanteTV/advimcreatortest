package
{
   import com.cartoonnetwork.apps.fwplayer.UIVideoController;
   import com.cartoonnetwork.events.SiteLoaderEvent;
   import com.cartoonnetwork.utils.SiteLoader;
   import flash.display.MovieClip;
   import flash.display.StageScaleMode;
   
   public class MainDoc extends MovieClip
   {
      
      private var m_siteLoader:SiteLoader;
      
      private var _deepLinkID:String = null;
      
      protected var videoController:UIVideoController;
      
      public function MainDoc()
      {
         super();
         stage.showDefaultContextMenu = false;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         this.m_siteLoader = new SiteLoader(this);
         this.m_siteLoader.addEventListener(SiteLoaderEvent.COMPLETE,this.onComplete,false,0,true);
      }
      
      protected function onComplete(param1:SiteLoaderEvent) : void
      {
         this.init();
      }
      
      protected function init() : void
      {
         this.videoController = new UIVideoController();
         addChild(this.videoController);
      }
   }
}

