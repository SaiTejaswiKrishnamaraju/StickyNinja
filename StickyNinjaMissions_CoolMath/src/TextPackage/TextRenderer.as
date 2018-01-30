package TextPackage 
{
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class TextRenderer 
	{

		static var font_scaler:Number = 1;
		static var space_space:int = 12;
		
		public function TextRenderer() 
		{
			
		}
		
		
		public static function InitOnce()
		{

		}
		
		public static var xspacing_offset:int = 0;
		public static var y_offset:int = -10;
		
		public static const JUSTIFY_LEFT:int = 0;
		public static const JUSTIFY_CENTRE:int = 1;
		public static const JUSTIFY_RIGHT:int = 2;
		
		public static var stringCharX:Number;
		public static var stringCharY:Number;
		public static var stringCharBitmapData:BitmapData;
		static var m:Matrix = new Matrix();
		static var p:Point = new Point(0, 0);
		static var p1:Point = new Point(0, 0);
		
		static function TransformPointInPlace(m:Matrix, p0:Point, p1:Point)
		{
			var x0:Number = (m.a * p0.x) + (m.c * p0.y);
			var y0:Number = (m.b * p0.x) + (m.d * p0.y);
			p1.x = x0;
			p1.y = y0;
		}
		
		
		public static function RenderAt(fontIndex:int,screenBD:BitmapData,x:Number, y:Number, str:String,dir:Number=0,scale:Number=1,justify:int=JUSTIFY_CENTRE,ct:ColorTransform = null,_firstChar:int=0,_lastChar:int=-1)
		{
			if (Game.use_localisation)
			{
				str = TextStrings.GetLocalisedText(str);
			}
			
			scale *= font_scaler;
			
			y += y_offset * scale;
			
			var bf:BitmapFont = BitmapFonts.fontList[fontIndex];
 			var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName(bf.fontName);

			m.identity();
			m.rotate(dir);
			m.scale(scale, scale);
			
			var width:Number = GetStringWidth(fontIndex,str,dir,scale,justify);
			if (justify == JUSTIFY_LEFT)
			{
				
			}
			else if (justify == JUSTIFY_CENTRE)
			{
				p.x = -(width / 2);
				p.y = 0;
				TransformPointInPlace(m, p, p1);
				//p = m.transformPoint(p);
				x += p1.x;
				y += p1.y;
			}
			else if (justify == JUSTIFY_RIGHT)
			{
				p.x = -(width);
				p.y = 0;
				TransformPointInPlace(m, p, p1);
				//p = m.transformPoint(p);
				x += p1.x;
				y += p1.y;
				
			}
			
			
			stringCharX = x;
			stringCharY = y;
			var i:int;
			
			var lastChar:int = str.length-1;		// last char is inclusive
			if (_lastChar != -1)
			{
				lastChar = _lastChar;
			}
			if (lastChar > str.length - 1) lastChar = str.length - 1;
			
			
			for (i = 0; i <= lastChar; i++)
			{
				var a:int = int(str.charCodeAt(i));
				if (a < 0) a = 0;
				if (a > 255)
				{
					Utils.print("missing char code " + a);
					a = 32;
				}
				
				var ox:Number = 0;
				var oy:Number = 0;
				var spacing:Number;
				var bfc:BitmapFontChar = bf.GetCharById(a);
				if (bfc != null)
				{
					ox = bfc.offsetX * scale;
					oy = bfc.offsetY * scale;
					spacing = bfc.advanceX + (xspacing_offset * scale);
					
				}
				
				if (i >= _firstChar)
				{
				
					if (false)	//scale == 1 && dir == 0 && ct == null)
					{
						dobj.RenderAt(a, screenBD, int(stringCharX+ox), int(stringCharY+oy) );
					}
					else
					{
						dobj.RenderAtRotScaled(a, screenBD, stringCharX, stringCharY+oy, scale, dir, ct,true);
					//	dobj.RenderAtRotScaled(a, screenBD, Math.round(stringCharX+ox), Math.round(stringCharY+oy), scale, dir, ct,true);
						//dobj.RenderAtRotScaledQuality(a, screenBD, int(stringCharX+ox), int(stringCharY+oy), scale, dir, ct,true,StageQuality.HIGH);
					}
				}
					
				if (a == 32)
				{
					p.x = space_space;
				}
				else
				{
					p.x = spacing;
				}
				p.y = 0;
				TransformPointInPlace(m, p, p1);
				//p = m.transformPoint(p);
				
				stringCharX += p1.x;
				stringCharY += p1.y;
			
				
				
			}
		}

		
		public static function GetStringWidth(fontIndex:int,str:String,dir:Number=0,scale:Number=1,justify:int=JUSTIFY_CENTRE):Number
		{
			return GetStringDimensions(fontIndex,str,dir,scale,justify).width;
		}
		
		public static function GetStringHeight(fontIndex:int,str:String):int
		{
			return GetStringDimensions(fontIndex,str).height;
		}
		public static function GetStringDimensions(fontIndex:int,str:String,dir:Number=0,scale:Number=1,justify:int=JUSTIFY_CENTRE):Rectangle
		{
			
			
			var r:Rectangle = new Rectangle(0, 0, 1, 1);
			
			
			if (Game.use_localisation)
			{
				str = TextStrings.GetLocalisedText(str);
			}
			
			
			var bf:BitmapFont = BitmapFonts.fontList[fontIndex];
 			var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName(bf.fontName);
			
			var x:Number = 0;
			var y:Number = 0;
			
			
			stringCharX = x;
			stringCharY = y;
			var i:int;
			for (i = 0; i < str.length; i++)
			{
				var a:int = int(str.charCodeAt(i));
				if (a < 0) a = 0;
				if (a > 255)
				{
					Utils.print("missing char code " + a);
					a = 32;
				}
				
				var ox:Number = 0;
				var oy:Number = 0;
				var spacing:Number;
				var bfc:BitmapFontChar = bf.GetCharById(a);
				if (bfc != null)
				{
					ox = bfc.offsetX;
					oy = bfc.offsetY;
					spacing = bfc.advanceX + (xspacing_offset * scale);
					
				}
				if (a == 32)
				{
					p.x = space_space;
				}
				else
				{
					p.x = spacing;
				}
				
				stringCharX += p.x;
				stringCharY += p.y;
				
			}
			r.width = stringCharX;
			r.height = 20;
			return r;
		}
		
		
		
	}

}