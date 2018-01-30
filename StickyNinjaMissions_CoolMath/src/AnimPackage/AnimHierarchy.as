package AnimPackage
{
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class AnimHierarchy 
	{
		var dobj:DisplayObj;
		var frames:Vector.<AnimHierarchyFrame> = null;
		var vertexBufferIndex:int;
		
		public function AnimHierarchy() 
		{
			

		}
		
		static var m:Matrix = new Matrix();
		static var p:Point = new Point(0, 0);
		static var p1:Point = new Point(0, 0);
		
		
		public function CreateSeparates(x:Number, y:Number, frame:Number, scale:Number, rot:Number, xflip:Boolean = false):Array
		{
			var goList:Array = new Array();
			if (frames == null) return null;
			var f:AnimHierarchyFrame = frames[int(frame)];
			
			for (var pcount:int = 0; pcount < f.parts.length; pcount++)
			{
				var part:AnimHierarchyFramePart = f.parts[pcount];
				if (part.visible)
				{
					
					
					p.x = (part.x*scale);
					p.y = (part.y * scale);

					//if (needToTransform)
					//{
						m.identity();
						m.rotate(rot);
						p = m.transformPoint(p);
					//}
					
					var xpos:Number = x + p.x;
					var ypos:Number = y + p.y;
					
					var r:Number = rot + Utils.DegToRad(part.r_degrees);
					
					var go:GameObj = GameObjects.AddObj(xpos, ypos, 0);
					go.dobj = part.dobj;
					go.frame = part.frame;
					go.scale = scale;
					go.dir = r;
					goList.push(go);
					
				}
			}		
			return goList;
		}
		
		public function RenderAt(bd:BitmapData,x:Number, y:Number,frame:Number,scale:Number,rot:Number,xflip:Boolean=false,_vector:Boolean = false)
		{
			
			if (frames == null) return;
			var f:AnimHierarchyFrame = frames[int(frame)];
			var _smooth:Boolean = true;

			if (PROJECT::useStage3D)
			{
				_smooth = false;
			}
			//_vector = true;
			
			var needToTransform:Boolean = false;
			if (rot != 0) needToTransform = true;
			
			
			/*
			var clip:Boolean = false;
			if (dobj != null)
			{
				var w:Number = dobj.GetWidth(frame) * scale;
				var h:Number = dobj.GetHeight(frame) * scale;
				
				if (x > Defs.displayarea_w + w) clip = true;
				if (x <  - w) clip = true;
				if (y > Defs.displayarea_h + h) clip = true;
				if (y < - h) clip = true;
			}
			else
			{
				if (x > Defs.displayarea_w+100) clip = true;
				if (x < - 100) clip = true;
				if (y> Defs.displayarea_h+100) clip = true;
				if (y < - 100) clip = true;
			}

			if (clip)
			{
				GameVars.numHierarchiesClipped++;
				return;
			}
			else
			{
				GameVars.numHierarchiesRendered++;
			}
			*/
			
			m.identity();
			m.rotate(rot);
			
			var offset:Number = 0;
			if (frame != int(frame))
			{
				offset = frame-Math.floor(frame);
			}
			
			// no interpolation!
			offset = 0;
			

			
			var nextf:int = frame + 1;
			if (nextf >= frames.length) nextf = frame;
			var f1:AnimHierarchyFrame = frames[int(nextf)];
			
			for (var pcount:int = 0; pcount < f.parts.length; pcount++)
			{
				var part:AnimHierarchyFramePart = f.parts[pcount];
				var part1:AnimHierarchyFramePart = f1.parts[pcount];
				if (part.visible)
				{
					var interpAmt:Number = offset;
					if (part.interpolate == false)
					{
						interpAmt = 0;
					}
					
					
					p.x = (part.x*scale);
					p.y = (part.y * scale);
					
					
					//p1.x = (part1.x*scale);
					//p1.y = (part1.y * scale);
					
					//p.x = Utils.ScaleTo(p.x, p1.x, 0, 1, interpAmt);
					//p.y = Utils.ScaleTo(p.y, p1.y, 0, 1, interpAmt);
					
					if (needToTransform)
					{
						p = m.transformPoint(p);
					}
					
					part.transformedX = p.x;
					part.transformedY = p.y;
					
					var xpos:Number = x + p.x;
					var ypos:Number = y + p.y;

					
					var r:Number = rot + Utils.DegToRad(part.r_degrees);
					//var r1:Number = rot + Utils.DegToRad(part1.r);
					//r = Utils.ScaleTo(r,r1, 0, 1, interpAmt);
					
					if (xflip)
					{
						xpos = ( x  ) - p.x;
					}
					
					if (_vector)
					{
						part.dobj.RenderAtRotScaled_Vector(part.frame, bd, xpos, ypos, scale*part.scale, r,part.colorTransform,true,xflip);					
					}
					else
					{
						if (xflip == false)
						{
							part.dobj.RenderAtRot(part.frame, bd, xpos, ypos, r, part.colorTransform, _smooth);
							//part.dobj.RenderAtRotScaled(part.frame, bd, xpos, ypos, scale * part.scale, r, part.colorTransform, _smooth);
						}
						else
						{
							part.dobj.RenderAtRot_Xflip(part.frame, bd, xpos, ypos, r, part.colorTransform, _smooth);
						}
					}
				}
			}		
		}
		
		
		function ForAllPartsMatchingGame(partName:String, fn:Function)
		{
			for each(var f:AnimHierarchyFrame in frames)
			{
				for each(var p:AnimHierarchyFramePart in f.parts)
				{
					if (p.partName == partName)
					{
						fn(p);
					}
				}
			}
		}

		
		function Frame_ForAllPartsMatchingGame(partName:String, frame:int,fn:Function)
		{
			var f:AnimHierarchyFrame = frames[frame];
			for each(var p:AnimHierarchyFramePart in f.parts)
			{
				if (p.partName == partName)
				{
					fn(p);
				}
			}
		}
	
		public function SetPartRot(partName:String,rot:Number)
		{
			ForAllPartsMatchingGame(partName, function(p:AnimHierarchyFramePart) { p.r_degrees = rot; } );
		}

		public function Frame_SetPartRot(partName:String, frame:int, _rot:Number):Number
		{
			var f:AnimHierarchyFrame = frames[frame];
			var oldR:Number = 0;
			
			for each(var p:AnimHierarchyFramePart in f.parts)
			{
				if (p.partName == partName)
				{
					oldR = p.r_degrees;
					p.r_degrees = _rot;
					return oldR;
				}
			}
			return oldR;
		}

		public function Frame_SetPartOriginalRot(partName:String, frame:int):Number
		{
			var f:AnimHierarchyFrame = frames[frame];
			var oldR:Number = 0;
			
			for each(var p:AnimHierarchyFramePart in f.parts)
			{
				if (p.partName == partName)
				{
					oldR = p.r_degrees;
					p.r_degrees = p.r_degrees_original;
					return oldR;
				}
			}
			return oldR;
		}
		
		
		public function SetPartColourTransform(partName:String,_ct:ColorTransform)
		{
			ForAllPartsMatchingGame(partName, function(p:AnimHierarchyFramePart) { p.colorTransform = _ct; } );
		}
		public function SetPartsListFrame(partNames:String, frame:int)
		{
			var a:Array = partNames.split(",");
			for each(var s:String in a)
			{
				SetPartFrame(s, frame);
			}
		}
		public function SetPartFrame(partName:String,frame:int)
		{
			ForAllPartsMatchingGame(partName, function(p:AnimHierarchyFramePart) { p.frame = frame; } );
		}
		public function SetPartScale(partName:String,scale:Number)
		{
			ForAllPartsMatchingGame(partName, function(p:AnimHierarchyFramePart) { p.scale = scale; } );
		}
		public function SetPartVisible(partName:String,visible:Boolean)
		{
			ForAllPartsMatchingGame(partName, function(p:AnimHierarchyFramePart) { p.visible = visible; } );
		}
		public function SetPartInterpolate(partName:String,interpolate:Boolean)
		{
			ForAllPartsMatchingGame(partName, function(p:AnimHierarchyFramePart) { p.interpolate = interpolate; } );
		}
		
		public function SetPartDobjName(partName:String,dobjName:String)
		{
			ForAllPartsMatchingGame(partName, function(p:AnimHierarchyFramePart) 
			{ 
				p.dobjName = dobjName;
				p.dobj = GraphicObjects.GetDisplayObjByName(dobjName);
			} );
		}
		
		
		
		public function Clone():AnimHierarchy
		{
			var h:AnimHierarchy = new AnimHierarchy();
			h.dobj = dobj;
			h.frames = new Vector.<AnimHierarchyFrame>();
			for each(var f:AnimHierarchyFrame in frames)
			{
				h.frames.push(f.Clone());
			}
			return h;
		}
		
		public function Init(_dobj:DisplayObj,origMC:MovieClip,limb_preface:String,parts:Array,clips:Array)
		{
			dobj = _dobj;
			frames = new Vector.<AnimHierarchyFrame>();
			
			var mc:MovieClip = origMC;
			var totalFrames:int = mc.totalFrames;
			mc.gotoAndStop(1);
			for (var i:int = 1; i <= totalFrames; i++)
			{
				
				var f:AnimHierarchyFrame = new AnimHierarchyFrame();
				
				var partIndex:int = 0;
				for each(var partName:String in parts)
				{
					var arr:Array = partName.split(".");
					
					var partMC:MovieClip = mc;
					var x:Number = 0;
					var y:Number = 0;
					var r:Number = 0;
					var sc:Number = 1;
					for each(var p:String in arr)
					{
						if (partMC == null)
						{
							
						}
						else
						{
							partMC = partMC.getChildByName(p) as MovieClip;
							
							if (partMC == null)
							{
								Utils.traceerror("Hierachy: missing part " + p+"   "+limb_preface);
							}
							else
							{
							
								
								partMC.gotoAndStop(1);
								var pt:Point = new Point(partMC.x, partMC.y);
								var m:Matrix = new Matrix();
								m.identity();
								m.rotate(Utils.DegToRad(r));
								m.scale(sc, sc);
								pt = m.transformPoint(pt);
								
								x += ((pt.x) * sc);
								y += ((pt.y) * sc);
								r += partMC.rotation;
								sc *= partMC.scaleX;
							}
						}
						
					}
					
					
					var parentPart:AnimHierarchyFramePart = null;
					var part:AnimHierarchyFramePart = new AnimHierarchyFramePart();
					
					part.x = x;
					part.y = y;
					part.r_degrees = r;
					part.r_degrees_original = r;
					part.scale = sc;
					
					var clipName:String = clips[partIndex];
					clipName = clipName.replace("XXX", limb_preface);
					
					part.dobjName = clipName;
					
					part.partName = parts[partIndex];
					
					part.dobj = GraphicObjects.GetDisplayObjByName(part.dobjName);
					
//					trace(int(i)+" " + part.partName + ":  " + part.x + "   " + part.y + "     " + part.r);
					
					partIndex++;
					f.parts.push(part);
				}
				
				mc.nextFrame();
//				trace( "num parts: " + f.parts.length);
				frames.push(f);
			}
//			trace( "num frames: " + frames.length);
			
		}
		
		
		public function MakeVertexBuffersForAnimation()
		{
			return;
			if (PROJECT::useStage3D)
			{
			
				dobj = frames[0].parts[0].dobj;
					s3d.StartCreateDobjVertexBuffer();
					
				for (var i:int = 0; i < frames.length; i++)
				{
					var f:AnimHierarchyFrame = frames[i];

					var i0:int = s3d.CreateDobjVertexBuffer_GetCurrentIndex();

					RenderFrameToVertexBuffer(f);
					
					var i1:int = s3d.CreateDobjVertexBuffer_GetCurrentIndex();

					f.vertexBufferStartIndex = i0;
					f.vertexBufferLength = i1 - i0;
					//trace("frame " + i + ":  " + f.vertexBufferStartIndex + " / " + f.vertexBufferLength);
				}
				vertexBufferIndex = s3d.FinishCreateDobjVertexBuffer();
				
				// set vertex buffer indices for each frame: (as all frames are stored as one buffer)
				for (var i:int = 0; i < frames.length; i++)
				{
					var f:AnimHierarchyFrame = frames[i];
					f.vertexBufferIndex = vertexBufferIndex;
				}
			}
		}

		public function RenderFrameToVertexBuffer(f:AnimHierarchyFrame)
		{
			if (PROJECT::useStage3D)
			{

			var x:Number = 0;
			var y:Number = 0;
			var scale:Number = 1;
			var rot:Number = 0;
			
			
			m.identity();
			
			f.vertexBufferStartIndex = 0;
			f.vertexBufferLength = 0;
			
			for (var pcount:int = 0; pcount < f.parts.length; pcount++)
			{
				var part:AnimHierarchyFramePart = f.parts[pcount];
				if (part.visible)
				{
					p.x = (part.x*scale);
					p.y = (part.y * scale);
					
					part.transformedX = p.x;
					part.transformedY = p.y;
					
					var xpos:Number = x + p.x;
					var ypos:Number = y + p.y;

					
					var r:Number = rot + Utils.DegToRad(part.r_degrees);
					
//					if (xflip)
//					{
//						xpos = ( x  ) - p.x;
//					}
					
					var dof:DisplayObjFrame = part.dobj.frames[part.frame];
					dof.AppendToVertexBufferRotScaled(null, xpos, ypos, scale * part.scale, r, part.colorTransform);
				}
			}		
			}
		}
		public function RenderVertexBufferAt(bd:BitmapData,x:Number, y:Number,frame:Number,scale:Number,rot:Number,xflip:Boolean=false)
		{
			if (PROJECT::useStage3D)
			{

			if (frames == null) return;
			var f:AnimHierarchyFrame = frames[int(frame)];
			
			if (f.vertexBufferIndex == -1) return;
		
			
			var m3d:Matrix3D = new Matrix3D();
			m3d.identity();
//			m3d.appendTranslation( -x, -y, 0);
			
			var triList:s3dTriList = s3d.triangleLists[f.vertexBufferIndex];
//			s3d.RenderPreUploadedTriangleList1(x,y,m3d, dobj.GetTexture(0), triList);
			s3d.RenderPreUploadedTriangleList1_WithRange(x,y,m3d, dobj.GetTexture(0), triList,f.vertexBufferStartIndex,f.vertexBufferLength/3);

			}
			
		}
		
		
	}

}

