package  
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	/**
	* ...
	* @author Default
	*/
	public class KeyReader 
	{
		public static const KEY_RIGHT:int = 39;
		public static const KEY_LEFT:int = 37;
		public static const KEY_UP:int = 38;
		public static const KEY_DOWN:int = 40;
		public static const KEY_SPACE:int = 32;
		public static const KEY_ENTER:int =13;
		public static const KEY_MINUS:int =189;
		public static const KEY_EQUALS:int =187;
		public static const KEY_DOT:int =190;
		
		public static const KEY_SQUIGGLE:int = 192;
		
		public static const KEY_A:int = 65;
		public static const KEY_B:int = 66;
		public static const KEY_C:int = 67;
		public static const KEY_D:int = 68;
		public static const KEY_E:int = 69;
		public static const KEY_F:int = 70;
		public static const KEY_G:int = 71;
		public static const KEY_H:int = 72;
		public static const KEY_I:int = 73;
		public static const KEY_J:int = 74;
		public static const KEY_K:int = 75;
		public static const KEY_L:int = 76;
		public static const KEY_M:int = 77;
		public static const KEY_N:int = 78;
		public static const KEY_O:int = 79;
		public static const KEY_P:int = 80;
		public static const KEY_Q:int = 81;
		public static const KEY_R:int = 82;
		public static const KEY_S:int = 83;
		public static const KEY_T:int = 84;
		public static const KEY_U:int = 85;
		public static const KEY_V:int = 86;
		public static const KEY_W:int = 87;
		public static const KEY_X:int = 88;
		public static const KEY_Y:int = 89;
		public static const KEY_Z:int = 90;
		
		public static const KEY_1:int = 49;
		public static const KEY_2:int = 50;
		public static const KEY_3:int = 51;
		public static const KEY_4:int = 52;
		public static const KEY_5:int = 53;
		public static const KEY_6:int = 54;
		public static const KEY_7:int = 55;
		public static const KEY_8:int = 56;
		public static const KEY_9:int = 57;
		public static const KEY_0:int = 48;
		
		public static const KEY_NUM_0:int = 96;
		public static const KEY_NUM_1:int = 97;
		public static const KEY_NUM_2:int = 98;
		public static const KEY_NUM_3:int = 99;
		public static const KEY_NUM_4:int = 100;
		public static const KEY_NUM_5:int = 101;
		public static const KEY_NUM_6:int = 102;
		public static const KEY_NUM_7:int = 103;
		public static const KEY_NUM_8:int = 104;
		public static const KEY_NUM_9:int = 105;
		public static const KEY_NUM_PLUS:int = 107;
		public static const KEY_NUM_MINUS:int = 109;
		
		public static const KEY_ESCAPE:int = 27;
		public static const KEY_TAB:int = 9;
		public static const KEY_INSERT:int = 45;
		public static const KEY_DELETE:int = 46;
		public static const KEY_HOME:int = 36;
		public static const KEY_END:int = 35;
		public static const KEY_PAGEUP:int = 33;
		public static const KEY_PAGEDOWN:int = 34;
		
		public static const KEY_F1:int = 112;
		public static const KEY_F2:int = 113;
		public static const KEY_F3:int = 114;
		public static const KEY_F4:int = 115;
		public static const KEY_F5:int = 116;
		public static const KEY_F6:int = 117;
		public static const KEY_F7:int = 118;
		public static const KEY_F8:int = 119;
		public static const KEY_F9:int = 120;
		public static const KEY_F10:int = 121;
		
		public static const KEY_SHIFT:int = 16;
		public static const KEY_CONTROL:int = 17;
		
		public static const KEY_BACKSPACE:int = 8;
		public static const KEY_BACKSLASH:int = 220;
		public static const KEY_FORWARDSLASH:int = 191;
		public static const KEY_HASH:int = 222;
		public static const KEY_SEMICOLON:int = 186
		public static const KEY_LEFTSQUAREBRACKET:int = 219;
		public static const KEY_RIGHTSQUAREBRACKET:int = 221;
		public static const KEY_TOPLEFT:int = 223;
		public static const KEY_COMMA:int= 188;
		public static const KEY_PERIOD:int = 190;
		
		

		public static var active:Boolean;
		public static var keysDown:Vector.<int>;
		public static var keysCleared:Vector.<Boolean>;
		public static var keysPressed:Vector.<Boolean>;
		
		public static function Reset()
		{
			keysDown = new Vector.<int>(256);
			keysCleared = new Vector.<Boolean>(256);
			keysPressed = new Vector.<Boolean>(256);
			var i:int;
			for (i = 0; i < 256; i++)
			{
				keysDown[i] = int(0);
				keysPressed[i] = Boolean(false);
				keysCleared[i] = Boolean(false);
			}			
			active = true;
		}
		public static function InitOnce(stage:Stage)
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			stage.focus = stage;
			Reset();
		}
		
		public function KeyReader() 
		{
		}
		
		public static function Disable()
		{
			Reset();
			active = false;
		}
		public static function Enable()
		{
			active = true;
		}
		
		public static function UpdateOncePerFrame():void
		{
			if (active == false) return;
			var i:int;
			for (i = 0; i < 256; i++)
			{
				if (keysDown[i] == 1)
				{
					keysPressed[i] = true;
					keysDown[i]++;
				}
				else
				{
					keysPressed[i] = false;
				}				
			}
		}
		
//		public function SetDown(keyID:int,value:Boolean)
//		{
//			if(value)
//				keysDown[keyID]++;
//			else
//				keysDown[keyID] = 0;
//		}
		
		public static function Down(keyID:int):Boolean
		{
			if (active == false) return false;
			if (keyID > 255) return false;
			if (keysCleared[keyID] == true) return false;
			return (keysDown[keyID] != 0);
		}
		
		public static function Pressed(keyID:int):Boolean
		{
			if (active == false) return false;
			if (keyID > 255) return false;
			return keysPressed[keyID];
		}
		public static function ClearKey(keyID:int):void
		{
			if (keyID > 255) return;
			keysPressed[keyID] = false;
			keysDown[keyID] = 0;
			keysCleared[keyID] = true;
		}
	
		static function keyDownListener(event:KeyboardEvent):void 
		{
			if (active == false) return;
			var code:int = event.keyCode;
			if (code > 255) return;
			keysDown[code]++;
//			Utils.trace(code);
		}

		static function keyUpListener(event:KeyboardEvent):void 
		{
			if (active == false) return;
			var code:int = event.keyCode;
			if (code > 255) return;
			keysDown[code ] = 0;
			keysCleared[code] = false;
		}		
	}
	
}