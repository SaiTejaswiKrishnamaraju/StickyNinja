package  
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Default
	*/
	public class MouseControl 
	{
		
		public static var ox:Number = 0;
		public static var oy:Number = 0;
		public static var x:Number = 0;
		public static var y:Number = 0;
		public static var mouseVelX:Number = 0;
		public static var mouseVelY:Number = 0;
		public static var buttonPressed:Boolean = false;
		public static var buttonReleased:Boolean = false;
		public static var wheelFunction:Function = null;
		public static var active:Boolean = false;

		
		public static function InitOnce(stage:Stage):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, MouseHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseClickHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, MouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, MouseWheelHandler);
			wheelFunction = null
			active = false;
		}
		
		public static function SetWheelHandler(f:Function):void
		{
			wheelFunction = f;
		}
		
		public function MouseControl() 
		{
			
		}
		
		
		public static function Reset():void 
		{
			buttonPressed = false;
			buttonReleased = false;
		}
		
		public static function MouseHandler(event:MouseEvent):void 
		{			
			x = event.stageX;
			y = event.stageY;
			mouseVelX = x - ox;
			mouseVelY = y - oy;
			dx = (x - ox);
			dy = (y - oy);
			ox = x;
			oy = y;
			
			
		}

		public static function ResetDxDy():void
		{
			dx = 0;
			dy = 0;
		}
		
		public static var dx:Number = 0;
		public static var dy:Number = 0;
		
		public static var delta:int = 0;
		public static function MouseWheelHandler(event:MouseEvent):void 
		{
			delta = event.delta;
			if(wheelFunction != null) wheelFunction(delta);
		}
		public static function MouseClickHandler(event:MouseEvent):void 
		{
			if (active == false) return;
			Utils.print("buttonPressed");
			buttonPressed = true;
			buttonReleased = false;
		}
		public static function MouseUpHandler(event:MouseEvent):void 
		{
			if (active == false) return;
			Utils.print("buttonReleased");
			buttonPressed = false;
			buttonReleased = true;
		}

		
	}
	
}