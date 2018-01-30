
package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class Vars 
	{
		static var list:Vector.<Var>;
		static var dict:Dictionary;
		
		
			[Embed(source = "../bin/VarsData.xml", mimeType = "application/octet-stream")] 
			private static var class_vars:Class; 
		
		
		public function Vars() 
		{
			
		}
		
		public static function InitOnce()
		{
			if (Game.load_vars_data == false)
			{
				var xml:XML = new XML(new class_vars()) as XML; 
				DecodeXML(xml);
			}
			else
			{
				ReloadXML();
			}
		}
		
		static var xmlLoader:URLLoader;
		
		// call this on a keypress
		public static function ReloadXML()
		{
			if (Game.load_vars_data)
			{			
				XML.ignoreWhitespace = true;
								
				xmlLoader = new URLLoader();			
				xmlLoader.addEventListener(Event.COMPLETE, XMLLoaded,false,0,true);
				xmlLoader.load(new URLRequest("VarsData.xml"));
			}
		}
		
		public static function XMLLoaded(e:Event) 
		{
			xmlLoader.removeEventListener(Event.COMPLETE, XMLLoaded);
			
			var xml:XML = new XML(e.target.data) as XML; 
			DecodeXML(xml);
			
		}
		static function DecodeXML(_xml:XML)
		{
			XML.ignoreWhitespace = true;			
			list = new Vector.<Var>();
			var i:int;
			var xml:XML = _xml;
			for (i = 0; i < xml.variable.length(); i++)
			{				
				var vx:XML = xml.variable[i];
				var v:Var = new Var();
				v.name = vx.@name;
				v.type = vx.@type;
				v.valueString = vx.@value;
				v.valueInt = int(v.valueString);
				v.valueNumber = Number(v.valueString);
				v.valueBool = Boolean(v.valueString);
				
				var s:String = vx.@value;
				v.valueArray = s.split(",");				
				
//				trace("var " + v.name + " " + v.valueString);
				list.push(v);
			}
			
			dict = new Dictionary();
			for each(var v:Var in list)
			{
				dict[v.name] = v;
			}
		}
		
		public static function TraceAll()
		{
			for each(var v:Var in list)
			{
				v.Trace();
			}
		}
		
		
		
		public static function GetVar(name:String):Var
		{
			return dict[name];
//			for each(var v:Var in list)
//			{
//				if (name == v.name) return v;
//			}
//			return null;
		}
		public static function GetVarAsString(name:String):String
		{
			return dict[name].valueString;
//			var v:Var = GetVar(name);
//			return v.valueString;
		}
		public static function GetVarAsNumber(name:String):Number
		{
			return dict[name].valueNumber;
//			var v:Var = GetVar(name);
//			return v.valueNumber;
		}
		public static function GetVarAsInt(name:String):int
		{
			return dict[name].valueInt;
//			var v:Var = GetVar(name);
//			return v.valueInt;
		}
		public static function GetVarAsArray(name:String):Array
		{
			return dict[name].valueArray;
//			var v:Var = GetVar(name);
//			return v.valueArray;
		}
		
	}

}

