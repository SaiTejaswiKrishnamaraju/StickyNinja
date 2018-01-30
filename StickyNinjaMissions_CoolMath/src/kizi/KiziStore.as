package kizi 
{
	/**
	 * ...
	 * @author 
	 */
	public class KiziStore 
	{	
		// purchase failure return codes
		public static const ITEM_MAXED_OUT:String = "ITEM_MAXED_OUT";
		public static const NOT_ENOUGH_COINS:String = "NOT_ENOUGH_COINS";
		public static const ITEM_NOT_FOUND:String = "ITEM_NOT_FOUND";
		public static const UNKNOWN_ERROR:String = "UNKNOWN_ERROR";
				
		public static function getItemPrice(itemName:String):int
		{
			if (KiziAPI.apiLoaded)
				return KiziAPI.api.store.getItemPrice(itemName);
			else
				return 0;
		}
		
		public static function getItemLevelPrices(itemName:String):Array
		{
			if (KiziAPI.apiLoaded)
				return KiziAPI.api.store.getItemLevelPrices(itemName);
			else
				return [];
		}
		
		public static function getItemBundleSize(itemName:String):int
		{
			if (KiziAPI.apiLoaded)
				return KiziAPI.api.store.getItemBundleSize(itemName);
			else
				return 0;
		}
		
		public static function purchaseItem(itemName:String, callback:Function, suppressPurchasePopup:Boolean = false):void 
		{
			if (KiziAPI.apiLoaded)
				KiziAPI.api.store.purchaseItem([itemName], callback, suppressPurchasePopup);
		}
		
		public static function purchaseItems(itemNames:Array, callback:Function, suppressPurchasePopup:Boolean = false):void 
		{
			if (KiziAPI.apiLoaded)
				KiziAPI.api.store.purchaseItems(itemNames, callback, suppressPurchasePopup);
		}
	}

}