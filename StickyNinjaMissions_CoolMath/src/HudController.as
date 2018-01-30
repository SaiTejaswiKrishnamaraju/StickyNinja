package  
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import AudioPackage.Audio;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.ui.GameInputControl;
	import LicPackage.Lic;
	import MissionPackage.Mission;
	import MissionPackage.MissionLevel;
	import MissionPackage.MissionObjective;
	import MissionPackage.MissionRenderer;
	import MissionPackage.Missions;
	import MissionPackage.MissionType;
	import MobileSpecificPackage.MobileSpecific;
	import TextPackage.TextRenderer;
	import TextPackage.TextStrings;
	import UIPackage.UI;
	import UIPackage.UIX;
	import UIPackage.UIX_GameObj;
	import UIPackage.UIX_GameObjects;
	import UIPackage.UIX_Instance;
	import UIPackage.UIX_PageInstance;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class HudController
	{
		
		var hudMC:MovieClip;
		
		var hudEnabled:Boolean = true;

		public function HudController() 
		{
			
		}
		
		
		function SetupMuteButtons()
		{			
			return;
				if (PROJECT::useStage3D)
				{
					return;
				}
			
			UI.SetupAnimatedSFXMuteButton(hudMC.mainArea.btn_sfxMuteBtn);
			UI.SetupAnimatedMusicMuteButton(hudMC.mainArea.btn_musicMute);
			UI.RemoveAnimatedMCButton(hudMC.mainArea.btn_moregames);
			Lic.AnimatedMCMoreGamesButton(hudMC.mainArea.btn_moregames,"hud");
		}
		function Hide()
		{
			//hudMC.visible = false;
		}
		function Show()
		{
			//hudMC.visible = true;
		}
		function ExitForLevel()
		{
			ExitScreenUIX();
		}
		function InitForLevel()
		{
			InitScreenUIX();
			return;
			
		}
		
		function InitOnce()
		{
		}
		
		function ButtonMenuPressed(e:MouseEvent)
		{
			if (PauseMenu.IsPaused() == false)
			{
				PauseMenu.Pause();
			}
		}
		
		
		function ButtonDebugSkipPressed(e:MouseEvent)
		{
			Game.NextLevel();
		}
		function ButtonRestartPressed(inst:UIX_Instance)
		{
			Game.RestartLevel();
		}
		
		
		function UpdateKeyPresses()
		{
			if (PROJECT::isGamePad)
			{
				var controlPause:GameInputControl = MobileSpecific.pad0.getControlAt(OuyaPad.Y);
				if (controlPause.value > 0.5)
				if (PauseMenu.IsPaused() == false)
				{
					PauseMenu.Pause();
				}
				return;
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_P)) 	// restart current screen
			{
				if (PauseMenu.IsPaused() == false)
				{
					PauseMenu.Pause();
				}
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_R))
			{
				Game.RestartLevel();
			}
			
		}
		
		var debugMode:int = 0;
		public function CycleDebugModes()
		{
			debugMode++;
			if (debugMode >= 3) debugMode = 0;
		}
		
		function helpPressed(e:MouseEvent)
		{
			//UI.InitHelp();
			Game.pause = true;
		}
		function logoPressed(e:MouseEvent)
		{
//			Lic.Link_Slix(e);			
		}
		function walkthroughPressed(e:MouseEvent)
		{
//			Lic.Link_Walkthrough_Slix(e);
		}
		function ButtonPausePressed(inst:UIX_Instance)
		{
			if (PauseMenu.IsPaused() == false)
			{
				PauseMenu.Pause();
			}
		}
		
//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
		
		
		var uix_pageName:String;
		var pageInst:UIX_PageInstance;
		var mc:MovieClip;
		
		public function Render(bd:BitmapData):void
		{
//			if (Game.usedebug) return;
			
			if (hudEnabled == false) return;
			if (EngineDebug.mobileTest0) return;
			
			
			pageInst.renderBD = bd;
			pageInst.RenderWithoutReset();

//			var s:String = "score: " + GameVars.currentScore;
//			TextRenderer.RenderAt(0, bd, Defs.displayarea_w-10, Defs.displayarea_h - 200, s, 0, 1, TextRenderer.JUSTIFY_RIGHT);
//			s = "combo " + GameVars.comboCounter;
//			TextRenderer.RenderAt(0, bd, Defs.displayarea_w-10, Defs.displayarea_h - 240, s,0,1,TextRenderer.JUSTIFY_RIGHT);
			

			/*
			if (PROJECT::useStage3D == false)
			{
				var rect:Rectangle = new Rectangle( 10,10,140,30);
				bd.fillRect(rect, 0xff000000);
				rect.width = Utils.ScaleTo(0, 140, 0, 1, GameVars.brakeLevel);
				bd.fillRect(rect, 0xffff0000);
			}
			*/
			
			
			
		}
		
		var digitScale:Number = 1;
		function RenderBombTimer(bd:BitmapData)
		{
			if (Game.levelState != Game.levelState_Play) return;	
			
			 Utils.CounterToMinutesSecondsMilisecondsString(GameVars.bombTimer,false);	
			
			 var x:Number = 200;
			 var y:Number = 100;

			 
			 var sc:Number = 1;		
			 var dir:Number = 0;
			 var isRed:Boolean = false;
			 
			 if (GameVars.bombTimer < Defs.fps * 10)
			 {
				 isRed = ((Game.levelTimer % 50) < 25);
			 }
			 if (GameVars.bombTimer < Defs.fps * 5)
			 {
				 sc = digitScale;
				 digitScale += 0.01;
				 if (digitScale >= 1.3)
				 {
					 digitScale = 1.0;
				 }				 
			 }
			 else
			 {
				 digitScale = 1;
			 }
			 if (GameVars.bombTimer < Defs.fps * 3)
			 {
				dir = 1;
			 }
			 
			 
			var dobj:DisplayObj;
			if (isRed == false)
			{
				dobj = GraphicObjects.GetDisplayObjByName("TimerDigits");
			}
			else
			{
				dobj = GraphicObjects.GetDisplayObjByName("TimerDigitsRed");
			}
			
			 
			 
			 
			 RenderDigits(dobj,x, y, bd, Utils.minutesString,sc,dir,isRed);
			 
			 var spacing1:int = 120;
			 var spacing2:int = 60;
			 
			 
			 x += spacing1;
			 dobj.RenderAt(10, bd, x, y);
			 x += spacing2;
			 
			 RenderDigits(dobj,x, y, bd, Utils.secondsString,sc,dir,isRed);
			 
			 x += spacing1;
			 dobj.RenderAt(10, bd, x, y);
			 x += spacing2;
			 
			 RenderDigits(dobj,x, y, bd, Utils.miliString,sc,dir,isRed);
			
		}
		function RenderDigits(dobj:DisplayObj,x:Number, y:Number, bd:BitmapData, str:String, scale:Number = 1, dir:Number = 0,isRed:Boolean=false )
		{
			
			if (str.length == 1) str = "0" + str;
			if (str.length != 2) return;
			
			if (dir != 0)
			{
				dir = Utils.RandBetweenFloat( -0.1, 0.1);
			}
			
			var s1:int = str.charCodeAt(0) - "0".charCodeAt(0);
			var s2:int = str.charCodeAt(1) - "0".charCodeAt(0);
			
			
			
			dobj.RenderAtRotScaled(s1, bd, x, y, scale, dir);
			dobj.RenderAtRotScaled(s2, bd, x + 64, y, scale, dir);
			
		}
		
		
		function ExitScreenUIX()
		{			
			if (hudEnabled == false) return;

			UIX.StopPage_Overlay();
			MouseControl.buttonPressed = false;
			MouseControl.buttonReleased = false;
		}
		
		function Stop()
		{
			ExitScreenUIX();
		}
		
		
		function InitScreenUIX()
		{
			if (hudEnabled == false) return;

			
			uix_pageName = "page_hud";
			if (PROJECT::useStage3D)
			{
//				uix_pageName = "page_hud_mobile_" + int(GameVars.CurrentControlLayoutIndex + 1);
			}
			if (PROJECT::isGamePad)
			{
				uix_pageName = "page_hud_ouya";
			}
			pageInst = UIX.StartPage_Overlay(uix_pageName);

			GetInstancesOnce();
			
			UIX.AddAnimatedButton(pageInst.Child("buttonPause"), ButtonPausePressed);
			UIX.AddAnimatedButton(pageInst.Child("buttonRetry"), ButtonRestartPressed);
			
			UIX.AddAnimatedSFXMuteButton(pageInst.Child("buttonMuteSFX"));
			
			GameVars.InitBoostsFromHud();
			

			missionTexts = new Array();
			missionTicks = new Array();
			
			
			
			
			var ml:MissionLevel  = Missions.GetCurrentMissionLevel();
			for (var i:int = 0; i < 3; i++)
			{
				var n:String = "startLevelObjective" + int(i + 1);
				var objInst:UIX_Instance = pageInst.Child(n);
				if (objInst != null)
				{
					objInst.visible = false;
					if (i < ml.objectives.length)
					{
						objInst.visible = true;
						objInst.Child("textInfo").SetText(ml.objectives[i].name);
						objInst.Child("icon").frame = MissionType.GetIndex(ml.objectives[i].type);
						pageInst.gameObjects.AddInstance(objInst).InitMissionInfoIngame(i+10);
					}
				}
				
				
				
				var n:String = "objective" + int(i + 1);
				var objInst:UIX_Instance = pageInst.Child(n);
				if (objInst != null)
				{
					objInst.visible = false;
					if (i < ml.objectives.length)
					{
						objInst.visible = true;
						objInst.Child("textInfo").SetText(ml.objectives[i].name);
						objInst.Child("icon").frame = MissionType.GetIndex(ml.objectives[i].type);
						
						missionTexts.push(objInst.Child("textInfo"));
						missionTicks.push(objInst.Child("tick"));
						pageInst.gameObjects.AddInstance(objInst).InitMissionInfoHud(i+10);
					}
				}
				
			}
			
			
			
			if (PROJECT::useStage3D)
			{
				var inst:UIX_Instance;
				inst = pageInst.Child("buttonJump");
				if(inst != null) GameVars.touchRect_Jump = GetUnitRectFromScreenCircle(inst.x, inst.y, 60);
				inst = pageInst.Child("buttonAccel");
				if(inst != null) GameVars.touchRect_Accel = GetUnitRectFromScreenCircle(inst.x, inst.y, 60);
				inst = pageInst.Child("buttonNitro");
				if(inst != null) GameVars.touchRect_Nitro = GetUnitRectFromScreenRect(inst.x-200, inst.y-40, 400,80);
			}

			var controlsInst:UIX_Instance = pageInst.Child("controls");
			if (controlsInst != null)
			{
				controlsInst.visible = false;
				if (GameVars.currentOrderedLevelIndex < 2)
				{
					controlsInst.visible = true;
				}
			}
			controlsTimer = 0;
			objectivesTimer = 0;
			
			achievement_inst = pageInst.Child("achievementPopup");
			achievement_inst.visible = false;
			pageInst.gameObjects.AddInstance(achievement_inst).InitAchievementsPopup(0);
			pageInst.gameObjects.Update();
			
		}
		
		var missionTexts:Array;
		var missionTicks:Array;
		
		public var achievement_inst:UIX_Instance;
		
		var objectivesTimer:int;
		var controlsTimer:int;
		
		var inst_progressBar:UIX_Instance;
		var inst_carMarkerPlayer:UIX_Instance;
		var inst_carMarkers:Vector.<UIX_Instance>
		function GetInstancesOnce()
		{
			inst_progressBar = pageInst.Child("progressBar");
			inst_carMarkerPlayer = pageInst.Child("carMarkerPlayer");
			
			inst_carMarkers = new Vector.<UIX_Instance>();
			
			inst_carMarkers.push(pageInst.Child("carMarker1"));
			inst_carMarkers.push(pageInst.Child("carMarker2"));
			inst_carMarkers.push(pageInst.Child("carMarker3"));
			inst_carMarkers.push(pageInst.Child("carMarker4"));
			inst_carMarkers.push(pageInst.Child("carMarker5"));
			inst_carMarkers.push(pageInst.Child("carMarker6"));
			
		}
		
		
		function Update()
		{
			
			if (hudEnabled == false) return;
			if (EngineDebug.mobileTest3) return;
			
			UpdateKeyPresses();
			
			var controlsInst:UIX_Instance = pageInst.Child("controls");
			if (controlsInst != null)
			{
				if (GameVars.currentOrderedLevelIndex < 2)
				{
					controlsTimer++;
					if (controlsTimer >= 200)
					{
						controlsTimer = 0;
						if (controlsInst.frame == 0)
						{
							controlsInst.frame = 1;
						}
						else
						{
							controlsInst.frame = 0;
						}
					}
					
				}
			}
			
			var ml:MissionLevel = Missions.GetCurrentMissionLevel();
			var s:String;
			
			var info:UIX_Instance = pageInst.Child("info");
			var infojumps:UIX_Instance = info.Child("jumps");
			var infolives:UIX_Instance = info.Child("lives");
			var jumpIcon:UIX_Instance = info.Child("jumpIcon");
			var gold:UIX_Instance = info.Child("gold");
			infojumps.SetText(GameVars.numLevelFlicks.toString());
			infolives.SetText(GameVars.lives.toString());
			gold.SetText(GameVars.levelScore.toString());
			
			var levelAward:int = 0;
			if (GameVars.numLevelFlicks <= ml.medalJumps[1]) levelAward = 1;
			if (GameVars.numLevelFlicks <= ml.medalJumps[0]) levelAward = 2;
			jumpIcon.frame = levelAward;
			
			
			
			var i:int = 0;
			for each(var mo:MissionObjective in ml.objectives)
			{
				mo.RenderHud(null, 0, 0, 1, true);
				var s:String = mo.renderHUDMiniString;
				var inst:UIX_Instance;
				inst = missionTicks[i];
				inst.visible = false;
				if (mo.TestPass()) inst.visible = true;
				
				inst = missionTexts[i];
				inst.SetText(s);
				
				i++;
				
			}
			
			pageInst.gameObjects.Update();
			
			
			
/*			
			if (PROJECT::isMobile)
			{
			var go:GameObj = GameVars.playerGO;
			var inst0:UIX_Instance;
			var inst1:UIX_Instance;
			var inst2:UIX_Instance;
			var inst3:UIX_Instance;
			inst0 = pageInst.Child("buttonJump");
			inst1 = pageInst.Child("buttonAccel");
			inst2 = pageInst.Child("buttonNitro");
			
			inst0.frame = 0;
			inst1.frame = 0;
			inst2.frame = 0;
			
			if (go.jumpPressed) inst0.frame += 4;
			if (go.accel) inst1.frame += 4
			if (go.extraTopSpeedTimer > 0) inst2.frame += 4
			}
			*/
		}
		
		function GetUnitRectFromScreenCircle(x:Number, y:Number, rad:Number):Rectangle
		{
//			x = ScreenSize.XtoUnit(x);
//			y = ScreenSize.YtoUnit(y);
//			rad = ScreenSize.XtoUnit(rad);
			
			var r:Rectangle = new Rectangle(x - rad, y - rad, rad * 2, rad * 2);
//			trace(r);
			return r;
			
		}
		
		function GetUnitRectFromScreenRect(x:Number,y:Number,w:Number,h:Number):Rectangle
		{
//			x = ScreenSize.XtoUnit(x);
//			y = ScreenSize.YtoUnit(y);
//			rad = ScreenSize.XtoUnit(rad);
			
			var r1:Rectangle = new Rectangle(x,y,w,h);
//			trace(r);
			return r1;
			
		}
		
		
	}

}