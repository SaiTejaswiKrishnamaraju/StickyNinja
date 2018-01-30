package  
{
	import EditorPackage.EditMode_Lines;
	import EditorPackage.EdLine;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class GameObjPolyRenderer 
	{
		public static var go:GameObj;
		
		static var surface_height:Number = 64;
		
		static var collisionYOffsets:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0);
				
				
				
		public function GameObjPolyRenderer() 
		{
			
		}

		
		public static function PreRenderPhysicsLineObject_SurfacePoly_PointsList(_go:GameObj)
		{
			go = _go;
			
			var collideY:int = surface_height-30;
			var collideYa:int = 30;	// - collisionYOffsets[Game.currentBackground];
			
			// Create a left-right list of points
			
			go.surfacePointsList0 = new Vector.<Point>();
			go.surfacePointsList1 = new Vector.<Point>();
			go.surfacePointsList2 = new Vector.<Point>();
			go.surfacePointsList3 = new Vector.<Point>();
			go.surfacePointsList4 = new Vector.<Point>();
			
			go.fillScreenMC = new Shape();
			go.fillScreenMC.x = 0;
			go.fillScreenMC.y = 0;
			
			var p0:Point;
			var p1:Point;
			var p2:Point;
			var p3:Point;
			
			var num:int = go.linkedPhysLine.points.length;

			
			for (var i:int = 0; i < num; i++)
			{
				var p:Point = go.linkedPhysLine.points[i];
				p0 = p.clone();
				p1 = p0.clone();
				p2 = p0.clone();
				p3 = p0.clone();

				p0.y -= collideY;
				p1.y += collideYa;
				
				go.surfacePointsList0.push(p0);
				go.surfacePointsList1.push(p1);
			}

			for (var i:int = 0; i < num; i++)
			{
				var p:Point = go.linkedPhysLine.points[i];
				p0 = p.clone();
				
				var j:int = i + 1;
				if (j >= num) j = 0;
				
				var p:Point = go.linkedPhysLine.points[j];
				p1 = p.clone();

				if (p0.x < p1.x)
				{				
					p0.y += collideYa;
				}
				
				go.surfacePointsList4.push(p0);
			}
			
			
			go.s3dTriListIndex = -1;
			Surface_MakeDrawTrianglesLists();
		}
		
		
		public static function PreRenderPhysicsLineObject_Surface_PointsList(_go:GameObj)
		{
			go = _go;
			
			var collideY:int = surface_height;
			var collideYa:int = 0;	// - collisionYOffsets[Game.currentBackground];
			
			// Create a left-right list of points
			
			go.surfacePointsList0 = new Vector.<Point>();
			go.surfacePointsList1 = new Vector.<Point>();
			go.surfacePointsList2 = new Vector.<Point>();
			go.surfacePointsList3 = new Vector.<Point>();
			
			go.fillScreenMC = new Shape();
			go.fillScreenMC.x = 0;
			go.fillScreenMC.y = 0;
			
			var p0:Point;
			var p1:Point;
			var p2:Point;
			var p3:Point;
			
			var num:int = go.linkedPhysLine.points.length;
			
			// check for no wrapping back on yourself
			for (var i:int = 0; i < num-1; i++)
			{
				if (go.linkedPhysLine.points[i].x > go.linkedPhysLine.points[i + 1].x)
				{
					go.visible = false;
					trace("ERROR: surface is wrapping under itself "+i);
					return;
					
				}
				
			}
			
			for (var i:int = 0; i < num; i++)
			{
				var p:Point = go.linkedPhysLine.points[i];
				p0 = p.clone();
				p1 = p0.clone();
				p2 = p0.clone();
				p3 = p0.clone();

				p0.y -= collideY;
				p1.y += collideYa;
				
				p2.y += collideYa;
				p3.y += 900;
				
				go.surfacePointsList0.push(p0);
				go.surfacePointsList1.push(p1);
				go.surfacePointsList2.push(p2);
				go.surfacePointsList3.push(p3);		
				// 2 rows of surface points
			}
			
			go.s3dTriListIndex = -1;
			Surface_MakeDrawTrianglesLists();
		}
		
		public static function PreRenderPhysicsLineObject_Surface_PointsList_FromEditor(_go:GameObj,points:Array,scale:Number):Boolean
		{
			go = _go;
			
			var collideY:int = surface_height-30;
			var collideYa:int = 30;	// - collisionYOffsets[Game.currentBackground];
			
			// Create a left-right list of points
			
			go.surfacePointsList0 = new Vector.<Point>();
			go.surfacePointsList1 = new Vector.<Point>();
			go.surfacePointsList2 = new Vector.<Point>();
			go.surfacePointsList3 = new Vector.<Point>();
			
			go.fillScreenMC = new Shape();
			go.fillScreenMC.x = 0;
			go.fillScreenMC.y = 0;
			
			var p0:Point;
			var p1:Point;
			var p2:Point;
			var p3:Point;
			
			var num:int = points.length;
			
			
			// check for no wrapping back on yourself
			for (var i:int = 0; i < num-1; i++)
			{
				if (points[i].x > points[i + 1].x)
				{
					trace("ERROR: surface is wrapping under itself "+i);
					return false
					
				}
				
			}
			
			for (var i:int = 0; i < num; i++)
			{
				var p:Point = points[i];
				p0 = p.clone();
				p1 = p0.clone();
				p2 = p0.clone();
				p3 = p0.clone();

				p0.y -= collideY*scale;
				p1.y += collideYa*scale;
				
				p2.y += collideYa*scale;
				p3.y += 900*scale;
				
				go.surfacePointsList0.push(p0);
				go.surfacePointsList1.push(p1);
				go.surfacePointsList2.push(p2);
				go.surfacePointsList3.push(p3);		
				// 2 rows of surface points
			}
			
			go.s3dTriListIndex = -1;
			Surface_MakeDrawTrianglesLists();
			return true;
		}
		
		
		static function Surface_MakeDrawTrianglesLists()
		{
			// one set of data for each layer, sorted by texture
			// skewed quads, made from 2 triangles each
			
			// top layer
			
			var len:int = go.surfacePointsList0.length;

			go.vertices = new Vector.<Number>();
			go.indices = new Vector.<int>();
			go.uvtData = new Vector.<Number>();

			go.vertices1 = new Vector.<Number>();
			go.indices1 = new Vector.<int>();
			go.uvtData1 = new Vector.<Number>();
			
			var p0:Point = new Point();
			var p1:Point = new Point();
			var p2:Point = new Point();
			var p3:Point = new Point();
			
			var currentVertexIndex:int = 0;
			
			var dobf:DisplayObjFrame = go.dobj3.GetFrame(0);
			
//			dobf.v0 = 0;
//			dobf.v1 = 0.2;
			
			for (var index:int = 0; index < len-1; index++)
			{
				
				p0 = go.surfacePointsList0[index].clone();
				p1 = go.surfacePointsList0[index+1].clone();
				p2 = go.surfacePointsList1[index+1].clone();
				p3 = go.surfacePointsList1[index].clone();

				if (p1.x > p0.x)
				{
					
					go.vertices.push(p0.x);
					go.vertices.push(p0.y);
					go.vertices.push(p1.x);
					go.vertices.push(p1.y);
					go.vertices.push(p2.x);
					go.vertices.push(p2.y);
					go.vertices.push(p3.x);
					go.vertices.push(p3.y);
					
					var vi:int = currentVertexIndex;
					currentVertexIndex += 4;
					go.indices.push(vi+0, vi+1, vi+3, vi+1, vi+2, vi+3);
					
					var sc:Number = 1 / 512;
					var u0:Number = go.surfacePointsList0[index].x * sc;
					var u1:Number = go.surfacePointsList0[index+1].x * sc;
					
					var min:Number = dobf.v0+0.05;
					var max:Number = dobf.v1 - 0.02;
					go.uvtData.push(u0, min, u1, min, u1, max, u0, max);
					
				}
				
			}
			
			
			if (go.surfacePointsList2.length != 0)
			{
			
				currentVertexIndex = 0;
				// bottom part
				for (var index:int = 0; index < len-1; index++)
				{
					
					p0 = go.surfacePointsList2[index].clone();
					p1 = go.surfacePointsList2[index+1].clone();
					p2 = go.surfacePointsList3[index+1].clone();
					p3 = go.surfacePointsList3[index].clone();
					
					go.vertices1.push(p0.x);
					go.vertices1.push(p0.y);
					go.vertices1.push(p1.x);
					go.vertices1.push(p1.y);
					go.vertices1.push(p2.x);
					go.vertices1.push(p2.y);
					go.vertices1.push(p3.x);
					go.vertices1.push(p3.y);
					
					var vi:int = currentVertexIndex;
					currentVertexIndex += 4;
					go.indices1.push(vi+0, vi+1, vi+3, vi+1, vi+2, vi+3);
					
					var sc:Number = 1 / 512;
					var u0:Number = go.surfacePointsList2[index].x * sc;
					var u1:Number = go.surfacePointsList2[index+1].x * sc;
					var u2:Number = go.surfacePointsList3[index+1].x * sc;
					var u3:Number = go.surfacePointsList3[index].x * sc;
					
					var v0:Number = go.surfacePointsList2[index].y * sc;
					var v1:Number = go.surfacePointsList2[index+1].y * sc;
					var v2:Number = go.surfacePointsList3[index+1].y * sc;
					var v3:Number = go.surfacePointsList3[index].y * sc;
					
					go.uvtData1.push(u0, v0, u1, v1, u2, v2, u3, v3);
				}
				
				
			}

			
		}

//-----------------------------------------------------------------------------------------------

		public static function RenderPhysicsLineObject_Surface_PointsList(_go:GameObj)
		{
			go = _go;
			var z:Number = go.camZ;
			
			RenderPhysicsLineObject_Surface_PointsList_Inner_3D(0, 0,5);
			
			go.camZ = z;
		}
		
//---------------------------------------------------------------------------------------------------		
		
		static function RenderPhysicsLineObject_Surface_PointsList_Inner_3D(_offsetX:Number, _offsetY:Number,hack:int)
		{
			
			go.frame = Game.currentBackground;

			var camScale:Number = 1;
			var zp:Number = go.camZ - Game.camera.z;
			if (zp != 0)
			{
				camScale= 1/Game.camera.PerspectiveTransformGetScale(zp);
			}
			
			var p0:Point = new Point();
			var p1:Point = new Point();
			var p2:Point = new Point();
			var p3:Point = new Point();
			
			Game.camera.PerspectiveTransform(0, Defs.displayarea_h, zp);
			var bottom:int = Game.camera.transformY;
			
			var xp:Number;
			var yp:Number;
			xp = Math.round(Game.camera.x);
			yp = Math.round(Game.camera.y);
			
			xp += _offsetX;
			yp += _offsetY;
			
			var len:int = go.surfacePointsList2.length;
			var foundA:Boolean= false;
			var foundB:Boolean = false;

			
			
			
			var x0:int = 0;	// Game.camera.x;
			var x1:int = Defs.displayarea_w;	// x0 + Defs.displayarea_w;

			var firstIndex:int = 0;
			var lastIndex:int = 100;
			
			var centreIndex:int = len / 2;
			var current:int = 0;
			var lookRight:Boolean = true;
			
			for (var i:int = 0; i < len; i++)
			{
				
				var zp:Number = go.camZ - Game.camera.z;
				Game.camera.PerspectiveTransform(go.surfacePointsList2[i].x-Game.camera.x,0,zp);
				var px:Number = Game.camera.transformX;
				
				
				if (foundA == false)
				{
					if (px > x0)
					{
						foundA = true;
						firstIndex = i - 1;
					}
				}
				if (foundB == false)
				{
					if (px > x1)
					{
						foundB = true;
						lastIndex = i;
					}
				}
			}
//			trace("len " + len + "   " + firstIndex + "  " + lastIndex);
			
				
			firstIndex = Utils.LimitNumber(0, len - 1, firstIndex);
			lastIndex = Utils.LimitNumber(0, len - 1, lastIndex);
			
			firstIndex--;
			if (firstIndex < 0) firstIndex = 0;
			
//			lastIndex--;
			
			if (firstIndex >= lastIndex)
			{
				return;
			}
			if (lastIndex >= go.surfacePointsList2.length)
			{
				return;
			}
			
			
			var firstIndex0:int = firstIndex*6;
			var firstIndex1:int = firstIndex*8;
			var lastIndex0:int = lastIndex*6;
			var lastIndex1:int = lastIndex*8;
			
			
			var vertlen:int = go.vertices.length / 2;
			var vertlen1:int = go.vertices1.length / 2;
			var index:int = 0;
			
			// translate all vertices to camera pos

			
			var oldVertices:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i < go.vertices.length; i+=2)
			{
				oldVertices[i] = go.vertices[i];
				oldVertices[i+1] = go.vertices[i+1];
				Game.camera.PerspectiveTransform(go.vertices[i]-Game.camera.x, go.vertices[i + 1]-Game.camera.y, go.camZ-Game.camera.z);
				
				go.vertices[i] = Game.camera.transformX;
				go.vertices[i + 1] = Game.camera.transformY;
			}
			
			var newIndices:Vector.<int> = new Vector.<int>();
			var newIndex:int = 0;
			
			
			for (var i:int = firstIndex0; i < lastIndex0; i++)
			{
				if (i < go.indices.length)
				{
					var ind:int = go.indices[i];
					newIndices[newIndex++] = ind;
				}
			}

			var g:Graphics = go.fillScreenMC.graphics;
			g.clear();
			
			
			var camScale1:Number = 1 / camScale;
			
			g.lineStyle(null,null,0);			
			g.beginBitmapFill(go.dobj3.GetBitmapData(go.frame),null, true);			
			g.drawTriangles(go.vertices, newIndices, go.uvtData);			
			g.endFill();				
			
			
			// bottom
			go.gmat.identity();
			go.gmat.translate(-Game.camera.x+(Defs.displayarea_w2*camScale),-Game.camera.y+(Defs.displayarea_h2*camScale));
			go.gmat.scale(camScale1,camScale1);
			g.lineStyle(null, null, 0);			
			g.beginBitmapFill(go.dobj.GetBitmapData(go.frame), go.gmat, true);	
			
			
			bottom= 800;
			if (hack == 1) bottom = 50;
			if (hack == 2) bottom = 100;
			if (hack == 3) bottom = 200;
			if (hack == 4) bottom = 300;
			if (hack == 5) bottom = 400;
			
			p0 = go.surfacePointsList2[firstIndex];
			MoveTo(g, p0);
			for (var index:int = firstIndex; index <= lastIndex; index++)
			{
				p0 = go.surfacePointsList2[index];
				MoveTo(g, p0,true);
				
			}
			p0 = go.surfacePointsList3[lastIndex];
			var pp:Point = new Point(p0.x, p0.y+bottom);
			MoveTo(g, pp,true);
//			g.lineTo(p0.x-xp, bottom);
			p0 = go.surfacePointsList3[firstIndex];
			var pp:Point = new Point(p0.x, p0.y+bottom);
			MoveTo(g, pp,true);
//			g.lineTo(p0.x-xp, bottom);
			g.endFill();				
			
			
			/*
			// surface line
			g.lineStyle(hack, 0, 1);
			p0 = go.surfacePointsList2[firstIndex];
			MoveTo(g, p0);
			for (var index:int = firstIndex; index <= lastIndex; index++)
			{
				p0 = go.surfacePointsList2[index];
				MoveTo(g, p0,true);				
			}
			*/
			
			
			go.bd.draw(go.fillScreenMC);	// , null, null, null, bd.rect, false);				
			
			
			
			
			
			// translate all vertices back from camera pos
			for (var i:int = 0; i < go.vertices.length; i+=2)
			{
				go.vertices[i] = oldVertices[i];
				go.vertices[i + 1] = oldVertices[i + 1];
			}

		}

		static function MoveTo(g:Graphics, p:Point, line:Boolean = false)
		{
			var xp:Number =  Math.round(p.x) - Math.round(Game.camera.x);
			var yp:Number =  Math.round(p.y) - Math.round(Game.camera.y);
			var zp:Number = go.camZ - Game.camera.z;
		
			if (zp != 0)
			{
				var camScale:Number = Game.camera.PerspectiveTransform(xp,yp,zp);
				//sc *= camScale;
				xp = Game.camera.transformX;
				yp = Game.camera.transformY;
			}			
			
			
			if (line == false)
			{
				g.moveTo(xp, yp);
			}
			else
			{
				g.lineTo(xp, yp);
			}
		}
		
		
//-------------------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------------------		
		
		static function RenderPhysicsLineObject_Surface_PointsList_Inner(_offsetX:Number, _offsetY:Number)
		{
			
			go.frame = Game.currentBackground;

			var p0:Point = new Point();
			var p1:Point = new Point();
			var p2:Point = new Point();
			var p3:Point = new Point();
			
			var bottom:int = Defs.displayarea_h;
			
			var xp:Number;
			var yp:Number;
			xp = Math.round(Game.camera.x);
			yp = Math.round(Game.camera.y);
			
			xp += _offsetX;
			yp += _offsetY;
			
			var len:int = go.surfacePointsList2.length;
			var foundA:Boolean= false;
			var foundB:Boolean = false;

			var x0:int = Game.camera.x;
			var x1:int = x0 + Defs.displayarea_w;

			var firstIndex:int = 0;
			var lastIndex:int = 100;
			
			var centreIndex:int = len / 2;
			var current:int = 0;
			var lookRight:Boolean = true;
			
			for (var i:int = 0; i < len; i++)
			{
				if (foundA == false)
				{
					if (go.surfacePointsList2[i].x > x0)
					{
						foundA = true;
						firstIndex = i - 1;
					}
				}
				if (foundB == false)
				{
					if (go.surfacePointsList2[i].x > x1)
					{
						foundB = true;
						lastIndex = i;
					}
				}
			}
//			trace("len " + len + "   " + firstIndex + "  " + lastIndex);
			
				
			firstIndex = Utils.LimitNumber(0, len - 1, firstIndex);
			lastIndex = Utils.LimitNumber(0, len - 1, lastIndex);
			
			firstIndex--;
			if (firstIndex < 0) firstIndex = 0;
			
//			lastIndex--;
			
			if (firstIndex >= lastIndex)
			{
				return;
			}
			if (lastIndex >= go.surfacePointsList2.length)
			{
				return;
			}
			
			
			var firstIndex0:int = firstIndex*6;
			var firstIndex1:int = firstIndex*8;
			var lastIndex0:int = lastIndex*6;
			var lastIndex1:int = lastIndex*8;
			
			
			var vertlen:int = go.vertices.length / 2;
			var vertlen1:int = go.vertices1.length / 2;
			var index:int = 0;
			
			// translate all vertices to camera pos
			
			for (var i:int = 0; i < go.vertices.length; i+=2)
			{
				go.vertices[i] -= xp;
				go.vertices[i+1] -= yp;
			}
			
			var newIndices:Vector.<int> = new Vector.<int>();
			var newIndex:int = 0;
			
			
			for (var i:int = firstIndex0; i < lastIndex0; i++)
			{
				if (i < go.indices.length)
				{
					var ind:int = go.indices[i];
					newIndices[newIndex++] = ind;
				}
			}

			var g:Graphics = go.fillScreenMC.graphics;
			g.clear();
			
			
			
			g.lineStyle(null, null, 0);			
			g.beginBitmapFill(go.dobj3.GetBitmapData(go.frame),null, true);			
			g.drawTriangles(go.vertices, newIndices, go.uvtData);			
			g.endFill();				
			
			// bottom
			go.gmat.identity();
			go.gmat.translate(-xp,-yp);
			g.lineStyle(null, null, 0);			
			g.beginBitmapFill(go.dobj.GetBitmapData(go.frame), go.gmat, true);	
			
			
			p0 = go.surfacePointsList2[firstIndex];
			g.moveTo(p0.x-xp, p0.y-yp);
			for (var index:int = firstIndex; index <= lastIndex; index++)
			{
				p0 = go.surfacePointsList2[index];
				g.lineTo(p0.x-xp, p0.y-yp);
				
			}
			p0 = go.surfacePointsList3[lastIndex];
			g.lineTo(p0.x-xp, bottom);
			p0 = go.surfacePointsList3[firstIndex];
			g.lineTo(p0.x-xp, bottom);
			g.endFill();				
						
			go.bd.draw(go.fillScreenMC);	// , null, null, null, bd.rect, false);				
			
			
			// translate all vertices back from camera pos
			for (var i:int = 0; i < go.vertices.length; i+=2)
			{
				go.vertices[i] += xp;
				go.vertices[i+1] += yp;
			}

		}
		
		

//-------------------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------------------		

//-----------------------------------------------------------------------------------------------

		public static function RenderPhysicsLineObject_SurfacePoly_PointsList(_go:GameObj)
		{
			go = _go;
			RenderPhysicsLineObject_SurfacePoly_PointsList_Inner(0, 0);
		}
		
//---------------------------------------------------------------------------------------------------		
		
		static function RenderPhysicsLineObject_SurfacePoly_PointsList_Inner(_offsetX:Number, _offsetY:Number)
		{
			go.frame = Game.currentBackground;

			var p0:Point = new Point();
			var p1:Point = new Point();
			var p2:Point = new Point();
			var p3:Point = new Point();
			
			var bottom:int = Defs.displayarea_h;
			
			var xp:Number;
			var yp:Number;
			xp = Math.round(Game.camera.x);
			yp = Math.round(Game.camera.y);
			
			xp += _offsetX;
			yp += _offsetY;
			
			
			var vertlen:int = go.vertices.length / 2;
			var vertlen1:int = go.vertices1.length / 2;
			var index:int = 0;
			
			// translate all vertices to camera pos
			index = 0;
			for (var i:int = 0; i < vertlen; i++)
			{
				go.vertices[index++] -= xp;
				go.vertices[index++] -= yp;
			}
			index = 0;
			for (var i:int = 0; i < vertlen1; i++)
			{
				go.vertices1[index++] -= xp;
				go.vertices1[index++] -= yp;
			}
			

			var g:Graphics = go.fillScreenMC.graphics;
			g.clear();
			
			g.lineStyle(null, null, 0);			
			g.beginBitmapFill(go.dobj3.GetBitmapData(go.frame),null, true);			
			g.drawTriangles(go.vertices, go.indices, go.uvtData);			
			g.endFill();				
			

			go.gmat.identity();
			go.gmat.translate(-xp,-yp);
			g.lineStyle(null, null, 0);			
			g.beginBitmapFill(go.dobj.GetBitmapData(go.frame), go.gmat, true);	
			
			p0 = go.surfacePointsList4[0];
			g.moveTo(p0.x-xp, p0.y-yp);
			for (var index:int = 0; index < go.surfacePointsList4.length; index++)
			{
				p0 = go.surfacePointsList4[index];
				g.lineTo(p0.x-xp, p0.y-yp);
				
			}
			g.endFill();				
			

			go.bd.draw(go.fillScreenMC);
			
			// translate all vertices back from camera pos
			index = 0;
			for (var i:int = 0; i < vertlen; i++)
			{
				go.vertices[index++] += xp;
				go.vertices[index++] += yp;
			}
			index = 0;
			for (var i:int = 0; i < vertlen1; i++)
			{
				go.vertices1[index++] += xp;
				go.vertices1[index++] += yp;
			}
		}

//-------------------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------------------		
		

		if (PROJECT::useStage3D)
		{

			public static function PreRenderPhysicsLineObject_Surface_Stage3D(_go:GameObj)
			{
				go = _go;
				
				PreRenderPhysicsLineObject_Surface_PointsList(go);
				
				// poly data now stored in these lists in the GO:
				//var vertices:Vector.<Number>;
				//var indices:Vector.<int>;
				//var uvtData:Vector.<Number>;
				// translate that in to s3d stuff, single triangle list and uv list:
				
				go.surfaceSegmentList0 = new Array();
				go.surfaceSegmentList1 = new Array();
				go.surfaceSegmentList2 = new Array();
				go.surfaceSegmentMinMaxXList = new Array();
				
				var triangleList:Array = new Array();
				var uvList:Array = new Array();
			
				var tricount:int = go.indices.length / 3;
				for (var t:int = 0; t < tricount; t++)
				{
					var vindex0:int = go.indices[(t*3)+0];
					var vindex1:int = go.indices[(t*3)+1];
					var vindex2:int = go.indices[(t*3) + 2];
					
					triangleList.push( new Point( go.vertices[ (vindex0 * 2) +0 ], go.vertices[ (vindex0 * 2) +1 ]));
					triangleList.push( new Point( go.vertices[ (vindex1 * 2) +0 ], go.vertices[ (vindex1 * 2) +1 ]));
					triangleList.push( new Point( go.vertices[ (vindex2 * 2) +0 ], go.vertices[ (vindex2 * 2) +1 ]));
					
					uvList.push( new Point( go.uvtData[ (vindex0 * 2) +0 ], go.uvtData[ (vindex0 * 2) +1 ]));
					uvList.push( new Point( go.uvtData[ (vindex1 * 2) +0 ], go.uvtData[ (vindex1 * 2) +1 ]));
					uvList.push( new Point( go.uvtData[ (vindex2 * 2) +0 ], go.uvtData[ (vindex2 * 2) +1 ]));
				}
				go.s3dTriListIndex = s3d.MakeIndieTriangleList(triangleList, uvList);
				go.surfaceSegmentList0.push(go.s3dTriListIndex);
				

				var triangleList:Array = new Array();
				var uvList:Array = new Array();
				
				var tricount1:int = go.indices1.length / 3;
				for (var t:int = 0; t < tricount1; t++)
				{
					var vindex0:int = go.indices1[(t*3)+0];
					var vindex1:int = go.indices1[(t*3)+1];
					var vindex2:int = go.indices1[(t*3) + 2];
					
					triangleList.push( new Point( go.vertices1[ (vindex0 * 2) +0 ], go.vertices1[ (vindex0 * 2) +1 ]));
					triangleList.push( new Point( go.vertices1[ (vindex1 * 2) +0 ], go.vertices1[ (vindex1 * 2) +1 ]));
					triangleList.push( new Point( go.vertices1[ (vindex2 * 2) +0 ], go.vertices1[ (vindex2 * 2) +1 ]));
					
					uvList.push( new Point( go.uvtData1[ (vindex0 * 2) +0 ], go.uvtData1[ (vindex0 * 2) +1 ]));
					uvList.push( new Point( go.uvtData1[ (vindex1 * 2) +0 ], go.uvtData1[ (vindex1 * 2) +1 ]));
					uvList.push( new Point( go.uvtData1[ (vindex2 * 2) +0 ], go.uvtData1[ (vindex2 * 2) +1 ]));
				}
				go.s3dTriListIndex1 = s3d.MakeIndieTriangleList(triangleList, uvList);
				go.surfaceSegmentList1.push(go.s3dTriListIndex1);
				
				
			}
			public static function PreRenderPhysicsLineObject_SurfacePoly_Stage3D(_go:GameObj)
			{
				go = _go;
				
				PreRenderPhysicsLineObject_SurfacePoly_PointsList(go);
				
				// poly data now stored in these lists in the GO:
				//var vertices:Vector.<Number>;
				//var indices:Vector.<int>;
				//var uvtData:Vector.<Number>;
				// translate that in to s3d stuff, single triangle list and uv list:
				
				go.surfaceSegmentList0 = new Array();
				go.surfaceSegmentList1 = new Array();
				go.surfaceSegmentList2 = new Array();
				go.surfaceSegmentMinMaxXList = new Array();
				
				var triangleList:Array = new Array();
				var uvList:Array = new Array();
			
				var tricount:int = go.indices.length / 3;
				for (var t:int = 0; t < tricount; t++)
				{
					var vindex0:int = go.indices[(t*3)+0];
					var vindex1:int = go.indices[(t*3)+1];
					var vindex2:int = go.indices[(t*3) + 2];
					
					triangleList.push( new Point( go.vertices[ (vindex0 * 2) +0 ], go.vertices[ (vindex0 * 2) +1 ]));
					triangleList.push( new Point( go.vertices[ (vindex1 * 2) +0 ], go.vertices[ (vindex1 * 2) +1 ]));
					triangleList.push( new Point( go.vertices[ (vindex2 * 2) +0 ], go.vertices[ (vindex2 * 2) +1 ]));
					
					uvList.push( new Point( go.uvtData[ (vindex0 * 2) +0 ], go.uvtData[ (vindex0 * 2) +1 ]));
					uvList.push( new Point( go.uvtData[ (vindex1 * 2) +0 ], go.uvtData[ (vindex1 * 2) +1 ]));
					uvList.push( new Point( go.uvtData[ (vindex2 * 2) +0 ], go.uvtData[ (vindex2 * 2) +1 ]));
				}
				go.s3dTriListIndex = s3d.MakeIndieTriangleList(triangleList, uvList);
				go.surfaceSegmentList0.push(go.s3dTriListIndex);
				
				TriangulatePointList(go.surfacePointsList4);

				/*
				var triangleList:Array = new Array();
				var uvList:Array = new Array();
				
				var tricount1:int = go.indices1.length / 3;
				for (var t:int = 0; t < tricount1; t++)
				{
					var vindex0:int = go.indices1[(t*3)+0];
					var vindex1:int = go.indices1[(t*3)+1];
					var vindex2:int = go.indices1[(t*3) + 2];
					
					triangleList.push( new Point( go.vertices1[ (vindex0 * 2) +0 ], go.vertices1[ (vindex0 * 2) +1 ]));
					triangleList.push( new Point( go.vertices1[ (vindex1 * 2) +0 ], go.vertices1[ (vindex1 * 2) +1 ]));
					triangleList.push( new Point( go.vertices1[ (vindex2 * 2) +0 ], go.vertices1[ (vindex2 * 2) +1 ]));
					
					uvList.push( new Point( go.uvtData1[ (vindex0 * 2) +0 ], go.uvtData1[ (vindex0 * 2) +1 ]));
					uvList.push( new Point( go.uvtData1[ (vindex1 * 2) +0 ], go.uvtData1[ (vindex1 * 2) +1 ]));
					uvList.push( new Point( go.uvtData1[ (vindex2 * 2) +0 ], go.uvtData1[ (vindex2 * 2) +1 ]));
				}
				go.s3dTriListIndex1 = s3d.MakeIndieTriangleList(triangleList, uvList);
				go.surfaceSegmentList1.push(go.s3dTriListIndex1);
				*/
				
			}
		}
//---------------------------------------------

		if (PROJECT::useStage3D)
		{
			public static function RenderPhysicsLineObject_Surface_Stage3D(_go:GameObj)
			{
				go = _go;
				var z:Number = go.camZ;
				
				go.camZ += 1000;			
				RenderPhysicsLineObject_Surface_Stage3D_Inner(0, -40,1);
				go.camZ -= 250;
				RenderPhysicsLineObject_Surface_Stage3D_Inner(0, -30,2);
				go.camZ -= 250;
				RenderPhysicsLineObject_Surface_Stage3D_Inner(0, -20,3);
				go.camZ -= 250;
				RenderPhysicsLineObject_Surface_Stage3D_Inner(0, -10,4);
				go.camZ -= 250;			
				RenderPhysicsLineObject_Surface_Stage3D_Inner(0, 0,5);
				
				go.camZ = z;
				
			}
			public static function RenderPhysicsLineObject_Surface_Stage3D_Inner(_offsetX:Number, _offsetY:Number,hack:int)
			{
				
				go.frame = Game.currentBackground;
				
				var camScale:Number = 1;
				var zp:Number = go.camZ - Game.camera.z;
				if (zp != 0)
				{
					camScale= 1/Game.camera.PerspectiveTransformGetScale(zp);
				}
				
				
				var x:Number = Math.round(go.xpos);
				var y:Number =  Math.round(go.ypos);
				x = Math.round(Game.camera.x);
				y = Math.round(Game.camera.y);
				
				var cx:int = Game.camera.x;
				var cy:int = Game.camera.y;
				
				
				
				
				var zp:Number = go.camZ - Game.camera.z;
			var xp:Number = 0;
			var yp:Number = 0;
				
				if (zp != 0)
				{
					Game.camera.PerspectiveTransform(-Defs.displayarea_w2,-Defs.displayarea_h2,zp);
					//sc *= camScale;
					xp = Game.camera.transformX;
					yp = Game.camera.transformY;
				}			
				
				var camScale1:Number = 1 / camScale;
				
				var render:int = 0;
				var skip:int = 0;
				
				s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);

				var triList:s3dTriList = s3d.triangleLists[go.surfaceSegmentList0[i]];
				
				/*
				for (var i:int = 0; i < go.surfaceSegmentList0.length; i++)
				{
					var triList:s3dTriList = s3d.triangleLists[go.surfaceSegmentList0[i]];
					
					go.m3d.identity();
					go.m3d.appendTranslation( -x, -y, 0);
//					go.m3d.appendTranslation( -triList.cx*camScale,-triList.cy*camScale, 0);
					go.m3d.appendScale(camScale1, camScale1, 1);
//					go.m3d.appendTranslation( triList.cx*camScale,triList.cy*camScale, 0);
					
					s3d.RenderPreUploadedTriangleList1(-x,-y,go.m3d, go.dobj3.GetTexture(go.frame), triList);
				}
				*/
				
				for (var i:int = 0; i < go.surfaceSegmentList1.length; i++)
				{
					var triList1:s3dTriList = s3d.triangleLists[go.surfaceSegmentList1[i]];

					go.m3d.identity();
					go.m3d.appendTranslation((Defs.displayarea_w2*camScale),(Defs.displayarea_h2*camScale),0);
					go.m3d.appendTranslation( -x, -y, 0);
					go.m3d.appendScale(camScale1, camScale1, 1);
					go.m3d.appendTranslation(-(Defs.displayarea_w2*camScale1),-(Defs.displayarea_h2*camScale1),0);
					
					s3d.RenderPreUploadedTriangleList1(-x,-y,go.m3d, go.dobj.GetTexture(go.frame), triList1);
				}
				
				s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);
				
			}

			public static function RenderPhysicsLineObject_SurfacePoly_Stage3D(_go:GameObj)
			{
				go = _go;
				
				go.frame = Game.currentBackground;
				
				
				var x:Number = Math.round(go.xpos);
				var y:Number =  Math.round(go.ypos);
				x = Math.round(Game.camera.x);
				y = Math.round(Game.camera.y);
				
				var cx:int = Game.camera.x;
				var cy:int = Game.camera.y;
				
				
				go.m3d.identity();
				go.m3d.appendTranslation( -x, -y, 0);
				
				var render:int = 0;
				var skip:int = 0;
				
				s3d.SetCurrentBlendMode(s3d.BLENDMODE_SOLID);
				s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);

				var triList:s3dTriList = s3d.triangleLists[go.surfaceSegmentList0[i]];

				
				for (var i:int = 0; i < go.surfaceSegmentList0.length; i++)
				{
					var triList:s3dTriList = s3d.triangleLists[go.surfaceSegmentList0[i]];
					s3d.RenderPreUploadedTriangleList1(-x,-y,go.m3d, go.dobj3.GetTexture(go.frame), triList);
				}
				
				go.m3d.identity();
				go.m3d.appendTranslation( -x, -y, 0);
				var triList:s3dTriList = s3d.triangleLists[go.s3dTriListIndex];

				s3d.RenderPreUploadedTriangleList1(-x,-y,go.m3d, go.dobj.GetTexture(go.frame), triList);
				
				
				s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);
				
			}
		
			static function TriangulatePointList(pts: Vector.<Point>)
			{
				var line:EdLine = new EdLine();
				for each(var p:Point in pts)
				{
					line.AddPoint(p.x, p.y);
				}
				
				line.DoTriangulation();
				line.CalcBoundingRectangle();			
				
				go.s3dTriListIndex = s3d.MakeIndieTriangleList(line.triangleList, line.uvList);
				
				
			}
		}
		

	}

}