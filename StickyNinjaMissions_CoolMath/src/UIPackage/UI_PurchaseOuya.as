package UIPackage
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import MobileSpecificPackage.MobileSpecific;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_PurchaseOuya extends UIScreenInstance
	{
		
		public function UI_PurchaseOuya() 
		{
			
		}
		
		public override function ExitScreen()
		{
			UIX.StopPage(titleMC, pageInst);
		}
		
		public override function InitScreen()
		{
			titleMC = new MovieClip();
			uix_pageName = "page_purchase_ouya";
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("buttonYes"), UIX_buttonYesPressed);			
			UIX.AddAnimatedButton(pageInst.Child("buttonNo"), UIX_buttonNoPressed);			
			
			
		}
		
		public function UIX_buttonYesPressed(inst:UIX_Instance)
		{
			trace("getProductInfo");
			if (PROJECT::isGamePad)
			{
				MobileSpecific.Ouya_PurchaseCallback = PurchaseSuccessful;
				MobileSpecific.ouyaIap.getProductInfo( "grandtruckismo_full" );
				pageInst.Child("buttonYes").visible = false;
				pageInst.dPadCurrent = pageInst.Child("buttonNo")
			}
		

		}
		
		public function PurchaseSuccessful()
		{
			if (PROJECT::isGamePad)
			{

				MobileSpecific.Ouya_PurchaseCallback = null;
				GameVars.nextScreenName = "shop";
				UI.StartTransition(GameVars.nextScreenName);						
			}
		}
		
		public function UIX_buttonNoPressed(inst:UIX_Instance)
		{
			UI.StartTransition("title");			
		}

	}

}