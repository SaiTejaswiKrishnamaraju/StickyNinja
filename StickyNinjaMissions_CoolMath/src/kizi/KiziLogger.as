package kizi
{
	/**
	 * ...
	 * @author 
	 */
	public class KiziLogger 
	{
		public static var logLevel:int;
		// very detailed output
		public static const VERBOSE:int = 2;
		// debug output, useful for development
		public static const DEBUG:int = 1;
		// only errors
		public static const ERROR:int = 0;
		public static function verbose(...params):void
		{
			log(2, params.join(" "));
		}
		
		public static function debug(...params):void
		{
			log(1, params.join(" "));
		}
		
		public static function error(...params):void
		{
			log(0, params.join(" "));
		}
		
		public static function log(logLevel:int, message:String):void
		{
			if (logLevel <= KiziLogger.logLevel)
			{
				var now:Date = new Date();
				var datetimeString:String = now.getDay() + "." + now.getMonth() + "." + now.getFullYear() + " " + now.getHours() + ":" + now.getMinutes() + ":" + now.getSeconds();
				trace(datetimeString + " - Host: " + message);
			}
		}
	}

}