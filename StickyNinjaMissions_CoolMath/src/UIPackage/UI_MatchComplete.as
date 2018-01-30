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
	import MissionPackage.Mission;
	import MissionPackage.Missions;
	import MobileSpecificPackage.MobileSpecific;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_MatchComplete extends UIScreenInstance
	{
		
		public function UI_MatchComplete () 
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
		
		function SetLevelTrophy(inst:UIX_Instance,l:Level)
		{
			return;
			inst.frame = l.completionLevel;
		}
		
		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			titleMC = new MovieClip();
			uix_pageName = "page_matchcomplete";
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("buttonPlay"), UIX_buttonNextPressed);			
			
//			pageInst.Child("youBeatText").SetText("You Beat " + GameVars.GetTeam(GameVars.currentMatchIndex+1).teamName);
			
			var m:Mission = Missions.GetMission(GameVars.currentMatchIndex);

			
			pageInst.gameObjects.Update();
			
		}
		
		function UIX_buttonNextPressed(inst:UIX_Instance)
		{				
			UI.StartTransition("shop");
		}
		
				
		
		public override function InitScreen()
		{
			InitScreenUIX();
		}	
	}

}