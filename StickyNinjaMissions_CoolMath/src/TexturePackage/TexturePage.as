package TexturePackage
{
	if (PROJECT::useStage3D)
	{
		import com.adobe.air.filesystem.events.FileMonitorEvent;
		import com.adobe.images.JPGEncoder;
		import com.adobe.images.PNGEncoder;
		import flash.display.Bitmap;
		import flash.display3D.Context3D;
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		import flash.display3D.Context3DTextureFormat;
		import flash.display3D.textures.Texture;
		import flash.system.System;
	}
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class TexturePage 
	{
		public var items:Vector.<DisplayObjFrame>;
		public var width:int;
		public var height:int;
		public var index:int;
		
		public var cellSize:int;
		public var currentCellX:int;
		public var currentCellY:int;
		
		public var bd:BitmapData;
		public var beenUploaded:Boolean;
		
		public var s3dTexture:s3dTex;
		
		public var formatName:String;
		
		
		public function TexturePage(_index:int,_w:int,_h:int) 
		{
			width = _w;
			height = _h;
			items = new Vector.<DisplayObjFrame>();
			index = _index;
			formatName = "";
			beenUploaded = false;
		}
		
		var firstNode:TexturePageNode = null;
		
		
		
		public function AddDOF(dof:DisplayObjFrame):Boolean
		{
			if (firstNode == null)
			{
				firstNode = new TexturePageNode();
				firstNode.rect = new Rectangle(0, 0, width,height);
			}
			if (firstNode.Insert(dof) == null)
			{
				return false;
			}
			return true;
		}
		
		
		
		// actually copy the bitmap data in
		
		public function Create(_useFullTexture:Boolean=false)
		{
			
			
			if (PROJECT::useStage3D)
			{
			
				if (items.length != 0)
				{
					
					if (Game.loadTextureFiles == false)
					{
						s3dTexture = new s3dTex(null, width, height,Context3DTextureFormat.BGRA,"normal",TexturePages.nextTexID++);
						s3dTexture.texture  = s3d.context3D.createTexture(width,height,Context3DTextureFormat.BGRA,false);			
						bd = new BitmapData(width, height, true, 0);
						
						formatName = Context3DTextureFormat.BGRA;
						
						for each(var dof:DisplayObjFrame in items)
						{
							bd.copyPixels(dof.bitmapData, dof.bitmapData.rect, new Point(dof.sourceRect.x, dof.sourceRect.y));				
							
							dof.u0 = 1 / Number(width) * dof.sourceRect.x;
							dof.v0 = 1 / Number(height) * dof.sourceRect.y;
							dof.u1 = 1 / Number(width) * (dof.sourceRect.x + dof.sourceRect.width);
							dof.v1 = 1 / Number(height) * (dof.sourceRect.y + dof.sourceRect.height);
							
							if (_useFullTexture)
							{
								dof.u0 = 0;
								dof.v0 = 0;
								dof.u1 = 1;
								dof.v1 = 1;
								
							}
							
							dof.s3dTexture = s3dTexture;	// .Clone();
							dof.MakeVertexBuffer();

							dof.bitmapData.dispose();
							dof.bitmapData = null;
							dof.s3dTexPageIndex = index;
							
						}		
					
						dof.s3dTexture.texture.uploadFromBitmapData(bd);	
						
						Save();
						
						bd.dispose();		
						bd = null;
					}					
				}
			}
		}
			

		public function CreateFromInclude()
		{
			
			
			if (PROJECT::useStage3D)
			{
					
				var ba:ByteArray = TexturePageIncludes.GetATF_ByteArray(index);		
				
				ba.position = 13;
				var w:uint = ba.readByte();
				ba.position = 14;
				var h:uint = ba.readByte();
				
				
				width = Math.pow(2, w);
				height =  Math.pow(2, h);

				trace("bytearray " + ba.length + " " + w + " " + h+"   "+width+"  "+height);
				
				ba.position = 12;
				var type:uint = ba.readByte();
				var format:String;
				switch (type & 0x7F) {
					case 0:
					case 1:
						format = Context3DTextureFormat.BGRA;
						break;
					case 2:
					case 3:
						format = Context3DTextureFormat.COMPRESSED;
						break;
					case 4:
					case 5:
						format = Context3DTextureFormat.COMPRESSED_ALPHA;
						break;
				}				
				ba.position = 0;
				trace("format: "+format+" "+type)
				
				
				formatName = format;
				
				s3dTexture = new s3dTex(null, width, height, format, "", TexturePages.nextTexID++);
				s3dTexture.CreateTexture();
				s3dTexture.byteArray = ba;
				//s3dTexture.texture.uploadCompressedTextureFromByteArray(ba,0);
					
			}
		}			
		
		
		
		
//		static function Level_Dump_OneComplete(e:Event)
//		{
//		}

	
		

		public function Save()
		{

			if (Game.saveTextureFiles)
			{
				
				if (PROJECT::useStage3D)
				{
					
					var ba:ByteArray = PNGEncoder.encode(bd);
					var fl:File = File.desktopDirectory.resolvePath("airtextures/TexturePage_" + index + ".png");
					
					var fs:FileStream = new FileStream();
					
					try
					{
					 //open file in write mode
						fs.open(fl,FileMode.WRITE);
					 //write bytes from the byte array
					 fs.writeBytes(ba);
					 //close the file
					 fs.close();
					}catch (e:Error)
					{
						trace(e.message);
					}
				}
			}
			
		}
		
	}

}