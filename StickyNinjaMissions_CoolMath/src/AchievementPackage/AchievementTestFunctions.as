package AchievementPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class AchievementTestFunctions 
	{
		
		public function AchievementTestFunctions() 
		{
			
		}
		function AchPass_Null():void
		{
//			Achievements.currentAch.popupFrame = 37;
		}		

		function AchPass_Cash():void
		{
			//var num:int = Utils.GetParamInt("cash");
			GameVars.cash += 100;
//			GameVars.currentScore += num;
		}		

		function AchPass_UnlockLevel():void
		{
		}		
		
		function AchPass_UnlockCar():void
		{
		}		

		function AchTest_Speed():Boolean
		{
			return false;
		}		

		
		function AchTest_Place():Boolean
		{
			return false;
		}		
		
		function AchTest_NotUsingSpecialCar():Boolean
		{
			return true;
		}
		function AchTest_UsingSpecialCar():Boolean
		{
			return false;
		}

		function AchTest_LevelUnlocked():Boolean
		{
			return true;			
		}
		
		function AchTest_FullyUpgrade():Boolean
		{
			return false;
				
		}
		function AchTest_PurchaseAllCars():Boolean
		{
			return false;

		}

		function AchTest_WetWeather():Boolean
		{
			return false;
		}
		function AchTest_DryWeather():Boolean
		{
			return false;
		}
		
		function AchTest_FinishedNotLastPlace():Boolean
		{
//			if (GameVars.raceComplete == false) return false;
//			if (Game.playerCameLast == true) return false;
			return true;
		}

		function AchTest_GetCash():Boolean
		{
			var value:int = Utils.GetParamInt("cash");						
			if (GameVars.cash >= value) return true;
			return false;
		}

		
		function AchTest_PercentComplete():Boolean
		{
			var value:int = Utils.GetParamInt("value");	
			var pc:int = 100;	// Game.CalculatePercentComplete();
			if (pc >= value) return true;
			return false;
		}
		
		function AchTest_LevelTime():Boolean
		{
			
			return false;
		}
		function AchTest_WinAllLevels():Boolean
		{
			return false;
		}
		
		function AchTest_CompleteAllLevels():Boolean
		{
			return false;
		}
		
		function AchTest_AllGreenLights():Boolean
		{
			return false;
		}
		
		function AchTest_LevelComplete():Boolean
		{
			return false;
			
		}
		
		function AchTest_CompleteAllEvents():Boolean
		{
//			if (RaceEvents.GetCompletedCount() >= RaceEvents.GetTotalCount())
//			{
//				return true;
//			}
			return false;
		}
		
		function AchTest_Stat_GreaterOrEqual():Boolean
		{
			var statName:String = Utils.GetParamString("stat");
			var value:int = Utils.GetParamInt("value");		
			var statValue:int = Stats.GetValueByName(statName);
			
			if (statValue >= value) 
			{
				return true;
			}
			return false;
		}

		function AchTest_Stat_LessOrEqual():Boolean
		{
			var statName:String = Utils.GetParamString("stat");
			var value:int = Utils.GetParamInt("value");		
			var statValue:int = Stats.GetValueByName(statName);
			
			if (statValue <= value) 
			{
				return true;
			}
			return false;
		}
		
		function AchTest_IntGreaterOrEqual():Boolean
		{
			var varName:String = Utils.GetParamString("variable");
			var value:int = Utils.GetParamInt("value");			
			var intVar:int = this[varName];
			
			if (intVar >= value) return true;
			return false;
		}
		
		function AchTest_IntLessOrEqual():Boolean
		{
			var varName:String = Utils.GetParamString("variable");
			var value:int = Utils.GetParamInt("value");			
			var intVar:int = this[varName];
			if (intVar <= value) return true;
			return false;
		}
		
		function AchTest_FlagSet():Boolean
		{
			var flagName:String = Utils.GetParamString("flag");
			if (this[flagName] == true) return true;
			return false;
		}

		function AchTest_FlagNotSet():Boolean
		{
			var flagName:String = Utils.GetParamString("flag");
			if (this[flagName] == false) return true;
			return false;
		}
		
		
		
		function AchTest_Cones():Boolean
		{
			return false;
		}
		function AchTest_Nitros():Boolean
		{
			return false;
		}
		function AchTest_CashPickup():Boolean
		{
			return false;
		}
		function AchTest_NitroOvertake():Boolean
		{
			var num:int = Utils.GetParamInt("number");
			if (numNitroOvertakes >= num) return true;
			return false;
		}
		function AchTest_DontHitSides():Boolean
		{
			return true;			
		}
		
		function AchTest_FinishPlace():Boolean
		{
//			if (Game.levelState != Game.levelState_Complete) return false;
//			var num:int = Utils.GetParamInt("place");
//			num--;
//			if (GameVars.playerRacePosition<= num) return true;
			return false;						
		}

		function AchTest_FinishAll():Boolean
		{
//			if (Game.levelState != Game.levelState_Complete) return false;
			var num:int = Utils.GetParamInt("place");
			num--;
			
			for each(var l:Level in Levels.list)
			{
				if (l.complete)
				{					
				}
				else
				{
					return false;
				}
			}
			
			return true;						
		}
		
		
		function AchTest_FinishTime():Boolean
		{
			return false;						
		}

		function AchTest_Falls():Boolean
		{
			return false;						
		}
		
		
		//--------------------------------------------------------------------------------------------------------
		//--------------------------------------------------------------------------------------------------------
		//--------------------------------------------------------------------------------------------------------
		
		
		public var num_hits:int;
		public var race_time:int= 999999;
		public var race_place:int = 99999;
		public var off_road_edge:Boolean;
		public var at_full_boost:Boolean;
		public var hit_another_car:Boolean;
		public var used_brake:Boolean;
		public var released_accelerator:Boolean;
		public var caused_another_car_to_crash:Boolean;
		public var raining_when_crossed_line:Boolean;
		public var crashed:Boolean;
		public var hit_cone:Boolean;
		public var boost_times_used:int;
		public var num_crashes:int;
		public var top_speed_int:int;
		public var numNitroOvertakes:int;
		
		
		public function UpdateFromGameVars()
		{
			
		}
		
		public function ResetForLevel():void 
		{
			at_full_boost = false;
			
			num_hits = 0;
			race_time = 9999999;
			race_place = 9999999;
			
			off_road_edge = false;
			at_full_boost = false;
			hit_another_car = false;
			used_brake = false;
			hit_cone = false;
			released_accelerator = false;
			caused_another_car_to_crash = false;
			raining_when_crossed_line = false;
			crashed = false;
			num_crashes = 0;
			boost_times_used = 0;
			top_speed_int = 0;
			numNitroOvertakes = 0;
			
			
		}
		
	}

}