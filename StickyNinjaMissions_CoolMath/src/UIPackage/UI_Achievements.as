package UIPackage 
{
	import AchievementPackage.Achievement;
	import AchievementPackage.Achievements;
	import AchievementPackage.Leaderboards;
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
	public class UI_Achievements extends UIScreenInstance
	{
		
		public function UI_Achievements() 
		{
			
		}

		function InitScreenUIX()
		{
			Audio.PlayMusic("menus_music");
			
			titleMC = new MovieClip();
			uix_pageName = "page_achievements";
			pageInst = UIX.StartPage(titleMC, uix_pageName);
						
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), buttonBackPressed);	
			UIX.AddAnimatedButton(pageInst.Child("buttonAwards"), buttonAwardsPressed);	
			UIX.AddAnimatedButton(pageInst.Child("buttonStats"), buttonStatsPressed);	
			UIX.AddAnimatedButton(pageInst.Child("prev"), buttonPageBackPressed);	
			UIX.AddAnimatedButton(pageInst.Child("next"), buttonPageNextPressed);	
			
			currentPage = 0;
			
			pageInst.Child("bg").renderFunction = RenderBG;

			
			// add awards components
			
			for (var i:int = 0; i < numPerPage; i++)
			{
				pageInst.AddDynamicInstanceFromXML(x0,"ach" + i);
				pageInst.AddDynamicInstanceFromXML(x1,"achtext" + i);
				pageInst.AddDynamicInstanceFromXML(x2,"achdesc" + i);
				pageInst.AddDynamicInstanceFromXML(x3,"achtick" + i);
			}
			var y:Number = 100;
			var x:Number = 50;
			
			achInstances = new Array();
			
			for (var i:int = 0; i < numPerPage; i++)
			{
				var ach:Achievement = Achievements.GetAchievementByIndex(i);
				
				var i0:UIX_Instance = pageInst.Child("ach" + i);
				i0.x = x;
				i0.y = y;
				var i1:UIX_Instance = pageInst.Child("achtext" + i);
				i1.x = x+210;
				i1.y = y;
				i1.SetText(ach.name+" :");
				var i2:UIX_Instance = pageInst.Child("achdesc" + i);
				i2.x = x+250;
				i2.y = y;
				var i3:UIX_Instance = pageInst.Child("achtick" + i);
				i3.x = x+16;
				i3.y = y+20;
				achInstances.push(i0, i1, i2, i3);
				y += 40;
			}

			mode = 1;	// awards
		}
		
		var achInstances:Array;
		
		var x0:XML = <instance component="Component_UI_Award_Box" pos="120, 100, 0" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon1, uix_text= , uix_textscale=1,uix_textalign=centre" />
		var x1:XML = <instance component="Component_Text" pos="120, 100, -10" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon1, uix_text=asdkajghdkajsdh , uix_textscale=1,uix_textalign=right" />
		var x2:XML = <instance component="Component_Text" pos="120, 100, -10" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon1, uix_text=asdkajghdkajsdh , uix_textscale=1,uix_textalign=left" />
		var x3:XML = <instance component="Component_ButtonInner_TickCross" pos="120, 100, -20" scale="1, 1" rot="0" alpha="1" color="0.0.0" textparent="0" params="uix_instancename=icon1, uix_text= , uix_textscale=1,uix_textalign=centre" />
		
		
		var mode:int;
		
		var numPerPage:int = 10;
		var numPages:int = 3;
		var currentPage:int = 0;
		
		function SetAchVisible(yes:Boolean)
		{
			for each(var inst:UIX_Instance in achInstances)
			{
				inst.visible = yes;
			}
			if (yes)
			{
				pageInst.Child("next").blackout = false;
				pageInst.Child("next").button_canPress = true;
				pageInst.Child("prev").blackout = false;
				pageInst.Child("prev").button_canPress = true;
			}
			else
			{
				pageInst.Child("next").blackout = true;
				pageInst.Child("next").button_canPress = false;
				pageInst.Child("prev").blackout = true;
				pageInst.Child("prev").button_canPress = false;
			}
		}
		
		
		function RenderBG(_inst:UIX_Instance,_frame:int, screenBD:BitmapData, m:Matrix3D,ct:ColorTransform)
		{
			// render parent
			_inst.component.dobj.RenderAtMatrix3D(_inst.component.frame-1 + _frame, screenBD, m, ct);

			if (mode == 0)	// stats
			{
				SetAchVisible(false);
				var x0:Number = Defs.displayarea_w2-20;
				var x1:Number = Defs.displayarea_w2+20;
				var y:Number = 100;
				for (var i:int = 0; i < Stats.GetCount(); i++)
				{
					TextRenderer.RenderAt(0,screenBD, x0, y, Stats.GetNameString(i),0,1,TextRenderer.JUSTIFY_RIGHT);
					TextRenderer.RenderAt(0,screenBD, x1, y, Stats.GetValueString(i),0,1,TextRenderer.JUSTIFY_LEFT);
					y += 30;
				}
			}
			
			if (mode == 1)	// achievements
			{
				SetAchVisible(true);
				
				
				for (var i:int = 0; i < numPerPage; i++)
				{
					var ach:Achievement = Achievements.GetAchievementByIndex(i+(numPerPage * currentPage));
					var i0:UIX_Instance = pageInst.Child("ach" + i);
					var i1:UIX_Instance = pageInst.Child("achtext" + i);
					i1.SetText(ach.name+" :");
					var i2:UIX_Instance = pageInst.Child("achdesc" + i);
					i2.SetText(ach.toUnlockText);
					var i3:UIX_Instance = pageInst.Child("achtick" + i);
					i3.frame = 1;
					if (ach.complete) i3.frame = 0;
				}
				
//				pageInst.Child("buttonPage").SetText("Page " + int(currentPage + 1).toString() + "/" + numPages);
			}
			
			return;
			
			if (scores == null) return;

			var num:int = scores.length;
			if (num == 0) return;
			if (num > 20) num = 20;
			
			var x:Number = 400;
			var y:Number = 50;
			
			for (var i:int = 0; i < num; i++)
			{
				
				var s:String = Utils.GetCardinalString(i)+": "+scores[i].Score.score;
				
				TextRenderer.RenderAt(0,screenBD, x, y, s);
				
				y += 25;
			}
			
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

		
		function buttonStatsPressed(inst:UIX_Instance):void
		{
			mode = 0;
		}
		function buttonPageBackPressed(inst:UIX_Instance):void
		{
			currentPage--;
			if (currentPage < 0) currentPage = numPages - 1;
		}
		function buttonPageNextPressed(inst:UIX_Instance):void
		{
			currentPage++;
			if (currentPage >= numPages) currentPage = 0;			
		}
		function buttonAwardsPressed(inst:UIX_Instance):void
		{
			mode = 1;
			
		}
		
		function buttonBackPressed(inst:UIX_Instance):void
		{
			UI.StartTransition("levelcomplete");
		}
		
	}

}