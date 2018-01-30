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
	public class EditParam_EditItem_List extends EditParam_EditItem_Base
	{
		var popup:MovieClip;
		var popupList:Array;
		
		public function EditParam_EditItem_List() 
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
			mc.inputText.mouseEnabled = false;

			UI.AddButton(mc.buttonElipsis, ElipsisPressed)
			
			mc.filters = [];
			if (_op.multipleValues) mc.filters = [UI.greyFilter];
			
			PostSetup();
		}
		
		function ElipsisPressed(e:MouseEvent)
		{
			InitListPopup();
		}
		
		function CloseListPopup()
		{
			mc.parent.removeChild(popup);
			popup = null;
		}
		function InitListPopup()
		{
			Utils.print("InitListPopup");
			popup = new MovieClip();
			popup.graphics.clear();
			popup.graphics.beginFill(0x0, 0.5);
			popup.graphics.drawRect(-1000, -1000, Defs.displayarea_w+1000, Defs.displayarea_h+1000);
			popup.graphics.endFill();
			
			popupList = new Array();
			
			var ob:ObjParam = ObjectParameters.GetObjectParamByName(op.name);
			
			var y:int = 10;
			for (var i:int = 0; i < ob.valueList.length; i++)
			{
				var itemString:String = ob.valueList[i];
				
				var item:MovieClip = new Editor_EditItem_ListItem();
				item.displayText.text = itemString;
				item.listIndex = i;
				item.buttonMode = true;
				item.useHandCursor = true;
				item.addEventListener(MouseEvent.CLICK, PopupClicked, false, 0, true);
				
				item.displayBox.visible = false;
				
				item.displayText.mouseEnabled = false;
				item.highlight.visible = false;
				if (itemString == op.value)
				{
					item.highlight.visible = true;
				}
				
				popupList.push(item);
				popup.addChild(item);
				
				item.x = 10;
				item.y = y;
				y += item.height;
				
			}
			mc.parent.addChild(popup);
			
		}
		
		function PopupClicked(e:MouseEvent)
		{
			var item:MovieClip = e.currentTarget as MovieClip;
			Utils.print("pressed " + item.listIndex);
			CloseListPopup();
			
			mc.inputText.text = item.displayText.text;
			CopyValueToParameter();
		}
		
		
	}

}