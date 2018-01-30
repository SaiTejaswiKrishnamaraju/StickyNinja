package TexturePackage
{
	/**
	 * ...
	 * @author 
	 */
	public class PreparingCompression 
	{
		public static var COMPRESSION_NORMAL:int = 0;
		public static var COMPRESSION_NONE:int = 1;
		
		public var ios:int;
		public var android:int;
		
		public function PreparingCompression(_android:int=0,_ios:int=0) 
		{
			android = _android;
			ios = _ios;
		}
		
		
		
	}

}