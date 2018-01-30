package UIPackage  
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import AudioPackage.Audio;
	import EditorPackage.EditMode_ObjCol;
	import EditorPackage.EdObj;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.ui.Mouse;
	import LicPackage.Lic;
	import LicPackage.LicCoolmath;
	import MissionPackage.Mission;
	import MissionPackage.MissionLevel;
	import MissionPackage.Missions;
	import MobileSpecificPackage.MobileSpecific;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_LevelSelect extends UIScreenInstance
	{
		
		static var usePrePlacedLevels:Boolean = true;
		
		public function UI_LevelSelect() 
		{
			
		}

		public override function ExitScreen()
		{
			ExitScreenUIX();
			
			//RemoveListeners();
			//UI.RemoveAllButtons();
			//UI.RemoveGeneric();
		}
		function ExitScreenUIX()
		{
			UIX.StopPage(titleMC,pageInst);
		}
		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			titleMC = new MovieClip();
			uix_pageName = "page_levelselect";
			pageInst = UIX.StartPage(titleMC, uix_pageName);
						
			currentPage = GameVars.currentMatchIndex;
			numPages = (Levels.list.length/numPerPage)+1;
			
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), UIX_buttonBackPressed);			
			UIX.SetHardwareBackButton(pageInst.Child("btn_back"));			
			
			UIX_InitPage();
//			UIX_PopulatePage();
			
			UIX.AddGeneric(pageInst.Child("generic"));
			

			pageInst.InitTimelines();
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
				UI.StartTransition("levelselect");
			}
		}
		
		function UIX_PrevPageClicked(inst:UIX_Instance)
		{
			currentPage--;
			if (currentPage < 0) currentPage = numPages - 1;
			UIX_PopulatePage();
		}
		function UIX_NextPageClicked(inst:UIX_Instance)
		{
			currentPage++;
			if (currentPage >= numPages) currentPage = 0;
			UIX_PopulatePage();			
		}
		function UIX_buttonBackPressed(inst:UIX_Instance)
		{
			SaveData.Save();			
			UI.StartTransition("matchselect");
		}
		
		
		function GetLevelCarIndex(l:Level):int
		{
			var index:int = 0;
			for each(var inst:EdObj in l.instances)
			{
				if (inst.typeName.search("CarStartPoint") != -1) 
				{
					var s:String = inst.typeName.substr(13);
					index = int(s);
				}
			}
			return index;
		}
		
		var icons:Array;
		function UIX_InitPage()
		{
			icons = new Array();

			var m:Mission = Missions.GetCurrentMission();
			
			numPerPage = 6;
			
			for (var i:int = 0; i < numPerPage; i++)
			{
				if (i < m.missionLevels.length)
				{
					var ml:MissionLevel = m.missionLevels[i];
					
					var inst:UIX_Instance = pageInst.Child("icon" + int(i + 1));
					
					inst.userData.levelIndex = i;
					
					var background:UIX_Instance = inst.Child("bg");
					var star:UIX_Instance = inst.Child("star");
					var newicon:UIX_Instance = inst.Child("newicon");
					var lock:UIX_Instance = inst.Child("lock");
					var text:UIX_Instance = inst.Child("textInfo");
					var text1:UIX_Instance = inst.Child("textInfo1");
					var levelImage:UIX_Instance = inst.Child("levelImage");
					
					var l:Level = Levels.GetLevelById( ml.levelName);
					
					text.SetText(ml.name);
					if (text1 != null) text1.SetText("");
//					UIX.AddAnimatedButton(inst, UIX_LevelPressed, null, false);		
					

					
					lock.visible = true;
					if (ml.available)
					{
						lock.visible = false;
					}
					
					if (Game.usedebug || ml.available)
					{
						UIX.AddAnimatedButton(inst, UIX_LevelPressed, null, false, UIX_LevelHovered);		
					}
					
					newicon.visible = false;
					if (ml.newlyAvailable)
					{
						newicon.visible = true;
						pageInst.gameObjects.AddInstance(newicon).InitWobble();

					}
					
					star.frame = 0;
					if (ml.complete) 
					{
						star.frame = 1 + ml.result;
					}
					
					var levelIndex:int = Levels.GetLevelIndexById(ml.levelName);
					
					var eo:EdObj = Levels.GetLevel(levelIndex).GetObjectByType("LevelInfo");
					if (eo)
					{
						levelImage.frame = eo.objParameters.GetValueInt("level_background")-1;
					}
					
					icons.push(inst);
				}
				
			}
		}
		
		function UIX_PopulatePage()
		{
			return;
//			pageInst.Child("prevPage").visible = true;
//			pageInst.Child("nextPage").visible = true;
//			if(currentPage == 0) pageInst.Child("prevPage").visible = false;
//			if(currentPage == numPages-1) pageInst.Child("nextPage").visible = false;
			
			var m:Mission = Missions.GetMission(GameVars.currentMatchIndex);
			
			var l0:int = currentPage * numPerPage;
			var l1:int = l0 + (numPerPage-1);
			
			var inst:UIX_Instance;
			
			var index:int = 0 ;
			for (var i:int = l0; i <=l1; i++)
			{
				inst = icons[index];
				inst.visible = false;
				if (i < Levels.list.length)
				{
					
					var levelName:String = m.levelNames[index];
					var l:Level = Levels.GetLevel(Levels.GetLevelIndexByName(levelName));
					
					inst.visible = true;
					inst.userData.levelID = Levels.GetLevelIndexByName(levelName);
					//mc.levelNumber.text = int(i + 1).toString();
					//inst.Child("levelNumber").SetText(int( (i-l0) + 1).toString());
					inst.Child("levelNumber").frame = 0;	// index;
					
					if (Game.usedebug)
					{
						//mc.textLevelCreator.text = l.creator;
					}
					else
					{
						//mc.textLevelCreator.text = "";
					}
					
					var lll:int = Levels.currentIndex;
					Levels.currentIndex = i;
					GameVars.CalculateNumCoinsInLevel();
					GameVars.CalculateNumLevelCoinsCollected();
					var totalC:int = GameVars.totalLevelCoins;
					var numC:int = GameVars.numLevelCoinsCollected;
					Levels.currentIndex = lll;
						
					var coinPC:int = numC * 100 / totalC;
					
					inst.button_canPress = false;
					
					
					if (l.available)		// always available
					{
						inst.button_canPress = true;
						inst.Child("levelNumber").visible = true;
 						inst.Child("lock").visible = false;
					}
					else
					{
 						inst.Child("lock").visible = true;
						inst.Child("levelNumber").visible = true;
					}
					
					inst.Child("new").visible = false;
					if (l.newlyAvailable)
					{
						inst.Child("new").visible = true;
					}

					
					index++;
				}
				
			}
			
		}
		
		function UIX_LevelHovered(inst:UIX_Instance)
		{
			var levelID:int = inst.userData.levelID;
			selectedLevel = levelID;
			var l:Level = Levels.GetLevel(selectedLevel);

			var s:String = "";
			var eo:EdObj = l.GetObjectByType("LevelInfo");
			if (eo != null)
			{			
			}
			
		}
		
		function UIX_LevelPressed(inst:UIX_Instance)
		{		
			var levelID:int = inst.userData.levelIndex;
			Missions.currentMissionLevelIndex = levelID;
			
			var n:String = Missions.GetCurrentMissionLevel().levelName;
			Levels.currentIndex = Levels.GetLevelIndexById(n);
			
			
			
			
			var helpScreen:int = -1;	// GameVars.GetHelpScreenForThisLevelIndex(Levels.currentIndex);
			
			if (helpScreen == -1)
			{
				if (false)	//Game.record_player)
				{
					UI.StartTransition("playerselect");				
				}
				else
				{
					LicCoolmath.LevelButtonOrContinueButtonPressed(Missions.currentMissionIndex,Missions.currentMissionLevelIndex);

					UI.StartTransition("gamescreen");				
				}
			}
			else
			{
				UI_HelpScreen.pageToShow = helpScreen;			
				UI.StartTransition("helpscreen");				
			}
		}
		
		
		
//_-----------------------------------------------------------------------------------------------------		
//_-----------------------------------------------------------------------------------------------------		
		
		
		public override function InitScreen()
		{
			InitScreenUIX();
			return;
			
		}
		
		var selectedLevel:int;

		var numPages:int;
		var numPerPage:int = 9;
		var currentPage:int;
		
		
		
	}

}