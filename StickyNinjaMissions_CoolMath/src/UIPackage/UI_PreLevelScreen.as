

package UIPackage  
{
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_PreLevelScreen extends UIScreenInstance
	{
		
		public function UI_PreLevelScreen() 
		{
			
		}
		public override function ExitScreen()
		{
			
		}
		public override function InitScreen()
		{
			titleMC = new PreLevelScreen();
			var l:Level = Game.GetCurrentLevel();
			titleMC.textDescription.text = l.description;
			titleMC.textName.text = l.name;
			UI.AddMCButton(titleMC.buttonOK, buttonOKPressed);			
		}
		public static function buttonOKPressed(e:MouseEvent)
		{
			UI.StartTransition(null, Game.StartLevel);
		}
		
	}

}