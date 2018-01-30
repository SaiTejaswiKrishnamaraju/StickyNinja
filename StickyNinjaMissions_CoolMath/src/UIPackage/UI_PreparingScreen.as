package UIPackage 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.System;
	import LicPackage.Lic;
	import LicPackage.LicAds;
	import LicPackage.LicDef;
	import TexturePackage.Preparing;
	import TexturePackage.TexturePages;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_PreparingScreen extends UIScreenInstance
	{
		
		public function UI_PreparingScreen() 
		{
			
		}
		public override function ExitScreen()
		{
			
		}
		public override function InitScreen()
		{
			mem1 = System.totalMemory / 1024;
			
			
			
			if (PROJECT::isMobile == false)
			{
				titleMC = new screen_preparing();
				ScreenSize.ScaleMovieClip(titleMC);
			}
			else
			{
				if (Game.loadTextureFiles == false)
				{
					titleMC = new screen_preparing();
					ScreenSize.ScaleMovieClip(titleMC);
					
				}
				else
				{
				titleMC = new MovieClip();
					
				}
			}

			Preparing.Modify();
			
			titleMC.addEventListener(Event.ENTER_FRAME, UpdatePreparingScreen, false, 0, true);

			
			preparingGraphicsTimer = 0;
			preparingGraphicsIndex = 0;
			PreparingScreenSetBar();

			
		}
		var preparingScreenDone:Boolean = false;
		var preparingGraphicsTimer:int;
		
		var preparingGraphicsIndex:int;
		
		function UpdatePreparingScreen(e:Event)
		{
			if (titleMC == null) return;
			preparingGraphicsTimer--;
			if (preparingGraphicsTimer > 0) return;
			PreparingScreenSetBar();
			
			var maxPerFrame:int = 20;
			
			for (var i:int = 0; i < maxPerFrame; i++)
			{
			
				var po:PreparingObject = Preparing.GetPreparingList()[preparingGraphicsIndex];
				Preparing.DoPreparingObject(po);
				
				PreparingScreenSetBar();
				preparingGraphicsIndex++;
				if (preparingGraphicsIndex >= Preparing.GetPreparingList().length) 
				{				
					i = maxPerFrame;
					TexturePages.Create();
					TexturePages.LoadGraphicObjectsForPreparing();
					UIX.CreateDisplayObjs();
					GameVars.InitHierarchies();

					Preparing.RemoveAllUnwantedMovieClips();

					
					preparingScreenDone = true;
					titleMC.removeEventListener(Event.ENTER_FRAME, UpdatePreparingScreen);
					
					var mem2:int = System.totalMemory / 1024;
					var memused:int = mem2 - mem1;
					Utils.print("memory used for gfx: " + memused + "k");
					
					if (Game.doWalkthrough)
					{
						UI.StartTransition("walkthrough");
					}
					else
					{
						if (false)	//PROJECT::useStage3D)
						{
							Levels.currentIndex = 0;
							UI.StartTransition("gamescreen");
						}
						else
						{					
							UI.StartTransition("title");
						}
					}
				}
			}
		}
		
		
		function PreparingScreenSetBar()
		{			
			if (PROJECT::isMobile)
			{
				if (Game.loadTextureFiles) return;
			}

			if (titleMC == null) return;
			var pc:Number = Utils.ScaleTo(0, 1, 0, Preparing.GetPreparingList().length-1, preparingGraphicsIndex);
			titleMC.loaderBar.loadBar.scaleX = pc;
		}
		static var mem1:int;
		
	}

}