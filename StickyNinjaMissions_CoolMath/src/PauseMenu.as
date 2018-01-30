package  
{
	import AudioPackage.Audio;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.getTimer;
	import flash.net.*;
	import flash.ui.*
	import LicPackage.AdHolder;
	import LicPackage.LicDef;
	import LicPackage.OtherGames;
	import MobileSpecificPackage.MobileSpecific;
	import TextPackage.TextStrings;
	import UIPackage.UI;
	import UIPackage.UIX;
	import UIPackage.UIX_Instance;
	import UIPackage.UIX_PageInstance;
//	import fl.controls.RadioButton;
//	import fl.controls.RadioButtonGroup;

	/**
	* ...
	* @author Default
	*/
	public class PauseMenu 
	{
		static var active:Boolean;
		static var pauseMC:MovieClip;
		
		public static function InitOnce():void
		{
			active = false;
		}		
		
		public function PauseMenu():void
		{
		}
		
		static var uix_pageName:String;
		static var pageInst:UIX_PageInstance;
		static function Unpause_UIX()
		{			
			
			if (PROJECT::useStage3D == false)
			{
				if (LicDef.AreOtherGamesAdsAllowed())
				{
					pageInst.Child("background").RemoveMovieClipDisplayChild();
				}
			}
			
			active = false;
			UIX.StopPage(pauseMC, pageInst);
			MouseControl.buttonPressed = false;
			MouseControl.buttonReleased = false;
			
			Game.mouseDown = false;
			Game.mouseReleased = false;
						
			Game.hudController.Show();

		}
		static function InitScreenUIX()
		{
			Game.hudController.Hide();
			pauseMC = new MovieClip();
			uix_pageName = "page_pause";
			pageInst = UIX.StartPage(pauseMC,uix_pageName);
			
			active = true;

			UIX.AddAnimatedButton(pageInst.Child("buttonContinue"), UIX_buttonContinuePressed);			
			UIX.AddAnimatedButton(pageInst.Child("buttonRestart"), UIX_buttonRestartPressed);			
			UIX.AddAnimatedButton(pageInst.Child("buttonQuit"), UIX_buttonQuitPressed);		
			
			
			if (PROJECT::useStage3D == false)
			{
				if (LicDef.AreOtherGamesAdsAllowed())
				{
					pageInst.Child("background").AddMovieClipDisplayChild( OtherGames.GetOtherGamesMC(4,3),Defs.displayarea_w2+65,Defs.displayarea_h-62);
				}
			}
			
			UIX_AddDebugButtons();
		}
		
		public static function UIX_buttonNextLevelPressed(inst:UIX_Instance)
		{
			Unpause();
			Levels.IncrementLevel();
			UI.StartTransition("gamescreen");
			
		}
		public static function UIX_buttonPrevLevelPressed(inst:UIX_Instance)
		{
			Unpause();
			Levels.DecrementLevel();
			UI.StartTransition("gamescreen");
		}
		public static function UIX_buttonContinuePressed(inst:UIX_Instance)
		{			
			Unpause();
		}
		public static function UIX_buttonRestartPressed(inst:UIX_Instance)
		{			
			Unpause();
			Game.RestartLevel();
		}
		public static function UIX_buttonQuitPressed(inst:UIX_Instance)
		{			
			Unpause();
			UI.StartTransition("matchselect");
		}
		
		
		public static function Render(bd:BitmapData):void
		{
			if (PROJECT::isMobile == false)
			{
				pageInst.renderBD = bd;
				pageInst.Render();
			}
		}
		public static function Pause():void
		{
			InitScreenUIX();
			return;
		}
		
		public static function IsPaused():Boolean
		{
			return active;
		}
		
		public static function Unpause():void
		{
			Unpause_UIX();
			return;
		}
		
		static function DebugClicked(e:MouseEvent)
		{
			 EngineDebug.mobileTest0 = UI.GetAnimatedMCTickState(pauseMC.option0);
			 EngineDebug.mobileTest1 = UI.GetAnimatedMCTickState(pauseMC.option1);
			 EngineDebug.mobileTest2 = UI.GetAnimatedMCTickState(pauseMC.option2);
			 EngineDebug.mobileTest3 = UI.GetAnimatedMCTickState(pauseMC.option3);
			 EngineDebug.mobileTest4 = UI.GetAnimatedMCTickState(pauseMC.option4);
			 EngineDebug.mobileTest5 = UI.GetAnimatedMCTickState(pauseMC.option5);
			 EngineDebug.mobileTest6 = UI.GetAnimatedMCTickState(pauseMC.option6);
			 EngineDebug.mobileTest7 = UI.GetAnimatedMCTickState(pauseMC.option7);
			 EngineDebug.mobileTest8 = UI.GetAnimatedMCTickState(pauseMC.option8);
			 EngineDebug.mobileTest9 = UI.GetAnimatedMCTickState(pauseMC.option9);
			 EngineDebug.mobileTest10 = UI.GetAnimatedMCTickState(pauseMC.option10);
			 EngineDebug.mobileTest11 = UI.GetAnimatedMCTickState(pauseMC.option11);
			 EngineDebug.mobileTest12 = UI.GetAnimatedMCTickState(pauseMC.option12);
			 EngineDebug.mobileTest13 = UI.GetAnimatedMCTickState(pauseMC.option13);
			 EngineDebug.mobileTest14 = UI.GetAnimatedMCTickState(pauseMC.option14);
			 
			 EngineDebug.mobileTestInt0 = UI.GetAnimatedMCCycleIndex(pauseMC.option15);
			
			 
			if (PROJECT::useStage3D)
			{
			 s3d.useRingOfBuffers = false;
			 s3d.useFastMem = false;
			 if(EngineDebug.mobileTest4) s3d.useRingOfBuffers = true;
			 if (EngineDebug.mobileTest6) s3d.useFastMem = true;
			}
			 
			 Game.main.useFrameSkip = true;
			 
			 if (EngineDebug.mobileTest7) Game.main.useFrameSkip = false;
			 
			 if (EngineDebug.mobileTest14) 
			 {
				 Audio.muteSFX = true;
			 }
			 else
			 {
				  Audio.muteSFX = false;
			 }
			 
			 
			 
		}

		static function UIX_DebugClicked(inst:UIX_Instance)
		{
			EngineDebug.mobileTest0 = UIX.GetTickButtonState(pageInst.Child("option0"));
			EngineDebug.mobileTest1 = UIX.GetTickButtonState(pageInst.Child("option1"));
			EngineDebug.mobileTest2 = UIX.GetTickButtonState(pageInst.Child("option2"));
			EngineDebug.mobileTest3 = UIX.GetTickButtonState(pageInst.Child("option3"));
			EngineDebug.mobileTest4 = UIX.GetTickButtonState(pageInst.Child("option4"));
			EngineDebug.mobileTest5 = UIX.GetTickButtonState(pageInst.Child("option5"));
			EngineDebug.mobileTest6 = UIX.GetTickButtonState(pageInst.Child("option6"));
			EngineDebug.mobileTest7 = UIX.GetTickButtonState(pageInst.Child("option7"));
			
			
		}
		
		static function UIX_AddDebugButtons()
		{
			
			if (true)	//PROJECT::useStage3D == false)
			{
				pageInst.Child("option0").visible = false;
				pageInst.Child("option1").visible = false;
				pageInst.Child("option2").visible = false;
				pageInst.Child("option3").visible = false;
				pageInst.Child("option4").visible = false;
				pageInst.Child("option5").visible = false;
				pageInst.Child("option6").visible = false;
				pageInst.Child("option7").visible = false;
				pageInst.Child("option7").visible = false;
				pageInst.Child("prevLevel").visible = false;
				pageInst.Child("nextLevel").visible = false;
			}
			
			if (false)
			{
				UIX.AddTickButton(pageInst.Child("option0"), UIX_DebugClicked,"HUD render",false,null,null,EngineDebug.mobileTest0);		
				UIX.AddTickButton(pageInst.Child("option1"), UIX_DebugClicked,"Background",false,null,null,EngineDebug.mobileTest1);		
				UIX.AddTickButton(pageInst.Child("option2"), UIX_DebugClicked,"BLEND",false,null,null,EngineDebug.mobileTest2);		
				UIX.AddTickButton(pageInst.Child("option3"), UIX_DebugClicked,"HUD update",false,null,null,EngineDebug.mobileTest3);		
				UIX.AddTickButton(pageInst.Child("option4"), UIX_DebugClicked,"",false,null,null,EngineDebug.mobileTest4);		
				UIX.AddTickButton(pageInst.Child("option5"), UIX_DebugClicked,"---",false,null,null,EngineDebug.mobileTest5);		
				UIX.AddTickButton(pageInst.Child("option6"), UIX_DebugClicked,"---",false,null,null,EngineDebug.mobileTest6);		
				UIX.AddTickButton(pageInst.Child("option7"), UIX_DebugClicked, "---", false, null, null, EngineDebug.mobileTest7);		
				
		
				UIX.AddAnimatedButton(pageInst.Child("prevLevel"), UIX_buttonPrevLevelPressed);			
				UIX.AddAnimatedButton(pageInst.Child("nextLevel"), UIX_buttonNextLevelPressed);			
			}
			
		}
		
		
	}
	
}