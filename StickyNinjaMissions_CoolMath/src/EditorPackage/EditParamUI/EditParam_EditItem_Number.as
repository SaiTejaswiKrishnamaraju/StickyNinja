package EditorPackage.EditParamUI 
{
	import EditorPackage.ObjParameter;
	import EditorPackage.PhysEditor;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import UIPackage.UI;
	/**
	 * ...
	 * @author 
	 */
	public class EditParam_EditItem_Number extends EditParam_EditItem_Base
	{
		
		public function EditParam_EditItem_Number() 
		{
			super();
		}
		

		public override function Setup(_op:ObjParameter, _parent:MovieClip = null)
		{
			super.Setup(_op, _parent);
			
			var s:String = op.name + " : " + op.value;
			
			mc = new Editor_EditItem_Number();

			mc.editorItem = this;
			
			mc.displayText.text = op.name;
			mc.inputText.text = op.value;
			
			mc.displayText.mouseEnabled = false;
			
			
			mc.inputText.addEventListener(TextEvent.TEXT_INPUT, TextInputDone, false, 0, true);
			mc.inputText.addEventListener(KeyboardEvent.KEY_DOWN, TextInputKeyDown, false, 0, true);
			mc.inputText.addEventListener(FocusEvent.FOCUS_OUT, TextInputLoseFocus, false, 0, true);
			
			UI.AddButton(mc.buttonPlus,PlusPressed)
			UI.AddButton(mc.buttonMinus,MinusPressed)
			
			mc.filters = [];
			if (_op.multipleValues) mc.filters = [UI.greyFilter];
			
			PostSetup();
		}
		
		
		function PlusPressed(e:MouseEvent)
		{
			var ob:ObjParam = ObjectParameters.GetObjectParamByName(mc.displayText.text);
			var inc:Number = ob.number_step;
			var val:Number = Number(mc.inputText.text);
			val += inc;
			mc.inputText.text = val.toString();
			
			CheckRange();
			CopyValueToParameter();
		}
		
		function MinusPressed(e:MouseEvent)
		{
			var ob:ObjParam = ObjectParameters.GetObjectParamByName(mc.displayText.text);
			var inc:Number = -ob.number_step;
			var val:Number = Number(mc.inputText.text);
			val += inc;
			mc.inputText.text = val.toString();
			
			CheckRange();
			
			CopyValueToParameter();
		}
		
		function CheckRange()
		{
			var val:Number = Number(mc.inputText.text);
			var ob:ObjParam = ObjectParameters.GetObjectParamByName(mc.displayText.text);
			if (ob.number_useRangeMin)
			{
				if (val < ob.number_min) val = ob.number_min;
			}
			if (ob.number_useRangeMax)
			{
				if (val > ob.number_max) val = ob.number_min;
			}
			mc.inputText.text = val.toString();
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
				PhysEditor.isEntering = false;
				
				
				CheckRange();
				
				CopyValueToParameter();
				
				Game.main.stage.focus = null;
				
			}
		}
		function TextInputDone(e:TextEvent)
		{
			Utils.print("TextInputDone " + e.text);
		}
		
	}

}