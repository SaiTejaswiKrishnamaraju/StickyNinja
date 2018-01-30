package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import UIPackage.UI;
	/**
	 * ...
	 * @author 
	 */
	public class BikeEditor 
	{
		static var hudMC:MovieClip = null;
		static var active = false;
		static var wheelIndex:int = 0;
		static var totalWheels:int = 9;
		static var totalChars:int = 1;
		static var totalFrames:int = 9;
		
		
		public function BikeEditor() 
		{
			
		}
		
		public static function Update()
		{
			totalChars = 1;	// GameVars.GetNumBikeHierarchies();
			
			var doit:Boolean = false;
			var upPressed:Boolean = false;
			var downPressed:Boolean = false;
			var leftPressed:Boolean = false;
			var rightPressed:Boolean = false;
			
			var adder0:Number = 0;
			var adder1:Number = 0;
			var adder2:Number = 0;
			var adderScale:Number = 0;
			
			if (KeyReader.Pressed(KeyReader.KEY_F8)) 
			{
				SaveBikeDataXML();
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_UP)) 
			{
				upPressed = true;
				doit = true;
			}
			if (KeyReader.Pressed(KeyReader.KEY_DOWN)) 
			{
				downPressed = true;
				doit = true;
			}
			if (KeyReader.Pressed(KeyReader.KEY_LEFT)) 
			{
				leftPressed = true;
				doit = true;
			}
			if (KeyReader.Pressed(KeyReader.KEY_RIGHT)) 
			{
				rightPressed = true;
				doit = true;
			}
			if (KeyReader.Pressed(KeyReader.KEY_W)) 
			{
				wheelIndex = 1 - wheelIndex;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_NUM_7)) 
			{
				adder0 = -0.25;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_NUM_8)) 
			{
				adder0 = 0.25;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_NUM_4)) 
			{
				adder1 = -1;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_NUM_5)) 
			{
				adder1 = 1;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_NUM_1)) 
			{
				adder2 = -0.25;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_NUM_2)) 
			{
				adder2 = 0.25;
				doit = true;
			}
			if (KeyReader.Pressed(KeyReader.KEY_NUM_6)) 
			{
				adderScale = -0.05;
				doit = true;
			}
			if (KeyReader.Pressed(KeyReader.KEY_NUM_9)) 
			{
				adderScale = 0.05;
				doit = true;
			}
			if (KeyReader.Pressed(KeyReader.KEY_LEFTSQUAREBRACKET)) 
			{
				StatDownClicked(null);
				if (KeyReader.Down(KeyReader.KEY_SHIFT))
				{
					StatDownClicked(null);
					StatDownClicked(null);
					StatDownClicked(null);
				}
			}
			if (KeyReader.Pressed(KeyReader.KEY_RIGHTSQUAREBRACKET)) 
			{
				StatUpClicked(null);
				if (KeyReader.Down(KeyReader.KEY_SHIFT))
				{
					StatUpClicked(null);
					StatUpClicked(null);
					StatUpClicked(null);
				}
			}
			
			
			var dx:int = 0;
			var dy:int = 0;
			if (upPressed) dy = -1;
			if (downPressed) dy = 1;
			if (leftPressed) dx = -1;
			if (rightPressed) dx = 1;
			
			var bd:BikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			if (wheelIndex == 0)
			{
				bd.wheel0_x += dx;
				bd.wheel0_y += dy;
				
				bd.susp0_len += adder0;
				bd.susp0_ang += adder1;
				bd.susp0_freq += adder2;
				bd.wheel0_scale += adderScale;
				
			}
			if (wheelIndex == 1)
			{
				bd.wheel1_x += dx;
				bd.wheel1_y += dy;
				
				bd.susp1_len += adder0;
				bd.susp1_ang += adder1;
				bd.susp1_freq += adder2;
				bd.wheel1_scale += adderScale;
			}
			bd.susp0_freq = Utils.LimitNumber(0.1, 1000, bd.susp0_freq);
			bd.susp1_freq = Utils.LimitNumber(0.1, 1000, bd.susp1_freq);
			
			
			if (KeyReader.Down(KeyReader.KEY_1)) 
			{
				bd.inputTorqueAccel -= 5;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_2)) 
			{
				bd.inputTorqueAccel += 5;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_3)) 
			{
				bd.maxInputTorqueVel -= 5;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_4)) 
			{
				bd.maxInputTorqueVel += 5;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_5)) 
			{
				bd.maxRotVel -= 0.01;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_6)) 
			{
				bd.maxRotVel += 0.01;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_7)) 
			{
				bd.accel -= 0.01;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_8)) 
			{
				bd.accel += 0.01;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_9)) 
			{
				bd.maxVel -= 1;
				doit = true;
			}
			if (KeyReader.Down(KeyReader.KEY_0)) 
			{
				bd.maxVel += 1;
				doit = true;
			}
			
			
			if (doit)
			{
				SetPlayerBike();
			}

		}
		
		static function SetPlayerBike()
		{
			var bd:BikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			var cd:CharDef = BikeDefs.GetCharByIndex(GameVars.playerCharIndex);
			
			for (var i:int = 0; i < 6; i++)
			{
				var a:int = cd.skills[i];
				var tf:TextField = hudMC.getChildByName("txt_stat" + i) as TextField;
				if (i == currentStat)
				{
					tf.text = "-->"+a.toString();
				}
				else
				{
					tf.text = a.toString();
				}
			}
			
			hudMC.wheelName.text = "LEFT";
			if(wheelIndex == 1) hudMC.wheelName.text = "RIGHT";
			hudMC.bikeName.text = bd.name;
			
			if (wheelIndex == 0)
			{
				hudMC.suspensionHeightText.text = "[7,8] LENGTH: " + bd.susp0_len;
				hudMC.suspensionAngleText.text = "[4,5] ANGLE: " + bd.susp0_ang;
				hudMC.suspensionFrequencyText.text = "[1,2] FREQ: " + bd.susp0_freq;
				hudMC.scaleText.text = "[6,9] SCALE: " + bd.wheel0_scale;
			}
			else
			{
				hudMC.suspensionHeightText.text = "[7,8] LENGTH: " + bd.susp1_len;
				hudMC.suspensionAngleText.text = "[4,5] ANGLE: " + bd.susp1_ang;
				hudMC.suspensionFrequencyText.text = "[1,2] FREQ: " + bd.susp1_freq;		
				hudMC.scaleText.text = "[6,9] SCALE: " + bd.wheel1_scale;
			}
			
			hudMC.rotText0.text = "[1,2] tq acc: " + bd.inputTorqueAccel;
			hudMC.rotText1.text = "[3,4] tq max: " + bd.maxInputTorqueVel;
			hudMC.rotText2.text = "[5,6] rot max: " + bd.maxRotVel;
			hudMC.rotText3.text = "[7,8] accel: " + bd.accel;
			hudMC.rotText4.text = "[9,0] maxvel: " + bd.maxVel;
			
			hudMC.charName.text = cd.name;
			
			//GameVars.playerGO.InitPlayerBikeDef(true);
		}
		
		
		static var currentStat:int = 0;
		public static function StatClicked(e:MouseEvent)
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			currentStat = mc.statIndex;
			SetPlayerBike();
		}
		public static function StatDownClicked(e:MouseEvent)
		{			
			var cd:CharDef = BikeDefs.GetCharByIndex(GameVars.playerCharIndex);
			var a:int = cd.skills[currentStat];
			a -= 5;
			if (a < 0) a = 0;
			cd.skills[currentStat] = a;
			SetPlayerBike();
		}
		public static function StatUpClicked(e:MouseEvent)
		{			
			var cd:CharDef = BikeDefs.GetCharByIndex(GameVars.playerCharIndex);
			var a:int = cd.skills[currentStat];
			a += 5;
			if (a > 100) a = 100;
			cd.skills[currentStat] = a;
			SetPlayerBike();
		}
		
		
		public static function Start()
		{
			if (PROJECT::isMobile) return;
			
			active = true;
			
			var classRef:Class = getDefinitionByName("bike_editor_hud") as Class;
			hudMC = new classRef as MovieClip;
//			hudMC = new bike_editor_hud();
			
			Game.main.addChild(hudMC);
			GameVars.playerGO.ypos -= 50;
			GameVars.playerGO.dir = 0;
			GameVars.playerGO.SetBodyXForm_Immediate(0, GameVars.playerGO.xpos, GameVars.playerGO.ypos, 0);
						
			hudMC.btn_stat0.statIndex = 0;
			hudMC.btn_stat1.statIndex = 1;
			hudMC.btn_stat2.statIndex = 2;
			hudMC.btn_stat3.statIndex = 3;
			hudMC.btn_stat4.statIndex = 4;
			hudMC.btn_stat5.statIndex = 5;
			UI.AddAnimatedMCButton(hudMC.btn_stat0, StatClicked, "topspeed");
			UI.AddAnimatedMCButton(hudMC.btn_stat1, StatClicked, "accel");
			UI.AddAnimatedMCButton(hudMC.btn_stat2, StatClicked, "brakes");
			UI.AddAnimatedMCButton(hudMC.btn_stat3, StatClicked, "spin");
			UI.AddAnimatedMCButton(hudMC.btn_stat4, StatClicked, "boost");
			UI.AddAnimatedMCButton(hudMC.btn_stat5, StatClicked, "jumps");
			UI.AddAnimatedMCButton(hudMC.btn_statDown, StatDownClicked, "stat down [");
			UI.AddAnimatedMCButton(hudMC.btn_statUp, StatUpClicked, "stat up ]");
			
			UI.AddAnimatedMCButton(hudMC.btn_wheel1, Wheel1Clicked, "Wheel LEFT");
			UI.AddAnimatedMCButton(hudMC.btn_wheel2, Wheel2Clicked, "Wheel RIGHT");
			UI.AddAnimatedMCButton(hudMC.btn_prevBike, PrevBikeClicked, "Prev Bike");
			UI.AddAnimatedMCButton(hudMC.btn_nextBike, NextBikeClicked, "Next Bike");
			UI.AddAnimatedMCButton(hudMC.btn_back, BackClicked);

			UI.AddAnimatedMCButton(hudMC.btn_frameDepth, FrameDepthClicked, "Frame Depth");
			UI.AddAnimatedMCButton(hudMC.btn_wheelDepth, WheelDepthClicked, "Wheel Depth");
			UI.AddAnimatedMCButton(hudMC.btn_prevWheel, PrevWheelClicked, "Prev Wheel");
			UI.AddAnimatedMCButton(hudMC.btn_nextWheel, NextWheelClicked, "Next Wheel");
			UI.AddAnimatedMCButton(hudMC.btn_prevChar, PrevCharClicked, "Prev Char");
			UI.AddAnimatedMCButton(hudMC.btn_nextChar, NextCharClicked, "Next Char");
			UI.AddAnimatedMCButton(hudMC.btn_prevFrame, PrevFrameClicked, "Prev Frame");
			UI.AddAnimatedMCButton(hudMC.btn_nextFrame, NextFrameClicked, "Next Frame");
			
			SetPlayerBike();
			
		}
		
		static function BackClicked(e:MouseEvent)
		{
			Stop();
		}
		static function Wheel1Clicked(e:MouseEvent)
		{
			wheelIndex = 0;
			SetPlayerBike();
		}
		static function Wheel2Clicked(e:MouseEvent)
		{
			wheelIndex = 1;
			SetPlayerBike();
		}
		static function PrevBikeClicked(e:MouseEvent)
		{
			GameVars.playerBikeDefIndex--;
			if (GameVars.playerBikeDefIndex < 0) GameVars.playerBikeDefIndex = BikeDefs.list.length - 1;
			SetPlayerBike();
		}
		static function NextBikeClicked(e:MouseEvent)
		{
			GameVars.playerBikeDefIndex++;
			if (GameVars.playerBikeDefIndex >= BikeDefs.list.length) GameVars.playerBikeDefIndex = 0;
			SetPlayerBike();
		}

				
		static function PrevFrameClicked(e:MouseEvent)
		{
			var bd:BikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			bd.frameIndex--;
			if (bd.frameIndex < 0) bd.frameIndex = totalFrames-1;
			SetPlayerBike();			
		}
		static function NextFrameClicked(e:MouseEvent)
		{
			var bd:BikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			bd.frameIndex++;
			if (bd.frameIndex >= totalFrames) bd.frameIndex = 0;
			SetPlayerBike();			
		}
		static function PrevCharClicked(e:MouseEvent)
		{
			GameVars.playerCharIndex--;
			if (GameVars.playerCharIndex < 0)GameVars.playerCharIndex = totalChars-1;
			SetPlayerBike();
		}
		static function NextCharClicked(e:MouseEvent)
		{
			GameVars.playerCharIndex++;
			if (GameVars.playerCharIndex >= totalChars) GameVars.playerCharIndex = 0;
			SetPlayerBike();
		}
		
		static function FrameDepthClicked(e:MouseEvent)
		{
			var bd:BikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			bd.frame_depth = 1 - bd.frame_depth;
			SetPlayerBike();			
		}
		static function WheelDepthClicked(e:MouseEvent)
		{
			var bd:BikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			if (wheelIndex == 0)
			{
				bd.wheel0_depth = 1 - bd.wheel0_depth;
			}
			if (wheelIndex == 1)
			{
				bd.wheel1_depth = 1 - bd.wheel1_depth;
			}			
			SetPlayerBike();
		}
		static function PrevWheelClicked(e:MouseEvent)
		{
			var bd:BikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			if (wheelIndex == 0)
			{
				bd.wheel0_index += -1;
				if (bd.wheel0_index < 0) bd.wheel0_index = totalWheels - 1;
			}
			else
			{
				bd.wheel1_index += -1;
				if (bd.wheel1_index < 0) bd.wheel1_index = totalWheels - 1;
			}
			
			SetPlayerBike();
		}
		static function NextWheelClicked(e:MouseEvent)
		{
			var bd:BikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			if (wheelIndex == 0)
			{
				bd.wheel0_index += 1;
				if (bd.wheel0_index >= totalWheels) bd.wheel0_index = 0;
			}
			else
			{
				bd.wheel1_index += 1;
				if (bd.wheel1_index >= totalWheels) bd.wheel1_index = 0;
			}
			
			SetPlayerBike();
			
		}
		
		public static function ExportBikeData()
		{
			var s:String = "";
			var index:int = 0;
			for each(var cd:CharDef in BikeDefs.charList)
			{
				cd.index = index;
				s += cd.Export();
				s += "\n";
				index++;
			}
			
			index = 0;
			for each(var bd:BikeDef in BikeDefs.list)
			{
				bd.index = index;
				s += bd.Export();
				s += "\n";
				index++;
			}
			System.setClipboard(s);
			trace(s);
		}

		public static function SaveBikeDataXML()
		{
			var sss:String = ExportBikeDataXML();
			var fileRef:FileReference;
			fileRef = new FileReference();
			fileRef.save(sss,"Vehicle_Data.xml");			

		}
		public static function ExportBikeDataXML():String
		{
			var s:String = "";
			var index:int = 0;
			
			s += '<data>\n';
			
			index = 0;
			for each(var bd:BikeDef in BikeDefs.list)
			{
				bd.index = index;
				s += bd.ExportXML();
				index++;
			}
			s += '</data>\n';
			trace(s);
			return s;
		}
		
		
		public static function Stop()
		{
			GameVars.playerGO.InitPlayerBikeDef(true);
			
			ExportBikeData();
			ExportBikeDataXML();
			if (hudMC != null)
			{
				Game.main.removeChild(hudMC);
				hudMC = null;				
			}
			active = false;
			KeyReader.InitOnce(Game.main.stage);			

		}
		
	}

}