package UIPackage 
{
	import AudioPackage.Audio;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import LicPackage.Lic;
	import LicPackage.LicDef;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_Credits extends UIScreenInstance
	{
		
		public function UI_Credits() 
		{
			
		}

		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			
			titleMC = new MovieClip();
			uix_pageName = "page_credits";
			pageInst = UIX.StartPage(titleMC, uix_pageName);
						
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), buttonBackPressed);	
			UIX.SetHardwareBackButton(pageInst.Child("btn_back"));			

			
			if (LicDef.GetCurrentSku().allowAuthorLink)
			{
				UIX.AddAnimatedButton(pageInst.Child("buttonLongAnimals"), link_longAnimalsPressed);	
				UIX.AddAnimatedButton(pageInst.Child("buttonRobotJAM"), link_asutePressed);	
				UIX.AddAnimatedButton(pageInst.Child("buttonSnakeEngine"), link_snakeEnginePressed);	
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

		
		function link_snakeEnginePressed(inst:UIX_Instance):void
		{
			Lic.DoLink("http://www.longanimalsgames.com/SnakeEngine.php", "credits","snakeengine");
		}
		function link_longAnimalsPressed(inst:UIX_Instance):void
		{
			Lic.DoLink("http://www.longanimalsgames.com", "credits","longanimals");
		}
		function link_robotJamPressed(inst:UIX_Instance):void
		{
			Lic.DoLink("http://www.robotjam.com", "credits","robotjam");
		}
		function link_jimpPressed(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.artjimp.com?gamereferral=cyclomaniacsepic"),"_blank");		
		}
		function link_asutePressed(inst:UIX_Instance):void
		{
			Lic.DoLink("http://www.biscuitlocker.com", "credits","biscuitlocker");
		}
		function buttonBackPressed(inst:UIX_Instance):void
		{
			UI.StartTransition("title");
		}
		
	}

}