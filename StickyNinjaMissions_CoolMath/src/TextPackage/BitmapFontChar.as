package TextPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class BitmapFontChar 
	{
		public var id:int;
		public var sourceX:int;
		public var sourceY:int;
		public var sourceW:int;
		public var sourceH:int;
		public var offsetX:int;
		public var offsetY:int;
		public var advanceX:int;
		public var pageIndex:int;
		public var channel:int;
		
		public function BitmapFontChar() 
		{
			
		}
		
		public function FromXML(xml:XML)
		{
			id = XmlHelper.GetAttrInt(xml.@id, 0);
			sourceX = XmlHelper.GetAttrInt(xml.@x, 0);
			sourceY = XmlHelper.GetAttrInt(xml.@y, 0);
			sourceW = XmlHelper.GetAttrInt(xml.@width, 0);
			sourceH = XmlHelper.GetAttrInt(xml.@height, 0);
			offsetX = XmlHelper.GetAttrInt(xml.@xoffset, 0);
			offsetY = XmlHelper.GetAttrInt(xml.@yoffset, 0);
			advanceX = XmlHelper.GetAttrInt(xml.@xadvance, 0);
			channel = XmlHelper.GetAttrInt(xml.@chnl, 0);			
		}
		
	}

}