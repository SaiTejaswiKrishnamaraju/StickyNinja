package UIPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class UIX_InputText 
	{
		var parentPageInstance:UIX_PageInstance;
		var inst:UIX_Instance;
		var cursorPos:int;
		var maxChars:int;
		var originalText:String;
		
		public function UIX_InputText(_parent:UIX_PageInstance,_inst:UIX_Instance) 
		{
			parentPageInstance = _parent;
			inst = _inst;
			cursorPos = 0;
			maxChars = 16;
			originalText = _inst.GetButtonText();
		}
		
		var allowedKeys:Array = new Array(
				KeyReader.KEY_A,
				KeyReader.KEY_B,
				KeyReader.KEY_C,
				KeyReader.KEY_D,
				KeyReader.KEY_E,
				KeyReader.KEY_F,
				KeyReader.KEY_G,
				KeyReader.KEY_H,
				KeyReader.KEY_I,
				KeyReader.KEY_J,
				KeyReader.KEY_K,
				KeyReader.KEY_L,
				KeyReader.KEY_M,
				KeyReader.KEY_N,
				KeyReader.KEY_O,
				KeyReader.KEY_P,
				KeyReader.KEY_Q,
				KeyReader.KEY_R,
				KeyReader.KEY_S,
				KeyReader.KEY_T,
				KeyReader.KEY_U,
				KeyReader.KEY_V,
				KeyReader.KEY_W,
				KeyReader.KEY_X,
				KeyReader.KEY_Y,
				KeyReader.KEY_Z,
				KeyReader.KEY_1,
				KeyReader.KEY_2,
				KeyReader.KEY_3,
				KeyReader.KEY_4,
				KeyReader.KEY_5,
				KeyReader.KEY_6,
				KeyReader.KEY_7,
				KeyReader.KEY_8,
				KeyReader.KEY_9,
				KeyReader.KEY_0,
				KeyReader.KEY_SPACE
			);
			
		function GetCharFromKeyCode(keyCode:int):String
		{
			var char:String = String.fromCharCode(keyCode);
			trace(keyCode + "  " + char);
			return char;
		}
	
		
		
		public function Update()
		{
			if (KeyReader.Pressed(KeyReader.KEY_LEFT))
			{
				//CursorLeft();
			}
			if (KeyReader.Pressed(KeyReader.KEY_LEFT))
			{
				//CursorRight();
			}
			if (KeyReader.Pressed(KeyReader.KEY_BACKSPACE))
			{
				Backspace();
			}
			if (KeyReader.Pressed(KeyReader.KEY_DELETE))
			{
				//Delete();
			}
			if (KeyReader.Pressed(KeyReader.KEY_ENTER))
			{
				Enter();
			}
			if (KeyReader.Pressed(KeyReader.KEY_ESCAPE))
			{
				Escape();
			}
			for each(var k:int in allowedKeys)
			{
				if (KeyReader.Pressed(k))
				{
					KeyInput(k);
				}
			}
			
		}
		
		function UpdateStuff()
		{
			trace("cursorPos " + cursorPos+"     len "+inst.GetButtonText().length);
		}
		function Enter()
		{
			parentPageInstance.StopInput();
			UpdateStuff();
		}
		function Escape()
		{
			inst.SetText(originalText);
			UpdateStuff();
			parentPageInstance.StopInput();
		}
		
		function Backspace()
		{
			if (cursorPos == 0) return;
			var s:String = inst.GetButtonText();
			var s1:String = s.substring(0, cursorPos-1);
			var s2:String = s.substring(cursorPos)
			inst.SetText(s1 + s2);
			cursorPos--;
			UpdateStuff();			
		}
		function Delete()
		{
			if (cursorPos == 0) return;
			var s:String = inst.GetButtonText();
			var s1:String = s.substring(0, cursorPos-1);
			var s2:String = s.substring(cursorPos)
			inst.SetText(s1 + s2);
			cursorPos--;
			UpdateStuff();			
		}
		function CursorLeft()
		{
			cursorPos--;
			if (cursorPos <= 0) cursorPos = 0;
			UpdateStuff();
		}
		function CursorRight()
		{
			cursorPos++;
			var len:int = inst.GetButtonText().length;
			if (cursorPos >= len) cursorPos = len;
			UpdateStuff();
		}
		function KeyInput(keyCode:int)
		{
			if (cursorPos >= maxChars) return;
			var k:String = GetCharFromKeyCode(keyCode);
			var s:String = inst.GetButtonText();
			
			var s1:String = s.substring(0, cursorPos);
			var s2:String = s.substring(cursorPos);
			
			s = s1 + k + s2;
			inst.SetText(s);
			cursorPos++;
			UpdateStuff();
		}
		
	}

}