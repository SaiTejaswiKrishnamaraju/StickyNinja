package TexturePackage
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import TextPackage.BitmapFont;
	import TextPackage.BitmapFonts;
	import UIPackage.PreparingObject;
	import UIPackage.UIX;
	import UIPackage.UIX_Component;
	/**
	 * ...
	 * @author 
	 */
	public class Preparing 
	{


		
		public function Preparing() 
		{
			
		}
		
		
		public static function GetPreparingList():Array
		{
			return PreparingData.preparingList;
		}
		
		
		static var isInitialised:Boolean = false;
		
		public static function AddInUIX()
		{
			var usedMCList:Array = new Array();
			
			var uix_array:Array = UIX.GetPreparingList();
			for each(var comp:UIX_Component in uix_array)
			{				
				var po:PreparingObject = new PreparingObject("gfx", comp.mcName);

				po.modifier = PreparingData.mod_ui;
				
				if (comp.uiPage == 1)				
				{
					po.modifier = PreparingData.mod_hud;
				}
				
				var compName:String = po.name;
				if (usedMCList.indexOf(compName) == -1)
				{					
					PreparingData.preparingList.push(po);
					usedMCList.push(compName);
				}
				
			}
		}
		
		public static function RemoveUnwantedMovieClip(dobj:DisplayObj)
		{
				if (dobj != null)
				{
					Utils.RemoveMovieClipEntirely(dobj.origMC);
					dobj.origMC = null;
					var findex:int = 0;
					for each(var f:DisplayObjFrame in dobj.frames)
					{
						if (f.bitmapData != null)
						{
							//trace(" bitmap data " + dobj.origName + "   " + findex);
						}
						findex++;
					}
					if (dobj.origMC != null)
					{
						var aa:int = 0;
					}
				}
			
		}
		public static function RemoveAllUnwantedMovieClips()
		{
			if (PROJECT::useStage3D == false) return;
			for each(var dobj:DisplayObj in GraphicObjects.displayObjs)
			{
				RemoveUnwantedMovieClip(dobj);
			}
		}
		
		
		public static function Modify()
		{
			
			for each(var po:PreparingObject in PreparingData.preparingList)
			{				
				po.modifier = PreparingData.mod_default;
			}
			
			AddInUIX();
			
			var list:Array = PreparingData.modifyList;
			
			for (var i:int = 0; i < list.length / 2; i++)
			{
				var s0:String = list[(i * 2)];
				var s1:PreparingModifier = list[(i * 2) + 1];
				for each(var po:PreparingObject in PreparingData.preparingList)
				{
					if (po.name == s0)
					{
						po.modifier = s1;
					}
				}
			}

			/*
			if (PROJECT::useStage3D)
			{
				for (var i:int = 0; i < modifyList_Mobile.length / 2; i++)
				{
					var s0:String = modifyList_Mobile[(i * 2)];
					var s1:String = modifyList_Mobile[(i * 2) + 1];
					for each(var po:PreparingObject in preparingList)
					{
						if (po.name == s0)
						{
							po.data = s1;
						}
					}
				}
			}
			*/
			
		}
		
		public static function DoPreparingObject( po:PreparingObject)
		{
			if (po.modifier.type != "skip")
			{
				if (po.type == "gfx")
				{			
					if (Game.loadTextureFiles == false)
					{
						if(ApplicationDomain.currentDomain.hasDefinition(po.name))
						{						
							var dobj:DisplayObj = GraphicObjects.Add(po.name, po.modifier);
							//ApplyExternalOffsets(dobj);

							RemoveUnwantedMovieClip(dobj);
						}
					}
				}
				
				else if (po.type == "font")
				{
					var mcClass:Class = getDefinitionByName(po.name+"_mc") as Class;					
					var xml:XML = new XML(new po.fontXMLClass()) as XML; 
					var bmFont1:BitmapFont = BitmapFonts.Add(xml, new mcClass(),po.name);
					if (Game.loadTextureFiles == false)
					{
						GraphicObjects.AddBitmapFont(bmFont1, po.name, po.modifier);
					}					
				}
				else if (po.type == "skip")
				{
					var a:int = 0;
				}
			}
			
		}
		
		public static function Start()
		{
			if (isInitialised)
			{
				return;
			}
			
			if (Game.loadTextureFiles)
			{
				TexturePages.Create();
				isInitialised = true;
				return;				
			}

			
			Modify();
			
			for (var i:int = 0; i < PreparingData.preparingList.length; i++)
			{
				var po:PreparingObject = PreparingData.preparingList[i];
				DoPreparingObject(po);
			
			}
			TexturePages.Create();
			isInitialised = true;
		}
		
		
		
		/* Driving games */
		 
		/*
		static function ApplyExternalOffsets(dobj:DisplayObj)
		{
			if (dobj == null) return;
			var xml:XML = ExternalData.xml_ExportedBitmapsData;
			var numItems:int = xml.item.length();
			for (var i:int = 0; i < numItems; i++)
			{
				var x:XML = xml.item[i];
				var mcName:String = XmlHelper.GetAttrString(x.@mcname, "");
				var mcFrame:int = XmlHelper.GetAttrInt(x.@mcframe, 0);
				var xoff:int = XmlHelper.GetAttrInt(x.@xoff, 0);
				var xoffxf:int = XmlHelper.GetAttrInt(x.@xoffxf, 0);
				var yoff:int = XmlHelper.GetAttrInt(x.@yoff, 0);
				
				if (dobj.origName == mcName)
				{
					var frame:DisplayObjFrame = dobj.frames[mcFrame];
					if (frame.modifierScale != 1)
					{
						var a:int = 0;
					}
					frame.xoffsetxf = -xoffxf * frame.modifierScale;
					frame.xoffset = -xoff * frame.modifierScale;
					frame.yoffset = -yoff * frame.modifierScale;
				}
			}
		}
		*/
		
		
	}

}