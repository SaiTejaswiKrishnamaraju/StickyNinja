package kizi 
{
	/**
	 * ...
	 * @author 
	 */
	public class KiziGameVars 
	{
		public static function getVar(key:String, defaultValue:*):*
		{
			if (KiziAPI.apiLoaded && KiziAPI.api.customVars[key] != undefined)
				return KiziAPI.api.customVars[key];
			else
				return defaultValue;
		}
	}

}