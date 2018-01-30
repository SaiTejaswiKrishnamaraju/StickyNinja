package UIPackage 
{
	import TexturePackage.PreparingModifier;
	/**
	 * ...
	 * @author 
	 */
	public class PreparingObject 
	{
		public var name:String;
		public var type:String;
		public var modifier:PreparingModifier;
		public var fontXMLClass:Class;
		
		public function PreparingObject(_type:String,_name:String="",_modifier:PreparingModifier=null,_fontXMLClass:Class=null) 
		{
			name = _name;
			type = _type;
			modifier = _modifier;
			fontXMLClass = _fontXMLClass;
		}
		
	}

}