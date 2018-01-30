package  
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class s3dMaterial 
	{
		// a material describes a rendering procedure:
		// vertex and index buffer types
		// program types 
		// blend modes
		
		// passed in from creator:
		var context3D:Context3D;
		
		var program:s3dProgram;
		
		
		public function s3dMaterial() 
		{
			
		}
		
		public var renderRectangleFunction:Function;
		public var renderTriangleListFunction:Function;
		public var renderLineFunction:Function;
		
		public function SetVertexBufferState(vb:VertexBuffer3D)
		{
			context3D.setVertexBufferAt(0, vb, 0, Context3DVertexBufferFormat.FLOAT_2); // x,y
			context3D.setVertexBufferAt(1, vb, 2, Context3DVertexBufferFormat.FLOAT_2); // u,v
			context3D.setVertexBufferAt(2, vb, 4, Context3DVertexBufferFormat.BYTES_4); // Color data
			
		}
		
		
	}

}