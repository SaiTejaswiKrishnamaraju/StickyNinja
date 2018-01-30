package UIPackage 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import LicPackage.Lic;
	import LicPackage.LicAds;
	import LicPackage.LicDef;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_WalkthroughScreen extends UIScreenInstance
	{
		
		public function UI_WalkthroughScreen() 
		{
			
		}

		public override function ExitScreen()
		{
			Utils.print("removing level " + Levels.currentIndex);
			
			var w:WalkthroughScreen = Walkthrough.walkthroughScreens[Levels.currentIndex];
			w.StopPlayback();
			
			Game.gameState = Game.gameState_Play;
			
			UI.RemoveAllButtons();
			//UI.RemoveGeneric();
			
			
		}
		public override function InitScreen()
		{
			
			UI.StartAddButtons();
			
			titleMC = new MovieClip();	// screen_walkthrough();
			titleMC.gotoAndStop(1);

			Lic.MainLogoButton(titleMC.mainLogo);		
			
			TextStrings.ReplaceTextFieldText(titleMC.textTitle);
			
//			Lic.AuthorButton(titleMC.turboBtn);
			
			UI.AddAnimatedMCButton(titleMC.buttonBack, backClicked);
			//UI.AddAnimatedMCButton(titleMC.buttonNext, nextClicked);
					
			
			titleMC.textLevelName.text = Levels.GetCurrent().name;
			
			var w:WalkthroughScreen = Walkthrough.walkthroughScreens[Levels.currentIndex];
			w.InitPlayback(titleMC);
			
			
			LicDef.GetStage().stage.frameRate = Defs.fps;
			
		}
		
		
		function backClicked(e:MouseEvent)
		{
			var w:WalkthroughScreen = Walkthrough.walkthroughScreens[Levels.currentIndex];
			w.StopPlayback();
			UI.StartTransition("walkthrough");
		}
		
		
	}

}