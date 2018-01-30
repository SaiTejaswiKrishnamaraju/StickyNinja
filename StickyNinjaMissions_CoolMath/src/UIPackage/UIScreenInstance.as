package UIPackage
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UIScreenInstance
	{
		public var template:UIScreen;
		var active:Boolean;
		var titleMC:MovieClip;
		var onTransitionCompleteFunction:Function = null;		
		public var pageInst:UIX_PageInstance;
		public var uix_pageName:String;

		
		
		public function UIScreenInstance() 
		{
			
		}
		
		public function GetMC():MovieClip
		{
			return titleMC;
		}
		
		public function Restart()
		{
			UI.StartTransition(template.name);
		}
		public function Start()
		{
			onTransitionCompleteFunction = null;
			Mouse.cursor = MouseCursor.AUTO;
			
			InitScreen();
		}
		public function Stop()
		{
			ExitScreen();
		}		
		
		public function OnComplete()
		{
			if (onTransitionCompleteFunction != null)
			{
				onTransitionCompleteFunction();
			}
		}
		
		public function RenderForTransition(renderBD:BitmapData):void
		{
			renderBD.draw(titleMC);
		}
		
		
		public function InitScreen()
		{
			
		}
		public function ExitScreen()
		{
			
		}

		
//----------------------------------------------------------------------------------------------------------------

		
//----------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------
		
	}

}