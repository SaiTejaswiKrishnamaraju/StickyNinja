package LicPackage
{
	import flash.external.ExternalInterface;
	import MissionPackage.Missions;
	/**
	 * ...
	 * @author ...
	 */
	public class LicCoolmath 
	{
		
		public static function InitFromPreloader()
		{
			trace("Coolmath InitFromPreloader");
			levelsJustUnlocked = false;
			
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("unlockAllLevels", UnlockAllLevels);
			}
			
		}
		
		public static var levelsJustUnlocked:Boolean = false;
		public static function UnlockAllLevels():void 
		{
			trace("Coolmath UnlockAllLevels");
			Missions.UnlockAll();
			SaveData.Save();
			levelsJustUnlocked = true;
		}

		public static function PlayButtonPressed():void 
		{
			trace("Coolmath PlayButtonPressed");
			
			if (ExternalInterface.available)
			{
				ExternalInterface.call("cmgGameEvent", "start");
			}
		}

		public static function LevelButtonOrContinueButtonPressed(missionIndex:int,levelIndex:int):void 
		{
			var totalLevelIndex:int = (missionIndex * 5) + levelIndex;
			
			trace("Coolmath LevelButtonOrContinueButtonPressed "+missionIndex.toString()+" "+levelIndex.toString()+"  level "+totalLevelIndex);
			
			var s:String = totalLevelIndex.toString();
			if (ExternalInterface.available)
			{
				ExternalInterface.call("cmgGameEvent", "start", s);
			}
		}

		public static function RestartPressed(missionIndex:int,levelIndex:int):void 
		{
			var totalLevelIndex:int = (missionIndex * 5) + levelIndex;
			trace("Coolmath RestartPressed "+missionIndex.toString()+" "+levelIndex.toString()+"  level "+totalLevelIndex);
			
			var s:String = totalLevelIndex.toString();
			if (ExternalInterface.available)
			{
				ExternalInterface.call("cmgGameEvent", "replay", s);
			}
		}
		
	}

}