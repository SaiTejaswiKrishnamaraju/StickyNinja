package UIPackage 
{
	import AchievementPackage.Leaderboards;
	import AudioPackage.Audio;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import LicPackage.Lic;
	import PlayerRecordPackage.PlayerRecording;
	import PlayerRecordPackage.PlayerRecordings;
	import TextPackage.TextRenderer;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_HighScores extends UIScreenInstance
	{
		
		public function UI_HighScores() 
		{
			
		}

		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			
			titleMC = new MovieClip();
			uix_pageName = "page_highscores";
			pageInst = UIX.StartPage(titleMC, uix_pageName);
						
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), buttonBackPressed);	
			
			pageInst.Child("bg").renderFunction = RenderBGWithScores;

			scores = null;
			Leaderboards.GetTopScores(GetTopScoresCB);

		}
		
		var scores:Object;
		
		function GetTopScoresCB(o:Object)
		{
			scores = o;
		}
		function RenderBGWithScores(_inst:UIX_Instance,_frame:int, screenBD:BitmapData, m:Matrix3D,ct:ColorTransform)
		{
			// render parent
			_inst.component.dobj.RenderAtMatrix3D(_inst.component.frame-1 + _frame, screenBD, m, ct);
			
			if (scores == null) return;

			var num:int = scores.length;
			if (num == 0) return;
			if (num > 20) num = 20;
			
			var x:Number = 400;
			var y:Number = 50;
			
			for (var i:int = 0; i < num; i++)
			{
				
				var s:String = Utils.GetCardinalString(i)+": "+scores[i].Score.score;
				
				TextRenderer.RenderAt(0,screenBD, x, y, s);
				
				y += 25;
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

		
		function buttonBackPressed(inst:UIX_Instance):void
		{
			UI.StartTransition("title");
		}
		
	}

}