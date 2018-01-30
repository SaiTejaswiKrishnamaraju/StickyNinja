package EditorPackage 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import UIPackage.UI;
	/**
	 * ...
	 * @author 
	 */
	public class EdModalDialog
	{
		static var mc:MovieClip;		
		static var box:Editor_ModalBox;		
		
		static var cb:Function;
		
		public static function Stop()
		{
			mc.removeChild(box);
			box = null;			
			Game.main.stage.removeChild(mc);
			mc = null;
			KeyReader.InitOnce(Game.main.stage);			
		}
		
		
		
		public static function Start(name:String, _initialString:String,_cb:Function)
		{
			cb = _cb;
			mc = new MovieClip();
			mc.graphics.clear();
			mc.graphics.beginFill(0x0000, 0.5);
			mc.graphics.drawRect(0, 0, Defs.editor_area_w, Defs.displayarea_h);
			mc.graphics.endFill();
			
			box = new Editor_ModalBox();
			
			box.titleText.text = name;
			box.inputText.text = _initialString;
			UI.AddMCButton(box.buttonYes, clickedYes);
			UI.AddMCButton(box.buttonNo, clickedNo);
			mc.addChild(box);
			
			box.x = (Defs.displayarea_w2 - (box.width / 2));
			box.y = (Defs.displayarea_h2 - (box.height / 2));
			
			Game.main.stage.addChild(mc);
		}
		
		public static function clickedYes(e:MouseEvent)
		{
			var result:EdModalDialogResult = new EdModalDialogResult();
			result.resultString = box.inputText.text;
			result.resultInt = int(box.inputText.text);
			result.resultNumber = Number(box.inputText.text);
			result.yes = true;
			
			Stop();
			
			if (cb)
			{
				cb(result);
			}
		}
		public static function clickedNo(e:MouseEvent)
		{
			var result:EdModalDialogResult = new EdModalDialogResult();
			result.resultString = box.inputText.text;
			result.resultInt = int(box.inputText.text);
			result.resultNumber = Number(box.inputText.text);
			result.yes = false;
			
			Stop();
			
			if (cb)
			{
				cb(result);
			}
		}
		
		public function EdModalDialog() 
		{
		}
		
	}

}