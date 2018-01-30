package  
{
	import AchievementPackage.Achievements;
	import AchievementPackage.Leaderboards;
	import AnimPackage.AnimDefinitions;
	import AudioPackage.Audio;
	import EditorPackage.EdJoint;
	import EditorPackage.EdLine;
	import EditorPackage.EdObj;
	import EditorPackage.GameLayers;
	import EditorPackage.PhysEditor;
	import EditorPackage.PolyMaterial;
	import EditorPackage.PolyMaterials;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import LicPackage.LicCoolmath;
	import MissionPackage.MissionLevel;
	import MissionPackage.Missions;
	import MobileSpecificPackage.MobileSpecific;
	import nape.phys.BodyList;
	import nape.space.Space;
	import PlayerRecordPackage.PlayerRecording;
	import PlayerRecordPackage.PlayerRecordings;
	import TexturePackage.TexturePages;
	if (PROJECT::useStage3D)
	{
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	}
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.system.System;
	import flash.ui.*;
	import flash.utils.getDefinitionByName;
	import GameObj;
	import LicPackage.AdHolder;
	import LicPackage.Lic;
	import LicPackage.LicAds;
	import LicPackage.LicDef;
	import nape.callbacks.BodyCallback;
	import nape.constraint.AngleJoint;
	import nape.constraint.Constraint;
	import nape.constraint.DistanceJoint;
	import nape.constraint.MotorJoint;
	import nape.constraint.PivotJoint;
	import nape.dynamics.InteractionFilter;
	import nape.geom.GeomPoly;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.util.BitmapDebug;
	import nape.util.Debug;
	import Particles;
	import TextPackage.BitmapFonts;
	import TextPackage.TextRenderer;
	import TextPackage.TextStrings;
	import UIPackage.UI;
	import UIPackage.UIX;
	import UIPackage.UIX_PageInstance;
	


	/**
	* ...
	* @author Default
	*/
	public class Game
	{
		public static var isWildTangent:Boolean = true;
		
		public static var seed:String = "turbonuke";
		
		
		public static var using30fps:Boolean = false;
		public static var usingTilt:Boolean = false;
		public static var is_11_3:Boolean = false;
		public static var ad_free_unlocked:Boolean = false;
		public static var full_version_unlocked:Boolean = false;
		
		public static var saveTextureFiles:Boolean = true;	
		public static var loadTextureFiles:Boolean = false;	
		
		public static var doWalkthrough:Boolean = false;		
		public static var recordWalkthrough:Boolean = false;
		public static var playbackWalkthrough:Boolean = false;
		public static var usedebug:Boolean = true;
		public static var soundon:Boolean = true;
		
		public static var use_localisation:Boolean = false;
		public static var load_vars_data:Boolean = true;
		
		public static var record_player:Boolean = false;
		public static var useLocalRuns:Boolean = true;
		
		public static var controlMode:int = 0;
		
		if(PROJECT::isWalkthrough)
		{
			doWalkthrough= true;		
			recordWalkthrough= false;
			playbackWalkthrough= true;			
			usedebug= false;			
			soundon= false;			
			load_vars_data = false;		
		}

		if(PROJECT::isFinal)
		{
			recordWalkthrough= false;
			playbackWalkthrough= false;			
		usedebug= false;			
			soundon= true;			
			load_vars_data = false;	
		record_player = false;
		useLocalRuns = true;
		}

		if(PROJECT::useStage3D)
		{
		usedebug = false;
			load_vars_data = false;
		record_player = false;
			useLocalRuns = true;		
		}
		if(PROJECT::useStage3D == false)
		{
			loadTextureFiles = false;
		}
		
		if (PROJECT::isMobile)
		{
			usingTilt = true;
		loadTextureFiles = true;
		}
		if (PROJECT::isMobile == false)
		{
		}
		
		if (PROJECT::isAirPC)
		{
		loadTextureFiles = false;
		usedebug= true;
		}
		
		
		
		if (PROJECT::isAndroid)
		{
			saveTextureFiles = false;
		}
		if (PROJECT::isIOS)
		{
			saveTextureFiles = false;
		}
		if(PROJECT::isGamePad)
		{
		saveTextureFiles = false;
		usingTilt = true;
		}
		
		static var debugPrint:Boolean = false;
		static var debugPrintError:Boolean = true;
		
		
		public static var unlockEverything:Boolean = false;
		
		public static var doLevelEndTests:Boolean = true;
		public static var onlyFinalLevels:Boolean = true;
		
		public static var debugTest1:Boolean = false;
		public static var debugTest2:Boolean = false;
		public static var debugTest3:Boolean = false;

		public static var version:Number = 1;
		
		public static const gameState_UI = 0;
		public static const gameState_Play = 1;
		public static const gameState_Walkthrough = 2;
				
		public static const levelState_LevelStart = 0;
		public static const levelState_Play = 1;
		public static const levelState_Null = 2;
		public static const levelState_Editor = 3;
		public static const levelState_Complete = 4;
		public static const levelState_EndScreen = 5;
		public static const levelState_BonusSectionStart = 6;
		public static const levelState_BonusSection = 7;
		public static const levelState_PlayerDead = 8;
		
		
		static var debugPlayerInvulnerable:Boolean = false;
		
		static var currentGameMusic:int;
		
		public static var frameSkip:int = 1;
		
		public static var currentMC:MovieClip;
		public static var main:Main;
		public static var levelScore:int;
		public static var scoreMultiplier:int;

		public static var numLevels:int;
		public static var numLives:int;
		
		public static var pause:Boolean;
		public static var pauseGameplayInput:Boolean;
		
		public static var levelTimer:int;
		
		public static var mapBD:BitmapData;
		public static var polyDOF:DisplayObjFrame;
		public static var backDOF:DisplayObjFrame;
		public static var backDOF2:DisplayObjFrame;
		public static var backBD:BitmapData;
		public static var backBD2:BitmapData;
		public static var backgroundScreenBD:BitmapData;
		public static var polyScreenBD:BitmapData;
		public static var shadowScreenBD:BitmapData;
		public static var scrollScreenBD:BitmapData;
		public static var scrollScreenTempBD:BitmapData;
		public static var foregroundScreenBD:BitmapData;
		public static var flattenedScreenBD:BitmapData;
		public static var particleScreenBD:BitmapData;
		public static var layerScreenBD:BitmapData;
		public static var copyScreenBD:BitmapData;
		public static var fillScreenMC:MovieClip;
		public static var fillScreenMC1:MovieClip;
		
		public static var camera:Camera;
		public static var boundingRectangle:Rectangle;
		
		public static var levelState:int;
		public static var gameState:int;
		public static var levelStateTimer:int;
		public static var levelStateCount:int;

		public static var objectDefs:PhysObjs;
		public static var physMaterials:Array;
		
		
		public static var lastGeneratedGameObj:GameObj;
		public static var zsortoffset:Number = 0;
		public static var levelSuccessFlag:Boolean;
		public static var levelFailReason:String="";

		public static var levelJustUnlocked:Boolean = false;
		
		public static var level_instances:Array;
		
		public static var textFrameOffset:int;
		
		public static var currentBackground:int;
		
		public static var goCursor:GameObj;
		public static var goMarker:GameObj;

		public static var hudController:HudController;
		
		// Game initialised ONCE only
		// Game initialised ONCE only
		public static function InitOnce(_main:Main)
		{
			main = _main;
			
			
			GameVars.currentScore = 0;
			scoreMultiplier = 1;
			numLevels = 8;
			Levels.currentIndex = 0;		

			Vars.InitOnce();
			AnimDefinitions.InitOnce();

			BitmapFonts.InitOnce();
			TextStrings.InitOnce();

			PlayerRecordings.InitOnce();


			PolyMaterials.InitOnce();
			ObjectParameters.InitOnce();
			PolyDefs.InitOnce();
			
			UIX.InitOnce();

			SurfaceParameters.InitOnce();
			BikeDefs.InitOnce();
			Skills.InitOnce();
			
			
			hudController = new HudController();
			hudController.InitOnce();
			gameState = gameState_UI;
			InitBitmaps();
			camera = new Camera();

			Grass.InitOnce();
	
			GameLayers.InitOnce();
	
			LevelDobjCache.InitOnce();
			
			
			LoadPhysMaterials();

			
			objectDefs = new PhysObjs();
			objectDefs.InitFromXml(ExternalData.xml);
			
			GameVars.InitOnce();
			Stats.InitOnce();
			
	
			if (PROJECT::useStage3D)
			{
			
				s3d.InitOnce(InitOnceA);
			}
			else
			{
				InitOnceA();
			}
			//InitGame();
		}

		static function InitOnceA()
		{
			if (PROJECT::useStage3D)
			{
			s3d.SetVisible(false);
			}
			InitGame();
		}
		

		static function InitBitmaps()
		{			
			
			if (PROJECT::useStage3D)
			{
			
//				polyScreenBD=new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0x0);
//				backgroundScreenBD=new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0x0);
//				scrollScreenBD=new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0x0);
//				scrollScreenTempBD=new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0x0);
//				copyScreenBD=new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0x0);
			}
			else
			{
			
				polyScreenBD=new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0x0);
				backgroundScreenBD=new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0x0);
				scrollScreenBD=new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0x0);
				scrollScreenTempBD=new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0x0);
				copyScreenBD=new BitmapData(Defs.displayarea_w,Defs.displayarea_h,true,0x0);
			}
			
			backDOF = new DisplayObjFrame();
			backDOF2 = new DisplayObjFrame();
			polyDOF = new DisplayObjFrame();


			fillScreenMC = new MovieClip();
			fillScreenMC.x = 0;
			fillScreenMC.y = 0;
			fillScreenMC1 = new MovieClip();
			fillScreenMC1.x = 0;
			fillScreenMC1.y = 0;			
		}

		public static function StartTitleScreen()
		{
			LicAds.RemovePreloaderStuff();
			gameState = gameState_UI;
			main.ClearStage();
			
			if (doWalkthrough)
			{
				Walkthrough.InitScreens();
				UI.StartTransitionImmediate("preparingscreen");
			}
			else
			{
				UI.StartTransitionImmediate("preparingscreen");
			}
		}

		
		// Game initialised when NEW GAME starts - might not be applicable for all games.
		// could be called from InitOnce() or from the UI to start a new game.
		public static function InitGame()
		{
			gameState = gameState_Play;
		
//			main.InitStageForGame();

			EngineDebug.debugMode = 0;
			numLives = 3;

			Levels.currentIndex = 0;			
			
			pause = true;
			
			GameVars.cash = 0;
			
			currentGameMusic = 0;
			
			Levels.LoadAll();
			Missions.InitOnce();
			WalkthroughRecordings.InitOnce();
			Achievements.InitOnce();

			
//			ShowLevelPlayerUsage();
			
//			LoadCarData();
		
			CustomCursor.InitOnce();
			
			Particles.Reset();
			MouseControl.Reset();
			Particles.Reset();
			GameObjects.ClearAll();
			
			HintPopups.InitOnce();
			
			ResetEverything();
			SaveData.Load();
			SubmitStats();

			Audio.PlayMusic("menus_music");
			
			ExternalData.RemoveXML();

			StartTitleScreen();


		}
		
		static function FindObjInInstances(l:Level, name:String):Boolean
		{
			for each(var inst:EdObj in l.instances)
			{
				if (inst.typeName == name) return true;
			}
			return false;
		}
	
		
		static function ReloadData()
		{
			ExternalData.Load(ReloadData_Done);
		}
		static function ReloadData_Done()
		{
//			LoadLevels();
		}
		
		
		
		static function Reload(_func:Function)
		{
			ExternalData.Load(_func);
		}
		
		
		
		static function GetPhysMaterialByName(name:String):PhysObj_Material
		{
			for each(var mat:PhysObj_Material in physMaterials)
			{
				if (mat.name == name) return mat;
			}
			Utils.traceerror("ERROR, missing physics material: " + name);
			return new PhysObj_Material();			
		}
		static function LoadPhysMaterials()
		{
			physMaterials = new Array();
			var i:int;
			var x:XML = ExternalData.MaterialsXML;
			
			for (i = 0; i < x.material.length(); i++)
			{
				var px:XML = x.material[i];
				var mat:PhysObj_Material = new PhysObj_Material();
				mat.FromXML(px);				
				physMaterials.push(mat);
			}			
			
		}
		
		
		static function AddGameObjectAt(objName:String, _x:Number, _y:Number, _rotDeg:Number, _scale:Number,instanceName:String = "", initParams:String = "",_id:String="",_xflip:Boolean=false):GameObj
		{
			var go:GameObj = null;
			var physobj:PhysObj = objectDefs.FindByName(objName);
			
			
			if (physobj.graphics.length != 0)
			{
				var graphic:PhysObj_Graphic = physobj.graphics[0];
				
				if (physobj.staticGameObj)
				{
					go = GameObjects.AddStaticObj(_x, _y, zsortoffset);
				}
				else
				{				
					go = GameObjects.AddObj(_x, _y, zsortoffset);
				}
				
				Utils.GetParams(initParams);			
				var layerZpos:Number = GameLayers.GetZPosByName(Utils.GetParamString("game_layer"));
				go.zpos = layerZpos+ zsortoffset;
				
				go.dobj = GraphicObjects.GetDisplayObjByName(graphic.graphicName);
				go.frame = graphic.frame;
				go.dir = Utils.DegToRad(_rotDeg);
				go.scale = _scale;
				go.initParams = initParams;
				go.id = _id;
				go.xflip = _xflip;
				
			}
			try
			{
				if (physobj.initFunctionName != "")
				{
					go.initFunctionVarString = physobj.initFunctionParameters;
					go[physobj.initFunctionName]();
				}
			}catch (err:Error)
			{
				Utils.print("init function doesn't exist: " + physobj.initFunctionName);
			}
			
			return go;
		}
		
		
		static function GetLineListByType(_type:int):Array
		{
			var list:Array = new Array();
			var l:Level = Levels.GetCurrent();
			for each (var line:EdLine in l.lines)
			{
				if (line.type == _type)
				{
					list.push(line);
				}
			}
			return list;
		}
		
		static function GetNumLinesByType(_type:int):int
		{
			var count:int = 0;
			var l:Level = Levels.GetCurrent();
			for each (var line:EdLine in l.lines)
			{
				if (line.type == _type)
				{
					count++;
				}
			}
			return count;
		}
		
		
		static function GetNearestPathLine(x:Number,y:Number):int
		{
			var nearestD:Number = 999999;
			var nearestL:int = 0;
			
			var count:int = 0;
			var l:Level = Levels.GetCurrent();
			for each (var line:EdLine in l.lines)
			{
				if (line.type == 1)
				{
					var d:Number = Utils.DistBetweenPoints(x, y, line.points[0].x, line.points[0].y);
					if (d < nearestD)
					{
						nearestD = d;
						nearestL = count;
					}
				}
				count++;
			}
			return nearestL;
		}		
		
		static function GetLineIndexByTypeIndex(_type:int, _typeIndex:int):int
		{
			var count:int = 0;
			var lcount:int = 0;
			var l:Level = Levels.GetCurrent();
			for each (var line:EdLine in l.lines)
			{
				if (line.type == _type)
				{
					if (count == _typeIndex)
					{
						return lcount;
					}
					count++;
				}
				lcount++;
			}
			return 0;
			
		}
		
		
		static function GetLineByIndex(_index:int):EdLine
		{
			var l:Level = Levels.GetCurrent();
			return l.lines[_index]; 
		}
		
		
		
		
		
		public static function NextLevel():void
		{
			Audio.StopAllSFX();
			Levels.IncrementLevel();
			RestartLevel();

		}
		public static function RestartLevel():void
		{
			UI.StartTransition("gamescreen");
			
//			Audio.StopAllSFX();
//			StopLevel();
//			StartLevel();
		}
		
		
		
		public static function InitLevelGameplay()
		{
		}
		
		
		
		static function scoreOverlay_EnterFrame(e:Event)
		{
			var mc:MovieClip = e.target as MovieClip;
			if (mc.currentFrame == mc.totalFrames)
			{
				mc.stop();
				mc.visible = false;
			}
		}
		
		
		static function UpdateLevel()
		{
		}
		
		
/*
		static function InitPhysicsGO(x:Number, y:Number,graphic:PhysObj_Graphic,_gid:int = 0,_frame:int = 0,_zpos:Number=0):int
		{
			var go:GameObj;
			
			_zpos += graphic.zoffset;
			
			if (graphic == null)
			{			
				go = GameObjects.AddObj(x*PhysicsBase.p2w, y*PhysicsBase.p2w, _zpos+zsortoffset);
				go.InitPhysicsObject(_gid, _frame,0,0,"",false);
			}
			else
			{
				if (graphic.goInitFuntion == "")
				{
					go = GameObjects.AddObj(x*PhysicsBase.p2w, y*PhysicsBase.p2w, _zpos+zsortoffset);
					go.InitPhysicsObject(_gid, _frame,graphic.offset.x,graphic.offset.y,graphic.goInitFuntionVarString,graphic.hasShadow);
				}
				else
				{
					go = GameObjects.AddObj(x*PhysicsBase.p2w, y*PhysicsBase.p2w, _zpos+zsortoffset);
					go.InitPhysicsObject(_gid, _frame,graphic.offset.x,graphic.offset.y,graphic.goInitFuntionVarString,graphic.hasShadow);	
					go.initFunctionVarString = graphic.goInitFuntionVarString;
					go[graphic.goInitFuntion]();
				}
			}
			lastGeneratedGameObj = go;
			return GameObjects.lastGenIndex;
		}
		*/
		
		
		

		
		
		
		public static function InitLevelState(s:int)
		{
			levelState = s;
			levelStateTimer = 0;
			if (levelState == levelState_LevelStart)
			{
				levelState = levelState_Play;
			}
			if (levelState == levelState_Complete)
			{
				if (recordWalkthrough)
				{
					WalkthroughRecordings.AddRecording(walkthroughRecording);
				}

				levelStateTimer = 0;

				// always called when you have crossed line
				DoEndLevelStuff();
			}
			if (levelState == levelState_EndScreen)
			{
				SaveData.Save();
				InitLevelState(levelState_Null);
				
				if (levelSuccessFlag == true)
				{
					UI.StartTransitionImmediate("levelcomplete");					
				}
				else
				{
					UI.StartTransitionImmediate("levelfailed");
				}
				
			}
			
						
			if (levelState == levelState_PlayerDead)
			{
				levelTimer = Defs.fps*1.5;
			}
			if (levelState == levelState_BonusSection)
			{
				levelTimer = Defs.fps*10;
			}
			if (levelState == levelState_Play)
			{
				levelStateTimer = 0;
			}
			if (levelState == levelState_Editor)
			{
 				PhysEditor.InitEditor(camera.x,camera.y);
				PhysEditor.currentLevel = Levels.currentIndex;
				
			}
		}
		
		
		static function LevelFailed()
		{
			InitLevelState(levelState_Null);
			UI.StartTransition("levelfailed");
		}
		
		
		
		public static function ResetEverything()
		{
			Levels.ClearAll();
			
			// can't do this in debug cos vars aren't loaded in until after this in debug
			var firstLevelIndex:int = 0;	
			if (usedebug == false)
			{
				firstLevelIndex = GameVars.GetReorderedLevelIndex(0);	
			}
			
			Levels.GetLevel(firstLevelIndex).available = true;
			Levels.GetLevel(firstLevelIndex).locked = false;
			Levels.GetLevel(firstLevelIndex).newlyAvailable = true;
			Levels.currentIndex = firstLevelIndex;
			Missions.ClearAll();
			CalculateScore();
			Stats.ResetStats();
			Achievements.ClearAll();
			GameVars.ResetEverything();
			HintPopups.ResetEverything();
			GameVars.cash = 0;
			GameVars.currentScore = 0;
			GameVars.newMatchIndex = 0;
			if (unlockEverything)
			{
				GameVars.cash = 100000;
			}
		}
		
		
		
		public static var killScore:int;
		public static var rating:int;
		public static var endLevelScore:int;
		public static var newMatchUnlocked:Boolean;
		public static var newCompletionLevelReached:Boolean;
		public static var newBestTime:Boolean;
		
		
		static function DoEndLevelStuff()
		{
			// always called whether you win or lose. Calculate which one it is here
			
			// GameVars.CalculateFinalPositions() has been called when player crossed line
			
			// GameVars.playerFinalPosition;
			
			if(levelSuccessFlag == false) return;
			
			var ml:MissionLevel = Missions.GetCurrentMissionLevel();
			ml.complete = true;
			ml.newlyAvailable = false;
			ml.played = true;
			
			if (GameVars.numLevelFlicks < ml.bestJumps)
			{
				ml.bestJumps = GameVars.numLevelFlicks;
			}
			var levelAward:int = 0;
			if (ml.bestJumps <= ml.medalJumps[1]) levelAward = 1;
			if (ml.bestJumps <= ml.medalJumps[0]) levelAward = 2;
			ml.result = levelAward;
			
			var nextMissionLevel:MissionLevel = Missions.GetNextMissionLevel();
			if (nextMissionLevel != null)
			{
				nextMissionLevel.available = true;
				nextMissionLevel.newlyAvailable = true;
			}
			
			
			
			var placeCash:int = GameVars.GetPlaceCash(GameVars.playerFinalPosition);
			trace("placeCash " + placeCash);
			GameVars.levelCash += placeCash;
			
			GameVars.levelScore = 1000;
			GameVars.currentScore += GameVars.levelScore;
			
			if (PROJECT::isGamePad)
			{
				if (full_version_unlocked == false)
				{
					GameVars.levelCash = 0;
				}
			}
			
			
			GameVars.cash += GameVars.levelCash;
			
			trace("LEVEL CASH " + GameVars.levelCash);
			
			
			var gotRequirement:Boolean = false;
			var passReq:int = GameVars.GetLevelPassRequirement(GameVars.currentOrderedLevelIndex);
			if (GameVars.playerFinalPosition <= passReq)
			{
				gotRequirement = true;
			}
			trace(" pos: " + GameVars.playerFinalPosition + "   req: " + passReq + "   passed :" + gotRequirement);
			
			var collectedAllCash:Boolean = false;
			if (GameVars.numCashPickups >= GameVars.totalCashPickups)
			{
				collectedAllCash = true;
			}

			
			if (PROJECT::isGamePad)
			{
				if (full_version_unlocked == false)
				{
					gotRequirement = false;
				}
			}
			
			
			var l:Level = Levels.GetCurrent();
			l.complete = true;
			l.newlyAvailable = false;
			
			var rating:int = 5 - GameVars.playerFinalPosition;
			
			if (GameVars.playerFinalPosition < l.bestPlace)
			{
				l.bestPlace = GameVars.playerFinalPosition;
			}
			
			if (rating > l.rating)
			{
				l.rating = rating;
			}

			if (collectedAllCash)
			{
				l.gotBonus = true;
			}
			
			if (GameVars.playerFinalTime < l.bestTime )
			{
				l.bestTime = GameVars.playerFinalTime;
				
			}
			
			
			newMatchUnlocked = false;
			levelJustUnlocked = false;

			if (gotRequirement)
			{
				var orderIndex:int = GameVars.GetReorderedLevelIndexInverse(Levels.currentIndex)
				if (orderIndex < Levels.list.length - 1)
				{
					orderIndex++;
					var l1index:int = GameVars.GetReorderedLevelIndex(orderIndex);
				
					var l1:Level = Levels.GetLevel(l1index);
					if (l1.available == false)
					{
						l1.newlyAvailable = true;
						levelJustUnlocked = true;
						
						if (orderIndex % 4 == 0)
						{
							if (orderIndex != 0)
							{
								newMatchUnlocked = true;
							}
						}
						
					}
					l1.available = true;
				}
			}
			
			
			
			CalculateScore();
			//CountPerfectLevels();
			
			SubmitStats();

			Stats.Test("Most Money In Bank", GameVars.cash);
			Stats.Test("Score", GameVars.currentScore);
			
			var count1:int = 0;
			var count2:int = 0;
			var count3:int = 0;
			for each(var l:Level in Levels.list)
			{
				if (l.complete)
				{
					if (l.bestPlace == 0) count1++;
					if (l.bestPlace <=2) count2++;
					if (l.gotBonus) count3++;
				}
			}
		
			
			Stats.Test("Wins",count1);
			Stats.Test("Top Threes",count2);
			Stats.Test("All Coin Levels",count3);
			
		}
		
		static function SubmitMinigameStats()
		{
//			Lic.Kongregate_SubmitStat(GameVars.numBonusKills, "minigame_kills");
//			Lic.Kongregate_SubmitStat(GameVars.numBonusBestKillStreak, "minigame_killstreak");
			
		}
		
		static function SubmitStats()
		{
			var l:Level;
			
//			var progress:Number = GameVars.GetLevelProgress();
//			var percent:int = Math.round(progress * 100);
			
//			Lic.Kongregate_SubmitStat(percent, "progress");

			if (GameVars.currentScore != 0)
			{
//				Leaderboards.SubmitScore(GameVars.currentScore, "");

				Lic.Kongregate_SubmitStat(GameVars.currentScore, "highscore");
			}
			
			/*
			var totalcoins:int = GameVars.GetTotalCoinsCollected();
			Lic.Kongregate_SubmitStat(totalcoins, "totalcoins");

			var totalcups:int = GameVars.GetNumTrophies();
			Lic.Kongregate_SubmitStat(totalcups, "totalcups");
			
			var numcomplete:int = 0;
			for each(var l:Level in Levels.list)
			{
				if (l.complete) numcomplete++;
			}
			Lic.Kongregate_SubmitStat(numcomplete, "numcomplete");
			
			// submitted on minigame screen.
			//Lic.Kongregate_SubmitStat(score, "minigamescore");
			*/
			
		}
		
		
		static function GetHighestScore():int
		{
			var bestScore:int = 0;
			for each(var l:Level in Levels.list)
			{
				if (l.bestScore > bestScore) bestScore = l.bestScore;
			}
			return bestScore;
		}
		
		static function GetNumLevelsUnlocked():int
		{
			var num:int = 0;
			for each(var l:Level in Levels.list)
			{
				if (l.available)
				{
					num++;
				}
			}
			return num;
		}
		
		
		
		public static var numGolds:int;
		public static function CalculateScore()
		{
		}
		
		public static function GetSwitchJointName(name:String):String
		{
			if (name == "") return "";
			var l:Level = Levels.GetCurrent();
			var jointList:Array = Levels.GetCurrentLevelJoints();
			
			var p:Point;
			var p1:Point;
			
			for each(var joint:EdJoint in jointList)
			{
				if (joint.type == EdJoint.Type_Switch)
				{
					if (joint.obj0Name == name) return joint.obj1Name;
					if (joint.obj1Name == name) return joint.obj0Name;
				}
			}
			return "";
		}
		
		
		public static function InitLevelPlayFromEditorObjects()
		{
			zsortoffset = 0;
			level_instances = Levels.GetCurrentLevelInstances();
			for each(var inst:EdObj in level_instances)
			{			
				InitLevelObject(inst);
			}		
		}
		
		public static function InitLevelObject(inst:EdObj)
		{
			var go:GameObj;
			var physobj:PhysObj = objectDefs.FindByName(inst.typeName);
			if (physobj.bodies.length == 0)
			{
				go = AddGameObjectAt(inst.typeName, inst.x, inst.y, inst.rot, inst.scale,inst.instanceName,inst.objParameters.ToString(),inst.id,inst.isXFlipped);
				zsortoffset += 0.01;					
			}
			else
			{
				go =PhysicsBase.AddPhysObjAt(inst.typeName, inst.x, inst.y, inst.rot, inst.scale,inst.instanceName,inst.objParameters.ToString(),inst.id,false,inst.isXFlipped);
				zsortoffset += 0.01;
			}
			go.originalLevelEdObj = inst;
			
		}
		
		
		
		
		
		
		static function GetMapData(x:int, y:int):int
		{
			var l:Level = Levels.GetCurrent();
			x /= l.mapCellW;
			y /= l.mapCellH;
			if (x < l.mapMinX || x > l.mapMaxX || y < l.mapMinY || y > l.mapMaxY)
			{
				return 0;
			}
			var w:int = (l.mapMaxX - l.mapMinX) + 1;
			x -= l.mapMinX;
			y -= l.mapMinY;
			return l.map[x + (y * w)];			
		}
		

		static var goBackground:GameObj;
		static var goPolyLayer:GameObj;

		
		// Called from UI screen when the level stops
		public static function StopLevel()
		{

			MouseControl.active = false;
			Utils.print("MouseControl deactivated");

			hudController.ExitForLevel();
			MultiTouchHandler.Exit();
			
			HintPopups.ExitForLevel();
			LevelDobjCache.ExitForLevel();
			Audio.StopAllSFX();
			gameState = gameState_UI;
			if (PROJECT::useStage3D)
			{
			s3d.SetVisible(false);
			}
		}
		
		
		static function SetOpponentTeam()
		{
			
			var teams:Array = new Array();
			for (var i:int = 0; i <= 8; i++)
			{
				if (i != GameVars.playerTeam) teams.push(i);
			}
			
			var l:int = Levels.currentIndex % 8;
			GameVars.opponentTeam = teams[l];
			
		}
		
		// Called from UI when the level starts.
		static var doingWalkthrough:Boolean;
		public static function StartLevel(_doingWalkthrough:Boolean = false):void 
		{
			doingWalkthrough = _doingWalkthrough;
			
			StartLevelA();
//			s3d.InitOnce(StartLevelA);
			var a:int = 0;
		}
		public static function StartLevelA():void 
		{
			System.gc()
			
			Mouse.cursor = MouseCursor.ARROW;

			MultiTouchHandler.Init();

			GameVars.firstTime = false;

			if (PROJECT::useStage3D)
			{
			s3d.SetVisible(true);
			}

			MouseControl.buttonReleased = false;
			MouseControl.buttonPressed = false;

			LevelDobjCache.InitForLevel();

			Grass.InitForLevel();
			
			//GameVars.useVector = true;
			gameState = gameState_Play;

			SetOpponentTeam();

//			InitLevelIntro();
			
			Mouse.show();
			var go:GameObj;
			
			KeyReader.InitOnce(main.stage);			

			
//			SoundPlayer.Reset();
			
			//InitBackgroundSounds();
			QuietAllSounds();
			

			GetLevelBoundingRectangle();
			
			textFrameOffset = 0;
			
//			main.InitStageForGame();
			var l:Level = Levels.GetCurrent();
			
			l.beenPlayed = true;
			l.newlyAvailable = false;

			
			Particles.Reset();
			PhysicsBase.Init();
			
			PhysicsBase.SetGravity(Vars.GetVarAsNumber("gravity"));
			
			camera.ResetBounds();

			GameVars.InitForLevel();
			
			GameObjects.ClearAll();

			InitLevelState(levelState_LevelStart);
			
			
			GameVars.stopwatch = 0;
			GameVars.bombTimer = Defs.fps * 10;
			GameVars.brakeLevel = 1;
			
			InitLevelPlayFromEditorObjects();
			PhysicsBase.InitLines();
			PhysicsBase.InitJoints();

			
//			FindRoutesInSwapZones();
			
			pause = false;
			pauseGameplayInput = false;
			
			scrollMode = 0;
			
			
			levelTimer = 0;
	
			levelScore = 0;

			hudController.InitForLevel();
			
	
//			InitBackgroundSounds();
//			QuietAllSounds();

//			InitSkids();

//			Audio.PlayMusic("menus_music");
	
			Audio.PlayMusic("music_ingame"+ int(currentGameMusic + 1) );
			
			currentGameMusic++;
			if (currentGameMusic >= 2) currentGameMusic = 0;
			


			
//			levelFunctions.Init(l.levelFunctionName);
			
			
			scoreMultiplier = 1;
			
			InitLevelGameplay();
			
//			currentBackground = Levels.currentIndex % GraphicObjects.GetDisplayObjByName("backgrounds").GetNumFrames();

//			var go:GameObj = GameObjects.AddObj(0, 0, 5000);
//			go.InitJointRenderer();
	
			InitScrollForLevel();

	// this should only be called from InitLevelINfo, a game object
	// but this is in case it isn't added to the level.
			InitBackground();

			goBackground = GameObjects.AddObj(0, 0, 15000);
			goBackground.InitBackground();
			
//			goCursor = GameObjects.AddObj(0, 0, 0);
//			goCursor.InitCursor();
			
			InitControl();
//			ShowHelpScreen();

//			StartBloodOverlay();
			
//			Grass.PreRenderLines();
//			var goGrass:GameObj = GameObjects.AddObj(0, 0, -10);
//			goGrass.InitGrass();
			
			
			StartLevelSounds();
			hudController.SetupMuteButtons();
			

			RenderBallPath_calcPositions_Init();
			
			InitScroll();
			
			createdForegroundBitmaps = false;
			
			Achievements.ResetForLevel();
			
			
			HintPopups.InitForLevel();
			
//			PreRenderPolys();
			
			CustomCursor.Use(true);
			
			MakeCombinedStaticsByTexturePage();
			
			
			
			GameVars.grassFrame = Levels.currentIndex % 4;
			GameVars.dirtFrame = Levels.currentIndex % 3;
			
			if (recordWalkthrough)
			{
				walkthroughRecording = new WalkthroughRecording(l.name);
			}
			if (playbackWalkthrough)
			{
				walkthroughRecording = WalkthroughRecordings.GetByLevelName(l.name);
				
				if (walkthroughRecording == null) 
				{
					playbackWalkthrough = false;
				}
				else
				{
					walkthroughRecording.StartPlayback();
				}
				walkthroughCursorGO = GameObjects.AddObj(0, 0, -10000);
				walkthroughCursorGO.InitPlaybackCursor();	
				
				
			}
			
			InitBallPathForLevel();
			
			
			
//			if (PROJECT::useStage3D)
//			{
				main.stage.addEventListener(MouseEvent.MOUSE_MOVE, MouseMoveHandler);
				main.stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseClickHandler);
				main.stage.addEventListener(MouseEvent.MOUSE_UP, MouseUpHandler);	
				mouseReleased = false;
				mouseDown = false;
//			}


			GameVars.InitForLevel_PostObjects();
			

			doKick = false;
			MouseControl.buttonReleased = false;
			MouseControl.buttonPressed = false;
			MouseControl.active = true;
			Utils.print("MouseControl activated");
		
			GameVars.raceTimer = 0;
			
			Missions.InitForLevel();
		}
		
		public static function InitBackground()
		{
			if (PROJECT::useStage3D)
			{
				backDOF = GraphicObjects.GetDisplayObjByName("background").GetFrame(currentBackground);
				//backDOF2 = GraphicObjects.GetDisplayObjByName("backgrounds_sky").GetFrame(currentBackground);

				m3d_backDOF = new Matrix3D();
				m3d_backDOF.appendScale( (Defs.displayarea_w/backDOF.sourceRect.width), (Defs.displayarea_h/backDOF.sourceRect.height), 1);

				//m3d_backDOF2 = new Matrix3D();
				//m3d_backDOF2.appendScale( (Defs.displayarea_w/backDOF2.sourceRect.width), (Defs.displayarea_h/backDOF2.sourceRect.height), 1);
				
				for (var i:int = 0; i < 10; i++)
				{
					UpdateScroll();
				}
				

			}
			else
			{
				
				if (backgroundsMC == null)
				{
					backgroundsMC = new background();
				}				
				backgroundsMC.gotoAndStop(currentBackground + 1);
				var r:Rectangle = backgroundsMC.getRect(null);
				
				if (backBD == null)
				{
					backBD = new BitmapData(1024,512, true,0);
//					backBD = new BitmapData(r.width,r.height, true,0);
				}
				
				var m:Matrix = new Matrix();
//				m.scale(backBD.width / r.width , backBD.height / r.height);	
				backBD.fillRect(backBD.rect, 0);
				backBD.draw(backgroundsMC);	// , m);
				backDOF.CreateStandalone(backBD, 0, 0,false);
				backDOF.ReUploadBitmap(backBD);


/*				
				if (backgroundsMC2 == null)
				{
					backgroundsMC2 = new backgrounds_sky();
				}
				backgroundsMC2.gotoAndStop(currentBackground + 1);
				var r:Rectangle = backgroundsMC2.getRect(null);
				if (backBD2 == null)
				{
					backBD2 = new BitmapData(1024,512, false, 0);
//					backBD2 = new BitmapData(r.width,r.height, true,0);
				}
				
				var m:Matrix = new Matrix();
//				m.scale(backBD2.width/r.width , backBD2.height/r.height);				
				backBD2.fillRect(backBD.rect, 0);
				backBD2.draw(backgroundsMC2);	// , m);
				
				
				backDOF2.CreateStandalone(backBD2, 0, 0);
				backDOF2.ReUploadBitmap(backBD2);
				
				*/
				
				for (var i:int = 0; i < 10; i++)
				{
					UpdateScroll();
				}
				
//				polyDOF.CreateStandalone(polyScreenBD, 0, 0);
//				polyDOF.ReUploadBitmap(polyScreenBD);

			}
			
		}
		
		static function InitLevelIntro()
		{
			GameVars.doingLevelIntro = true;
			GameVars.levelIntroTimer = 0;
			GameVars.levelIntroTimerMax = 0.3 * Defs.fps;	// comes from xml varsdata
			
		}
		static function UpdateLevelIntro()
		{
			if (GameVars.doingLevelIntro)
			{
				GameVars.levelIntroTimer++;
				if (GameVars.levelIntroTimer >= GameVars.levelIntroTimerMax)
				{
					GameVars.doingLevelIntro = false;
				}
			}
			
		}
		
		static var m3d_backDOF:Matrix3D = new Matrix3D();
		static var m3d_backDOF2:Matrix3D = new Matrix3D();
		public static var walkthroughCursorGO:GameObj;
		public static var walkthroughRecording:WalkthroughRecording;
		
		static var backgroundsMC:MovieClip = null;
		static var backgroundsMC2:MovieClip = null;
		
		
		
		
		static function PreRenderPolys()
		{
			camera.x = 0;
			camera.y = 0;
			camera.scale = 1;
			
			polyScreenBD.fillRect(Defs.screenRect, 0);
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active)
				{
					if (go.preRenderFunction != null)
					{
						go.bd = polyScreenBD;
						go.preRenderFunction();
					}
				}
			}
			
		}
		
		static function InitBackgroundSounds()
		{

	
//			_mp3 = SoundPlayer.GetSoundByName("sfx_car_02");
//			_mp3.addEventListener(Event.COMPLETE, complete);
			
//			SoundPlayer.Reset();
//			SoundPlayer.Play("sfx_car_02", 0, 999999, "engine");	// , engineSampleCallback);
//			SoundPlayer.Play("sfx_skid", 0, 999999,"skid");
//			SoundPlayer.Play("sfx_bridge", 0, 999999,"bridge");

//			poo = new MP3Pitch(null);

		}
		
		static function QuietAllSounds()
		{
		}		
		
		
		static function StopAllLoops()
		{
			
		}
		
		
		static function StartLevelSounds()
		{
		}
		
		
		
//------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------

		public static var currentWalkthroughRecordingPoint:WalkthroughRecordingPoint = null;
		public static var testTextureFrame:int = 0;
		
		public static function UpdateGameplay():void 
		{			
			EngineDebug.StartTimers();
			
			var numLoops:int = 1;
			
//			if (KeyReader.Pressed(KeyReader.KEY_F5))
//			{
//				usedebug = (usedebug == false);
//			}
			
			if (KeyReader.Pressed(KeyReader.KEY_U))
			{
				LicCoolmath.UnlockAllLevels();
			}
			
			if (GameVars.doingFastForward) 
			{
				numLoops = GameVars.fastForward_numskips;
			}
			for (var loopCount:int = 0; loopCount < numLoops; loopCount++)
			{
			
			if (gameState == gameState_UI) 
			{
				if (levelState == levelState_Editor)
				{
					PhysEditor.UpdateEditor();
					return;
				}
				else
				{
					if (usedebug)
					{
						if (KeyReader.Pressed(KeyReader.KEY_R)) 	// restart current screen
						{
							UI.currentScreen.Restart();
						}
						if (KeyReader.Pressed(KeyReader.KEY_SPACE)) 
						{
							UI.currentScreen.pageInst.Stop();
							
							Mouse.cursor = MouseCursor.AUTO;
							InitLevelState(levelState_Editor);
							var index:int = UIX.GetPageIndexByName( UI.currentScreen.uix_pageName);
							PhysEditor.SetEditMode(PhysEditor.editMode_UI);
							PhysEditor.editModeObj_UI.currentPageIndex = index;
						}
					}
					
				}				
				return;
			}
			
			
			if (usedebug)
			{
				if (levelState != levelState_Editor)
				{
					
					if (KeyReader.Pressed(KeyReader.KEY_C)) 
					{
						if (BikeEditor.active == false)
						{
							BikeEditor.Start();
						}
						else
						{
							BikeEditor.Stop();
						}
						return;
					}
					
					if (BikeEditor.active)
					{
						BikeEditor.Update();
						return;
					}
				}
			}
			
			if (gameState == gameState_Walkthrough) 
			{
				if (usedebug)
				{
					if (KeyReader.Pressed(KeyReader.KEY_W))
					{
						gameState = gameState_Play;
						doWalkthrough = false;
						UI.StartTransition("gamescreen");
						return;
					}
				}
				
				UpdateScroll_Walkthrough();
				GameObjects.UpdateWalkthroughObjects();
				
				return;
			}

			if (pause) return;

			if (usedebug)
			{
				if (KeyReader.Pressed(KeyReader.KEY_V))
				{
					Vars.ReloadXML();
					Vars.TraceAll();
				}
			}
			
			if (PauseMenu.IsPaused()) 
			{
				return;
			}
			if (levelState == levelState_EndScreen) return;
			if (levelState == levelState_Null) return;
			if (levelState == levelState_Editor)
			{
				PhysEditor.UpdateEditor();
				return;
			}
			
			
			if (usedebug)
			{
				
				/*
				if (KeyReader.Pressed(KeyReader.KEY_W))
				{
					KeyReader.ClearKey(KeyReader.KEY_W);
					gameState = gameState_UI;
					doWalkthrough = true;
					Walkthrough.InitScreen();
					gameState = gameState_UI;

					UI.StartTransition("walkthrough_screen");
					gameState = gameState_UI;
					return;
				}
				*/
				
				if (KeyReader.Pressed(KeyReader.KEY_F))
				{
					//Game.levelSuccessFlag = true;
					//Game.InitLevelState(Game.levelState_Complete);
					
				}
				if (KeyReader.Pressed(KeyReader.KEY_S))
				{
					//Screenshot.Level_Dump();
				}
				if (KeyReader.Pressed(KeyReader.KEY_SPACE)) 
				{
					Mouse.cursor = MouseCursor.AUTO;
					InitLevelState(levelState_Editor);
					hudController.Stop();
				}
				
			}			

			
			var numUpdates:int = 1;
			
			if (KeyReader.Pressed(KeyReader.KEY_1)) GameVars.render1 = (GameVars.render1 == false);
			if (KeyReader.Pressed(KeyReader.KEY_2)) GameVars.render2 = (GameVars.render2 == false);
			if (KeyReader.Pressed(KeyReader.KEY_3)) GameVars.render3 = (GameVars.render3 == false);
			if (KeyReader.Pressed(KeyReader.KEY_4)) GameVars.render4 = (GameVars.render4 == false);
			
			if (usedebug)
			{
				if (KeyReader.Pressed(KeyReader.KEY_1)) 
				{
					EngineDebug.debugMode ^= 1;
				}
				if (KeyReader.Pressed(KeyReader.KEY_2)) 
				{
					EngineDebug.debugMode ^= 2;
				}
				if (KeyReader.Pressed(KeyReader.KEY_3)) 
				{
					EngineDebug.debugMode ^= 4;
				}
				if (KeyReader.Pressed(KeyReader.KEY_4)) 
				{
					EngineDebug.debugMode ^= 8;
				}

				if (KeyReader.Pressed(KeyReader.KEY_6))
				{
					GameVars.playerBikeDefIndex++;
					if (GameVars.playerBikeDefIndex >= BikeDefs.list.length) GameVars.playerBikeDefIndex = 0;
					RestartLevel();
				}

				if (KeyReader.Pressed(KeyReader.KEY_7))
				{
					RestartLevel();
				}
				if (KeyReader.Pressed(KeyReader.KEY_8))
				{
					Levels.DecrementLevel();
					RestartLevel();
				}
				if (KeyReader.Pressed(KeyReader.KEY_9))
				{
					NextLevel();
				}

			}

			
			if (levelState == levelState_Play)
			{
				
				if (levelStateTimer == 1)
				{
//					if (Game.currentLevel == 0)
//					{
//						UI.InitHelp();
//						pause = true;
//					}
				}
				levelStateTimer++;
			}
			if (levelState == levelState_LevelStart)
			{
			}
			
			
			
//			physObjInstances.PreUpdatePhysObjs();


			if (levelState == levelState_Play || levelState == levelState_BonusSection) 
			{
				if (playbackWalkthrough)
				{
					if (walkthroughRecording)
					{
						var wpos:WalkthroughRecordingPoint = walkthroughRecording.GetNextPoint();
						currentWalkthroughRecordingPoint = wpos.Clone();
						MouseControl.x = wpos.x;
						MouseControl.y = wpos.y;
						MouseControl.buttonPressed = wpos.mouseButton;
						walkthroughCursorGO.xpos = wpos.x;
						walkthroughCursorGO.ypos = wpos.y;
						
						if (wpos.mouseButton)
						{
							var go:GameObj = GameObjects.AddObj(wpos.x, wpos.y, -11000);
							go.InitPlaybackClick();	
							
						}
						
					}
				}
			
				UpdateControl();
			}
			
			
			if (recordWalkthrough)
			{
				if (walkthroughRecording)
				{
					walkthroughRecording.Add(MouseControl.x, MouseControl.y, buttonClickedThisUpdate);
				}
			}
			
			

			GameObjects.PreUpdateGOsBeforePhysics();				
			PhysicsBase.TimeStep();
			GameObjects.UpdateGOsFromPhysics_Nape();				

			GameVars.UpdateForFrame();
			if (levelState == levelState_Play || levelState == levelState_LevelStart || levelState == levelState_Complete || levelState == levelState_BonusSection || levelState == levelState_BonusSectionStart) 
			{
				Stats.Add("Total Time Played", 1);

				GameObjects.ClearAddList();				
				GameObjects.Update();
				GameObjects.KillObjects();				
				GameObjects.DoAddList();
				Particles.Update();
				hudController.Update();
				
				GameVars.raceTimer++;
			}
				
			UpdateLevelIntro();		
			GameVars.UpdatePlayerPosition();

			
			if (levelState == levelState_Play)
			{
				Missions.Update();
				levelTimer++;			
				
				GameVars.stopwatch++;
				GameVars.bombTimer--;
				
				
				
				
				if (Game.usedebug)
				{
					if (KeyReader.Pressed(KeyReader.KEY_F))
					{
						GameVars.reachedExit = true;
					}
				}	
				
				
				if ( GameVars.playerGO != null)
				{
					if (GameVars.reachedExit)
					{
//						GameVars.playerGO.PlayerCrossedLine();
//						GameVars.crossedLine = true;
						levelSuccessFlag = true;			
						
						
						InitLevelState(levelState_Complete);
					}
				}
					
				
//					Achievements.TestAll();
//					if (Achievements.UpdateDisplayQueue() == false)
//					{
//	//					HintPopups.UpdateDisplayQueue();
//					}
				}


				if (levelState == levelState_Complete)
				{
//					Achievements.TestAll();
					

					var stillUpdating:Boolean = false;	// Achievements.UpdateDisplayQueue();

					levelStateTimer++;
					var time:int = Defs.fps * 3;
	//				if (levelSuccessFlag == false) time = 0;
					
					if (levelStateTimer > time && stillUpdating==false)
					{
						InitLevelState(levelState_EndScreen);
					}
				}
				
				if (levelState == levelState_PlayerDead)
				{
				}

				

				
				UpdateScroll();

				if (playbackWalkthrough)
				{
					if (walkthroughRecording)
					{						
						if (walkthroughRecording.HasFinished())
						{
							var w:WalkthroughScreen = Walkthrough.walkthroughScreens[Levels.currentIndex];
							w.StopPlayback();
							UI.StartTransition("walkthrough");
						}
					}
				}					
			
			}
		}
		
		
		static function InitCreateForegroundBitmaps()		// once
		{
		}
		
		static var createdForegroundBitmaps:Boolean = false;
		static var scrollFirstTime:Boolean;
		static function InitScroll()
		{
			scrollFirstTime = true;
		}

		
		static function UpdateScroll_Garage()
		{
			var go:GameObj = GameObjects.GetGameObjByName("player");			
			if (go == null) return;
			
			camera.x = go.xpos - Defs.displayarea_w/2;
			camera.y = go.ypos - Defs.displayarea_w/2;
		}
		
		
		static var scrollMode:int = 0;	// nothing
		static var scrollDragX:Number;
		static var scrollDragY:Number;
		static var doKick:Boolean = false;
		
		static var mouse_ox:Number = 0;
		static var mouse_oy:Number = 0;
		static var mouse_x:Number = 0;
		static var mouse_y:Number = 0;
		static var mouse_dx:Number = 0;
		static var mouse_dy:Number = 0;
		
		public static function MouseMoveHandler(event:MouseEvent):void 
		{		
			var go:GameObj = GameVars.footballGO;
			if (go == null) return;

			var scalex:Number = ScreenSize.fullScreenScale;
			var scaley:Number =  ScreenSize.fullScreenScale;
			
			var mx:Number;
			var my:Number;

			mouse_ox = mouse_x;
			mouse_oy = mouse_y;
			
			mx = Utils.ScaleToPreLimit(0, Defs.displayarea_w, ScreenSize.fullScreenScaleXOffset, ScreenSize.gameStageWidth - ScreenSize.fullScreenScaleXOffset, event.stageX);
			my = Utils.ScaleToPreLimit(0, Defs.displayarea_h, 0, ScreenSize.gameStageHeight, event.stageY);
			
			mouse_dx = mx - mouse_ox;
			mouse_dy = my - mouse_oy;
			mouse_x = mx;
			mouse_y = my
			
			var cx:Number = Defs.displayarea_w / 2;
			var cy:Number = Defs.displayarea_h / 2;
			
			return;
			
			Utils.print("scrollMode: "+scrollMode+"   controlMode "+controlMode);
			
			if (controlMode == 1)
			{
				if (scrollMode == 0)
				{
					
				}
				else if (scrollMode == 1)		// drag screen
				{
					camera.x -= mouse_dx;
					camera.y -= mouse_dy;
					Utils.print("mouse_dx " + mouse_dx+ "   "+mx);
					Utils.print("mouse_dy " + mouse_dy+ "   "+my);
					
				}
				else if (scrollMode == 2)
				{
				//absolute position from centre
					var scaler:Number = 0.4;
					var dx:Number = cx - mouse_x;
					var dy:Number = cy - mouse_y;
					camera.x = (go.xpos + (dx * scaler)) -cx;
					camera.y = (go.ypos +( dy * scaler)) -cy;
				}

//				if (camera.x < boundingRectangle.x) camera.x = boundingRectangle.x;
//				if (camera.y < boundingRectangle.y) camera.y = boundingRectangle.y;
				
//				if (camera.x+Defs.displayarea_w > boundingRectangle.right) camera.x = boundingRectangle.right-Defs.displayarea_w;
//				if (camera.y + Defs.displayarea_h > boundingRectangle.bottom) camera.y = boundingRectangle.bottom-Defs.displayarea_h;
				
				/*
				if (camera.x < boundingRectangle.x) 
				{
					camera.x = boundingRectangle.x;
				}
				if (camera.y < boundingRectangle.y) 
				{
					camera.y = boundingRectangle.y;
				}
				
				if (camera.x + Defs.displayarea_w > boundingRectangle.right) 
				{
					camera.x = boundingRectangle.right-Defs.displayarea_w;
				}
				if (camera.y + Defs.displayarea_h > boundingRectangle.bottom) 
				{
					camera.y = boundingRectangle.bottom-Defs.displayarea_h;
				}
				*/
				
			}
		}

		
		static var mouseDown:Boolean = false;
		static var mouseReleased:Boolean = false;
		public static function MouseClickHandler(event:MouseEvent):void 
		{
			mouseDown = true;
			return;
		}
		
		
		public static function MouseUpHandler(event:MouseEvent):void 
		{
			if (mouseDown)
			{
				mouseReleased = true;
			}
			mouseDown = false;
			return;
		}

		
		
		static function UpdateScroll_Walkthrough()
		{
			mouse_x = MouseControl.x;
			mouse_y = MouseControl.y;
			var v:Vec = new Vec();
			v.SetFromDxDy(mouse_x - Defs.displayarea_w2, mouse_y - Defs.displayarea_h2);
			v.speed *= 0.04;
			camera.x += v.X();
			camera.y += v.Y();

			if (camera.x < boundingRectangle.x) camera.x = boundingRectangle.x;
			if (camera.y < boundingRectangle.y) camera.y = boundingRectangle.y;
			
			if (camera.x+Defs.displayarea_w > boundingRectangle.right) camera.x = boundingRectangle.right-Defs.displayarea_w;
			if (camera.y + Defs.displayarea_h > boundingRectangle.bottom) camera.y = boundingRectangle.bottom-Defs.displayarea_h;
			
		}
		
		
		static function InitScrollForLevel()
		{
			if ( GameVars.playerGO == null) return;
			GameVars.levelIntroTimer = 0;
			GameVars.levelIntroTimerMax = Vars.GetVarAsNumber("camera_intro_time") * Defs.fps;

			if (usedebug == false)
			{
				GameVars.doingLevelIntro = true;
			}
			
			var go:GameObj = GameVars.playerGO;
			camera.x = camera.toX = go.xpos;
			camera.y = camera.toY = go.ypos;
			camera.scale = 1;
			camera_offset_x = 0;
			InitSteadyCameraForLevel();
			InitShakeCamForLevel();
		}
		
		static var camera_offset_x:Number;
		
		
		static function GetLevelBoundingRectangle()
		{
			boundingRectangle = new Rectangle( -10000, -10000, 20000, 20000);
			var l:EdLine = Levels.GetCurrent().GetLineByMaterial("poly_scrollarea");
			if (l == null) return;
			l.CalcBoundingRectangle();
			boundingRectangle.copyFrom(l.boundingRectangle);
		}
		
		static var cameraDragZoom:Number=0;
		
		static function UpdateScroll()
		{
			var go:GameObj = GameVars.playerGO;
			if (go == null) return;
			
			
			
			var vel:Number = 0;
			if (go.nape_bodies != null)
			{
				vel = go.GetBodyLinearVelocity(0).length;
			}			
			
			var camToZ:Number = 0;	// Utils.ScaleTo(0, -100, 0, 600, Math.abs(vel));
			
			if (go.state == GameObj.NINJASTATE_DRAGGING)			
			{
				camToZ = Utils.ScaleToPreLimit(0, -50, 200, 480,go. ballLaunch_vec.speed);
			}
			if (go.state == GameObj.NINJASTATE_FLYING)			
			{
				camToZ = Utils.ScaleToPreLimit(0, -50, 200, 480,go. ballLaunch_vec.speed);
			}
			
			
			
			var czv:Number = 10;	// Math.abs(camToZ - camera.z) * 0.05;
			if (go.state == GameObj.NINJASTATE_LOOKAROUND)
			{
				camToZ = -cameraDragZoom;
				camToZ = Utils.LimitNumber( -100, 0, camToZ);
				czv = 8;
			}
			
			//camToZ = 0;
			
			/*
			if (camera.z < camToZ)
			{
				camera.z += czv;
				if (camera.z > camToZ) camera.z = camToZ;
			}
			else
			{
				camera.z -= czv;
				if (camera.z < camToZ) camera.z = camToZ;
				
			}
			*/
			
			camera.z += (camToZ - camera.z) * Vars.GetVarAsNumber("camzoom_modifier");
			
			camera.x = go.xpos - (Defs.displayarea_w / 2);
			camera.y = go.ypos - (Defs.displayarea_h / 2);

			
			camera.x += shakeCamX;
			camera.y += shakeCamY;

			UpdateShakeCam();
			camera.x += shakeX;
			camera.y += shakeY;
			
			if (camera.x < boundingRectangle.x) camera.x = boundingRectangle.x;
			if (camera.y < boundingRectangle.y) camera.y = boundingRectangle.y;
			
			if (camera.x+Defs.displayarea_w > boundingRectangle.right) camera.x = boundingRectangle.right-Defs.displayarea_w;
			if (camera.y + Defs.displayarea_h > boundingRectangle.bottom) camera.y = boundingRectangle.bottom-Defs.displayarea_h;
			
			
		}
		static function UpdateScrollOld1()
		{			
			
			if ( GameVars.playerGO == null) return;
			var go:GameObj = GameVars.playerGO;
			
			
			
			if (go == null) return;
			
			if (go.state == GameObj.NINJASTATE_LOOKAROUND) return;
			
			var l:Level = Levels.GetCurrent();
			
			var camera_offset_tox:Number = Vars.GetVarAsNumber("camera_offset_x");
			var camera_offset_y:Number = Vars.GetVarAsNumber("camera_offset_y");
			var camera_base_offset_y:Number = Vars.GetVarAsNumber("camera_base_offset_y");
			
			
			var vel:Number = 0;
			var xvel:Number = 0;
			if (go.nape_bodies != null)
			{
				xvel = go.GetBodyLinearVelocity(0).x;
				vel = go.GetBodyLinearVelocity(0).length;
			}
			camera_offset_tox = Utils.ScaleToPreLimit( camera_offset_tox-40, camera_offset_tox, 0, 600, xvel);
			

			var camToZ:Number = Utils.ScaleTo(0, -200, 0, 600, Math.abs(vel));
			var czv:Number = 1;
			if (camera.z < camToZ)
			{
				camera.z += czv;
				if (camera.z > camToZ) camera.z = camToZ;
			}
			else
			{
				camera.z -= czv;
				if (camera.z < camToZ) camera.z = camToZ;
				
			}
			
			camera_offset_x += (camera_offset_tox - camera_offset_x) * 0.1;
			
			
			if (BikeEditor.active)
			{
				
				camera.x = go.xpos - (Defs.displayarea_w / 2);
				camera.y = go.ypos - (Defs.displayarea_h / 2);
				camera.scale = 1;
				return;
			}
			
			camera.x = go.xpos - (Defs.displayarea_w / 2);
			camera.toY = go.ypos - (Defs.displayarea_h / 2);

			if (GameVars.cameraFixedPointActive)
			{
				camera.x = GameVars.cameraFixedPointX - (Defs.displayarea_w / 2);
				camera.toY = GameVars.cameraFixedPointY - (Defs.displayarea_h / 2);
			}

			var yvel:Number = GameVars.playerGO.GetBodyLinearVelocity(0).y;
			if (levelState == levelState_Complete)
			{
				yvel = 0;
			}

			var yoff:Number = Utils.ScaleToPreLimit( camera_offset_y, -camera_offset_y, -500, 500, yvel);
			
			camera.x += camera_offset_x;
			camera.toY += yoff;
			camera.toY += camera_base_offset_y;
			camera.y += (camera.toY-camera.y) * 0.2;
			
	
			var vel:Number = GameVars.playerGO.GetBodyLinearVelocity(0).length;
			
			if (levelState == levelState_Complete)
			{
				vel = 0;
			}
			
			UpdateSteadyCam(vel);
			
			
			camera.x += shakeCamX;
			camera.y += shakeCamY;

			UpdateShakeCam();
			camera.x += shakeX;
			camera.y += shakeY;
			
			if (camera.x < boundingRectangle.x) camera.x = boundingRectangle.x;
			if (camera.y < boundingRectangle.y) camera.y = boundingRectangle.y;
			
			if (camera.x+Defs.displayarea_w > boundingRectangle.right) camera.x = boundingRectangle.right-Defs.displayarea_w;
			if (camera.y + Defs.displayarea_h > boundingRectangle.bottom) camera.y = boundingRectangle.bottom-Defs.displayarea_h;
			
			
			return;
					
		}
		static var shakeX:Number = 0;
		static var shakeY:Number = 0;
		static var shakeTimer:int = 0;
		static var shakeTimerMax:int = 0;
		static function UpdateShakeCam()
		{
			shakeX = 0;
			shakeY = 0;
			shakeTimer --;
			if (shakeTimer <= 0) 
			{
				shakeTimer = 0;
				return;
			}
			
			var max:Number = Utils.ScaleTo(0, 10, 0, shakeTimerMax, shakeTimer);
			
			shakeX = Utils.RandBetweenFloat(-max,max);
			shakeY = Utils.RandBetweenFloat(-max,max);
		}

		public static function InitShakeCamForLevel()
		{
			shakeX = 0;
			shakeY = 0;
			shakeTimer = 0;
			shakeTimerMax = 0;
		}
		public static function StartShake(val:Number)
		{
			shakeTimerMax = shakeTimer = int(Utils.ScaleTo(0, 50, 0, 1, val));
		}
		
		static function InitSteadyCameraForLevel()
		{
			shakeCamToX = shakeCamToY = 0;
			shakeCamX = shakeCamX = 0;
			shakeCamDX = shakeCamDX = 0;
			shakeCamTimer = 0;
			shakeCamTimerMax = 0;
		}
		static var shakeCamToX:Number = 0;
		static var shakeCamToY:Number = 0;
		static var shakeCamX:Number = 0;
		static var shakeCamY:Number = 0;
		static var shakeCamDX:Number = 0;
		static var shakeCamDY:Number = 0;
		static var shakeCamTimer:int = 50;
		static var shakeCamTimerMax:int = 50;
		static function UpdateSteadyCam(speed:Number):void 
		{
			shakeCamTimer--;
			if (shakeCamTimer <= 0)
			{
				shakeCamTimer = Utils.RandBetweenInt(20,40);
				shakeCamTimerMax = shakeCamTimer;
				
				
				var dist:Number = Utils.ScaleToPreLimit(1,5, 0, 500, speed);

				shakeCamToX = Utils.RandBetweenFloat( -dist,dist);
				shakeCamToY = Utils.RandBetweenFloat( -dist,dist);
				
				shakeCamDX = (shakeCamToX - shakeCamX) / shakeCamTimer;
				shakeCamDY = (shakeCamToY - shakeCamY) / shakeCamTimer;
				
			}
			shakeCamX += shakeCamDX;	// (shakeCamToX - shakeCamX) * 0.1;
			shakeCamY += shakeCamDY;	// (shakeCamToY - shakeCamY) * 0.1;
		}

//------------------------------------------------------------------
		
		static function UpdateScrollOld()
		{			
			var go:GameObj = GameVars.playerGO;
			
			if (scrollMode == 1)
			{
				go = GameVars.manGO;
			}
			
			if (go == null) return;
			camera.x = go.xpos - (Defs.displayarea_w / 4);
			camera.y = go.ypos - (Defs.displayarea_h / 2);
			return;
			
			var go:GameObj = GameVars.footballGO;
			if (go == null) return;
			
			mouse_x = MouseControl.x;
			mouse_y = MouseControl.y;

			
			var p:Point = new Point(go.xpos, go.ypos);
			
			var c:Number = 0.1;
			var w2:Number = Defs.displayarea_w / 2;
			var h2:Number = Defs.displayarea_h / 2;
			
			if (scrollFirstTime)
			{
				scrollFirstTime = false;
				c = 1;
			}
			
//			if (MouseControl.buttonPressed)
//			{
//				doKick = true;
//				MouseControl.buttonPressed = false;				
//			}
			
			if (go.state == 1)	// waiting to be launched
			{
				var mx:Number = MouseControl.x;
				var my:Number = MouseControl.y;
				
				var tox:Number = (((mx - w2) * 0.5) + p.x) - w2;
				var toy:Number = (((my - h2) * 0.5) + p.y) - h2;
				camera.x += (tox - camera.x) * c;
				camera.y += (toy - camera.y) * c;
				
			}
			else
			{
			camera.x += (p.x-w2 - camera.x) * c;
			camera.y += (p.y-h2 - camera.y) * c;
				
			}
			
			
			if (camera.x < boundingRectangle.x) camera.x = boundingRectangle.x;
			if (camera.y < boundingRectangle.y) camera.y = boundingRectangle.y;
			
			if (camera.x+Defs.displayarea_w > boundingRectangle.right) camera.x = boundingRectangle.right-Defs.displayarea_w;
			if (camera.y + Defs.displayarea_h > boundingRectangle.bottom) camera.y = boundingRectangle.bottom-Defs.displayarea_h;
			

			return;
			
			if (scrollMode == 0)
			{
				var go:GameObj = GameVars.footballGO;
				if (go == null) return;
				camera.x = go.xpos - (Defs.displayarea_w / 2);
				camera.y = go.ypos - (Defs.displayarea_h / 2);
				return;
				
			}
			return;
			
			var go:GameObj = GameVars.footballGO;
			if (go == null) return;
			
			if (controlMode == 0)
			{
				camera.x = go.xpos - (Defs.displayarea_w / 2);
				camera.y = go.ypos - (Defs.displayarea_h / 2);
				return;
				
			}
			
			var cx:Number = Defs.displayarea_w / 2;
			var cy:Number = Defs.displayarea_h / 2;
			
			if (scrollMode == 0)
			{
				doKick = false;
				if (MouseControl.buttonPressed)
				{
					if (Utils.DistBetweenPoints(MouseControl.x+camera.x,MouseControl.y+camera.y,go.xpos,go.ypos) < 50) // is ball
					{
						scrollMode = 2;	// start drag from ball
					}
					else
					{
						
						scrollMode = 1;	// start drag
						scrollDragX = 0;
						scrollDragY = 0;
						MouseControl.dx = 0;
						MouseControl.dy = 0;
					}
				}
			}
			else if (scrollMode == 1)		// drag
			{
				camera.x -= MouseControl.dx;
				camera.y -= MouseControl.dy;
				scrollDragX = MouseControl.x;
				scrollDragY = MouseControl.y;
				MouseControl.dx = 0;
				MouseControl.dy = 0;
				if (MouseControl.buttonPressed == false)
				{
					scrollMode = 0;
				}
			}
			else if (scrollMode == 2)		// dragging cursor
			{
				//absolute position from centre
				var dx:Number = cx - MouseControl.x;
				var dy:Number = cy - MouseControl.y;
				var scaler:Number = 0.8;
				camera.x = (go.xpos + (dx * scaler)) -cx;
				camera.y = (go.ypos +( dy * scaler)) -cy;
				if (MouseControl.buttonPressed == false)
				{
					scrollMode = 0;
					doKick = true;
				}
			}
			

			return;
			var mx:Number = MouseControl.x;
			var my:Number = MouseControl.y;
			
			var screenw:Number = 800;
			var screenh:Number = 700;
			
			var diffx:Number = screenw - Defs.displayarea_w;
			var diffy:Number = screenh - Defs.displayarea_h;
			
			var offx:Number = Utils.ScaleTo(0, diffx, 0, Defs.displayarea_w, mx);
			var offy:Number = Utils.ScaleTo(0, diffy, 0, Defs.displayarea_h, my);
			
			camera.x = offx;
			camera.y = offy;
			
			return;
			
			
			var go:GameObj = GameObjects.GetGameObjByName("player");
			
			if (go == null) return;
			if (Game.levelState == Game.levelState_Complete) return;

			
			camera.oldX = camera.x;
			camera.oldY = camera.y;
			
			//if (stopScroll) return;
			
			var playerPos:Point = new Point(go.xpos, go.ypos);
		
			var dx:Number;
			var dy:Number;
			
			var xoff:Number = Defs.displayarea_w/2;
			var yoff:Number = Defs.displayarea_h/2;
			var linv:Vec2 = go.GetBodyLinearVelocity(0);
			
			var ang:Number = Math.atan2(linv.y, linv.x);
			var speed:Number = linv.length;
			
			if (false)	//speed < 1)
			{
				dx = 0;
				dy = 0;
			}
			else
			{
				speed = Utils.LimitNumber(0, 30, speed);				
				var dist:Number = Utils.ScaleTo(100, 250, 0, 30, speed);
				dx = Math.cos(ang) * dist;
				dy = Math.sin(ang) * dist;
				
				dx = dist;
				dy = 0;
				
			}			
			
			
			camera.toX = (playerPos.x-xoff) +dx;
			camera.toY = (playerPos.y - yoff) +dy;
			
			UpdateShake();
			
			camera.toY += shakeX;
			camera.toY += shakeY;
			
			var a:Number = (camera.toX - camera.x);
			var b:Number = (camera.toY - camera.y);
			
			camera.x += (camera.toX - camera.x) * 0.3;
			camera.y += (camera.toY - camera.y) * 0.3;
			
			camera.x = Math.round(camera.x);
			camera.y = Math.round(camera.y);
			
		}
		
		
		public static function GetRankString(pc:Number):String
		{
			pc *= 0.01;
			
			if (pc <= 0.2) return "E";
			if (pc <= 0.4) return "D";
			if (pc <= 0.6) return "C";
			if (pc <= 0.8) return "B";
			if (pc <= 0.9) return "A";
			if (pc <= 0.95) return "AA";
			if (pc >= 1.0) return "AAA";
			return "POO";
		}
		
		public static function GetRankIndex(pc:Number):int
		{
			pc *= 0.01;
			
			if (pc <= 0.2) return 0;
			if (pc <= 0.4) return 1;
			if (pc <= 0.6) return 2;
			if (pc <= 0.8) return 3;
			if (pc <= 0.9) return 4;
			if (pc <= 0.95) return 5;
			if (pc >= 1.0) return 6;
			return 0;
		}
		

		
		
		static var addedNapeDisplay:Boolean = false;

		
		static function RenderOverlay(bd:BitmapData)
		{
			if (GameVars.doingLevelIntro == false) return;
			var g:Graphics = fillScreenMC1.graphics;
			g.clear();

			//copyScreenBD.fillRect(copyScreenBD.rect, 0);
			
			
			g.lineStyle(0, 0, 0);
			g.beginFill(0, 1);
			g.drawRect(0, 0, Defs.displayarea_w, Defs.displayarea_h);
			
			var x:Number = Defs.displayarea_w2;
			var y:Number = Defs.displayarea_h2;
			
// circular
//			var rad:Number = Utils.ScaleTo(1, Defs.displayarea_w, 0, GameVars.levelIntroTimerMax, GameVars.levelIntroTimer);
//			g.drawCircle(x, y, rad);
			
// horizontal
//			var rad:Number = Utils.ScaleTo(0, Defs.displayarea_w2, 0, GameVars.levelIntroTimerMax, GameVars.levelIntroTimer);
//			g.drawRect(Defs.displayarea_w2, 0,  rad, Defs.displayarea_h);			
//			g.drawRect(Defs.displayarea_w2-rad, 0,  rad, Defs.displayarea_h);

// vertical
			var rad:Number = Utils.ScaleTo(0, Defs.displayarea_h2, 0, GameVars.levelIntroTimerMax, GameVars.levelIntroTimer);
			g.drawRect(0,Defs.displayarea_h2,  Defs.displayarea_w,rad );			
			g.drawRect(0,Defs.displayarea_h2-rad, Defs.displayarea_w,rad);
			
			
//			g.drawRect(0, 0,  Defs.displayarea_w2-rad, Defs.displayarea_h);
//			g.drawRect(Defs.displayarea_w2+rad, 0, Defs.displayarea_w2-rad, Defs.displayarea_h);
			
			
			g.endFill();
			
			bd.draw(fillScreenMC1, null, null);
		}
		
		
		public static function Render(_bd:BitmapData)
		{
			
			if (gameState == gameState_UI)
			{
				return;
			}
			if (gameState == gameState_Walkthrough)
			{
				return RenderWalkthrough(_bd);
			}
			if (pause) return;
			
			if (PauseMenu.IsPaused()) 
			{	
				if (PROJECT::isMobile == false)
				{
					PauseMenu.Render(_bd);
				}
				return;
			}
			
			if (levelState == levelState_EndScreen)
			{
				return;
			}
			if (levelState == levelState_Null)
			{
				return;
			}

			if (levelState == levelState_Editor)
			{
				return;
			}
			
			var screenBD:BitmapData = _bd;
			var bd:BitmapData = scrollScreenBD; 
			
			var gfxid:int;
			var numf:int;
			var px:Number;
			
			var x:int;
			var y:int;
			
			
			
			var level:Level = Levels.GetCurrent();

			
			if (PROJECT::useStage3D)
			{
				s3d.StartRender();
				s3d.SetCurrentBlendMode(s3d.BLENDMODE_SOLID);
				s3d.SetCurrentShader("normal");
			}
			
			if (PROJECT::useStage3D == false)
			{
				bd.fillRect(bd.rect, 0);
			}

			
			if (currentDisplayTexture == -1)
			{
			
				GameObjects.Render(bd);
				Particles.Render(bd);
			}
			 
			EngineDebug.RenderNape(bd);
			//EngineDebug.RenderLines(bd);



				
			if (PROJECT::useStage3D == false)
			{
				screenBD.copyPixels(bd, bd.rect, new Point(0, 0), null, null, true);
			}

			if (PROJECT::useStage3D)
			{
				if (currentDisplayTexture != -1)
				{
					s3d.RenderRectangle(new Matrix3D(),TexturePages.pages[currentDisplayTexture].s3dTexture, 0, 0, 640, 480, 0, 0, 0, 1, 1);				
					//s3d.RenderRectangle(TexturePages.pages[currentDisplayTexture].s3dTexture, 0, 0, 640, 480, 0, 0, 0, 1, 1);				
					//s3d.RenderRectangle(TexturePages.pages[currentDisplayTexture].s3dTexture, 0, 0, 640, 480, 0, 0, 0, 1, 1);				
					trace("size " + TexturePages.pages[currentDisplayTexture].width + " , " + TexturePages.pages[currentDisplayTexture].height);
				}
				if (true)	//usedebug)
				{
					if (KeyReader.Pressed(KeyReader.KEY_T))
					{
						currentDisplayTexture++;
						if (currentDisplayTexture >= TexturePages.pages.length)
						{
							currentDisplayTexture = -1;
						}
						Utils.print("texture page " + currentDisplayTexture);
					}
					if (KeyReader.Pressed(KeyReader.KEY_Y))
					{
						currentDisplayTexture--
						if (currentDisplayTexture < 0)
						{
							currentDisplayTexture = -1;
						}
						Utils.print("texture page " + currentDisplayTexture);
					}
				}

				RenderPanel(screenBD);
				hudController.Render(screenBD);
		
				s3d.EndRender();
			}
			else
			{
				hudController.Render(screenBD);
				RenderOverlay(screenBD);
				RenderPanel(screenBD);
			}
			
			
			EngineDebug.StopTimers();
			
			EngineDebug.RenderTimers(screenBD);
			EngineDebug.CreateGetTimerStrings();
			
		}
		
		public static function RenderWalkthrough(_bd:BitmapData)
		{
			var screenBD:BitmapData = _bd;
			var bd:BitmapData = scrollScreenBD; 
			
			var gfxid:int;
			var numf:int;
			var px:Number;
			
			var x:int;
			var y:int;
			
			
			
			var level:Level = Levels.GetCurrent();

			
			if (PROJECT::useStage3D)
			{
				s3d.StartRender();
			}
			
			if (PROJECT::useStage3D == false)
			{
				bd.fillRect(bd.rect, 0);
			}
			
//			backDOF.RenderAt(screenBD, 0, 0);
			
			
			
			GameObjects.Render(bd);
			Particles.Render(bd);
			
			EngineDebug.RenderNape(bd);
			//EngineDebug.RenderLines(bd);



				
			if (PROJECT::useStage3D == false)
			{
				screenBD.copyPixels(bd, bd.rect, new Point(0, 0), null, null, true);
			}

			if (PROJECT::useStage3D)
			{
				if (currentDisplayTexture != -1)
				{
					//s3d.RenderRectangle(GraphicObjects.GetDisplayObjByName("Fill").GetTexture(0), 0, 0, 800, 800, 0, 0, 0, 0.5, 0.5);				
					s3d.RenderRectangle(new Matrix3D(),TexturePages.pages[currentDisplayTexture].s3dTexture, 0, 0, 640, 480, 0, 0, 0, 1, 1);				
					//s3d.RenderRectangle(TexturePages.pages[currentDisplayTexture].s3dTexture, 0, 0, 640, 480, 0, 0, 0, 1, 1);				
					//s3d.RenderRectangle(TexturePages.pages[currentDisplayTexture].s3dTexture, 0, 0, 640, 480, 0, 0, 0, 1, 1);				
				}
				if (usedebug)
				{
					if (KeyReader.Pressed(KeyReader.KEY_T))
					{
						currentDisplayTexture++;
						if (currentDisplayTexture >= TexturePages.pages.length)
						{
							currentDisplayTexture = -1;
						}
						Utils.print("texture page " + currentDisplayTexture);
					}
				}

				
				s3d.EndRender();
			}
			
			
			
			EngineDebug.StopTimers();
			RenderPanel(screenBD);
			EngineDebug.RenderTimers(screenBD);
			EngineDebug.CreateGetTimerStrings();
			
		}
		
		
		static var currentDisplayTexture:int = -1;
		
		static var gm:Matrix = new Matrix();
		
		
		static function RenderCircle(g:Graphics, x:Number, y:Number, rad:Number, col:uint):void
		{
			var numP:int = 50;
			var dx:Number = Math.PI * 2 / numP;
			var i:int;
			var ang:Number = 0;
			for (i = 0; i < numP; i++)
			{
				var j:int = i + 1;
				var ang1:Number = ang + dx;
				var xp:Number = x + (Math.cos(ang) * rad);
				var yp:Number = y + (Math.sin(ang) * rad);
				var xp1:Number = x + (Math.cos(ang1) * rad);
				var yp1:Number = y + (Math.sin(ang1) * rad);
				ang += dx;
				
				g.beginFill(col, 1);
				g.lineStyle(null, null, 0);
				g.moveTo(x, y);
				g.lineTo(xp, yp);
				g.lineTo(xp1, yp1);
				g.lineTo(x, y);
				g.endFill();
				
			}			
		}
		
		
		static function RenderCursor(bd:BitmapData)
		{
		}
		
		
		static var zorder:Array;
		public static function RenderNearGOs(bd:BitmapData):void
		{
			var go:GameObj;
			var i:int = zorder.length;
			for (var a:int = 0; a <i; a++)
			{
				go = zorder[a];
				if (go.zpos < -1000)
				{
					go.Render(bd);
				}
			}
			
		}
		public static function RenderFarGOs(bd:BitmapData):void
		{
			var go:GameObj;
			var i:int;

			
			
			i = 0;
			zorder = new Array();
			for each(go in GameObjects.objs)
			{
				if (go.active && go.visible)
				{
					zorder.push(go);
					i++;
				}
			}
			zorder.sortOn("zpos",Array.NUMERIC|Array.DESCENDING);
			
			
			for (var a:int = 0; a <i; a++)
			{
				go = zorder[a];
				if (go.zpos >= -1000)
				{
					go.Render(bd);
				}
			}
			
		}
		
		
		static function RenderFloorGrass(bd:BitmapData):void 
		{
			var i:int;
			var p0:Point;
			var p1:Point;
			var l :Level = Levels.GetCurrent();

			var dobj_spikes:DisplayObj = GraphicObjects.GetDisplayObjByName("spikes");
			var numf_spikes:int = dobj_spikes.GetNumFrames();
			
			for each(var line:EdLine in l.lines)
			{
				if (line.type == 3)	// normals (spikes)
				{
					for (i = 0; i < line.points.length; i++)
					{
						var j:int = i + 1;
						j %= line.points.length;
						p0 = line.points[i].clone();
						p1 = line.points[j].clone();
						
						var dx:Number = p1.x - p0.x;
						var dy:Number = p1.y - p0.y;
						
						var len:Number = Utils.DistBetweenPoints(p0.x, p0.y, p1.x, p1.y);
						
						dx /= len;
						dy /= len;
						
						var k:Number;
						for (k = 0; k < len; k+=7)
						{
							var xx:Number = p0.x + (dx * k);
							var yy:Number = p0.y + (dy * k);
							//yy += Utils.RandBetweenInt(1, 3);
							
							var ang:Number = Math.atan2(dy, dx);	// + (Math.PI * 0.5);
							dobj_spikes.RenderAtRotScaled(Utils.RandBetweenInt(0, numf_spikes - 1), bd, xx, yy, 1, ang, null, true);
							
						}
					}
				}
			}
			
		}
		
		
		
		
		

		
		
		

		public static function InitMessage(_message:String,x:Number=320,y:Number=100)
		{
			var go:GameObj;
			go = GameObjects.AddObj(0, 0, -500);
			go.InitTextMessage(_message,x,y);
		}
		
		
		
		
		public static function RenderPanel(bd:BitmapData)
		{
		
			if ((EngineDebug.debugMode & 1) != 0) return;
			
			var l:Level = Levels.GetCurrent();
			if (l == null) 
			{
				Utils.print("null level " + Levels.currentIndex);
				return
			}
			
			
			var x:Number;
			var y:Number;
			var s:String;
			var w:Number;

			var f:int;
			x = 10;
			y = 35;

		
			if (false)	//PROJECT::isGamePad)
			{
				s = "Pad is supported" +MobileSpecific.pad_isSupported+" / "+MobileSpecific.pad_NumDevices;
				TextRenderer.RenderAt(0,bd, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
				y += 20;
				
				for (var i:int = 0; i < 24; i++)
				{
					var controlX:GameInputControl = MobileSpecific.pad0.getControlAt(i);
					s = "control " + i + ": " + controlX.value;
					TextRenderer.RenderAt(0,bd, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
					y += 20;
				}
				
			}
			
			
			if (usedebug == false)
			{
				
//				s = "" +int(main.fps);
//				TextRenderer.RenderAt(0,bd, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
//				y += 20;
			}
			else
			{
				
				s = "Level:" +(Levels.currentIndex + 1) + ": " + l.name + " id:" + l.id+"  fps:" +int(main.fps);
				TextRenderer.RenderAt(0,bd, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
				y += 20;
				
				s = "Lives: " + GameVars.lives + "/" + GameVars.maxLives;
				TextRenderer.RenderAt(0,bd, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
				y += 20;

				//s = "Stopwatch " +Utils.CounterToMinutesSecondsMilisecondsString(GameVars.stopwatch);
				//TextRenderer.RenderAt(0,bd, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
				//y += 20;
				
				
				
/*

				if (GameVars.playerGO)
				{
					s = "xvel " +GameVars.playerGO.nape_bodies[0].velocity.x.toPrecision(2);
					TextRenderer.RenderAt(bd, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
					y += 20;
				}
				
				*/
				
				/*
				s = "Particles " +Particles.CountActive()+" / "+Particles.list.length;
				TextRenderer.RenderAt(0,bd, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
				y += 20;

				s = "GOs " +GameObjects.CountActive()+ "/" + GameObjects.objs.length + "    static: " + GameObjects.CountStaticActive() + "/" + GameObjects.staticObjs.length;
				TextRenderer.RenderAt(0,bd, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
				y += 20;
				*/
			}
			
				
		}	

		static function InitControl()
		{
		}
		
		static function InitShot()
		{

		}

		
		
		public static function GetLineIndexByName(name:String):int
		{
			var l:Level = Levels.GetCurrent();
			var index:int = 0;
			for each(var line:EdLine in l.lines)
			{
				if (line.id == name)
				{
					return index;
				}
				index++;
			}
			return -1;
		}
		

		
		static function InitDrag()
		{
			dragState = 0;
		}
		
		static var dragState:int = 0;
		static var dragPosX:Number= 0;
		static var dragPosY:Number= 0;
		
		static var buttonClickedThisUpdate:Boolean;
		
		static function UpdateControl()		
		{
			buttonClickedThisUpdate = false;
			
		//	DoOnClickedControl();
		}
		
		static function DoOnClickedControl()		
		{
			
			var curs:String = "pointer";
			
			var mx:Number = MouseControl.x;
			var my:Number = MouseControl.y;
			var buttonPressed:Boolean = MouseControl.buttonPressed;
			
			if (playbackWalkthrough)
			{
				if (currentWalkthroughRecordingPoint != null)
				{
					mx = currentWalkthroughRecordingPoint.x;
					my = currentWalkthroughRecordingPoint.y;
					buttonPressed = currentWalkthroughRecordingPoint.mouseButton;
				}
			}
			
			
			go = HitTestPhysObjGraphics(mx, my);
			if (go)
			{
				if (go.onClickedFunction != null)
				{
					if (go.canClickFunction == null)
					{
						curs = "canpress";						
					}
					else
					{
						if (go.canClickFunction() == true)
						{
							curs = "canpress";						
						}
						else
						{
							curs = "cantpress";						
						}
					}
				}
			}
			if (Mouse.cursor != curs) 
			{
				if (PROJECT::useStage3D == false)
				{
					Mouse.cursor = curs;
				}
			}
			



			if (buttonPressed)
			{
				MouseControl.buttonPressed = false;
				buttonClickedThisUpdate = true;
			
				var go:GameObj;
				go = HitTestPhysObjGraphics(mx, my);
				if (go)
				{
					if (go.onClickedFunction != null)
					{
						go.onClickedFunction();
						return;
					}
				}
				else
				{
				}
			
			}		
		}
		
		
		static function HitTestGOLine(go:GameObj,mx:int,my:int):Boolean
		{
			var x:Number = Math.round(go.xpos);
			var y:Number =  Math.round(go.ypos);
			x -= Math.round(Game.camera.x);
			y -= Math.round(Game.camera.y);
			var sx:Number = Math.round(Game.camera.x);
			var sy:Number = Math.round(Game.camera.y);
			var newpoints:Array = new Array();
			
			var p0:Point;
			
			var index:int = 0;
			for each(var p:Point in go.linkedPhysLine.points)
			{
				p0 = p.clone();
				p0.x -= go.linkedPhysLine.centrex;
				p0.y -= go.linkedPhysLine.centrey;
				p0.x += go.xpos;
				p0.y += go.ypos;
				p0.x -= sx;
				p0.y -= sy;
				newpoints.push(p0);
				
				index++;
			}
			var edLine:EdLine = new EdLine();
			edLine.SetPointArray(newpoints);
			
			return edLine.PointInPoly(mx, my);

		}
		
		public static function HitTestPhysObjGraphics(x:Number, y:Number):GameObj
		{
			if (PROJECT::useStage3D)
			{
				return HitTestPhysObjGraphics_Stage3D(x, y);
			}
			
			var bd:BitmapData = Game.main.screenBD;
			var r:Rectangle = new Rectangle(0, 0, 1, 1);
									
			bd.fillRect(Defs.screenRect, 0);	

			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active && go.onClickedFunction != null)
				{
					if (go.clickTestType == 1)
					{
						if (HitTestGOLine(go, x, y)) return go;
					}
					else
					{

						var dobj:DisplayObj = go.dobj;

						var extra:Number =100;
						r = new Rectangle( (go.xpos-camera.x)-extra, (go.ypos-camera.y)-extra, extra*2,extra*2);
						
						if (r.contains(x, y))
						{
							bd.fillRect(r, 0);	
							
							go.Render(bd);
							
							var col:uint = bd.getPixel32(x, y);
							if (col != 0)
							{
								return go;
							}		
							
						}
					}
				}
			}
			return null;
		}
		

		public static function HitTestPhysObjGraphics_Stage3D(x:Number, y:Number):GameObj
		{
			
			var r:Rectangle = new Rectangle(0, 0, 1, 1);
									
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active && go.onClickedFunction != null)
				{
					if (go.clickTestType == 1)
					{
						//if (HitTestGOLine(go, x, y)) return go;
					}
					else
					{

						var dobj:DisplayObj = go.dobj;

						var extra:Number =100;
						r = new Rectangle( (go.xpos-camera.x)-extra, (go.ypos-camera.y)-extra, extra*2,extra*2);
						
						if (r.contains(x, y))
						{
							return go;
						}
					}
				}
			}
			return null;
		}
		
		
		
		public static function DoGameObjSwitch(go:GameObj_Base)
		{
			for each (var go1:GameObj in GameObjects.objs)
			{
				if (go1.active && go1.switchFunction != null)
				{
//					Utils.trace("GOBJ SWITCH  instID: "+go.id);
					if (go1.switchName == go.id)
					{
						go1.switchFunction();
					}
				}
			}
		}
		
		public static function DoSwitchPOI(thisPOI:EdObj)
		{
			
		}
		
		public static function DoSwitch(thisGO:GameObj_Base)
		{

			for each (var go:GameObj in GameObjects.objs)
			{
				if (go.active)
				{
					if (go.switchFunction != null)
					{
						if (go.logicLink0.length != 0)
						{
							for each(var link:GameObj in go.logicLink0)
							{
								if(link == thisGO)
								{
									go.switchFunction();
									Audio.OneShot("sfx_switch");
								}
							}
						}
					}
				}
			}
		}
		
		// 0 = first.
		// zero based.
		public static function GetPlayerPosition():int
		{
			var px:Number = GameVars.playerGO.xpos;
			
			var place:int = 0;
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active && go.name == "aicar")
				{
					if (go.xpos > px) place++;
				}
			}
			return place;
		}

		public static function GetAIPosition(aiCar:GameObj):int
		{
			var px:Number = aiCar.xpos;
			
			var place:int = 0;
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active && (go.name == "aicar" || go.name == "player"))
				{
					if (go != aiCar)
					{
						if (go.xpos > px) place++;
					}
				}
			}
			return place;
		}

		static var ballpath_grav:Number = 0.1;
		static var ballpath_mult:Number = 0.07300000000000005;
		static var renderBallPathTimer:Number = 0;
		static var ballpath_dx:Number;
		static var ballpath_dy:Number;
		static var ballpath_mass:Number;
		static var ballpath_scaler:Number = 1;
		static var ballpath_doit:Boolean;
		
		static var prevBallPath_dx:Number;
		static var prevBallPath_dy:Number;
		static var prevBallPath_x:Number;
		static var prevBallPath_y:Number;
		static var prevBallPath_doIt:Boolean;
		
		static function InitBallPathForLevel()
		{
			prevBallPath_doIt = false;
		}
		
		static function RenderPreviousBallPath(bd:BitmapData)
		{
			if (prevBallPath_doIt == false) return;
			var _x = prevBallPath_x- camera.x;
			var _y = prevBallPath_y- camera.y;
			var _dx = prevBallPath_dx;
			var _dy = prevBallPath_dy;
			
			var g:Graphics = fillScreenMC.graphics;
			g.clear();
			g.lineStyle(1, 0xffffff, 0.1);
			
			renderBallPathTimer -= 1;
			
			var x:Number = _x;
			var y:Number = _y;
			var grav:Number = ballpath_grav;
			
			var dx:Number = _dx*ballpath_mult;
			var dy:Number = _dy*ballpath_mult;
			
			var ox:Number = x;
			var oy:Number = y;
			var d2:Number = 3*3;
			
			g.moveTo(x, y);
			
			var i:int;
			var count:int = 0;
			for (i = 0; i < 1700; i++)
			{
				count--;
				if (count <= 0)
				{
					if (Utils.Dist2BetweenPoints(x, y, ox, oy) > (d2))
					{
						var alpha:Number = 0.2;
						var alphaOffset = Utils.ScaleToPreLimit(0, 0.2, 0, GameVars.ballLineLength, i);
						
						alpha -= alphaOffset;
						if (alpha <= 0) alpha = 0;
						
						g.lineStyle(1, 0xffffff, alpha);
						g.lineTo(x, y);
						ox = x;
						oy = y;
					}
					count = 10;
				}
				
				x += dx;
				y += dy;
				dy += grav;
				if (x < -10) i = 99999;
				if (x > Defs.displayarea_w+10) i = 99999;
				if (y > Defs.displayarea_h) i = 99999;
			}
			
			
			bd.draw(fillScreenMC,null,null,null,null,false);			
			
		}
		
		static function RenderBallPath_calcPositions_Init()
		{
			positions = new Vector.<Point>();
			for (var i:int = 0; i < numPositions; i++)
			{
				positions.push(new Point());
			}
		}
		
		static var numPositions:int = 50;
		static var positions:Vector.<Point>;
		static function RenderBallPath_calcPositions(_x:Number,_y:Number)
		{
//v' = (1 - d)^h * (v + a * h), x' = x + v' * h
//v = velocity, a = acceleration, h = time step, x = position, d = dampening, v' = new velocity, x' = new position
//v, x, a are all vectors
//d, h, scalars

			
			var v1:Point = new Point(0, 0);
			var p1:Point = new Point(0, 0);
			var x:Point = new Point(_x,_y);
			var v:Point = new Point(ballpath_dx / ballpath_mass * ballpath_scaler, ballpath_dy / ballpath_mass * ballpath_scaler);
			var a:Point = new Point(0, PhysicsBase.nape_Gravity);
			var d:Number = PhysicsBase.GetNapeSpace().worldLinearDrag;
			var h:Number = 1 / 60;
						
			var a1:Point = new Point();
			
			var totalTime:int = numPositions;
			for (var i:int = 0; i < totalTime; i++)
			{
				positions[i].x = x.x;
				positions[i].y = x.y;
				
				var z:Number = Math.pow((1 - d), h);
				a1.x = a.x * h;
				a1.y = a.y * h;
				a1.x += v.x;
				a1.y += v.y;
				v1.x = a1.x * z;
				v1.y = a1.y * z;
				
				x.x += v1.x * h;
				x.y += v1.y * h;
				
				v.x = v1.x;
				v.y = v1.y;
				
			}
			
		}
		
		
		static function DetectBallPath(bd:BitmapData,_x:Number,_y:Number,_dx:Number,_dy:Number):int
		{				
			RenderBallPath_calcPositions(_x,_y);

			var filter:InteractionFilter = new InteractionFilter(1, 1, 0, 0, 0, 0);
			
			for (var i:int = 1; i < 20; i+=4)
			{
				var p:Point = positions[i];
				
				var space:Space = PhysicsBase.GetNapeSpace();
				var bodyList:BodyList = space.bodiesInCircle(new Vec2(p.x, p.y), 20, false, filter);
				if (bodyList.length != 0)
				{
					trace("hit! body list "+bodyList.length+"  - "+i+"/"+positions.length);
					return i;
				}
			}
			return -1;
		}
		
		
		static function RenderBallPath(bd:BitmapData,_x:Number,_y:Number,_dx:Number,_dy:Number)
		{
			if (ballpath_doit == false) return;
			var hitSomethingPos:int= DetectBallPath(bd, _x, _y, _dx, _dy);
			RenderBallPath_Stage3D(bd, _x, _y, _dx, _dy,hitSomethingPos);
			return;

			RenderBallPath_calcPositions(_x,_y);

			var g:Graphics = fillScreenMC.graphics;
			g.clear();
			g.lineStyle(1, 0xffffff, 0.5);
			
			
			for (var i:int = 0; i < positions.length - 1; i++)
			{
				var alpha:Number = Utils.ScaleTo(1, 0, 0, positions.length, i);
				var p:Point = positions[i];
				var p1:Point = positions[i+1];
				g.lineStyle(2, 0xffffff, alpha);
				g.moveTo(p.x, p.y);
				g.lineTo(p1.x, p1.y);
			}
			
			
			bd.draw(fillScreenMC,null,null,null,null,false);			
		}

		static function RenderBallPathOld(bd:BitmapData,_x:Number,_y:Number,_dx:Number,_dy:Number)
		{
			if (ballpath_doit == false) return;
			if (PROJECT::useStage3D) 
			{
				RenderBallPath_Stage3D(bd, _x, _y, _dx, _dy,0);
				return;
			}
			var g:Graphics = fillScreenMC.graphics;
			g.clear();
			g.lineStyle(1, 0xffffff, 0.5);
			
			renderBallPathTimer -= 1;
			
			var bpt:Number = renderBallPathTimer;
			
			//if (shootMode != 0) return;
			
			if (usedebug)
			{
				if (KeyReader.Down(KeyReader.KEY_NUM_1)) ballpath_grav -= 0.001;
				if (KeyReader.Down(KeyReader.KEY_NUM_2)) ballpath_grav += 0.001;
				if (KeyReader.Down(KeyReader.KEY_NUM_4)) ballpath_mult -= 0.0001;
				if (KeyReader.Down(KeyReader.KEY_NUM_5)) ballpath_mult += 0.0001;
			}
			ballpath_grav = Vars.GetVarAsNumber("gravity") * Vars.GetVarAsNumber("ballpath_gravity_multiplier")
			
			var x:Number = _x;
			var y:Number = _y;
			var grav:Number = ballpath_grav;
			
			var dx:Number = _dx*ballpath_mult;
			var dy:Number = _dy*ballpath_mult;
			
			var ox:Number = x;
			var oy:Number = y;
			var d2:Number = 3*3;
			
			g.moveTo(x, y);
			
			var max:int = 1000;
			
			var i:int;
			var count:int = 0;
			for (i = 0; i < max; i++)
			{
				count--;
				if (count <= 0)
				{
					if (Utils.Dist2BetweenPoints(x, y, ox, oy) > (d2))
					{
						var alpha:Number = 0.5;	// + (Math.cos(bpt * 0.2) * 0.1);
						var alphaOffset = Utils.ScaleToPreLimit(0, 0.7, 0, GameVars.ballLineLength, i);
						
						alpha -= alphaOffset;
						if (alpha <= 0) alpha = 0;
						bpt +=1;
						g.lineStyle(1, 0xffffff, alpha);
						g.lineTo(x, y);
						ox = x;
						oy = y;
					}
					count = 5;
				}
				
				x += dx;
				y += dy;
				dy += grav;
				if (x < -10) i = 99999;
				if (x > Defs.displayarea_w+10) i = 99999;
				if (y > Defs.displayarea_h) i = 99999;
			}
			
			
			bd.draw(fillScreenMC,null,null,null,null,false);			
		}
		
		
		static var ballLineOffset:Number = 0;
//		if (PROJECT::useStage3D) 
//		{
			static function RenderBallPath_Stage3D(bd:BitmapData,_x:Number,_y:Number,_dx:Number,_dy:Number,hitSomethingPos:int)
			{				
				RenderBallPath_calcPositions(_x,_y);

				ballLineOffset += 0.5;
				
				var off:int = int(ballLineOffset) % 4;
				
				var dob:DisplayObj = GraphicObjects.GetDisplayObjByName("obj_pathline_marker");
				var dob1:DisplayObj = GraphicObjects.GetDisplayObjByName("obj_pathline_marker_blocked");
				
				//var dob:DisplayObj = GraphicObjects.GetDisplayObjByName("whiteRect");
				//var tx:Texture = dob.GetTexture(0);
				//var dof:DisplayObjFrame = dob.GetFrame(0);			
				
				for (var i:int = 0; i < positions.length - 5; i+=4)
				{
					var alpha:Number = Utils.ScaleTo(1, 0, 0, positions.length, i);
					var p:Point = positions[i+off];
//					var p1:Point = positions[i+2+off];
	//					s3d.RenderLine(tx, p.x,p.y,p1.x,p1.y, dof.u0,dof.v0,dof.u1,dof.v1);
					
					var dobToRender:DisplayObj = dob;
					if (hitSomethingPos == -1)
					{
					}
					else
					{
						if (i <= hitSomethingPos)
						{
							
						}
						else
						{
							dobToRender = dob1;
						}
					}
					GameVars.playerGO.RenderDispObjAt(p.x, p.y, dobToRender, 0, null, 0, 1);

				}
			}
//		}
		

		
		static function MakeCombinedStaticsByTexturePage()
		{
			return;
			if (PROJECT::useStage3D == false)
			{
				return;
			}
			trace("combining statics");
			var numStatics:int = 0;
			for each(var go:GameObj in GameObjects.staticObjs)
			{
				if (go.active)
				{
					go.zposInt = int(go.zpos);
					trace(go.dobj.origName + "  " + go.zpos + "   " + go.zposInt);
					trace("tex page index "+go.dobj.frames[0].s3dTexPageIndex);
					numStatics++;
				}
			}
			
			// sort in to groups by zpos:
			
			var groups:Array = new Array();
			var groupPages:Array = new Array();
			
			for each(var go:GameObj in GameObjects.staticObjs)
			{
				if (go.active)
				{
					var texpage:int = go.dobj.frames[0].s3dTexPageIndex;
					var foundGroupIndex:int = -1;
					var foundGroupZ:int = -1;
					for (var i:int = 0; i < groupPages.length; i++)
					{
						
						if (groupPages[i] == texpage)
						{
							foundGroupIndex = i;
							i = 99999;
						}
					}
					if (foundGroupIndex == -1)	// not found
					{
						var group:Array = new Array();
						group.push(go);
						groups.push(group);
						groupPages.push(texpage);
					}
					else
					{
						var group:Array = groups[foundGroupIndex];
						group.push(go);						
					}
				}
			}
			
			trace("numStatics: " + numStatics);
			for (var i:int = 0; i < groupPages.length; i++)
			{
				trace("group:  page=" + groupPages[i] + "   amt=" + groups[i].length);
			}
			
			for (var i:int = 0; i < groupPages.length; i++)
			{
				var group:Array = groups[i];
				
				trace("initing GO zpos " + group[0].zposInt);
				
				var newGO:GameObj = GameObjects.AddStaticObj(0, 0, group[0].zposInt);
				newGO.AddCombinedStaticObj();
				newGO.dobj = group[0].dobj;
				
				
				
				PROJECT::useStage3D
				{
					s3d.StartCreateDobjVertexBuffer();

					for each(var go:GameObj in group)
					{
						go.dobj.frames[go.frame].AppendToVertexBufferRotScaled(null, go.xpos, go.ypos, go.scale, go.dir);
					}
					newGO.s3dTriListIndex = s3d.FinishCreateDobjVertexBuffer();
				
				}
			}
			for each(var go:GameObj in GameObjects.staticObjs)
			{
				if (go.active && go.name != "combinedstatic")
				{
					go.active = false;
				}
			}
			
			
		}
		
		static function MakeCombinedStaticsByZpos()
		{
			
			if (PROJECT::useStage3D == false)
			{
				return;
			}
			trace("combining statics");
			var numStatics:int = 0;
			for each(var go:GameObj in GameObjects.staticObjs)
			{
				if (go.active)
				{
					go.zposInt = int(go.zpos);
					trace(go.dobj.origName + "  " + go.zpos + "   " + go.zposInt);
					trace("tex page index "+go.dobj.frames[0].s3dTexPageIndex);
					numStatics++;
				}
			}
			
			// sort in to groups by zpos:
			
			var groups:Array = new Array();
			var groupZs:Array = new Array();
			
			for each(var go:GameObj in GameObjects.staticObjs)
			{
				if (go.active)
				{
					var foundGroupIndex:int = -1;
					var foundGroupZ:int = -1;
					for (var i:int = 0; i < groupZs.length; i++)
					{
						if (groupZs[i] == go.zposInt)
						{
							foundGroupIndex = i;
							i = 99999;
						}
					}
					if (foundGroupIndex == -1)	// not found
					{
						var group:Array = new Array();
						group.push(go);
						groups.push(group);
						groupZs.push(go.zposInt);
					}
					else
					{
						var group:Array = groups[foundGroupIndex];
						group.push(go);						
					}
				}
			}
			
			trace("numStatics: " + numStatics);
			for (var i:int = 0; i < groupZs.length; i++)
			{
				trace("group:  z=" + groupZs[i] + "   amt=" + groups[i].length);
			}
			
			for (var i:int = 0; i < groupZs.length; i++)
			{
				var group:Array = groups[i];
				var newGO:GameObj = GameObjects.AddStaticObj(0, 0, groupZs[i]);
				newGO.AddCombinedStaticObj();
				newGO.dobj = group[0].dobj;
				
				
				
				PROJECT::useStage3D
				{
					s3d.StartCreateDobjVertexBuffer();

					for each(var go:GameObj in group)
					{
						go.dobj.frames[go.frame].AppendToVertexBufferRotScaled(null, go.xpos, go.ypos, go.scale, go.dir);
					}
					newGO.s3dTriListIndex = s3d.FinishCreateDobjVertexBuffer();
				
				}
			}
			for each(var go:GameObj in GameObjects.staticObjs)
			{
				if (go.active && go.name != "combinedstatic")
				{
					go.active = false;
				}
			}
			
			
		}

		static function AddCars()
		{
			if (useLocalRuns)
			{
				loadedRunsCB_LocalData();
			}
			else
			{				
				if (PROJECT::isMobile == false)
				{
					PlayerRecordings.GetAllRaceData(GetAllRaceDataCB);
					
				}
			}			
		}
		
//----------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------		
		
		static function GetAllRaceDataCB()
		{
			var levelID:String = Levels.GetCurrent().id;
			var a:Array = new Array();
			for each(var pr:PlayerRecording in PlayerRecordings.serverTrackRaceDataList)
			{
				if (pr.levelID == levelID)
				{
					a.push(pr.db_id);
				}
			}
			
			if (a.length != 0)
			{
				PlayerRecordings.LoadRaceDataFromServer_IDArray(a, loadedRunsCB);
			}
			
		}
		
		static var aiGenerateList:Array;
		static function loadedRunsCB()
		{
			aiGenerateList = new Array();

			for each(var pr:PlayerRecording in PlayerRecordings.loadedRuns)
			{
				aiGenerateList.push(pr);
				
			}
			GenerateAIPlayersFromList();
		}

		static function loadedRunsCB_LocalData()
		{
			var levelID:String = Levels.GetCurrent().id;

			aiGenerateList = new Array();
			
			for each(var pr:PlayerRecording in PlayerRecordings.loadedRuns)	// this is all of them
			{
				if (pr.levelID == levelID)
				{
					aiGenerateList.push(pr);
				}
			}
			
			GenerateAIPlayersFromList();
		}
		
		static function GenerateAIPlayersFromList()
		{
			if (aiGenerateList.length == 0) return;
			
			
			var timeA:Number = 10;
			var timeB:Number = 20;
			var eo:EdObj = Levels.GetCurrent().GetObjectByType("LevelInfo");
			if (eo)
			{
				timeA = eo.objParameters.GetValueNumber("level_aitime_1");
				timeB = eo.objParameters.GetValueNumber("level_aitime_2");
			}
			
			// add some time on mobile version to make it easier
			if (PROJECT::useStage3D)
			{
				timeA += (5);
				timeB += (5);
			}
			
			
			var totalTime:Number = 0;
			var minTime:Number = 999999999;
			var maxTime:Number = 0;
			for each(var pr:PlayerRecording in aiGenerateList)
			{
				pr.time = pr.list.length;
				
				var t:int = pr.time;
				if (Game.useLocalRuns)
				{
					t *= GameVars.rundata_skip;
				}

				
				trace("TIME " + t);
				totalTime += t;
				if (t < minTime) minTime = t;
				if (t > maxTime) maxTime = t;
			}
			totalTime /= aiGenerateList.length;
			totalTime = Math.floor(totalTime);
			trace("Min TIME " + Utils.CounterToSecondsString(minTime));
			trace("Max TIME " + Utils.CounterToSecondsString(maxTime));
			trace("AVERAGE TIME " + Utils.CounterToSecondsString(totalTime));
			trace("Current Level times: " + timeA + " / " + timeB);
			var lev:int = GameVars.GetReorderedLevelIndexInverse(int(Levels.GetCurrent().id) - 1) + 1;
			trace("Current ordered level " + lev + "/24");
			
			var numAdded:int = 0;
			
			var newList1:Array = new Array();
			
			for each(var pr:PlayerRecording in aiGenerateList)
			{
				if (pr.bike_id != GameVars.playerBikeDefIndex)
				{
					newList1.push(pr.Clone());
				}
			}
			
			if (newList1.length > 5)
			{
				newList1.splice(5);
			}
			
			while (newList1.length < 5)
			{
				newList1.push(newList1[0].Clone());
			}
			
			
			var indexList:Array = new Array();
			for (var i:int = 0; i < newList1.length; i++)
			{
				indexList.push(i);
			}
			
			indexList = Utils.RandomiseArray(indexList, 500);
			
			for (var index:int = 0; index < newList1.length; index++)
			{
				var pr:PlayerRecording = newList1[indexList[index]];
				
				var timeSeconds:Number = Utils.ScaleTo(timeA, timeB, 0, newList1.length - 1, index);
				if (newList1.length == 1)
				{
					timeSeconds = timeA;
				}
				
//				var go:GameObj = PhysicsBase.AddPhysObjAt("car0_AI", 0, 0, 0, 1);
//				go.InitAIPlayer1(pr);	
				
				var go:GameObj = GameObjects.AddObj(0, 0, 0);
				go.InitAIPlayer(pr, timeSeconds);	
				
			}

			
		}
		
	}	
}