package UIPackage  
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import AudioPackage.Audio;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import LicPackage.Lic;
	import LicPackage.Tracking;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_LanguageSelect extends UIScreenInstance
	{
		
		public function UI_LanguageSelect() 
		{
			
		}

		public override function ExitScreen()
		{
			UIX.StopPage(titleMC, pageInst);
		}
		
		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			titleMC = new MovieClip();
			uix_pageName = "page_language";
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), UIX_buttonBackPressed);			
			
			pageInst.Child("textTitle").SetText("languages");
			
			TextStrings.ReplaceInstText(pageInst.Child("textTitle"));
			
			AddFlags();
			UpdateFlags();
			
		}
		
		function UIX_buttonBackPressed(inst:UIX_Instance)
		{		
			UI.StartTransition("title");
		}
		
		
		public override function InitScreen()
		{
			InitScreenUIX();
			return;
		}
		
		function GetFlagFrameFromName(name:String):int
		{
			var i:int = 1;
			for each(var s:String in availableFlags)
			{
				if (s == name) return i;
				i++;
			}
			return 1;
		}
		
		var availableFlags:Array = new Array(
			"en",
			"es",
			"de",
			"fr",
			"nl",
			"pt",
			"tr", 
			"se",
			"it"
			);
		
		// english: 1
		// spanish: 2
		// german: 3
		// french
		// dutch 5
		// portuguese 6
		
		
		var flagMCs:Array;
		
		function UpdateFlags()
		{
			for each(var inst:UIX_Instance in flagMCs)
			{
				if (inst.userData.languageID == TextStrings.currentLanguage)
				{
//					mc.selected.visible = true;
				}
				else
				{
//					mc.selected.visible = false;
				}
			}
		}
		
		function AddFlags()
		{
			flagMCs = new Array();
			var supported:Array = TextStrings.supportedLanguages;

			var ox:int = 50;
			var x:Number = ox;
			var y:Number = 100;
			var xp:int = 0;
			for each(var languageID:int in supported)
			{
				var inst:UIX_Instance = pageInst.Child("flag" + int(languageID + 1));
				inst.userData.languageID = languageID;
				inst.frame = GetFlagFrameFromName(TextStrings.languageLabels[languageID]);
				trace("set frame " + inst.frame);
				UIX.AddAnimatedButton(inst, flagClicked);
				flagMCs.push(inst);
				
			}	
		}
		
		function flagClicked(inst:UIX_Instance)
		{
			TextStrings.currentLanguage = inst.userData.languageID;

			
			UpdateFlags();
			
			TextStrings.ReplaceInstText(pageInst.Child("textTitle"),"languages");
			SaveData.Save();			
//			UI.StartTransition("title");
			
			
		}
		
		
		
	}


}