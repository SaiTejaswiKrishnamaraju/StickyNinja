package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.StaticText;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	* ...
	* @author Default
	*/
	public class Utils 
	{
		
		public function Utils() 
		{
		}
		
		
		public static function RectangleFromCoords(x0:Number, y0:Number, x1:Number, y1:Number):Rectangle
		{
			var a:Number;
			if (x1 < x0)
			{
				a = x0;
				x0 = x1;
				x1 = a;
			}
			if (y1 < y0)
			{
				a = y0;
				y0 = y1;
				y1 = a;
			}
			var r:Rectangle = new Rectangle(x0, y0, (x1 - x0) + 1, (y1 - y0) + 1);
			return r;
		}
		
		public static function MoveNumberAtoB(orig:Number, to:Number, vel:Number):Number
		{
			if (orig < to)
			{
				orig += vel;
				if (orig > to) orig = to;
			}
			else
			{
				orig -= vel;
				if (orig < to) orig = to;
			}
			return orig;
		}
		
		public static function CopyColorTransform(ct:ColorTransform):ColorTransform
		{
			if (ct == null) return null;
			var newct:ColorTransform = new ColorTransform();
			newct.redOffset = ct.redOffset;
			newct.greenOffset = ct.greenOffset;
			newct.blueOffset = ct.blueOffset;
			newct.alphaOffset= ct.alphaOffset;
			newct.redMultiplier= ct.redMultiplier;
			newct.greenMultiplier= ct.greenMultiplier;
			newct.blueMultiplier= ct.blueMultiplier;
			newct.alphaMultiplier = ct.alphaMultiplier;
			return newct;
		}
		
		private const FASTRANDOMTOFLOAT:Number = 1 / uint.MAX_VALUE;
		private var fastrandomseed:uint = Math.random() * uint.MAX_VALUE;
		public function fastRandom():Number
		{
			fastrandomseed ^= (fastrandomseed << 21);
			fastrandomseed ^= (fastrandomseed >>> 35);
			fastrandomseed ^= (fastrandomseed << 4);
			return (fastrandomseed * FASTRANDOMTOFLOAT);
		}		
		public static function print(str:*)
		{
			if (Game.debugPrint) trace(str);	// , TraceLevel.DEBUG);
		}
		public static function traceerror(str:String)
		{
			if (Game.debugPrintError) trace(str);	// , TraceLevel.ERROR);
		}

		public static function RandomiseArray_Seeded(a:Array,_amt:int=100):Array
		{
			for (var i:int = 0; i < _amt; i++)
			{
				var r0:int = RandBetweenInt_Seeded(0, a.length - 1);
				var r1:int = RandBetweenInt_Seeded(0, a.length - 1);
				var o:Object = a[r0];
				a[r0] = a[r1];
				a[r1] = o;
			}
			return a;
		}
		
		public static function RandomiseArray(a:Array,_amt:int=100):Array
		{
			for (var i:int = 0; i < _amt; i++)
			{
				var r0:int = RandBetweenInt(0, a.length - 1);
				var r1:int = RandBetweenInt(0, a.length - 1);
				var o:Object = a[r0];
				a[r0] = a[r1];
				a[r1] = o;
			}
			return a;
		}
		
		public static function ShuffleIntList(a:Array, amount:int = 100):Array
		{
			var len:int = a.length;
			for (var i:int = 0; i < amount; i++)
			{
				var p0:int = Utils.RandBetweenInt(0, len - 1);
				var p1:int = Utils.RandBetweenInt(0, len - 1);
				
				var x:int = a[p0];
				a[p0] = a[p1];
				a[p1] = x;				
			}
			return a;
		}
		
		public static function AddLeadingZeroes(number:int, amt:int):String
		{
			if (number < 10)
			{
				return "0" + number.toString();
			}
			return number.toString();
		}
		
		public static function RemoveWhiteSpace(s:String):String
		{
			s = s.replace(" ", "");
			return s;
		}

		
		public static function PointArrayFromString(s:String):Array
		{
			var pointArray:Array = new Array();
			
			var a:Array = s.split(",");
			
			if (a.length < 2 || (a.length%2)==1)
			{
				print("PointArrayFromString. Error, numpoints=" + a.length+" , string= "+s);
				return pointArray;
			}
			
			var i:int;
			var num:int = a.length / 2;
			for (i = 0; i < num; i++)
			{
				var p:Point = new Point(0, 0);
				p.x = Number(a[(i*2)+0]);
				p.y = Number(a[(i * 2) + 1]);
				pointArray.push(p);
			}
			
			return pointArray;
		}

		public static function HexArrayFromString(s:String):Array
		{
			var hexArray:Array = new Array();
			if (s.length == 0) return hexArray;
			
			
			var i:int;
			var num:int = s.length;
			for (i = 0; i < num; i++)
			{
				var char:int = int(s.charAt(i));
				hexArray.push(char);
			}
			
			return hexArray;
		}
		
		public static function rgbToHex(color:uint):String
		{
			// Find hex number in the RGB offset
			var colorInHex:String = color.toString(16);
			var c:String = "00000" + colorInHex;
			var e:int = c.length;
			c = c.substring(e - 6, e);
			return c.toUpperCase();
		}		
		
		
		public static function HexStringToInt(s:String):int
		{
			var h:String = "0123456789abcdef";
			s = s.toLowerCase();
			
			var multiplier:int = 1;
			var val:int = 0;
			
			for (var i:int = s.length-1; i >=0; i--)
			{
				var char:String = s.charAt(i);
				var a:int = h.indexOf(char);
				val += (a * multiplier);
				multiplier *= 16;
			}
			return val;
		}
		
		public static function HexStringToColorTransform(str:String):ColorTransform
		{
			if (str == null) return null;
			if (str == "") return null;
			
			var r:int = HexStringToInt(str.substr(0, 2));
			var g:int = HexStringToInt(str.substr(2, 2));
			var b:int = HexStringToInt(str.substr(4, 2));
			
			r = -255 + r;
			g = -255 + g;
			b = -255 + b;
			
			var ct:ColorTransform = new ColorTransform(1, 1, 1, 1, r, g, b, 0);
			return ct;
		}		
		
		public static function CounterToSecondsString(count:int):String
		{
			var s:String = "";
			
			var seconds:int = count / int(Defs.fps);
			var remainder:int = count % int(Defs.fps);
			
			s += seconds.toString() + ":";
			var r:Number = 100 / Defs.fps * Number(remainder);
			var rstring:String = Math.floor(r).toString();
			if (rstring.length == 1) rstring = rstring.concat("0");
			s += rstring;
			
			return s;
			
		}

		public static function CounterToMinutesSecondsString(count:int):String
		{
			var s:String = "";
			
			count /= Defs.fps;
			
			var seconds:int = count / int(60);
			var remainder:int = count % int(60);
			
			s += seconds.toString() + ":";
			var r:Number = Number(remainder);
			s += Math.floor(r).toString();
			
			return s;
			
		}
		
		public static var minutesString:String="";
		public static var secondsString:String="";
		public static var miliString:String = "";
		public static var fullTimeString:String = "";
		public static function CounterToMinutesSecondsMilisecondsString(count:int,returnFullString:Boolean=true):String
		{
			
			var ms:int = count % Defs.fps;
			ms = 100 * ms / Defs.fps ;
			
			count /= Defs.fps;
			
			
			
			var seconds:int = count / int(60);
			var remainder:int = count % int(60);
			
			if (remainder < 10)
			{
				secondsString = "0".concat(remainder.toString());
			}
			else
			{
				secondsString = remainder.toString();
			}

			minutesString = seconds.toString();

			if (ms < 10)
			{
				miliString = "0".concat(ms.toString());
			}
			else
			{
				miliString = ms.toString();
			}
			
			if (returnFullString)
			{
				fullTimeString = "";
				fullTimeString+=(minutesString);
				fullTimeString+=(".");
				fullTimeString+=(secondsString);
				fullTimeString+=(":");
				fullTimeString += (miliString);
			}

			return fullTimeString;
			
		}

		public static function AddIntAndLoop(f0:int, f1:int, n:int, adder:int):Number
		{
			n += adder;
			var d:int = (f1 - f0)+1;
			if (n > f1) n -=d;
			if (n < f0) n +=d;
			return n;
		}
		public static function LimitNumber(f0:Number, f1:Number,n:Number):Number
		{
			if (n < f0) n = f0;
			if (n > f1) n = f1;			
			return n;			
		}

		public static function LoopNumber(f0:Number, f1:Number,n:Number):Number
		{
			var diff:int = (f1 - f0) + 1;
			if (n < f0) n += diff;
			if (n > f1) n -= diff;			
			return n;			
		}
		
		
		public static function ScaleToAndLimit(f0:Number, f1:Number, o0:Number, o1:Number, val:Number):Number
		{
			var od:Number = o1 - o0;
			var fd:Number = f1 - f0;
			
			var d:Number = 1.0 / od * (val-o0);
			d = (fd * d) + f0;

			if (d < f0) d = f0;
			if (d > f1) d = f1;			
			
			return d;			
		}

		public static function ScaleToPreLimit(f0:Number, f1:Number, o0:Number, o1:Number, val:Number):Number
		{
			if (val < o0) val = o0;
			if (val > o1) val = o1;			
			
			var od:Number = o1 - o0;
			var fd:Number = f1 - f0;
			
			var d:Number = 1.0 / od * (val-o0);
			d = (fd * d) + f0;
			return d;			
		}
		
		public static function ScaleTo(f0:Number, f1:Number,o0:Number,o1:Number,val:Number):Number
		{
			var od:Number = o1 - o0;
			var fd:Number = f1 - f0;
			
			var d:Number = 1.0 / od * (val-o0);
			d = (fd * d) + f0;
			
			return d;			
		}
		public static function ScaleBetween(f0:Number, f1:Number,scale:Number):Number
		{
			var d:Number = (f1 - f0) * scale;
			d = f0 + d;
			return d;			
		}

		public static function LineLength(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			var dx:Number = x1 - x0;
			var dy:Number = y1 - y0;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public static function NumberToString2DP(n:Number):String
		{
			var aa:String = DP2(n).toString();
			var index:int = aa.lastIndexOf(".");
			if (index == -1)
			{
				aa = aa.concat(".00");
			}
			else
			{
				var len:int = aa.length;
				if (index == len - 1)
				{
					aa = aa.concat("0");
				}
			}
			return aa;
		}
		
				// two decimal places:
		public static function DP2(val:Number):Number
		{
			var n:Number = Math.ceil(val * 100.0) / 100.0;
			return n;
		}
		public static function DP1(val:Number):Number
		{
			var n:Number = Math.ceil(val * 10.0) / 10.0;
			return n;
		}
		
		
		public static function RandSetSeed(_seed:int)
		{
			SeededRandom.SetSeed(_seed);
		}
		public static function RandBetweenFloat_Seeded(r0:Number,r1:Number):Number
		{
			var r:Number = SeededRandom.GetNumber() * (r1 - r0);
			r += r0;
			return r;
		}
		public static function RandBetweenInt_Seeded(r0:int,r1:int):int
		{
			var r:int = SeededRandom.GetNumber()* ((r1-r0)+1);
			r += r0;
			return r;
		}
		

		public static function RandBetweenFloat(r0:Number,r1:Number):Number
		{
			var r:Number = Math.random() * (r1-r0);
			r += r0;
			return r;
		}
		public static function RandBetweenInt(r0:int,r1:int):int
		{
			var r:int = Math.random() * ((r1-r0)+1);
			r += r0;
			return r;
		}
		public static function RandBool():Boolean
		{
			return (RandBetweenInt(0, 99) < 50);
		}
		
		public static function DotProduct(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			// dot product
			// ax*bx + ay*by
			var dot:Number = (x0 * x1) + (y0 * y1);
			return dot;
		}

		
		public static function CrossProductAng(r0:Number,r1:Number):Number
		{
			var x0:Number = Math.cos(r0);
			var y0:Number = Math.sin(r0);
			var x1:Number = Math.cos(r1);
			var y1:Number = Math.sin(r1);
			return CrossProduct(x0,y0,x1,y1);
		}
		
		public static function CrossProduct(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			// dot product
			// ax*bx + ay*by
			var cross:Number = (x0 * y1) - (x1 * y0);
			return cross;
		}
		
		
		public static function SideOfLine(lx0:Number, ly0:Number, lx1:Number, ly1:Number, x:Number, y:Number):Boolean
		{
			var cross:Number = CrossProduct( lx1 - lx0, ly1 - ly0, x - lx0, y - ly0);
			if (cross < 0.0) return false;
			return true;
		}		

		
		
		public static function DotProductAng(r0:Number,r1:Number):Number
		{
			var x0:Number = Math.cos(r0);
			var y0:Number = Math.sin(r0);
			var x1:Number = Math.cos(r1);
			var y1:Number = Math.sin(r1);
			// dot product
			// ax*bx + ay*by
			var dot:Number = (x0 * x1) + (y0 * y1);
			return dot;
		}

		public static function RandCirclePosition(radius:Number):Point
		{
			var r:Number = Math.random() * (Math.PI * 2);
			var dx:Number = Math.cos(r) * Utils.RandBetweenFloat(0, radius);
			var dy:Number = Math.sin(r) * Utils.RandBetweenFloat(0, radius);
			var p:Point = new Point(dx, dy);
			return p;
		}
		
		
		public static function RandCircle():Number
		{
			return Math.random() * (Math.PI * 2);
		}

		public static function RadToDeg(rad:Number):Number
		{
			return 360.0 / (Math.PI * 2) * rad;
		}

		public static function DegToRad(deg:Number):Number
		{
			return (Math.PI * 2) / 360.0 * deg;
		}
		
		
		public static function RenderDotLine(bd:BitmapData,x0:Number, y0:Number, x1:Number, y1:Number,numP:int,col:uint):void
		{
			if (PROJECT::useStage3D) return;
			var i:int;
			var maxP:int = numP;
			var dx:Number = (x1 - x0) / Number(maxP);
			var dy:Number = (y1 - y0) / Number(maxP);
			bd.setPixel32(int(x0), int(y0), col);
			var ox:Number = x0;
			var oy:Number = y0;
			for (i = 0; i < maxP; i++)
			{
				x0 += dx;
				y0 += dy;
				bd.setPixel32(int(x0), int(y0), col);
			}
		}
		
		public static function RenderRectangle(bd:BitmapData,r:Rectangle,col:uint):void
		{
			if (PROJECT::useStage3D) return;
			RenderDotLine(bd, r.left, r.top, r.right, r.top, 100, col);
			RenderDotLine(bd, r.left, r.bottom, r.right, r.bottom, 100, col);
			RenderDotLine(bd, r.left, r.top, r.left, r.bottom, 100, col);
			RenderDotLine(bd, r.right, r.top, r.right, r.bottom, 100, col);
		}
		
		public static function RenderCircle(bd:BitmapData, x:Number, y:Number, rad:Number, col:uint):void
		{
			if (PROJECT::useStage3D) return;
			var numP:int = 50;
			var dx:Number = Math.PI * 2 / numP;
			var i:int;
			var ang:Number = 0;
			for (i = 0; i < numP; i++)
			{
				var xp:Number = x + (Math.cos(ang) * rad);
				var yp:Number = y + (Math.sin(ang) * rad);
				ang += dx;
				bd.setPixel32(int(xp), int(yp), col);
			}			
		}

		public static function DistBetweenPoints(x0:Number,y0:Number,x1:Number,y1:Number):Number
		{
			var dx:Number = x1-x0;
			var dy:Number = y1 - y0;
			return Math.sqrt( (dx * dx) + (dy * dy) );
		}

		public static function GetLength(dx:Number, dy:Number):Number
		{
			return ( (dx * dx) + (dy * dy) );			
		}
		public static function Dist2BetweenPoints(x0:Number,y0:Number,x1:Number,y1:Number):Number
		{
			var dx:Number = x1-x0;
			var dy:Number = y1 - y0;
			return ( (dx * dx) + (dy * dy) );
		}

		//-------------------------------------------------------------------
		
		public static function NormalizeRot(rot:Number):Number
		{
			while (rot < 0)
			{
				rot += Math.PI * 2;
			}
			while (rot > Math.PI*2)
			{
				rot -= Math.PI * 2;
			}
			return rot;
		}

		public static function NormalizeRot180(rot:Number):Number
		{
			while (rot < -Math.PI)
			{
				rot += Math.PI * 2;
			}
			while (rot > Math.PI)
			{
				rot -= Math.PI * 2;
			}
			return rot;
		}
		
		
		//-------------------------------------------------------------------
		
		
		public static var paramNames:Array;
		public static var paramValues:Array;
		public static var paramDictionary:Dictionary;

		public static function PrintParams():void
		{
			for (var i:int = 0; i < paramNames.length; i++)
			{
				var s:String = paramNames[i] + " " + paramValues[i];
				print(s);
			}
		}
		
		public static function CloneParamDictionary():Dictionary 
		{
			var cloned:Dictionary = new Dictionary();
			for(var key:Object in paramDictionary) {
				cloned[key] = paramDictionary[key];
			}
			return cloned;
		}		
		
		public static function GetParams1(params:String):void
		{
			paramDictionary = new Dictionary();
			
			if (params == null) return;
			if (params == "") return;
			
			var a:Array = new Array();
			
			var lastIndex:int = 0;
			for (var i:int = 0; i < params.length; i++)
			{
				var c:String = params.charAt(i);
				if (c == "=")			// pair
				{
					a.push(params.substr(lastIndex, i - lastIndex));
					i++;
					if (params.charAt(i) == ",")
					{
						a.push(true);
					}
					lastIndex = i;
					// copy value
				}
				if (c == "," )			// separated
				{
					a.push(params.substr(lastIndex, i - lastIndex));
					i++;
					lastIndex = i;
					// copy data
				}
			}
			a.push(params.substr(lastIndex, i - lastIndex));
			
			var len:int = a.length;
			
			for (var i:int = 0; i < a.length; i += 2)
			{
				paramDictionary[a[i]] = a[i + 1];
			}
			
			
		}
		
		
		public static function GetParams(params:String):void
		{
			paramDictionary = new Dictionary();
			
			if (params == null) return;
			if (params == "") return;
			
			
			var ss:Array = params.split(",");
			{
				for each(var s:String in ss)
				{
					var sss:Array = s.split("=");
					
					if (sss.length == 1)
					{
						paramDictionary[sss[0]] = true;
					}
					else
					{
						paramDictionary[sss[0]] = sss[1];
					}
					sss = null;
				}			
			}
			ss = null;
			// old style (non dict)
			
			paramNames = new Array();
			paramValues = new Array();
			
			
			if (params.substring(params.length - 1,params.length) == ",")
			{
				params = params.slice(0,params.length - 1);
			}
			
			//params = Utils.RemoveWhiteSpace(params);
			//params = params.toLowerCase();
			
			var ss:Array = params.split(",");
			for each(var s:String in ss)
			{
				var sss:Array = s.split("=");
				paramNames.push(sss[0]);
				paramValues.push(sss[1]);
			}	
			ss = null;

			
			
		}

		public static function GetParamExists(name:String):Boolean
		{
			var s:String = paramDictionary[name];
			if (s == null) return false;
			return true;
			/*
			var i:int = paramNames.indexOf(name);
			if (i != -1)
			{
				return true
			}
			return false;
			*/
		}
		public static function GetParamExistsDict(dictionary:Dictionary,name:String):Boolean
		{
			var s:String = dictionary[name];
			if (s == null) return false;
			return true;
		}
		
		
		public static function GetParam(name:String,_default:String=""):String
		{
			var s:String = paramDictionary[name];
			if (s == null) return _default;
			return s;
			
			/*
			var i:int = paramNames.indexOf(name);
			if (i != -1)
			{
				return paramValues[i];
			}
			return _default;
			*/
		}
		public static function GetParamString(name:String,_default:String=""):String
		{
			var s:String = paramDictionary[name];
			if (s == null) return _default;
			return s;
			/*
			var i:int = paramNames.indexOf(name);
			if (i != -1)
			{
				return paramValues[i];
			}
			return _default;
			*/
		}
		public static function GetParamNumber(name:String,_default:Number =0):Number
		{
			var s:String = paramDictionary[name];
			if (s == null) return _default;
			return Number(s);
			/*
			var i:int = paramNames.indexOf(name);
			if (i != -1)
			{
				return Number(paramValues[i]);
			}
			return _default;
			*/
		}
		public static function GetParamNumberDict(dictionary:Dictionary,name:String,_default:Number =0):Number
		{
			var s:String = dictionary[name];
			if (s == null) return _default;
			return Number(s);
		}
		
		public static function GetParamInt(name:String,_default:int =0):int
		{
			var s:String = paramDictionary[name];
			if (s == null) return _default;
			return int(s);
			/*
			var i:int = paramNames.indexOf(name);
			if (i != -1)
			{
				return int(paramValues[i]);
			}
			return _default;
			*/
		}
		public static function GetParamIntDict(dictionary:Dictionary,name:String,_default:int =0):int
		{
			var s:String = dictionary[name];
			if (s == null) return _default;
			return int(s);
		}
		public static function GetParamBool(name:String,_default:Boolean = false):Boolean
		{
			var s:String = paramDictionary[name];
			if (s == null) return _default;
			if (s == "true") return true;
			return false;
			/*
			var i:int = paramNames.indexOf(name);
			if (i != -1)
			{
				var s:String = paramValues[i];
				if (s == "true") return true;
				return false;
			}
			return _default;
			*/
		}
		
		public static function ChangeParam(name:String, value:String)
		{
			/*
			var i:int = paramNames.indexOf(name);
			if (i != -1)
			{
				paramValues[i] = value;
			}			
			*/
		}

		public static function MakeParamString():String
		{
			/*
			var s:String = "";
			for (var i:int = 0; i < paramNames.length; i++)
			{
				s += paramNames[i];
				s += "=";
				s += paramValues[i];
				if (i != paramNames.length - 1)
				{
					s += ",";
				}
			}
			
			return s;
			*/
			return "";
		}

		public static function qsort(arr:Vector.<Number>, l:int, r:int):void
		{
			var i:int, j:int, k:int, vi:int, v:Number;
		 
			if ((r - l) > 4) 
			{
				i = (r + l) >> 1;
				if ( arr[l] > arr[i] ) 
				{
					vi = arr[l];
					arr[l] = arr[i];
					arr[i] = vi;
				}
		 
				if ( arr[l] > arr[r] ) 
				{
					vi = arr[l];
					arr[l] = arr[r];
					arr[r] = vi;
				}
		 
				if ( arr[l] > arr[r] ) 
				{
					vi = arr[i];
					arr[i] = arr[r];
					arr[r] = vi;
				}
		 
				j = (r - 1);
		 
				vi = arr[i];
				arr[i] = arr[j];
				arr[j] = vi;
		 
				i = l;
				v = arr[j];
		 
				while (true) 
				{
					while ( arr[++i] < v);
					while ( arr[--j] > v);
		 
					if (j < i) break;
		 
					vi = arr[i];
					arr[i] = arr[j];
					arr[j] = vi;
				}
		 
				vi = arr[i];
				arr[i] = arr[ (k = (r - 1)) ];
				arr[k] = vi;
		 
				qsort(arr, l, j);
				qsort(arr, (i + 1), r);
			}
		}
		
		// zero based.
		public static function GetCardinalString(number:int):String
		{
			return int(number + 1) + GetPlacePostfixString(number);
		}
		public static function GetPlacePostfixString(place:int):String
		{
			var a:Array = new Array(
				"st", "nd", "rd", "th");
			
			if (place < 0) place = 0;
			if (place >= a.length) place = a.length - 1;
			return a[place];
		}

		public static function bsearch(array:Array,searchValue:*,sortOption:uint = 16):*
		{
			var tempArray:Array = array; //use a temporary array for sorting
			if (sortOption != 0) //a sort option of 0 will assume the array is already sorted
				tempArray = tempArray.sort(sortOption); //else it will sort by the given sort option (explained below)
			
			var b:int = 0;//bottom search index
			var t:int = tempArray.length-1;//top search index
			
			while (b <= t)//as long as the indexes have not crossed
			{
				var index:uint = (b+t)/2//search the middle of the indexes
				
				if (tempArray[index] == searchValue)//have you found the value?
				{
					if (sortOption != 0)//the value was found! If the array was presorted it will return the index, otherwise it will just return true
						return true;
					else
						return index;
				}
				else if (tempArray[index] < searchValue)//if the value checked is lower than the search term, it will check the higher portion
				{
					b = index+1;
				}
				else//otherwise it will check the lower portion
				{
					t = index-1;
				}
			}
			
			if (sortOption != 0)//if the item is never found it will return false or -1 (depending on whether or not the array was already sorted
				return false;
			else
				return -1;
		}		
		
		
		public static function RemoveMovieClipEntirely(parentMC:MovieClip)
		{
			if (parentMC == null) return;
			if ( parentMC.numChildren == 0) 
			{
				parentMC.stop();
				parentMC = null;
				return;
			}
			
			var i:int;
			for (i = parentMC.numChildren - 1; i >= 0; i--) 
			{
				if (parentMC.getChildAt(i) is MovieClip)
				{					
					var mc:MovieClip = parentMC.getChildAt(i) as MovieClip;		
					RemoveMovieClipEntirely(mc);
					parentMC.removeChildAt(i);
					mc = null;
				}
				else if( parentMC.getChildAt(i) is Shape)
				{
					var sh:Shape = parentMC.getChildAt(i) as Shape;		
					parentMC.removeChildAt(i);
					
					sh = null;
				}
				else if( parentMC.getChildAt(i) is Bitmap)
				{
					var a:int = 0;
//					sh = null;
				}
				else if( parentMC.getChildAt(i) is StaticText)
				{
					var st:StaticText = parentMC.getChildAt(i) as StaticText;		
					st = null;
				}
				else if( parentMC.getChildAt(i) is SimpleButton)
				{
					var sb:SimpleButton = parentMC.getChildAt(i) as SimpleButton;	
					sb = null;
				}
				else if( parentMC.getChildAt(i) is TextField)
				{
					var tf:TextField = parentMC.getChildAt(i) as TextField;	
					tf = null;
				}
				else
				{
					var d:DisplayObject = parentMC.getChildAt(i)
					var a:int = 0;
				}
			}
			parentMC = null;
		} 

		public static function CacheAsBitmapRecursive(parentMC:MovieClip,_cacheAsBitmap:Boolean)
		{
			parentMC.cacheAsBitmap = _cacheAsBitmap;
			if ( parentMC.numChildren == 0) return;
			
			var i:int;
			for (i = parentMC.numChildren - 1; i >= 0; i--) 
			{
				if (parentMC.getChildAt(i) is MovieClip)
				{					
					var mc:MovieClip = parentMC.getChildAt(i) as MovieClip;		
					CacheAsBitmapRecursive(mc, _cacheAsBitmap );
				}
				else
				{
					 parentMC.getChildAt(i).cacheAsBitmap = _cacheAsBitmap;
					 Utils.print("child is " + typeof(parentMC.getChildAt(i)));
				}
			}
		} 
		
		
		public static function NearestSuperiorPow2(i:int):int
		{
			var a:int = 2;
			for (var x:int = 0; x < 12; x++)
			{
				if (i <= a) 
				{
					//a /= 8;
					//if (a < 2) a = 2;
			
					return a;
				}
				a *= 2;
			}
			
			//a /= 8;
			//if (a < 2) a = 2;
			return a;
		}

		// only for uniform scaled matrices, of course
		public static function GetScaleFromMatrix(origm:Matrix):Number
		{
			var m:Matrix = origm.clone();
			m.tx = 0;
			m.ty = 0;
			var p:Point = new Point();
			p.x = 1.0;
			p.y = 0.0;
			p = m.transformPoint(p);
			var scale:Number = p.length;
			return scale;
		}
		public static function GetRotFromMatrix(origm:Matrix):Number
		{
			var m:Matrix = origm.clone();
			m.tx = 0;
			m.ty = 0;
			var p:Point = new Point();
			p.x = 1.0;
			p.y = 0.0;
			p = m.transformPoint(p);
			var rot:Number = Math.atan2(p.y, p.x);
			return rot;
		}
		
		public static function Matrix3DToMatrix(m3d:Matrix3D):Matrix
		{
			var m:Matrix = new Matrix();
			
			var raw:Vector.<Number> = m3d.rawData;
			
			m.a = raw[0];
			m.b = raw[1];
			m.c = raw[4];
			m.d = raw[5];
			m.tx = m3d.position.x;
			m.ty = m3d.position.y;
			return m;
		}
		
		public static function Matrix3DTransformRectangle(m:Matrix3D,r:Rectangle):Rectangle
		{
			var p0:Vector3D = new Vector3D(r.x, r.y);
			var p1:Vector3D = new Vector3D(r.right, r.bottom);
			p0 = m.transformVector(p0);
			p1 = m.transformVector(p1);
			var r1:Rectangle = new Rectangle();
			r1.x = p0.x;
			r1.y = p0.y;			
			r1.right = p1.x;
			r1.bottom = p1.y;	
			return r1;
		}

		public static function Matrix3DTransformPoint(m:Matrix3D,p:Point):Point
		{
			var p0:Vector3D = new Vector3D(p.x, p.y);
			p0 = m.transformVector(p0);
			var p1:Point = new Point(p0.x, p0.y);
			return p1;
		}
		
		public static function GetFlashVersion():Array
		{
			// get & split information arrays
			var _fullInfo:String = Capabilities.version;
			var _osSplitArr:Array = _fullInfo.split(' ');
			var _versionSplitArr:Array = _osSplitArr[1].split(',');
			 
			// declare the relevant infos
			var _osInfo:String = _osSplitArr[0];
			var _versionInfo:Number = _versionSplitArr[0];
			var _versionInfo1:Number = _versionSplitArr[1];
			 
			
			return _versionSplitArr;
			
		}
		
		
		static const minFlashVersionMajor:Number = 11;
		static const minFlashVersionMinor:Number = 3;
		public static function GetFlash11_3()
		{		
			var versionArray:Array = GetFlashVersion();
			trace("flash version " + versionArray[0] + "." + versionArray[1]);

			Game.is_11_3 = false;
			if (versionArray[0] >= minFlashVersionMajor)
			{
				if (versionArray[1] >= minFlashVersionMinor)
				{
					Game.is_11_3 = true;
				}
			}
		}
		
		public static function DrawBD (destBD:BitmapData,source:IBitmapDrawable, matrix:Matrix=null, colorTransform:ColorTransform=null, blendMode:String=null, clipRect:Rectangle=null, smoothing:Boolean=false, quality:String=null) : void
		{
			if (PROJECT::useStage3D)
			{
				destBD.drawWithQuality(source, matrix, colorTransform, blendMode, clipRect, smoothing, quality);
				return;
			}			
			
			if (Game.is_11_3)
			{
				destBD.drawWithQuality(source , matrix, colorTransform, blendMode, clipRect, smoothing, quality);			
			}
			else
			{
				destBD.draw(source , matrix, colorTransform, blendMode, clipRect, smoothing);	
			}
			
		}		
		
		
		static var mnumbers:Vector.<Number> = new Vector.<Number>(16);
		
		public static function deltaTransformVector3DInPlace(m:Matrix3D, v:Vector3D)
		{
			/*
			m.copyRawDataTo(mnumbers);

			var n11:Number = mnumbers[0];
			var n12:Number = mnumbers[1];
			var n13:Number = mnumbers[2];
			var n14:Number = mnumbers[3];
			var n21:Number = mnumbers[4];
			var n22:Number = mnumbers[5];
			var n23:Number = mnumbers[6];
			var n24:Number = mnumbers[7];
			var n31:Number = mnumbers[8];
			var n32:Number = mnumbers[9];
			var n33:Number = mnumbers[10];
			var n34:Number = mnumbers[11];
			var n41:Number = mnumbers[12];
			var n42:Number = mnumbers[13];
			var n43:Number = mnumbers[14];
			var n44:Number = mnumbers[15];
			
			var x : Number = v.x;
			var y : Number = v.y;
			var z : Number = v.z;
			var w : Number = v.w;
			v.x = n11 * x + n12 * y + n13 * z + n14 * w;
			v.y = n21 * x + n22 * y + n23 * z + n24 * w;
			v.z = n31 * x + n32 * y + n33 * z + n34 * w;
			v.w = n41 * x + n42 * y + n43 * z + n44 * w;
			*/
			
			v = m.deltaTransformVector(v);			
		}
		
		public static function RotatePoint(p:Point, dir:Number):Point		
		{
			var s:Number = Math.sin(dir);
			var c:Number = Math.cos(dir);
			var x:Number = (p.x * c) - (p.y * s);
			var y:Number = (p.x * s) + (p.y * c);
			p.x = x;
			p.y = y;
			return p;
		}
		
	}
	
}