package UIPackage  
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import AudioPackage.Audio;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import LicPackage.Lic;
	import LicPackage.LicCoolmath;
	import MissionPackage.Mission;
	import MissionPackage.MissionLevel;
	import MissionPackage.MissionObjective;
	import MissionPackage.Missions;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_MatchSelect extends UIScreenInstance
	{
		
		public function UI_MatchSelect() 
		{
			
		}

		public override function ExitScreen()
		{
			ExitScreenUIX();
			
//			//RemoveListeners();
//			UI.RemoveAllButtons();
//			UI.RemoveGeneric();
		}
		
		function ExitScreenUIX()
		{
			UIX.StopPage(titleMC,pageInst);
		}
		function InitScreenUIX()
		{
			titleMC = new MovieClip();
			uix_pageName = "page_matchselect";
			pageInst = UIX.StartPage(titleMC, uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), UIX_buttonBackPressed);			
			UIX.SetHardwareBackButton(pageInst.Child("btn_back"));			

			UIX.AddGeneric(pageInst.Child("generic"));
			
			AddMatches();
			
			pageInst.gameObjects.Update();

			pageInst.gameObjects.AddInstance(pageInst.Child("background")).InitTitle_Background();
			
			pageInst.preUpdateFunction = PreUpdate;
			
		}
		
		
		function PreUpdate()
		{
			if (Game.usedebug)
			{
				if (KeyReader.Pressed(KeyReader.KEY_U))
				{
					LicCoolmath.UnlockAllLevels();
				}
			}
			
			if (LicCoolmath.levelsJustUnlocked)
			{
				LicCoolmath.levelsJustUnlocked = false;
				UI.StartTransition("matchselect");
			}
		}
		
		function AddMatches()
		{
			// Actually Matches are Missions. Not gonna be confusing at all.
			
			
			var numMissions:int = Missions.GetNumMissions();
			
			if (numMissions > 8) numMissions = 8;
			

			matchInstList = new Array();
			for (var i:int = 0; i < numMissions; i++)
			{
				var id:int = i + 1;
				var inst:UIX_Instance = pageInst.Child("mission" + id);
				
				
				
				matchInstList.push(inst);
				
				inst.userData.matchIndex = i;
				
				var m:Mission = Missions.GetMission(i);
				
				var available:Boolean = false;
				var newlyAvailable:Boolean = false;
				var j:int = 1;
				for each(var ml:MissionLevel in m.missionLevels)
				{
					var star:UIX_Instance = inst.Child("star" + j);
					star.frame = 0;
					if (ml.complete) 
					{
						star.frame = 1 + ml.result;
					}
					
					if (ml.available) available = true;
					if (ml.newlyAvailable) newlyAvailable = true;
					
					j++;
				}
				
				var lock:UIX_Instance = inst.Child("lock");
				var newicon:UIX_Instance = inst.Child("newicon");
				
				lock.visible = (available == false);
				newicon.visible = newlyAvailable;
				
				if (newicon.visible)
				{
					pageInst.gameObjects.AddInstance(newicon).InitWobble();
				}

				
				var s:String = "DAY " + id;
				
				
				
				if (Game.usedebug || available == true)
				{
					UIX.AddAnimatedButton(inst, buttonMatchPressed);			
				}
				
				inst.Child("nameText").SetText(s);
				
			}
		}

		
		function buttonMatchPressed(inst:UIX_Instance)
		{
			
			GameVars.currentMatchIndex = inst.userData.matchIndex;
			Missions.currentMissionIndex = inst.userData.matchIndex;
			
			UI.StartTransition("levelselect");
		}
		
		
		
//-------------------------------------------------------------------------------		
		function InitScreenUIXScrollerOld()
		{
			titleMC = new MovieClip();
			uix_pageName = "page_matchselect";
			pageInst = UIX.StartPage(titleMC, uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), UIX_buttonBackPressed);			
			
			
			
			AddMatches();
			pageInst.Child("dragBox").button_canPress = true;
			pageInst.Child("dragBox").mouseEnabled = true;
			pageInst.Child("dragBox").dragBox_x = 0;
			pageInst.Child("dragBox").dragBox_minX = 0;
			pageInst.Child("dragBox").dragBox_maxX = 30000;
			pageInst.Child("dragBox").dragBox_CB = DragCB;
			pageInst.Child("dragBox").dragBox_dragActive = false;
			if (PROJECT::useStage3D)
			{
				pageInst.Child("dragBox").dragBox_dragActive = true;
			}
			
			
			UIX.AddGeneric(pageInst.Child("generic"));

			
			// scroll dragbox the correct position
			
			var inst:UIX_Instance = pageInst.Child("dragBox");
			
			var startX:Number = GameVars.missionSelectXPos;
			if (startX < inst.dragBox_minX) startX = inst.dragBox_minX;
			
			pageInst.SetDragBoxPosHorizontal(pageInst.Child("dragBox"), startX);
			
			
			// set up dpad controls:
			
			pageInst.SetDpadControls("btn_back", "", "","dpad_previous", "");

/*
			for (var icon:int = 1; icon <= 6; icon++)
			{
				var iconstr:String = "icon" + icon;
				
				var prev:int = icon - 1;
				if (prev < 1) prev = 6;
				var next:int = icon + 1;
				if (next >6) next = 1;
				
				var previconstr:String = "icon" + prev.toString();
				var nexticonstr:String = "icon" +next.toString();
				var up:String = "";
				var down:String = "";
				var left:String = "";
				var right:String = "";
				
				var l0s:String = ".level0";
				var l1s:String = ".level1";
				var l2s:String = ".level2";
				var l3s:String = ".level3";
				
				var levstr:String;
				
				up = "btn_back";
				levstr = iconstr+".level0";
				right = iconstr + l1s;
				down = iconstr + l2s;
				left = previconstr + l1s;
				pageInst.SetDpadControls(levstr, up, right,down, left);
				pageInst.SetDpadHoverCallback(levstr,DpadHoverCB);

				levstr = iconstr+".level1";
				right = nexticonstr + l0s;
				down = iconstr + l3s;
				left = iconstr + l0s;
				pageInst.SetDpadControls(levstr, up, right,down, left);
				pageInst.SetDpadHoverCallback(levstr,DpadHoverCB);

				down = "";
				levstr = iconstr+".level2";
				right = iconstr + l3s;
				up = iconstr + l0s;
				left = previconstr + l3s;
				pageInst.SetDpadControls(levstr, up, right,down, left);
				pageInst.SetDpadHoverCallback(levstr,DpadHoverCB);

				levstr = iconstr+".level3";
				right = nexticonstr + l2s;
				up = iconstr + l1s;
				left = iconstr + l2s;
				pageInst.SetDpadControls(levstr, up, right,down, left);
				pageInst.SetDpadHoverCallback(levstr,DpadHoverCB);
				
				
			}
			*/
			
			pageInst.dPadCurrent = "icon1.level0";
			
//			pageInst.gameObjects.Update();
			
			
		}
		
		public function DpadHoverCB(inst:UIX_Instance)
		{
			var name:String = inst.parentInst.GetInstanceName();
			
			var pos:int = int(name.substr(4));
			
			var startX:Number = 30 + ( (pos-1) * 600);
			if (startX < inst.dragBox_minX) startX = inst.dragBox_minX;
			GameVars.missionSelectXPos = startX;
			pageInst.SetDragBoxPosHorizontal(pageInst.Child("dragBox"), startX);
			
			/*
			pageInst.Child("icon1").ClearMatrixCache();
			pageInst.Child("icon2").ClearMatrixCache();
			pageInst.Child("icon3").ClearMatrixCache();
			pageInst.Child("icon4").ClearMatrixCache();
			pageInst.Child("icon5").ClearMatrixCache();
			pageInst.Child("icon6").ClearMatrixCache();
			*/
			
			
		}
		public function DragCB(xd:Number,yd:Number)
		{
			var inst:UIX_Instance = pageInst.Child("dragBox");
			inst.ClearMatrixCache();
			GameVars.missionSelectXPos = inst.dragBox_x;
			
			
			for each(var inst:UIX_Instance in matchInstList)
			{				
				inst.ClearMatrixCache();
				inst.x -= xd;
			}
		}
		
		function SetLevelTrophy(inst:UIX_Instance,l:Level)
		{
			return;
			inst.frame = l.completionLevel;
		}
		
		var matchInstList:Array;
		
		
		static var x0:XML = <instance component="Component_MatchSelectBox" pos="120, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon1, uix_text= , uix_textscale=1" />
		static var x1:XML = <instance component="Component_MatchSelectBox" pos="420, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon2, uix_text= , uix_textscale=1" />
		static var x2:XML = <instance component="Component_MatchSelectBox" pos="720, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon3, uix_text= , uix_textscale=1" />
		static var x3:XML = <instance component="Component_MatchSelectBox" pos="1020, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon4, uix_text= , uix_textscale=1" />
		static var x4:XML = <instance component="Component_MatchSelectBox" pos="1320, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon5, uix_text= , uix_textscale=1" />
		static var x5:XML = <instance component="Component_MatchSelectBox" pos="1620, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon6, uix_text= , uix_textscale=1" />
		static var x6:XML = <instance component="Component_MatchSelectBox" pos="1920, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon7, uix_text= , uix_textscale=1" />
		static var x7:XML = <instance component="Component_MatchSelectBox" pos="2220, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon8, uix_text= , uix_textscale=1" />
		static var x8:XML = <instance component="Component_MatchSelectBox" pos="2520, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon9, uix_text= , uix_textscale=1" />
		static var x9:XML = <instance component="Component_MatchSelectBox" pos="2520, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon10, uix_text= , uix_textscale=1" />
		static var x10:XML = <instance component="Component_MatchSelectBox" pos="120, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon11, uix_text= , uix_textscale=1" />
		static var x11:XML = <instance component="Component_MatchSelectBox" pos="420, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon12, uix_text= , uix_textscale=1" />
		static var x12:XML = <instance component="Component_MatchSelectBox" pos="720, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon13, uix_text= , uix_textscale=1" />
		static var x13:XML = <instance component="Component_MatchSelectBox" pos="1020, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon14, uix_text= , uix_textscale=1" />
		static var x14:XML = <instance component="Component_MatchSelectBox" pos="1320, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon15, uix_text= , uix_textscale=1" />
		static var x15:XML = <instance component="Component_MatchSelectBox" pos="1620, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon16, uix_text= , uix_textscale=1" />
		static var x16:XML = <instance component="Component_MatchSelectBox" pos="1920, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon17, uix_text= , uix_textscale=1" />
		static var x17:XML = <instance component="Component_MatchSelectBox" pos="2220, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon18, uix_text= , uix_textscale=1" />
		static var x18:XML = <instance component="Component_MatchSelectBox" pos="2520, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon19, uix_text= , uix_textscale=1" />
		static var x19:XML = <instance component="Component_MatchSelectBox" pos="2520, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon20, uix_text= , uix_textscale=1" />
		static var x20:XML = <instance component="Component_MatchSelectBox" pos="120, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon21, uix_text= , uix_textscale=1" />
		static var x21:XML = <instance component="Component_MatchSelectBox" pos="420, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon22, uix_text= , uix_textscale=1" />
		static var x22:XML = <instance component="Component_MatchSelectBox" pos="720, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon23, uix_text= , uix_textscale=1" />
		static var x23:XML = <instance component="Component_MatchSelectBox" pos="1020, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon24, uix_text= , uix_textscale=1" />
		static var x24:XML = <instance component="Component_MatchSelectBox" pos="1320, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon25, uix_text= , uix_textscale=1" />
		static var x25:XML = <instance component="Component_MatchSelectBox" pos="1620, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon26, uix_text= , uix_textscale=1" />
		static var x26:XML = <instance component="Component_MatchSelectBox" pos="1920, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon27, uix_text= , uix_textscale=1" />
		static var x27:XML = <instance component="Component_MatchSelectBox" pos="2220, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon28, uix_text= , uix_textscale=1" />
		static var x28:XML = <instance component="Component_MatchSelectBox" pos="2520, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon29, uix_text= , uix_textscale=1" />
		static var x29:XML = <instance component="Component_MatchSelectBox" pos="2520, 232, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon30, uix_text= , uix_textscale=1" />

		var leftArrowXML:XML = <instance component="Component_ButtonPageLeft" pos="2,259,-1000" scale="1,1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=pageLeft,uix_text=,uix_textscale=1" />
		var rightArrowXML:XML = <instance component="Component_ButtonPageRight" pos="802,261,-1000" scale="1,1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=pageRight,uix_text=,uix_textscale=1" />
		
		
		static var matchesList:Array = new Array(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9,
		x10, x11, x12, x13, x14, x15, x16, x17, x18, x19,
		x20, x21, x22, x23, x24, x25, x26, x27, x28, x29);
		
		function leftPressed(inst:UIX_Instance)
		{
			pageInst.FlickDragHorizontal(pageInst.Child("dragBox"), 151, true);
			
		}
		function rightPressed(inst:UIX_Instance)
		{
			pageInst.FlickDragHorizontal(pageInst.Child("dragBox"), -151, true);
		}

		function UIX_LevelPressed(inst:UIX_Instance)
		{		
			
			SaveData.Save();
			var levelID:int = inst.userData.levelIndex;
			Missions.currentMissionIndex = inst.userData.missionIndex;
			Missions.currentMissionLevelIndex = inst.userData.missionLevelIndex;
			
			var n:String = Missions.GetCurrentMissionLevel().levelName;
			Levels.currentIndex = Levels.GetLevelIndexById(n);
			
			
			
			var helpScreen:int = GameVars.GetHelpScreenForThisLevelIndex(GameVars.currentOrderedLevelIndex);
			
			if (true)	//helpScreen == -1)
			{
				if (false)	//Game.record_player)
				{
					UI.StartTransition("playerselect");				
				}
				else
				{
					UI.StartTransition("gamescreen");				
				}
			}
			else
			{
				UI_HelpScreen.pageToShow = helpScreen;			
				UI.StartTransition("helpscreen");				
			}
		}
		
		
		
		function AddLevel(inst:UIX_Instance,index:int,mission:int)
		{
			var m:Mission = Missions.GetMission(mission);
			var ml:MissionLevel = m.missionLevels[index];
			
			var linst:UIX_Instance = inst.Child("level" + index);
			linst.userData.missionIndex = mission;
			linst.userData.missionLevelIndex = index;
			linst.userData.levelIndex = (mission * 4) + index;

			//var level:Level = Levels.GetLevel(linst.userData.levelIndex);
			
			
			
			var trophy:UIX_Instance = linst.Child("trophy");
			var newicon:UIX_Instance = linst.Child("newicon");
			var lock:UIX_Instance = linst.Child("lock");
			var textInfo:UIX_Instance = linst.Child("textInfo");
			var icon:UIX_Instance = linst.Child("icon");
			
			icon.visible = false;
			
			textInfo.SetText(m.missionLevels[index].levelName+": "+m.missionLevels[index].name);
			
			
			trophy.visible = false;
			if (ml.complete)
			{
				trophy.visible = true;
			}

			if (Game.usedebug)
			{
				//UIX.AddAnimatedButton(linst, UIX_LevelPressed, null, false);		
				
			}
			
			lock.visible = true;
			if (true)	//level.available)
			{
				lock.visible = false;
				UIX.AddAnimatedButton(linst, UIX_LevelPressed, null, false);		

			}
			
			/*
			newicon.visible = false;
			if (level.newlyAvailable)
			{
				newicon.visible = true;
				pageInst.gameObjects.AddInstance(newicon).InitWobble();

			}
			*/
			
			
		}
		
		function AddMatchesOld()
		{
			// Actually Matches are Missions. Not gonna be confusing at all.
			
			
			var numMissions:int = Missions.GetNumMissions();
			
			if (numMissions > matchesList.length) numMissions = matchesList.length;
			
			for (var i:int = 0; i < numMissions; i++)
			{
				pageInst.AddDynamicInstanceFromXML(matchesList[i]);
			}

			if (PROJECT::isGamePad == false)
			{
				pageInst.AddDynamicInstanceFromXML(leftArrowXML);
				pageInst.AddDynamicInstanceFromXML(rightArrowXML);
			
				pageInst.Child("pageLeft").x = 0 +10;
				pageInst.Child("pageRight").x = Defs.displayarea_w -40;
				
				UIX.AddAnimatedButton(pageInst.Child("pageLeft"), leftPressed);
				UIX.AddAnimatedButton(pageInst.Child("pageRight"), rightPressed);
			}
			
			

			matchInstList = new Array();
			for (var i:int = 0; i < numMissions; i++)
			{
				var id:int = i + 1;
				var inst:UIX_Instance = pageInst.Child("icon" + id);
				
				matchInstList.push(inst);
				
//				inst.renderFunction = RenderMission;
				
				inst.userData.pageIndex = i;
				
				var m:Mission = Missions.GetMission(i);
				
				AddLevel(inst, 0,i);
				AddLevel(inst, 1,i);
				AddLevel(inst, 2,i);
				AddLevel(inst, 3,i);
				
				
				//inst.Child("text_matchName").SetText(m.name);
				inst.Child("textMissionName").SetText(m.name);
				
				
				inst.x = 120+150 + (i * 600);
				inst.y = 262;
				
				var go:UIX_GameObj;
				//go = UIX_GameObjects.AddInstance(inst);
				//go.InitAppear(UIX_GameObj.EDGE_NONE,Number(i*0.5));
				
				
			}
		}

//		function RenderMission(inst:UIX_Instance, _frame:int, _bd:BitmapData, _m:Matrix3D, _colorTransform:ColorTransform)
//		{
//			trace("rendermission");
//			var comp:UIX_Component = inst.component;
//			comp.dobj.RenderAtMatrix3D(comp.frame-1 + _frame, _bd, _m, _colorTransform);
//		}

		function UIX_buttonBackPressed(inst:UIX_Instance)
		{
			SaveData.Save();			
			if (Game.isWildTangent)
			{
				UI.StartTransition("title");
				return;
			}
			UI.StartTransition("playerselect");
			
		}
		
//_-----------------------------------------------------------------------------------------------------		
//_-----------------------------------------------------------------------------------------------------		
		
		
		public override function InitScreen()
		{
			InitScreenUIX();
			return;
			
		}
		
		
		
		
		
	}


}