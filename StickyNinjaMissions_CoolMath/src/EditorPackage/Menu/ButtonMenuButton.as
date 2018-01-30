package EditorPackage.Menu 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import UIPackage.UI;
	/**
	 * ...
	 * @author 
	 */
	public class ButtonMenuButton 
	{
		var mc:MovieClip;
		var func:Function;
		var testFunc:Function;
		var state:int;
		
		public function ButtonMenuButton(_text:String,_func:Function,_testFunc:Function=null) 
		{
			mc = new Editor_EditItem_Button();
			mc.displayText.text = _text;
			func = _func;
			testFunc = _testFunc;
			state = ButtonMenuButtonState.NORMAL;
			
			UI.AddBarebonesMCButton(mc, Clicked);
		}
		
		function Clicked(e:MouseEvent)
		{
			if (state != ButtonMenuButtonState.NORMAL) return;
			if (func != null)
			{				
				func();
			}
		}
		
	}

}