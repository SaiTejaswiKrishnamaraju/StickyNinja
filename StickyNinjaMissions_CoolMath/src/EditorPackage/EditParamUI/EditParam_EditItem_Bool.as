package EditorPackage.EditParamUI 
{
	import EditorPackage.ObjParameter;
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
	public class EditParam_EditItem_Bool extends EditParam_EditItem_Base
	{
		
		public function EditParam_EditItem_Bool() 
		{
			super();
		}
		

		public override function Setup(_op:ObjParameter, _parent:MovieClip = null)
		{
			super.Setup(_op, _parent);
			
			var s:String = op.name + " : " + op.value;
			
			mc = new Editor_EditItem_Bool();

			mc.editorItem = this;
			
			mc.displayText.text = op.name;
			
			mc.displayText.mouseEnabled = false;

			
			UI.AddBarebonesMCButton(mc.buttonTrue,TruePressed)
			UI.AddBarebonesMCButton(mc.buttonFalse,FalsePressed)
			
			UpdateButtons();
			
			mc.filters = [];
			if (_op.multipleValues) mc.filters = [UI.greyFilter];
			
			PostSetup();
		}
		
		function UpdateButtons()
		{
			mc.buttonTrue.highlight.visible = false;
			mc.buttonFalse.highlight.visible = false;
			
			if (op.value == "true")
			{
				mc.buttonTrue.highlight.visible = true;
			}
			else
			{
				mc.buttonFalse.highlight.visible = true;
			}
			
		}
		
		function TruePressed(e:MouseEvent)
		{
			op.value = "true";
			EditParams.DoChangedCallback(op);
			UpdateButtons();
		}
		function FalsePressed(e:MouseEvent)
		{
			op.value = "false";
			EditParams.DoChangedCallback(op);
			UpdateButtons();
		}
		
		
	}

}