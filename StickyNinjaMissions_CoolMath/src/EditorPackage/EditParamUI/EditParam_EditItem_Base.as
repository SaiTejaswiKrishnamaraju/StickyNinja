package EditorPackage.EditParamUI 
{
	import EditorPackage.ObjParameter;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class EditParam_EditItem_Base 
	{
		
		var op:ObjParameter;
		var parent:MovieClip;
		var mc:MovieClip;
		var selected:Boolean;
		var parent_index:int;
		
		var x:Number;
		var y:Number;
		
		public function EditParam_EditItem_Base() 
		{
			op = null;
			parent = null;
			parent_index = 0;
			mc = null;
			selected = false;
			
		}

		public function SetPos(_x:int, _y:int)
		{
			mc.x = _x;
			mc.y = _y;
		}
		public function MovePos(_x:int, _y:int)
		{
			mc.x += _x;
			mc.y += _y;
		}
		
		// Overridable functions
		public function Setup(_op:ObjParameter, _parent:MovieClip = null)
		{
			op = _op;
			parent = _parent;
			selected = false;
			
		}
		public function PostSetup()
		{			
			if (parent != null)
			{
				parent.addChild(mc);
			}			if (mc.highlight != null)
			{
				mc.highlight.visible = false;
			}
		}
		
		public function CancelParameter()
		{
		}
		public function ValidateParameter():Boolean
		{
			return true;
		}
		public function CopyValueToParameter()
		{
			op.value = mc.inputText.text;
			EditParams.DoChangedCallback(op);
		}
		
		
	}

}