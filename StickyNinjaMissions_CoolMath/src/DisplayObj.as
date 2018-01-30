package 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import TexturePackage.PreparingModifier;
	import TexturePackage.TexturePages;
	if (PROJECT::useStage3D)
	{
		import flash.display3D.Context3DTextureFormat;
		import flash.display3D.textures.Texture;
	}
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.display.Loader;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import LicPackage.LicDef;
	import TextPackage.BitmapFont;
	import TextPackage.BitmapFontChar;

	


	public class DisplayObj
	{
		static var preDrawQuality:String = StageQuality.BEST;
		
		public var frames:Vector.<DisplayObjFrame>;		
		public var frame:int;
		public var modifier:PreparingModifier;
		public var labels:Vector.<Object>;
		public var name:String;
		public var origMC:MovieClip;
		public var origName:String;
		

		public function Load(x:XML)
		{
			frame = 0;
			modifier = null;	// x.@flags;
			name = x.@name;
			origName = x.@origName;
			origMC = null;
			labels = new Vector.<Object>();
			frames = new Vector.<DisplayObjFrame>();
			
			for (var i:int = 0; i < x.frame.length(); i++)
			{
				var x1:XML = x.frame[i];
				var f:DisplayObjFrame = new DisplayObjFrame();
				f.Load(x1);
				frames.push(f);
				
			}
		}
		public function Save():String
		{
			var s:String = "";
			s += "<object ";
			s += XmlHelper.Attr("flags", 0);
			s += XmlHelper.Attr("name", name);
			s += XmlHelper.Attr("origName", origName);
			
			s += ">\n";
			for each(var dof:DisplayObjFrame in frames)
			{
				s +=dof.Save();
			}
			
			s += "</object>\n";
			
			return s;
		}
		
		public function DisplayObj(mc:MovieClip,scale:Number,_modifier:PreparingModifier,_frameCB:Function=null,_name:String=""):void
		{			
			labels = new Vector.<Object>();
			modifier = _modifier;
			frame = 0;
			
			if (modifier != null && modifier.type == "skip_bitmap_create")
			{
				CreateBitmapsFromMovieClip_Dummy(mc, _modifier,_frameCB,scale,_name);
				name = mc.name;
				
			}
			else
			{
				
				
				if (mc != null) 
				{
					CreateBitmapsFromMovieClip(mc, _modifier,_frameCB,scale,_name);
					name = mc.name;
				}
			}
			origMC = mc;
			origName = _name;
			
		}

		

		public function CreateBitmapFont(bmFont:BitmapFont,_modifier:PreparingModifier) : void
		{
			frames = new Vector.<DisplayObjFrame>();

			modifier = _modifier;
			
			var i:int;
			var j:int;
			var x0:int;
			var y0:int;	
			var mat:Matrix = new Matrix();
			var rect:Rectangle;
			var B:Bitmap;
			var BD:BitmapData;
			
			var fontBD:BitmapData = new BitmapData(bmFont.pageW, bmFont.pageH, true, 0);
			
			if (PROJECT::useStage3D)
			{
				fontBD.drawWithQuality( bmFont.origMovieClip , new Matrix(), null, null, null, true, preDrawQuality);
			}
			else
			{
				Utils.DrawBD(fontBD, bmFont.origMovieClip, null, null, null, null, true,StageQuality.BEST);
//				fontBD.draw(bmFont.origMovieClip, new Matrix(), null, null, null, true);
			}

			
			for (var i:int = 0; i < 512; i++)
			{
				var dof = new DisplayObjFrame();					
				frames.push(dof);
			}
			
			var i:int = 0;
			for each(var bmChar:BitmapFontChar in bmFont.chars)
			{
				var dof = frames[bmChar.id];
				
				dof.xoffset = -4;
				dof.yoffset = -4;
				
				BD = new BitmapData( bmChar.sourceW+8, bmChar.sourceH+8, true, 0 );
				BD.copyPixels(fontBD, new Rectangle(bmChar.sourceX, bmChar.sourceY, bmChar.sourceW, bmChar.sourceH), new Point(3, 3));
				BD.applyFilter(BD, BD.rect, Defs.pointZero, new DropShadowFilter(2, 90, 0, 0.5, 2, 2, 3, 3));
				
				dof.bitmapData = BD;
				
				dof.sourceRect = new Rectangle(0, 0, BD.width, BD.height);
				dof.point = new Point(0, 0);

				var rect:Rectangle = new Rectangle(0, 0, BD.width, BD.height);
				
				dof.modifier = _modifier;
				

				if (PROJECT::useStage3D)
				{
					var w:int = Utils.NearestSuperiorPow2(rect.width);
					var h:int = Utils.NearestSuperiorPow2(rect.height);
					dof.s3dTexture = new s3dTex(null, w, h);
					dof.s3dTexture.texture = s3d.context3D.createTexture(w,h,Context3DTextureFormat.BGRA,false);
					dof.s3dTexture.texture.uploadFromBitmapData(BD);				
					
					//BD.dispose();
					//BD = null;
					
					
					dof.u0 = 0;
					dof.v0 = 0;
					dof.u1 = 1 / Number(w) * rect.width;
					dof.v1 = 1 / Number(h) * rect.height;
					
					dof.MakeVertexBuffer();
				}
				
				BD = null;


				TexturePages.AddDobjFrame(dof);
				
			}
			fontBD.dispose();
			fontBD = null;

		}		
		
		
		public function CreateBitmapsFromMovieClip(mc:MovieClip,_modifier:PreparingModifier,_frameCB:Function=null,scale:Number=1,_name:String="") : void
		{
			
			var scl:Number = 1;

			modifier = _modifier;
			

			
			frames = new Vector.<DisplayObjFrame>();
			var i:int;
			var j:int;
			var x0:int;
			var y0:int;	
			var mat:Matrix = new Matrix();
			var rect:Rectangle;
			var B:Bitmap;
			var BD:BitmapData;
			var B1:Bitmap;
			var BD1:BitmapData;

			mc.gotoAndStop(1);

			
			var totalFrames:int = mc.totalFrames;
			
			
			for(i=0; i<totalFrames; i++)
			{
				if (PROJECT::useStage3D)
				{
				if (modifier.frameList != null)
				{
					if (modifier.frameList.indexOf( int(i + 1) ) == -1)
					{
						continue;
					}
				}
				}
				
				if (_frameCB != null)
				{
					_frameCB(mc);
				}
				if (mc.currentFrameLabel != null)
				{
					var o:Object = new Object();
					o.labelName = mc.currentFrameLabel;
					o.frameIndex = i;
					labels.push(o);
				}
				
				
				var dof:DisplayObjFrame = new DisplayObjFrame();	
				
				dof.CreateFromMC(mc, scale, modifier, this);
				
				frames.push(dof);				
				mc.nextFrame();				
				BD = null;


			}
		}
		
		
		
		
		
		public function CreateBitmapsFromMovieClip_Dummy(mc:MovieClip,_modifier:PreparingModifier,_frameCB:Function=null,scale:Number=1,_name:String="") : void
		{
			modifier = _modifier;
			
		
			if (modifier == null)
			{
				var aa:int = 0;
			}
			
			//flags = 0;
			
			frames = new Vector.<DisplayObjFrame>();
			var i:int;
			var j:int;
			var x0:int;
			var y0:int;	
			var mat:Matrix = new Matrix();
			var rect:Rectangle;
			var B:Bitmap;
			var BD:BitmapData;
			var B1:Bitmap;
			var BD1:BitmapData;

			mc.gotoAndStop(1);

			
			var totalFrames:int = mc.totalFrames;
			
			
			for(i=0; i<totalFrames; i++)
			{
				if (_frameCB != null)
				{
					_frameCB(mc);
				}
				if (mc.currentFrameLabel != null)
				{
					var o:Object = new Object();
					o.labelName = mc.currentFrameLabel;
					o.frameIndex = i;
					labels.push(o);
				}
				
				var dof:DisplayObjFrame = new DisplayObjFrame();	

				dof.point = new Point(0, 0);
				dof.parentDobj = this;
				dof.modifier = modifier;
				
				frames.push(dof);
				
				mc.nextFrame();

			}
		}

		
		public function DisposeOf()
		{
			for each( var f:DisplayObjFrame in frames)
			{
				f.Remove();
			}
			origMC = null;
		}
		
		public function CreateBlankBitmapsFromMovieClip(mc:MovieClip,flags:int,_frameCB:Function=null) : void
		{
			
			frames = new Vector.<DisplayObjFrame>();
			var i:int;
			var j:int;
			var x0:int;
			var y0:int;	
			var mat:Matrix = new Matrix();
			var rect:Rectangle;
			var B:Bitmap;
			var BD:BitmapData;
			var B1:Bitmap;
			var BD1:BitmapData;

			mc.gotoAndStop(1);

			for(i=0; i<mc.totalFrames; i++)
			{
				if (_frameCB != null)
				{
					_frameCB(mc);
				}
				if (mc.currentFrameLabel != null)
				{
					var o:Object = new Object();
					o.labelName = mc.currentFrameLabel;
					o.frameIndex = i;
					labels.push(o);
				}
				
				
				var dof:DisplayObjFrame = new DisplayObjFrame();	

				rect = mc.getRect(null);
				rect.x = Math.floor(rect.x);
				rect.y = Math.floor(rect.y);
				rect.width = Math.ceil(rect.width);
				rect.height = Math.ceil(rect.height);
				
				x0 = rect.left;
				y0 = rect.top;	
				mat.identity();
				mat.translate(-x0, -y0);
				dof.xoffset = Number(x0);
				dof.yoffset = Number(y0);
				
				
				if (mc.width != 0 && mc.height != 0)
				{
					//BD = new BitmapData( (rect.width), (rect.height),true,0 );
					//BD.draw( mc , mat);
					//dof.bitmapData = BD;
					//dof.sourceRect = new Rectangle(0, 0, BD.width, BD.height);
					
					dof.sourceRect = new Rectangle(0, 0, 1, 1);
					dof.bitmapData = null;
				}
				else
				{
//					trace("ERROR: Null bitmap found");
					dof.bitmapData = null;
					dof.sourceRect = new Rectangle(0, 0, 1, 1);
				}
					
				
				dof.point = new Point(0, 0);
				
				frames.push(dof);
				
				mc.nextFrame();
				


			}
		}
		
		public function CreateSingleBitmapdataFrame(frame:int,_frameCB:Function=null) : void
		{
			
			var i:int;
			var j:int;
			var x0:int;
			var y0:int;	
			var mat:Matrix = new Matrix();
			var rect:Rectangle;
			var B:Bitmap;
			var BD:BitmapData;
			var B1:Bitmap;
			var BD1:BitmapData;

			origMC.gotoAndStop(frame+1);

			if (_frameCB != null)
			{
				_frameCB(origMC);
			}
			
			
			var dof:DisplayObjFrame = frames[frame];

			rect = origMC.getRect(null);
			rect.x = Math.floor(rect.x);
			rect.y = Math.floor(rect.y);
			rect.width = Math.ceil(rect.width);
			rect.height = Math.ceil(rect.height);
			
			x0 = rect.left;
			y0 = rect.top;	
			mat.identity();
			mat.translate(-x0, -y0);
			dof.xoffset = Number(x0);
			dof.yoffset = Number(y0);
			
			
			if (origMC.width != 0 && origMC.height != 0)
			{
				BD = new BitmapData( (rect.width), (rect.height),true,0 );
				BD.draw( origMC , mat);
				dof.bitmapData = BD;
				dof.sourceRect = new Rectangle(0, 0, BD.width, BD.height);
			}
			else
			{
//					trace("ERROR: Null bitmap found");
				dof.bitmapData = null;
				dof.sourceRect = new Rectangle(0, 0, 1, 1);
			}
				
			
			dof.point = new Point(0, 0);
		}
		
		
		PROJECT::useStage3D
		{
		public function GetTexture(_frame:int):s3dTex
		{
			var dof:DisplayObjFrame = frames[_frame];
			return dof.s3dTexture;
		}
		}
		public function GetFrame(_frame:int):DisplayObjFrame
		{
			var dof:DisplayObjFrame = frames[_frame];
			return dof;
		}
		public function GetBitmapData(_frame:int):BitmapData
		{
			if (_frame < 0) return null;
			if (_frame >= frames.length) return null;
			var dof:DisplayObjFrame = frames[_frame];
			return dof.bitmapData;
		}
		public function GetSourceRect(_frame:int):Rectangle
		{
			var dof:DisplayObjFrame = frames[_frame];
			return dof.sourceRect;
		}
		public function GetWidth(_frame:int):int
		{
			var dof:DisplayObjFrame = frames[_frame];
			return dof.sourceRect.width;
		}
		public function GetHeight(_frame:int):int
		{
			var dof:DisplayObjFrame = frames[_frame];
			return dof.sourceRect.height;
		}
		public function GetXOffset(_frame:int):Number
		{
			var dof:DisplayObjFrame = frames[_frame];
			return dof.xoffset;
		}
		public function GetXOffsetXF(_frame:int):Number
		{
			var dof:DisplayObjFrame = frames[_frame];
			if (isNaN(dof.xoffsetxf)) return dof.xoffset;
			return dof.xoffsetxf;
		}
		public function GetYOffset(_frame:int):Number
		{
			var dof:DisplayObjFrame = frames[_frame];
			return dof.yoffset;
		}
		
		public function GetNumFrames():int
		{
			return frames.length;
		}
		
		public function GetRandomFrame():int
		{
			return Utils.RandBetweenInt(0, frames.length - 1);
		}
		
		public function GetLabelAtThisFrame(frame:int):String
		{
			for each(var o:Object in labels)
			{
				if(o.frameIndex == frame)
				{
					return o.labelName;
				}
			}
			return "";
		}
		
		public function GetFrameIndexLabel(label:String):int
		{
			for each(var o:Object in labels)
			{
				if (o.labelName == label) 
				{
					return o.frameIndex;
				}
			}
//			Utils.traceerror("Error finding label " + label + " in dobj " + origName);
			return 0;
		}
		public function DoesFrameIndexLabelExist(label:String):Boolean
		{
			for each(var o:Object in labels)
			{
				if (o.labelName == label) 
				{
					return true;
				}
			}
			return false;
		}
		
		
		var mat:Matrix = new Matrix();
		public function RenderAtRotScaled_Vector(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false,xflip:Boolean = false)
		{
			//if (PROJECT::useStage3D) return;
			origMC.gotoAndStop(_frame + 1);			
			mat.identity();
			if (xflip)
			{
				mat.scale( -1, 1);
			}
			mat.rotate(rot);
			mat.scale(renderScale, renderScale);
			mat.translate(xpos, ypos);
			
			
			screenBD.draw( origMC , mat,ct,null,null,_doSmooth);
		}

		
		/*
		var sprite:Sprite = new Sprite();
		public function RenderAtRotScaled_VectorSprite(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false,xflip:Boolean = false)
		{
			origMC.gotoAndStop(_frame + 1);			
			mat.identity();
			if (xflip)
			{
				mat.scale( -1, 1);
			}
			mat.rotate(rot);
			mat.scale(renderScale, renderScale);
			mat.translate(xpos, ypos);
			
			var bd:BitmapData = frames[frame].bitmapData;
			var g:Graphics = sprite.graphics;
			g.clear();
			g.beginBitmapFill(bd);
			g.drawRect(0, 0, bd.width, bd.height);
			g.endFill();
			
			screenBD.draw( sprite , mat,null,null,null,_doSmooth);
		}
		*/
		
		public function RenderAtRotScaled_Graphics(_frame:int, g:Graphics, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false )
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtRotScaled_Graphics(g,xpos,ypos,renderScale,rot,ct,_doSmooth);
		}
		
		
		public function DoesFrameExist(f:int):Boolean
		{
			if (f < 0) return false;
			if (f >= frames.length) return false;
			return true;
		}
		
		public function RenderAtMatrix3D_Vector(_frame:int, screenBD:BitmapData, m:Matrix3D,ct:ColorTransform)
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtMatrix3D_Vector(origMC,_frame,screenBD,m,ct);
		}
		public function RenderAtMatrix3D(_frame:int, screenBD:BitmapData, m:Matrix3D,ct:ColorTransform)
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtMatrix3D(screenBD,m,ct);
		}
		public function RenderFunctionAtMatrix3D(_frame:int, screenBD:BitmapData, m:Matrix3D,ct:ColorTransform,fn_flash:Function = null,fn_air:Function = null):void
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderFunctionAtMatrix3D(screenBD,m,ct,fn_flash,fn_air);
		}
		public function RenderAtRotScaled(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false )
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtRotScaled(screenBD,xpos,ypos,renderScale,rot,ct,_doSmooth);
		}
		public function RenderAtRotScaledQuality(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false ,_quality:String="high")
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtRotScaledQuality(screenBD,xpos,ypos,renderScale,rot,ct,_doSmooth,_quality);
		}
		public function AppendToVertexBufferRotScaled(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false )
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.AppendToVertexBufferRotScaled(screenBD,xpos,ypos,renderScale,rot,ct,_doSmooth);
		}
		public function RenderAtRotScaled_Offset(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,offx:Number,offy:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false )
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtRotScaled_Offset(screenBD,xpos,ypos,offx,offy,renderScale,rot,ct,_doSmooth);
		}
		public function RenderAtRot(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false )
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtRot(screenBD,xpos,ypos,rot,ct,_doSmooth);
		}
		public function RenderAtRot_Xflip(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false )
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtRot_Xflip(screenBD,xpos,ypos,rot,ct,_doSmooth);
		}
		public function RenderAtRotScaled_Xflip(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false )
		{
			var dof:DisplayObjFrame = frames[_frame];
			
			dof.RenderAtRotScaled_Xflip(screenBD,xpos,ypos,renderScale,rot,ct,_doSmooth);
		}
		public function RenderAtRotScaledWithOffset(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false ,offsetX:Number=0,offsetY:Number=0)
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtRotScaledWithOffset(screenBD,xpos,ypos,renderScale,rot,ct,_doSmooth,offsetX,offsetY);
		}

		public function RenderAtRotScaledAdditive(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false )
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtRotScaledAdditive(screenBD,xpos,ypos,renderScale,rot,ct,_doSmooth);
		}

		public function RenderAtRotScaledLayer(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false )
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtRotScaledLayer(screenBD,xpos,ypos,renderScale,rot,ct,_doSmooth);
		}

		public function RenderAtRotScaledOverlay(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false )
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtRotScaledOverlay(screenBD,xpos,ypos,renderScale,rot,ct,_doSmooth);
		}
		
		public function RenderAt(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number)
		{
			if (_frame >= frames.length)
			{
				return;
			}
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAt(screenBD, xpos, ypos);
		}
		public function RenderAtXFlip(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number)
		{
			var dof:DisplayObjFrame = frames[_frame];
			dof.RenderAtXFlip(screenBD, xpos, ypos);
		}

		
		
		public function HitTestRotScaled(_frame:int, screenBD:BitmapData, xpos:Number, ypos:Number,renderScale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false ):Boolean
		{
			var dof:DisplayObjFrame = frames[_frame];
			return dof.HitTestRotScaled(screenBD,xpos,ypos,renderScale,rot,ct,_doSmooth);
		}

		public function GetMaxFrames():int
		{
			return frames.length;
		}

		public function SetFrame(f:int)
		{
			frame = f;
			if(frame < 0) frame = 0;
			if(frame >= frames.length) frame = frames.length-1;
		}

		
		
	}		
}



