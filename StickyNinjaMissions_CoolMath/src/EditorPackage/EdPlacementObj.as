package EditorPackage 
{
	/**
	 * ...
	 * @author ...
	 */
	public class EdPlacementObj 
	{
		public var typeName:String;
		public var xpos:Number;
		public var ypos:Number;
		public var xoff:Number;
		public var yoff:Number;
		public var rot:Number;
		public var scale:Number;
		public var isXFlipped:Boolean;
		public var objChangeValue:Number;
		public var objParameters:ObjParameters;
		
		// Objects which are currently held by the cursor in placement mode
		
		public function EdPlacementObj(_typeName:String="",_params:ObjParameters = null) 
		{
			typeName = _typeName;
			xoff = 0;
			yoff = 0;
			rot = 0;
			scale = 1;
			isXFlipped = false;
			xpos = 0;
			ypos = 0;
			objChangeValue = 0.5;
			objParameters = null;
			if (_params != null)
			{
				objParameters = _params.Clone();
			}
		}
		
	}

}