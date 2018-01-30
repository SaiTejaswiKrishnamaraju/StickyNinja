package EditorPackage 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import UIPackage.UI;
	/**
	 * ...
	 * @author Julian
	 */
	public class EditorLayer 
	{
		var name:String;
		var index:int;
		var visible:Boolean;
		var locked:Boolean;
		var active:Boolean;
		var mc:Editor_EditItem_Layer;
		
		public function EditorLayer(_index:int, _name:String) 
		{
			name = _name;
			index = _index;
			visible = true;	
			locked = false;
			active = false;
			mc = new Editor_EditItem_Layer();
		
			mc.editorLayer = this;
			mc.displayText.text = "LAYER " + int(index + 1);
			
			UI.AddBarebonesMCButton(mc.buttonVisible, clickedVisible);
			UI.AddBarebonesMCButton(mc.buttonLocked, clickedLocked);
			UI.AddBarebonesMCButton(mc.buttonSelected, clickedSelected);
			
			UI.SetNonPropagateMouse(mc.buttonVisible);
			UI.SetNonPropagateMouse(mc.buttonLocked);
			UI.SetNonPropagateMouse(mc.buttonSelected);
			
		}
		
		function clickedVisible(e:MouseEvent)
		{
			e.stopPropagation();
			e.stopImmediatePropagation();
			ToggleVisibility();
			UpdateUI();
		}
		function clickedLocked(e:MouseEvent)
		{
			e.stopPropagation();
			e.stopImmediatePropagation();
			ToggleLocked();
			UpdateUI();
		}
		function clickedSelected(e:MouseEvent)
		{
			e.stopPropagation();
			e.stopImmediatePropagation();
			EditorLayers.SetActive(index);
			EditorLayers.UpdateUI();
		}
		
		public function UpdateUI()
		{
			mc.buttonVisible.cross.visible = true;
			mc.buttonLocked.cross.visible = true;
			mc.buttonSelected.cross.visible = true;
			
			if (visible) mc.buttonVisible.cross.visible = false;
			if (locked) mc.buttonLocked.cross.visible = false;
			if (active) mc.buttonSelected.cross.visible = false;
		}
		
		public function ToggleVisibility()
		{
			visible = (visible == false);
		}
		public function ToggleLocked()
		{
			locked = (locked == false);
		}
		public function ToggleActive()
		{
			active = (active == false);
		}
		
		public function IsVisible():Boolean
		{
			return visible;
		}
		public function IsLocked():Boolean
		{
			return locked;
		}
		public function IsActive():Boolean
		{
			return active;
		}
		
	}

}