package kizi 
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	/**
	 * ...
	 * @author 
	 */
	public dynamic class KiziInventory extends Proxy 
	{
		flash_proxy override function getProperty(name:*):*
		{
			if (KiziAPI.apiLoaded && KiziAPI.api.user && KiziAPI.api.user.inventory)
				return KiziAPI.api.user.inventory[name];
			else
				return undefined;
		}
		
		flash_proxy override function setProperty(name:*,value:*):void
        {
			if (KiziAPI.apiLoaded && KiziAPI.api.user && KiziAPI.api.user.inventory)
				KiziAPI.api.user.inventory[name] = value;
        }
	}

}