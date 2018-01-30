package LicPackage 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class LicUI 
	{
		
		public function LicUI() 
		{
			
		}
		
		public static function StopPropagation(e:MouseEvent)
		{
			e.stopPropagation();
			e.stopImmediatePropagation();			
		}
		static function nonPropagate(e:MouseEvent)
		{
			StopPropagation(e);
		}
		
		public static function SetNonPropagateMouse(btn:MovieClip)
		{
			btn.addEventListener(MouseEvent.MOUSE_DOWN, nonPropagate);
			btn.addEventListener(MouseEvent.MOUSE_UP, nonPropagate);
			btn.addEventListener(MouseEvent.MOUSE_MOVE, nonPropagate);
			
		}
		
		public static function AddAnimatedMCButton(btn:MovieClip,clickCallback:Function,text:String = null,reorderWhenOver:Boolean = false,_hoverCallback = null,_outCallback:Function = null)
		{			
//			if (PROJECT::useStage3D)
//			{
//				return AddAnimatedMCButton_Mobile(btn, clickCallback, text, reorderWhenOver, _hoverCallback,_outCallback);
//			}
			
			if (btn == null)
			{
				trace("add MCbutton button = null");				
			}
			if (clickCallback == null)
			{
//				trace("add MCbutton clickCallback = null");				
			}
			
			SetNonPropagateMouse(btn);
			
			btn.mouseChildren = false;
			
			btn.canClick = true;
			
			btn.reorderWhenOver = false;	// reorderWhenOver;
			btn.helpText = text;
			if (text != null)
			{
				btn.buttonName.text = text;
			}
			
			
			btn.clickCallback = clickCallback;
			btn.hoverCallback = _hoverCallback;
			btn.outCallback = _outCallback;
			
			btn.buttonAnimation.gotoAndStop(1);
			
			if (btn.buttonName != null)
			{
				
				
				if (btn.buttonAnimation.buttonText != null)
				{
					btn.buttonAnimation.buttonText.buttonName.text = btn.buttonName.text;
					btn.buttonName.visible = false;
					btn.buttonAnimation.buttonText.visible = true;
					btn.buttonAnimation.buttonText.mouseEnabled = false;
					btn.buttonName.mouseEnabled = false;
					btn.buttonAnimation.buttonText.buttonName.setTextFormat(btn.buttonName.getTextFormat());
				}
			}
			if (btn.buttonName != null)
			{
				btn.buttonName.mouseEnabled = false;
			}
			
			
			btn.addEventListener(MouseEvent.ROLL_OVER, AnimatedMCButton_Over, false, 0, true);
			btn.addEventListener(MouseEvent.ROLL_OUT, AnimatedMCButton_Out, false, 0, true);
			//btn.addEventListener(MouseEvent.MOUSE_UP, NewMCButton_Down, false, 0, true);
			
			btn.useHandCursor = true;
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.CLICK, AnimatedMCButton_Click, false, 0, true);	
			

		}

		
		public static function RemoveAnimatedMCButton(btn:MovieClip)
		{			
			btn.removeEventListener(MouseEvent.ROLL_OVER, AnimatedMCButton_Over);
			btn.removeEventListener(MouseEvent.ROLL_OUT, AnimatedMCButton_Out);
			btn.removeEventListener(MouseEvent.CLICK, AnimatedMCButton_Click);	
		}
		public static function AnimatedMCButton_Click(e:MouseEvent)
		{
			if (e.currentTarget.useTick)
			{
				if (e.currentTarget.canClick)
				{
					e.currentTarget.tickState = (e.currentTarget.tickState == false);
					e.currentTarget.tick.visible = e.currentTarget.tickState;
				}
			}
			
			e.currentTarget.buttonAnimation.gotoAndPlay("clicked");
			if (e.currentTarget.clickCallback != null)
			{
				e.currentTarget.clickCallback(e);
			}

		}
		public static function AnimatedMCButton_Over(e:MouseEvent)
		{
			if (e.currentTarget == null) return;
			
			if (e.currentTarget.hoverCallback != null)
			{
				e.currentTarget..hoverCallback(e);
			}
			
			e.currentTarget.buttonAnimation.gotoAndPlay("over");
		}
		public static function AnimatedMCButton_Out(e:MouseEvent)
		{
			if (e.currentTarget == null) return;
			e.currentTarget.buttonAnimation.gotoAndPlay("out");
			
			if (e.currentTarget.outCallback != null)
			{
				e.currentTarget..outCallback(e);
			}
			
		}
		
//------------------------------------------------------------------------------------------		

		public static function AddMCButton(btn:MovieClip,clickCallback:Function,text:String = null,hoverCallback:Function=null,outCallback:Function=null)
		{			
			if (btn == null)
			{
				trace("add MCbutton button = null");				
			}
			if (clickCallback == null)
			{
//				trace("add MCbutton clickCallback = null");				
			}
			
			btn.helpText = text;
			
			btn.gotoAndStop(1);
			btn.addEventListener(MouseEvent.ROLL_OVER, MCButton_Over, false, 0, true);
			btn.addEventListener(MouseEvent.ROLL_OUT, MCButton_Out, false, 0, true);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, MCButton_Down, false, 0, true);
			
			btn.useHandCursor = true;
			btn.buttonMode = true;
			
			btn.clickCallback = clickCallback;
			btn.hoverCallback = hoverCallback;
			btn.outCallback = outCallback;
			
			btn.addEventListener(MouseEvent.MOUSE_UP, MCButton_Click, false, 0, true);	
		}
		public static function RemoveMCButton(btn:MovieClip)
		{			
			btn.removeEventListener(MouseEvent.ROLL_OVER, MCButton_Over);
			btn.removeEventListener(MouseEvent.ROLL_OUT, MCButton_Out);
			btn.removeEventListener(MouseEvent.MOUSE_DOWN, MCButton_Down);
			btn.removeEventListener(MouseEvent.MOUSE_UP, MCButton_Click);	
		}
		public static function MCButton_Click(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop(1);
			e.currentTarget.clickCallback(e);

		}
		public static function MCButton_Over(e:MouseEvent)
		{
			if (e.currentTarget == null) return;
			
			if (e.currentTarget.hoverCallback != null)
			{
				e.currentTarget.hoverCallback(e);
			}
			
			if (e.currentTarget.currentFrame != 3)
			{
				e.currentTarget.gotoAndStop(2);
			}
		}
		public static function MCButton_Out(e:MouseEvent)
		{
			if (e.currentTarget == null) return;
			if (e.currentTarget.outCallback != null)
			{
				e.currentTarget.outCallback(e);
			}
			e.currentTarget.gotoAndStop(1);
		}
		public static function MCButton_Down(e:MouseEvent)
		{
			if (e.currentTarget == null) return;
			e.currentTarget.gotoAndStop(3);
		}
		
	}

}