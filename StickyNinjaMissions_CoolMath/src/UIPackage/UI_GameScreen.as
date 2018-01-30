package UIPackage 
{
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import LicPackage.LicDef;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_GameScreen extends UIScreenInstance
	{
		
		public function UI_GameScreen() 
		{
			
		}
		public override function ExitScreen()
		{
			Game.StopLevel();
	
			if (PROJECT::useStage3D)
			{
				
			}
			else
			{
				titleMC.removeChild(Game.main.screenB);
			}
		}
		
		public override function InitScreen()
		{
			
			if (PROJECT::useStage3D)
			{
				LicDef.GetStage().stage.frameRate = Defs.update_fps;
				titleMC = new MovieClip();
				
				Game.currentMC = titleMC;
				Game.StartLevel();
				
			}
			else
			{
				LicDef.GetStage().stage.frameRate = Defs.update_fps;
//				LicDef.GetStage().stage.quality = StageQuality.MEDIUM;

				Game.main.screenB.bitmapData.fillRect(Defs.screenRect, 0);
				titleMC = new MovieClip();
				titleMC.addChild(Game.main.screenB);
				
				Game.currentMC = titleMC;
				Game.main.screenB.x = 0;
				Game.main.screenB.y = 0;
				Game.StartLevel();
	//			Game.UpdateGameplay();
	//			Game.Render();
				
			}
		}
		
	}

}