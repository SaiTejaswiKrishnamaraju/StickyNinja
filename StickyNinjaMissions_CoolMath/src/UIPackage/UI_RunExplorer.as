package UIPackage 
{
	import AudioPackage.Audio;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import LicPackage.Lic;
	import PlayerRecordPackage.PlayerRecording;
	import PlayerRecordPackage.PlayerRecordings;
	import TextPackage.TextRenderer;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_RunExplorer extends UIScreenInstance
	{
		
		public function UI_RunExplorer() 
		{
			
		}

		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			
			titleMC = new MovieClip();
			uix_pageName = "page_run_explorer";
			pageInst = UIX.StartPage(titleMC, uix_pageName);
						
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), buttonBackPressed);	
			UIX.AddAnimatedButton(pageInst.Child("test1"), buttonTest1Pressed);	
			UIX.AddAnimatedButton(pageInst.Child("test2"), buttonTest2Pressed);	
			UIX.AddAnimatedButton(pageInst.Child("test3"), buttonTest3Pressed);	
			UIX.AddAnimatedButton(pageInst.Child("test4"), buttonTest4Pressed);	
			
			UIX.AddAnimatedButton(pageInst.Child("test5"), buttonShowAllPressed);	
			UIX.AddAnimatedButton(pageInst.Child("test6"), buttonSortByLevelPressed);	
			
			pageInst.gameObjects.AddInstance(pageInst.Child("btn_back")).InitAppear(UIX_GameObj.EDGE_TOP, 0);
			
			pageInst.Child("bg").renderFunction = RenderLists;
		
			currentIndex = 0;
			canPress = true;
			
			mode = 0;	// show all
			levelIndex = 0;
		}
		
		var canPress:Boolean = true;
		var currentIndex:int;
		var mode:int = 0;
		var levelIndex:int = 0;
		
		
		function GetCurrentDisplayList():Array
		{
			var displayList:Array = new Array();
			if (mode == 0)	// all
			{
				for each(var pr:PlayerRecording in PlayerRecordings.serverTrackRaceDataList)
				{
					displayList.push(pr.Clone());
				}
			}
			else
			{
				for each(var pr:PlayerRecording in PlayerRecordings.serverTrackRaceDataList)
				{
					if (pr.levelID == Levels.GetLevel(levelIndex).id )
					{
						displayList.push(pr.Clone());
					}
				}				
			}
			return displayList;
		}
		
		function RenderLists(_inst:UIX_Instance,_frame:int, screenBD:BitmapData, m:Matrix3D,ct:ColorTransform)
		{
			// render parent
			_inst.component.dobj.RenderAtMatrix3D(_inst.component.frame-1 + _frame, screenBD, m, ct);
			
			
			
			if (PlayerRecordings.serverTrackRaceDataList == null) return;
			if (PlayerRecordings.serverTrackRaceDataList.length == 0) return;

			var x:Number = 200;
			var y:Number = 50;

			var displayList:Array = GetCurrentDisplayList();
			if (displayList.length == 0) return;
			
			var totalTime:int = 0;
			
			var i:int = 0;
			for each(var pr:PlayerRecording in displayList)
			{
				pr.time = pr.list.length;

				var s:String = "dbid:" + pr.db_id + "  levelid:" + pr.levelID + "  carID:" + pr.bike_id + "  time= " + Utils.CounterToMinutesSecondsMilisecondsString(pr.time);
				
				totalTime += pr.time;
				
				if (i == currentIndex)
				{
					s = "---->" + s;
				}
				TextRenderer.RenderAt(0,screenBD, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
				
				y += 25;
				i++;
			}
			
			y += 30;
			var atime:int = totalTime / displayList.length;
			var s:String = "average time= " + Utils.CounterToMinutesSecondsMilisecondsString(atime);
			TextRenderer.RenderAt(0,screenBD, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
			

			
		}
		function buttonShowAllPressed(inst:UIX_Instance):void
		{
			mode = 0;
			pageInst.Child("text1").SetText("All runs");
			currentIndex = 0;
		}
		function buttonSortByLevelPressed(inst:UIX_Instance):void
		{
			mode = 1;
			levelIndex++;
			if (levelIndex >= Levels.list.length)
			{
				levelIndex = 0;
			}
			currentIndex = 0;
			pageInst.Child("text1").SetText("Only Showing Level ID:" +Levels.GetLevel(levelIndex).id);
		}
		
		
		function buttonTest4Pressed(inst:UIX_Instance):void
		{
			if (canPress == false) return;
			if (PlayerRecordings.serverTrackRaceDataList == null) return;
			if (PlayerRecordings.serverTrackRaceDataList.length == 0) return;
			
			var displayList:Array = GetCurrentDisplayList();

			
			if (currentIndex < 0) return;
			if (currentIndex >= displayList.length) return;
			var pr:PlayerRecording =displayList[currentIndex];
			if (pr == null) return;
			trace("DELETING db id " + pr.db_id);
			
			canPress = false;
			PlayerRecordings.DeleteRunByID(pr.db_id,buttonTest4Pressed_cb);
		}
		function buttonTest4Pressed_cb()
		{
			PlayerRecordings.GetAllRaceData(GetAllRaceDataCB);
		}
		
		function buttonTest3Pressed(inst:UIX_Instance):void
		{
			if (canPress == false) return;
			if (PlayerRecordings.serverTrackRaceDataList == null) return;
			if (PlayerRecordings.serverTrackRaceDataList.length == 0) return;
			currentIndex++;
			if (currentIndex >= PlayerRecordings.serverTrackRaceDataList.length) currentIndex = 0;
		}
		function buttonTest1Pressed(inst:UIX_Instance):void
		{
			if (canPress == false) return;
			canPress = false;
			PlayerRecordings.GetAllRaceData(GetAllRaceDataCB);
		}
		function GetAllRaceDataCB()
		{
			trace("GetAllRaceDataCB done");
			
			canPress = true;
		}
		
		
		function buttonTest2Pressed(inst:UIX_Instance):void
		{
			if (canPress == false) return;
			PlayerRecordings.GetAllRaceData(SaveAllRaceDataCB);
		}
		
		static function SaveAllRaceDataCB()
		{
			var levelID:String = Levels.GetCurrent().id;
			var a:Array = new Array();
			for each(var pr:PlayerRecording in PlayerRecordings.serverTrackRaceDataList)
			{
				a.push(pr.db_id);
			}
			if (a.length != 0)
			{
				PlayerRecordings.LoadRaceDataFromServer_IDArray(a, SaveAllRaceDataCB_loadedRunsCB);
			}
			
		}
		static function SaveAllRaceDataCB_loadedRunsCB()
		{
			var s:String = "";
			var index:int = 0;
			
			PlayerRecordings.SaveRunsToBinary();
			
		}
		
		
		
		
		function ExitScreenUIX()
		{
			UIX.StopPage(titleMC,pageInst);
		}		
		
		public override function ExitScreen()
		{
			ExitScreenUIX();
		}
		public override function InitScreen()
		{
			InitScreenUIX();
		}

		
		function buttonLayoutPressed(inst:UIX_Instance):void
		{
			GameVars.CurrentControlLayoutIndex = inst.userData.index;
			trace(GameVars.CurrentControlLayoutIndex);
			UI.StartTransition("title");			
		}
		function buttonBackPressed(inst:UIX_Instance):void
		{
			UI.StartTransition("title");
		}
		
	}

}