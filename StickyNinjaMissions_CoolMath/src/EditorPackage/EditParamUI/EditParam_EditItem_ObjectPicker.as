package EditorPackage.EditParamUI 
{
	import EditorPackage.EditableObjectBase;
	import EditorPackage.EdLine;
	import EditorPackage.EdObj;
	import EditorPackage.ObjParameter;
	import EditorPackage.PhysEditor;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import UIPackage.UI;
	/**
	 * ...
	 * @author 
	 */
	public class EditParam_EditItem_ObjectPicker extends EditParam_EditItem_Base
	{
		
		public function EditParam_EditItem_ObjectPicker() 
		{
			super();
		}
		

		public override function Setup(_op:ObjParameter, _parent:MovieClip = null)
		{
			super.Setup(_op, _parent);
			
			var s:String = op.name + " : " + op.value;
			
			mc = new Editor_EditItem_List();

			mc.editorItem = this;
			
			mc.displayText.text = op.name;
			mc.inputText.text = op.value;
			
			mc.displayText.mouseEnabled = false;
			
			
			mc.inputText.addEventListener(TextEvent.TEXT_INPUT, TextInputDone, false, 0, true);
			mc.inputText.addEventListener(KeyboardEvent.KEY_DOWN, TextInputKeyDown, false, 0, true);
			mc.inputText.addEventListener(FocusEvent.FOCUS_OUT, TextInputLoseFocus, false, 0, true);
			
			mc.addEventListener(MouseEvent.ROLL_OVER, OnRollOver, false, 0, true);
			mc.addEventListener(MouseEvent.ROLL_OUT, OnRollOut, false, 0, true);
			
			UI.AddButton(mc.buttonElipsis, ElipsisPressed)
			
			mc.filters = [];
			if (_op.multipleValues) mc.filters = [UI.greyFilter];
			
			PostSetup();
		}
		
		function OnRollOut(e:MouseEvent)
		{
			var g:Graphics = mc.graphics;
			g.clear();
		}
		function OnRollOver(e:MouseEvent)
		{
			var obj:EditableObjectBase = PhysEditor.GetAnyObjectById(mc.inputText.text);
			if (obj != null)
			{
				var x1:Number = obj.GetCentreHandle().x - PhysEditor.scrollX;
				var y1:Number = obj.GetCentreHandle().y - PhysEditor.scrollY;
				var r:Rectangle = mc.getRect(null);
				var p:Point = mc.localToGlobal( new Point(r.right+3,(r.top+r.bottom)*0.5 ));
				var g:Graphics = mc.graphics;
				g.clear();
				g.lineStyle(3, 0xffffff, 1);
				g.moveTo(p.x, p.y);
				g.lineTo(x1, y1);
			}
		}
		function ElipsisPressed(e:MouseEvent)
		{
			PhysEditor.oldEditMode = PhysEditor.editMode;
			PhysEditor.editModeObj_PickPieceForLink.returnFunction = PickPieceReturnFunction;
			PhysEditor.SetEditMode(PhysEditor.editMode_PickPieceForLink,false);
			PhysEditor.CursorText_Set("Pick Object");				
		}
		public function PickPieceReturnFunction(_obj:EdObj)
		{
			var id:String = "";
			if (_obj != null)
			{
				id = PhysEditor.GetOrCreateUniqueObjectID(_obj);
			}			
			mc.inputText.text = id;
			CopyValueToParameter();
			
			PhysEditor.SetEditMode(PhysEditor.oldEditMode,false);
			PhysEditor.CursorText_Set("");

		}
		
		
		function TextInputLoseFocus(e:FocusEvent)
		{
			PhysEditor.isEntering = false;
			CancelParameter();
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

				Game.main.stage.focus = null;
				
			}
		}
		function TextInputDone(e:TextEvent)
		{
			Utils.print("TextInputDone " + e.text);
		}
		
	}

}