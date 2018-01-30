package EditorPackage.EditParamUI 
{
	import EditorPackage.ObjParameter;
	import EditorPackage.ObjParameters;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	/**
	 * ...
	 * @author 
	 */
	public class EditParam_ListBox extends MovieClip
	{
		var objParameters:ObjParameters;
		var items:Array;
		var closed_function:Function;
		
		public function EditParam_ListBox() 
		{
			super();

			closed_function = null;
			addEventListener(MouseEvent.CLICK, PreventPropogationHandler); 
			addEventListener(MouseEvent.MOUSE_DOWN, PreventPropogationHandler); 
			addEventListener(MouseEvent.MOUSE_UP, PreventPropogationHandler); 

			addEventListener(KeyboardEvent.KEY_DOWN, TextInputKeyDown, false, 0, true);

			
			/*
			var bg:MovieClip = new MovieClip();
			bg.graphics.clear();
			bg.graphics.beginFill(0x0, 0.5);
			bg.graphics.drawRect(0, 0, Defs.displayarea_w, Defs.displayarea_h);
			bg.graphics.endFill();
			addChild(bg);
			*/
			
			items = new Array();
			
		}
		
		function TextInputKeyDown(e:KeyboardEvent)
		{
			var code:int = e.keyCode;
			if (code == KeyReader.KEY_ESCAPE)
			{
				Utils.print("Closed");
				if (closed_function != null)
				{
					closed_function();
				}
			}
		}
		
		function PreventPropogationHandler(e:MouseEvent)
		{
			e.stopImmediatePropagation();
		}
		
		public function SetPos(_x:int,_y:int)
		{
			x = _x;
			y = _y;
		}
		public function SetParameters(_objParameters:ObjParameters)
		{
			items = new Array();
			objParameters = _objParameters;

			var y:int = 0;
			
			var i:int = 0;
			for each(var op:ObjParameter in objParameters.list)
			{
				var type:String = "undefined";
				var ob:ObjParam = ObjectParameters.GetObjectParamByName(op.name);
				if (ob != null)
				{
					type = ob.type;
				}
				
				var item:EditParam_EditItem_Base;
				
				if (type == "text")
				{
					item = new EditParam_EditItem_Text();
				}
				else if (type == "number")
				{
					item = new EditParam_EditItem_Number();
				}
				else if (type == "angle")
				{
					item = new EditParam_EditItem_Angle();
				}
				else if (type == "list")
				{
					item = new EditParam_EditItem_List();
				}
				else if (type == "materiallist")
				{
					item = new EditParam_EditItem_MaterialList();
				}
				else if (type == "bool")
				{
					item = new EditParam_EditItem_Bool();
				}				
				else if (type == "linelink")
				{
					item = new EditParam_EditItem_LinePicker();
				}
				else if (type == "objlink")
				{
					item = new EditParam_EditItem_ObjectPicker();
				}
				else if (type == "editorlayer")
				{
					item = new EditParam_EditItem_EditorLayer();
				}
				else if (type == "color")
				{
					item = new EditParam_EditItem_ColorPicker();
				}
				else if (type == "undefined")
				{
					Utils.print("undefined edit item type. ERROR");
				}
				else
				{
					Utils.print("unhandled edit item type: "+ob.type);
					item = new EditParam_EditItem_Text() as EditParam_EditItem_Base;
				}
				
				
				item.Setup(op, this);
				item.parent_index = i;
				
				item.SetPos(0, y);
				
				items.push(item);
				y += item.mc.height;
				i++;
			}
			
			for each(item in items)
			{
				item.MovePos(0, Defs.displayarea_h - 20 - y);
			}
			
		}
		
		
	}

}