package UIPackage 
{
	import AudioPackage.Audio;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import LicPackage.Lic;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_Controls extends UIScreenInstance
	{
		
		public function UI_Controls() 
		{
			
		}

		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			
			titleMC = new MovieClip();
			uix_pageName = "page_controls";
			pageInst = UIX.StartPage(titleMC, uix_pageName);
						
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), buttonBackPressed);	
			
			pageInst.gameObjects.AddInstance(pageInst.Child("btn_back")).InitAppear(UIX_GameObj.EDGE_TOP, 0);
			
			var numLayouts:int = GameVars.NumCurrentControlLayouts;
			
			for (var i:int = 0; i < numLayouts; i++)
			{
				var inst:UIX_Instance = pageInst.Child("layout" + int(i + 1));
				inst.userData.index = i;
				UIX.AddAnimatedButton(inst, buttonLayoutPressed);	

			}
			
		}
		
		
		function ExitScreenUIX()
		{
			UIX.StopPage(titleMC,pageInst);
		}		
		
		public override function ExitScreen()
		{
			ExitScreenUIX();
		}
		public override function InitScreen()
		{
			InitScreenUIX();
		}

		
		function buttonLayoutPressed(inst:UIX_Instance):void
		{
			GameVars.CurrentControlLayoutIndex = inst.userData.index;
			trace(GameVars.CurrentControlLayoutIndex);
			UI.StartTransition("title");			
		}
		function buttonBackPressed(inst:UIX_Instance):void
		{
			UI.StartTransition("title");
		}
		
	}

}