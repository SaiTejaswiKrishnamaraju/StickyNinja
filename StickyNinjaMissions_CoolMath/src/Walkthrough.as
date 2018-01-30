package  
{
	/**
	 * ...
	 * @author 
	 */
	public class Walkthrough 
	{
		
		public function Walkthrough() 
		{
			
		}
	
		
		public static var walkthroughScreens:Array;
		
		public static function InitScreens()
		{
			walkthroughScreens = new Array();
			for (var i:int = 0; i < Levels.list.length; i++)
			{
				var w:WalkthroughScreen = new WalkthroughScreen();
				w.MakeScreen(i);
				walkthroughScreens.push(w);
			}
		}
		
		public static function InitScreen()
		{
			walkthroughScreens = new Array();
			for (var i:int = 0; i < Levels.list.length; i++)
			{
				
				var w:WalkthroughScreen = new WalkthroughScreen();
				if (i == Levels.currentIndex)
				{
					w.MakeScreen(i);
				}
				walkthroughScreens.push(w);
			}
		}

		
		
		
	}

}