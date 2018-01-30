
package UIPackage  
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import AnimPackage.AnimDefinitions;
	import AudioPackage.Audio;
	import EditorPackage.EditMode_ObjCol;
	import EditorPackage.EdObj;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.ui.Mouse;
	import LicPackage.AdMediator;
	import LicPackage.Lic;
	import MissionPackage.Mission;
	import MissionPackage.Missions;
	import MobileSpecificPackage.MobileSpecific;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_PlayerSelect extends UIScreenInstance
	{
		
		public function UI_PlayerSelect() 
		{
			
		}

		public override function ExitScreen()
		{
			ExitScreenUIX();
		}
		function ExitScreenUIX()
		{
			UIX.StopPage(titleMC,pageInst);
		}
		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			titleMC = new MovieClip();
			uix_pageName = "page_playerselect";
			pageInst = UIX.StartPage(titleMC, uix_pageName);
						
			GameVars.UnlockGenericContent(0);
			
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), UIX_buttonBackPressed);			
			UIX.SetHardwareBackButton(pageInst.Child("btn_back"));			
			
			
//			UIX_InitPage();
//			UIX_PopulatePage();
			
			pageInst.Child("text_levelInfo2").SetText("");
			
			UIX.AddGeneric(pageInst.Child("generic"));
			
			
			for (var i:int = 0; i < numPerPage; i++)
			{
				var inst:UIX_Instance = pageInst.Child("icon" + int(i + 1));
				inst.userData.playerIndex = i;
				
				var lock:UIX_Instance = inst.Child("lock");
				lock.visible = false;
				if (GameVars.GenericContentLocked(i))
				{
					lock.visible = true;
				}
				
				UIX.AddAnimatedButton(inst, UIX_buttonPlayerPressed);	
				
				
				
				inst.frame = i;
			}

			pageInst.gameObjects.Update();
			

		}
		
		var numPerPage:int = 3;
		var icons:Array;
		
		
		function UIX_buttonPlayerPressed(inst:UIX_Instance)
		{
			GameVars.playerCharIndex = inst.userData.playerIndex;
			AnimDefinitions.ReInit(GameVars.playerCharIndex)

			
			SaveData.Save();			
			
//			AdMediator.ShowRewardAd();

			if (GameVars.GenericContentLocked(GameVars.playerCharIndex))
			{			
				UI_UnlockContent.global_content_index = GameVars.playerCharIndex;
				UI.StartTransition("unlockcontent",null,"playerselect");				
			}
			else
			{
				UI.StartTransition("matchselect");
			}
		}
		function UIX_buttonBackPressed(inst:UIX_Instance)
		{

			SaveData.Save();			
			UI.StartTransition("title");
		}
		function UIX_buttonHaddockPressed(inst:UIX_Instance)
		{
			trace("haddock");
			GameVars.useFeature1 = UIX.GetTickButtonState(inst);
			SaveData.Save();			
		}
		
		
		function UIX_InitPage()
		{
			icons = new Array();
			
			
			for (var i:int = 0; i < numPerPage; i++)
			{
				
				var inst:UIX_Instance = pageInst.Child("icon" + int(i + 1));
				
//				inst.x = x;
//				inst.y = y;
//				inst.scaleX = 1.0;
//				inst.scaleY = 1.0;
				
				var carIndex:int = 0;
				
				inst.Child("cars").frame =i;
				inst.Child("blackCars").frame =i;
				

				inst.Child("cars").visible = true;
				inst.Child("blackCars").visible = false;
				
				if (false)	//Game.usedebug)
				{
					UIX.AddAnimatedButton(inst, UIX_LevelPressed, null, false);	// , UIX_LevelHovered);		
					
				}
				else
				{
				
					if (i > GameVars.upgradeLevels[0])
					{
						inst.Child("cars").visible = false;
						inst.Child("blackCars").visible = true;
					}
					else
					{
					
						UIX.AddAnimatedButton(inst, UIX_LevelPressed, null, false);	// , UIX_LevelHovered);							
					}
				}
				
				icons.push(inst);
				
				
//				var go:UIX_GameObj;
//				go = UIX_GameObjects.AddInstance(inst);
//				go.InitAppear(UIX_GameObj.EDGE_NONE,Number(i*0.5));
				
			}
		}
		
		function UIX_PopulatePage()
		{
//			pageInst.Child("prevPage").visible = true;
//			pageInst.Child("nextPage").visible = true;
//			if(currentPage == 0) pageInst.Child("prevPage").visible = false;
//			if(currentPage == numPages-1) pageInst.Child("nextPage").visible = false;
			
			var m:Mission = Missions.GetMission(GameVars.currentMatchIndex);
			
			var l0:int = 0;
			var l1:int = l0 + (numPerPage-1);
			
			var inst:UIX_Instance;
			
			var index:int = 0 ;
			for (var i:int = l0; i <=l1; i++)
			{
				inst = icons[index];
				inst.visible = false;
					
				inst.visible = true;
				inst.userData.playerIndex = i;
				//mc.levelNumber.text = int(i + 1).toString();
				//inst.Child("levelNumber").SetText(int( (i-l0) + 1).toString());

					inst.button_canPress = true;
				
				index++;
				
			}
			
		}
		
		function UIX_LevelHovered(inst:UIX_Instance)
		{
			var playerIndex:int = inst.userData.playerIndex;
			
			pageInst.Child("text_levelInfo2").SetText("Use car "+playerIndex.toString());
			
		}
		
		function UIX_LevelPressed(inst:UIX_Instance)
		{		
			var playerIndex:int = inst.userData.playerIndex;
			GameVars.playerBikeDefIndex = playerIndex;
			
			var helpScreen:int = -1;	// GameVars.GetHelpScreenForThisLevelIndex(Levels.currentIndex);
			
			if (helpScreen == -1)
			{
				UI.StartTransition("gamescreen");				
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
		
		
	}

}

/*
package UIPackage  
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import AnimPackage.AnimDefinition;
	import AnimPackage.AnimDefinitions;
	import AudioPackage.Audio;
	import EditorPackage.EditMode_ObjCol;
	import EditorPackage.EdObj;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.ui.Mouse;
	import LicPackage.AdMediator;
	import LicPackage.Lic;
	import MissionPackage.Mission;
	import MissionPackage.Missions;
	import MobileSpecificPackage.MobileSpecific;
	import TextPackage.TextStrings;
	public class UI_PlayerSelect extends UIScreenInstance
	{
		
		public function UI_PlayerSelect() 
		{
			
		}

		public override function ExitScreen()
		{
			ExitScreenUIX();
		}
		function ExitScreenUIX()
		{
			UIX.StopPage(titleMC,pageInst);
		}
		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			titleMC = new MovieClip();
			uix_pageName = "page_playerselect";
			pageInst = UIX.StartPage(titleMC, uix_pageName);
						
			
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), UIX_buttonBackPressed);			
			
//			UIX_InitPage();
//			UIX_PopulatePage();
			
			pageInst.Child("text_levelInfo2").SetText("");
			
			UIX.AddGeneric(pageInst.Child("generic"));
			
			
			for (var i:int = 0; i < numPerPage; i++)
			{
				var inst:UIX_Instance = pageInst.Child("icon" + int(i + 1));
				inst.userData.playerIndex = i;
				
				var lock:UIX_Instance = inst.Child("lock");
				lock.visible = false;
				if (GameVars.GenericContentLocked(i))
				{
					lock.visible = true;
				}
				
				UIX.AddAnimatedButton(inst, UIX_buttonPlayerPressed);			
				inst.frame = i;
			}

			pageInst.gameObjects.Update();
			

		}
		
		var numPerPage:int = 3;
		var icons:Array;
		
		
		function UIX_buttonPlayerPressed(inst:UIX_Instance)
		{
			GameVars.playerCharIndex = inst.userData.playerIndex;
			
			AnimDefinitions.ReInit(GameVars.playerCharIndex)
			
			SaveData.Save();			
			
//			AdMediator.ShowRewardAd();

			if (GameVars.GenericContentLocked(GameVars.playerBikeDefIndex))
			{			
				UI_UnlockContent.global_content_index = GameVars.playerCharIndex;
				UI.StartTransition("unlockcontent",null,"playerselect");				
			}
			else
			{
				UI.StartTransition("matchselect");
			}
		}
		function UIX_buttonBackPressed(inst:UIX_Instance)
		{

			SaveData.Save();			
			UI.StartTransition("title");
		}
		function UIX_buttonHaddockPressed(inst:UIX_Instance)
		{
			trace("haddock");
			GameVars.useFeature1 = UIX.GetTickButtonState(inst);
			SaveData.Save();			
		}
		
		
		function UIX_InitPage()
		{
			icons = new Array();
			
			
			for (var i:int = 0; i < numPerPage; i++)
			{
				
				var inst:UIX_Instance = pageInst.Child("icon" + int(i + 1));
				
//				inst.x = x;
//				inst.y = y;
//				inst.scaleX = 1.0;
//				inst.scaleY = 1.0;
				
				var carIndex:int = 0;
				
				inst.Child("cars").frame =i;
				inst.Child("blackCars").frame =i;
				

				inst.Child("cars").visible = true;
				inst.Child("blackCars").visible = false;
				
				if (false)	//Game.usedebug)
				{
					UIX.AddAnimatedButton(inst, UIX_LevelPressed, null, false);	// , UIX_LevelHovered);		
					
				}
				else
				{
				
					if (i > GameVars.upgradeLevels[0])
					{
						inst.Child("cars").visible = false;
						inst.Child("blackCars").visible = true;
					}
					else
					{
					
						UIX.AddAnimatedButton(inst, UIX_LevelPressed, null, false);	// , UIX_LevelHovered);							
					}
				}
				
				icons.push(inst);
				
				
//				var go:UIX_GameObj;
//				go = UIX_GameObjects.AddInstance(inst);
//				go.InitAppear(UIX_GameObj.EDGE_NONE,Number(i*0.5));
				
			}
		}
		
		function UIX_PopulatePage()
		{
//			pageInst.Child("prevPage").visible = true;
//			pageInst.Child("nextPage").visible = true;
//			if(currentPage == 0) pageInst.Child("prevPage").visible = false;
//			if(currentPage == numPages-1) pageInst.Child("nextPage").visible = false;
			
			var m:Mission = Missions.GetMission(GameVars.currentMatchIndex);
			
			var l0:int = 0;
			var l1:int = l0 + (numPerPage-1);
			
			var inst:UIX_Instance;
			
			var index:int = 0 ;
			for (var i:int = l0; i <=l1; i++)
			{
				inst = icons[index];
				inst.visible = false;
					
				inst.visible = true;
				inst.userData.playerIndex = i;
				//mc.levelNumber.text = int(i + 1).toString();
				//inst.Child("levelNumber").SetText(int( (i-l0) + 1).toString());

					inst.button_canPress = true;
				
				index++;
				
			}
			
		}
		
		function UIX_LevelHovered(inst:UIX_Instance)
		{
			var playerIndex:int = inst.userData.playerIndex;
			
			pageInst.Child("text_levelInfo2").SetText("Use car "+playerIndex.toString());
			
		}
		
		function UIX_LevelPressed(inst:UIX_Instance)
		{		
			var playerIndex:int = inst.userData.playerIndex;
			GameVars.playerBikeDefIndex = playerIndex;
			
			var helpScreen:int = -1;	// GameVars.GetHelpScreenForThisLevelIndex(Levels.currentIndex);
			
			if (helpScreen == -1)
			{
				UI.StartTransition("gamescreen");				
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
		
		
	}

}

*/