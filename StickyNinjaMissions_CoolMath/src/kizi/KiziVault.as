package kizi 
{
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;	
	import flash.utils.Proxy;
	/**
	 * ...
	 * @author ...
	 */
	public class KiziVault extends Proxy 
	{
		public function KiziVault() 
		{
		}
		
		flash_proxy  override function setProperty(name:*, value:*):void
		{
			if (KiziAPI.apiLoaded && KiziAPI.api.vault != undefined)
				KiziAPI.api.vault[name] = value;
		}
		
		flash_proxy  override function getProperty(name:*):*
		{
			if (KiziAPI.apiLoaded && KiziAPI.api.vault != undefined)
			{
				return KiziAPI.api.vault[name];
			}
			else
			{
				return null;
			}
		}
		
		
	}
}