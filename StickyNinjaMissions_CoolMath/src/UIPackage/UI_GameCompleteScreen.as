package UIPackage
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import AudioPackage.Audio;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	import LicPackage.AdHolder;
	import LicPackage.Lic;
	import LicPackage.LicDef;
	import MobileSpecificPackage.MobileSpecific;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_GameCompleteScreen extends UIScreenInstance
	{
		
		public function UI_GameCompleteScreen () 
		{
			
		}
		public override function ExitScreen()
		{
			ExitScreenUIX();
		}
		
		function ExitScreenUIX()
		{
			UIX.StopPage(titleMC, pageInst);
			
		}
		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			titleMC = new MovieClip();
			uix_pageName = "page_gamecomplete";
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("buttonPlay"), UIX_buttonNextPressed);			
			
			var count1:int = 0;
			var count2:int = 0;
			var count3:int = 0;
			for each(var l:Level in Levels.list)
			{
				if (l.bestPlace <= 0) count1++;
				if (l.bestPlace <= 1) count2++;
				if (l.bestPlace <= 2) count3++;
			}
			var numLevels:int = Levels.list.length;
			
			pageInst.Child("text1").SetText(count1 + "/" + numLevels);
			pageInst.Child("text2").SetText(count2 + "/" + numLevels);
			pageInst.Child("text3").SetText(count3 + "/" + numLevels);
			
			pageInst.gameObjects.AddInstance(pageInst.Child("buttonPlay")).InitAppear(UIX_GameObj.EDGE_BOTTOM,0);			
			pageInst.gameObjects.AddInstance(pageInst.Child("bg")).InitAppear(UIX_GameObj.EDGE_NONE,0);			
			pageInst.gameObjects.AddInstance(pageInst.Child("text1")).InitAppear(UIX_GameObj.EDGE_NONE,5);			
			pageInst.gameObjects.AddInstance(pageInst.Child("text2")).InitAppear(UIX_GameObj.EDGE_NONE,7);			
			pageInst.gameObjects.AddInstance(pageInst.Child("text3")).InitAppear(UIX_GameObj.EDGE_NONE,9);			
			pageInst.gameObjects.Update();
			
		}
		
		function UIX_buttonNextPressed(inst:UIX_Instance)
		{				
			UI.StartTransition("matchselect");
		}
		
		
		public override function InitScreen()
		{
			InitScreenUIX();
		}	
	}

}