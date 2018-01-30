package  
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class XmlHelper 
	{
		
		public function XmlHelper() 
		{
			
		}
		
		public static function GetAttrPoint(x:Object):Point
		{
			var val:String = "0,0";
			if (x != undefined) val = String(x);
			var a:Array = val.split(",");
			var p:Point = new Point(a[0], a[1]);
			return p;
		}
		public static function GetAttrString(x:Object,defaultvalue:String = ""):String
		{
			var val:String = defaultvalue;
			if (x != undefined) val = String(x);
			return val;
		}
		public static function GetAttrNumber(x:Object,defaultvalue:Number = 0):Number
		{
			var val:Number = defaultvalue;
			if (x != undefined) 
			{
				var s:String = String(x);
				val = Number(x);
			}
			return val;
		}
		
		public static function GetAttrInt(x:Object, defaultvalue:int = 0):int
		{
			var val:int = defaultvalue;
			if (x != undefined) val = int(x);
			return val;
		}
		public static function GetAttrBoolean(x:Object, defaultvalue:Boolean = false):Boolean
		{
			var val:Boolean = defaultvalue;
			if (x != null && x!=undefined) 
			{
				val = false;
				var s:String = String(x);
				s = s.toLowerCase();
				if (x == "true") val = true;
			}
			return val;
		}
		
		
		public static function Attr(name:String, value:Object, preSpace:Boolean = true ):String
		{
			if (value == null) value = "null";
			var s:String = "";
			if (preSpace) s += " ";
			s += name + '="';
			s += value.toString();
			s += '"';
			return s;
		}
		
	}
	
}