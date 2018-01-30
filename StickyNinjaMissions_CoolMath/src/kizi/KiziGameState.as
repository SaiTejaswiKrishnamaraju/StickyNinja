package kizi 
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	/**
	 * ...
	 * @author 
	 */
	public dynamic class KiziGameState extends Proxy 
	{	
		flash_proxy override function getProperty(name:*):*
		{
			if (KiziAPI.apiLoaded && KiziAPI.api.gameState)
				return KiziAPI.api.gameState[name];
			else
				return undefined;
		}
		
		flash_proxy override function setProperty(name:*,value:*):void
        {
			if (KiziAPI.apiLoaded && KiziAPI.api.gameState)
				KiziAPI.api.gameState[name] = value;
        }
	}

}