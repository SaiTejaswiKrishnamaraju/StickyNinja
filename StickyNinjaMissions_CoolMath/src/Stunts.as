package  
{
	import AudioPackage.Audio;
	/**
	 * ...
	 * @author 
	 */
	public class Stunts 
	{
		
		public function Stunts() 
		{
			
		}
		
		public static const STUNT_NONE:int = 0;
		public static const STUNT_REARWHEELIE:int = 1;
		public static const STUNT_FRONTWHEELIE:int = 2;
		public static const STUNT_BACKROLL:int = 3;
		public static const STUNT_FORWARDROLL:int = 4;
		public static const STUNT_AIRTIME:int = 5;
		public static const STUNT_UPDSIDEDOWN:int = 6;
		public static const STUNT_PERFECT_LANDING:int = 7;
		public static const STUNT_MAX:int = STUNT_PERFECT_LANDING;
		
		public static var displayNames:Array = [
				"None",
				"Rear Wheelie",
				"Front Wheelie",
				"Back Roll",
				"Forward Roll",
				"Air Time",
				"Upside Down",
				"Perfect Landing" ];
		public static function GetStuntDisplayName(index:int)
		{
			return displayNames[index];
		}
		
		var combo:Array;
		var comboTimer:int;
		function InitCombos()
		{
			combo = new Array();
		}
		function UpdateCombos(_go:GameObj)
		{
			go = _go;
			if (comboTimer == 0)
			{
				return;
			}
			comboTimer--;
		}
		
		function StuntDone(stuntName:String, data:int)
		{
//			trace("Stunt done " + stuntName);
			
			if (stuntName == "backward_roll")
			{
				GameVars.AddToCash(50);
				
				PhysicsBase.AddPhysObjAt("boostbomb", go.xpos, go.ypos,0,1);
				Stats.Add("Total Rolls", 1);
//				Audio.OneShot("sfx_roll");
			}
			if (stuntName == "forward_roll")
			{
				GameVars.AddToCash(50);
//				Audio.OneShot("sfx_roll");
				PhysicsBase.AddPhysObjAt("boostbomb", go.xpos, go.ypos, 0, 1);
				Stats.Add("Total Rolls", 1);

			}
			
			if (stuntName == "perfect_landing")
			{				
//				Particles.Add(go.xpos, go.ypos - 10).InitInfoPopup("Popups", 5);
//				GameVars.AddToCash(50);
//				Audio.OneShot("sfx_roll");
			}
			
			
			if (comboTimer == 0)
			{
				// first one
				combo = new Array();
			}
			combo.push(stuntName);
			comboTimer = 100;
			
			if (combo.length >= 2)
			{
				//go.InitPlayerStuntStar("Combo x" + combo.length,-120);
			}
			
		}
		
		
		var canUseStunts:Boolean;
		var playerRotCount:int;
		var canDoPerfectLanding:Boolean;
		var oldPlayerRot:Number;
		var playerRot:Number;
		var playerUpsideDownCounter:int;
		var totalStunts:int;
		var levelPerfectLandings:int;
		var levelUpsideDownTime:int;
		var singleUpsideDownTime:int;
		var bestUpsideDownTime:int;
		
		var playerRotMode:int;
		var playerRotLeaveGround:Number;
		var multiRollCount:int;
		var highestFrontMultiRoll:int;
		var multiFrontRollCount:int;
		var levelBackRolls:int;
		var multiBackRollCount:int;
		var levelFrontRolls:int;
		var highestBackMultiRoll:int;
		var highestMultiRoll:int;
		
		var bestSingleAirTime:int = 0;
		var levelAirTime:int = 0;
		var bestFrontWheelieTime:int = 0;
		var levelFrontWheelieTime:int = 0;
		var bestRearWheelieTime:int = 0;
		var levelWheelieTime:int = 0;
		var levelBoostAtMaxTime:int = 0;
		
		var boostModifier_UpsideDown:Number;
		var boostModifier_UpsideDownMax:Number;
		
		public function Reset()
		{
			canUseStunts = true;
			playerRotCount = 0;
			canDoPerfectLanding = false;
			oldPlayerRot = 0;
			playerRot = 0;
			playerUpsideDownCounter = 0;
			totalStunts = 0;
			levelPerfectLandings = 0;
			levelUpsideDownTime = 0;
			singleUpsideDownTime = 0;
			bestUpsideDownTime = 0;
			
			bestSingleAirTime = 0;
			levelAirTime = 0;
			bestFrontWheelieTime = 0;
			levelFrontWheelieTime = 0;
			bestRearWheelieTime = 0;
			levelWheelieTime = 0;
			levelBoostAtMaxTime = 0;
			
			playerRotMode = 0;
			playerRotLeaveGround = 0;
			highestFrontMultiRoll = 0;
			levelBackRolls = 0;
			highestMultiRoll = 0;
			highestBackMultiRoll = 0;
			multiRollCount = 0;
			multiFrontRollCount = 0;
			multiBackRollCount = 0;			
			levelFrontRolls = 0;
					
			airTime = 0;
			frontWheelieTimer = 0;
			rearWheelieTimer = 0;
			playerUpsideDownCounter = 0;
			isDoingAir = false;
			isDoingFrontWheelie = false;
			isDoingRearWheelie = false;
			isDoingUpsideDown = false;
			addRotationTimer = 0;
			playerRotCount = 0;
			canDoPerfectLanding = false;
			
			
			
			InitCombos();
		}
		
		public function ResetWhenDead()
		{
			playerRotCount = 0;
			canDoPerfectLanding = false;
			oldPlayerRot = 0;
			playerRot = 0;
			playerUpsideDownCounter = 0;
			singleUpsideDownTime = 0;
			
			playerRotMode = 0;
			playerRotLeaveGround = 0;

			multiRollCount = 0;
			multiFrontRollCount = 0;
			multiBackRollCount = 0;			
					
			isDoingAir = false;
			isDoingFrontWheelie = false;
			isDoingRearWheelie = false;
			isDoingUpsideDown = false;
			playerRotCount = 0;
			canDoPerfectLanding = false;
			
			airTime = 0;
			frontWheelieTimer = 0;
			rearWheelieTimer = 0;
			playerUpsideDownCounter = 0;
			addRotationTimer = 0;
			
			multiRollCount = 0;
			multiFrontRollCount = 0;
			multiBackRollCount = 0;						
			
			InitCombos();
		}
		
		var frontWheelOnFloorTimer:int = 0;
		var rearWheelOnFloorTimer:int = 0;
		
		var rearWheelDownTimer:int = 0;
		var frontWheelDownTimer:int = 0;
		
		var frontWheelieTimer:int = 0;
		var rearWheelieTimer:int = 0;
		var airTime:int = 0;
		
		var rearWheelieMinTime:int = 30;
		var frontWheelieMinTime:int = 30;
		var airMinTime:int = Defs.fps / 2;
		var upsideDownMinTime:int = 30;
		var isDoingRearWheelie:Boolean = false;
		var isDoingFrontWheelie:Boolean = false;
		var isDoingAir:Boolean = false;
		var isDoingUpsideDown:Boolean = false;
		var addRotationTimer:int  = 0;
		var wheelOffGroundStillThinksItsOnGroundTime:int = 15;
		
		var go:GameObj;
		
		
		var specialStuntModifier:Number = 1.2;
		function IsSpecialStunt(stuntIndex:int):Boolean
		{
			var bd:BikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			return stuntIndex == bd.specialStunt;
		}
		
		function CompleteRearWheelie()
		{
			
			if (rearWheelieTimer > rearWheelieMinTime)
			{
				StuntDone("rear_wheelie", rearWheelieTimer);
				
				levelWheelieTime += rearWheelieTimer

				
				var stuntvalue_rearwheelie:Number = Vars.GetVarAsNumber("stuntvalue_rearwheelie");
				var val:Number = (rearWheelieTimer / Defs.fps) * stuntvalue_rearwheelie;
				
				if (IsSpecialStunt(STUNT_REARWHEELIE)) 
				{
//					Game.hudController.FlashSpecialIcon();
					val *= specialStuntModifier;
				}
				
				var amt:Number = go.AddToBoost(val);

				totalStunts++;

				
				
				if (rearWheelieTimer > bestRearWheelieTime)
				{
					bestRearWheelieTime = rearWheelieTimer;
				}
				
			}			
			StopRearWheelie();
			StopFrontWheelie();
		}
		function CompleteFrontWheelie()
		{
			if (frontWheelieTimer > frontWheelieMinTime)
			{
				StuntDone("front_wheelie", frontWheelieTimer);
					
				levelFrontWheelieTime += frontWheelieTimer

				
				var stuntvalue_frontwheelie:Number = Vars.GetVarAsNumber("stuntvalue_frontwheelie");
				var val:Number = (frontWheelieTimer / Defs.fps) * stuntvalue_frontwheelie;				
				var amt:Number = go.AddToBoost(val);	
				
				if (IsSpecialStunt(STUNT_FRONTWHEELIE)) 
				{
					val *= specialStuntModifier;
				}

				
				totalStunts++;

				
				if (frontWheelieTimer > bestFrontWheelieTime)
				{
					bestFrontWheelieTime = frontWheelieTimer;
				}
				
			}			
			StopRearWheelie();
			StopFrontWheelie();
		}
		function StopRearWheelie()
		{
			rearWheelieTimer = 0;			
		}
		function StopFrontWheelie()
		{
			frontWheelieTimer = 0;			
		}
		
		public function UpdateWheels(_go:GameObj)
		{
			var stuntvalue_upsidedown:Number = Vars.GetVarAsNumber("stuntvalue_upsidedown");
			var stuntvalue_frontloop:Number = Vars.GetVarAsNumber("stuntvalue_frontloop");
			var stuntvalue_backloop:Number = Vars.GetVarAsNumber("stuntvalue_backloop");
			var stuntvalue_airtime:Number = Vars.GetVarAsNumber("stuntvalue_airtime");
			var stuntvalue_perfectlanding:Number = Vars.GetVarAsNumber("stuntvalue_perfectlanding");
			
			var stunt_mintime_wheelie:Number = Vars.GetVarAsNumber("stunt_mintime_wheelie") * Defs.fps;
			var stunt_mintime_upsidedown:Number = Vars.GetVarAsNumber("stunt_mintime_upsidedown") * Defs.fps;
			var stunt_mintime_airtime:Number = Vars.GetVarAsNumber("stunt_mintime_airtime") * Defs.fps;
			
			go = _go;
			rearWheelOnFloorTimer--;
			if (rearWheelOnFloorTimer <= 0)
			{
				rearWheelOnFloorTimer = 0;
				rearWheelDownTimer = 0;
			}
			else
			{
				rearWheelDownTimer++;
			}
			
			frontWheelOnFloorTimer--;
			if (frontWheelOnFloorTimer <= 0)
			{
				frontWheelOnFloorTimer = 0;
				frontWheelDownTimer = 0;
			}
			else
			{
				frontWheelDownTimer++;
			}
			
			isDoingAir = false;
			isDoingFrontWheelie = false;
			isDoingRearWheelie = false;
			
			
			// new style rear wheelie
			
			if (frontWheelOnFloorTimer == 0 && rearWheelOnFloorTimer > 1)
			{
				rearWheelieTimer++;
			}
			if (frontWheelOnFloorTimer > 0 && rearWheelieTimer > 0)
			{
				if (rearWheelieTimer > rearWheelieMinTime)
				{
					CompleteRearWheelie();
				}
			}
			if (rearWheelieTimer > rearWheelieMinTime)
			{
				isDoingRearWheelie = true;
			}
			

			// new style front wheelie
			
			if (rearWheelOnFloorTimer == 0 && frontWheelOnFloorTimer > 1)
			{
				frontWheelieTimer++;
			}
			if (rearWheelOnFloorTimer > 0 && frontWheelieTimer > 0)
			{
				if (frontWheelieTimer > frontWheelieMinTime)
				{
					CompleteFrontWheelie();
				}
			}
			if (frontWheelieTimer > frontWheelieMinTime)
			{
				isDoingFrontWheelie = true;
			}
			
			if (rearWheelDownTimer == 0 && frontWheelDownTimer == 0)
			{
				airTime++;
				if (airTime > airMinTime)
				{
					isDoingAir = true;
					StopRearWheelie();
					StopFrontWheelie();
				}
			}
			else
			{
				

				
				/*
				if (airTime > airMinTime)
				{
					levelAirTime += airTime;

					
					if (goodLandingTimer0 < 5 && goodLandingTimer1 < 5)
					{
						var val:Number = (airTime / Defs.fps) * stuntvalue_perfectlanding;

						if (IsSpecialStunt(STUNT_PERFECT_LANDING)) 
						{
//							Game.hudController.FlashSpecialIcon();
							val *= specialStuntModifier;
						}
						
						totalStunts++;


						var amt:Number = go.AddToBoost(val);
						StuntDone("perfect_landing", airTime);
						levelPerfectLandings++;
					}
					else
					{						
						var val:Number = (airTime / Defs.fps) * stuntvalue_airtime;
						var amt:Number = go.AddToBoost(val);

						if (IsSpecialStunt(STUNT_AIRTIME)) 
						{
//							Game.hudController.FlashSpecialIcon();
							val *= specialStuntModifier;
						}

						totalStunts++;

						
						StuntDone("air_time", airTime);
					}
					
				}
				airTime = 0;
				*/
			}
			
			
			
			
		}
		
		var goodLandingTimer0:int = 0;
		var goodLandingTimer1:int = 0;
		
		
		function TestGoodLanding()
		{
			var amt:int = 2;
			if (canDoPerfectLanding)
			{
				if (goodLandingTimer0 < amt && goodLandingTimer1 < amt)
				{
					StuntDone("perfect_landing", 0);
					canDoPerfectLanding = false;
				//trace(goodLandingTimer0 + "  " + goodLandingTimer1);
				}
				if (goodLandingTimer0 >= amt && goodLandingTimer1 >= amt)
				{
					canDoPerfectLanding = false;
				}
			}			
		}
		
		public function RearWheelDown(firstTime:Boolean)
		{
			rearWheelOnFloorTimer = wheelOffGroundStillThinksItsOnGroundTime;
			
			if (firstTime)
			{
				goodLandingTimer0 = 0;
			}
			else
			{
				goodLandingTimer0++;
			}
			TestGoodLanding();
			playerRotMode = 0;
			playerRotCount = 0;
		}

		public function FrontWheelDown(firstTime:Boolean)
		{
			frontWheelOnFloorTimer = wheelOffGroundStillThinksItsOnGroundTime;
			
			if (firstTime)
			{
				goodLandingTimer1 = 0;
			}
			else
			{
				goodLandingTimer1++;
			}
			TestGoodLanding();
			playerRotMode = 0;
			playerRotCount = 0;
			
		}
		
		
		
		public function Update(_go:GameObj)
		{
			
			var stuntvalue_upsidedown:Number = Vars.GetVarAsNumber("stuntvalue_upsidedown");
			var stuntvalue_frontloop:Number = Vars.GetVarAsNumber("stuntvalue_frontloop");
			var stuntvalue_backloop:Number = Vars.GetVarAsNumber("stuntvalue_backloop");
			var stuntvalue_airtime:Number = Vars.GetVarAsNumber("stuntvalue_airtime");
			var stuntvalue_perfectlanding:Number = Vars.GetVarAsNumber("stuntvalue_perfectlanding");
			
			var stunt_mintime_wheelie:Number = Vars.GetVarAsNumber("stunt_mintime_wheelie") * Defs.fps;
			var stunt_mintime_upsidedown:Number = Vars.GetVarAsNumber("stunt_mintime_upsidedown") * Defs.fps;
			var stunt_mintime_airtime:Number = Vars.GetVarAsNumber("stunt_mintime_airtime") * Defs.fps;
			
			go = _go;
			if (canUseStunts == false) return;
			oldPlayerRot = go.oldDir;
			playerRot = go.dir;
			
			var pi2:Number = Math.PI * 2;
			var pi:Number = Math.PI;
			
			var orc:int = playerRotCount;

			var a:Number = oldPlayerRot % pi2;
			var b:Number = playerRot % pi2;
			if (a < 0) a = pi2 + a;
			if (b < 0) b = pi2 + b;
			
			
			var rb:Number = Utils.RadToDeg(b);
			
			isDoingUpsideDown = false;
			
			
			var upsideDownAngRange:Number = 60;
			if (rb > 180 - upsideDownAngRange && rb < 180 + upsideDownAngRange)
			{
				playerUpsideDownCounter++;
				
				if (playerUpsideDownCounter > upsideDownMinTime)
				{
					isDoingUpsideDown = true;
					StopRearWheelie();
					StopFrontWheelie();
				}
			}
			else
			{
				if (playerUpsideDownCounter > upsideDownMinTime)
				{
					
					var singleUpsideDownTime:int = playerUpsideDownCounter;
					
					var val:Number = (playerUpsideDownCounter / Defs.fps) * stuntvalue_upsidedown;
					
					if (IsSpecialStunt(STUNT_UPDSIDEDOWN)) 
					{
//						Game.hudController.FlashSpecialIcon();
						val *= specialStuntModifier;
					}
					var amt:Number = go.AddToBoost(val);
					

					StuntDone("invert", singleUpsideDownTime);

					
					
					totalStunts++;
					
					levelUpsideDownTime += singleUpsideDownTime;
					if (singleUpsideDownTime > bestUpsideDownTime)
					{
						bestUpsideDownTime = singleUpsideDownTime;
					}
				}				
				playerUpsideDownCounter = 0;
			}
			
			// rotate
			if(Math.abs(b-pi) < 0.5)
			{
				if (playerRotMode == 0) // either way
				{
					
					if (a < pi && b >= pi)
					{
						
						playerRotMode = 1;
						playerRotLeaveGround = playerRot + pi;
						playerRotCount++;
						canDoPerfectLanding = true;
						
						multiRollCount = 0;
						multiFrontRollCount = 0;
						multiBackRollCount = 0;
						
					}
					else if (a > pi && b <= pi)
					{
						
						playerRotMode = -1;
						playerRotLeaveGround = playerRot - pi;
						playerRotCount++;
						canDoPerfectLanding = true;
						multiRollCount = 0;
						multiFrontRollCount = 0;
						multiBackRollCount = 0;
					}
					
				}
				else if (playerRotMode == 1)
				{
					if (a < pi && b >= pi)
					{
						if (playerRot > playerRotLeaveGround)
						{
							
							playerRotLeaveGround = playerRot + pi;		
							playerRotCount++;
							canDoPerfectLanding = true;
						}
					}				
				}
				else if (playerRotMode == -1)
				{
					if (a > pi && b <= pi)
					{
						if (playerRot < playerRotLeaveGround)
						{
							
							playerRotLeaveGround = playerRot - pi;	
							playerRotCount++;
							canDoPerfectLanding = true;
						}
					}
				}
			}			
			
			if (orc != playerRotCount)
			{
				var tt:int = multiRollCount;
				
				if (tt >= rollText.length) tt = rollText.length - 1;
				var tts:String = rollText[tt];
				
				addRotationTimer = 100;
				
				if (playerRotMode == 1) 
				{
					
					levelFrontRolls++;

					var val:Number = (playerRotCount * stuntvalue_frontloop);
					if (IsSpecialStunt(STUNT_FORWARDROLL)) 
					{
						//Game.hudController.FlashSpecialIcon();
						val *= specialStuntModifier;
					}

					var amt:Number = go.AddToBoost(val);
					//InitMessage(tts + "Forward Roll");
					
					
					StuntDone("forward_roll", playerRotCount);
					
					totalStunts++;
					
					StopRearWheelie();
					StopFrontWheelie();
					
					multiFrontRollCount++;
					if (multiFrontRollCount > highestFrontMultiRoll)
					{
						highestFrontMultiRoll = multiFrontRollCount;
					}
					

				}
				if (playerRotMode == -1) 
				{

					
					levelBackRolls++;
					
					var val:Number = (playerRotCount * stuntvalue_backloop);
					if (IsSpecialStunt(STUNT_BACKROLL)) 
					{
						//Game.hudController.FlashSpecialIcon();
						val *= specialStuntModifier;
					}
					
					var amt:Number = go.AddToBoost(val);
					//InitMessage(tts+"Back Roll");
					StuntDone("backward_roll", playerRotCount);
					totalStunts++;
					
					StopRearWheelie();
					StopFrontWheelie();
					
					multiBackRollCount++;
					if (multiBackRollCount > highestBackMultiRoll)
					{
						highestBackMultiRoll = multiBackRollCount;
					}
					
				}
				
				multiRollCount++;
				if (multiRollCount > highestMultiRoll)
				{
					highestMultiRoll = multiRollCount;
				}
				
				
				
			}
			
		}
		
		var rollText:Array = new Array(
			"",
			"Double ",
			"Triple ",
			"Quadruple ",
			"Quintuple ",
			"Multi ");
		
		
	}

}