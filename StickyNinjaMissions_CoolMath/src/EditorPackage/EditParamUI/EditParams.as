package EditorPackage.EditParamUI 
{
	import EditorPackage.EdLine;
	import EditorPackage.EdObj;
	import EditorPackage.ObjParameter;
	import EditorPackage.ObjParameters;
	import EditorPackage.PhysEditor;
	import fl.controls.ComboBox;
	import fl.controls.List;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.events.ListEvent;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditParams
	{
		
		public function EditParams() 
		{
			
		}
		
		
		static var objParameters:ObjParameters;
		static var currentParamIndex:int=0;
		
		
		static var listBox:List = null;
		static var listBoxContainer:MovieClip = null;
		
		public static function ClearParameterListBox()
		{		
			
//			KeyReader.Enable();
			if (listBoxContainer != null)
			{
				listBoxContainer.parent.removeChild(listBoxContainer);
				listBoxContainer = null;
				PhysEditor.isEntering = false;
				
			}
		}
		
		public static function PreventPropogationHandler(e:MouseEvent)
		{
			e.stopImmediatePropagation();
		}

		public static function AddParameterListBoxOrClear(_objParameters:ObjParameters)
		{
			if (_objParameters != null)
			{
				AddParameterListBox(_objParameters);
			}
			else
			{
				ClearParameterListBox();
			}
		}
		
		public static function OpenCurrentParameterEdit()
		{
			CurrentAdjustObject_EnterParameter();
		}
		
		
		public static function DoChangedCallback(op:ObjParameter)
		{
			if (parameterChangedCallback != null)
			{
				parameterChangedCallback(op);
			}
		}
		
		static var parameterChangedCallback:Function = null;
		
		public static function AddParameterListBox(_objParameters:ObjParameters,callback:Function=null)
		{
			parameterChangedCallback = callback;
			objParameters = _objParameters;
			
			currentParamIndex = 0;
			
			ClearParameterListBox();

			listBoxContainer = new EditParam_ListBox();
			listBoxContainer.closed_function = ListBoxClosed;

			PhysEditor.editorMC.addChild(listBoxContainer);
			
			listBoxContainer.x = Defs.editor_x;
			
			listBoxContainer.SetParameters(objParameters);
			
//			KeyReader.Disable();
			
//			listBoxContainer.stage.focus = listBoxContainer;
			

		}
		
		public static function ListBoxClosed()
		{
			Utils.print("Closed2");
			ClearParameterListBox();

		}
		
		public static function UpdateListBoxItem(index:int)
		{
			listBox.removeAll();
		
			for each(var op:ObjParameter in objParameters.list)
			{
				var o:Object = new Object();				
				var s:String = op.name + " : " + op.value;
				o.label = s;
				o.data = s;
				listBox.addItem(o);
			}
		}

		
		public static function AddParameterListBox_changeHandler(event:ListEvent):void 
		{ 
			event.stopImmediatePropagation();
			var list:List = List(event.target);
			if (list == null) return;
			var cr:CellRenderer = list.itemToCellRenderer(event.item) as CellRenderer;
			var listData:ListData = cr.listData;
			
			currentParamIndex = listData.row;
			CurrentAdjustObject_EnterParameter();
		}

		public static function PickLineReturnFunction(_EdLine:EdLine)
		{
			var id:String = "";
			if (_EdLine != null)
			{
				id = PhysEditor.GetOrCreateUniqueLineID(_EdLine);
				UpdateListBoxItem(currentParamIndex);
			}
			Utils.print("here " + id);
			CurrentAdjustObject_UpdateCurrentParameter(id);
			UpdateListBoxItem(currentParamIndex);
			
			PhysEditor.SetEditMode(PhysEditor.oldEditMode,false);
			PhysEditor.CursorText_Set("");

		}
		
		public static function PickObjectReturnFunction(poi:EdObj)
		{
			var id:String = "";
			if (poi != null)
			{
				id = PhysEditor.GetOrCreateUniqueObjectID(poi);
				UpdateListBoxItem(currentParamIndex);
			}
			Utils.print("here1 " + id);
			CurrentAdjustObject_UpdateCurrentParameter(id);
			UpdateListBoxItem(currentParamIndex);
			
			PhysEditor.SetEditMode(PhysEditor.oldEditMode,false);
			PhysEditor.CursorText_Set("");

		}
		
		public static function CurrentAdjustObject_EnterParameter()
		{
			var param:ObjParameter = objParameters.GetByIndex(currentParamIndex) ;
			var paramName:String = param.name;
			var ob:ObjParam = ObjectParameters.GetObjectParamByName(paramName);
			if (ob == null) return;
			if (ob.type == "list")
			{
				AddComboBoxEntry(GetParamXpos(currentParamIndex),GetParamYpos(currentParamIndex), ob.name,CurrentAdjustObject_GetSelectedParameterValue(),  ob.valueList,CurrentAdjustObject_EnterParameter_Done);
			}
			else if (ob.type == "linelink" && KeyReader.Down(KeyReader.KEY_SHIFT) )
			{
				PhysEditor.oldEditMode = PhysEditor.editMode;
				PhysEditor.editModeObj_PickLineForLink.returnFunction = PickLineReturnFunction;
				PhysEditor.SetEditMode(PhysEditor.editMode_PickLineForLink,false);
				PhysEditor.CursorText_Set("Pick Line");				
			}
			else if (ob.type == "objlink" && KeyReader.Down(KeyReader.KEY_SHIFT) )
			{
				PhysEditor.oldEditMode = PhysEditor.editMode;
				PhysEditor.editModeObj_PickPieceForLink.returnFunction = PickObjectReturnFunction;
				PhysEditor.SetEditMode(PhysEditor.editMode_PickPieceForLink,false);
				PhysEditor.CursorText_Set("Pick Object");
				
			}
			
			
			else
			{
				AddTextEntry(GetParamXpos(PhysEditor.editModeObj_Adjust.currentAdjustObjectParam),GetParamYpos(PhysEditor.editModeObj_Adjust.currentAdjustObjectParam), ob.name,CurrentAdjustObject_GetSelectedParameterValue(), CurrentAdjustObject_EnterParameter_Done);
			}
		}
		
		public static function CurrentAdjustObject_EnterParameter_Done(text:String)
		{
			CurrentAdjustObject_UpdateCurrentParameter(text);
			UpdateListBoxItem(currentParamIndex);
		}
		
		public static function ParameterListBox_SetSelectedIndex()
		{
			if (listBoxContainer != null)
			{
				listBox.selectedIndex = currentParamIndex;
			}
		}
		static function CurrentAdjustObject_UpdateCurrentParameter(newValue:String):void
		{
			var param:ObjParameter = objParameters.GetByIndex(currentParamIndex) ;
			param.value = newValue;
		}
		static function CurrentAdjustObject_GetSelectedParameterName():String 
		{
			var param:ObjParameter = objParameters.GetByIndex(currentParamIndex) ;
			return param.name;
		}
		static function CurrentAdjustObject_GetSelectedParameterValue():String 
		{
			var param:ObjParameter = objParameters.GetByIndex(currentParamIndex) ;
			return param.value;
		}
		static function CurrentAdjustObject_SelectNextParameter()
		{
			currentParamIndex++;
			if (currentParamIndex >= objParameters.list.length) currentParamIndex = 0;			
			ParameterListBox_SetSelectedIndex();
		}
		
		public static function GetParamXpos(index:int):int
		{
			return 230;	// instanceParamsStartX + 100;
		}
		public static function GetParamYpos(index:int):int
		{
			return Defs.displayarea_h - 100;	// instanceParamsStartY + (index * 15);
		}
		
		static var instanceParamsStartY:int;
		static var instanceParamsStartX:int;
		public static function RemoveEntryMC()
		{
			if (entryMC != null)
			{
				entryMC.parent.removeChild(entryMC);
				entryMC = null;
			}
		}
		public static function AddEntryMC()
		{
			RemoveEntryMC();			
			entryMC = new MovieClip();
			entryMC.x = 0;
			entryMC.y = 0;
			entryMC.graphics.clear();
			entryMC.graphics.beginFill(0xffffff, 0.5);
			entryMC.graphics.drawRect(entryMC.x, entryMC.y,Defs.displayarea_w,Defs.displayarea_h);
			entryMC.graphics.endFill();
			PhysEditor.editorMC.addChild(entryMC);
			entryMC.addEventListener(MouseEvent.CLICK, PreventPropogationHandler); 
			entryMC.addEventListener(MouseEvent.MOUSE_DOWN, PreventPropogationHandler); 
			entryMC.addEventListener(MouseEvent.MOUSE_UP, PreventPropogationHandler); 
		}
		
		static var entryMC:MovieClip = null;
		static var comboBox:ComboBox;
		public static function AddComboBoxEntry(xpos:int, ypos:int, title:String,text:String,inputList:Array,_cb:Function)
		{
			
			AddEntryMC();
			
			
			AddTextEntry_Callback = _cb;
			comboBox = new fl.controls.ComboBox();
			comboBox.x = xpos;
			comboBox.y = ypos;
			comboBox.alpha = 1;
			comboBox.width = 300;
			
			entryMC.addChild(comboBox);
			
			var selectedIndex:int = 0;
			var count:int = 0;
			for each(var s:String in inputList)
			{
				var o:Object = new Object();
				o.label = s;
				o.data = s;
				if (s == text) 
				{
					comboBox.selectedItem = o;
					selectedIndex = count;
				}
				comboBox.addItem(o);
				count++;
			}
			
			comboBox.selectedIndex = selectedIndex;
			
			comboBox.prompt = text;
			comboBox.addEventListener(Event.CHANGE, AddComboBoxEntry_changeHandler,false,0,true); 
			//comboBox.addEventListener(KeyboardEvent.KEY_DOWN, ComboBox_keyDownHandler,false,0,true);
			
			Game.main.stage.focus = comboBox;
		}
		static function ComboBox_Close()
		{
			Game.main.stage.focus = null;
			PhysEditor.isEntering = false;
			ComboBox_RemoveHandlers();
			comboBox.close();
			RemoveEntryMC();
			
		}
		static function ComboBox_RemoveHandlers()
		{
			comboBox.removeEventListener(Event.CHANGE, AddComboBoxEntry_changeHandler); 
			//comboBox.removeEventListener(KeyboardEvent.KEY_DOWN, ComboBox_keyDownHandler); 
		}
		
		static function ComboBox_keyDownHandler(e:KeyboardEvent)		
		{			
			if (PhysEditor.isEntering == false) return;
			if ( e.charCode ==KeyReader.KEY_ESCAPE)
			{
				Utils.print("cancelled");
				ComboBox_Close();
			}			
		}
		
		static function AddComboBoxEntry_changeHandler(event:Event):void 
		{ 
			var selection:String  = ComboBox(event.target).selectedItem.data; 
			
			ComboBox_Close();
			
			if (AddTextEntry_Callback != null)
			{
				AddTextEntry_Callback(selection);
			}
		}
		
		static var pickedPieceForLink:EdObj = null;
		static var tf:TextField;
		static var AddTextEntry_Callback:Function;
		static function AddTextEntry(xpos:int, ypos:int, title:String,text:String,_cb:Function)
		{
			AddEntryMC();
			
			AddTextEntry_Callback = _cb;
			var f:TextFormat;
			
			f = new TextFormat();
			f.size = 20;
			f.color = 0x0;
			
			tf = new TextField();
			tf.name = "tf";
			tf.type = TextFieldType.INPUT;
			entryMC.addChild(tf);
			tf.x = xpos;
			tf.y = ypos;
			tf.text = text;
			tf.opaqueBackground = true;
			tf.background = true;
			tf.backgroundColor = 0xffffff;
			tf.multiline = false;
			tf.setTextFormat(f);
			tf.setSelection(0, tf.text.length);
			Game.main.stage.focus = tf;
			
			tf.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler,false,0,true);
			
			PhysEditor.isEntering = true;
			
		}

		/*
		listBoxContainer.addEventListener(KeyboardEvent.KEY_DOWN, ListBoxKeyHandler); 
		static function ListBoxKeyHandler(e:KeyboardEvent)
		{
			if (e.keyCode == KeyReader.KEY_ESCAPE)
			{
				PhysEditor.SetEditMode(PhysEditor.oldEditMode,false);
				PhysEditor.CursorText_Set("");
				
			}
		}
		*/

		static function keyDownHandler(e:KeyboardEvent)		
		{
			
			if (PhysEditor.isEntering == false) return;
			var tf:TextField = e.currentTarget as TextField;
			if ( e.charCode ==KeyReader.KEY_ENTER)
			{
				KeyReader.ClearKey(KeyReader.KEY_ENTER);

				if (AddTextEntry_Callback != null)
				{
					AddTextEntry_Callback(tf.text);
				}
				PhysEditor.isEntering = false;
				//ClearClicked();
				
				Game.main.stage.focus = null;
				tf.parent.removeChild(tf);
				tf = null;
				RemoveEntryMC();
				
			}
			if ( e.charCode ==KeyReader.KEY_ESCAPE)
			{
				Utils.print("cancelled");
				PhysEditor.isEntering = false;
				//ClearClicked();
				Game.main.stage.focus = null;
				tf.parent.removeChild(tf);
				tf = null;
				RemoveEntryMC();
				
			}
		}		
	}

}