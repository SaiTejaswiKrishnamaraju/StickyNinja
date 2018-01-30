package TexturePackage
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class TexturePageIncludes 
	{
		


		public static function GetATF_ByteArray(index:int):ByteArray
		{
			if (PROJECT::isMobile)
			{
			var c:Class =  textureInclude.pages_atf[index];
			var ba:ByteArray = new c();
			return ba;
			}
			else
			{
				return null;
			}
		}
		
		public function TexturePageIncludes() 
		{
			
		}
		
		
		
	}

}