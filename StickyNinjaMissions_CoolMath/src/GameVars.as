package  
{
	import AnimPackage.AnimHierarchy;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import UIPackage.UI;
	import UIPackage.UIX_Instance;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class GameVars
	{

		// StickyNinja
		public static var exitIsOpen:Boolean;
		public static var numLevelFlicks:int;
		public static var comboCounter:int;
		public static var totalTreasure:int;
		public static var numTreasureCollected:int;
		public static var totalEnemies:int;
		public static var bestMultiplier:int;
		public static var numEnemiesNonComboKilled:int;
		public static var numEnemiesComboKilled:int;
		public static var numEnemiesShurikenKilled:int;
		public static var numEnemiesKilled:int;
		public static var numEnemiesKilledByVehicle:int;
		public static var numSmashes:int;
		public static var numSmashables:int;
		public static var reachedExit:Boolean;
		public static var playerDied:Boolean;
		public static var lives:int;
		public static var maxLives:int;
		
		static var maxGenericUnlocks:int = 256;
		public static var genericUnlocks:Array;
		
		public static var cash:int;
		public static var levelCash:int;
		public static var levelScore:int;
		public static var levelCoins:int;
		public static var firstTime:Boolean;
		
		
		public static var missionSelectXPos:Number;
		
		// from cyclo3:
		public static var rundata_skip:int = 8;
		public static var playerBikeDefIndex:int = 0;
		public static var playerCharIndex:int = 0;
		public static var endFlagGO:GameObj = null;
		public static var playerGO:GameObj = null;
		public static var exitGO:GameObj = null;
		public static var manGO:GameObj = null;
		public static var wheelHitFloorTimerMax:int = 5;
		public static var endpost_xpos:Number = 99999;
		public static var startX:Number = 0;
		public static var endX:Number = 99999;
		public static var raceTimer:int = 0;
		public static var cameraFixedPointActive:Boolean = false;
		public static var cameraFixedPointX:Number = 0;
		public static var cameraFixedPointY:Number = 0;
		
		// GrandTruckismo
		public static var useAICatchup:Boolean = true;
		

		public static var numCashPickups:int;
		public static var totalCashPickups:int;
		public static var canStart:Boolean;
		
		// Out Of Control
		public static var bombTimer:int;
		public static var stopwatch:int;
		public static var brakeLevel:Number;
//		public static var engineSoundName:String;
		public static var windSoundName:String;
		public static var crossedLine:Boolean;
		public static var nextScreenName:String;
		
		
		public static var numMudTimesAdded:int;
		public static var numWaterTimesAdded:int;
		
		
		public static var gameMode:int;
		public static var gameTimer:int;
		public static var gameTimerMax:int;
		
		public static var numPigsActive:int;
		public static var totalGoals:int;
		public static var numGoalsScored:int;
		public static var numRefsHit:int;
		public static var totalRefs:int;
		public static var numAnimalsKilled:int;
		public static var bossDefeated:Boolean;
		
		public static var shadowOffset:int = 6;
		public static var shadowPower:int = -200;
		
		public static var guineaPigTypesAllowed:int = 4;
		
		public static var collectedBonus:Boolean;
		
		public static var takingADump:Boolean;
		public static const gravity:Number = 300;
		public static const gravity_GO:Number = 0.2;

		public static var pigsUsed:int;
		
		public static var SnakeReloadTimeNormal:int =  Defs.fps * 1;
		public static var SnakeReloadTimeSuper:int =  0;
		
		public static var snakeUpgradeTexts:Array = new Array("", "SuperRegen", "Spitter", "FastSwing", "PigChain");
		
		public static var snakeUpgrade_None:int = 0;
		public static var snakeUpgrade_SuperRegen:int = 1;
		public static var snakeUpgrade_Spitter:int = 2;
		public static var snakeUpgrade_FastSwing:int = 3;
		public static var snakeUpgrade_PigChain:int = 4;
		
		
		public static var snakeUpgradeGO:GameObj = null;
		public static var snakeUpgrade:int = 0;
		public static var upgradeTimer:int = 0;
		public static var upgradeTimerMax:int = Defs.fps * 10;
		
		
		public static var ballTimerShowTimerMax:int = Defs.fps * 4;
		public static var ballTimerMax:int = Defs.fps * 6;
		public static var numKicks:int;
		
		public static var hasPlayedIntro:Boolean;
		public static var introGoToLevelSelect:Boolean;
		
		public static const cannonHoldTime:int = Defs.fps;
	
		public static const ballLineLength:int = 80;
		
		public static const fastForward_numskips:int = 4;
		public static var doingFastForward:Boolean;
		public static var fastforwardoffset:int;

		public static var maxKicks:int;
		public static var goldKicks:int;
		
		public static var football_footOffsetX:Number = 0;	// 10;
		public static var football_footOffsetY:Number = -9;
			
		public static var useFeature1:Boolean;		//  haddock
		public static var useFeature2:Boolean;		// 
		public static var useFeature3:Boolean;		// 
		public static var useFeature4:Boolean;		//
		public static var useFeature5:Boolean;		// 
		public static var useFeature6:Boolean;		// 
		public static var useFeature7:Boolean;		// 
		public static var useFeature8:Boolean;		// 
		
		
		public static function GetFeatureActive(index:int):Boolean
		{
			if (index == 0) return useFeature1;
			if (index == 1) return useFeature2;
			if (index == 2) return useFeature3;
			if (index == 3) return useFeature4;
			if (index == 4) return useFeature5;
			if (index == 5) return useFeature6;
			if (index == 6) return useFeature7;
			if (index == 7) return useFeature8;
			return false;
		}
		
		public static function SetFeatureActive(index:int,value:Boolean)
		{
			if (index == 0) useFeature1 = value;
			if (index == 1) useFeature2 = value;
			if (index == 2) useFeature3 = value;
			if (index == 3) useFeature4 = value;
			if (index == 4) useFeature5 = value;
			if (index == 5) useFeature6 = value;
			if (index == 6) useFeature7 = value;
			if (index == 7) useFeature8 = value;
			return false;
		}
		
		public static function IsFeatureLocked(index:int):Boolean
		{
			if (index == 0)
			{
				if (Levels.CountCompleteLevels() == 24)
				{
					return false;
				}
			}
			return true;
		}
		
		public static var grassFrame:int;
		public static var dirtFrame:int;
		
		public static var currentWalkthroughPage:int = 0;
		
		public static var currentScore:int;
		public static var playerName:String;
		
		public static var doingLevelIntro:Boolean;
		public static var levelIntroTimer:int;
		public static var levelIntroTimerMax:int;

		public static var render1:Boolean = false;
		public static var render2:Boolean = false;
		public static var render3:Boolean = false;
		public static var render4:Boolean = false;
		public static var render5:Boolean = false;
		public static var render6:Boolean = false;
		public static var render7:Boolean = false;
		public static var render8:Boolean = false;
		
		public static var newMatchIndex:int = -1;
		public static var currentMatchIndex:int;
		public static var matchLocks:Array;
		static function InitMatchLocks()
		{
			var numMatches:int = 20;
			matchLocks = new Array();
			for (var i:int = 0; i < numMatches; i++)
			{
				matchLocks.push(true);
			}
			matchLocks[0] = false;
		}
		
		// returns false if next is already unlocked
		public static function UnlockNextMatch():Boolean
		{
			if (currentMatchIndex >= 8) return false;
			if (matchLocks[currentMatchIndex + 1] == false) return false;
			matchLocks[currentMatchIndex + 1] = false;
			return true;
		}
		public static function GetMatchLocked(index:int):Boolean
		{
			return false;
			return matchLocks[index];
		}
		
		public static var tilt:Number = 0;
		public static var tilt1:Number = 0;
		
		public function GameVars() 
		{
			
		}
		public static function InitOnce()
		{
			ResetEverything();
		}
		
		
		static var unlockList:Array = new Array(
				new Array(1,2),
				new Array(2,3),
				new Array(3,4),

				new Array(4,5,6),
				new Array(5,7),
				new Array(7,9),
				
				new Array(6,8),
				
				new Array(8,9),
				new Array(9,10),
				new Array(10,11),
				new Array(11,12),
				new Array(12,13),
				new Array(13,14),

				new Array(14,15,16),
				
				new Array(16,17,19),
				new Array(17,18),
				
				new Array(19,20),
				new Array(20,21),
				new Array(21,22),
				new Array(22,23),
				new Array(23, 24),
				
				new Array(24,25,27),
				new Array(25,26),
				new Array(26,29),
				new Array(27,28),
				new Array(28,29),
				
				new Array(29, 30),
				
				new Array(30,31,34),
				new Array(31,32),
				new Array(32,33),
				
				new Array(34,35),
				new Array(35,36),
				new Array(36,37),
				new Array(37,38),
				new Array(38,39),
				new Array(39, 40,43),
				new Array(40,41),
				new Array(41, 42),
				
				new Array(43,44),
				new Array(44,45),
				new Array(45,46),
				new Array(46,47),
				new Array(47,48),
				new Array(48,49),
				new Array(49,50)
				);
		
		// 1-based
		public static function GetUnlockedLevels(levelID:int):Array
		{
			var unlocked:Array = new Array();
			for each(var a:Array in unlockList)
			{
				if (a[0] == levelID)
				{
					for (var i:int = 1; i < a.length; i++)
					{
						unlocked.push(a[i]);						
					}
					return unlocked;
				}
			}
			Utils.print("GetUnlockedLevels error can't find level " + levelID);
			return unlocked;
		}
		
		static var DumpBackToLevelMapLevels:Array = new Array(4, 5, 6, 7, 8,
																14, 15,
																16, 17, 18,
																24, 25, 26, 27, 28,
																30, 31, 32, 33,
																39, 40, 41, 42);
		
		// 1-based
		public static function ShouldDumpBackToLevelMap(levelID:int):Boolean
		{
			for each(var l:int in DumpBackToLevelMapLevels)
			{
				if (l == levelID) return true;
			}
			return false;
		}
				
		
		public static function GetNumBonusGold():int
		{
			var count:Number = 0;
			for each(var l:Level in Levels.list)
			{
				if (l.gotBonus) count++;
			}			
			return count;
		}
		public static function GetLevelProgress():Number
		{
			var totalCount:Number = 0;
			var count:Number = 0;
			for each(var l:Level in Levels.list)
			{
				totalCount += 3;
				if (l.complete) 
				{
					count++;
					if (l.rating == 0) count++;
				}
				
				if (l.gotBonus) count++;
				
			}			
			return (count / totalCount);
		}
		
		public static function ResetEverything()
		{
			genericUnlocks = new Array();
			for (var i:int = 0; i < maxGenericUnlocks; i++)
			{
				genericUnlocks.push(false);
			}
			
			playerBikeDefIndex = 0;
			currentOrderedLevelIndex = 0;
			firstTime = true;
			missionSelectXPos = 0;
			InitUpgradesOnce();
			cash = 0;
			CurrentControlLayoutIndex = 3;
			currentMatchIndex = 0;
			newMatchIndex = -1;
			currentScore = 0;
			playerName = "yourname";
			
			InitMatchLocks();
			
			currentWalkthroughPage = 0;
			InitCoinsOnce();
			useFeature1 = false;
			useFeature2 = false;
			useFeature3 = false;
			useFeature4 = false;
			useFeature5 = false;
			useFeature6 = false;
			useFeature7 = false;
			useFeature8 = false;
			InitKeeperActions();
			TrophiesCollected = new Array();
			TrophiesCollected.push(
						false,false,false,false,false,
						false, false, false, false, false);
			
			playerTeam = 0;
			opponentTeam = 1;
			hasPlayedIntro = false;
			gameMode = 0;
			takingADump = false;
		}

		public static var renderDebugMode:int;
		public static var renderDebugModeMax:int = 5;
		
		public static var patrolMarkers:Vector.<GameObj>;
		public static var jumpMarkers:Vector.<GameObj>;
		public static var runMarkers:Vector.<GameObj>;
		public static var footballGO:GameObj;
		
		public static var numHierarchiesRendered:int;
		public static var numHierarchiesClipped:int;
		public static function ExitForFrame()
		{
			//Utils.print("hierarchies " + numHierarchiesRendered + "  " + numHierarchiesClipped);
		}
		public static function UpdateForFrame()
		{
			if (Game.levelState == Game.levelState_Play)
			{
				gameTimer++;
			}
			UpdateCashPickupTimer();
		}
		public static function InitForFrame()
		{
			numHierarchiesRendered = 0;
			numHierarchiesClipped = 0;
			numWaterTimesAdded = 0;
			numMudTimesAdded = 0;
		}
		
		public static function InitForLevel_PostObjects()
		{
			patrolMarkers = GameObjects.GetGameObjVectorByName("patrol_marker");
			jumpMarkers = GameObjects.GetGameObjVectorByName("jump_marker");
			runMarkers = GameObjects.GetGameObjVectorByName("run_marker");
			footballGO = GameObjects.GetGameObjByName("football");
			CalculateNumLevelCoinsCollected();
		}

		
		public static function InitForLevel()
		{
			gameTimer = 0;
			maxLives = lives = 3;
			
			levelScore = 0;
			levelCoins = 0;
			exitIsOpen = false;
			InitWeaponsForLevel();
			numLevelFlicks = 0;
			comboCounter = 0;
			totalTreasure = 0;
			numTreasureCollected = 0;
			totalEnemies = 0;
			numEnemiesKilled = 0;
			bestMultiplier = 0;
			numEnemiesShurikenKilled = 0;
			numEnemiesComboKilled = 0;
			numEnemiesNonComboKilled = 0;
			numEnemiesKilledByVehicle = 0;
			numSmashes = 0;
			numSmashables = 0;
			reachedExit = false;
			playerDied = false;
			
			canStart = true;
			if (Game.usedebug == false)
			{
				canStart = false;
			}
			numCashPickups = 0;
			totalCashPickups = 0;
			levelCash = 0;
			levelScore = 0;
			ResetCashPickupTimer();
			InitBoostForLevel();
			ResetPlayerListForLevel();
			crossedLine = false;
			playerGO = null;
			exitGO = null;
			InitCoinsForLevel();
			renderDebugMode = 0;
			var l:Level = Levels.GetCurrent();
			
			fastforwardoffset = 0;
			doingFastForward = false;
			maxKicks = l.failKicks;
			goldKicks = l.goldKicks;
			
			numKicks = 0;
			
			numPigsActive = 0;
			totalGoals = 0;
			numRefsHit = 0;
			totalRefs = 0;
			numGoalsScored = 0;
			numAnimalsKilled = 0;
			pigsUsed = 0;
			upgradeTimer = 0;
			bossDefeated = false;
			snakeUpgrade = snakeUpgrade_None;
			collectedBonus = false;
		}
		
		
		public static var currentPickTeam:int = 0;		// 0 = player, 1 = opponents
		public static var currentEditTeamIndex:int = 0;
		
		
		public static var playerTeam:int;
		public static var opponentTeam:int;
		
		
		static function UnlocksToByteArray(ba:ByteArray)
		{
			for (var i:int = 0; i < maxGenericUnlocks; i++)
			{
				ba.writeBoolean(genericUnlocks[i]);
			}
		}

		static function UnlocksFromByteArray(ba:ByteArray)
		{
			for (var i:int = 0; i < maxGenericUnlocks; i++)
			{
				genericUnlocks[i] = ba.readBoolean();
			}
		}		
		
		public static function ToByteArray(ba:ByteArray)
		{			
			ba.writeInt(CurrentControlLayoutIndex);
			ba.writeBoolean(firstTime);
			ba.writeBoolean(useFeature1);
			ba.writeBoolean(useFeature2);
			ba.writeBoolean(useFeature3);
			ba.writeBoolean(useFeature4);
			ba.writeBoolean(useFeature5);
			ba.writeBoolean(useFeature6);
			ba.writeBoolean(useFeature7);
			ba.writeBoolean(useFeature8);
			ba.writeInt(upgradeLevels[0]);
			ba.writeInt(upgradeLevels[1]);
			ba.writeInt(upgradeLevels[2]);
			ba.writeInt(upgradeLevels[3]);
			ba.writeInt(cash);
			ba.writeInt(currentScore);
			ba.writeInt(missionSelectXPos);
			ba.writeInt(playerBikeDefIndex);
			
			//UnlocksToByteArray(ba);
			
		}
		
		public static function FromByteArray(ba:ByteArray)
		{			
			CurrentControlLayoutIndex = ba.readInt();
			firstTime = ba.readBoolean();
			useFeature1 = ba.readBoolean();
			useFeature2 = ba.readBoolean();
			useFeature3 = ba.readBoolean();
			useFeature4 = ba.readBoolean();
			useFeature5 = ba.readBoolean();
			useFeature6 = ba.readBoolean();
			useFeature7 = ba.readBoolean();
			useFeature8 = ba.readBoolean();
			upgradeLevels[0] = ba.readInt();
			upgradeLevels[1] = ba.readInt();
			upgradeLevels[2] = ba.readInt();
			upgradeLevels[3] = ba.readInt();
			cash = ba.readInt();
			currentScore = ba.readInt();
			missionSelectXPos = ba.readInt();
			playerBikeDefIndex = ba.readInt();
			
			//UnlocksFromByteArray(ba);
		}
		
		
		static var parts_player:Array = [
						"upperArmRight",
						"upperArmRight.tint",
						"upperArmRight.lines",
						
						"lowerArmRight",
						
						"upperLegRight",
						"upperLegRight.tint",
						"upperLegRight.lines",
						
						"footRight",
						"footRight.tint",
						"footRight.lines",
						
						"head",
						
						"upperLegLeft",
						"upperLegLeft.tint",
						"upperLegLeft.lines",
						
						"body",
						"body.tint",
						"body.tint_stripes",
						"body.tint_hoops",
						"body.lines",
						
						"footLeft",
						"footLeft.tint",
						"footLeft.lines",
						
						"upperArmLeft",
						"upperArmLeft.tint",
						"upperArmLeft.lines",
						
						"lowerArmLeft" ];
						
			
			static var clips_player:Array = [
						"player_upperArm",
						"tint_topArm",
						"player_toparmLines",
						
						"player_foreArm",
						
						"player_topLeg",
						"tint_topLeg",
						"player_shortLines",
												
						"player_foot",
						"tint_socks",
						"player_legLines",
						
						"player_head",
						
						"player_topLeg",
						"tint_topLeg",
						"player_shortLines",
						
						"player_body",
						"tint_shirtbase",
						"tint_shirtStripes",
						"tint_hoopsEXP",
						"shirt_lines",
						
						"player_foot",
						"tint_socks",
						"player_legLines",
						
						"player_upperArm",
						"tint_topArm",
						"player_toparmLines",
						
						"player_foreArm"	];
		

		static var parts_ref:Array = [
						"upperArmRight",
						"lowerArmRight",
						"upperLegRight",
						"footRight",
						"head",
						"upperLegLeft",
						"body",
						"footLeft",
						"upperArmLeft",
						"lowerArmLeft" ];
						
			
		static var clips_ref:Array = [
						"ref_upperArm",
						"ref_foreArm",
						"ref_topLeg",
						"ref_foot",
						"ref_head",
						"ref_topLeg",
						"ref_body",
						"ref_foot",
						"ref_upperArm",
						"ref_foreArm"	];
						
		static var parts_keeper:Array = [
						"upperArmRight",
						"lowerArmRight",
						"upperLegRight",
						"footRight",
						"head",
						"upperLegLeft",
						"body",
						"footLeft",
						"upperArmLeft",
						"lowerArmLeft" ];
						
			
		static var clips_keeper:Array = [
						"keeper_upperArm",
						"keeper_foreArm",
						"keeper_topLeg",
						"keeper_foot",
						"keeper_head",
						"keeper_topLeg",
						"keeper_body",
						"keeper_foot",
						"keeper_upperArm",
						"keeper_foreArm"	];
						
						
		public static function InitHierarchies()
		{
			/*
			var mc:MovieClip = new player();
			hierarchy_player = new AnimHierarchy();
			hierarchy_player.Init(null,mc, "",parts_player, clips_player);
			Utils.RemoveMovieClipEntirely(mc);

			var mc:MovieClip = new ref();
			hierarchy_ref = new AnimHierarchy();
			hierarchy_ref.Init(null, mc, "",parts_ref, clips_ref);
			Utils.RemoveMovieClipEntirely(mc);
			
			var mc:MovieClip = new keeper();
			hierarchy_keeper = new AnimHierarchy();
			hierarchy_keeper.Init(null, mc, "",parts_keeper, clips_keeper);
			Utils.RemoveMovieClipEntirely(mc);
			*/

		}
		public static var hierarchy_player:AnimHierarchy;
		public static var hierarchy_ref:AnimHierarchy;
		public static var hierarchy_keeper:AnimHierarchy;
		

		
		static var coinsTable:Array;
		public static function InitCoinsForLevel()
		{
			totalLevelCoins = 0;
			currentCoinIndex = 0;
		}
		public static function InitCoinsOnce()
		{
			coinsTable = new Array();
		}
		
		public static var currentCoinIndex;
		public static var numLevelCoinsCollected;
		public static var totalLevelCoins;
		
		public static var totalGameCoins;
		public static function GetTotalGameCoins():int
		{
			totalGameCoins = Levels.list.length * 10;
			return totalGameCoins;
		}
		
		public static function CalculateNumCoinsInLevel()
		{
			var l:Level = Levels.GetCurrent();
			totalLevelCoins = l.totalCoins;
		}
		public static function CalculateNumLevelCoinsCollected()
		{
			numLevelCoinsCollected = 0;
			var num:int = coinsTable.length / 2;
			for (var i:int = 0; i < num; i++)
			{
				if (coinsTable[(i * 2)] == Levels.currentIndex)
				{
					numLevelCoinsCollected++;
				}
			}
		}
		public static function GetTotalCoinsCollected():int
		{
			return coinsTable.length / 2;
		}
		public static function CollectCoin(coinIndex:int)
		{			
			coinsTable.push(Levels.currentIndex);
			coinsTable.push(coinIndex);
			CalculateNumLevelCoinsCollected();
		}
		public static function IsCoinCollected(coinIndex:int):Boolean
		{		
			var num:int = coinsTable.length / 2;
			for (var i:int = 0; i < num; i++)
			{
				if (coinsTable[(i * 2)] == Levels.currentIndex)
				{
					if (coinsTable[(i * 2) + 1] == coinIndex) return true;
				}
			}
			return false;
		}
		
						
		public static var TrophiesCollected:Array;

		public static function GetNumTrophies():int
		{
			var num:int = 0;
			for each(var b:Boolean in TrophiesCollected)
			{
				if (b == true) num++;
			}
			return num;
		}
		public static function HasTrophy(index:int):Boolean
		{
			return TrophiesCollected[index];
		}
		public static function SetHasTrophy(index:int)
		{
			TrophiesCollected[index] = true;
		}
		
		public static function InitCoinBoxClip(coinBox:MovieClip)
		{
			var a:int = GetTotalCoinsCollected();
			var b:int = GetTotalGameCoins();
			
			coinBox.coinsCollected.text = a + "/" + b;
		}
		public static function InitTrophiesClip(trophies:MovieClip)
		{
			for (var i:int = 0; i < 10; i++)
			{
				var mc:MovieClip = trophies.getChildByName("trophy" + int(i + 1)) as MovieClip;
				if (HasTrophy(i))
				{
					mc.filters = [];
				}
				else
				{
					mc.filters = [UI.blackFilter];					
				}
			}
			trophies.numberText.text = GetNumTrophies().toString() + "/10";
		}

		public static function UIX_InitCoinBoxClip(coinBox:UIX_Instance)
		{
			var a:int = GetTotalCoinsCollected();
			var b:int = GetTotalGameCoins();
			
			coinBox.Child("coinsCollected").SetText( a + "/" + b);
		}
		
		public static function UIX_InitTrophiesClip(trophies:UIX_Instance)
		{
			for (var i:int = 0; i < 10; i++)
			{
				var inst:UIX_Instance = trophies.Child("trophy" + int(i + 1));
				if (HasTrophy(i))
				{
					inst.blackout = false;
				}
				else
				{
					inst.blackout = true;
				}
			}
			trophies.Child("numberText").SetText(GetNumTrophies().toString() + "/10");
		}
		
		public static function KeeperNextAction(name:String, index:int):int
		{
			for (var i:int = 0; i < keeperActions.length / 2; i++)
			{
				var s:String = keeperActions[ (i * 2) + 0];
				var a:Array = keeperActions[ (i * 2) + 1];
				if (s == name)
				{
					index++;
					if (index >= a.length) index = 0;
				}
			}
			return index;
		}
		public static function GetKeeperAction(name:String,index:int):Point
		{
			for (var i:int = 0; i < keeperActions.length / 2; i++)
			{
				var s:String = keeperActions[ (i * 2) + 0];
				var a:Array = keeperActions[ (i * 2) + 1];
				if (s == name)
				{
					return a[index];
				}
			}
			return null;
		}
		static var keeperActions:Array;
		static function InitKeeperActions()
		{
			keeperActions = new Array();
			keeperActions.push("stationary", new Array(new Point(0,-1) ));
			keeperActions.push("jump1", new Array(new Point(0,3),new Point(1,0)));
			keeperActions.push("crouch1", new Array(new Point(0,3),new Point(2,0)));
			keeperActions.push("jumpcrouch1", new Array(new Point(0,3),new Point(1,0),(new Point(0,3),new Point(2,0))));
		}


		public static var touchRect_Jump:Rectangle = new Rectangle(0,0, 0.5,0.5);
		public static var touchRect_Brake:Rectangle = new Rectangle(0.5,0, 0.5,0.5);
		public static var touchRect_Nitro:Rectangle = new Rectangle(0.5,0, 0.5,0.5);
		public static var touchRect_Accel:Rectangle = new Rectangle(0.5,0, 0.5,0.5);
		public static var touchRect_Left:Rectangle = new Rectangle(0,0.5, 0.5,1);
		public static var touchRect_Right:Rectangle = new Rectangle(0.5,0.5, 0.5,1);

		
		public static function GetAerialPos(index:int):Point
		{
			var s:String = Vars.GetVarAsString("aerialpos" + index);
			var a:Array = s.split(",");
			var p:Point = new Point(a[0], a[1]);
			
			return p;
		}

		public static function GetNitroPos(index:int):Point
		{
			var s:String = Vars.GetVarAsString("nitropos" + index);
			var a:Array = s.split(",");
			var p:Point = new Point(a[0], a[1]);
			
			return p;
		}
		
		public static function AddToBombTimer(timeSeconds:Number)
		{
			if (timeSeconds > 3) timeSeconds = 3;
			GameVars.bombTimer += Defs.fps * timeSeconds;
			
			var go:GameObj = GameObjects.AddObj(700, 200, -100);
			go.InitPlusSeconds(timeSeconds);

		}

/*
		Training
		Coupe
		Dakar
		Hummer
		Milk Float
		4x4
		Messerschmitt
		School Bus
		Dune Buggy
*/

		
		public static var CarTurboOffsets:Array = new Array(
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-70,-2),
						new Point(-80,-18),
						new Point(-81,-13),
						new Point(-76,-14),
						new Point(-83,-12),
						new Point(-40,-6),
						new Point(-114,-14),
						new Point(-47,-12 ));
		
		public static var brakeSounds:Array = new Array(
						"sfx_brake1",
						"sfx_brake2",
						"sfx_brake3")
						
		public static var rankNames:Array = new Array(
						"Newbie",
						"Rookie",
						"Agent",
						"Special Agent");
						
						
		static var helpScreenPages:Array = new Array(
						new Point(0,0),
						new Point(1,1),
						new Point(2,2),
						new Point(3,3)
						);
		// returns -1 if none
		public static function GetHelpScreenForThisLevelIndex(lIndex:int):int
		{
			for each(var p:Point in helpScreenPages)
			{
				if (p.x == lIndex) return p.y;
			}
			return -1;
		}

		public static var stingerIndex:int = 0;
		
		
		public static var CurrentControlLayoutIndex:int;
		public static var NumCurrentControlLayouts:int = 4;
		
		public static var maxAIRacers:int = 5;
		public static var numAIRacers:int = 5;
		public static var playerRacePosition:int = 10;
		
		public static function UpdatePlayerPosition()
		{
			var go:GameObj;
			playerRacePosition = 0;
			if (playerGO == null) return;
			
			for each(go in playerList)
			{
				if (go != playerGO)
				{
					if (go.xpos > playerGO.xpos)
					{
						playerRacePosition++;
					}
				}
			}
			
		}
		
		// called when player crosses line
		public static var playerFinalTime:int;
		public static var playerFinalPosition:int;
		public static var finalPositions:Array;
		public static function CalculateFinalPositions()
		{
			finalPositions = new Array();
			
			var go:GameObj;
			for each(go in playerList)
			{
				finalPositions.push(go);
			}

			finalPositions = finalPositions.sortOn("xpos",Array.DESCENDING);
			
			playerFinalPosition = 0;

			var i:int = 0;
			for each(go in finalPositions)
			{
				trace(int(go.xpos) + " " + go.name + " " + go.playerRecording.db_id);
				if (go.name == "player")
				{
					playerFinalPosition = i;
				}
				i++;
			}
			
		}
		
		public static var playerList:Array;
		static function ResetPlayerListForLevel()
		{
			playerList = new Array();
		}
		public static function AddPlayerToList(go:GameObj)
		{
			playerList.push(go);
		}
		
		
		static var boosts:Vector.<PlayerBoost>;
		static function InitBoostForLevel()
		{
			boosts = new Vector.<PlayerBoost>();
			boosts.push(new PlayerBoost(0,true));
			boosts.push(new PlayerBoost(1,false));
			boosts.push(new PlayerBoost(2,false));
			boosts.push(new PlayerBoost(3,false));
			boosts.push(new PlayerBoost(4,false));
			boosts.push(new PlayerBoost(5,false));
			boosts.push(new PlayerBoost(6,false));
			boosts.push(new PlayerBoost(7, false));
			boosts.push(new PlayerBoost(8, false));
			boosts.push(new PlayerBoost(9, false));
			
		}
		
		public static function AddToCash(amt:int)
		{
			levelCash += amt;
		}
		public static function AddToBoost()
		{
			for (var i:int = 0; i < boosts.length; i++)
			{
				var boost:PlayerBoost = boosts[i];
				if (boost.value < boost.maxValue)
				{
					boost.value = boost.maxValue;
					return;
				}
			}			
		}
		public static function CanUseBoost():Boolean
		{
			for (var i:int = 0; i < boosts.length; i++)
			{
				var boost:PlayerBoost = boosts[i];
				if (boost.value == boost.maxValue)
				{
					return true;
				}
			}			
			return false;
		}
		
		public static function UseBoost():int
		{
			
			var upgrade:int = GetUpgrade(UPGRADE_NITRO_TANKS);
			
			for (var i:int = boosts.length-1; i >= 0; i--)
			{
				if (i > upgrade)
				{
					
				}
				else
				{
					var boost:PlayerBoost = boosts[i];
					if (boost.value == boost.maxValue)
					{
						boost.value = 0;
						
						if (i != boosts.length - 1)
						{
							for (var j:int = 0; j < boosts.length; j++)
							{
								boosts[j].value = 0;
							}
						}
						
						return i;
					}
				}
			}	
			return -1;
		}
		
		
		public static function InitBoostsFromHud()
		{
			for (var i:int = 0; i < boosts.length; i++)
			{
				boosts[i].hudInst = Game.hudController.pageInst.Child("boost" + int(i + 1));
			}						
		}
		public static function UpdateBoostsFromHud()
		{
			if ( GameVars.playerGO == null) return;
			
			
			var upgrade:int = GetUpgrade(UPGRADE_NITRO_TANKS)+2;
			
			for (var i:int = 0; i < boosts.length; i++)
			{
				var boost:PlayerBoost = boosts[i];
				var inst:UIX_Instance = boost.hudInst;
				
				if (i >= upgrade)
				{
					inst.frame = 2;
				}
				else
				{
				
					if (boost.inUse == false)
					{
						if (boost.value == boost.maxValue)
						{
							inst.frame = 1;
							if (playerGO.extraTopSpeedTimer == 0)
							{
								if ( (Game.levelTimer&8) == 0) 
								{
									inst.frame = 3;
								}
							}
						}
						else
						{
							inst.frame = 0;	// boost.value;
						}					
					}
				}
				
			}			
			
		}
		
		
		public static var upgradeLevels:Array;
		public static const UPGRADE_CAR:int = 0;
		public static const UPGRADE_NITRO_TANKS:int = 1;
		public static const UPGRADE_NITRO_POWER:int = 2;
		public static const UPGRADE_JUMP:int = 3;
		static function InitUpgradesOnce()
		{			
			upgradeLevels = new Array(0, 0, 0, 0);
		}
		
		public static function GetUpgrade(index:int):int
		{
			return upgradeLevels[index];
		}
		public static function GetUpgradeMax(index:int):int
		{
			if (index == 0) return 16;
			return 8;
		}
		
		public static function GetUpgradePrice(type:int):int
		{
			var count:int = GameVars.upgradeLevels[type] + 1;
			
			var cost:int = 500;
			var costAdd:int = 50;
			
			var total:int = 0;
			
			for (var i:int = 0; i < count; i++)
			{
				total += cost;
				cost += costAdd;
			}
			return total;
			
			
			
		}
		
		public static function GetPlaceCash(place:int):int
		{
			var list:Array = new Array(1000, 600, 400, 300, 200, 100);
			if (place < 0) place = 0;
			if (place >= list.length) place = list.length - 1;
			return list[place];
		}
		
		public static var cashPickupTimer:int;
		public static var cashPickupLevel:int;
		public static function GetCashFromLevel():int
		{
			if (cashPickupLevel == 0) return 10;
			if (cashPickupLevel == 1) return 30;
			if (cashPickupLevel == 2) return 60;
			return 0;
		}
		public static function IncrementCashLevel()
		{
			cashPickupLevel++;
			if (cashPickupLevel >= 2) cashPickupLevel = 2;
		}
		public static function ResetCashPickupTimer()
		{
			cashPickupTimer = 0;
			cashPickupLevel = 0;
		}
		public static function StartCashPickupTimer()
		{
			cashPickupTimer = Defs.fps;
		}
		public static function UpdateCashPickupTimer()
		{
			cashPickupTimer--;
			if (cashPickupTimer <= 0)
			{
				ResetCashPickupTimer();
			}
		}
		
		
		public static function GetLevelPassRequirement(lIndex:int):int
		{
			if (lIndex < 12) return 2;
			if (lIndex < 20) return 1;
			return 0;
		}
		
		public static function TestReorderedLevels()
		{
			var usedLevels:Array = new Array();
			for (var i:int = 1; i <= 24; i++)
			{
				var levelIndex:int = Vars.GetVarAsInt("level" + i);			
				if (usedLevels.indexOf(levelIndex) != -1)
				{
					trace("ERROR, level "+i+"("+levelIndex+") multiply defined");
				}
				usedLevels.push(levelIndex);
			}
		}
		
		// 0 based!!!
		public static function GetReorderedLevelIndex(pos:int):int
		{
			return pos;
			TestReorderedLevels();
			pos++;
			var levelIndex:int = Vars.GetVarAsInt("level" + pos);
			return levelIndex-1;			
		}

		// 0 based?, returns 0 based
		public static function GetReorderedLevelIndexInverse(index:int):int
		{
			return index;
			for (var i:int = 1; i <= 24; i++)
			{
				var levelIndex:int = Vars.GetVarAsInt("level" + i);		
				if (levelIndex == (index + 1))
				{
					return i-1;
				}
			}
			return -1;
		}

		
		public static function GetHaddockPos(index:int):Point
		{
			var s:String = Vars.GetVarAsString("haddockpos" + index);
			var a:Array = s.split(",");
			var p:Point = new Point(a[0], a[1]);
			
			return p;
		}
		
		
		// 0-23 straight
		public static var currentOrderedLevelIndex:int;

		public static var currentWeapon:int;
		public static var currentAmmo:int;
		public static function IsWeaponActive():Boolean
		{
			return (currentWeapon != -1);
		}
		public static function InitWeaponsForLevel()
		{
			currentWeapon = -1;
			currentAmmo = 0;
		}
//----------------------------------------------------------------------------------------------
		
		public static function ResetCombo()
		{
			comboCounter = 0;
		}
		public static function IncrementComboAndAddCoins(go:GameObj)
		{
			comboCounter++;
			if(comboCounter > bestMultiplier) bestMultiplier = comboCounter
			Particles.Add(go.xpos, go.ypos).InitTreasurePickup(comboCounter);
			Particles.Add(go.xpos, go.ypos - 50).InitCombo(comboCounter);
			AddCoins(1);
		}
		public static function IncrementCombo(go:GameObj)
		{
			comboCounter++;
			if(comboCounter > bestMultiplier) bestMultiplier = comboCounter
			Particles.Add(go.xpos, go.ypos - 50).InitCombo(comboCounter);
			
		}

		public static const SCORE_TREASURE:int = 100;
		public static const SCORE_BREAKABLE:int = 5;
		public static const SCORE_ENEMY1:int = 30;
		public static const SCORE_ENEMY2:int = 40;
		public static const SCORE_ENEMY3:int = 50;
		public static const SCORE_ENEMY_VEHICLE:int = 100;
		
		public static function AddCoins(sc:int):void
		{
			levelCoins += sc * comboCounter;
		}
		public static function AddScore(sc:int):void
		{
			var combo:int = comboCounter;	// + 1;
			levelScore += sc * combo;
			currentScore += sc * combo;
		}
		
		public static function GenericContentLocked(index:int):Boolean
		{
			if (index == 0) return false;
			if (index == 1) return useFeature1==false;
			if (index == 2) return useFeature2==false;
			
			return true;
//			return (genericUnlocks[index] == false);
		}
		public static function UnlockGenericContent(index:int)
		{
			if (index == 0) return;
			if (index == 1) useFeature1 = true;
			if (index == 2) useFeature2 = true;
//			genericUnlocks[index] = true;
		}
		
	}

}