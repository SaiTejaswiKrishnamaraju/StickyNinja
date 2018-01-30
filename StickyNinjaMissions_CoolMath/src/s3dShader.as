package  
{
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class s3dShader 
	{
		public var name:String;
		public var vertexShader:ByteArray;
		public var fragmentShader:ByteArray;
		public var program:Program3D;
		
		public function s3dShader(_name:String,_vs:ByteArray,_fs:ByteArray) 
		{
			name = _name;
			vertexShader = _vs;
			fragmentShader = _fs;
			program = s3d.context3D.createProgram();
			program.upload(vertexShader, fragmentShader); // Upload the combined program to the video Ram

		}
		
	}

}