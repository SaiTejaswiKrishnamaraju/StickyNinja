package {
	import AudioPackage.Audio;
	import EditorPackage.GameLayers;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.system.System;
	import flash.text.*;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.getTimer;
	import flash.net.*;
	import flash.ui.*
	import flash.display.StageDisplayState;
	import flash.utils.Timer;
	import LicPackage.AdMediator;
	import LicPackage.Lic;
	import MobileSpecificPackage.MobileSpecific;
	import TexturePackage.TexturePages;
	import UIPackage.UI;
	import UIPackage.UIX;


	[Frame(factoryClass="Preloader")]
	public dynamic class Main extends MovieClip 
	{
		private var ftime:Number;// frame time
		private var currentTime:Number = 0;

		public var screenBD:BitmapData;
		public var screenB:Bitmap;


		public static var theRoot:MovieClip;
		public static var theStage:Stage;

		public function Main() 
		{
			addEventListener(Event.ADDED_TO_STAGE, added_to_stage, false, 0, true);
		}

		function added_to_stage(e:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, added_to_stage);			
			Lic.InitFromMain();
			Utils.GetFlash11_3()

			Lic.ShowIntro(NewInit4);
			
		}
		function NewInit4()
		{
			theRoot = this;
			theStage = this.root.stage;
			SetEverythingUpOnce();
			
		}
		
		
		function InitDrawScreen():void
		{
			if (PROJECT::useStage3D) return;
			screenBD=new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0x0);
			screenB=new Bitmap(screenBD);			

		}
		
		
		function SetEverythingUpOnce():void
		{
			SetEverythingUpOnce2();
		}
		
		function SetEverythingUpOnce2():void
		{
			MobileSpecific.Init();
			
			
			TexturePages.InitOnce();

			GraphicObjects.InitOnce();
			// Set up the click timer

			EngineDebug.InitOnce();
			KeyReader.InitOnce(theStage);			
			MouseControl.InitOnce(theStage);
			Audio.InitOnce();		
			PauseMenu.InitOnce();
			Particles.InitOnce(Defs.maxParticles);
			GameObjects.InitOnce(Defs.maxGameObjects);
			UI.InitOnce();
			InitDrawScreen();
			AdMediator.InitOnce();
			ExternalData.Load(SetEverythingUpOnce4);
		}
		
		function SetEverythingUpOnce4()
		{
			ClearStage();
			Game.InitOnce(this);
			mainCounter = 0;
			addEventListener(Event.ENTER_FRAME, MainLoop);
			
		}

		public function ClearStage()
		{
			var i:int;
			for (i=this.numChildren-1; i>=0; i--) {
				removeChildAt(i);
			}
		}
		

		public function DisplayStageNames()
		{
			var i:int;
			for (i=this.numChildren-1; i>=0; i--) {
				var dob:DisplayObject = getChildAt(i);
				Utils.print(dob.name);				
			}
		}
		
		
		
		function Render(bd:BitmapData) 
		{
			this.x = 0;
			this.y  = 0;
			Game.Render(bd);
		}

		var timeForFrame:Number;
		function calcFrameTime() {
			var oldTime:Number = currentTime;
			currentTime = getTimer();
			
			timeForFrame = currentTime - oldTime;
			
			if(currentTime < oldTime) oldTime = currentTime-100;
			if(currentTime > oldTime+(100*10)) oldTime = 100*10;
			
			ftime = 1 / (1000 / Defs.fps) * (currentTime - oldTime);
			
			framecounter ++;
			secondCounter += (currentTime - oldTime);
			
			if (secondCounter > 1000)
			{
				fps = (Number(framecounter) / secondCounter) * 1000;
				framecounter = 0;
				secondCounter = 0;
			}
			
//			ftime = 1;
		}
		public var fps:Number;		
		var framecounter:int = 0;
		var secondCounter:Number = 0.0;



		
		var renderCount:int = 0;
		var frameSkipCount:int = 0;
		
		public var timeForUpdate:Number = 0;
		var renderSkip:Boolean = false;
		
		function RunLevel() 
		{
			
			if (Game.doWalkthrough) return;
			
			Game.UpdateGameplay();
		}	
			
		
		var useFrameSkip:Boolean = true;
		var skipFrame:Boolean = true;

		public var pauseMainLoop:Boolean = false;
		
		public var mainCounter:Number = 0;
		function MainLoop(e:Event):void 
		{
			if (pauseMainLoop) return;
			mainCounter++;
			var oldTime:Number = getTimer();
			
			KeyReader.UpdateOncePerFrame();			
			Audio.UpdateOncePerFrame();

			GameVars.InitForFrame();
			RunLevel();
			GameVars.ExitForFrame();
			
			if (Game.using30fps)
			{
				KeyReader.UpdateOncePerFrame();			
				Audio.UpdateOncePerFrame();

				GameVars.InitForFrame();
				RunLevel();
				GameVars.ExitForFrame();
			}
			
			Render(screenBD);
			timeForUpdate = getTimer() - oldTime;
			
			

			calcFrameTime();
		}
	}
}