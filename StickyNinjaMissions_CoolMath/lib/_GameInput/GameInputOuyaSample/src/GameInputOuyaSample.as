package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import flash.text.TextField;
	import flash.ui.GameInput;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class GameInputOuyaSample extends Sprite
	{
		private var gameInput:GameInput;
		private var timer:Timer;
		private var timerStop:Timer;
		private var _device:GameInputDevice;
		private var ba:ByteArray;
		private var tf:TextField;
		
		public function GameInputOuyaSample()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			tf = new TextField();
			tf.x = 0;
			tf.y = 50;
			tf.border = tf.visible = true;
			tf.height = tf.width = 900;
			tf.multiline = true;
			tf.scrollV = 1;
			tf.text = "Welcome to the sample for GameInput API for Ouya TV, please press buttons on your controller...\n"
			addChild(tf);
			
			ba = new ByteArray();
			
			gameInput = new GameInput();
			gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, handleDeviceAttached);
			gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, handleDeviceRemoved);
			
		}
		
		
		protected function handleDeviceRemoved(event:GameInputEvent):void
		{
			tf.appendText("Device is removed\n");
		}
		
		protected function handleDeviceAttached(e:GameInputEvent):void
		{
			tf.appendText("Device is added\n");
			GameInputControlName.initialize(e.device);
			
			
			for(var k:Number=0;k<GameInput.numDevices;k++){
				_device = GameInput.getDeviceAt(k);
				var _controls:Vector.<String> = new Vector.<String>;
				_device.enabled = true;
				
				for (var i:Number = 0; i < _device.numControls; i++) {
					var control:GameInputControl = _device.getControlAt(i);
					control.addEventListener(Event.CHANGE,onChange);
					_controls[i] = control.id;
				}
				
				_device.startCachingSamples(30, _controls);
				
				
			}
			
			for(var j:int=0; j<_controls.length; j++)
			{
				trace(_controls[j]);
			}
			
			stage.addEventListener(Event.ENTER_FRAME, getCachedSamples);
			
		}	
		
		protected function onChange(event:Event):void
		{
			var control:GameInputControl = event.target as GameInputControl;
			tf.scrollV++;
			tf.appendText("The pressed control is " +control.name+" with value "+control.value+" \n");
		}
		
		protected function getCachedSamples(event:Event):void
		{
			var data:ByteArray = new ByteArray();
			var _device:GameInputDevice;
			_device = GameInput.getDeviceAt(0);
			
			try
			{
				var completed:int = _device.getCachedSamples(data, true);
			} 
			catch(e:Error)
			{
				tf.appendText("FAIL \n");
			}
			
			if(completed > 0 && data.length > 0)
			{
				tf.scrollV++;
				tf.appendText("Number of samples are "+completed+" and byte length is "+data.length+" \n");
			}
		}

	}
}