package  
{
	import EditorPackage.ObjParameters;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PhysLine 
	{
		public var index:int;
		public var id:String;
		public var type:int;
		public var points:Array;
		public var fill:int;
		public var fillScaleX:Number;
		public var fillScaleY:Number;
		public var centrex:Number;
		public var centrey:Number;
		public var fixed:Boolean;
		public var primitiveType:String;
		public var objParameters:ObjParameters;

		public static const PRIMITIVE_LINE:String = "line";
		public static const PRIMITIVE_RECTANGLE:String = "rectangle";
		public static const PRIMITIVE_CIRCLE:String = "circle";
		
		public function PhysLine() 
		{
			id = "";
			type = 0;
			points = new Array();
			fill = 0;
			fillScaleX = 1;
			fillScaleY = 1;
			fixed = true;
			objParameters = new ObjParameters();
			
			primitiveType = PRIMITIVE_LINE;
			
			
			centrex = 0;
			centrey = 0;

		}
		
		public function AddPoint(x:Number, y:Number)
		{
			points.push(new Point(x, y));
		}
		
		public function SetPointArray(a:Array)
		{
			points = a;
		}
		
		public function Clone():PhysLine
		{
			var l:PhysLine = new PhysLine();
			l.id = id;
			l.type = type;
			l.fill = fill;
			l.fillScaleX = fillScaleX;
			l.fillScaleY = fillScaleY;
			l.centrex = centrex;
			l.centrey = centrey;
			l.fixed = fixed;
			for each( var p:Point in points)
			{
				l.points.push(p.clone());
			}
			l.objParameters = objParameters.Clone();
			l.primitiveType = primitiveType;
			return l;
		}
		
//------------------------------------------------------------------------
		public function GetPoint(index:int):Point
		{
			return points[index];
		}
//------------------------------------------------------------------------

		var boundingRectangle:Rectangle;
		function CalcBoundingRectangle()
		{
			var p:Point;
			p = points[0];
			boundingRectangle = new Rectangle(p.x, p.y, 1, 1);

			for each(p in points)
			{
				inflateRectByPoint(boundingRectangle, p);
			}
		}
		public static function inflateRectByPoint(r:Rectangle, p:Point):void
		{ 
			var d:Number; 
			d = p.x - r.x; 
			if (d < 0) 
			{  
				r.x += d;
				r.width  -= d;
			} 
			else if (d > r.width) 
			{  
				r.width = d;
			} 
			d = p.y - r.y; 
			if (d < 0) 
			{  
				r.y += d;  
				r.height -= d; 
			}
			else if (d > r.height)
			{  
				r.height = d; 
			}
		}

		public function PointInPoly(x:Number, y:Number):Boolean
		{
			var numIntersections:int = 0;
			
			if (points.length == 2)
			{
				return PointOnLine(x, y, 2);
			}
			
			CalcBoundingRectangle();
			if (boundingRectangle.contains(x, y) == false) return false;
			
			var count:int = points.length;
			var i:int;
			for (i = 0; i < count; i++)
			{
				var j:int = i + 1;
				if (j >= count) j = 0;
				var p0:Point = points[i];
				var p1:Point = points[j];
				var x0:int = p0.x;
				var y0:int = p0.y;				
				var x1:int = p1.x;
				var y1:int = p1.y;
				
				if (y1 < y0)
				{
					x0 = p1.x;
					y0 = p1.y;				
					x1 = p0.x;
					y1 = p0.y;					
				}
				
				if (y >= y0 && y <= y1)
				{
					var dy:Number = y1 - y0;
					var dx:Number = x1 - x0;
					
					var y2:Number = (y - y0) / dy ;
					var x2:Number = x0 + (dx * y2);
					
					//Utils.trace(x2 + "    " + y2 + "           " + dx + "  " + dy);
					
					if (x < x2)
					{
						numIntersections++;
					}
				}
			}
			if ( (numIntersections & 1) != 0) return true;
			return false;
		}

		public function PointOnLine(x:Number, y:Number, dist:Number = 1 ):Boolean
		{
			var i:int;
			var a0:Array = points;
			var numPoints:int = points.length;
			for (i = 0; i < numPoints; i++)
			{
				var j:int = i + 1;
				if (j >= numPoints) j = 0;
				var p0:Point = a0[i];
				var p1:Point = a0[j];
				
				var t:Number = Collision.ClosestPointOnLine(p0.x, p0.y, p1.x, p1.y, x, y);
				if (t >= 0.0 && t <= 1)
				{
					if (Utils.DistBetweenPoints(x, y, Collision.closestX, Collision.closestY) < dist)
					{
						return true;
					}
				}
			}
			return false;
		}
		

		public function PointInConvexPoly(x:Number, y:Number):Boolean
		{
			var count:int = points.length;
			var i:int;
			for (i = 0; i < count; i++)
			{
				var j:int = i + 1;
				if (j >= count) j = 0;
				var p0:Point = points[i];
				var p1:Point = points[j];
				
				var l0:Point = new Point(p1.x - p0.x, p1.y - p0.y);
				var l1:Point = new Point(p1.x - x, p1.y - y);
				
				var dot:Number = Utils.DotProduct(l0.x, l0.y, l1.x, l1.y);
				if (dot < 0)
				{
					return false;
				}				
			}
			return true;
		}


//------------------------------------------------------------------------

		var catmullRomLength:Number;
		var segmentLengths:Array;
		var segmentRatios:Array;
		public function CalculateLength(loop:Boolean = false):Number
		{
			segmentLengths = null;
			segmentRatios = null;
			var l:Number = 0;
			var np:int = GetNumPoints();
			var numPoints:int = np;
			if (np <= 1) return 0;
			
			if (loop == false) np--;
			
			segmentLengths = new Array();
			segmentRatios = new Array();
			for (var i:int = 0; i < np; i++)
			{
				var j:int = i + 1;
				if (j >= numPoints) j = 0;
				
				var l1:Number = Utils.DistBetweenPoints(points[i].x, points[i].y, points[j].x, points[j].y);
				l += l1;
				segmentLengths.push(l1);
			}
			
			for each(var sl:Number in segmentLengths)
			{
				var r:Number = 1 / l * sl;
				segmentRatios.push(r);
				
			}

			/* output
			var rr:Number = 0;
			for (var i:int = 0; i < segmentLengths.length; i++)
			{
				sl = segmentLengths[i];
				r = segmentRatios[i];
				rr += r;
				Utils.trace("len: " + sl + "   ratio: " + r);
			}
			Utils.trace("total: " + rr);
			*/
			
			return l;
		}
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
					var pp:Point = GetPointOnCatmullRom(t1,true);
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

		public function PointOnCurve(t:Number, p0:Point, p1:Point, p2:Point, p3:Point):Point
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
		
		public function GetPointOnCatmullRom(t:Number,loop:Boolean):Point
		{
			var np:int = GetNumPoints();
			if (np < 4) return new Point(0, 0);
			var numSegs:int = np;

			var p0:Point;
			var p1:Point;
			var p2:Point;
			var p3:Point;
			// calc segment:
			var seg:Number = Number(numSegs) * t;
			if (seg >= numSegs) seg = numSegs - 1;
			var i:int = seg;
			
			var pt0:int;
			var pt1:int;
			var pt2:int;
			var pt3:int;
			
			
			if (loop)
			{
				pt0 = Utils.AddIntAndLoop(0, np - 1, i, -1);
				pt1 = i;
				pt2 = Utils.AddIntAndLoop(0, np - 1, i, 1);
				pt3 = Utils.AddIntAndLoop(0, np - 1, i, 2);
			}
			else
			{
				pt0 = i - 1;
				pt1 = i;
				pt2 = i + 1;
				pt3 = i + 2;
				if (pt0 < 0) pt0 = 0;
				if (pt2 > np - 1) pt2 = np - 1;
				if (pt3 > np - 1) pt3 = np - 1;
			}

			
			p0 = points[pt0];
			p1 = points[pt1];
			p2 = points[pt2];
			p3 = points[pt3];

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
				var pp:Point = GetPointOnCatmullRom(t1,true);
				bd.setPixel32(pp.x+xoff, pp.y+yoff, col);

			}
		}
		
		public function GetNumPoints():int
		{
			return points.length;
//			return lineList.length-1;
		}		
		
		
//-----------------------------------------------------------------------------------------------------------		
		
		// pos = number 0-1
		// logical distance between points is equal
		public function GetInterpolatedPoint1(pos:Number,loop:Boolean):Point
		{
			CalculateLength(loop);
//		var segmentLengths:Array;
//		var segmentRatios:Array;
			
			var numPoints:int = points.length;
			if (loop) numPoints++;
			var numSegs:int = numPoints - 1;
			
			var rr:Number = 0;
			for (var i:int = 0; i < numSegs; i++)
			{
				var j:int = i + 1;
				if (j >= points.length) j = 0;
				
				var r:Number = segmentRatios[i];
				var rr1:Number = rr + r;
				if (pos >= rr && pos <= rr1)
				{
					var q:Number = Utils.ScaleTo(0, 1, rr, rr1, pos);
					var x:Number = Utils.ScaleTo(points[i].x, points[j].x, 0,1, q);
					var y:Number = Utils.ScaleTo(points[i].y, points[j].y, 0,1, q);
					var p:Point = new Point(x, y);
					return p;

				}
				rr += r;
			}
			return new Point(0, 0);
			
		}
		public function GetInterpolatedPoint(pos:Number,loop:Boolean,isSpline:Boolean=false):Point
		{
			if (isSpline)	//type == 2)
			{
				return GetPointOnCatmullRom(pos,loop);
			}
			
			
			if (loop == true)
			{
				var numPoints:int = points.length;
				
				var nodelen:Number = 1.0 / numPoints;
				
				
				var pi0:int = Math.floor(numPoints * pos);
				var pi1:int = (pi0 + 1) % numPoints;
				
				var pos0:Number = pi0 * nodelen;
				var pos1:Number = (pi0+1) * nodelen;
				
				var x:Number = Utils.ScaleTo(points[pi0].x, points[pi1].x, pos0, pos1, pos);
				var y:Number = Utils.ScaleTo(points[pi0].y, points[pi1].y, pos0, pos1, pos);
				
				var p:Point = new Point(x, y);
				return p;
				
			}
			// loop = false
			var numPoints:int = points.length;
			
			var nodelen:Number = 1.0 / (numPoints-1);
			
			
			var pi0:int = Math.floor( (numPoints-1) * pos);
			var pi1:int = (pi0 + 1) % numPoints;
			
			var pos0:Number = pi0 * nodelen;
			var pos1:Number = (pi0+1) * nodelen;
			
			var x:Number = Utils.ScaleTo(points[pi0].x, points[pi1].x, pos0, pos1, pos);
			var y:Number = Utils.ScaleTo(points[pi0].y, points[pi1].y, pos0, pos1, pos);
			
			var p:Point = new Point(x, y);
			return p;
			
			
		}
		
	}
	
}