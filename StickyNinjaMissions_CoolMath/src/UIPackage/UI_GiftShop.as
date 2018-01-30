package UIPackage 
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import AudioPackage.Audio;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import LicPackage.AdHolder;
	import LicPackage.Lic;
	import LicPackage.LicAds;
	import LicPackage.LicDef;
	import LicPackage.LicSku;
	import LicPackage.OtherGames;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_GiftShop extends UIScreenInstance
	{
		
		public function UI_GiftShop() 
		{
			
		}

		public override function InitScreen()
		{
			InitScreenUIX();
			return;
		}
		public override function ExitScreen()
		{
			
			ExitScreenUIX();
		}
		function ExitScreenUIX()
		{
			
			for (var i:int = 0; i < 8; i++)
			{
				var itemNumber:int = i + 1;
				var inst_button:UIX_Instance = pageInst.Child("feature" + itemNumber);
				GameVars.SetFeatureActive(i, UIX.GetTickButtonState(inst_button));
			}
			
			SaveData.Save();
			UIX.StopPage(titleMC,pageInst);
		}
		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");			
			titleMC = new MovieClip();
			uix_pageName = "page_shop";
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), buttonBackPressed);	
			
			UIX.AddGeneric(pageInst.Child("generic"));

//			GameVars.UIX_InitCoinBoxClip(pageInst.Child("coinBox"));
			
			
			for (var i:int = 0; i < 8; i++)
			{
				var itemNumber:int = i + 1;
				var inst_button:UIX_Instance = pageInst.Child("feature" + itemNumber);
				inst_button.userData.itemNumber = itemNumber;
				
				var tickState:Boolean = GameVars.GetFeatureActive(i);
				
				UIX.AddTickButton(inst_button, buttonFeaturePressed,null,false,null,null,tickState);	
				

			}
			
		}
		
		function buttonFeaturePressed(inst:UIX_Instance):void
		{
			trace("pressed " + inst.userData.itemNumber);
		}
		
		function buttonBackPressed(inst:UIX_Instance):void
		{
			UI.StartTransition("levelselect");
		}
		
		
		
	}

}