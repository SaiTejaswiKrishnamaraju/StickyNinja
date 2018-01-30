package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.*;
	import flash.system.System;
	
	/**
	* ...
	* @author Default
	*/
	public class ExternalData 
	{
		static var loadExternalLevels:Boolean = false;
		if (PROJECT::isExternal == true)
		{
			loadExternalLevels = true;
		}
		
		public function ExternalData() 
		{
		}
		
		public static var xml:XML;
		public static var levelsXml:XML;
		public static var PolyMaterialsXML:XML;
		public static var GameLayersXML:XML;
		public static var MaterialsXML:XML;
		public static var ObjectParamsXML:XML;
		public static var LayoutTemplatesXML:XML;
		public static var VehiclesXML:XML;

		public static var levelsSaveName:String = "Levels_Data.xml";
		public static var templatesSaveName:String = "Templates_Data.xml";
		
		
		[Embed(source = "../bin/Objects_Data.xml", mimeType = "application/octet-stream")] 
        private static var class_Objects_Data:Class; 
		
		[Embed(source = "../bin/PolyMaterials_Data.xml", mimeType = "application/octet-stream")] 
        private static var class_PolyMaterials_Data:Class; 
		
		[Embed(source = "../bin/GameLayers_Data.xml", mimeType = "application/octet-stream")] 
        private static var class_GameLayers_Data:Class; 
		
		[Embed(source = "../bin/Materials_Data.xml", mimeType = "application/octet-stream")] 
        private static var class_Materials_Data:Class; 
		
		[Embed(source = "../bin/ObjectParams_Data.xml", mimeType = "application/octet-stream")] 
        private static var class_ObjectParams_Data:Class; 
		
		[Embed(source = "../bin/Templates_Data.xml", mimeType = "application/octet-stream")] 
        private static var class_LayoutTemplates_Data:Class; 
		
		[Embed(source = "../bin/Vehicle_Data.xml", mimeType = "application/octet-stream")] 
        private static var class_Vehicle_Data:Class; 
		
		[Embed(source = "../bin/Levels_Data.xml", mimeType = "application/octet-stream")] 
        private static var class_Levels:Class; 
		
		
		static var xmlLoader:URLLoader;
		static var cb:Function;
		public static function Load(_cb:Function)
		{
			cb = _cb;
			
			if (loadExternalLevels)
			{			
				XML.ignoreWhitespace = true;
				xml = new XML(new class_Objects_Data()) as XML; 
								
				xmlLoader = new URLLoader();			
				xmlLoader.addEventListener(Event.COMPLETE, levelXmlLoaded,false,0,true);
				xmlLoader.load(new URLRequest("OutOfControl_Levels_Cathy_Data.xml"));
			}
			else
			{
				XmlAllLoadedInternal();
			}
		}

		static function RemoveXML()
		{
			System.disposeXML(xml);
			xml = null;
			System.disposeXML(PolyMaterialsXML);
			PolyMaterialsXML = null;
			System.disposeXML(GameLayersXML);
			GameLayersXML = null;
			System.disposeXML(MaterialsXML);
			MaterialsXML = null;
			System.disposeXML(ObjectParamsXML);
			ObjectParamsXML = null;
			System.disposeXML(LayoutTemplatesXML);
			LayoutTemplatesXML = null;
			System.disposeXML(VehiclesXML);
			VehiclesXML = null;
			System.gc();
		}
		
		
		static function XmlAllLoadedInternal()
		{
			var i:int;
			XML.ignoreWhitespace = true;

            xml = new XML(new class_Objects_Data()) as XML; 
			
 			PolyMaterialsXML = new XML(new class_PolyMaterials_Data()) as XML; 
			GameLayersXML = new XML(new class_GameLayers_Data()) as XML; 
			MaterialsXML = new XML(new class_Materials_Data()) as XML; 
			ObjectParamsXML = new XML(new class_ObjectParams_Data()) as XML; 
			LayoutTemplatesXML = new XML(new class_LayoutTemplates_Data()) as XML; 
			VehiclesXML = new XML(new class_Vehicle_Data()) as XML; 
			
			
//-------------------------------			
            levelsXml = new XML(new class_Levels()) as XML; 
			
			
			//levelsXml.appendChild(levelsXml1);
			//
			cb();		
			
		}
		
		
		
		public static function dataXmlLoaded(e:Event) 
		{
			var i:int;
			XML.ignoreWhitespace = true;
			levelsXml = new XML(e.target.data);

			cb();			
		}
		public static function levelXmlLoaded(e:Event) 
		{
			var i:int;
			XML.ignoreWhitespace = true;
			
			levelsXml = new XML(e.target.data) as XML; 
			
			cb();			
		}
		
		public static function OutputString(s:String)
		{
			if (PROJECT::useStage3D == false)
			{
				System.setClipboard(s);
			}
			
			
		}
		
		
	}
	
}

