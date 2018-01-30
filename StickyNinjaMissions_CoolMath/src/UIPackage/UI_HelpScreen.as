package UIPackage
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_HelpScreen extends UIScreenInstance
	{
		public static var pageToShow:int = 0;
		
		public function UI_HelpScreen() 
		{
			
		}
		
		public override function ExitScreen()
		{
			ExitScreenUIX();
			return;
			
		}
		function ExitScreenUIX()
		{
			UIX.StopPage(titleMC, pageInst);
		}
		
		function InitScreenUIX()
		{
			titleMC = new MovieClip();
			uix_pageName = "page_helpscreen";
			
			if (PROJECT::useStage3D)
			{
				uix_pageName = "page_helpscreen_mobile";				
			}
			if (PROJECT::isGamePad)
			{
				uix_pageName = "page_helpscreen_ouya";
			}
			
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("buttonContinue"), buttonContinuePressed);			
		
			pageInst.Child("page").frame = pageToShow;
		
			var go:UIX_GameObj;
			go = pageInst.gameObjects.AddInstance(pageInst.Child("buttonContinue"));
			go.InitAppear(UIX_GameObj.EDGE_BOTTOM,0);
			
			pageInst.gameObjects.Update();
			
		}
		
		
		
		public function buttonContinuePressed(inst:UIX_Instance)
		{
			if (GameVars.firstTime)
			{
				UI.StartTransition("gamescreen");											
			}
			else
			{
				UI.StartTransition("playerselect");							
			}

		}

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------

		public override function InitScreen()
		{
			InitScreenUIX();
			return;
			
		}
	}

}