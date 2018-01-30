package  
{

	if (PROJECT::useStage3D)
	{
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;
	}	
import TexturePackage.PreparingModifier;
import TextPackage.BitmapFont;
import UIPackage.UI;
import flash.display.BitmapDataChannel;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.ID3Info;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.System;
import flash.text.Font;
import flash.text.TextFormat;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getTimer;
	
	/**
	* ...
	* @author Default
	*/
	public class GraphicObjects 
	{

		
		static var mod_default:PreparingModifier = new PreparingModifier("page", "1", true);
		static var dict:Dictionary;
		public static var displayObjs:Vector.<DisplayObj>;
		
		public function GraphicObjects() 
		{
			
		}
		
		[Embed(source = "../bin/GraphicObjectsLayout.xml", mimeType = "application/octet-stream")] 
		private static var class_vars:Class; 
		
		public static function Load()
		{
			if (Game.loadTextureFiles == false) return;
			
			var xml:XML = new XML(new class_vars()) as XML; 
			XML.ignoreWhitespace = true;	
			
			InitOnce();
			
			for (var i:int = 0; i < xml.graphicobjects.object.length(); i++)
			{
				var x:XML = xml.graphicobjects.object[i];
				var dobj:DisplayObj = new DisplayObj(null,1,null);
				dobj.Load(x);
				dict[dobj.origName] = dobj;
				displayObjs.push(dobj);
			}
			
		}
		public static function Save()
		{
			var s:String = "";
			
			s += "<data>\n";
			s += "<graphicobjects>\n";
			
			for each(var dobj:DisplayObj in displayObjs)
			{
				s += dobj.Save();
			}
			s += "</graphicobjects>\n";
			s += "</data>\n";
			
			//System.setClipboard(s);
			trace(s);
			
			if (PROJECT::useStage3D)
			{
				var fl:File = File.desktopDirectory.resolvePath("airtextures/GraphicObjectsLayout.xml");
				var fs:FileStream = new FileStream();
				
				try
				{
				 //open file in write mode
					fs.open(fl,FileMode.WRITE);
				 //write bytes from the byte array
				 fs.writeUTFBytes(s);
				 //close the file
				 fs.close();
				}catch (e:IOErrorEvent)
				{
					trace(e.errorID);
				}
			}
		}
		
		public static function InitOnce():void
		{
			displayObjs = new Vector.<DisplayObj>();
			dict = new Dictionary();
		}
		
		public static function RemoveDisplayObjByName(_name:String):void
		{
			var dob:DisplayObj;
			
			//dictionary method
			dob = dict[_name];			
			if (dob != null) 
			{
				dict[_name] = null;
				dob = null;
			}
		}
		public static function GetDisplayObjByIndex(_index:int):DisplayObj
		{
			return displayObjs[_index];
		}
		
		// This also adds it if it's not already there
		public static function GetDisplayObjByName(_name:String):DisplayObj
		{
			
			var dob:DisplayObj;
			
			//dictionary method
			dob = dict[_name];			
			if (dob != null) return dob;

			if (PROJECT::useStage3D == false)
			{
//				trace("Missing Display Object " + _name);
			}
			
			if (PROJECT::useStage3D == false)
			{
			dob = Add(_name);
			return dob;
			}
			
			return null;
			

			// slow test method
			/*
			var i:int = 0;
			for (i = 0; i < displayObjs.length; i++)
			{
				dob = displayObjs[i];
				if (dob.origName == _name)
				{
					return dob;
				}
			}
			Utils.print("GetDisplayObjByName: having to add object " + _name);
			dob = Add(_name, 0);
			return dob;
			*/
		}
		

		
		public static function AddBitmapFont(bmFont:BitmapFont,_name:String,_modifier:PreparingModifier)
		{
			var fontDobj:DisplayObj;
			fontDobj = new DisplayObj(null, 0, null,null,_name);	// don't create moveiclip
			fontDobj.CreateBitmapFont(bmFont,_modifier);
			
			dict[_name] = fontDobj;
			displayObjs.push(fontDobj);
		}
		
		
		
		
		
		public static function Create(mcName:String,_instName:String,flags:String="",_callback:Function= null):int
		{
			var classRef:Class = getDefinitionByName(mcName) as Class;
			var mc:MovieClip = new classRef() as MovieClip;
			if (_callback != null)
			{
				_callback(mc);
			}
			
			displayObjs.push(new DisplayObj(mc , 1, null));
			return 0
		}		

		public static function AddDobjEmptyBitmap(name:String, width:int, height:int,transparent:Boolean):DisplayObj
		{
			
			var dobj:DisplayObj = new DisplayObj(null,1,null);
			dobj.frames = new Vector.<DisplayObjFrame>();
			var dof:DisplayObjFrame = new DisplayObjFrame();	
			dof.bitmapData = new BitmapData(width, height, transparent, 0);
			dof.xoffset = 0;
			dof.yoffset = 0;
			dof.sourceRect = new Rectangle(0, 0, width, height);
			dof.point = new Point(0, 0);
			dobj.frames.push(dof);
			
			displayObjs.push(dobj);
			return dobj;
		}
		
		

		
		public static function Add(mcName:String,modifier:PreparingModifier=null,_instName:String = null):DisplayObj
		{
			if (_instName == null) _instName = mcName;
			
			var classRef:Class = null;
			
			if (modifier == null)
			{
				modifier = mod_default;
			}

			
			try
			{
				classRef = getDefinitionByName(mcName) as Class;
			}
			catch (e:Error)
			{
				classRef = null;
			}
			if (classRef != null)
			{
				var mc:MovieClip = new classRef() as MovieClip;
				
				
				var dispobj:DisplayObj = new DisplayObj(mc , 1, modifier, null, _instName);
				dict[_instName] = dispobj;
				displayObjs.push(dispobj);
				
				if (PROJECT::useStage3D)
				{
					Utils.RemoveMovieClipEntirely(mc);	
				}
				
				
				return dispobj;
			}
			else
			{
//				Utils.traceerror("Graphic Objects - can't find obj: " + mcName);
				displayObjs.push(null);
			}
			return null;
		}
		
		public static function GetFrameIndexLabel(gindex:int,label:String):int
		{
			var dobj:DisplayObj = displayObjs[gindex];
			for each(var o:Object in dobj.labels)
			{
				if (o.labelName == label) 
				{
					return o.frameIndex;
				}
			}
			return 0;
		}
		
		
		public static function GetPixelAt(gindex:int, _frame:int, _x:int, _y:int):uint
		{
			var bd:BitmapData = displayObjs[gindex].frames[_frame].bitmapData;
			var pix:uint = bd.getPixel32(_x, _y);
			return pix;			
		}
		
		
		
		

		
		
		/*
		public static function Recreate(mcName:String,_instName:String,flags:int,_callback:Function= null):int
		{
			var _id:int = GetIndexByName(_instName);
			if (_id == -1) 
			{
				return -1;
			}

			var classRef:Class = getDefinitionByName(mcName) as Class;
			var mc:MovieClip = new classRef() as MovieClip;
			if (_callback != null)
			{
				_callback(mc);
			}
			
			graphicobjs[_id]=(new DisplayObj(mc , 1, flags));
			return _id;
		}		
		*/
		
	}
	
}
