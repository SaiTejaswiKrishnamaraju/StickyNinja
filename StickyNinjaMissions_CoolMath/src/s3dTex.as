package  
{
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class s3dTex 
	{
		public var byteArray:ByteArray;
		public var texture:Texture;
		public var width:int;
		public var height:int;
		public var format:String;
		public var shaderName:String;
		public var id:int;
		
		public function s3dTex(_texture:Texture,_width:int,_height:int,_format:String=Context3DTextureFormat.BGRA,_shaderName:String="normal",_id:int=0) 
		{
			texture = _texture;
			width = _width;
			height = _height;
			format = _format;
			shaderName = _shaderName;
			id = _id;
		}
		
		public function CreateTexture()
		{
			if (PROJECT::useStage3D)
			{
				texture = s3d.context3D.createTexture(width, height, format, false, 0);
			}

		}
		
		
	}

}