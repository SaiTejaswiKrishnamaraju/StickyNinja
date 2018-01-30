package UIPackage 
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import AudioPackage.Audio;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import LicPackage.AdHolder;
	import LicPackage.Lic;
	import LicPackage.LicAds;
	import LicPackage.LicCoolmath;
	import LicPackage.LicDef;
	import LicPackage.LicSku;
	import LicPackage.OtherGames;
	import MobileSpecificPackage.MobileSpecific;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_TitleScreen extends UIScreenInstance
	{
		
		public function UI_TitleScreen() 
		{
			
		}

		public override function ExitScreen()
		{
			ExitScreenUIX();
			
//			UI.RemoveAllButtons();
//			UI.RemoveGeneric();
			
			
			
		}
		
		
		function ExitScreenUIX()
		{
			UIX.StopPage(titleMC,pageInst);
		}
		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			
			titleMC = new MovieClip();
			uix_pageName = "page_title";
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("buttonPlay"), UIX_buttonPlayPressed);			
			UIX.AddAnimatedButton(pageInst.Child("buttonCredits"), UIX_buttonCreditsPressed);			
//			UIX.AddAnimatedButton(pageInst.Child("buttonShop"), UIX_buttonShopPressed);			
			UIX.AddAnimatedButton(pageInst.Child("buttonControls"), UIX_buttonControlsPressed);	
			
			
//			UIX.AddAnimatedButton(pageInst.Child("buttonRunExplorer"), UIX_buttonRunExplorerPressed);	
			UIX.AddAnimatedButton(pageInst.Child("buttonRestorePurchases"), UIX_buttonRestorePurchasesPressed);	
			
//			UIX.AddAnimatedButton(pageInst.Child("buttonFacebook1"), UIX_ButtonFacebookPressed1);		
//			UIX.AddAnimatedButton(pageInst.Child("buttonFacebook2"), UIX_ButtonFacebookPressed2);		
//			UIX.AddAnimatedButton(pageInst.Child("buttonPickteam"), UIX_ButtonPickteamPressed);		
			UIX.AddAnimatedButton(pageInst.Child("buttonClearSave"), UIX_buttonClearDataPopupPressed);		
			
			if (Game.usedebug == false)
			{
				pageInst.Child("buttonClearSave").visible = false;
			}
			
			if (PROJECT::isIOS == false)
			{
				pageInst.Child("buttonRestorePurchases").visible = false;
			}
			
			
			
//			pageInst.Child("buttonRunExplorer").visible = false;
			
			
			if (PROJECT::useStage3D == false)
			{
//				pageInst.Child("buttonFacebook1").visible = false;
//				pageInst.Child("buttonFacebook2").visible = false;
				pageInst.Child("buttonControls").visible = false; 
			}

			if (PROJECT::useStage3D)
			{
				pageInst.Child("buttonDownload").visible = false;
				pageInst.Child("buttonControls").visible = true;
			}
			
			if (PROJECT::isGamePad)
			{
				pageInst.Child("buttonControls").visible = false;
			}
			
			UIX.AddGeneric(pageInst.Child("generic"));
			
			
			pageInst.InitTimelines();
			pageInst.gameObjects.Update();
			
			pageInst.gameObjects.AddInstance(pageInst.Child("background")).InitTitle_Background();
			pageInst.gameObjects.AddInstance(pageInst.Child("title")).InitTitle_Title();
			pageInst.gameObjects.AddInstance(pageInst.Child("image")).InitTitle_Image();

			
			if (LicDef.GetLicensor() == LicDef.LICENSOR_KIZI)
			{
				pageInst.Child("sponsorlogo").visible = false;
				KiziStuff.AddLogoAt(titleMC, 550, 165, 0.6);
			}
			
		}
		public function UIX_buttonClearDataPopupPressed(inst:UIX_Instance)
		{
//			UI.StartTransition("shop");
			UI.StartTransition("areyousure_cleardata");
		}
		
		function UIX_ButtonPickteamPressed(inst:UIX_Instance)
		{
			GameVars.currentPickTeam = 0;
			UI.StartTransition("pickateam");
			
		}
		function UIX_buttonPlayPressed(inst:UIX_Instance)
		{
			
			GameVars.gameMode = 0;
			
			GameVars.firstTime = false;

			if (GameVars.firstTime)
			{
				GameVars.firstTime = false;
				UI_MovieScreen.pageToShow = 0;
				UI.StartTransition("moviescreen");	
			}
			else
			{
				
				LicCoolmath.PlayButtonPressed();
				UI.StartTransition("matchselect");
			}
		}
		
		
		function UIX_ButtonFacebookPressed2(inst:UIX_Instance)
		{
//			MobileSpecific.Facebook1();
		}
		function UIX_ButtonFacebookPressed1(inst:UIX_Instance)
		{
//			MobileSpecific.PostTwitter();
		}
		function UIX_ButtonFacebookPressed(inst:UIX_Instance)
		{
//			MobileSpecific.Facebook();
		}
		function UIX_buttonCreditsPressed(inst:UIX_Instance)
		{
//						MobileSpecific.IAP_MakePurchase("ad_free");

			UI.StartTransition("credits");
		}
		function UIX_buttonShopPressed(inst:UIX_Instance)
		{
			UI.StartTransition("shop");
		}
		
		
		function UIX_buttonControlsPressed(inst:UIX_Instance)
		{
			UI.StartTransition("controls");
		}
		function UIX_buttonRunExplorerPressed(inst:UIX_Instance)
		{
			UI.StartTransition("runexplorer");
		}
		
		
		function UIX_buttonRestorePurchasesPressed(inst:UIX_Instance)
		{
			MobileSpecific.IAP_RestorePurchases();
		}
		
		
		
		public override function InitScreen()
		{
			InitScreenUIX();
		}
		
		
		
	}

}