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
	import flash.geom.Point;
	import UIPackage.UI;
	/**
	 * ...
	 * @author 
	 */
	public class EditParam_EditItem_Angle extends EditParam_EditItem_Base
	{
		
		public function EditParam_EditItem_Angle() 
		{
			super();
		}
		

		public override function Setup(_op:ObjParameter, _parent:MovieClip = null)
		{
			super.Setup(_op, _parent);
			
			var s:String = op.name + " : " + op.value;
			
			mc = new Editor_EditItem_Angle();

			mc.editorItem = this;
			
			mc.displayText.text = op.name;
			mc.inputText.text = op.value;
			
			mc.displayText.mouseEnabled = false;
			
			
			mc.inputText.addEventListener(TextEvent.TEXT_INPUT, TextInputDone, false, 0, true);
			mc.inputText.addEventListener(KeyboardEvent.KEY_DOWN, TextInputKeyDown, false, 0, true);
			mc.inputText.addEventListener(FocusEvent.FOCUS_OUT, TextInputLoseFocus, false, 0, true);
			
			UI.AddButton(mc.buttonPlus, PlusPressed);
			UI.AddButton(mc.buttonMinus, MinusPressed);
			
			mc.anglePointer.addEventListener(MouseEvent.MOUSE_DOWN, AngleDown, false, 0, true);
			mc.anglePointer.addEventListener(MouseEvent.MOUSE_MOVE, AngleDown, false, 0, true);
			
			mc.filters = [];
			if (_op.multipleValues) mc.filters = [UI.greyFilter];
			
			PostSetup();
		}
		
		
		function SetAngleArrow()
		{
			mc.anglePointer.pointer.rotation = Number(mc.inputText.text)- (Math.PI / 2);
		}
		
		function AngleDown(e:MouseEvent)
		{
			if (e.buttonDown == false) return;
			
			var ang:Number = Math.atan2(e.localY, e.localX);
			
			Utils.print("angle down " + ang);
			
			var degree:Number = Utils.RadToDeg(ang + (Math.PI / 2));
			degree = Math.round(degree);
			mc.anglePointer.pointer.rotation = degree;
			mc.inputText.text = degree;
			CopyValueToParameter();
		}
		function PlusPressed(e:MouseEvent)
		{
			var inc:Number = 1;
			var val:Number = Number(mc.inputText.text);
			val += inc;
			mc.inputText.text = val.toString();
			CopyValueToParameter();
			SetAngleArrow();
		}
		
		function MinusPressed(e:MouseEvent)
		{
			var inc:Number = -1;
			var val:Number = Number(mc.inputText.text);
			val += inc;
			mc.inputText.text = val.toString();
			CopyValueToParameter();
			SetAngleArrow();
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
				CopyValueToParameter();
				SetAngleArrow();
				
				Game.main.stage.focus = null;
				
			}
		}
		function TextInputDone(e:TextEvent)
		{
			Utils.print("TextInputDone " + e.text);
		}
		
	}

}