package UIPackage
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_Purchase extends UIScreenInstance
	{
		
		public function UI_Purchase() 
		{
			
		}
		
		public override function ExitScreen()
		{
			UIX.StopPage(titleMC, pageInst);
		}
		
		public override function InitScreen()
		{
			titleMC = new MovieClip();
//			uix_pageName = "page_purchase_ouya";
			uix_pageName = "page_purchase_mobile";
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), buttonBackPressed);	
			
			
//			UIX.AddAnimatedButton(pageInst.Child("buttonYes"), UIX_buttonYesPressed);			
//			UIX.AddAnimatedButton(pageInst.Child("buttonNo"), UIX_buttonNoPressed);			
			
//			pageInst.Child("text1").SetText(MobileSpecific.ouyaState);
//			pageInst.Child("text2").SetText(MobileSpecific.ouyaState1);
			
		}
		
		function buttonBackPressed(inst:UIX_Instance):void
		{
			UI.StartTransition(UI.nextScreenName);
		}
		
		
		public function UIX_buttonYesPressed(inst:UIX_Instance)
		{
			trace("getProductInfo");
		}
		public function UIX_buttonNoPressed(inst:UIX_Instance)
		{
			UI.StartTransition("title");			
		}

	}

}