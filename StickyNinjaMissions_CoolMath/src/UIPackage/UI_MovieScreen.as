package UIPackage
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import MissionPackage.Missions;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_MovieScreen extends UIScreenInstance
	{
		public static var pageToShow:int = 0;
		
		public function UI_MovieScreen() 
		{
			
		}
		
		public override function ExitScreen()
		{
			UIX.StopPage(titleMC, pageInst);
		}
		
		public override function InitScreen()
		{
			titleMC = new MovieClip();
			uix_pageName = "page_story1";
			if(pageToShow == 1) uix_pageName = "page_story2";
			
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("buttonContinue"), buttonContinuePressed);			
		
			pageInst.InitTimelines();
			pageInst.gameObjects.Update();
			
		}
		
		
		
		public function buttonContinuePressed(inst:UIX_Instance)
		{
			if (pageToShow == 0)
			{
				
				Missions.currentMissionLevelIndex = 0;
				Missions.currentMissionIndex = 0;
				var n:String = Missions.GetCurrentMissionLevel().levelName;
				Levels.currentIndex = Levels.GetLevelIndexById(n);
				
				UI.StartTransition("gamescreen");	
			}
			if (pageToShow == 1)
			{
				UI.StartTransition("title");	
			}
		}

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------

		
	}

}