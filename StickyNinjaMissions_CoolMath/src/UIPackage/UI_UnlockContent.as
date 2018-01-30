package UIPackage
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import LicPackage.AdMediator;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_UnlockContent extends UIScreenInstance
	{
		
		public function UI_UnlockContent() 
		{
			
		}
		
		public static var global_content_index:int = 0;
		public static var global_text1:String = "";
		public static var global_text2:String = "";
		public static var global_result:Boolean = false;
		
		public override function ExitScreen()
		{
			UIX.StopPage(titleMC, pageInst);
		}
		
		public override function InitScreen()
		{
			titleMC = new MovieClip();
			uix_pageName = "page_unlockcontent";
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("buttonOK"), UIX_buttonYesPressed);			
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), UIX_buttonNoPressed);			
			UIX.SetHardwareBackButton(pageInst.Child("btn_back"));
			
			pageInst.InitTimelines();
			
			
			var inst:UIX_Instance = pageInst.Child("icon");
			inst.frame = global_content_index;
			var lock:UIX_Instance = inst.Child("lock");
			lock.visible = true;			

//			pageInst.Child("text1").SetText(global_text1);
//			pageInst.Child("text2").SetText(global_text2);
			
			adAvailable = false;
			
			Test();
		}
		
		var adAvailable:Boolean;
		
		public function Test()
		{
			adAvailable = AdMediator.TestRewardAdAvailable();
			
			var text_status:UIX_Instance = pageInst.Child("text_status");
			if (adAvailable === false)
			{
				text_status.SetText("Video unavailable, try again later...");
			}
			else
			{
				text_status.SetText("");
			}
		}
		public function UIX_buttonYesPressed(inst:UIX_Instance)
		{
			if (Game.usedebug)
			{
				RewardAdCB(true, "Unlocked");
				global_result = true;
				return;
			}
			
			
			global_result = true;
			
			//GameVars.gameMode = "";
			//UI.StartTransition("levelselect");
			
			
			AdMediator.ShowRewardAd(RewardAdCB);
		}
		
		public function RewardAdCB(done:Boolean,s:String)
		{
//			pageInst.Child("text_watchVideo").SetText(s+" "+done);
			if (done == true)
			{
				trace("rewarded ad " + done);
				ContentUnlocked(global_content_index);
			}
			else
			{
				trace("rewarded ad failed");
			}
		}
		
		function ContentUnlocked(contentIndex:int)
		{
			var inst:UIX_Instance = pageInst.Child("icon");
			var lock:UIX_Instance = inst.Child("lock");
			lock.visible = false;			
			
			pageInst.Child("buttonOK").visible = false;
			pageInst.Child("text_watchVideo").SetText("Thank you, the content is now unlocked!");
			
			var text_status:UIX_Instance = pageInst.Child("text_status");
			text_status.SetText("");
			
			GameVars.UnlockGenericContent(contentIndex);
			SaveData.Save();
		}
		
		
		public function UIX_buttonNoPressed(inst:UIX_Instance)
		{
			global_result = false;
			UI.StartTransition(UI.returnScreenName);	
		}

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------

		
	}

}