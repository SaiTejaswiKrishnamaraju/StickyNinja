package UIPackage  
{
	import AudioPackage.Audio;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import TextPackage.TextRenderer;
	import UIPackage.UIX_Instance;
	/**
	 * ...
	 * @author 
	 */
	public class UIX_GameObj extends GameObj_Base
	{
		public var uixInstance:UIX_Instance;
		public var tweener:Tweener;
		
		public static var EDGE_TOP:String = "top";
		public static var EDGE_RIGHT:String = "right";
		public static var EDGE_BOTTOM:String = "bottom";
		public static var EDGE_LEFT:String = "left";
		public static var EDGE_NONE:String = "none";
		
		public function UIX_GameObj() 
		{
			
		}
		
		
		public function InitHudObject()
		{
			Init(0);
		}
		
		
//------------------------------------------------------------------------------------------------------------

		function UpdateState0Tweener_updateFunction1WhenDone()
		{
			if (state == 0)
			{
				tweener.Update();
				if (tweener.Update() == true) 
				{
					updateFunction = updateFunction1
				}
			}
		}

		function UpdateState0Tweener()
		{
			if (state == 0)
			{
				tweener.Update();
//				if (tweener.Update() == true) active = false;
			}
		}

		function UpdateState0Tweener_WithRemove()
		{
			if (state == 0)
			{
				if (tweener.Update() == true) 
				{
					active = false;
					uixInstance.visible = false;
				}
			}
		}
		
//------------------------------------------------------------------------------------------------------------

		function UpdateTextAppear()
		{
			tweener.Update();
		}
		function InitTextAppear(_delay:Number, _mode:int = 0 )
		{
			updateFunction = UpdateTextAppear;
			
			var track:TweenTrack;
			
			if (_mode == 0)
			{
			
				tweener = new Tweener();
				track = tweener.NewTrack(this, "alpha");
				track.Set(0.0);
				track.AddStep_Pause(_delay * 0.1);
				track.AddStep(0.0, 1, 2, "power_out", 2);
			}
			else if (_mode == 1)
			{
				tweener = new Tweener();
				track = tweener.NewTrack(this, "alpha");
				track.Set(0.0);
				track.AddStep_Pause(_delay * 0.1);
				track.AddStep(0.0, 1, 2,  Ease.EASE_LINEAR, 1);
				
				track = tweener.NewTrack(this, "scaleX");
				track.Set(3);
				track.AddStep_Pause(_delay * 0.1);
				track.AddStep(3, 1, 1.5,  Ease.EASE_LINEAR, 1);
				
				track = tweener.NewTrack(this, "scaleY");
				track.Set(3);
				track.AddStep_Pause(_delay * 0.1);
				track.AddStep(3, 1, 1.5, Ease.EASE_LINEAR, 1);

				track = tweener.NewTrack(this, "dir");
				track.Set(720);
				track.AddStep_Pause(_delay * 0.1);
				track.AddStep(720, 0, 1.5, Ease.EASE_LINEAR, 1);
				
			}
		}


//------------------------------------------------------------------------------------------------------------



		function UpdateComeOnFromSide()
		{
			tweener.Update();
		}
		function InitComeOnFromSide(_delay:Number)
		{
			updateFunction = UpdateComeOnFromSide;
			
			var ox:Number = -500;
			if (xpos > Defs.displayarea_w2)
			{
				ox = Defs.displayarea_w + 500;
			}
			
			var track:TweenTrack;
			tweener = new Tweener();

			track = tweener.NewTrack(this, "alpha");
			track.Set(0.5);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0.5, 1, 5, "power_out", 2);
			
			track = tweener.NewTrack(this, "xpos");
			track.Set(ox);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(ox, xpos, 0.5, "power_out", 2);

//			track = tweener.NewTrack(this, "ypos");
//			track.Set(ypos-200);
//			track.AddStep_Pause(_delay * 0.1);
//			track.AddStep(ypos-200, ypos, 0.5, "power_out", 2);
			
			track = tweener.NewTrack(this, "scaleX");
			track.Set(0.1);
			track.AddStep_Pause(_delay * 0.1+2);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);
			
			track = tweener.NewTrack(this, "scaleY");
			track.Set(0.8);
			track.AddStep_Pause(_delay * 0.1+2);
			track.AddStep(0.8, 1, 1, Ease.EASE_SPRING_OUT, 2);

			track = tweener.NewTrack(this, "dir");
			track.Set(0);
			track.AddStep_Pause(_delay * 0.1+2+1);
			track.AddStep(0,360, 1, Ease.EASE_POWER_INOUT, 2);
			
		}
		
		
//------------------------------------------------------------------------------------------------------------

		var fullText:String;
		var currentText:String;
		public function UpdateTeletype()
		{
			if (state == 0)
			{
				timer1--;
				if (timer1 <= 0)
				{
					state = 1;
				}
			}
			else if (state == 1)
			{
				timer--;
				if (timer <= 0)
				{
					timer = timerMax;					
					count++;
					if (count >= fullText.length)
					{
						count = fullText.length;
					}					
					currentText = fullText.substr(0, count);
				}	
			}
			uixInstance.SetText(currentText);			
		}
		public function InitTeletype(_unused:String,_delaySeconds:Number)
		{
			fullText = uixInstance.GetButtonText();
			currentText = "";
			updateFunction = UpdateTeletype;
			timer = timerMax = 3;
			count = 0;
			state = 0;
			timer1 = int(_delaySeconds * Defs.fps);
		}

//------------------------------------------------------------------------------------------------------------

		function InitStoryAppear(_edge:String,_delay:Number)
		{
			updateFunction = UpdateState0Tweener;
			
			var ox:Number = xpos;
			var oy:Number = ypos;
			
			if (_edge == EDGE_TOP)
			{
				oy = -500;				
			}
			else if (_edge == EDGE_RIGHT)
			{
				ox = Defs.displayarea_w + 500;				
			}
			else if (_edge == EDGE_BOTTOM)
			{
				oy = Defs.displayarea_h + 500;								
			}
			else if (_edge == EDGE_LEFT)
			{
				ox = -500;
			}
			
			
			
			var track:TweenTrack;
			tweener = new Tweener();

			track = tweener.NewTrack(this, "xpos");
			track.Set(ox);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(ox, xpos, 0.5, Ease.EASE_BOUNCE_IN, 2);

			track = tweener.NewTrack(this, "ypos");
			track.Set(ox);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(oy, ypos, 0.5, Ease.EASE_BOUNCE_IN, 2);
			
		}



		function InitAppear(_edge:String,_delay:Number)
		{
			updateFunction = UpdateState0Tweener;
			
			var ox:Number = xpos;
			var oy:Number = ypos;
			
			if (_edge == EDGE_TOP)
			{
				oy = -500;				
			}
			else if (_edge == EDGE_RIGHT)
			{
				ox = Defs.displayarea_w + 500;				
			}
			else if (_edge == EDGE_BOTTOM)
			{
				oy = Defs.displayarea_h + 500;								
			}
			else if (_edge == EDGE_LEFT)
			{
				ox = -500;
			}
			
			
			
			var track:TweenTrack;
			tweener = new Tweener();

			track = tweener.NewTrack(this, "dir");
			track.Set(dir+Math.PI*21);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(dir+Math.PI*21, dir, 0.5, "power_out", 2);
			
			track = tweener.NewTrack(this, "alpha");
			track.Set(0);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0, 1, 0.5, "power_out", 2);
			
			track = tweener.NewTrack(this, "xpos");
			track.Set(ox);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(ox, xpos, 0.5, "power_out", 2);

			track = tweener.NewTrack(this, "ypos");
			track.Set(ox);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(oy, ypos, 0.5, "power_out", 2);
			
		}
		
		function InitAppearOld(_edge:String,_delay:Number)
		{
			updateFunction = UpdateState0Tweener;
			
			var ox:Number = xpos;
			var oy:Number = ypos;
			
			if (_edge == EDGE_TOP)
			{
				oy = -500;				
			}
			else if (_edge == EDGE_RIGHT)
			{
				ox = Defs.displayarea_w + 500;				
			}
			else if (_edge == EDGE_BOTTOM)
			{
				oy = Defs.displayarea_h + 500;								
			}
			else if (_edge == EDGE_LEFT)
			{
				ox = -500;
			}
			
			
			
			var track:TweenTrack;
			tweener = new Tweener();

			track = tweener.NewTrack(this, "alpha");
			track.Set(0);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0, 1, 0.5, "power_out", 2);
			
			track = tweener.NewTrack(this, "xpos");
			track.Set(ox);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(ox, xpos, 0.5, "power_out", 2);

			track = tweener.NewTrack(this, "ypos");
			track.Set(ox);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(oy, ypos, 0.5, "power_out", 2);
			
		}

		
		
//------------------------------------------------------------------------------------------------------------
		function UpdateWobble()
		{
			timer++;
			ypos = starty+(Math.cos(timer*0.1) * 5)
		}
		function InitWobble()
		{
			updateFunction = UpdateWobble;
			
			startx = xpos;
			starty = ypos;
			timer = 0;
		}

//------------------------------------------------------------------------------------------------------------
		function UpdateScaleWobble()
		{
			timer++;
			scaleX = startScale+(Math.cos(timer*0.05) * 0.05)
			scaleY = startScale+(Math.cos(timer*0.05) * 0.05)
		}
		var startScale:Number;
		function InitScaleWobble()
		{
			updateFunction = UpdateScaleWobble;			
			startScale = scaleX;
			timer = 0;
			state = 0;
		}

		
		
//------------------------------------------------------------------------------------------------------------
		function UpdateDropOn()
		{
			timer++;
			ypos = starty+(Math.cos(timer*0.1) * 5)
		}
		function InitDropOn(startY:Number)
		{
			updateFunction = UpdateDropOn;
			
			startx = xpos;
			starty = ypos;
			timer = 0;
		}
		
		
//------------------------------------------------------------------------------------------------------------



		function UpdateTest1()
		{
			dir += 1;
		}
		function InitTest1()
		{
			updateFunction = UpdateTest1;
		}
		
//------------------------------------------------------------------------------------------------------------

		function UpdateTitle_Background()
		{
			dir += 0.1;
		}
		function InitTitle_Background()
		{
			dir = 0;
			updateFunction = UpdateTitle_Background;
		}

//------------------------------------------------------------------------------------------------------------

		function UpdateTitle_Title()
		{
			timer1++;
			dir = Math.cos(timer1 * 0.1);
		}
		function InitTitle_Title()
		{
			updateFunction = UpdateState0Tweener_updateFunction1WhenDone;
			updateFunction1 = UpdateTitle_Title;
			timer1 = 0;
			
			var track:TweenTrack;
			tweener = new Tweener();

			track = tweener.NewTrack(this, "alpha");
			track.Set(0);
			track.AddStep(0, 1, 0.5, Ease.EASE_POWER_OUT, 2);
			
			track = tweener.NewTrack(this, "scaleX");
			track.Set(0.1);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);

			track = tweener.NewTrack(this, "scaleY");
			track.Set(0.1);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);
			
		}

//------------------------------------------------------------------------------------------------------------

		function UpdateTitle_Image()
		{
			timer1++;
			dir = Math.sin(timer1 * 0.1);
		}
		function InitTitle_Image()
		{
			updateFunction = UpdateState0Tweener_updateFunction1WhenDone;
			updateFunction1 = UpdateTitle_Image;
			timer1 = 0;
			
			var track:TweenTrack;
			tweener = new Tweener();

			track = tweener.NewTrack(this, "alpha");
			track.Set(0);
			track.AddStep(0, 1, 0.5, Ease.EASE_POWER_OUT, 2);
			
			track = tweener.NewTrack(this, "scaleX");
			track.Set(0.1);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);

			track = tweener.NewTrack(this, "scaleY");
			track.Set(0.1);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);
			
		}

		
//------------------------------------------------------------------------------------------------------------




		function InitTrophyAppear(_delay:Number)
		{
			updateFunction = UpdateState0Tweener;
			
			var track:TweenTrack;
			tweener = new Tweener();

			track = tweener.NewTrack(this, "alpha");
			track.Set(0);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0, 1, 0.5, Ease.EASE_POWER_OUT, 2);
			
			track = tweener.NewTrack(this, "scaleX");
			track.Set(0.1);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);

			track = tweener.NewTrack(this, "scaleY");
			track.Set(0.1);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);
			
		}
		
//------------------------------------------------------------------------------------------------------------

		public function UpdateLevelCompleteContainer()
		{
			
		}
		public function InitLevelCompleteContainer(_delay:Number)
		{
			
			updateFunction = UpdateState0Tweener;
			
			var track:TweenTrack;
			tweener = new Tweener();
			
			var t:Number = 1;
			
			track = tweener.NewTrack(this, "dir");
			track.Set(-720);
			track.AddStep( -720, 0, t, Ease.EASE_POWER_OUT, 2);
				
			track = tweener.NewTrack(this, "scaleX");
			track.Set(0.1);
			track.AddStep(0.1, 1, t, Ease.EASE_POWER_OUT, 2);

			track = tweener.NewTrack(this, "scaleY");
			track.Set(0.1);
			track.AddStep(0.1, 1, t, Ease.EASE_POWER_OUT, 2);
				
			
		}
		public function InitLevelCompleteText(_initialDelay:Number,_delay:Number)
		{
			updateFunction = UpdateState0Tweener;
			
			var track:TweenTrack;
			tweener = new Tweener();
			
			var d:Number = (_delay * 0.1) + _initialDelay;
			
			track = tweener.NewTrack(this, "alpha");
			track.Set(0);
			track.AddStep_Pause(d);
			track.AddStep(0, 1, 0.5, Ease.EASE_POWER_OUT, 2);
			
			track = tweener.NewTrack(this, "scaleX");
			track.Set(0.1);
			track.AddStep_Pause(d);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);

			track = tweener.NewTrack(this, "scaleY");
			track.Set(0.1);
			track.AddStep_Pause(d);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);
			
		}

//------------------------------------------------------------------------------------------------------------

		public function InitMissionInfoIngame(_delay:Number)
		{
			updateFunction = UpdateState0Tweener;
			
			var track:TweenTrack;
			tweener = new Tweener();

			
			track = tweener.NewTrack(this, "alpha");
			track.Set(0);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0, 1, 0.5, Ease.EASE_POWER_OUT, 2);
			
			track.AddStep_Pause(3);
			track.AddStep(1, 0, 0.5, Ease.EASE_POWER_OUT, 2);
			
			track = tweener.NewTrack(this, "scaleX");
			track.Set(0.1);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);

			track = tweener.NewTrack(this, "scaleY");
			track.Set(0.1);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);
			
		}

		public function InitMissionInfoHud(_delay:Number)
		{
			updateFunction = UpdateState0Tweener;
			
			var track:TweenTrack;
			tweener = new Tweener();

			
			track = tweener.NewTrack(this, "alpha");
			track.Set(0);
			track.AddStep_Pause(3.5);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0, 1, 0.5, Ease.EASE_POWER_OUT, 2);
			
			track = tweener.NewTrack(this, "scaleX");
			track.Set(0.1);
			track.AddStep_Pause(3.5);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);

			track = tweener.NewTrack(this, "scaleY");
			track.Set(0.1);
			track.AddStep_Pause(3.5);
			track.AddStep_Pause(_delay * 0.1);
			track.AddStep(0.1, 1, 0.5, Ease.EASE_SPRING_OUT, 2);
			
		}
		
//------------------------------------------------------------------------------------------------------------


		public function InitPlaceRequirement()
		{
			updateFunction = UpdateState0Tweener_WithRemove;
			var track:TweenTrack;
			tweener = new Tweener();

			track = tweener.NewTrack(this, "alpha");
			track.Set(0);
			track.AddStep(0, 1, 1,Ease.EASE_LINEAR, 1);
			track.AddStep_Pause(3);
			track.AddStep(1,0, 0.5,Ease.EASE_LINEAR, 1);

			track = tweener.NewTrack(this, "scaleX");
			track.Set(1.5);
			track.AddStep(1.5, 1, 1,Ease.EASE_LINEAR, 1);

			track = tweener.NewTrack(this, "scaleY");
			track.Set(1.2);
			track.AddStep(1.2, 1, 1,Ease.EASE_LINEAR, 1);
			
			
		}

//------------------------------------------------------------------------------------------------------------

		function UpdateCountdown()
		{
			if (tweener.Update() == true) 
			{
				active = false;
				uixInstance.visible = false;
			}
			timer++;
			if (timer == timerMax)
			{
				GameVars.canStart = true;
			}
		}

		public function InitCountdown()
		{
			updateFunction = UpdateCountdown;
			var track:TweenTrack;
			tweener = new Tweener();
			
			this.uixInstance.visible = true;
			this.uixInstance.frame = 0;

			var gap:Number = 0.5;
			var gap2:Number = 2;
			
			track = tweener.NewTrack(this, "frame");
			track.AddStep_Set(0,gap);
			track.AddStep_Set(1,gap);
			track.AddStep_Set(2,gap);
			track.AddStep_Set(3,gap2);
			
			
			track = tweener.NewTrack(this, "alpha");
			track.AddStep(1,0, gap,Ease.EASE_LINEAR, 1);
			track.AddStep(1,0, gap,Ease.EASE_LINEAR, 1);
			track.AddStep(1,0, gap,Ease.EASE_LINEAR, 1);
			track.AddStep(1,0, gap2,Ease.EASE_LINEAR, 1);

			var maxScale:Number = 1.5;
			
			track = tweener.NewTrack(this, "scaleX");
			track.AddStep(maxScale,1, gap,Ease.EASE_LINEAR, 1);
			track.AddStep(maxScale,1, gap,Ease.EASE_LINEAR, 1);
			track.AddStep(maxScale,1, gap,Ease.EASE_LINEAR, 1);
			track.AddStep(maxScale,1, gap2,Ease.EASE_LINEAR, 1);

			track = tweener.NewTrack(this, "scaleY");
			track.AddStep(maxScale,1, gap,Ease.EASE_LINEAR, 1);
			track.AddStep(maxScale,1, gap,Ease.EASE_LINEAR, 1);
			track.AddStep(maxScale,1, gap,Ease.EASE_LINEAR, 1);
			track.AddStep(maxScale,1, gap2,Ease.EASE_LINEAR, 1);
			
			
			timer = 0;
			timerMax = 3 * gap * Defs.fps;
			
		}
		
		

		
//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------

		function UpdateAchievementsPopup()
		{
			if (state == 0)
			{
				
				uixInstance.visible = false;
				timer++;
				if (timer >= 2)
				{
					uixInstance.visible = true;
				}
				
				if (tweener.Update() == true)
				{
					active = false;
				}
			}
		}
		var origx:Number;
		var origy:Number;
		public function InitAchievementsPopup(_mode:int)
		{
			updateFunction = UpdateAchievementsPopup;
			var track:TweenTrack;
			tweener = new Tweener();

			
			if (_mode == 0)	// init
			{
				origx = xpos;
				origy = ypos;
				state = 0;
				uixInstance.visible = false;
				timer = 0;
				return;
			}
			
			if (_mode == 1)
			{
				active = true;
				state = 0;
				track = tweener.NewTrack(this, "ypos");
				track.Set(origy - 200);
				track.AddStep(origy-200,origy, 1,Ease.EASE_SPRING_OUT, 2);
				track.AddStep_Set(origy, 1000);
				timer = 0;
				uixInstance.visible = false;
				return;
			}
			
			if (_mode == 2)	// init
			{
				state = 0;
				track = tweener.NewTrack(this, "ypos");
				track.Set(origy);
				track.AddStep(origy,origy-200, 1,Ease.EASE_POWER_OUT, 2);
				track.AddStep_Set(origy - 200, 1000);
				return;
			}
			
			
			
		}

//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------

		public function InitLevelUnlocked()
		{
			updateFunction = UpdateState0Tweener;
			var track:TweenTrack;
			tweener = new Tweener();

			var pause:Number = 3;
			
			track = tweener.NewTrack(this, "alpha");
			track.AddStep(0, 1, 1, Ease.EASE_POWER_IN, 2);
			track.AddStep_Pause(pause);
			track.AddStep(1,0, 1, Ease.EASE_POWER_OUT, 2);

			track = tweener.NewTrack(this, "scaleX");
			track.AddStep(2, 1, 1,Ease.EASE_POWER_IN, 2);
			track.AddStep_Pause(pause);
			track.AddStep(1,0.1, 1,Ease.EASE_POWER_OUT, 2);

			track = tweener.NewTrack(this, "scaleY");
			track.AddStep(2, 1, 1,Ease.EASE_POWER_IN, 2);
			track.AddStep_Pause(pause);
			track.AddStep(1,0.1, 1,Ease.EASE_POWER_OUT, 2);
			
			
		}

		
//------------------------------------------------------------------------------------------------------------


		function UpdateX()
		{
		}
		function InitX()
		{
			updateFunction = UpdateX;
		}
		
//------------------------------------------------------------------------------------------------------------
		
	}

}