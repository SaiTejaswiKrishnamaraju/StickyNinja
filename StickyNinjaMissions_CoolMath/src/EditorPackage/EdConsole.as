package EditorPackage 
{
	/**
	 * ...
	 * @author ...
	 */
	public class EdConsole 
	{
		static var lineList:Vector.<EdConsoleItem>;
		static var activeList:Vector.<EdConsoleItem>;
		
		
		public function EdConsole() 
		{
			
		}
		public static function InitOnce()
		{
			lineList = new Vector.<EdConsoleItem>();
			activeList = new Vector.<EdConsoleItem>();
		}
		
		
		public static function Add(text:String)
		{
			//Utils.trace(text);
			activeList.push(new EdConsoleItem(text));
			lineList.push(new EdConsoleItem(text));
		}
		
		
		public static function UpdateOncePerFrame()
		{
		}
		
	}

}