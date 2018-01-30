package kizi 
{
	/**
	 * ...
	 * @author 
	 */
	public class KiziUser 
	{
		public static var inventory:KiziInventory;
		
		{
			inventory = new KiziInventory();
		}
		
		public static function getCoins():int { return KiziAPI.api.user.coins; }
		public static function getLevel():int { return KiziAPI.api.user.level; }
		public static function getExperience():int { return KiziAPI.api.user.experience; }
		public static function getLogin():int { return KiziAPI.api.user.login; }
		public static function isGuest():int { return KiziAPI.api.user.isGuest(); }
	}

}