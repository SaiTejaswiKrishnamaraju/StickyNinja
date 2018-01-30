package  
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import GameObj;
	import Line;
	
	/**
	* ...
	* @author Default
	*/
	public class Collision 
	{
		

		
		
		public static function PointInConvexPoly(x:Number, y:Number, poly:Array):Boolean
		{
			var count:int = poly.length;
			var i:int;
			for (i = 0; i < count; i++)
			{
				var line:Line = poly[i];
				
				var dot:Number = DotProduct( line.x0 - x, line.y0 - y, line.nx, line.ny);
				if (dot < 0)
				{
					return false;
				}				
			}
			return true;
		}
	
		
		

		
		
		
		//---------------
		
		// Helper functions:
		
		static function GameObjectInPolyBoundingBox(go:GameObj, poly:Poly):Boolean
		{
			var rad:Number = go.radius+50;
			var x:Number = go.xpos;
			var y:Number = go.ypos;
			
			if (poly.boundingRectangle == null) return false;
			
			stats_numBBTests++;
			
			if (x < (poly.boundingRectangle.left - rad) ) return false;
			if (x > (poly.boundingRectangle.right + rad) ) return false;
			if (y < (poly.boundingRectangle.top - rad) ) return false;
			if (y > (poly.boundingRectangle.bottom + rad) ) return false;
			return true;			
		}
		
		static function DistBetween(go0:GameObj, go1:GameObj):Number
		{
			var dx:Number = go1.xpos - go0.xpos;
			var dy:Number = go1.ypos - go0.ypos;
			return Math.sqrt( (dx * dx) + (dy * dy) );
		}
		static function Dist2Between(go0:GameObj, go1:GameObj):Number
		{
			var dx:Number = go1.xpos - go0.xpos;
			var dy:Number = go1.ypos - go0.ypos;
			return (dx * dx) + (dy * dy);
		}
		
		static function DistBetweenPoints(x0:Number,y0:Number,x1:Number,y1:Number):Number
		{
			var dx:Number = x1-x0;
			var dy:Number = y1 - y0;
			return Math.sqrt( (dx * dx) + (dy * dy) );
		}
		static function Dist2BetweenPoints(x0:Number,y0:Number,x1:Number,y1:Number):Number
		{
			var dx:Number = x1-x0;
			var dy:Number = y1 - y0;
			return (dx * dx) + (dy * dy);
		}

		
		
//----------------------------------------------------------------------------------------------------------------------		

		public static var closestX:Number = 0;
		public static var closestY:Number = 0;
		public static var closestInfiniteX:Number = 0;
		public static var closestInfiniteY:Number = 0;
		public static function ClosestPointOnLine(lx0:Number, ly0:Number, lx1:Number, ly1:Number, x:Number, y:Number):Number
		{
			var apX:Number = x - lx0;
			var apY:Number = y - ly0;
			var abX:Number = lx1 - lx0;
			var abY:Number = ly1 - ly0;
			var ab2:Number = (abX * abX) + (abY * abY);
			var ap_ab:Number = (apX * abX) + (apY * abY);
			var t:Number = ap_ab / ab2;

			closestInfiniteX = lx0 + (abX * t);
			closestInfiniteY = ly0 + (abY * t);			
			
			var origt:Number = t;
			
			if (t < 0.0) t = 0.0;
			if (t > 1.0) t = 1.0;
			closestX = lx0 + (abX * t);
			closestY = ly0 + (abY * t);			
			
			return origt;
		}


		
		
		
		public static var IntersectionX:Number = 0;
		public static var IntersectionY:Number = 0;
		public static function LineLineIntersection(l0:Line,l1:Line):Boolean
		{
			var x0:Number = l0.x0;
			var y0:Number = l0.y0;
			var x1:Number = l0.x1;
			var y1:Number = l0.y1;
			var x2:Number = l1.x0;
			var y2:Number = l1.y0;
			var x3:Number = l1.x1;
			var y3:Number = l1.y1;
			
			var d0:Number = (x1 - x0);
			var d1:Number = (x3 - x2);
//			if (d0 < 0.0001) d0 = 0.0001;
//			if (d1 < 0.0001) d1 = 0.0001;
			var m1:Number = (y1 - y0) / d0;
			var m2:Number = (y3 - y2) / d1;

//			if (m1 > 999999999.0)
//				m1 = 999999999.0;
//			if (m2 > 999999999.0)
//				m2 = 999999999.0;

			var c1:Number = (y0 - m1 * x0);
			var c2:Number = (y2 - m2 * x2);

			var xi:Number = (c1 - c2) / (m2 - m1);
			var yi:Number = m1 * (c2 - c1) / (m1 - m2) + c1;
			
			if (l0.boundingRect.contains(xi, yi))
			{
				if(l1.boundingRect.contains(xi, yi) )
				{
					IntersectionX = xi;
					IntersectionY = yi;
					return true;
				}
			}
			return false;
		}
		
		
//----------------------------------------------------------------------------------------------------------------------		
				
		static function DistToLine(lx0:Number, ly0:Number, lx1:Number, ly1:Number, x:Number, y:Number):Number
		{
			ClosestPointOnLine(lx0, ly0, lx1, ly1, x, y);
			
			var dx:Number = closestX - x;
			var dy:Number = closestY - y;
			var dist:Number = Math.sqrt( (dx * dx) + (dy * dy) );
			return dist;			
		}
		static function Dist2ToLine(lx0:Number, ly0:Number, lx1:Number, ly1:Number, x:Number, y:Number):Number
		{
			ClosestPointOnLine(lx0, ly0, lx1, ly1, x, y);
			
			var dx:Number = closestX - x;
			var dy:Number = closestY - y;
			return (dx * dx) + (dy * dy);
		}

//----------------------------------------------------------------------------------------------------------------------		

		static function SideOfLine(lx0:Number, ly0:Number, lx1:Number, ly1:Number, x:Number, y:Number):Boolean
		{
			var dot:Number = DotProduct( lx1 - lx0, ly1 - ly0, x - lx0, y - ly0);
			if (dot < 0.0) return false;
			return true;
		}		

		
		static function SideOfLine1(l:Line,x:Number, y:Number):Boolean
		{			
			var dot:Number = DotProduct( l.x1 - l.x0, l.y1 - l.y0, x - l.x0, y - l.y0);
			if (dot < 0.0) return false;
			return true;
		}		
		
//----------------------------------------------------------------------------------------------------------------------		
		
		static function DotProduct(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			// dot product
			// ax*bx + ay*by
			var dot:Number = (x0 * x1) + (y0 * y1);
			return dot;
		}
		
//----------------------------------------------------------------------------------------------------------------------		

		static function Intersected(go:GameObj, l:Line,intersectionPointX:Number,intersectionPointY:Number,xoff:Number,yoff:Number,rad:Number):void
		{
			var numIterations:int = 50;
			var dx:Number = (go.oldxpos+xoff) - intersectionPointX;
			var dy:Number = (go.oldypos+yoff) - intersectionPointY;

			
			dx /= Number(numIterations);
			dy /= Number(numIterations);
			var x:Number = go.xpos+xoff;
			var y:Number = go.ypos+yoff;

			var radius2:Number = rad*rad;

			var i:int;
			for (i = 0; i < numIterations; i++)
			{
				x += dx;
				y += dy;				
				var dist2ToLine:Number = Dist2ToLine(l.x0, l.y0, l.x1, l.y1, x,y);
				if (dist2ToLine > radius2)
				{
					go.xpos = x-xoff;
					go.ypos = y-yoff;
					return;
				}
			}
		}
		
//----------------------------------------------------------------------------------------------------------------------		

		static var PolyCollision_LineHit:Line;
		static function PolyCollision(go:GameObj, poly:Poly,xoff:Number,yoff:Number,rad:Number):Boolean
		{
			stats_numPolyCollisionTests++;
			
			var collidedLines:Array = new Array();
			var collidedDists:Array = new Array();
			var l:Line;
			var sideOfLine:Boolean;
			var dist2ToLine:Number;
			
			var x:Number = go.xpos+xoff;
			var y:Number = go.ypos+yoff;
			var radius:Number = rad;
			var radius2:Number = radius*radius;
			for each (var line:Line in poly.lineList)
			{
				sideOfLine = SideOfLine(line.x0, line.y0, line.x1, line.y1, x, y);
				if (sideOfLine == true)
				{
					dist2ToLine = Dist2ToLine(line.x0, line.y0, line.x1, line.y1, x, y);
					if (dist2ToLine < radius2)
					{
						collidedLines.push(line);
						collidedDists.push(dist2ToLine);
					}
					
				}
			}
			var i:int;
			var j:int;
			var numCollided = collidedLines.length;
			for (i = 0; i < numCollided - 1; i++)
			{
				for (j = i; j < numCollided; j++)
				{
					var d0:Number = collidedDists[i];
					var d1:Number = collidedDists[j];
					var l0:Line = collidedLines[i];
					var l1:Line = collidedLines[j];
					if (d1 < d0)
					{
						collidedDists[i] = d1;
						collidedDists[j] = d0;
						collidedLines[i] = l1;
						collidedLines[j] = l0;
					}
				}
			}
			
			for (i = 0; i < numCollided; i++)
			{
				l = collidedLines[i];
				sideOfLine = SideOfLine(l.x0, l.y0, l.x1, l.y1, x, y);
				if (sideOfLine == true)
				{
					dist2ToLine = Dist2ToLine(l.x0, l.y0, l.x1, l.y1, x, y);
					if (dist2ToLine < radius2)
					{
						stats_numIntersections++;
						Intersected(go, l, closestX, closestY,xoff,yoff,rad);
						PolyCollision_LineHit = l;
						return true;

					}					
				}
				return true;
			}
			
			return false;
		}

		
		

		static function PlayerPickupCollision()
		{
			var bugs:Array = GameObjects.GetGameObjListByName("bug");
			var pickups:Array = new Array();
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active==true && go.colFlag_canBePickedUp)
				{
					pickups.push(go);
				}
			}
			for each(var go:GameObj in bugs)
			{
				for each(var go1:GameObj in pickups)
				{
					if (go1.killed == false)
					{
						var dist:Number = 10+go1.radius;
						if (Utils.DistBetweenPoints(go.xpos, go.ypos, go1.xpos, go1.ypos) < dist)
						{
							if (go1.onHitFunction)
							{
								go1.onHitFunction(go);
							}
						}
					}
				}
			}			
		}
		
		static function PlayerSwitchCollision()
		{
			var bugs:Array = GameObjects.GetGameObjListByName("bug");
			var switches:Array = GameObjects.GetGameObjListByName("switch");
			
			var dist:Number = 30;
			
			
			for each(var go:GameObj in bugs)
			{
				for each(var go1:GameObj in switches)
				{
					if (go1.Switch_IsInContactList(go) == false)
					{
						if (Utils.DistBetweenPoints(go.xpos, go.ypos, go1.xpos, go1.ypos) < dist)
						{
							if (go1.doSwitchFunction != null) 
							{
								if (go1.switchType == "2way")
								{								
									go1.Switch_AddToContactList(go);
								}
								if (go1.doSwitchFunction()) Game.DoGameObjSwitch(go1);
							}						
						}
					}
				}
			}
			
			var removeList:Array = new Array();
			for each(var go1:GameObj in switches)
			{
				for each(go in go1.switchContactList)
				{
					if (Utils.DistBetweenPoints(go.xpos, go.ypos, go1.xpos, go1.ypos) >= dist)
					{
						removeList.push(go);
					}
				}
				for each (go in removeList)
				{
					go1.Switch_RemoveFromContactList(go);
				}
			}
			
			
		}
		static function ProjectileGoPhysObjCollision()
		{
			for each(var goVehicle:GameObj in ProjectileList)
			{
				var vx:Number = goVehicle.xpos;
				var vy:Number = goVehicle.ypos;
				for each(var goObj:GameObj in PhysObjList)
				{
					var d:Number = goObj.radius + 20;
					var d2:Number = d * d;
					var dx:Number = vx-goObj.xpos;
					var dy:Number = vy - goObj.ypos;
					dx += goObj.colOffsetX;
					dy += goObj.colOffsetY;
					var h:Number = (dx * dx) + (dy * dy);

					if (h < d2)
					{
						if (goObj.onHitFunction != null)
						{
							goObj.onHitFunction(goVehicle);
						}
					}
				}				
			}
		}
		
		static var ProjectileList:Vector.<GameObj> = new Vector.<GameObj>();
		static var PhysObjList:Vector.<GameObj> = new Vector.<GameObj>();
		
		public static function MakeLists()
		{
			ProjectileList.splice(0, ProjectileList.length);
			PhysObjList.splice(0, PhysObjList.length);
			
			var go:GameObj;
			for each(go in GameObjects.objs)
			{
				if (go.active && go.colFlag_isBall)						
				{
					ProjectileList.push(go);
				}
				if (go.active && go.colFlag_isGoPhysObj && go.killed == false)						
				{
					PhysObjList.push(go);
					
				}
			}
		}
		
		public static function Update() 
		{
			stats_numIntersections = 0;
			stats_numBBTests = 0;
			stats_numPolyCollisionTests = 0;
			

			//MakeLists();
			//ProjectileGoPhysObjCollision();
			//PlayerSwitchCollision();
			//PlayerPickupCollision();
			
		}		
		
		public static var main:Main;
		public static var stats_numIntersections:int;
		public static var stats_numBBTests:int;
		public static var stats_numPolyCollisionTests:int;
	}
	
}