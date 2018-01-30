package TextPackage 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class BitmapFont 
	{
		public var lineHeight:int;
		public var base:int;
		public var pageW:int;
		public var pageH:int;
		public var chars:Vector.<BitmapFontChar>;
		public var map:Vector.<BitmapFontChar>;
		public var origMovieClip:MovieClip;
		public var fontName:String;
		
		public function BitmapFont() 
		{
			
		}
		
		public function GetCharById(id:int):BitmapFontChar
		{
			return map[id];
		}
		
		function InternalGetCharById(id:int):BitmapFontChar
		{
			for each(var char:BitmapFontChar in chars)
			{
				if (char.id == id) return char;
			}
			return null;
		}
		
		public function Create(xml:XML, mc:MovieClip,_name:String)
		{
			
			lineHeight = XmlHelper.GetAttrInt(xml.common.@lineHeight, 0);
			base = XmlHelper.GetAttrInt(xml.common.@base, 0);
			pageW = XmlHelper.GetAttrInt(xml.common.@scaleW, 0);
			pageH = XmlHelper.GetAttrInt(xml.common.@scaleH, 0);
			
			origMovieClip = mc;
			fontName = _name;
			
			var x:XML;
			var num:int = xml.chars.char.length();

			chars = new Vector.<BitmapFontChar>();
			
			for (var i:int = 0; i < num; i++)
			{
				x = xml.chars.char[i];
				var char:BitmapFontChar = new BitmapFontChar();
				char.FromXML(x);
				chars.push(char);
			}
			
			map = new Vector.<BitmapFontChar>();
			for (var i:int = 0; i < 256; i++)
			{
				map.push(InternalGetCharById(i));
			}
			
		}
		
		
	}

}