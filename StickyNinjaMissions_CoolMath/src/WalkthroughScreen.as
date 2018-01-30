package  
{
	import com.adobe.images.PNGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class WalkthroughScreen 
	{
		public var screenBD:BitmapData;
		public var thumbBD:BitmapData;
		public var screenB:Bitmap;
		public var thumbB:Bitmap;
		
		public function WalkthroughScreen() 
		{
			var ratio:Number = Defs.displayarea_h / Defs.displayarea_w;
			SetScreenSize(Defs.displayarea_w, Defs.displayarea_h);
			
			var thumbW:Number = 60;
			
			SetThumbSize(thumbW,thumbW*ratio);
		}
		
		var screenW:int;
		var screenH:int;
		public var thumbW:int;
		public var thumbH:int;
		
		function SetScreenSize(w:int, h:int)
		{
			screenW = w;
			screenH = h;
		}
		function SetThumbSize(w:int, h:int)
		{
			thumbW = w;
			thumbH = h;
		}
		
		var titleMC:MovieClip;
		public function InitPlayback(_titleMC:MovieClip)
		{
			Game.gameState = Game.gameState_Walkthrough;
			Game.StartLevel(true);
			titleMC = _titleMC;
			//titleMC.screenHolder.addChild(screenB);					
			titleMC.addChild(screenB);					
			titleMC.setChildIndex(screenB, 0);
			titleMC.addEventListener(Event.ENTER_FRAME, OnEnterFrame);			
		}

		function OnEnterFrame(e:Event)
		{
			UpdatePlayback();
		}
		
		public function UpdatePlayback()
		{
			Game.gameState = Game.gameState_Walkthrough;
			Game.UpdateGameplay();
			Game.Render(screenBD);
		}
		
		public function StopPlayback()
		{
			titleMC.removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
//			titleMC.removeChild(screenB);								
			//titleMC.screenHolder.removeChild(screenB);								
			
		}
		
		public function MakeScreen(level:int)
		{
			Levels.currentIndex = level;
			var l:Level = Levels.GetCurrent();
			
			/*
			
			Game.StartLevel(true);
			
			Game.gameState = Game.gameState_Play;
			Game.UpdateGameplay();
			var bd:BitmapData = Game.main.screenBD;
			bd.fillRect(Defs.screenRect, 0);
			Game.Render(bd);
			Game.gameState = Game.gameState_UI;
			
			
			
			var m:Matrix = new Matrix();
			
			var scale:Number;
			
			scale = screenW/Defs.displayarea_w;
			screenBD = new BitmapData(screenW, screenH);
			m.identity();
			m.scale(scale, scale);
			screenBD.draw(bd, m, null, null, null, true);
			screenB = new Bitmap(screenBD);
			
			scale = thumbW/Defs.displayarea_w;
			thumbBD = new BitmapData(thumbW, thumbH);
			m.identity();
			m.scale(scale, scale);
			thumbBD.draw(bd, m, null, null, null, true);
			
			thumbB = new Bitmap(thumbBD);
			*/

			screenBD = new BitmapData(screenW, screenH);
			screenB = new Bitmap(screenBD);
			
		}
		
	}

}