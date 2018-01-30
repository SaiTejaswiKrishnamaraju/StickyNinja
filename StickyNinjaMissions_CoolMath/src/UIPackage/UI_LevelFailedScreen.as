package UIPackage
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import AudioPackage.Audio;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.ui.Mouse;
	import LicPackage.AdHolder;
	import LicPackage.AdMediator;
	import LicPackage.Lic;
	import LicPackage.LicCoolmath;
	import LicPackage.LicDef;
	import MissionPackage.MissionLevel;
	import MissionPackage.MissionObjective;
	import MissionPackage.Missions;
	import MissionPackage.MissionType;
	import MobileSpecificPackage.MobileSpecific;
	import PlayerRecordPackage.PlayerRecordings;
	import TextPackage.TextStrings;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_LevelFailedScreen extends UIScreenInstance
	{
		
		public function UI_LevelFailedScreen() 
		{
			
		}
		public override function ExitScreen()
		{
//			GameVars.useFeature1 = UIX.GetTickButtonState(pageInst.Child("feature1"));
//			GameVars.useFeature2 = UIX.GetTickButtonState(pageInst.Child("feature2"));
//			GameVars.useFeature3 = UIX.GetTickButtonState(pageInst.Child("feature3"));
//			GameVars.useFeature4 = UIX.GetTickButtonState(pageInst.Child("feature4"));
			
			var adbox:UIX_Instance = pageInst.Child("adBox");
			if (AreOtherGamesAdsAllowed())
			{
				adbox.RemoveMovieClipDisplayChild();
			}

			UIX.StopPage(titleMC, pageInst);
			
		}
		public override function InitScreen()
		{
			Audio.PlayMusic("menus_music");
			titleMC = new MovieClip();
			uix_pageName = "page_levelfailed";
			pageInst = UIX.StartPage(titleMC,uix_pageName);
			
//			pageInst.preUpdateFunction = PreUpdate;
			
//			UIX.AddAnimatedButton(pageInst.Child("submitRun"), UIX_buttonSubmit);			
			
			
			UIX.AddAnimatedButton(pageInst.Child("btn_tryagain"), UIX_buttonRetryPressed);			
			UIX.AddAnimatedButton(pageInst.Child("btn_continue"), UIX_buttonNextPressed);			
//			UIX.AddAnimatedButton(pageInst.Child("buttonLevelSelect"), UIX_buttonMenuPressed);		

			UIX.AddAnimatedButton(pageInst.Child("buttonAwards"), UIX_buttonAchievementsPressed);	

			UIX.AddGeneric(pageInst.Child("generic"));

			
			var container:UIX_Instance = pageInst.Child("container");
			var adbox:UIX_Instance = pageInst.Child("adBox");
			if (AreOtherGamesAdsAllowed())
			{
				adbox.AddMovieClipDisplayChild(AdHolder.GetAd(),0,0);
			}
			else
			{
				adbox.visible = false;
				container.x = 400;
			}
			
			var l:Level = Levels.GetCurrent();
						
			
			var textList:Vector.<UIX_Instance> = new Vector.<UIX_Instance>();
			textList.push(pageInst.Child("container.text1"));
			textList.push(pageInst.Child("container.text2"));
			textList.push(pageInst.Child("container.text3"));
			textList.push(pageInst.Child("container.text4"));
			textList.push(pageInst.Child("container.text5"));
			textList.push(pageInst.Child("container.text6"));
			textList.push(pageInst.Child("container.text7"));
			textList.push(pageInst.Child("container.text8"));

			for each(var inst:UIX_Instance in textList)
			{
				inst.SetText("");
			}
			
			textList[0].SetText("MISSION FAILED!");
			
				
			var ml:MissionLevel = Missions.GetCurrentMissionLevel();
			var s:String;

			var levelAward:int = ml.result;
			
			var s:String = "";
			if (Game.levelFailReason == "lives") s = "YOU RAN OUT OF LIVES";
			if (Game.levelFailReason == MissionType.TIME) s = "YOU RAN OUT OF TIME";
			if (Game.levelFailReason == MissionType.STEALTH) s = "YOU KILLED AN ENEMY";
			if (Game.levelFailReason == MissionType.COMBOKILLS) s = "YOU KILLED AN ENEMY WITHOUT A COMBO";
			if (Game.levelFailReason == MissionType.HEALTH) s = "YOU LOST SOME HEALTH";
			
			
			textList[1].SetText("");
			textList[2].SetText(s);
			textList[3].SetText("");
			textList[4].SetText("");
			textList[5].SetText("Try Again");
			textList[6].SetText("");
			textList[7].SetText("");
			
			
			pageInst.gameObjects.Update();
			
			renderX = 0;
			
			pageInst.gameObjects.AddInstance(pageInst.Child("background")).InitTitle_Background();
			
			pageInst.gameObjects.AddInstance(pageInst.Child("container")).InitLevelCompleteContainer(0);
			
			var i:int = 0;
			for each(var inst:UIX_Instance in textList)
			{
				pageInst.gameObjects.AddInstance(inst).InitLevelCompleteText(1,i);
				i++;
			}
			
			cashCount = GameVars.levelCash;
			scoreCount = GameVars.levelScore;
			
			AdMediator.Update();

		}
		
		var cashCount:int;
		var scoreCount:int;
		
		
		function UIX_buttonSubmit(inst:UIX_Instance)
		{
			inst.visible = false;
			
			PlayerRecordings.SubmitRecording(GameVars.playerGO.playerRecording);
		}
		
		var renderX:Number = 0;
		function RenderBackgroundInstance(_inst:UIX_Instance,_frame:int, screenBD:BitmapData, m:Matrix3D,ct:ColorTransform)
		{
			
			var scale:Number = (525-270) / 512;		// 270 being the height
			
			
			renderX = 0;
			
			
			for (var i:int = 0; i < 3; i++)
			{
				m.identity();
				m.appendScale(scale,scale, 1);
				m.appendTranslation(_inst.x, _inst.y, 0);
			
				var x:Number = (Game.backDOF.sourceRect.width * scale) * i;
				x -= i;
				
				m.appendTranslation( x, 0, 0);
				m.appendTranslation( -renderX, 0, 0);
				
				//trace("my render x"+x+"  "+scale+"   "+);
				
				Game.backDOF2.RenderAtMatrix3D(screenBD, m, ct);
				Game.backDOF.RenderAtMatrix3D(screenBD, m, ct);
			}
			

		}
		
		function UIX_buttonAchievementsPressed(inst:UIX_Instance)
		{
			UI.StartTransition("achievements");			
		}
		
		function UIX_buttonNextPressed(inst:UIX_Instance)
		{				
			UI.StartTransition("matchselect");				
			return;
			
			if (PROJECT::isGamePad)
			{
				if(Game.full_version_unlocked == false)
				{
					UI.StartTransition("purchase_ouya");
					return;
				}
			}
			
			
			GameVars.nextScreenName = "shop";
			
			if (Game.newMatchUnlocked)
			{
				GameVars.nextScreenName = "matchcomplete";
			}
			if ( (GameVars.currentOrderedLevelIndex == Levels.list.length-1) && (GameVars.playerFinalPosition == 0) )
			{
				GameVars.nextScreenName = "gamecomplete";
			}
			if (PROJECT::isMobile && PROJECT::isGamePad==false)
			{
				if (Game.ad_free_unlocked == false)
				{
					UI.StartTransition("intersitialad");				
				}
				else
				{
					UI.StartTransition(GameVars.nextScreenName);
				}
			}
			else
			{
				UI.StartTransition(GameVars.nextScreenName);				
			}
		}
		function UIX_buttonRetryPressed(inst:UIX_Instance)
		{		
			if (PROJECT::isGamePad)
			{
				if(Game.full_version_unlocked == false)
				{
					UI.StartTransition("purchase_ouya");
					return;
				}
			}
			
			LicCoolmath.RestartPressed(Missions.currentMissionIndex, Missions.currentMissionLevelIndex);
			
			UI.StartTransition("gamescreen");
		}
		function UIX_buttonMenuPressed(inst:UIX_Instance)
		{		
			UI.StartTransition("matchselect");
		}
		function UIX_buttonShopPressed(inst:UIX_Instance)
		{		
			UI.StartTransition("shop");
		}
		
		
//----------------------------------------------------------------------------------------------------------		
		function AreOtherGamesAdsAllowed():Boolean
		{
			if (PROJECT::useStage3D)
			{
				return false;
			}
			return LicDef.AreOtherGamesAdsAllowed();

		}
		
		
	}

}