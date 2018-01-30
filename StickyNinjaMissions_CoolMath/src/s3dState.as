package  
{
	if (PROJECT::useStage3D)
	{
	import flash.display3D.textures.Texture;
	}
	/**
	 * ...
	 * @author 
	 */
	public class s3dState 
	{
		PROJECT::useStage3D
		{
		private var _tx:s3dTex;
		}
		public var shader:s3dShader;
		private var _xpos:Number;
		private var _ypos:Number;
		private var _programIndex:int;
		private var _blendMode:int;
		
		private var _shaderName:String;
		private var _shaderFullName:String;
		
		public var tx_updated:Boolean;
		public var pos_updated:Boolean;
		public var shader_updated:Boolean;
		public var program_updated:Boolean;
		public var blendMode_updated:Boolean;
		
		private var updated:Boolean;

		
		public function s3dState() 
		{
			Reset();
		}
		
		public function Reset()
		{
			if (PROJECT::useStage3D)
			{
			_tx = null;
			}
			_xpos = 0;
			_ypos = 0;
			_programIndex = 0;
			updated = false;
			shader = null;
			_blendMode = s3d.BLENDMODE_ALPHA;
			_shaderName = "";
			_shaderFullName = "";
			
			shader_updated = false;
			tx_updated = false;
			pos_updated = false;
			program_updated = false;
			blendMode_updated = false;
			
		}
		
		PROJECT::useStage3D
		{
		public function set tx(value:s3dTex):void 
		{
			if (value != _tx)
			{
				tx_updated = true;
			}
			_tx = value;
		}
		}

		public function set shaderName(value:String):void 
		{
//			if (value != _shaderName)
//			{
//				shader_updated = true;
//			}
			_shaderName = value;
			
		}

		public function set shaderFullName(value:String):void 
		{
			_shaderFullName = value;
			
		}
		
		public function set blendMode(value:int):void 
		{
			if (value != _blendMode)
			{
				blendMode_updated = true;				
			}
			_blendMode = value;
		}
		
		public function set xpos(value:Number):void 
		{
			_xpos = value;
			pos_updated = true;
		}
		
		public function set ypos(value:Number):void 
		{
			_ypos = value;
			pos_updated = true;
		}
		
		public function set programIndex(value:int):void 
		{
			_programIndex = value;
			program_updated = true;
		}
		
		PROJECT::useStage3D
		{
		public function get tx():s3dTex 
		{
			return _tx;
		}
		}		
		public function get xpos():Number 
		{
			return _xpos;
		}
		
		public function get ypos():Number 
		{
			return _ypos;
		}

		public function get shaderName():String 
		{
			return _shaderName;
		}

		public function get shaderFullName():String 
		{
			return _shaderFullName;
		}
		
		public function get blendMode():int
		{
			return _blendMode;
		}
		
		public function get programIndex():int 
		{
			return _programIndex;
		}
	}

}