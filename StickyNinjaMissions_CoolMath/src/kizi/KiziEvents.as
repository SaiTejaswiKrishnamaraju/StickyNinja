package kizi 
{
	/**
	 * ...
	 * @author 
	 */
	public class KiziEvents 
	{
		public static function cycleStarted(callback:Function):void 
		{
			KiziLogger.debug("cycleStarted called");
			KiziAPI.api.events.onCycleStart(callback);
		}
		
		public static function cycleEnded(callback:Function):void 
		{
			KiziLogger.debug("cycleEnded called");
			KiziAPI.api.events.onCycleEnd(callback);
		}
		
		public static function scoreScreenClosed(callback:Function):void 
		{
			KiziLogger.debug("scoreScreenClosed called");
			KiziAPI.api.events.afterScoreScreen(callback);
		}
		
		public static function mainMenuShown():void 
		{
			KiziLogger.debug("mainMenuShown called");
			KiziAPI.api.events.onMainMenu();
		}
		
		
		public static function togglePause():void 
		{
			KiziLogger.debug("togglePause called");
			KiziAPI.api.events.onTogglePause();
		}
		
		public static function registerCallback(eventName:KiziApiInitiatedEvents, callbackFunction:Function):void 
		{
			KiziAPI.api.events.registerCallback(eventName, callbackFunction);
		}
	}
}