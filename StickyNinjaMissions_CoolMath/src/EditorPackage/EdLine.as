package EditorPackage 
{
	import EditorPackage.ObjParameters;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EdLine extends EditableObjectBase 
	{
		public var index:int;
		public var type:int;
		public var points:Array;
		public var pointsCopy:Array;
		public var fill:int;
		public var fillScaleX:Number;
		public var fillScaleY:Number;
		public var centrex:Number;
		public var centrey:Number;
		public var fixed:Boolean;
		public var primitiveType:String;
		
		public var isVisible:Boolean;
		public var numVisiblePoints:int;

		public static const PRIMITIVE_LINE:String = "line";
		public static const PRIMITIVE_RECTANGLE:String = "rectangle";
		public static const PRIMITIVE_CIRCLE:String = "circle";
		
		public function EdLine() 
		{
			super();
			classType = "line";
			type = 0;
			points = new Array();
			fill = 0;
			fillScaleX = 1;
			fillScaleY = 1;
			fixed = true;
			
			primitiveType = PRIMITIVE_LINE;
						
			for (var i:int = 0; i < PolyDefs.instanceParams.length; i++)
			{
				objParameters.Add(PolyDefs.instanceParams[i], PolyDefs.instanceParamsDefaults[i]);				
			}
			
			centrex = 0;
			centrey = 0;
			boundingRectangle = null;

		}
		
		public var lineTriangleList:Array;
		public var triangleList:Array;
		public var uvList:Array;
		public var lineUvList:Array;
		
		public function MakeLineTriangleList(width:Number)
		{
			lineTriangleList = null;
			if (GetNumPoints() < 3) return;
			var pointsToTriangulate:Array = points;
			
			lineTriangleList = new Array();
			lineUvList = new Array();
			
			// simple 1:
			// for each line segment take the normal and make 2 triangles from it.
			
			for (var i:int = 0; i < points.length; i++)
			{
				var j:int = i + 1;
				if (j >= points.length) j = 0;
				var k:int = j + 1;
				if (k >= points.length) k = 0;
				var p0:Point = points[i];
				var p1:Point = points[j];
				var p1a:Point = points[k];
				
				var angle:Number = Math.atan2(p1.y - p0.y, p1.x - p0.x);
				angle -= (Math.PI / 2);
				
				var angle2:Number = Math.atan2(p1a.y - p1.y, p1a.x - p1.x);
				angle2 -= (Math.PI / 2);
				
				var p2:Point = p0.clone();
				var p3:Point = p1.clone();
				var dx:Number = Math.cos(angle) * width;
				var dy:Number = Math.sin(angle) * width;
				p2.x += dx;
				p2.y += dy;
				p3.x += dx;
				p3.y += dy;
				
				// p1b is tangent from next line
				var p1b:Point = p1.clone();
				var dx2:Number = Math.cos(angle2) * width;
				var dy2:Number = Math.sin(angle2) * width;
				p1b.x += dx2;
				p1b.y += dy2;
				
				lineTriangleList.push(p0.clone());
				lineTriangleList.push(p2.clone());
				lineTriangleList.push(p3.clone());
				lineTriangleList.push(p0.clone());
				lineTriangleList.push(p3.clone());
				lineTriangleList.push(p1.clone());
				
				var scale:Number = 0.006;
				
				// 2  3
				// 0  1
				
				lineUvList.push(  new Point( (p0.x * scale), (p0.y * scale) )  );
				lineUvList.push(  new Point( (p2.x * scale), (p2.y * scale) )  );
				lineUvList.push(  new Point( (p3.x * scale), (p3.y * scale) )  );
				
				lineUvList.push(  new Point( (p0.x * scale), (p0.y * scale) )  );
				lineUvList.push(  new Point( (p3.x * scale), (p3.y * scale) )  );
				lineUvList.push(  new Point( (p1.x * scale), (p1.y * scale) )  );
				
				if (angle2 > angle)
				{
					// triangle from p1, p1b, and p3
					lineTriangleList.push(p1.clone());
					lineTriangleList.push(p1b.clone());
					lineTriangleList.push(p3.clone());
					lineUvList.push(  new Point( (p1.x * scale), (p1.y * scale) )  );
					lineUvList.push(  new Point( (p1b.x * scale), (p1b.y * scale) )  );
					lineUvList.push(  new Point( (p3.x * scale), (p3.y * scale) )  );
					
				}
				
			}
			
		}
		public function DoTriangulation()
		{
			triangleList = null;
			if (GetNumPoints() < 3) return;
			
			var isSpline:Boolean = IsSpline();

			var pointsToTriangulate:Array = points;
			
			if (isSpline)
			{
				if (GetNumPoints() < 4) return;
				pointsToTriangulate =  GetCatmullRomPointsList(points, 0, 0);
			}
			
			
			triangleList = new Array();
			uvList = new Array();
			
			var triangulate:Triangulate = new Triangulate();
			var triangulatedVerts:Array = triangulate.process(pointsToTriangulate);
			
			if (triangulatedVerts == null)
			{									
				Utils.traceerror("object failed triangulating: " + pointsToTriangulate.length);
				triangulatedVerts = new Array()
				for each(var p:Point in pointsToTriangulate)
				{
					triangulatedVerts.push(p.clone());
				}
			}
			else
			{
//				Utils.print("object triangulating: " + pointsToTriangulate.length + "  ->  " + triangulatedVerts.length);
				
			}
			var numTris:int = int(triangulatedVerts.length / 3);
			for (var t:int = 0; t < numTris; t++)
			{
				var p0:Point = triangulatedVerts[(t * 3) + 0];
				var p1:Point = triangulatedVerts[(t * 3) + 1];
				var p2:Point = triangulatedVerts[(t * 3) + 2];

				triangleList.push(p0.clone());
				triangleList.push(p1.clone());
				triangleList.push(p2.clone());
				
				var scale:Number = 0.006;
				
				uvList.push(  new Point( (p0.x * scale), (p0.y * scale) )  );
				uvList.push(  new Point( (p1.x * scale), (p1.y * scale) )  );
				uvList.push(  new Point( (p2.x * scale), (p2.y * scale) )  );
				
			}
				
		}
		

		public function GetParameterListForExport():String
		{
			var exportStr:String = ""
						
			for (var i:int = 0; i < PolyDefs.instanceParams.length; i++)
			{
				var s:String = PolyDefs.instanceParams[i];
				exportStr += s + "=";
				var s1:String = objParameters.GetValueString(s);
				exportStr += s1;
				if (i != PolyDefs.instanceParams.length - 1) exportStr += ",";				
			}
			return exportStr;
		}
		
		
		public function CalculateCentre():Point
		{
			var x:Number = 0;
			var y:Number = 0;
			for each(var p:Point in points)
			{
				x += p.x;
				y += p.y;
			}
			x /= points.length;
			y /= points.length;
			return new Point(x, y);
			
		}
		
		public function AddPoint(x:Number, y:Number)
		{
			points.push(new Point(x, y));
		}
		
		public function SetPointArray(a:Array)
		{
			points = a;
		}
		
		public function Clone():EdLine
		{
			var l:EdLine = new EdLine();
			l.classType = classType;
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
			
			if (boundingRectangle != null)
			{
				l.boundingRectangle = boundingRectangle.clone();
			}
			return l;
		}
		
//------------------------------------------------------------------------
		public function GetPoint(index:int):Point
		{
			return points[index];
		}
//------------------------------------------------------------------------

		public var boundingRectangle:Rectangle;
		public function CalcBoundingRectangle()
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

		public function GetPointOnCatmullRom_Points(_points:Array,t:Number,loop:Boolean):Point
		{
			var np:int = _points.length;
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

			
			p0 = _points[pt0];
			p1 = _points[pt1];
			p2 = _points[pt2];
			p3 = _points[pt3];

			var i1:int = i + 1;
			var s0:Number = 1.0 / Number(numSegs) * i;
			var s1:Number = 1.0 / Number(numSegs) * i1;
			var t1:Number = 1.0 / (s1 - s0) * (t - s0);
			var p:Point = PointOnCurve(t1, p0, p1, p2, p3);

//			trace(t + " " + i + " " + t1);

			return p;
			
		}

		public function GetCatmullRomPointsList(origPoints:Array,xoff:Number,yoff:Number):Array
		{
			var np:int = origPoints.length;
			if (np < 4) return null;

			var a:Array = new Array();
			var t1:Number;
			
			var numSubdivs:int = np * 4;
			var adder:Number = 1 / numSubdivs;
			
			for (t1 = 0; t1 < 1.0; t1 += adder)
			{
				var pp:Point = GetPointOnCatmullRom_Points(origPoints,t1, true);
				a.push(pp);
			}
			return a;
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
		public function GetInterpolatedPoint_SegmentRatio(pos:Number,loop:Boolean,isSpline:Boolean=false):Point
		{
			if (isSpline)	//type == 2)
			{
				return GetPointOnCatmullRom(pos,loop);
			}
			
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
		public function GetInterpolatedPoint_EqualSpacing(pos:Number,loop:Boolean,isSpline:Boolean=false):Point
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
		
		public function RenderHighlightSelectedPoint(selectedPointIndex:int,col:uint,rad:int):void
		{
			PhysEditor.linesScreen.graphics.clear();

			var layer:int = GetCurrentLayer();			
			if (EditorLayers.IsVisible(layer) == true)
			{
			
				var thesePoints:Array = points;
				for each(var p:Point in thesePoints)
				{
					p = PhysEditor.GetMapPos( p.x, p.y);
				}
				
				
				if (primitiveType == EdLine.PRIMITIVE_LINE)
				{
					for (var i:int = 0; i < thesePoints.length; i++)
					{
						if (i == selectedPointIndex)
						{
							var r:Rectangle = new Rectangle(0, 0, 1, 1);
							
							var pt:Point = PhysEditor.GetMapPos(thesePoints[i].x, thesePoints[i].y);
							
							r.x = pt.x - rad;
							r.y = pt.y - rad;
							r.width = (rad*2)+1;
							r.height = (rad*2)+1;
							
							PhysEditor.RenderRectangle(r, col);
						}
					}					
				}
			
			}
			PhysEditor.screenBD.draw(PhysEditor.linesScreen);
		}
		
		
		function Reverse()
		{
			var pts:Array = points;			
			var newpts:Array = pts.reverse();			
			points = newpts;			
		}
		
		public override function XFlip(centreX:Number):void
		{
			Reverse();
			
			for each(var p:Point in points)
			{
				p.x = centreX - p.x;
			}
		}
		
		public override function GetEditorHoverName():String
		{
			return "LINE: " + id;
		}
		
		public override function RenderHighlighted(highlightType:int):void
		{
			PhysEditor.linesScreen.graphics.clear();

			var points:Array = PhysEditor.GetMapPosPoints(points);		
			
			if (highlightType == HIGHLIGHT_HOVER)
			{
				PhysEditor.FillPoly(points, 0xff0000, 0.5);				
			}
			else if (highlightType == HIGHLIGHT_SELECTED)
			{
				PhysEditor.FillPoly(points, 0xffffff, 0.5);				
			}
			PhysEditor.screenBD.draw(PhysEditor.linesScreen);
			
		}
		
		public function RenderInner():void
		{
			PhysEditor.linesScreen.graphics.clear();
			
			var _useCursor:Boolean = false;
			PhysEditor.GetMousePositions();
			
			var selectedIndex:int = PhysEditor.editModeObj_Lines.currentLineIndex;
			var selectedPointIndex:int = PhysEditor.editModeObj_Lines.currentPointIndex;
			
			var lineIndex:int = this.index;
			
			var p0:Point = new Point();
			var p1:Point = new Point();
			var r:Rectangle = new Rectangle();

			var layer:int = GetCurrentLayer();			
			var polyMaterial:PolyMaterial = GetCurrentPolyMaterial();			
			
			var col:uint = 0xffffff;
			var doNormals:Boolean = false;
			var doBitmapFill:Boolean = false;
			var thickness:int  = 1;
			var joinPoly:Boolean = false;
			var doColorFill:Boolean = false;
			var doDirectionArrows:Boolean = false;
			var highlightFirstPoint:Boolean = true;
			
			var isSpline:Boolean = IsSpline();

			
			if (polyMaterial.edType == "path")
			{
				col = 0x2020ff;
				thickness = 2;
				doNormals = false;
				doBitmapFill = false;
				joinPoly = true;
				doColorFill = false;
				doDirectionArrows = true;
			}
			else if (polyMaterial.edType == "outline")
			{
				col = 0xffffff;
				thickness = 2;
				doNormals = true;
				doBitmapFill = false;
				joinPoly = true;
				doColorFill = false;
				doDirectionArrows = false;
			}
			else if (polyMaterial.edType == "line")
			{
				col = 0xffff80;
				thickness = 3;
				doNormals = false;
				doBitmapFill = false;
				joinPoly = false;
				doColorFill = false;
				doDirectionArrows = false;
			}
			else if (polyMaterial.edType == "poly")
			{
				col = 0xffffff;
				thickness = 1;
				doNormals = true;
				doBitmapFill = true;
				joinPoly = true;
				doColorFill = false;
				doDirectionArrows = false;
			}
			else if (polyMaterial.edType == "surface")
			{
				col = 0xffff80;
				thickness = 1;
				doNormals = true;
				doBitmapFill = true;
				joinPoly = false;
				doColorFill = false;
				doDirectionArrows = false;
			}
			else
			{
				Utils.print("error, unknown polymaterial type " + polyMaterial.initType);
			}
			

			
			
			
			if (EditorLayers.IsVisible(layer) == true)
			{
			
				var thesePoints:Array = points;
				if (lineIndex == selectedIndex && _useCursor && primitiveType==EdLine.PRIMITIVE_LINE) 
				{
					thesePoints = new Array();
					for each(var p0:Point in points)
					{
						thesePoints.push(p0.clone());
					}
					thesePoints.push(new Point(PhysEditor.mxs, PhysEditor.mys));
				}
				var points1:Array = new Array;
				for each(var p:Point in thesePoints)
				{
					var zp:Point = PhysEditor.GetMapPos( p.x, p.y);
					points1.push(zp);
				}
				thesePoints = points1;
				
				
				var np:int = GetNumPoints();
				
				if (polyMaterial.editorRenderFunctionName != null && polyMaterial.editorRenderFunctionName != "")
				{
					this[polyMaterial.editorRenderFunctionName](PhysEditor.screenBD,polyMaterial,thesePoints);
				}
				else
				{
				

					if (isSpline == false || thesePoints.length < 4)
					{
					
						if (thesePoints.length >= 2)
						{
							
							var i:int;
							for (i = 0; i < thesePoints.length - 1; i++)
							{
								p0 = thesePoints[i];
								p1 = thesePoints[i + 1];
								PhysEditor.RenderLine(p0.x,p0.y, p1.x,p1.y,col,thickness,1,doNormals,doDirectionArrows);
							}
							if (joinPoly)
							{
								p0 = thesePoints[thesePoints.length-1];
								p1 = thesePoints[0];
								PhysEditor.RenderLine(p0.x,p0.y, p1.x,p1.y,col,thickness,1,doNormals,doDirectionArrows);
							}
						}
						if (doBitmapFill)
						{
							var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName(polyMaterial.graphicName);
							if (dobj != null)
							{
								var frame:int = polyMaterial.fillFrame;
								PhysEditor.FillPolyBitmap(dobj.GetBitmapData(frame), thesePoints);
							}
						}

						
						if (doColorFill) 
						{
							PhysEditor.FillPoly(thesePoints, col, 0.1);
						}
					}
					
					if (isSpline && thesePoints.length >= 4)
					{
						var splinePoints:Array = GetCatmullRomPointsList(thesePoints, 0, 0);
							
						var i:int;
						for (i = 0; i < splinePoints.length - 1; i++)
						{
							p0 = splinePoints[i];
							p1 = splinePoints[i + 1];
							thickness = 1;
							doNormals = false;
							doDirectionArrows = false;
							PhysEditor.RenderLine(p0.x,p0.y, p1.x,p1.y,col,thickness,1,doNormals,doDirectionArrows);
						}
						//if (joinPoly)
						//{
						//	p0 = thesePoints[thesePoints.length-1];
						//	p1 = thesePoints[0];
						//	PhysEditor.RenderLine(p0.x,p0.y, p1.x,p1.y,col,thickness,1,doNormals,doDirectionArrows);
						//}
						if (doBitmapFill)
						{
							var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName(polyMaterial.graphicName);
							PhysEditor.FillPolyBitmap(dobj.GetBitmapData(polyMaterial.fillFrame),splinePoints);
						}
					
						if (doColorFill) 
						{
							PhysEditor.FillPoly(splinePoints, col, 0.1);
						}
					}
				}
				
				if (primitiveType == EdLine.PRIMITIVE_LINE)
				{
					for (i = 0; i < thesePoints.length; i++)
					{
						col = 0xffff0000;
						var off1:int = 2;
						var off2:int = 4;
						r.x = thesePoints[i].x - off1;
						r.y = thesePoints[i].y - off1;
						r.width = off2;
						r.height = off2;
						PhysEditor.RenderRectangle(r, col);
						
						if (highlightFirstPoint)
						{
							if (i == 0)
							{
								col = 0xffff8080;
								
								
								r.x = thesePoints[i].x - 4;
								r.y = thesePoints[i].y - 4;
								r.width = 8;
								r.height = 8;
								PhysEditor.RenderRectangle(r, col);
							}
						}
						
					}					
				}
				
				if (primitiveType == EdLine.PRIMITIVE_RECTANGLE)
				{
					for (i = 0; i <= 2; i+=2)
					{
						col = 0xffff0000;
						var off1:int = 2;
						var off2:int = 4;
						r.x = thesePoints[i].x - off1;
						r.y = thesePoints[i].y - off1;
						r.width = off2;
						r.height = off2;
						
						PhysEditor.RenderRectangle(r, col);
					}
					
				}
			}
			PhysEditor.screenBD.draw(PhysEditor.linesScreen);
		}
		
		public override function GetCentreHandle():Point
		{
			return CalculateCentre();
		}
		

		public override function MoveBy(_x:Number, _y:Number):void
		{
			for each(var p:Point in points)
			{
				p.x += _x;
				p.y += _y;							
			}
		}
		
		public override function HitTestRectangle(r:Rectangle):Boolean
		{
			var layer:int = GetCurrentLayer();
			
			if (EditorLayers.IsVisible(layer) == true)
			{
				for each(var p:Point in points)
				{					
					if (r.containsPoint(new Point(p.x, p.y))) return true;			
				}
			}
			return false;
			
		}
		
		public override function Duplicate():EditableObjectBase
		{
			var dup:EditableObjectBase = Clone() as EditableObjectBase;
			CopyBaseToDuplicate(dup);
			return dup;
		}


//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
		public function RenderEditor_Surface(bd:BitmapData, polyMaterial:PolyMaterial, points:Array)
		{
			
			if (points.length < 2) return;
			
			var p0:Point;
			var p1:Point;
			var i:int;
			for (i = 0; i < points.length - 1; i++)
			{
				p0 = points[i];
				p1 = points[i + 1];
				PhysEditor.RenderLine(p0.x,p0.y, p1.x,p1.y,0xffffff,2,1,true,false);
			}

			
			var go:GameObj = new GameObj();
			go.linkedPhysLine = this;
			go.dobj = GraphicObjects.GetDisplayObjByName(polyMaterial.graphicName);
			go.frame = 0;
			
			go.dobj3 = GraphicObjects.GetDisplayObjByName("SurfaceTextures");
			go.frame3 = 0;
			
			go.xpos = 0;
			go.ypos = 0;
			
			Game.camera.x = 0;
			Game.camera.y = 0;
			
			
			go.bd = bd;
			if (GameObjPolyRenderer.PreRenderPhysicsLineObject_Surface_PointsList_FromEditor(go, points, PhysEditor.zoom))
			{
				GameObjPolyRenderer.RenderPhysicsLineObject_Surface_PointsList(go);
			}
			
			
		}
		
	}
}