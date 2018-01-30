package 
{
	if (PROJECT::useStage3D)
	{
		import flash.ui.Multitouch;
		import flash.ui.MultitouchInputMode;		
		import MobileSpecificPackage.MobileSpecific;
	}
	import LicPackage.LicCoolmath;
	import flash.utils.setTimeout;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import LicPackage.AdHolder;
	import LicPackage.LicAds;
	import LicPackage.LicDef;
	import LicPackage.Tracking;
	
	/**
	 * ...
	 * @author LongAnimals
	 */
	
	 public dynamic class Preloader extends MovieClip 
	 {
		 
		 public function Preloader() 
		 {
 			addEventListener(Event.ADDED_TO_STAGE, added_to_stage, false, 0, true);
		 }
		 function added_to_stage(e:Event)
		 {
			 removeEventListener(Event.ADDED_TO_STAGE, added_to_stage);
			 
			 LicCoolmath.InitFromPreloader();
			 
 //--- KIZI START
			LicDef.InitFromPreloader(this);
			if (LicDef.GetLicensor() == LicDef.LICENSOR_KIZI)
			{
			  ScreenSize.Calculate(stage);

				Security.allowDomain("*");

				addEventListener(Event.ENTER_FRAME, updateProgress_Kizi);
				 
				
				if (ExternalInterface.available)
					ExternalInterface.addCallback("startGame", startGame_Kizi);

				return;
			}
//--- KIZI END				 
			 
			 
			 if (stage) 
			 {
				 
				  if (PROJECT::useStage3D)
				  {
//					  stage.scaleMode = StageScaleMode.EXACT_FIT;	
					  stage.align = StageAlign.TOP_LEFT;
					  //stage.fullScreenSourceRect = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);	
					  //stage.displayState = StageDisplayState.FULL_SCREEN;
					Multitouch.inputMode = MultitouchInputMode.NONE;
					Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
					stage.quality = StageQuality.HIGH;
					  stage.scaleMode = StageScaleMode.NO_SCALE;
					  stage.displayState = StageDisplayState.NORMAL;
				  }
				  else
				  {
					  stage.scaleMode = StageScaleMode.NO_BORDER;
					  stage.displayState = StageDisplayState.NORMAL;
					stage.quality = StageQuality.HIGH;
					  
				  }
				  
				  
				  ScreenSize.Calculate(stage);
				  if (PROJECT::useStage3D)
				  {
					  //Defs.fps = 30;
					  
					  if (PROJECT::isIOS)
					  {
						  if (MobileSpecific.IOS_ShouldUse30fps())
						  {
							  Defs.fps = 60;
							  Defs.ui_fps = 60;
							  Defs.update_fps =30;
							  Game.using30fps = true;
						  }
					  }
					  if (PROJECT::isGamePad)
					  {
						MobileSpecific.InitOuyaGamePad();
					  }
					  
				  }
			 }
			 
			 
			Tracking.InitOnce(stage);
			LicDef.InitFromPreloader(this);
			AdHolder.InitOnce(AdHolderInitOnceCB);
			 
		 }
		 function AdHolderInitOnceCB()
		 {
			LicAds.ShowAd(LicAdsShowAdCB);			 
		 }
		 function LicAdsShowAdCB()
		 {
			 addEventListener(Event.ENTER_FRAME, checkFrame,false,0,true);
			 loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			 loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			 
		 }
		 
		 private function ioError(e:IOErrorEvent):void 
		 {
			 //Utils.trace(e.text);
		 }
		 
		 private function progress(e:ProgressEvent):void 
		 {
			 // TODO update loader
		 }
		 
		 private function checkFrame(e:Event):void 
		 {
			 if (currentFrame == totalFrames) 
			 {
				 stop();
				 loadingFinished1();
			 }
		 }
		 
		 private function loadingFinished1():void 
		 {
			 removeEventListener(Event.ENTER_FRAME, checkFrame);
			 loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			 loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			 
			loadingFinished2();
		 }
		 private function loadingFinished2():void 
		 {
			 startup();
		 }
		 
		 private function startup():void 
		 {
			 var mainClass:Class = getDefinitionByName("Main") as Class;
			 addChild(new mainClass() as DisplayObject);
		 }
		 
//-----------------------------------------------------------------------------------------------------
// KIZI START
//-----------------------------------------------------------------------------------------------------
		
		private function updateProgress_Kizi(e:Event):void
		{
			// update percents loaded
			var total:Number = stage.loaderInfo.bytesTotal;
			var loaded:Number = stage.loaderInfo.bytesLoaded;
			var pct:int= loaded / total * 100;
			
			// Report to the Oopla preloader about the game file load progress
			if (ExternalInterface.available)
			{
				ExternalInterface.call("setPreloaderProgress",  pct );
			}
			else
			{	
				// No external interface is available (stand-alone mode?), so we need to launch
// the game ourselves
				if (pct == 100)
					setTimeout(startGame_Kizi, 1000);
			}
			
			// Everything is loaded, we can stop running this event
			if (pct == 100)
					removeEventListener(Event.ENTER_FRAME, updateProgress_Kizi);	
			
		}
		
		
		private function startGame_Kizi():void
		{
			// hide loader			
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChildAt(new mainClass() as DisplayObject, 0);			
		}
				 
//-----------------------------------------------------------------------------------------------------
// KIZI END
//-----------------------------------------------------------------------------------------------------
		 

	}
	
}