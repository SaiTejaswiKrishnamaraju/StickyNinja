package MissionPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class MissionData 
	{
		
		public function MissionData() 
		{
			
		}


		static var numLevelsPerMission:int;
		static var currentMission:Mission;
		static var currentMissionLevel:int;
		static var currentMissionIndex:int;
		static var totalMissions:int;
		
		// creates missions if need be
		static function AddLevel(_name:String,_levelName:String=""):MissionLevel
		{
			if (currentMission == null)
			{
				currentMission = Missions.AddMission(currentMissionIndex.toString(),currentMissionIndex.toString(), "");
			}
			
			if (currentMissionLevel >= numLevelsPerMission)
			{
				currentMissionLevel = 0;
				currentMissionIndex++;
				currentMission = Missions.AddMission(currentMissionIndex.toString(),currentMissionIndex.toString(), "");				
			}
			
			currentMissionLevel++;
			totalMissions++;
			
			trace("mission " + totalMissions + ": " + _name + "  /  " + _levelName);
			
			return currentMission.AddLevel(_name, _levelName);
		}
		
		public static function SetOrder()
		{
			totalMissions = 0;
			currentMissionIndex = 0;
			currentMissionLevel = 0;
			currentMission = null;
			numLevelsPerMission = 5;
			
			var l:MissionLevel;
			
			Missions.ResetList();
			Missions.addMissionIndex = 0;

//-------------------------------Group START ---------------------------------			


			l = AddLevel("Sticky Start", "tutorial");
			l.SetJumpMedals(5, 10);
			l.AddObjective("Defeat All Enemies", MissionType.KILLS, -1);
			l.available = true;
			l.newlyAvailable = true;
			
			l = AddLevel("Urban Ninja", "training1");
			l.SetJumpMedals(8, 13);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = AddLevel("Downtown And Dangerous", "training2");
			l.SetJumpMedals(9,14);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			l = AddLevel("Dockland Duels", "docks1");
			l.SetJumpMedals(13,18);
			l.AddObjective("Defeat All Enemies", MissionType.KILLS, -1);
			
			l = AddLevel("Castle Argh", "castle1");
			l.SetJumpMedals(18,23);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			l = AddLevel("Central Park", "park1");
			l.SetJumpMedals(10,15);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			
//---------------			
			
			l = AddLevel("Ninjas At Work", "construction1");
			l.SetJumpMedals(12, 17);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = AddLevel("Downtown Treasure Hunt", "training2");
			l.SetJumpMedals(100,200);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);

			//l = AddLevel("Dockland Multiplier", "docks1");
			//l.SetJumpMedals(100,200);
			//l.AddObjective("Get a 7x multiplier",MissionType.BESTMULTIPLIER, 7);
	
			l = AddLevel("Misadventure Playground", "park2");
			l.SetJumpMedals(15,20);
			l.AddObjective("Defeat All Enemies", MissionType.KILLS, -1);
			
			l = AddLevel("Central Park Quick Run", "park1");
			l.SetJumpMedals(15,20);
			l.AddObjective("Finish in 30 seconds",MissionType.TIME, 35);
			
			l = AddLevel("Stealth Construction", "construction1");
			l.SetJumpMedals(10, 12);
			l.AddObjective("don't defeat any enemies",MissionType.STEALTH, 0);
			
//---------------			

			l = AddLevel("Ship it", "docks2");
			l.SetJumpMedals(15,20);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			l = AddLevel("Urban Ninja Level Score", "training1");
			l.SetJumpMedals(10,15);
			l.AddObjective("Score 2000",MissionType.LEVELSCORE,2000);

			l = AddLevel("Pits Of Fire", "castle2a");
			l.SetJumpMedals(25,30);
			l.AddObjective("Defeat All Enemies", MissionType.KILLS, -1);
			
			l = AddLevel("Misadventure Combos", "park2");
			l.SetJumpMedals(100,200);
			l.AddObjective("Defeat All Enemies With Combos",MissionType.COMBOKILLS, -1);
			
			l = AddLevel("Dockland Treasure Race", "docks1");
			l.SetJumpMedals(100,200);
			l.AddObjective("Finish in 50 seconds",MissionType.TIME, 50);
			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);
			
			l = AddLevel("Underground Overground", "subway");
			l.SetJumpMedals(20,25);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

//---------------			
			
			l = AddLevel("Ship It QuickRun", "docks2");
			l.SetJumpMedals(10, 12);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Finish in 120 seconds", MissionType.TIME, 120);
			
			l = AddLevel("Halls Of Peril", "castle2b");
			l.SetJumpMedals(30, 35);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			l = AddLevel("Downtown And Smashing", "training2");
			l.SetJumpMedals(10, 12);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Smash 11 items",MissionType.SMASHES,11);

			l = AddLevel("Castle Marauder", "castle1");
			l.SetJumpMedals(10, 12);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);
			l.AddObjective("Smash Everything",MissionType.SMASHES,-1);

			l = AddLevel("Cave Of Shadows", "underground1");
			l.SetJumpMedals(21,26);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			//l = AddLevel("Underground Race", "subway");
			//l.SetJumpMedals(100,200);
			//l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			//l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);

//----------------------------
			
//			l = AddLevel("Shuriken Kills", "castle2");
//			l.SetJumpMedals(10, 12);
//			l.AddObjective("Kill five enemies with shurikens",MissionType.SHURIKEN, 5);

			l = AddLevel("Rooftops", "rooftops");
			l.SetJumpMedals(26,31);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
	
//			l = AddLevel("Arcade", "arcade");
//			l.SetJumpMedals(36, 41);
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = AddLevel("Construction Quickrun", "construction1");
			l.SetJumpMedals(100,200);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Finish in 35 seconds",MissionType.TIME, 35);
	
			l = AddLevel("Cave Of Shadows", "underground1");
			l.SetJumpMedals(100,200);
			l.AddObjective("Finish in 70 seconds",MissionType.TIME, 70);
			l.AddObjective("Don't Get Hit",MissionType.HEALTH,1);
			
			l = AddLevel("Train Surfers", "subway2");
			l.SetJumpMedals(20,25);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Don't Get Hit",MissionType.HEALTH,1);
			
//----------------------------

			l = AddLevel("Treasure Playground", "park2");
			l.SetJumpMedals(10, 12);
			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);
			l.AddObjective("Finish in 90 seconds",MissionType.TIME, 90);

			l = AddLevel("Castle Quickrun", "castle1");
			l.SetJumpMedals(10, 12);
			l.AddObjective("Finish in 50 seconds",MissionType.TIME, 50);

			l = AddLevel("The Fairground", "fairground");
			l.SetJumpMedals(12, 17);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			l = AddLevel("Harbor Fury", "docklands");
			l.SetJumpMedals(17,22);
			l.AddObjective("Defeat All Enemies", MissionType.KILLS, -1);
			
			l = AddLevel("Fast Treasure Rooftops", "rooftops");
			l.SetJumpMedals(100,200);
			l.AddObjective("Get All Treasure",MissionType.TREASURE,-1);
			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);
			
			l = AddLevel("Cave Combos", "underground1");
			l.SetJumpMedals(100,200);
			l.AddObjective("Defeat All Enemies With Combos", MissionType.COMBOKILLS, -1);
			
//----------------------------

			l = AddLevel("High Rise Rage", "highrise1");
			l.SetJumpMedals(50,60);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			l = AddLevel("Fast Treasure Fairground", "fairground");
			l.SetJumpMedals(100,200);
			l.AddObjective("Get All Treasure",MissionType.TREASURE,-1);
			l.AddObjective("Finish in 70 seconds",MissionType.TIME, 70);
			
			l = AddLevel("Scaffold Labyrinth", "construction2");
			l.SetJumpMedals(54,60);
			l.AddObjective("Defeat All Enemies", MissionType.KILLS, -1);
			
			l = AddLevel("Liftopia", "lifts");
			l.SetJumpMedals(10, 12);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

//			l = AddLevel("Harbour Racer", "docklands");
//			l.SetJumpMedals(10, 12);
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);
			
//			l = AddLevel("High Rise Gem hunt", "highrise1");
//			l.SetJumpMedals(10, 12);
//			l.AddObjective("Find all the treasure", MissionType.TREASURE, -1);
//			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);
			
//----------------------------
			
			
			l = AddLevel("Shinobi Heath", "park3");
			l.SetJumpMedals(35, 40);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

//			l = AddLevel("Liftopia Timer", "lifts");
//			l.SetJumpMedals(10, 12);
//			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);
			
//			l = AddLevel("Scaffold Multiplier", "construction2");
//			l.SetJumpMedals(100,200);
//			l.AddObjective("Get an 11x multiplier",MissionType.BESTMULTIPLIER, 11);
			
			l = AddLevel("Dodge City Park", "park4");
			l.SetJumpMedals(10, 12);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			l = AddLevel("Vertigo", "highrise2");
			l.SetJumpMedals(10, 12);
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			
			l = AddLevel("The Lair", "lair");
			l.SetJumpMedals(10, 12);
			l.AddObjective("Defeat All Enemies", MissionType.KILLS, -1);
	
			
//----------------------------------------------------------------			
//----------------------------------------------------------------			
//----------------------------------------------------------------
// trace mission info:
	
			trace("total missions: " + totalMissions);
			
			var levelNames:Array = new Array();
			var levelCounts:Array = new Array();
			for each(var miss:Mission in Missions.list)
			{
				for each(var ml:MissionLevel in miss.missionLevels)
				{
					var n:String = ml.levelName;					
					var index:int = levelNames.indexOf(n);
					if (index == -1)
					{
						levelNames.push(n);
						levelCounts.push(1);
					}
					else
					{
						levelCounts[index]++;
					}
				}
			}
			for (var i:int = 0; i < levelNames.length; i++)
			{
				trace("Level " + levelNames[i] + ":   count=" + levelCounts[i]);
			}
			trace("Num Levels used: " + levelNames.length);
			trace("Total Physical Levels: " + Levels.list.length);
			
		}
		public static function Init()
		{
			var m:Mission;
			var l:MissionLevel;

			Missions.addMissionIndex = 0;

//-------------------------------MISSION START ---------------------------------			
			m = Missions.AddMission("1", "training1", "");
			
//			l = m.AddLevel("training1","training1");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			l = m.AddLevel("vehicle kills","training1");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Run over 3 enemies",MissionType.VEHICLEKILLS,3);
			
//			l = m.AddLevel("jumps","training1");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Don't use more than 10 jumps",MissionType.JUMPS, 10);
			
//			l = m.AddLevel("Level Score","training1");
//			l.AddObjective("Score 1000",MissionType.LEVELSCORE,1000);

			
//-------------------------------MISSION END ---------------------------------			


//-------------------------------MISSION START ---------------------------------			
			m = Missions.AddMission("2", "training2", "");
			
//			l = m.AddLevel("clean up","training2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
//			l = m.AddLevel("smashing","training2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Smash 6 items",MissionType.SMASHES,6);
		
//			l = m.AddLevel("treasure hunt","training2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);
			
			l = m.AddLevel("Combos","training2");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Defeat All Enemies With Combos",MissionType.COMBOKILLS, -1);

//-------------------------------MISSION END ---------------------------------			


//-------------------------------MISSION START docks1---------------------------------			
			m = Missions.AddMission("3", "docks1", "");
			
//			l = m.AddLevel("clean up","docks1");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			l = m.AddLevel("quick run","docks1");
			l.AddObjective("Finish in 30 seconds",MissionType.TIME, 30);
			
//			l = m.AddLevel("timed treasure hunt","docks1");
//			l.AddObjective("Finish in 40 seconds",MissionType.TIME, 40);
//			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);
			
//			l = m.AddLevel("Multiplier","docks1");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Get a 7x multiplier",MissionType.BESTMULTIPLIER, 7);

//-------------------------------MISSION END ---------------------------------			

//-------------------------------MISSION START castle1 ---------------------------------			
			m = Missions.AddMission("4", "castle1", "");
			
//			l = m.AddLevel("clean up","castle1");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
			l = m.AddLevel("quick run","castle1");
			l.AddObjective("Finish in 30 seconds",MissionType.TIME, 30);
			
//			l = m.AddLevel("jumps","castle1");
//			l.AddObjective("Don't use more than 20 jumps",MissionType.JUMPS, 20);
			
//			l = m.AddLevel("Marauder","castle1");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);
//			l.AddObjective("Smash Everything",MissionType.SMASHES,-1);

//-------------------------------MISSION END ---------------------------------			

//-------------------------------MISSION START park1 ---------------------------------			
			m = Missions.AddMission("5", "park1", "");
			
//			l = m.AddLevel("clean up","park1");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("Combos","park1");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Defeat All Enemies With Combos",MissionType.COMBOKILLS, -1);
			
//			l = m.AddLevel("quick run","park1");
//			l.AddObjective("Finish in 30 seconds",MissionType.TIME, 30);
			
			l = m.AddLevel("treasure jumps","park1");
			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);
			l.AddObjective("Don't use more than 20 jumps",MissionType.JUMPS, 20);
			

//-------------------------------MISSION END ---------------------------------			

//-------------------------------MISSION START construction1 ---------------------------------			
			m = Missions.AddMission("6", "construction1", "");
			
//			l = m.AddLevel("clean up","construction1");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

//			l = m.AddLevel("quick run","construction1");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Finish in 30 seconds",MissionType.TIME, 30);
			
			l = m.AddLevel("Treasure","construction1");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);
						
//			l = m.AddLevel("stealth","construction1");
//			l.AddObjective("don't defeat any enemies",MissionType.STEALTH, 0);
			

//-------------------------------MISSION START docks2 ---------------------------------			
			m = Missions.AddMission("7", "docks2", "");
			
//			l = m.AddLevel("clean up","docks2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

//			l = m.AddLevel("quick run","docks2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Finish in 30 seconds",MissionType.TIME, 30);
			
			l = m.AddLevel("UNDEFINED","docks2");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("UNDEFINED","docks2");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			
//-------------------------------MISSION END ---------------------------------			


//-------------------------------MISSION START park2 ---------------------------------			
			m = Missions.AddMission("8", "park2", "");
			
//			l = m.AddLevel("clean up","park2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

//			l = m.AddLevel("quick run","park2");
//			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);
			
//			l = m.AddLevel("Combos","park2");
//			l.AddObjective("Defeat All Enemies With Combos",MissionType.COMBOKILLS, -1);

			l = m.AddLevel("Shuriken Kills","park2");
			l.AddObjective("Kill 5 enemies with a shuriken",MissionType.SHURIKEN,5);

			
//-------------------------------MISSION END ---------------------------------			


//-------------------------------MISSION START castle2 ---------------------------------			
			m = Missions.AddMission("9", "castle2", "");
			
//			l = m.AddLevel("clean up","castle2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("quick treasure run","castle2");
			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);
			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);
			l.AddObjective("Finish in 50 jumps",MissionType.JUMPS, 50);
			
//			l = m.AddLevel("Combos","castle2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);

//			l = m.AddLevel("Shuriken Kills","castle2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Finish in 50 jumps",MissionType.JUMPS, 50);

			
//-------------------------------MISSION END ---------------------------------			

//-------------------------------MISSION START subway ---------------------------------			
			m = Missions.AddMission("10", "subway", "");
			
//			l = m.AddLevel("clean up","subway");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

//			l = m.AddLevel("Timer","subway");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);

			l = m.AddLevel("UNDEFINED","subway");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("UNDEFINED","subway");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
//-------------------------------MISSION END ---------------------------------			


//-------------------------------MISSION START underground1 ---------------------------------			
			m = Missions.AddMission("11", "underground1", "");
			
//			l = m.AddLevel("clean up","underground1");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("Treasure rush","underground1");
			l.AddObjective("Get All The Treasure",MissionType.TREASURE, -1);
			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);

//			l = m.AddLevel("Multiplier","underground1");
//			l.AddObjective("Defeat All Enemies With Combos",MissionType.COMBOKILLS,-1);

//			l = m.AddLevel("Big rush","underground1 ");
//			l.AddObjective("Finish in 30 seconds",MissionType.TIME, 30);
//			l.AddObjective("Don't Get Hit",MissionType.HEALTH,3);
			
//-------------------------------MISSION END ---------------------------------		




//-------------------------------MISSION START rooftops ---------------------------------			
			m = Missions.AddMission("11", "rooftops", "");
			
//			l = m.AddLevel("clean up","rooftops");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

//			l = m.AddLevel("Fast Treasure","rooftops");
//			l.AddObjective("Get All Treasure",MissionType.TREASURE,-1);
//			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);

			l = m.AddLevel("Jumps","rooftops");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Finish in 30 jumps or less",MissionType.JUMPS, 30);

			l = m.AddLevel("UNDEFINED","rooftops");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
//-------------------------------MISSION END ---------------------------------			


//-------------------------------MISSION START arcade ---------------------------------			
			m = Missions.AddMission("11", "arcade", "");
			
//			l = m.AddLevel("clean up","arcade");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("UNDEFINED","arcade");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("UNDEFINED","arcade");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("UNDEFINED","arcade");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
//-------------------------------MISSION END ---------------------------------			

//-------------------------------MISSION START subway2 ---------------------------------			
			m = Missions.AddMission("11", "subway2", "");
			
//			l = m.AddLevel("clean up","subway2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Don't Get Hit",MissionType.HEALTH,3);

			l = m.AddLevel("Jumps","subway2");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Don't Get Hit",MissionType.HEALTH,3);
			l.AddObjective("Finish in 50 jumps",MissionType.JUMPS, 50);

			l = m.AddLevel("UNDEFINED","subway2");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("UNDEFINED","subway2");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
//-------------------------------MISSION END ---------------------------------			


//-------------------------------MISSION START fairground ---------------------------------			
			m = Missions.AddMission("11", "fairground", "");
			
//			l = m.AddLevel("clean up","fairground");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

//			l = m.AddLevel("Fast Treasure","fairground");
//			l.AddObjective("Get All Treasure",MissionType.TREASURE,-1);
//			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);

			l = m.AddLevel("Jumps","fairground");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Finish in 30 jumps or less",MissionType.JUMPS, 30);

			l = m.AddLevel("UNDEFINED","fairground");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
//-------------------------------MISSION END ---------------------------------			


//-------------------------------MISSION START docklands ---------------------------------			
			m = Missions.AddMission("11", "docklands", "");
			
//			l = m.AddLevel("clean up","docklands");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("Fast Treasure","docklands");
			l.AddObjective("Get All Treasure",MissionType.TREASURE,-1);
			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);

//			l = m.AddLevel("Jumps","docklands");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Finish in 30 jumps or less",MissionType.JUMPS, 30);

			l = m.AddLevel("UNDEFINED","docklands ");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
//-------------------------------MISSION END ---------------------------------			

//-------------------------------MISSION START lifts ---------------------------------			
			m = Missions.AddMission("11", "lifts", "");
			
//			l = m.AddLevel("clean up","lifts");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("Fast Treasure","lifts");
			l.AddObjective("Get All Treasure",MissionType.TREASURE,-1);
			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);

//			l = m.AddLevel("Jumps","lifts");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Finish in 30 jumps or less",MissionType.JUMPS, 30);

			l = m.AddLevel("UNDEFINED","lifts ");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			
//-------------------------------MISSION END ---------------------------------			



//-------------------------------MISSION START park3 ---------------------------------			
			m = Missions.AddMission("11", "park3", "");
			
//			l = m.AddLevel("clean up","park3");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("Stealth","park3");
			l.AddObjective("don't defeat any enemies",MissionType.STEALTH, 0);
			l.AddObjective("Finish in 130 seconds",MissionType.TIME, 130);

			l = m.AddLevel("Speedy","park3");
			l.AddObjective("Finish in 30 seconds",MissionType.TIME, 30);

			l = m.AddLevel("UNDEFINED","park3 ");
			
//-------------------------------MISSION END ---------------------------------			

//-------------------------------MISSION START construction2 ---------------------------------			
			m = Missions.AddMission("11", "construction2", "");
			
//			l = m.AddLevel("clean up","construction2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("Speedy","construction2");
			l.AddObjective("Finish in 60 seconds",MissionType.TIME, 60);

//			l = m.AddLevel("Multiplier","construction2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
//			l.AddObjective("Get an 11x multiplier",MissionType.BESTMULTIPLIER, 11);

			l = m.AddLevel("UNDEFINED","construction2 ");
			
//-------------------------------MISSION END ---------------------------------			

//-------------------------------MISSION START highrise1 ---------------------------------			
			m = Missions.AddMission("11", "highrise1", "");
			
//			l = m.AddLevel("clean up","highrise1");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("Speedy","highrise1 ");
			l.AddObjective("Finish in 60 seconds",MissionType.TIME, 60);

//			l = m.AddLevel("Treasure","highrise1 ");
//			l.AddObjective("Find all the treasure", MissionType.TREASURE, -1);

			l = m.AddLevel("UNDEFINED","highrise1 ");
			
//-------------------------------MISSION END ---------------------------------			

//-------------------------------MISSION START park4 ---------------------------------			
			m = Missions.AddMission("11", "park4", "");
			
//			l = m.AddLevel("clean up","park4");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("Stealth","park4 ");
			l.AddObjective("don't defeat any enemies",MissionType.STEALTH, 0);

			l = m.AddLevel("Speedy","park4 ");
			l.AddObjective("Finish in 60 seconds",MissionType.TIME, 60);

			l = m.AddLevel("UNDEFINED","park4 ");
			
//-------------------------------MISSION END ---------------------------------			

//-------------------------------MISSION START highrise2 ---------------------------------			
			m = Missions.AddMission("11", "highrise2", "");
			
//			l = m.AddLevel("clean up","highrise2");
//			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);

			l = m.AddLevel("Multiplier","highrise2 ");
			l.AddObjective("Defeat All Enemies",MissionType.KILLS,-1);
			l.AddObjective("Get a 17x multiplier",MissionType.BESTMULTIPLIER, 17);

			l = m.AddLevel("UNDEFINED","highrise2 ");
			l.AddObjective("Kill all enemies with a combo", MissionType.COMBOKILLS, -1);

			l = m.AddLevel("UNDEFINED","highrise2 ");
//-------------------------------MISSION END ---------------------------------			

			


//-------------------------------MISSION START highrise2 ---------------------------------			

			m = Missions.AddMission("11", "lair", "");

//			l = m.AddLevel("clean up","lair");
//			l.AddObjective("Defeat All Enemies", MissionType.KILLS, -1);
			
			
//-------------------------------MISSION END ---------------------------------			

			SetOrder();

		}
		
	}

}