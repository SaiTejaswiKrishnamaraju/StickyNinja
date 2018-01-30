package UIPackage
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_AreYouSure_ClearData extends UIScreenInstance
	{
		
		public function UI_AreYouSure_ClearData() 
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
			uix_pageName = "page_clearsave_areyousure";
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("buttonYes"), UIX_buttonYesPressed);			
			UIX.AddAnimatedButton(pageInst.Child("buttonNo"), UIX_buttonNoPressed);			
			
		}
		
		public function UIX_buttonYesPressed(inst:UIX_Instance)
		{
			Game.ResetEverything();
			SaveData.Save();
			UI.StartTransition("title");			
		}
		public function UIX_buttonNoPressed(inst:UIX_Instance)
		{
			UI.StartTransition("title");			
		}

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------

		public override function InitScreen()
		{
			InitScreenUIX();
			return;
			
			UI.StartAddButtons();
			titleMC = new screen_clearSave();
			UI.AddAnimatedMCButton(titleMC.btn_yes, buttonOKPressed);
			UI.AddAnimatedMCButton(titleMC.btn_no, buttonCancelPressed);	
			
			TextStrings.ReplaceTextFieldText(titleMC.textTitle);
			
			
		}
		public function buttonOKPressed(e:MouseEvent)
		{
			Game.ResetEverything();
			SaveData.Save();
			UI.StartTransition("title");			
		}
		public function buttonCancelPressed(e:MouseEvent)
		{
			UI.StartTransition("title");			
		}
		
	}

}