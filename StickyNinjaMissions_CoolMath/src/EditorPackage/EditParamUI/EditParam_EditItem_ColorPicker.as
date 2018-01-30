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
	public class EditParam_EditItem_ColorPicker extends EditParam_EditItem_Base
	{
		
		public function EditParam_EditItem_ColorPicker() 
		{
			super();
		}
		

		public override function Setup(_op:ObjParameter, _parent:MovieClip = null)
		{
			super.Setup(_op, _parent);
			
			var s:String = op.name + " : " + op.value;
			
			mc = new Editor_EditItem_ColorPicker();
			
			mc.editorItem = this;
			
			mc.displayText.text = op.name;
			
			var a:Array = op.value.split(".");
			if (a.length == 3)
			{
			
				mc.inputTextR.text = a[0];
				mc.inputTextG.text = a[1];
				mc.inputTextB.text = a[2];
			}
			
			mc.displayText.mouseEnabled = false;
			
			mc.inputTextR.addEventListener(TextEvent.TEXT_INPUT, TextInputDone, false, 0, true);
			mc.inputTextR.addEventListener(KeyboardEvent.KEY_DOWN, TextInputKeyDown, false, 0, true);
			mc.inputTextR.addEventListener(FocusEvent.FOCUS_OUT, TextInputLoseFocus, false, 0, true);
			mc.inputTextG.addEventListener(TextEvent.TEXT_INPUT, TextInputDone, false, 0, true);
			mc.inputTextG.addEventListener(KeyboardEvent.KEY_DOWN, TextInputKeyDown, false, 0, true);
			mc.inputTextG.addEventListener(FocusEvent.FOCUS_OUT, TextInputLoseFocus, false, 0, true);
			mc.inputTextB.addEventListener(TextEvent.TEXT_INPUT, TextInputDone, false, 0, true);
			mc.inputTextB.addEventListener(KeyboardEvent.KEY_DOWN, TextInputKeyDown, false, 0, true);
			mc.inputTextB.addEventListener(FocusEvent.FOCUS_OUT, TextInputLoseFocus, false, 0, true);
			
			
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
		
		public override function CopyValueToParameter()
		{
			op.value = mc.inputTextR.text + "." + mc.inputTextG.text + "." + mc.inputTextB.text;
			EditParams.DoChangedCallback(op);
		}
		
		
	}

}