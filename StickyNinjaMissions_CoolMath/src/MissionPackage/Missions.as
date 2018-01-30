package MissionPackage
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class Missions 
	{
		static var list:Vector.<Mission>;
		
		public static var currentMissionIndex:int;
		public static var currentMissionLevelIndex:int;
		
		public static function TestPass():Boolean
		{
			return GetCurrentMissionLevel().TestPass();
		}
		public static function Update()
		{
			var result:String = GetCurrentMissionLevel().Update();
			if (result == MissionResult.FAIL)
			{
				Game.levelFailReason = GetCurrentMissionLevel().lastFailure;
				Game.levelSuccessFlag = false;
				Game.InitLevelState(Game.levelState_Complete);
			}
		}
		public static function GetCurrentMissionLevel():MissionLevel
		{
			return list[currentMissionIndex].missionLevels[currentMissionLevelIndex];
		}
		public static function GetCurrentMission():Mission
		{
			return list[currentMissionIndex];
		}
		public static function GetNextMission():Mission
		{
			if (IsLastMission()) return null;
			return list[currentMissionIndex+1];
		}
		
		
		public static function IsLastMission():Boolean
		{
			if (currentMissionIndex == list.length - 1) return true;
			return false;
		}
		public static function GetNextMissionLevel():MissionLevel
		{
			var m:Mission = GetCurrentMission();
			if (IsLastMission())
			{
				if (currentMissionLevelIndex == m.missionLevels.length - 1)
				{
					return null;
				}
			}
			if (currentMissionLevelIndex < m.missionLevels.length - 1)
			{
				return m.missionLevels[currentMissionLevelIndex + 1];
			}
			return GetNextMission().missionLevels[0];
			
		}
		
		public function Missions() 
		{
			
		}
		
		public static function InitForLevel()
		{
			var ml:MissionLevel = GetCurrentMissionLevel();
			for each(var mo:MissionObjective in ml.objectives)
			{
				if (mo.type == MissionType.HEALTH)
				{
					GameVars.lives = GameVars.maxLives = 1;
				}
			}
		}
		public static function InitOnce()
		{
			ClearAll();
		}
		public static function ResetList()
		{
			currentMissionIndex = 0;
			currentMissionLevelIndex = 0;			
			list = new Vector.<Mission>();			
		}
		public static function ClearAll()
		{
			currentMissionIndex = 0;
			currentMissionLevelIndex = 0;
			
			list = new Vector.<Mission>();
			
			MissionData.Init();
			
			list[0].available = true;
		}
		
		public static function UnlockAll()
		{
			for (var i:int = 0; i < list.length; i++)
			{
				var m:Mission = list[i];
				m.available = true;				
				
				for (var j:int = 0; j < m.missionLevels.length; j++)
				{
					m.missionLevels[j].available = true;
				}
			}
		}
		
		
		public static function UnlockNextLevel(missionIndex:int,levelIndex:int):int
		{
			var m:Mission = GetMission(missionIndex);
			levelIndex %= 4;
			
			if (levelIndex == 3) 
			{
				if (missionIndex == GetNumMissions() - 1)
				{
					// last mission
					return 0;
				}
				// unlock next mission lvel 1
				var m1:Mission = GetMission(missionIndex + 1);
				if (m1.available == false)
				{
					m1.newlyAvailable = true;
				}
				m1.available = true;
				
//				var l:Level = Levels.GetLevelByName(m1.levelNames[0]);
//				if (l.available == false)
//				{
//					l.newlyAvailable = true;
//				}
//				l.available = true;				
				return 2;
			}
			
			var toUnlockIndex:int = levelIndex + 1;
			
//			var l:Level = Levels.GetLevelByName(m.levelNames[toUnlockIndex]);
//			if (l.available == false)
//			{
//				l.newlyAvailable = true;
//			}
//			l.available = true;
			
			return 1;
		}
		
		public static function GetNumMissions():int
		{
			return list.length;
		}
		public static function GetMission(index:int):Mission
		{
			return list[index];
		}
		
		static function AddMission(_id:String, _name:String, _desc:String):Mission
		{
			var m:Mission = new Mission();
			m.id = _id;
			m.name = _name;
			m.description = _desc;
			m.index = addMissionIndex;
			addMissionIndex++;
			
			list.push(m);
			
			return m;
		}
		public static var addMissionIndex:int;
		
		
		public static function ToByteArray(ba:ByteArray)
		{			
			for each(var m:Mission in list)
			{
				ba.writeBoolean(m.available);
				ba.writeBoolean(m.newlyAvailable);
				for each(var ml:MissionLevel in m.missionLevels)
				{
					ml.ToByteArray(ba);
				}
			}
		}

		public static function FromByteArray(ba:ByteArray)
		{			
			for each(var m:Mission in list)
			{
				m.available = ba.readBoolean();
				m.newlyAvailable = ba.readBoolean();
				for each(var ml:MissionLevel in m.missionLevels)
				{
					ml.FromByteArray(ba);
				}
			}
		}
		
		
	}

}