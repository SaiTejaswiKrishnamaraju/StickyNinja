package kizi  
{
	
	/**
	 * ...
	 * @author 
	 */
	public class KiziApiInitiatedEvents
	{
		public static const USER_LOGGED_IN:KiziApiInitiatedEvents = new KiziApiInitiatedEvents(USER_LOGGED_IN);
		public static const COIN_BALANCE_CHANGED:KiziApiInitiatedEvents = new KiziApiInitiatedEvents(COIN_BALANCE_CHANGED);
		public function KiziApiInitiatedEvents(gs:KiziApiInitiatedEvents) 
		{
			
		}
		public function toString():String
		{
			switch(this) {
				case KiziApiInitiatedEvents.USER_LOGGED_IN:
					return "USER_LOGGED_IN";
				case KiziApiInitiatedEvents.COIN_BALANCE_CHANGED:
					return "COIN_BALANCE_CHANGED";
				default:
					return undefined;
			}
		}
	}
	
}