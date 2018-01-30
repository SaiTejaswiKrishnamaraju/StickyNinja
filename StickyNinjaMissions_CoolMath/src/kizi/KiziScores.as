package kizi 
{
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class KiziScores 
	{
		public static function reportScore(boardName:String, value:Number):void 
		{
			if (KiziAPI.apiLoaded)
				KiziAPI.api.scores.reportScore(boardName, value);
		}
	}
}