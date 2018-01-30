package  
{
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import TexturePackage.PreparingModifier;
	import TexturePackage.TexturePage;
	import TexturePackage.TexturePages;
		if (PROJECT::useStage3D)
		{
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
		}
	
	import flash.events.*;
	import flash.text.TextField;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.display.Loader;

	
	public class DisplayObjFrame
	{
		
		public var bitmapData:BitmapData;
		public var xoffsetxf:Number;
		public var xoffset:Number;
		public var yoffset:Number;
		public static var mat:Matrix = new Matrix();
		public static var colTrans:ColorTransform = new ColorTransform();
		public static var vector3D:Vector3D = new Vector3D();
		public var sourceRect:Rectangle;
		public var point:Point;					// local, used for rendering
		public var modifier:PreparingModifier;
		public var modifierScale:Number;
		public var modifierOneOverScale:Number;
		
		public var s3dTexPageIndex:int;
		public var parentDobj:DisplayObj;
		PROJECT::useStage3D
		{
		public var s3dTexture:s3dTex;
		}
		public var u0:Number;
		public var v0:Number;
		public var u1:Number;
		public var v1:Number;		
		public var assignedToTexturePage:Boolean;		
		
		public var indices:Vector.<uint>;
		public var vertices:Vector.<Number>;
		public var vertices_extra:Vector.<Number>;
		public var vertices_transformed:Vector.<Number>;
		
		public function InlineTest():Boolean
		{
			return true;
		}
		
		public function Load(x:XML)
		{
			xoffset = XmlHelper.GetAttrNumber(x.@xoffset, 0);
			xoffsetxf = XmlHelper.GetAttrNumber(x.@xoffsetxf, 0);
			yoffset = XmlHelper.GetAttrNumber(x.@yoffset, 0);
			u0 = XmlHelper.GetAttrNumber(x.@u0, 0);
			u1 = XmlHelper.GetAttrNumber(x.@u1, 0);
			v0 = XmlHelper.GetAttrNumber(x.@v0, 0);
			v1 = XmlHelper.GetAttrNumber(x.@v1, 0);
			
			sourceRect = new Rectangle();
			sourceRect.x = XmlHelper.GetAttrNumber(x.@sourceRectX, 0);
			sourceRect.y = XmlHelper.GetAttrNumber(x.@sourceRectY, 0);
			sourceRect.width = XmlHelper.GetAttrNumber(x.@sourceRectW, 0);
			sourceRect.height = XmlHelper.GetAttrNumber(x.@sourceRectH, 0);
			
			s3dTexPageIndex = XmlHelper.GetAttrInt(x.@s3dTexPageIndex, 0);
			modifierScale = XmlHelper.GetAttrNumber(x.@modifierScale, 1);
			modifierOneOverScale = 1 / modifierScale;
			
			if (PROJECT::useStage3D)
			{
				var tp:TexturePage = TexturePages.pages[s3dTexPageIndex];
				s3dTexture = tp.s3dTexture;	// .Clone();
				MakeVertexBuffer();
			}
			
		}
		public function Save():String
		{
			var s:String = "";
			s += "<frame ";
			s += XmlHelper.Attr("xoffset", xoffset);
			s += XmlHelper.Attr("xoffsetxf", xoffsetxf);
			s += XmlHelper.Attr("yoffset", yoffset);
			s += XmlHelper.Attr("sourceRectX", sourceRect.x);
			s += XmlHelper.Attr("sourceRectY", sourceRect.y);
			s += XmlHelper.Attr("sourceRectW", sourceRect.width);
			s += XmlHelper.Attr("sourceRectH", sourceRect.height);
			s += XmlHelper.Attr("modifierScale", modifierScale);
			s += XmlHelper.Attr("s3dTexPageIndex", s3dTexPageIndex);
			s += XmlHelper.Attr("u0", u0);
			s += XmlHelper.Attr("v0", v0);
			s += XmlHelper.Attr("u1", u1);
			s += XmlHelper.Attr("v1", v1);
			s += "/>\n";
			return s;
		}
		
		public function DisplayObjFrame()
		{
		if (PROJECT::useStage3D)
		{
			s3dTexture = null;
		}
			modifier = null;
			point = new Point(0, 0);
			sourceRect = new Rectangle(0, 0, 1, 1);
			modifierScale = 1;
			modifierOneOverScale = 1;

		}
		
		public function Remove()
		{
			if (bitmapData != null)
			{
				bitmapData.dispose();
				bitmapData = null;
				sourceRect = null;
				point = null;
			}
		}
		
		public function MakeVertexBuffer()
		{
			var currentV:int = 0;
			var currentVE:int = 0;
			var currentI:int = 0;
		
			vertices = new Vector.<Number>(3 * 4);
			vertices_transformed = new Vector.<Number>(3 * 4);
			vertices_extra = new Vector.<Number>(5 * 4);
			indices = new Vector.<uint>(6);
			
//			u0 = v0 = 0;
//			u1 = v1 = 1;
			
			vertices[currentV++] = 0;
			vertices[currentV++] = 0;
			vertices[currentV++] = 1;
			vertices_extra[currentVE++] = u0;
			vertices_extra[currentVE++] = v0;
			vertices_extra[currentVE++] = 1;
			vertices_extra[currentVE++] = 1;
			vertices_extra[currentVE++] = 1;
			
			vertices[currentV++] = sourceRect.width;
			vertices[currentV++] = 0;
			vertices[currentV++] = 1;
			vertices_extra[currentVE++] = u1;
			vertices_extra[currentVE++] = v0;
			vertices_extra[currentVE++] = 1;
			vertices_extra[currentVE++] = 1;
			vertices_extra[currentVE++] = 1;

			vertices[currentV++] = 0;
			vertices[currentV++] = sourceRect.height;
			vertices[currentV++] = 1;
			vertices_extra[currentVE++] = u0;
			vertices_extra[currentVE++] = v1;
			vertices_extra[currentVE++] = 1;
			vertices_extra[currentVE++] = 1;
			vertices_extra[currentVE++] = 1;

			vertices[currentV++] = sourceRect.width;
			vertices[currentV++] = sourceRect.height;
			vertices[currentV++] = 1
			vertices_extra[currentVE++] = u1;
			vertices_extra[currentVE++] = v1;
			vertices_extra[currentVE++] = 1;
			vertices_extra[currentVE++] = 1;
			vertices_extra[currentVE++] = 1;
			
			
			indices[currentI++] = 0;
			indices[currentI++] = 1;
			indices[currentI++] = 2;
			indices[currentI++] = 1;
			indices[currentI++] = 3;
			indices[currentI++] = 2;
			
		}
		
		
		// assumes it's already been created
		public function ReUploadBitmap(bd:BitmapData)
		{
			bitmapData = bd;
			
			
		}
		
		public function CreateStandalone(bd:BitmapData, xoff:Number, yoff:Number,reuse:Boolean=false)
		{
			if (bitmapData = null) return;
			bitmapData = bd;
			xoffset = 0;
			yoffset = 0;
			sourceRect = new Rectangle(0, 0, bd.width, bd.height);
			
			
		}

		
		public function RenderAtRotScaled_Graphics(g:Graphics, xpos:Number, ypos:Number, scale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false):void
		{
			var x:Number = xpos;
			var y:Number = ypos;
			var w:Number = bitmapData.width * scale;
			var h:Number = bitmapData.height * scale;
			
			x += xoffset * scale;
			y += yoffset * scale;

			mat.identity();
			mat.scale(scale, scale);
			mat.translate( x, y);
			
			g.lineStyle(null, 0, 0);
			g.beginBitmapFill(bitmapData,mat,false,false);
			g.drawRect(x, y, w, h);
			g.endFill();
			
		}
		
		
		
		var m3d:Matrix3D = new Matrix3D();
		public function RenderAt(screenBD:BitmapData,xpos:Number,ypos:Number):void
		{			
			point.x = xpos + xoffset;
			point.y = ypos + yoffset;
			if (PROJECT::useStage3D)
			{
				m3d.identity();
				m3d.appendTranslation(xpos + xoffset, ypos + yoffset, 0);

				s3d.RenderTriangleList(m3d, s3dTexture, indices, vertices,vertices_extra, null);
			}
			else
			{
			
				screenBD.copyPixels( bitmapData, sourceRect, point, null, null, true);							
			}
		}

		public function RenderAtXFlip(screenBD:BitmapData,xpos:Number,ypos:Number):void
		{


			if (PROJECT::useStage3D)
			{
				m3d.identity();
					m3d.appendScale( -1, 1, 1);
				m3d.appendTranslation(xpos - xoffset, ypos + yoffset, 0);

				s3d.RenderTriangleList(m3d, s3dTexture, indices, vertices,vertices_extra, null);
			}
			else
			{
				if (bitmapData != null)
				{
					mat.identity();
					mat.translate( xoffset,yoffset);
					mat.scale( -1.0, 1);
					mat.translate(xpos, ypos);
					screenBD.draw(bitmapData, mat,null,null,null,true);								
				}			
			}
			
		}

		
		public function HitTestRotScaled(screenBD:BitmapData,xpos:Number,ypos:Number,scale:Number=1.0,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false):Boolean
		{
			return screenBD.hitTest(new Point(0, 0), 255, bitmapData,new Point( xpos + xoffset, ypos + yoffset),255);
		}
		
		
		
		public function RenderAtRotScaledWithOffset(screenBD:BitmapData, xpos:Number, ypos:Number, scale:Number = 1.0, rot:Number = 0.0, ct:ColorTransform = null, _doSmooth:Boolean = false , offsetX:Number = 0, offsetY:Number = 0):void
		{
			mat.identity();
			mat.translate(xoffset, yoffset);			
			mat.rotate(rot);
			mat.translate(-xoffset, -yoffset);			

			mat.translate(offsetX, offsetY);			
			mat.scale(scale, scale);
			mat.translate(-offsetX, -offsetY);			
			mat.translate(xpos + (xoffset * scale), ypos + (yoffset * scale));

			
			if (bitmapData != null)
			{
				screenBD.draw(bitmapData, mat,ct,null,null,_doSmooth);								
			}			
			
		}
		
		static var z_azis:Vector3D = new Vector3D(0, 0, 1);
		
		static var vtransformsIn:Vector.<Number> = new Vector.<Number>();
		static var vtransformsOut:Vector.<Number> = new Vector.<Number>();
		
		static var copiedMatrix:Matrix3D = new Matrix3D();
		public function RenderAtMatrix3D(screenBD:BitmapData,m:Matrix3D,ct:ColorTransform =null):void
		{
			if (PROJECT::useStage3D)
			{
				vector3D.x = xoffset;
				vector3D.y = yoffset;
				vector3D.z = 0;
				
				// need to copy the matrix to append in the modifier scale :(
				copiedMatrix.copyFrom(m);
				
				copiedMatrix.prependScale( modifierOneOverScale, modifierOneOverScale, 1);
				
				Utils.deltaTransformVector3DInPlace(copiedMatrix, vector3D);
				
				copiedMatrix.prependTranslation(vector3D.x, vector3D.y,0);				
				s3d.RenderTriangleList(copiedMatrix, s3dTexture, indices, vertices, vertices_extra, ct);
				copiedMatrix.prependTranslation(-vector3D.x, -vector3D.y,0);
				
			}
			else
			{
				if (bitmapData != null)
				{
					var p:Point = new Point(xoffset, yoffset);
					
					var m0:Matrix = Utils.Matrix3DToMatrix(m);
					var m1:Matrix = Utils.Matrix3DToMatrix(m);
					m1.tx = 0;
					m1.ty = 0;
					
					p = m1.transformPoint(p);
					m0.translate(p.x, p.y);
					
					screenBD.draw(bitmapData, m0,ct,null,null,true);								
				}							
			}
		}

		public function RenderFunctionAtMatrix3D(screenBD:BitmapData,m:Matrix3D,ct:ColorTransform =null,fn_flash:Function = null,fn_air:Function = null):void
		{
			if (PROJECT::useStage3D)
			{
				vector3D.x = xoffset;
				vector3D.y = yoffset;
				vector3D.z = 0;
				
				Utils.deltaTransformVector3DInPlace(m, vector3D);
				
				
//				vector3D = m.deltaTransformVector(vector3D);
				m.prependTranslation(vector3D.x, vector3D.y, 0);			
				
				if (fn_air != null)
				{
					fn_air(screenBD,m,this);
				}
				
//				s3d.RenderTriangleList(m, s3dTexture, indices, vertices, vertices_extra, ct);
				m.prependTranslation(-vector3D.x, -vector3D.y,0);
				
			}
			else
			{
				if (bitmapData != null)
				{
					var p:Point = new Point(xoffset, yoffset);
					
					var m0:Matrix = Utils.Matrix3DToMatrix(m);
					var m1:Matrix = Utils.Matrix3DToMatrix(m);
					m1.tx = 0;
					m1.ty = 0;
					
					p = m1.transformPoint(p);
					m0.translate(p.x, p.y);
					
					if (fn_flash != null)
					{
						fn_flash(screenBD, m0, this);
					}
					//screenBD.draw(bitmapData, m0,ct,null,null,true);								
				}							
			}
		}
		
		
		public function RenderAtMatrix3D_Vector(origMC:MovieClip,_frame:int,screenBD:BitmapData,m:Matrix3D,ct:ColorTransform =null):void
		{
			if (PROJECT::useStage3D)
			{
				vector3D.x = xoffset;
				vector3D.y = yoffset;
				vector3D.z = 0;
				vector3D = m.deltaTransformVector(vector3D);
				m.appendTranslation(vector3D.x, vector3D.y,0);				
				s3d.RenderTriangleList(m, s3dTexture, indices, vertices, vertices_extra, ct);
				m.appendTranslation(-vector3D.x, -vector3D.y,0);
				
			}
			else
			{
				if (bitmapData != null)
				{
					var m0:Matrix = Utils.Matrix3DToMatrix(m);
					origMC.gotoAndStop( _frame + 1);		
					screenBD.draw(origMC,m0, ct, null, null, false);								
				}							
			}
		}
		
		
		public function RenderAtRotScaled(screenBD:BitmapData,xpos:Number,ypos:Number,scale:Number=1.0,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false):void
		{
			
			if (PROJECT::useStage3D)
			{
//				scale *= 0.75;
				m3d.identity();
				m3d.appendTranslation(xoffset, yoffset,0);
				m3d.appendRotation(Utils.RadToDeg(rot), z_azis);
				m3d.appendTranslation( -xoffset, -yoffset, 0);
				if(scale == 0) scale = 0.001;
				m3d.appendScale(scale, scale,1);
				m3d.appendTranslation(xpos + (xoffset * scale), ypos + (yoffset * scale),0);
				
				s3d.RenderTriangleList(m3d, s3dTexture, indices,vertices,vertices_extra,ct);
				

			}
			else
			{
			
				mat.identity();
				mat.translate(xoffset, yoffset);			
				mat.rotate(rot);
				mat.translate(-xoffset, -yoffset);			

				mat.scale(scale, scale);
				mat.translate(xpos + (xoffset * scale), ypos + (yoffset * scale));

				if (bitmapData != null)
				{
//					Utils.DrawBD(screenBD, bitmapData, mat, ct, null, null, _doSmooth, StageQuality.HIGH);
					screenBD.draw(bitmapData, mat,ct,null,null,_doSmooth);								
				}			
			}
		}

		public function RenderAtRotScaledQuality(screenBD:BitmapData,xpos:Number,ypos:Number,scale:Number=1.0,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false,_quality:String="high"):void
		{
			
			if (PROJECT::useStage3D)
			{
//				scale *= 0.75;
				m3d.identity();
				m3d.appendTranslation(xoffset, yoffset,0);
				m3d.appendRotation(Utils.RadToDeg(rot), z_azis);
				m3d.appendTranslation( -xoffset, -yoffset, 0);
				if(scale == 0) scale = 0.001;
				m3d.appendScale(scale, scale,1);
				m3d.appendTranslation(xpos + (xoffset * scale), ypos + (yoffset * scale),0);
				
				s3d.RenderTriangleList(m3d, s3dTexture, indices,vertices,vertices_extra,ct);
				

			}
			else
			{
			
				mat.identity();
				mat.translate(xoffset, yoffset);			
				mat.rotate(rot);
				mat.translate(-xoffset, -yoffset);			

				mat.scale(scale, scale);
				mat.translate(xpos + (xoffset * scale), ypos + (yoffset * scale));

				if (bitmapData != null)
				{
					Utils.DrawBD(screenBD, bitmapData, mat, ct, null, null, _doSmooth, _quality);
				}			
			}
		}
		
		
		public function RenderAtRotScaled_Offset(screenBD:BitmapData,xpos:Number,ypos:Number,offx:Number,offy:Number,scale:Number=1.0,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false):void
		{
			
			if (PROJECT::useStage3D)
			{
//				scale *= 0.75;
				m3d.identity();
				m3d.appendTranslation(xoffset, yoffset,0);
				m3d.appendTranslation(offx, offy,0);
				m3d.appendRotation(Utils.RadToDeg(rot), z_azis);
				m3d.appendTranslation( -xoffset, -yoffset, 0);
				if(scale == 0) scale = 0.001;
				m3d.appendScale(scale, scale,1);
				m3d.appendTranslation(xpos + (xoffset * scale), ypos + (yoffset * scale),0);
				
				s3d.RenderTriangleList(m3d, s3dTexture, indices,vertices,vertices_extra,ct);
				
//				s3d.RenderQuad(m3d,s3dTexture,
//						0,0, 0, u0, v0,
//						sourceRect.width,0, 0, u1, v0,
//					0,sourceRect.height, 0, u0, v1,
//						sourceRect.width,sourceRect.height , 0, u1, v1,
//						ct);
						

			}
			else
			{
			
				mat.identity();
				mat.translate(xoffset, yoffset);			
				mat.translate(offx, offy);			
				mat.rotate(rot);
				mat.translate(-xoffset, -yoffset);			

				mat.scale(scale, scale);
				mat.translate(xpos + (xoffset * scale), ypos + (yoffset * scale));

				if (bitmapData != null)
				{
//					Utils.DrawBD(screenBD, bitmapData, mat, ct, null, null, _doSmooth, StageQuality.HIGH);
					screenBD.draw(bitmapData, mat,ct,null,null,_doSmooth);								
				}			
			}
		}

		public function AppendToVertexBufferRotScaled(screenBD:BitmapData,xpos:Number,ypos:Number,scale:Number=1.0,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false):void
		{
			
			if (PROJECT::useStage3D)
			{
				m3d.identity();
				m3d.appendTranslation(xoffset, yoffset,0);
				m3d.appendRotation(Utils.RadToDeg(rot), z_azis);
				m3d.appendTranslation( -xoffset, -yoffset, 0);
				if(scale == 0) scale = 0.001;
				m3d.appendScale(scale, scale,1);
				m3d.appendTranslation(xpos + (xoffset * scale), ypos + (yoffset * scale),0);
				
				s3d.AppendTriangleListToDobjVertexBuffer(m3d, s3dTexture, indices,vertices,vertices_extra,ct);
			}
		}

		
		public function RenderAtRot(screenBD:BitmapData,xpos:Number,ypos:Number,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false):void
		{
			
			if (PROJECT::useStage3D)
			{
				m3d.identity();
				m3d.appendTranslation(xoffset, yoffset,0);
				m3d.appendRotation(Utils.RadToDeg(rot), z_azis);
				m3d.appendTranslation( -xoffset, -yoffset, 0);
				m3d.appendTranslation(xpos + (xoffset), ypos + (yoffset),0);
				
				s3d.RenderTriangleList(m3d, s3dTexture, indices,vertices,vertices_extra,ct);
			}
			else
			{
			
				mat.identity();
				mat.translate(xoffset, yoffset);			
				mat.rotate(rot);
				mat.translate(-xoffset, -yoffset);			
				mat.translate(xpos + (xoffset), ypos + (yoffset));

				if (bitmapData != null)
				{
					screenBD.draw(bitmapData, mat,ct,null,null,_doSmooth);								
				}			
			}
		}
		

		public function RenderAtRot_Xflip(screenBD:BitmapData,xpos:Number,ypos:Number,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false):void
		{
			
			if (PROJECT::useStage3D)
			{
				m3d.identity();
				m3d.appendTranslation(xoffset, yoffset,0);
				m3d.appendRotation(Utils.RadToDeg(rot), z_azis);
				m3d.appendTranslation(-xoffset, -yoffset,0);
				m3d.appendTranslation((xoffset), (yoffset),0);
				m3d.appendScale(-1, 1,1);
				m3d.appendTranslation(xpos, ypos,0);
				
				s3d.RenderTriangleList(m3d, s3dTexture, indices,vertices,vertices_extra,ct);
			}
			else
			{
			
				mat.identity();
				mat.translate(xoffset, yoffset);			
				mat.rotate(rot);
				mat.translate(-xoffset, -yoffset);			
				mat.translate(xpos + (xoffset), ypos + (yoffset));

				if (bitmapData != null)
				{
					screenBD.draw(bitmapData, mat,ct,null,null,_doSmooth);								
				}			
			}
		}
		
		public function RenderAtRotScaled_Xflip(screenBD:BitmapData,xpos:Number,ypos:Number,scale:Number=1.0,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false):void
		{

			
			if (PROJECT::useStage3D)
			{
				
				m3d.identity();
				m3d.appendTranslation(xoffset, yoffset,0);
				m3d.appendScale(-1, 1,1);
				m3d.appendRotation(Utils.RadToDeg(rot), z_azis);
				m3d.appendTranslation(-xoffset, -yoffset,0);
				m3d.appendScale(scale, scale,1);
				m3d.appendTranslation((xoffset * scale), (yoffset * scale),0);
				m3d.appendTranslation(xpos, ypos,0);
				
				s3d.RenderTriangleList(m3d, s3dTexture, indices,vertices,vertices_extra,ct);


			}
			else
			{
			
				mat.identity();
				mat.translate(xoffset, yoffset);			
				mat.scale( -1.0, 1);
				mat.rotate(rot);
				mat.translate(-xoffset, -yoffset);			

				mat.scale(scale, scale);
				mat.translate((xoffset * scale), (yoffset * scale));
				mat.translate(xpos, ypos);

				if (bitmapData != null)
				{
					screenBD.draw(bitmapData, mat,ct,null,null,_doSmooth);								
				}			
			}
			
		}
		
		
		public function RenderAtRotScaled_XflipA(screenBD:BitmapData,xpos:Number,ypos:Number,scale:Number=1.0,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false):void
		{

			
			if (PROJECT::useStage3D)
			{
				
				m3d.identity();
				m3d.appendTranslation(xoffset, yoffset,0);
				m3d.appendRotation(Utils.RadToDeg(rot), z_azis);
				m3d.appendTranslation(-xoffset, -yoffset,0);
				m3d.appendScale(scale, scale,1);
				m3d.appendTranslation((xoffset * scale), (yoffset * scale),0);
				m3d.appendScale(-1, 1,1);
				m3d.appendTranslation(xpos, ypos,0);
				
				s3d.RenderTriangleList(m3d, s3dTexture, indices,vertices,vertices_extra,ct);


			}
			else
			{
			
				mat.identity();
				mat.translate(xoffset, yoffset);			
				mat.rotate(rot);
				mat.translate(-xoffset, -yoffset);			

				mat.scale(scale, scale);
				mat.translate((xoffset * scale), (yoffset * scale));
				mat.scale( -1.0, 1);
				mat.translate(xpos, ypos);

				if (bitmapData != null)
				{
					screenBD.draw(bitmapData, mat,ct,null,null,_doSmooth);								
				}			
			}
			
		}
		
		public function RenderAtRotScaledAdditive(screenBD:BitmapData,xpos:Number,ypos:Number,scale:Number=1.0,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false):void
		{
			mat.identity();
			mat.translate(xoffset, yoffset);			
			mat.rotate(rot);
			mat.translate(-xoffset, -yoffset);			

			mat.scale(scale, scale);
			mat.translate(xpos + (xoffset * scale), ypos + (yoffset * scale));

			if (bitmapData != null)
			{
				screenBD.draw(bitmapData, mat, null, BlendMode.ADD, null, _doSmooth);								
			}			
		}
		
		

		public function RenderAtRotScaledLayer(screenBD:BitmapData,xpos:Number,ypos:Number,scale:Number=1.0,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false):void
		{
			mat.identity();
			mat.translate(xoffset, yoffset);			
			mat.rotate(rot);
			mat.translate(-xoffset, -yoffset);			

			mat.scale(scale, scale);
			mat.translate(xpos + (xoffset * scale), ypos + (yoffset * scale));

			if (bitmapData != null)
			{
				screenBD.draw(bitmapData, mat, null, BlendMode.LAYER, null, _doSmooth);								
			}			
		}
		
		public function RenderAtRotScaledOverlay(screenBD:BitmapData,xpos:Number,ypos:Number,scale:Number=1.0,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false):void
		{
			mat.identity();
			mat.translate(xoffset, yoffset);			
			mat.rotate(rot);
			mat.translate(-xoffset, -yoffset);			

			mat.scale(scale, scale);
			mat.translate(xpos + (xoffset * scale), ypos + (yoffset * scale));

			if (bitmapData != null)
			{
				screenBD.draw(bitmapData, mat, null, BlendMode.OVERLAY, null, _doSmooth);								
			}			
		}
		
		public function RenderAtRotScaled_SourceRect(screenBD:BitmapData,xpos:Number,ypos:Number,scale:Number=1.0,rot:Number = 0.0,ct:ColorTransform=null,_doSmooth:Boolean=false,sourceRect:Rectangle = null,xo:int = 0,yo:int=0):void
		{
			
			mat.identity();
			mat.translate(xoffset, yoffset);			
			mat.rotate(rot);
			mat.translate(-xoffset, -yoffset);			

			mat.scale(scale, scale);
			mat.translate(xpos + ((xoffset-xo) * scale), ypos + ((yoffset-yo) * scale));

			sourceRect.x = xpos;
			sourceRect.y = ypos;
			
			if (bitmapData != null)
			{					
				screenBD.draw(bitmapData, mat, ct, null,sourceRect,_doSmooth);								
			}
		}		
//-----------------------------------------------------------------------

		public function CreateFromMC(mc:MovieClip, scale:Number, _modifier:PreparingModifier, dobj:DisplayObj)
		{
			if (PROJECT::useStage3D == false)
			{
				CreateFromMC_Flash(mc, scale, _modifier, dobj);
			}
			else
			{
				if (Game.loadTextureFiles)
				{
					CreateFromMC_Stage3D_LoadedTexturePage(mc, scale, _modifier, dobj);			
					
				}
				else
				{
					CreateFromMC_Stage3D_TexturePage(mc, scale, _modifier, dobj);				
				}
			}
		}
		
		
		static var gmat:Matrix = new Matrix();
		
		static var border_off:int = -2;
		static var border_add:int = 4;
		
		public function CreateFromMC_Flash(mc:MovieClip,scale:Number,_modifier:PreparingModifier,dobj:DisplayObj)
		{
			var x0:int;
			var y0:int;	
			var rect:Rectangle;
			
			modifier = _modifier;
			parentDobj = dobj;
			
			rect = mc.getBounds(null);

			rect.x =(rect.x*scale);
			rect.y = (rect.y*scale);
			rect.width = (rect.width*scale);
			rect.height = (rect.height*scale);
				
			if (modifier.addBorder)
			{
				rect.x += border_off;
				rect.y += border_off;
				rect.width +=border_add;
				rect.height += border_add;
			}
				
			x0 = rect.left;
			y0 = rect.top;	
			gmat.identity();
			gmat.scale(scale, scale);
			gmat.translate(-x0, -y0);
			xoffset = Number(x0);
			yoffset = Number(y0);
			
			rect.width = int(rect.width);
			rect.height = int(rect.height);

			if (mc.width == 0 || mc.height == 0)
			{
				Utils.traceerror("ERROR, mc frame 0 height or width");
				bitmapData = new BitmapData(1, 1, true, 0);
				sourceRect = new Rectangle(0, 0, 1, 1);
			}
			
			else if (modifier.IsSeparateTexture())
			{					
				bitmapData = new BitmapData( (rect.width), (rect.height),true,0 );	// scaled (if necessary) original bitmap
				
				Utils.DrawBD(bitmapData,mc, gmat, null, null, null, true, DisplayObj.preDrawQuality);
				sourceRect = new Rectangle(0, 0, rect.width, rect.height);	// actual render size						
			}
			else	// draw to texture page
			{
				bitmapData = new BitmapData( (rect.width), (rect.height),true,0 );	// scaled (if necessary) original bitmap
				//bitmapData.draw( mc , gmat, null, null, null, true);				
				Utils.DrawBD(bitmapData, mc, gmat, null, null, null, true, StageQuality.BEST);
				sourceRect = new Rectangle(0, 0, rect.width, rect.height);	// actual render size			
			}			
			
			u0 = 0;
			v0 = 0;
			u1 = 1;
			v1 = 1;
			
			TexturePages.AddDobjFrame(this);
			
		}
		
		// Creates bitmap data for use later with texture pages
		public function CreateFromMC_Stage3D_TexturePage(mc:MovieClip,scale:Number,_modifier:PreparingModifier,dobj:DisplayObj)
		{
			var x0:int;
			var y0:int;	
			var rect:Rectangle;
			
			
			modifier = _modifier;
			parentDobj = dobj;

			if (modifier.IsSeparateTextureScaledUp())
			{
				var aa:int = 0;
			}

			scale *= modifier.scale;
			modifierScale = modifier.scale;
			modifierOneOverScale = 1/modifier.scale;
			
			rect = mc.getBounds(null);

			rect.x =(rect.x*scale);
			rect.y = (rect.y*scale);
			rect.width = (rect.width*scale);
			rect.height = (rect.height*scale);
				
			if (modifier.addBorder)
			{
				rect.x += border_off;
				rect.y += border_off;
				rect.width +=border_add;
				rect.height += border_add;
			}
				
			x0 = rect.left;
			y0 = rect.top;	
			gmat.identity();
			gmat.scale(scale, scale);
			gmat.translate(-x0, -y0);
			xoffset = Number(x0);
			yoffset = Number(y0);
			
			rect.width = int(rect.width);
			rect.height = int(rect.height);
			
			var origRect:Rectangle = rect.clone();
			
			if (_modifier.IsForcedRectangle())
			{
				rect.x = _modifier.forcedRectangle.x;
				rect.y = _modifier.forcedRectangle.y;
				rect.width = _modifier.forcedRectangle.width;
				rect.height = _modifier.forcedRectangle.height;
				
				x0 = rect.left;
				y0 = rect.top;	

				gmat.identity();
				gmat.scale(scale, scale);
				gmat.translate(-x0, -y0);
				xoffset = Number(x0);
				yoffset = Number(y0);
			}
			

			if (mc.width == 0 || mc.height == 0)
			{
				Utils.traceerror("ERROR, mc frame 0 height or width");
				sourceRect = new Rectangle(0, 0, 1, 1);
			}
			
			else if (modifier.IsSeparateTextureScaledUp())
			{					
				bitmapData = new BitmapData( (rect.width), (rect.height),true,0 );	// scaled (if necessary) original bitmap

				gmat.identity();
				gmat.scale(rect.width/origRect.width, rect.height/origRect.height);
		
				
				Utils.DrawBD(bitmapData,mc, gmat, null, null, null, true, DisplayObj.preDrawQuality);
				sourceRect = new Rectangle(0, 0, origRect.width, origRect.height);	// actual render size			
				
				u0 = 0;
				v0 = 0;
				u1 = 1;
				v1 = 1;
							
				MakeVertexBuffer();				
			}
			else if (modifier.IsSeparateTexture())
			{					
				bitmapData = new BitmapData( (rect.width), (rect.height),true,0 );	// scaled (if necessary) original bitmap
							
				Utils.DrawBD(bitmapData,mc, gmat, null, null, null, true, DisplayObj.preDrawQuality);
				sourceRect = new Rectangle(0, 0, rect.width, rect.height);	// actual render size			
				
				u0 = 0;
				v0 = 0;
				u1 = 1;
				v1 = 1;
							
				MakeVertexBuffer();				
			}
			else	// draw to texture page
			{
				bitmapData = new BitmapData( (rect.width), (rect.height), true, 0 );	// scaled (if necessary) original bitmap
				Utils.DrawBD(bitmapData,mc, gmat, null, null, null, true, DisplayObj.preDrawQuality);				
				sourceRect = new Rectangle(0, 0, rect.width, rect.height);	// actual render size	
				
				MakeVertexBuffer();				
				
			}			
			TexturePages.AddDobjFrame(this);
			
		}

		
		// Creates bitmap data for use later with texture pages
		public function CreateFromMC_Stage3D_LoadedTexturePage(mc:MovieClip,scale:Number,_modifier:PreparingModifier,dobj:DisplayObj)
		{
			var x0:int;
			var y0:int;	
			var rect:Rectangle;
			
			modifier = _modifier;
			parentDobj = dobj;
			
			rect = mc.getBounds(null);

			rect.x =(rect.x*scale);
			rect.y = (rect.y*scale);
			rect.width = (rect.width*scale);
			rect.height = (rect.height*scale);
				
			if (modifier.addBorder)
			{
				rect.x += border_off;
				rect.y += border_off;
				rect.width +=border_add;
				rect.height += border_add;
			}
				
			x0 = rect.left;
			y0 = rect.top;	
			gmat.identity();
			gmat.scale(scale, scale);
			gmat.translate(-x0, -y0);
			xoffset = Number(x0);
			yoffset = Number(y0);
			
			rect.width = int(rect.width);
			rect.height = int(rect.height);

			
			if (mc.width == 0 || mc.height == 0)
			{
				Utils.traceerror("ERROR, mc frame 0 height or width");
				sourceRect = new Rectangle(0, 0, 1, 1);
			}			
			else if (modifier.IsSeparateTexture())
			{					
				sourceRect = new Rectangle(0, 0, rect.width, rect.height);	// actual render size			
				u0 = 0;
				v0 = 0;
				u1 = 1;
				v1 = 1;							
				MakeVertexBuffer();				
			}
			else	// draw to texture page
			{
				sourceRect = new Rectangle(0, 0, rect.width, rect.height);	// actual render size					
				MakeVertexBuffer();				
				
			}			
			TexturePages.AddDobjFrame(this);
			
		}
		
		
	}
}