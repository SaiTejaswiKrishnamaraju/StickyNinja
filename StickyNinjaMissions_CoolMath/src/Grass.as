package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Ray;
	import nape.geom.RayResult;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author 
	 */
	public class Grass 
	{
		static var list:Vector.<GrassItem>;
		static var segmentList:Vector.<GrassSegment>;
		static var frames:Vector.<GrassFrame>;
		
		public function Grass() 
		{
			
		}
		
		public static function InitOnce()
		{
			return;
			list = new Vector.<GrassItem>();
			
			frames = new Vector.<GrassFrame>();
			AddFrames("grass_fairway");
			AddFrames("grass_rough");
			
		}
		
		static function GetGrassFrame(mcName:String, f:int):GrassFrame
		{
			for each(var gf:GrassFrame in frames)
			{
				if (gf.frameIndex == f && gf.mcName == mcName)
				{
					return gf;
				}
			}
			return null;
		}
		
		static function AddFrames(mcName:String)
		{
		}
		
		public static function InitForLevel()
		{
			list = new Vector.<GrassItem>();
		}
		
		
		
		public static function GetRandomPoint():Point
		{
			var r:int = Utils.RandBetweenInt(0, list.length - 1);
			return new Point(list[r].xpos, list[r].ypos);
		}
		public static function RenderAll(bd:BitmapData)		
		{
					return;

			if (PROJECT::useStage3D)
			{
				return RenderAll_Stage3D();
			}
			
			var sc:Number = Game.camera.scale;
			var cx:Number = Game.camera.x;
			var cy:Number = Game.camera.y;
			
			
//			Utils.trace(Game.camera.linScale);
			
			var renderIt:Boolean = true;
//			if (KeyReader.Down(KeyReader.KEY_G)) renderIt = false;

			var mat:Matrix = new Matrix();

			var sc:Number = Game.camera.scale;
			var x0:Number = 0;
			var x1:Number = (Defs.displayarea_w) * (1 / sc);
			var y0:Number = 0;
			var y1:Number = (Defs.displayarea_h) * (1 / sc);

			
			var frameIndex:int = 0;	// frames[0].GetNearestScaleFrame(sc);
			
			var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName("grass_rough");
			
			
			var skipCount:int = 0;
			var numSegs:int = 0;
			var numGrass:int = 0;
			for each(var seg:GrassSegment in segmentList)
			{
				var xp0:Number = (seg.x0 - cx);	// * sc;
				var xp1:Number = (seg.x1 - cx);	// * sc;
				var yp0:Number = (seg.y0 - cy);	// * sc;
				var yp1:Number = (seg.y1 - cy);	// * sc;

				if ( true)	//(xp1 >= x0 && xp0 <= x1) && (yp1 >= y0 && yp0 <= y1) )
				{
					var i:int = 0;
					for (i = 0; i < seg.list.length; i += 1)
					{	
						var g:GrassItem = seg.list[i];
						var xp:Number = Math.round(g.xpos - cx);
						var yp:Number =  Math.round(g.ypos -cy);
						
						if (g.rot == 0)
						{
							dobj.RenderAt(g.frameIndex, bd, xp, yp);
						}
						else
						{
							dobj.RenderAtRotScaled(g.frameIndex, bd, xp, yp, 1, g.rot);
						}
						numGrass++
					}
					numSegs++;
				}
				else
				{
					skipCount++;
				}
			}
//			Utils.print("numsegs " + numSegs+"  skipCount: "+skipCount+"   numblades: "+numGrass);
			
		}
		
//		v' = (1-d)^h * (v + a/m), x' = x + hv'
//		 for drag d, timestep h, acceleration a, mass m


		if (PROJECT::useStage3D)
		{
		static function RenderAll_Stage3D()
		{
		return;
			var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName("grass_rough");
			
				var x:Number =  Math.round(Game.camera.x);
				var y:Number =  Math.round(Game.camera.y);
				
				var m3d:Matrix3D = new Matrix3D();
				m3d.identity();
				m3d.appendTranslation(-x, -y, 0);
				var triList:s3dTriList = s3d.triangleLists[s3dTriListIndex];
//				s3d.RenderTriangleList(m3d, dobj.GetTexture(0), triList.indices,triList.vertices,triList.vertices_extra);
			
				s3d.RenderPreUploadedTriangleList1(-x,-y,m3d, dobj.GetTexture(0), triList);
				
		}
		static function PreRenderGrass_Stage3D()
		{
		return;
		
			var triangleList:Array = new Array();
			var uvList:Array = new Array();
			var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName("grass_rough");
			
			for each(var seg:GrassSegment in segmentList)
			{
				for each(var g:GrassItem in seg.list)
				{
					
					var dof:DisplayObjFrame = dobj.GetFrame(g.frameIndex);
					
					var x:Number = g.xpos+dof.xoffset;
					var y:Number = g.ypos+dof.yoffset;
					
					triangleList.push(new Point(x+0, y+0));
					triangleList.push(new Point(x+dof.sourceRect.width, y+0));
					triangleList.push(new Point(x+0, y+dof.sourceRect.height));
					triangleList.push(new Point(x+dof.sourceRect.width, y+0));
					triangleList.push(new Point(x+dof.sourceRect.width, y+dof.sourceRect.width));
					triangleList.push(new Point(x+0, y+dof.sourceRect.height));
					
					uvList.push(new Point(dof.u0, dof.v0));
					uvList.push(new Point(dof.u1, dof.v0));
					uvList.push(new Point(dof.u0, dof.v1));

					uvList.push(new Point(dof.u1, dof.v0));
					uvList.push(new Point(dof.u1, dof.v1));
					uvList.push(new Point(dof.u0, dof.v1));


				}
			}

			
			s3dTriListIndex = s3d.MakeIndieTriangleList(triangleList, uvList);
			
		}
		}
		
		static var s3dTriListIndex:int;		
		
		public static var minX:Number;
		public static var maxX:Number;
		public static var minY:Number;
		public static var maxY:Number;
		public static function PreRenderLines()
		{
			return;
			segmentList = new Vector.<GrassSegment>();
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active && go.preRenderFunction1 != null)
				{
					list = new Vector.<GrassItem>();
					go.preRenderFunction1();
			
					minX = 9999999;
					maxX = -9999999;
					minY = 9999999;
					maxY = -9999999;
					for each(var g:GrassItem in list)
					{
						if (g.xpos < minX) minX = g.xpos;
						if (g.xpos > maxX) maxX = g.xpos;
						if (g.ypos < minY) minY = g.ypos;
						if (g.ypos > maxY) maxY = g.ypos;
					}
					
					var segWidth:int = 100;
					
					for (var x0:int = minX; x0 < maxX; x0 += segWidth)
					{
						var seg:GrassSegment = new GrassSegment();
						
						seg.boundingRect = new Rectangle(x0, minY, x1 - x0, maxY - minY);
						
						var x1:int = x0 + segWidth;
						seg.x0 = x0;
						seg.x1 = x1;
						seg.y0 = minY;
						seg.y1 = maxY;
						
						for each(var g:GrassItem in list)
						{
							if (g.xpos >= x0 && g.xpos <= x1)
							{
								seg.list.push(g);
							}
						}
						segmentList.push(seg);
					}
				}
			}
//			RemoveHiddenGrass();
if(PROJECT::useStage3D)
{
			PreRenderGrass_Stage3D();
}
		}
		
		static function Update()
		{
			return;
			var cx:Number = Game.camera.x;
			var cy:Number = Game.camera.y;
			var sc:Number = 1;
			
			var x0:Number = 0;
			var x1:Number = (Defs.displayarea_w) * (1 / sc);
			var y0:Number = 0;
			var y1:Number = (Defs.displayarea_h) * (1 / sc);
			
			var go:GameObj = GameVars.footballGO;
			if (go == null) return;

			var doCol:Boolean = true;
			if (go.GetBodyLinearVelocity(0).length < 20) doCol = false;
			
			var l:Number = go.GetBodyLinearVelocity(0).length;
			
			var go_x:Number = go.xpos;
			var go_y:Number = go.ypos;
			var d2test:Number = 15 * 15;
			
			var updatesegcount:int = 0;
			var skipsegcount:int = 0;
			
			for each(var seg:GrassSegment in segmentList)
			{
				var xp0:Number = (seg.x0 - cx);	// * sc;
				var xp1:Number = (seg.x1 - cx);	// * sc;
				var yp0:Number = (seg.y0 - cy);	// * sc;
				var yp1:Number = (seg.y1 - cy);	// * sc;


				if (doCol)
				{
					if ( (go_x >= seg.x0 - 30 && go_x <= seg.x1 + 30) && (go_y >= seg.y0 - 30 && go_y <= seg.y1 + 30) )
					{
					//updatesegcount++;
						for each(var g:GrassItem in seg.list)
						{
							if (g.timer == 0)
							{
								var dx:Number = g.xpos-go_x;
								var dy:Number = g.ypos-go_y;
								var d2:Number = ( (dx * dx) + (dy * dy) );
								if (d2 < d2test)
								{
									g.timer = Utils.RandBetweenInt(20,20);
									
								}
							}
						}
					}
				}
				
				// update
				if ( (xp1 >= x0 && xp0 <= x1) && (yp1 >= y0 && yp0 <= y1) )
				{
					for each(var g:GrassItem in seg.list)
					{
						if (g.timer > 0)
						{
							g.timer--;
							
							if(Math.random() < 0.5)
							{
								g.rot += 0.1;
								if (g.rot > 1) g.rot = 1;
							}
							else
							{
								g.rot -= 0.1;
								if (g.rot < -1) g.rot = -1;
							}
							if (g.timer <= 0)
							{
								g.rot = 0;
							}
						}
					}
				}
			}
//			Utils.print("grass " + updatesegcount + "  " + skipsegcount);
			
		}
		static function RemoveHiddenGrass()
		{
			PhysicsBase.SetCurrentSpace(1);
			for each(var g:GrassItem in list)
			{
				var r:Ray = new Ray(new Vec2(g.xpos, g.ypos - 5), new Vec2(0, -1));
				r.maxDistance = 500;				
				var filter:InteractionFilter = new InteractionFilter(1, 1, 0, 0, 0, 0);				
				var rr:RayResult = PhysicsBase.GetNapeSpace().rayCast(r,true, filter);
				if (rr != null)
				{
					g.visible = false;
					var p:Vec2 = r.at(rr.distance);
					//Utils.trace("grass ray hit");
				}
			}
			PhysicsBase.SetCurrentSpace(0);
		}
		
		
		public static function AddLine(p0:Point, p1:Point, mcName:String)
		{
			var sc:Number = Game.camera.scale;
			var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName(mcName);
			var numF:int = dobj.GetNumFrames();
			if (p1.x > p0.x)
			{
				var ang:Number = Math.abs(p1.y - p0.y) /  Math.abs(p1.x - p0.x) 
				if (ang < 0.7)
				{				
					var dx:Number = p1.x - p0.x;
					var dy:Number = p1.y - p0.y;
					var total:Number = dx/6;
					dx /= total;
					dy /= total;
					for (var j:int = 0; j < total; j++)
					{
						var f:int = Utils.RandBetweenInt(0, numF - 1);
						
						var xoffset:Number = Utils.RandBetweenInt( -1, 1);
						
						var grassFrame:GrassFrame = GetGrassFrame(mcName, f);
						
						list.push(new GrassItem(p0.x+xoffset, p0.y+1, grassFrame,f));
						p0.x += dx;
						p0.y += dy;
					}
				}
			}
		}
		
	}

}