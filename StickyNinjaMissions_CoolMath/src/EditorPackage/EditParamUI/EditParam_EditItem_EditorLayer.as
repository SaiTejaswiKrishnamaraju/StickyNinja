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
	public class EditParam_EditItem_EditorLayer extends EditParam_EditItem_Base
	{
		
		public function EditParam_EditItem_EditorLayer() 
		{
			super();
		}
		

		public override function Setup(_op:ObjParameter, _parent:MovieClip = null)
		{
			super.Setup(_op, _parent);
			
			var s:String = op.name + " : " + op.value;
			
			mc = new Editor_EditItem_EditorLayer();

			mc.editorItem = this;
			
			mc.displayText.text = op.name;
			mc.displayText.mouseEnabled = false;
			
			
			UI.AddBarebonesMCButton(mc.button1,Pressed1)
			UI.AddBarebonesMCButton(mc.button2,Pressed2)
			UI.AddBarebonesMCButton(mc.button3,Pressed3)
			UI.AddBarebonesMCButton(mc.button4,Pressed4)
			
			UpdateButtons();
			
			mc.filters = [];
			if (_op.multipleValues) mc.filters = [UI.greyFilter];
			
			PostSetup();
		}
		
		function UpdateButtons()
		{
			mc.button1.highlight.visible = false;
			mc.button2.highlight.visible = false;
			mc.button3.highlight.visible = false;
			mc.button4.highlight.visible = false;
			
			if (op.value == "1") mc.button1.highlight.visible = true;
			if (op.value == "2") mc.button2.highlight.visible = true;
			if (op.value == "3") mc.button3.highlight.visible = true;
			if (op.value == "4") mc.button4.highlight.visible = true;
			
		}
		
		function Pressed1(e:MouseEvent)
		{
			op.value = "1";
			EditParams.DoChangedCallback(op);
			UpdateButtons();
		}
		function Pressed2(e:MouseEvent)
		{
			op.value = "2";
			EditParams.DoChangedCallback(op);
			UpdateButtons();
		}
		function Pressed3(e:MouseEvent)
		{
			op.value = "3";
			EditParams.DoChangedCallback(op);
			UpdateButtons();
		}
		function Pressed4(e:MouseEvent)
		{
			op.value = "4";
			EditParams.DoChangedCallback(op);
			UpdateButtons();
		}
		
		
	}

}