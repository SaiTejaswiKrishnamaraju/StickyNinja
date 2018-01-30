package EditorPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class EdObjMarker 
	{
		public var xpos:Number;
		public var ypos:Number;
		public var type:String;
		public var data:String;
		public var frame:int;
		public var radius:int;
		public var objParameters:ObjParameters;
		
		public function EdObjMarker() 
		{
			xpos = 0;
			ypos = 0;
			type = "";
			data = "";
			frame = 0;
			radius = 10;
			UpdateParams();
		}

		public function UpdateParams()
		{
			objParameters = new ObjParameters();
			objParameters.Add("marker_x", xpos.toString(),true,"xpos");
			objParameters.Add("marker_y", ypos.toString(),true,"ypos");
			objParameters.Add("marker_type", type,true,"type","string");
			objParameters.Add("marker_data", data,true,"data","string");
			objParameters.Add("marker_frame", frame.toString(),true,"frame");
			objParameters.Add("marker_radius", radius.toString(),true,"radius");
		}
	}

}