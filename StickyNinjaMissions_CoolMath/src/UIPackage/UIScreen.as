package UIPackage  
{
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UIScreen
	{
		public var name:String;
		public var overlay:Boolean;
		public var theClass:Class;
		public var params:Object;
		
		public function UIScreen(_name:String,_overlay:Boolean,_className:Class,_params) 
		{
			name = _name;
			overlay = _overlay;
			theClass = _className;
			params = _params;
			
		}
		
	}

}