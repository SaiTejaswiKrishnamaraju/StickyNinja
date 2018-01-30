package TexturePackage
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	if (PROJECT::useStage3D)
	{
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	}
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import UIPackage.PreparingObject;

	if (PROJECT::useStage3D)
	{
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
	}
	
	/**
	 * ...
	 * @author 
	 */
	public class TexturePages 
	{
		public static var pages:Vector.<TexturePage>;
		public static var dobjFrames:Vector.<DisplayObjFrame>;
		
		
		public static var txSizeX:int = 2048;
		public static var txSizeY:int = 2048;
		public static var doBestFit:Boolean = true;
		public static var nextTexID:int = 0;
		
		public function TexturePages() 
		{
			
		}
		
		public static function InitOnce()
		{
			pages = new Vector.<TexturePage>();
			dobjFrames = new Vector.<DisplayObjFrame>();
		}
		
		public static function AddDobjFrame(_dobj:DisplayObjFrame)
		{
			dobjFrames.push(_dobj);
		}
		
		public static function SortWidth(x:DisplayObjFrame, y:DisplayObjFrame):Number
		{
			if (x.sourceRect.width < y.sourceRect.width) return 1;
			if (x.sourceRect.width > y.sourceRect.width) return -1;
			return 0;
		}
		public static function SortHeight(x:DisplayObjFrame, y:DisplayObjFrame):Number
		{
			if (x.sourceRect.height < y.sourceRect.height) return 1;
			if (x.sourceRect.height > y.sourceRect.height) return -1;
			return 0;
		}
		public static function SortArea(x:DisplayObjFrame, y:DisplayObjFrame):Number
		{
			var a0:Number = x.sourceRect.width * x.sourceRect.height;
			var a1:Number = y.sourceRect.width * y.sourceRect.height;
			
			if (a0 < a1) return 1;
			if (a0 > a1) return -1;
			return 0;
		}
		
		public static var currentPage:TexturePage;
		
		public static function LoadGraphicObjectsForPreparing()
		{
			if (Game.loadTextureFiles == false) return;
			if (PROJECT::useStage3D)
			{
				GraphicObjects.Load();
			}
		}
		
		
			
			
			
			
		public static function CreateSeparate(po:PreparingObject,frame:int)
		{
			var dob:DisplayObj = GraphicObjects.GetDisplayObjByName(po.name);
			
			var dof:DisplayObjFrame = dob.frames[frame];
			
			var w:int = Utils.NearestSuperiorPow2(dof.sourceRect.width);
			var h:int = Utils.NearestSuperiorPow2(dof.sourceRect.height);

			currentTP = new TexturePage(pages.length-1, w, h);
			currentPage = currentTP;

			currentTP.AddDOF(dof);
			currentTP.Create();
			pages.push(currentTP);
			
		}
		
		static var currentTP:TexturePage;
		
		public static function Create()
		{
			if (PROJECT::useStage3D == false) return;
			
			if (PROJECT::isMobile)
			{
				if (Game.loadTextureFiles)
				{
					for (var i:int = 0; i < textureInclude.pages_atf.length; i++)
					{
						var p:Point = textureInclude.sizes_atf[i];
						currentTP = new TexturePage(i, p.x, p.y);
						currentTP.CreateFromInclude();

						pages.push(currentTP);
					}
					return;
				}
			}
			
			
			dobjFrames = dobjFrames.sort(SortArea);

			var a:int = 0;
			
			for each(var dof:DisplayObjFrame in dobjFrames)
			{
				dof.assignedToTexturePage = false;
			}
			
			
			var tfIndex:int = 0;
			var currentTP:TexturePage;

			var a:int = 0;
			
			var tryAgain:Boolean = false;
			
			
			// define the texture pages in preparing.as 
			var predefinedPageIndex:int = 0;
			for each( var p:Point in PreparingData.predefinedTextureSizes)
			{
				currentTP = new TexturePage(predefinedPageIndex, p.x, p.y);
				tfIndex++;
				for each(var dof:DisplayObjFrame in dobjFrames)
				{
					if (dof.assignedToTexturePage == false)
					{
						if (dof.modifier.type == "page")
						{
							var pageNumber:int = int(dof.modifier.value) - 1;
							if (pageNumber == predefinedPageIndex)
							{
								currentPage = currentTP;
								var assigned:Boolean = currentTP.AddDOF(dof);
							}
						}
					}
				}
				currentTP.Create();
				pages.push(currentTP);
				predefinedPageIndex++;
			}
				
			
			
			for each(var dof:DisplayObjFrame in dobjFrames)
			{
				if (dof.assignedToTexturePage == false)
				{
					
					if (dof.modifier.IsSeparateTexture() )
					{
						var w:int = Utils.NearestSuperiorPow2(dof.sourceRect.width);
						var h:int = Utils.NearestSuperiorPow2(dof.sourceRect.height);
						
						if (dof.modifier.IsForcedRectangle() )
						{
							w = dof.modifier.forcedRectangle.width;
							h = dof.modifier.forcedRectangle.height;
						}

						currentTP = new TexturePage(tfIndex++, w, h);
						currentPage = currentTP;

						currentTP.AddDOF(dof);
						currentTP.Create(dof.modifier.IsForcedRectangle());
						pages.push(currentTP);
					}
				}
			}
			
			
			
			
			
			for each(var dof:DisplayObjFrame in dobjFrames)
			{
//				Utils.trace("DOBJ "+dof.sourceRect+"    tx:"+dof.s3dTexPageIndex);
			}
			Utils.traceerror("num frames: " + dobjFrames.length + "    num pages: " + pages.length);
			
			if (Game.saveTextureFiles)
			{
				SaveBatchFile();
				SaveIncludeFile();
				GraphicObjects.Save();
			}

			Utils.traceerror("A num objects: " + GraphicObjects.displayObjs.length);
			
			
			Utils.traceerror("B num objects: " + GraphicObjects.displayObjs.length);
			var a:int = 0;

		}
		
		static function SaveIncludeFile()
		{
			if (Game.saveTextureFiles == false) return;
				
			var batchString:String = "";
				
			batchString += "package"
			batchString += "\r\n";
			batchString += "{"
			batchString += "\r\n";
			
			batchString += "import flash.geom.Point;";
			batchString += "\r\n";
			
			batchString += "public class textureInclude"
			batchString += "\r\n";
			batchString += "{"
			batchString += "\r\n";
				
			
			
			batchString += "\r\n";
			batchString += "\r\n";
			
			batchString += "PROJECT::isAndroid";
			batchString += "\r\n";
			batchString += "{";
			batchString += "\r\n";
			var index:int = 0;
			for each(var tp:TexturePage in pages)
			{				
				var n:String = "TexturePage_" + index + "_Android.atf";		
				batchString += '[Embed(source="../TextureIncludes/' + n+'", mimeType="application/octet-stream")]';
				batchString += "\r\n";
				batchString += 'public static var TexturePage_ATF_'+index+':Class;';
				batchString += "\r\n";
				index++;
			}
			batchString += "}";
			batchString += "\r\n";
			
			batchString += "\r\n";
			batchString += "\r\n";
			
			
			batchString += "PROJECT::isIOS";
			batchString += "\r\n";
			batchString += "{";
			batchString += "\r\n";
			var index:int = 0;
			for each(var tp:TexturePage in pages)
			{				
				var n:String = "TexturePage_" + index + "_iOS.atf";		
				batchString += '[Embed(source="../TextureIncludes/' + n+'", mimeType="application/octet-stream")]';
				batchString += "\r\n";
				batchString += 'public static var TexturePage_ATF_'+index+':Class;';
				batchString += "\r\n";
				index++;
			}
			batchString += "}";
			batchString += "\r\n";

			batchString += "\r\n";
			batchString += "\r\n";
			
			
			batchString += "PROJECT::isMobile";
			batchString += "\r\n";
			batchString += "{";
			batchString += "\r\n";
			
			batchString += 'public static var pages_atf:Array = new Array(';
			batchString += "\r\n";
			var index:int = 0;
			for each(var tp:TexturePage in pages)
			{				
				batchString += '\tTexturePage_ATF_' + index;
				if (index != pages.length - 1)
				{
					batchString += ',';					
				}
				else
				{
					batchString += ');';
				}
				batchString += "\r\n";
				index++;
			}

//---------------- sizes

			batchString += 'public static var sizes_atf:Array = new Array(';
			batchString += "\r\n";
			var index:int = 0;
			for each(var tp:TexturePage in pages)
			{				
				batchString += '\tnew Point(' + tp.width + ',' + tp.height + ')';
				if (index != pages.length - 1)
				{
					batchString += ',';					
				}
				else
				{
					batchString += ');';
				}
				batchString += "\r\n";
				index++;
			}
			batchString += "}";
			batchString += "\r\n";


//--------------
			
			
			batchString += "\r\n";
			batchString += "\r\n";
						
			batchString += "}";
			batchString += "\r\n";
			batchString += "}";
			batchString += "\r\n";
			
			
			
			
			if (PROJECT::useStage3D)
			{
				var fl:File = File.desktopDirectory.resolvePath("airtextures/textureInclude.as");
				var fs:FileStream = new FileStream();
				
				try
				{
				 //open file in write mode
					fs.open(fl,FileMode.WRITE);
				 //write bytes from the byte array
				 fs.writeUTFBytes(batchString);
				 //close the file
				 fs.close();
				}catch (e:IOErrorEvent)
				{
					trace(e.errorID);
				}
			}
			
			
		}
		static function SaveBatchFile()
		{
			if (Game.saveTextureFiles == false) return;
				
			var batchString:String = "";
				
				
			batchString = "";
			var index:int = 0;
			for each(var tp:TexturePage in pages)
			{
				
				var name:String = "TexturePage_" + index;
				batchString += "png2atf e -i " + name + ".png -o " + name + "_Android.atf -n 0,0";
				batchString += "\r\n";
				batchString += "png2atf p -i " + name + ".png -o " + name + "_iOS.atf -n 0,0";
				batchString += "\r\n";
				index++;
			}
			
			if (PROJECT::useStage3D)
			{
				var fl:File = File.desktopDirectory.resolvePath("airtextures/ConvertTextures_All.bat");
				var fs:FileStream = new FileStream();				
				try
				{
					fs.open(fl,FileMode.WRITE);
				 fs.writeUTFBytes(batchString);
				 fs.close();
				}catch (e:IOErrorEvent)
				{
					trace(e.errorID);
				}
			}

			
			batchString = "";
			var index:int = 0;
			for each(var tp:TexturePage in pages)
			{
				
				var name:String = "TexturePage_" + index;
				
				
				//var comp:PreparingCompression = tp.modifier.compression;
				if (true)	//comp.android == PreparingCompression.COMPRESSION_NONE)
				{					
					batchString += "png2atf e -i " + name + ".png -o " + name + "_Android.atf -n 0,0";
				}
				else
				{
					batchString += "png2atf -c e -i " + name + ".png -o " + name + "_Android.atf -n 0,0";
				}
				
				batchString += "\r\n";
				index++;
			}
			
			if (PROJECT::useStage3D)
			{
				var fl:File = File.desktopDirectory.resolvePath("airtextures/ConvertTextures_Android.bat");
				var fs:FileStream = new FileStream();				
				try
				{
					fs.open(fl,FileMode.WRITE);
				 fs.writeUTFBytes(batchString);
				 fs.close();
				}catch (e:IOErrorEvent)
				{
					trace(e.errorID);
				}
			}

			batchString = "";
			var index:int = 0;
			for each(var tp:TexturePage in pages)
			{
				
				var name:String = "TexturePage_" + index;
				batchString += "png2atf p -i " + name + ".png -o " + name + "_iOS.atf -n 0,0";
				batchString += "\r\n";
				index++;
			}
			
			if (PROJECT::useStage3D)
			{
				var fl:File = File.desktopDirectory.resolvePath("airtextures/ConvertTextures_IOS.bat");
				var fs:FileStream = new FileStream();				
				try
				{
					fs.open(fl,FileMode.WRITE);
				 fs.writeUTFBytes(batchString);
				 fs.close();
				}catch (e:IOErrorEvent)
				{
					trace(e.errorID);
				}
			}
			
			
		}

		
	}

}