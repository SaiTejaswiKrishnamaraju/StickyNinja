package EditorPackage.EditParamUI 
{
	import EditorPackage.ObjParameter;
	import EditorPackage.PhysEditor;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import UIPackage.UI;
	/**
	 * ...
	 * @author 
	 */
	public class EditParam_EditItem_Text extends EditParam_EditItem_Base
	{
		
		public function EditParam_EditItem_Text() 
		{
			super();
		}
		

		public override function Setup(_op:ObjParameter, _parent:MovieClip = null)
		{
			super.Setup(_op, _parent);
			
			var s:String = op.name + " : " + op.value;
			
			mc = new Editor_EditItem_Text();
			
			mc.editorItem = this;
			
			mc.displayText.text = op.name;
			mc.inputText.text = op.value;
			
			mc.displayText.mouseEnabled = false;
			
			mc.inputText.addEventListener(TextEvent.TEXT_INPUT, TextInputDone, false, 0, true);
			mc.inputText.addEventListener(KeyboardEvent.KEY_DOWN, TextInputKeyDown, false, 0, true);
			mc.inputText.addEventListener(FocusEvent.FOCUS_OUT, TextInputLoseFocus, false, 0, true);
			
			
			mc.filters = [];
			if (_op.multipleValues) mc.filters = [UI.greyFilter];
			
			PostSetup();
		}
		
		
		function TextInputLoseFocus(e:FocusEvent)
		{
			PhysEditor.isEntering = false;
			CopyValueToParameter();
			
		}
		function TextInputKeyDown(e:KeyboardEvent)
		{
			PhysEditor.isEntering = true;

			var code:int = e.keyCode;
			if (code == KeyReader.KEY_ENTER)
			{
				Utils.print("Entered");
				CopyValueToParameter();
				PhysEditor.isEntering = false;
				Game.main.stage.focus = null;
			}
		}
		function TextInputDone(e:TextEvent)
		{
			Utils.print("TextInputDone " + e.text);
		}
		
	}

}