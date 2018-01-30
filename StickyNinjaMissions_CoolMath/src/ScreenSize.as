package  
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import LicPackage.Lic;
	import LicPackage.LicDef;
	/**
	 * ...
	 * @author 
	 */
	public class ScreenSize 
	{
		
		public function ScreenSize() 
		{
			
		}
		
		public static var gameStageWidth:Number;
		public static var gameStageHeight:Number;
		public static var fullScreenScale:Number;
		public static var fullScreenScaleXOffset:Number;
		public static var fullScreenScaleYOffset:Number;
		public static var fullScreenBlankArea:Number;
		
		public static var visibleW:Number;
		public static var visibleH:Number;
		
		public static function GetHudXScale():Number
		{
			if (PROJECT::isMobile == false) return 1;
			return 0.9;	// (gameStageWidth / Defs.displayarea_w);
		}
		public static function GetHudYScale():Number
		{
			if (PROJECT::isMobile == false) return 1;
			return 1;	// (gameStageHeight / Defs.displayarea_h);
		}
		public static function GetHudXOffset():Number
		{
			if (PROJECT::isMobile == false) return 0;
			return 0;	// (Defs.displayarea_w - gameStageWidth) / 2;
		}
		public static function GetHudYOffset():Number
		{
			if (PROJECT::isMobile == false) return 0;
			return 15;	// ((Defs.displayarea_h - gameStageHeight) / 2);	// * (1 / GetHudYScale());
		}
		
			
		public static function XtoUnit(x:Number):Number
		{
			return ScaleTo(0, 1, 0, gameStageWidth, x);
		}
		public static function YtoUnit(y:Number):Number
		{
			return ScaleTo(0, 1, 0, gameStageHeight, y);
		}
		public static function ScaleMovieClip(mc:MovieClip)			
		{
			if (PROJECT::isMobile)
			{
				mc.scaleX = fullScreenScale;
				mc.scaleY = fullScreenScale;
				mc.x += fullScreenScaleXOffset;
				mc.y += fullScreenScaleYOffset;
			}
			
		}
		public static function Calculate(stage:Stage)			
		{
			var stageFullScreenWidth:int;
			var stageFullScreenHeight:int;
			
			stageFullScreenWidth = stage.fullScreenWidth;
			stageFullScreenHeight = stage.fullScreenHeight;
			
		  // scale to make the entire screen fit on
		  // so there is nothing offscreen
			
			
			if (stageFullScreenWidth > stageFullScreenHeight)
			   {
				  gameStageWidth = stageFullScreenWidth;
				  gameStageHeight = stageFullScreenHeight;
			   }
			   else
			   {
				  gameStageWidth = stageFullScreenHeight;
				  gameStageHeight = stageFullScreenWidth;
			   }
			   
			   var sc0:Number = gameStageWidth / Defs.displayarea_w;
			   var sc1:Number = gameStageHeight / Defs.displayarea_h;
			   
			   fullScreenScale = sc0;
			   if (sc1 < sc0) fullScreenScale = sc1;
			   
			   
			   fullScreenScaleXOffset = (stageFullScreenWidth - (Defs.displayarea_w * fullScreenScale))/2;
			   fullScreenScaleYOffset = (stageFullScreenHeight - (Defs.displayarea_h * fullScreenScale))/2;
			   
			   visibleW = Defs.displayarea_w * fullScreenScale;
			   visibleH = Defs.displayarea_h * fullScreenScale;

//			   visibleW = stage.fullScreenWidth;
//			   visibleH = stage.fullScreenHeight;
//			   fullScreenScaleXOffset = 0;
//			   fullScreenBlankArea = 0;
			   
			  //Utils.print("********************** "+stage.fullScreenWidth +" " + stage.fullScreenHeight + " " + fullScreenScale);
			  //Utils.print("********************** " + a +" " +b);
			  //Utils.print("********************** " + Defs.displayarea_w +" " +Defs.displayarea_h);
			  //Utils.print("************************xoffset " + fullScreenScaleXOffset);
			  //Utils.print("************************leftover W " + fullScreenBlankArea);
			
		}
			
		public static function ScaleTo(f0:Number, f1:Number,o0:Number,o1:Number,val:Number):Number
		{
			var od:Number = o1 - o0;
			var fd:Number = f1 - f0;
			
			var d:Number = 1.0 / od * (val-o0);
			d = (fd * d) + f0;
			
			return d;			
		}
		
		public static function GetScaledMousePosX(val:Number):Number
		{
			val = Utils.ScaleToPreLimit(0, Defs.displayarea_w, fullScreenScaleXOffset, gameStageWidth - fullScreenScaleXOffset, val);
			return val;			
		}
		public static function GetScaledMousePosY(val:Number):Number
		{
			val = Utils.ScaleToPreLimit(0, Defs.displayarea_h, fullScreenScaleYOffset, gameStageHeight - fullScreenScaleYOffset, val);
			return val;
		}
		
	}

}