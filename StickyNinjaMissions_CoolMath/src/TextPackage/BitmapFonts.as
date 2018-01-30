package TextPackage 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class BitmapFonts 
	{
		static var fontList:Vector.<BitmapFont>;
		
		public function BitmapFonts() 
		{
			
		}
		
		public static function InitOnce()
		{
			fontList = new Vector.<BitmapFont>();
		}
		
		public static function Add(x:XML, mc:MovieClip,_name:String):BitmapFont
		{
			var bmFont:BitmapFont = new BitmapFont();
			bmFont.Create(x, mc,_name);
			fontList.push(bmFont);
			return bmFont;
		}
		
	}

}