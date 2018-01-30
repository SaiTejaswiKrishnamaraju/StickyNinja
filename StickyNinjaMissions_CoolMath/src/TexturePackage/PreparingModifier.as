package TexturePackage
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class PreparingModifier 
	{
		public var type:String;
		public var value:String;
		public var addBorder:Boolean;
		public var forcedRectangle:Rectangle;
		public var compression:PreparingCompression;
		public var scale:Number;
		public var frameList:Array;
		
		public function PreparingModifier(_type:String, _value:String, _addBorder:Boolean, _forcedRectangle:Rectangle = null ,_compression:PreparingCompression=null,_scale:Number=1,_frameList:Array = null) 
		{
			frameList = _frameList;
			value = _value;
			type = _type;
			addBorder = _addBorder;
			forcedRectangle = _forcedRectangle;
			scale = _scale;
			compression = _compression;
			if (compression == null) compression = new PreparingCompression();
		}
		
		public function IsForcedRectangle():Boolean
		{
			if (forcedRectangle == null) return false;
			return true;
		}
		public function IsSeparateTexture():Boolean
		{
			if (type == "page" && value == "separate") return true;
			if (type == "page" && value == "separate_scale_up") return true;
			return false;
		}
		public function IsSeparateTextureScaledUp():Boolean
		{
			if (type == "page" && value == "separate_scale_up") return true;
			return false;
		}
		
	}

}