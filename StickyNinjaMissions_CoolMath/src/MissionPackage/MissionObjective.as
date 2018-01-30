package MissionPackage 
{
	import flash.display.BitmapData;
	import TextPackage.TextRenderer;
	/**
	 * ...
	 * @author 
	 */
	public class MissionObjective 
	{
		
		public var name:String;
		public var type:String;
		public var value:Object;
		
		
		public function MissionObjective() 
		{
		}
		
		
		public function Update():String
		{
			var failed:Boolean = TestFail();
			
			if (failed)
			{
				trace("FAILED");
				return MissionResult.FAIL;
			}
			return MissionResult.NONE;
		}
		
		public function IsDoorAlwaysOpen():Boolean
		{
			if (type == MissionType.STEALTH)
			{
				return true;
			}
			return false;			
		}
		
		public var lastFailure:String;
		public function TestFail():Boolean
		{
			lastFailure = type;
			if (type == MissionType.FINISH)
			{
			}
			else if (type == MissionType.HEALTH)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.maxLives;
				
				if (GameVars.lives < v) return true;
			}
			else if (type == MissionType.JUMPS)
			{
				if (GameVars.numLevelFlicks > int(value)) return true;
			}
			else if (type == MissionType.TIME)
			{
				var maxTime:int = int(value) * Defs.fps;
				if (GameVars.gameTimer > maxTime) return true;
			}
			else if (type == MissionType.SMASHES)
			{
			}
			else if (type == MissionType.KILLS)
			{
			}
			else if (type == MissionType.TREASURE)
			{
			}
			else if (type == MissionType.VEHICLEKILLS)
			{
			}
			else if (type == MissionType.COMBOKILLS)
			{
				if (GameVars.numEnemiesNonComboKilled > 0) return true;
			}
			else if (type == MissionType.BESTMULTIPLIER)
			{
			}
			else if (type == MissionType.STEALTH)
			{
				var v:int = int(value);
				if (GameVars.numEnemiesKilled > v) return true;
			}
			else if (type == MissionType.SHURIKEN)
			{
			}
			else if (type == MissionType.LEVELSCORE)
			{
			}
			
			return false;
		}

		public function TestPass():Boolean
		{
			
			if (type == MissionType.FINISH)
			{
				return true;
			}
			else if (type == MissionType.HEALTH)
			{
				return true;
			}
			else if (type == MissionType.JUMPS)
			{
				return true;
			}
			else if (type == MissionType.TIME)
			{
				return true;
			}
			else if (type == MissionType.SMASHES)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.numSmashables;
				if (GameVars.numSmashes >= v) return true;
			}
			else if (type == MissionType.KILLS)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.totalEnemies;
				if (GameVars.numEnemiesKilled >= v) return true;
			}
			else if (type == MissionType.TREASURE)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.totalTreasure;
				if (GameVars.numTreasureCollected >= v) return true;
			}
			else if (type == MissionType.VEHICLEKILLS)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.totalEnemies;
				if (GameVars.numEnemiesKilled >= v) return true;
			}
			else if (type == MissionType.COMBOKILLS)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.totalEnemies;
				if (GameVars.numEnemiesComboKilled >= v) return true;
			}
			else if (type == MissionType.BESTMULTIPLIER)
			{
				var v:int = int(value);
				if (GameVars.bestMultiplier >= v) return true;
			}
			else if (type == MissionType.STEALTH)
			{
			}
			else if (type == MissionType.SHURIKEN)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.totalEnemies;
				if (GameVars.numEnemiesShurikenKilled >= v) return true;
			}
			else if (type == MissionType.LEVELSCORE)
			{
				var v:int = int(value);
				if (GameVars.levelScore >= v) return true;
			}
			
			return false;
		}
		

		public var renderHUDMiniString:String;
		public function RenderHud(bd:BitmapData, x:int, y:int, scl:Number,justReturnString:Boolean = false):String
		{
			var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName("Component_Mission_Icons");
			var fr:int = MissionType.GetIndex(type);
			
			var s:String = "";
			var s1:String = "";
			if (type == MissionType.FINISH)
			{
				s = "Finish The Level";
			}
			else if (type == MissionType.HEALTH)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.maxLives;
				s = "Health "+GameVars.lives+"/" +v;
				s1 = GameVars.lives+"/" +v;
			}
			else if (type == MissionType.JUMPS)
			{
				s = "Jumps " + GameVars.numLevelFlicks +"/"+value;
				s1 = GameVars.numLevelFlicks +"/"+value;
			}
			else if (type == MissionType.TIME)
			{
				var t:int = int(GameVars.gameTimer / Defs.fps);
				s = "Time " +t+"/"+ value;
				s1 = t+"/"+ value;
			}
			else if (type == MissionType.SMASHES)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.numSmashables;
				s = "Smashes " +GameVars.numSmashes+"/"+ v;
				s1 = GameVars.numSmashes+"/"+ v;
			}
			else if (type == MissionType.KILLS)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.totalEnemies;
				s = "Kills " +GameVars.numEnemiesKilled+"/"+ v;
				s1 = GameVars.numEnemiesKilled+"/"+ v;
			}
			else if (type == MissionType.TREASURE)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.totalTreasure;
				s = "Treasure " +GameVars.numTreasureCollected+"/"+ v;
				s1 = GameVars.numTreasureCollected+"/"+ v;
			}
			else if (type == MissionType.VEHICLEKILLS)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.totalEnemies;
				s = "Vehicle Kills " +GameVars.numEnemiesKilledByVehicle+"/"+ v;
				s1 = GameVars.numEnemiesKilledByVehicle+"/"+ v;
			}
			else if (type == MissionType.COMBOKILLS)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.totalEnemies;
				s = "Combo Kills " +GameVars.numEnemiesComboKilled+"/"+ v;
				s1 = GameVars.numEnemiesComboKilled+"/"+ v;
			}
			else if (type == MissionType.BESTMULTIPLIER)
			{
				var v:int = int(value);
				s = "Best Multiplier " +GameVars.bestMultiplier+"/"+ v;
				s1 = GameVars.bestMultiplier+"/"+ v;
			}
			else if (type == MissionType.STEALTH)
			{
				s = "Stealth! Don't kill any enemies!";
				s1 = "Stealth!";
			}
			else if (type == MissionType.SHURIKEN)
			{
				var v:int = int(value);
				if (v == -1) v = GameVars.totalEnemies;
				s = "Shuriken Kills " +GameVars.numEnemiesShurikenKilled+"/"+ v;
				s1 = GameVars.numEnemiesShurikenKilled+"/"+ v;
				
			}
			else if (type == MissionType.LEVELSCORE)
			{
				var v:int = int(value);
				s = "Level Score " +GameVars.levelScore+" / "+ v;
				s1 = GameVars.levelScore+" / "+ v;
			}
			
			renderHUDMiniString = s1;
			
			if (justReturnString == false)
			{
				dobj.RenderAtRotScaled(fr, bd, x, y, 0.6);
				TextRenderer.RenderAt(0, bd, x + 30, y, s, 0, scl, TextRenderer.JUSTIFY_LEFT);
			}
			return s;
		
		}
	}

}