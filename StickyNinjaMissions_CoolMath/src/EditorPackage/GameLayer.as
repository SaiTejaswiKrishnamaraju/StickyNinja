package EditorPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class GameLayer 
	{
		public var name:String;
		public var zpos:Number;
		public function GameLayer() 
		{
			
		}
		public function FromXML(x:XML)
		{
			name = XmlHelper.GetAttrString(x.@name, "");
			zpos = XmlHelper.GetAttrNumber(x.@zpos, 0);

		}
		
	}

}