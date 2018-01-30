package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Default
	*/
	public class Poly 
	{
		public static const polytype_PATH = 0;
		public static const polytype_WALL = 1;
		public static const polytype_TRIGGER = 2;
		public static const polytype_ZONE = 3;
		public static const polytype_OVERLAY = 4;
		public static const polytype_FLOOR = 5;
		public static const polytype_CEILING = 6;

		var boundingRectangle:Rectangle;
		var active:Boolean;
		var type:int;
		var name:String;		
		var lineList:Array;
		var pointList:Array;
		var hitCallback:Object;
		var param0:String;
		var param1:String;
		var iparam0:int;
		var typeName:String;
		var subTypeName:String;
		var closed:Boolean;
		
		
		public static function FindAllByType(type:int, polyList:Array):Array
		{
			var list:Array = new Array();
			for each (var poly:Poly in polyList)
			{
				if (poly.type == type)
				{
					list.push(poly);
				}
			}
			return list;
		}

		
		public static function FindByName(name:String, polyList:Array):Poly
		{
			for each (var poly:Poly in polyList)
			{
				if (poly.name == name)
				{
					return poly;
				}
			}
			return null;
		}
		public static function FindIndexByName(name:String, polyList:Array):int
		{
			var index:int = 0;
			for each (var poly:Poly in polyList)
			{
				if (poly.name == name)
				{
					return index;
				}
				index++;
			}
			return -1;
		}
		
		public function Poly(_name:String,_type:int,x:Number,y:Number):void
		{			
			lineList = new Array();
			active = true;
			type = _type;
			name = _name;
			boundingRectangle = null;
			hitCallback = null;
			closed = false;
			pointList = new Array();
			pointList.push(new Point(x, y));
		}
		
		
		public function AddLine(x0:Number, y0:Number, x1:Number, y1:Number):void
		{
			var l:Line = new Line(x0,y0,x1,y1);
			lineList.push(l);
			
			pointList.push(new Point(x1, y1));

			if (boundingRectangle == null)
			{
				boundingRectangle = l.boundingRect;
			}
			else
			{
				var r:Rectangle = boundingRectangle.clone();
				boundingRectangle = r.union(l.boundingRect);				
			}
		}
		
		public function Finish(close:Boolean)
		{
			if (close)
			{
				var l0:Line = lineList[0];
				var l1:Line = lineList[lineList.length-1];
				var l:Line = new Line(l1.x1,l1.y1,l0.x0,l0.y0);
				lineList.push(l);				
				var r:Rectangle = boundingRectangle.clone();
				boundingRectangle = r.union(l.boundingRect);				
			}
			closed = close;
		}
		
		public function OffsetFromStartPoint()
		{
			var offx = -pointList[0].x;
			var offy = -pointList[0].y;
			
			var i:int;
			for (i = 0; i < pointList.length; i++)
			{
				pointList[i].x += offx;
				pointList[i].y += offy;
			}
			
			for (i = 0; i < lineList.length; i++)
			{
				var l:Line = lineList[i];
				l.x0 += offx;
				l.x1 += offx;
				l.y0 += offy;
				l.y1 += offy;
			}			
		}
		
		
		public static function MakeSplineFromPointList(pts:Array):Poly
		{
			var p:Point;
			var p1:Point;
			p = pts[0];
			
			var poly:Poly = new Poly("", 0, p.x, p.y);
			var len:int = pts.length;
			var i:int;
			
			for (i = 0; i < len - 1; i++)
			{
				p = pts[i];
				p1 = pts[i+1];
				poly.AddLine(p.x, p.y, p1.x, p1.y);
			}
			poly.Finish(false);
			poly.CalculateCatmullRomLength();
			return poly;
			
		}
		
		var catmullRomLength:Number;
		public function CalculateCatmullRomLength()
		{
			var l:Array = new Array();
			var i:int;
			
			var np:int = GetNumPoints();
			if (np < 4) 
			{
				catmullRomLength = 0;
			}
			else
			{
			
				var t1:Number;
				for (t1 = 0; t1 < 1.0; t1 += 0.025)
				{
					var pp:Point = GetPointOnCatmullRom(t1);
					l.push(pp);
				}
			}
			
			catmullRomLength = 0.0; 
			for (i = 0; i < l.length - 2; i++)
			{
				var p0:Point = l[i];
				var p1:Point = l[i+1];
				catmullRomLength += Utils.DistBetweenPoints(p0.x, p0.y, p1.x, p1.y);
			}
			
//			trace("Curve Length: " + catmullRomLength);
			l = null;
		}
		
		
		function PointOnCurve(t:Number, p0:Point, p1:Point, p2:Point, p3:Point):Point
		{
			var out:Point = new Point();
			var t2:Number = t * t;
			var t3:Number = t2 * t;
			out.x = 0.5 * ( ( 2.0 * p1.x ) +
			( -p0.x + p2.x ) * t +
			( 2.0 * p0.x - 5.0 * p1.x + 4 * p2.x - p3.x ) * t2 +
			( -p0.x + 3.0 * p1.x - 3.0 * p2.x + p3.x ) * t3 );
			out.y = 0.5 * ( ( 2.0 * p1.y ) +
			( -p0.y + p2.y ) * t +
			( 2.0 * p0.y - 5.0 * p1.y + 4 * p2.y - p3.y ) * t2 +
			( -p0.y + 3.0 * p1.y - 3.0 * p2.y + p3.y ) * t3 );
			return out;
		}
		
		public function GetPointOnCatmullRom(t:Number):Point
		{
			var np:int = GetNumPoints();
			if (np < 4) return new Point(0, 0);
			var numSegs:int = np - 1;

			var p0:Point;
			var p1:Point;
			var p2:Point;
			var p3:Point;
			// calc segment:
			var seg:Number = Number(numSegs) * t;
			var i:int = seg;
			
			
			var pt0:int = i - 1;
			var pt1:int = i;
			var pt2:int = i + 1;
			var pt3:int = i + 2;
			if (pt0 < 0) pt0 = 0;
			if (pt2 > np - 1) pt2 = np - 1;
			if (pt3 > np - 1) pt3 = np - 1;
			
			p0 = pointList[pt0];
			p1 = pointList[pt1];
			p2 = pointList[pt2];
			p3 = pointList[pt3];

			var i1:int = i + 1;
			var s0:Number = 1.0 / Number(numSegs) * i;
			var s1:Number = 1.0 / Number(numSegs) * i1;
			var t1:Number = 1.0 / (s1 - s0) * (t - s0);
			var p:Point = PointOnCurve(t1, p0, p1, p2, p3);

//			trace(t + " " + i + " " + t1);

			return p;
			
		}
		
		public function DrawCatmullRom(bd:BitmapData, col:uint,xoff:Number,yoff:Number)
		{
			var np:int = GetNumPoints();
			if (np < 4) return;
			
			var t1:Number;
			for (t1 = 0; t1 < 1.0; t1 += 0.001)
			{
				var pp:Point = GetPointOnCatmullRom(t1);
				bd.setPixel32(pp.x+xoff, pp.y+yoff, col);

			}
		}
		
		
		public function GetNumPoints():int
		{
			return pointList.length;
//			return lineList.length-1;
		}
		public function GetNumLines():int
		{
			return lineList.length;
		}
		public function GetLine(index:int):Line
		{
			return lineList[index];
		}
		public function GetCatmullRomLength():Number
		{
			return catmullRomLength;
		}
		
		public function GetPoint(index:int):Point
		{
			return new Point(pointList[index].x, pointList[index].y);
		}
		public function GetPointNormal(index:int):Point
		{
			return new Point(lineList[index].nx, lineList[index].ny);
		}
	}
	
}