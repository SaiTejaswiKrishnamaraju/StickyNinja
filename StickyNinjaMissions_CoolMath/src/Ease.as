package  
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class Ease
	{
		
		public function Ease() 
		{
			
		}

		static function DebugOut(s:String)
		{
			Utils.print(s);
		}
		
		public static function GetStringNameList():String
		{
			return "linear,power_in,power_out,power_inout,spring_in,spring_out,spring_inout";
		}
		
		public static const EASE_LINEAR:String = "linear";
		public static const EASE_POWER_IN:String = "power_in";
		public static const EASE_POWER_OUT:String = "power_out";
		public static const EASE_POWER_INOUT:String = "power_inout";
		public static const EASE_SPRING_IN:String = "spring_in";
		public static const EASE_SPRING_OUT:String = "spring_out";
		public static const EASE_SPRING_INOUT:String = "spring_inout";
		public static const EASE_BOUNCE_IN:String = "bounce_in";
		
		public static function EaseByName(name:String, time:Number, value:Number)
		{
			if (name == "linear") return Linear(time);
			if (name == "power_in") return Power_In(time,value);
			if (name == "power_out") return Power_Out(time,value);
			if (name == "power_inout") return Power_InOut(time,value);
			if (name == "spring_in") return Spring_In(time);
			if (name == "spring_out") return Spring_Out(time);
			if (name == "spring_inout") return Spring_InOut(time);
			if (name == "bounce_in") return Bounce_In(time,value);
			return time;
		}
		
		
		static var bounce_table:Vector.<Number> = null;
		public static function Bounce_In(time:Number, value):Number
		{
			if (bounce_table == null)
			{
				bounce_table = new Vector.<Number>();
				var y:Number = 0;
				var yv:Number = 0.1;
				var grav:Number = 0.01;
				var bounce:Number = -0.3;
				var minv:Number = 0.1;
				var doit:Boolean = true;
				bounce_table.push(y);
				do
				{
					y += yv;
					yv += grav;
					if (y >= 1) 
					{
						y = 1;
						if (yv <= minv)
						{
							doit = false;
						}
						yv *= bounce;						
					}
					bounce_table.push(y);
					
				}while (doit == true);
			}
			
			if (time == 1)
			{
				var aaa:int = 0;
			}
			
			var pos:int = Utils.ScaleTo(0, bounce_table.length, 0, 1, time);
			if (pos < 0) pos = 0;
			if (pos >= bounce_table.length) pos = bounce_table.length - 1;
			return bounce_table[pos];
		}
		public static function Linear(time:Number):Number
		{
			return time;
		}
		
		public static function Spring_Out(time:Number):Number
		{
			return easeOut(time, 0, 1, 1);
		}
		public static function Spring_In(time:Number):Number
		{
			return easeIn(time, 0, 1, 1);
		}
		public static function Spring_InOut(time:Number):Number
		{
			return easeInOut(time, 0, 1, 1);
		}
		
		
		private static const _2PI:Number = Math.PI * 2;
		
		public static function easeIn (t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number;
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) { a=c; s = p/4; }
			else s = p/_2PI * Math.asin (c/a);
			return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )) + b;
		}
		public static function easeOut (t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number;
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) { a=c; s = p/4; }
			else s = p/_2PI * Math.asin (c/a);
			return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*_2PI/p ) + c + b);
		}
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number;
			if (t==0) return b;  if ((t/=d*0.5)==2) return b+c;  if (!p) p=d*(.3*1.5);
			if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) { a=c; s = p/4; }
			else s = p/_2PI * Math.asin (c/a);
			if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )) + b;
			return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )*.5 + c + b;
		}
		
		/*
		
		public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d) < (1/2.75)) {
				return c*(7.5625*t*t) + b;
			} else if (t < (2/2.75)) {
				return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
			} else if (t < (2.5/2.75)) {
				return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
			} else {
				return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
			}
		}
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return c - easeOut(d-t, 0, c, d) + b;
		}
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d*0.5) return easeIn (t*2, 0, c, d) * .5 + b;
			else return easeOut (t*2-d, 0, c, d) * .5 + c*.5 + b;
		}		
		*/
		
		
		public static function Power_In(time:Number,power:Number=2):Number
		{
			var v:Number = time;
			for (var i:int = 0; i < power-1; i++)
			{
				v *= time;
			}
			//DebugOut(time + "     " + v);
			return v;
		}		
		public static function Power_Out(time:Number,power:Number=2):Number
		{
			var t:Number = 1 - time;
			var v:Number = t;
			for (var i:int = 0; i < power-1; i++)
			{
				v *= t;
			}
			v = 1 - v;
			return v;
		}		

		public static function Power_InOut(time:Number,power:Number=2):Number
		{
			if (time < 0.5)
			{
				return Power_In(time * 2, power)*0.5;
			}
			return 0.5 + (Power_Out( (time - 0.5) * 2, power) * 0.5);
		}		
		
		
		
		public static function Render(bd:BitmapData, fn:Function, x:int, y:int, w:int = 45, h:Number = 45)
		{
			bd.fillRect(new Rectangle(x, y, w, h), 0xff000000);
			for (var t:Number = 0; t <= 1; t += 0.01)
			{
				var v:Number = fn(t);
				var rx:Number = x + (w * t);
				var ry:Number = (y+h) - (h * v);
				bd.setPixel32(rx, ry, 0xffffffff);
			}
		}
		
	}

}