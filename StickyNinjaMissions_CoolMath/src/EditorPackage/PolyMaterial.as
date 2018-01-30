package EditorPackage 
{
	/**
	 * ...
	 * @author ...
	 */
	public class PolyMaterial 
	{
		public var name:String;
		public var graphicName:String;
		public var fillFrame:int;
		public var fillFrame1:int;
		public var fillFrame2:int;
		public var fillName:String;
		public var editorRenderFunctionName:String;
		public var initFunctionName:String
		public var materialName:String;
		public var fixed:Boolean;
		public var initType:String;
		public var edType:String;
		public var collisionCategory:int;
		public var collisionMask:int;
		public var sensorCategory:int;
		public var sensorMask:int;
		public var fluidCategory:int;
		public var fluidMask:int;
		public var defaultGameLayer:String;
		
		public var instanceParams:Array;
		public var instanceParamsDefaults:Array;

		
		public function PolyMaterial() 
		{
			editorRenderFunctionName = null;
		}
		
	}

}