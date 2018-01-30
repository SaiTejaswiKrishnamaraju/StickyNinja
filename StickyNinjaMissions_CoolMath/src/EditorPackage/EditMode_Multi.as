package EditorPackage 
{
	import EditorPackage.EditParamUI.EditParam_EditItem_ObjectPicker;
	import EditorPackage.EditParamUI.EditParams;
	import EditorPackage.Menu.ButtonMenu;
	import EditorPackage.Menu.ButtonMenuButton;
	import EditorPackage.Menu.ButtonMenuButtonState;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author ...
	 */
	public class EditMode_Multi extends EditMode_Base
	{

		public var dragRectX0:int;
		public var dragRectX1:int;
		public var dragRectY0:int;
		public var dragRectY1:int;
		public var selectedObjects:Vector.<EditableObjectBase>;
		public var copiedObjects:Vector.<EditableObjectBase>;
		public var hoveredObj:EditableObjectBase;
		
		var selectedParameters:ObjParameters;
		var extraParameters:ObjParameters;
		
		public function AfterUndo()
		{
			ClearSelected();
			hoveredObj = null;
		}
		
		
		public function ParameterChanged(op:ObjParameter)
		{
			trace("param changed " + op.name + "  " + op.value);
			
			for (var i:int = 0; i < selectedObjects.length; i++)
			{
				var params:ObjParameters = selectedObjects[i].objParameters;
				
				if (params.Exists(op.name))
				{
					params.SetParam(op.name, op.value)
					op.multipleValues = false;
				}
				
				selectedObjects[i].SetStandardParameter(op);
				
			}
			EditParams.AddParameterListBox(selectedParameters,ParameterChanged);
		}
		
		function SetSelectedParameters()
		{
			if (selectedObjects.length == 0)
			{
				EditParams.ClearParameterListBox();
			}
			else
			{				
				selectedParameters = new ObjParameters();
				
				for (var i:int = 0; i < selectedObjects.length; i++)
				{
					var params:ObjParameters = selectedObjects[i].objParameters.Clone();
					selectedParameters.AddMultiParameters(params);
					selectedParameters.AddMultiParameters(selectedObjects[i].GetStandardParameters());					
				}
				
				EditParams.AddParameterListBox(selectedParameters, ParameterChanged);
				
			}
		}
		
		function SelectAll(updateParameters:Boolean = true)
		{
			selectedObjects = new Vector.<EditableObjectBase>();
			var a:Array = PhysEditor.GetAllObjectsList();
			for each(var eo:EditableObjectBase in a)
			{
				AddToSelected(eo, updateParameters);
			}
		}
		function ClearSelected()
		{
			selectedObjects = new Vector.<EditableObjectBase>();
			EditParams.ClearParameterListBox();
		}
		
		// makes a list of libclasses on all selected objects
		// and selects all objects with any one of those classes
		function SelectAllWithSameLibClass()
		{
			var eob:EditableObjectBase;
			var eo:EdObj;
			var po:PhysObj;
			var libs:Array = new Array();
			for each(eob in selectedObjects)
			{
				if (eob.classType == "obj")
				{
					eo = eob as EdObj;
					po = Game.objectDefs.FindByName(eo.typeName);
					if (libs.indexOf(po.libraryClass) == -1)
					{
						libs.push(po.libraryClass);
					}
				}
			}
			var a:Array = PhysEditor.GetAllObjectsList();
			for each(eob in a)
			{
				if (eob.classType == "obj")
				{
					eo = eob as EdObj;
					po = Game.objectDefs.FindByName(eo.typeName);
					if (libs.indexOf(po.libraryClass) != -1)
					{
						AddToSelected(eo);
					}
				}
			}
		}
		
		
		// multiple libclasses are allowed.
		// objects are randomised within their own classes
		function RandomiseSelectedObjectsUsingLibClass()
		{
			
			
			var eob:EditableObjectBase;
			var eo:EdObj;
			var po:PhysObj;
			
			// get all libs in selected list
			
			var libs:Array = new Array();
			for each(eob in selectedObjects)
			{
				if (eob.classType == "obj")
				{
					eo = eob as EdObj;
					po = Game.objectDefs.FindByName(eo.typeName);
					if (libs.indexOf(po.libraryClass) == -1)
					{
						libs.push(po.libraryClass);
					}
				}
			}
			
			for each(var selectedLibClass:String in libs)
			{
				
				// make a list of all library objects with the same class(es)
				
				var libobjs:Array = new Array();
				for each(po in Game.objectDefs.list)
				{
					if (po.libraryClass == selectedLibClass)
					{
						libobjs.push(po);
					}
				}
				
				if (libobjs.length != 0)
				{

					for each(eob in selectedObjects)
					{
						if (eob.classType == "obj")
						{							
							eo = eob as EdObj;
							po = Game.objectDefs.FindByName(eo.typeName);
							if (po.libraryClass == selectedLibClass)
							{
								var r:int = Utils.RandBetweenInt(0, libobjs.length - 1);
								eo.typeName = libobjs[r].name;
							}
						}
					}
				}
			}
			
		}
		
		function XFlipObjectsAboutThemselves()
		{
			for each(var eo:EditableObjectBase in selectedObjects)
			{
				eo.SelfXFlip();
			}
			
		}
		
		
		
		function XFlipLevel(centreX:Number)
		{
			for each(var eo:EditableObjectBase in selectedObjects)
			{
				eo.XFlip(centreX);
			}			
		}
		
		
		function SetAllLevelsAllObjectsDefaultGameLayers()
		{
			Utils.print("SetAllLevelsAllObjectsDefaultGameLayers");
			var oldCurrentLevel:int = Levels.currentIndex;
			var oldCurrentLevel1:int = PhysEditor.currentLevel;
			
			for (var lindex:int = 0; lindex < Levels.list.length; lindex++)
			{
				Levels.currentIndex = lindex;
				PhysEditor.currentLevel = lindex;
				SelectAll(false);
				SetDefaultGameLayers();
				
				Utils.print(" level " + lindex + "    num objects: " + selectedObjects.length);
			}
			
			Levels.currentIndex = oldCurrentLevel;
			PhysEditor.currentLevel = oldCurrentLevel1;
		}
		function SetDefaultGameLayers()
		{
			for each(var eo:EditableObjectBase in selectedObjects)
			{
				if (eo.objParameters != null)
				{
					if (eo.objParameters.Exists("game_layer"))
					{
						if (eo is EdObj)
						{
							var eobj:EdObj = eo as EdObj;
						
							var po:PhysObj = Game.objectDefs.FindByName(eobj.typeName);
							if (po != null)
							{
								
								var def:String = po.GetInstanceParamDefault("game_layer");
								eobj.objParameters.SetParam("game_layer", def);
								
								if (GameLayers.GetByName(def) == null)
								{								
									trace("Game Layer not defined " + eobj.typeName + " layer: " + def);
								}
								
							}
							else
							{
								trace("object not found " + eobj.typeName);
							}
						}
						else if (eo is EdLine)
						{
							var eline:EdLine = eo as EdLine;
							var pm:PolyMaterial = eline.GetCurrentPolyMaterial();							
							eline.objParameters.SetParam("game_layer", pm.defaultGameLayer);
							
						}
						else
						{
							var aaa:int = 0;
						}
					}
					else
					{
						trace("game_layer doesn't exist on object " + eo.classType);
					}
				}
			}
		}
		
		
		function AddToSelected(obj:EditableObjectBase,updateParameters:Boolean=true)
		{
			if (obj == null) return;
			var a:int = selectedObjects.indexOf(obj);
			if (a == -1)
			{			
				selectedObjects.push(obj);
			}
			if (updateParameters)
			{
				SetSelectedParameters();
			}
		}
		function RemoveFromSelected(obj:EditableObjectBase)
		{
			if (obj == null) return;
			var a:int = selectedObjects.indexOf(obj);
			if (a != -1)
			{			
				selectedObjects.splice(a, 1);
			}
			SetSelectedParameters();
		}
		function IsInSelectedList(obj:EditableObjectBase):Boolean
		{
			if (obj == null) return false;
			var a:int = selectedObjects.indexOf(obj);
			return (a != -1);			
		}
		
		function ToggleSelected(obj:EditableObjectBase)
		{
			if (obj == null) return;
			if (IsInSelectedList(obj))
			{
				RemoveFromSelected(obj);
			}
			else
			{
				AddToSelected(obj);
			}
		}
		
		public function EditMode_Multi() 
		{
			
			
		}
		public override function InitOnce():void
		{
			selectedObjects = new Vector.<EditableObjectBase>();
			copiedObjects = new Vector.<EditableObjectBase>();
			hoveredObj = null;
		}
		public override function EnterMode():void
		{
			PhysEditor.CursorText_Show();
			PhysEditor.CursorText_Set("");
			SetSubMode("null");
			
			selectedObjects = new Vector.<EditableObjectBase>();
			hoveredObj = null;
			
			
			menu = new ButtonMenu();
			
			menu.AddItem("Rotate 90 cw",ButtonClicked_Rotate90);
			menu.AddSpacer();
			menu.AddItem("Add Marker",ButtonClicked_AddMarker,TestFunc_AddMarker);
			menu.AddItem("Delete Marker",ButtonClicked_DeleteMarker,TestFunc_DeleteMarker);
			 
			PhysEditor.editorMC.addChild(menu.mc);
			menu.mc.x = Defs.editor_x+340;
			menu.mc.y = 70;
			
			
		}
		
		function UpdateMenu()
		{
			menu.Update();
		}
		
		function TestFunc_AddMarker(button:ButtonMenuButton):int
		{
			if(selectedObjects.length == 1) return ButtonMenuButtonState.NORMAL;
			return ButtonMenuButtonState.GREYED;
		}
		function TestFunc_DeleteMarker(button:ButtonMenuButton):int
		{
			if(selectedObjects.length == 1) return ButtonMenuButtonState.NORMAL;
			return ButtonMenuButtonState.GREYED;
		}
		function ButtonClicked_AddMarker()
		{
			
		}
		function ButtonClicked_DeleteMarker()
		{
			
		}
		
		function ButtonClicked_Rotate90()
		{
			PhysEditor.UndoTakeSnapshot();				
			for each(var eo:EditableObjectBase in selectedObjects)
			{
				eo.RotateBy(eo.GetCentreHandle().x,eo.GetCentreHandle().y, Math.PI / 2);
			}
		}
		
		
		public override function ExitMode():void
		{
			PhysEditor.editorMC.removeChild(menu.mc);
			menu = null;
			
		}		
		var menu:ButtonMenu;
		
		
		var dragRot_WorldCentreX:Number;
		var dragRot_CentreX:Number;
		var dragRot_WorldCentreY:Number;
		var dragRot_CentreY:Number;
	
		public override function OnRightMouseDown(e:MouseEvent):void
		{
			super.OnRightMouseDown(e);
			
			ClearSelected();
			var obj:EditableObjectBase = PhysEditor.HitTestAnyObject(mxs, mys,mx,my);
			ToggleSelected(obj);							
		}
		
		
		public override function OnMouseDown(e:MouseEvent):void
		{
			super.OnMouseDown(e);			
			
			
			if (subMode == "drag")
			{
				PhysEditor.UndoTakeSnapshot();
				
				drag_mouseX = mxs;
				drag_mouseY = mys;
			}
			else if (subMode == "dragbox")
			{
				
				dragRectX0 = mxs;
				dragRectY0 = mys;
				dragRectX1 = mxs;
				dragRectY1 = mys;
				ClearSelected();
			}
			else if (subMode == "dragrot")
			{
				PhysEditor.UndoTakeSnapshot();
				drag_mouseX = mxs;
				dragRot_CentreX = mx;
				dragRot_CentreY = my;
				dragRot_WorldCentreX = mxs;
				dragRot_WorldCentreY = mys;
			}
			else
			{
				var obj:EditableObjectBase = PhysEditor.HitTestAnyObject(mxs, mys,mx,my);
				ToggleSelected(obj);				
			}
		}
		
		function SelectInDragBox(updateParameters:Boolean = true)
		{
			var eob:EdObj;
			var r:Rectangle = GetDragRectangle();
			
			var a:Array = PhysEditor.DragBoxAnyObject(r);
			
			ClearSelected();
			for each(var obj:EditableObjectBase in a)
			{
				AddToSelected(obj,updateParameters);
			}
			
		}
		
		public override function OnMouseUp(e:MouseEvent):void
		{
			super.OnMouseUp(e);
			
			if (subMode == "dragbox")
			{
				SelectInDragBox(true);
				KeyReader.ClearKey(KeyReader.KEY_SHIFT);
			}
			else if (subMode == "dragrot")
			{
				
			}
			
			SetSubMode("null");
			
		}
		public override function OnMouseMove(e:MouseEvent):void
		{
			super.OnMouseMove(e);
			
			if (e.buttonDown)
			{
				hoveredObj = null;
				if (subMode == "dragbox")
				{
					dragRectX1 = mxs;
					dragRectY1 = mys;	
					SelectInDragBox(false);
				}
				else if (subMode == "drag")
				{
					
					var dx:Number = mxs - drag_mouseX;
					var dy:Number = mys - drag_mouseY;					
					for each(var obj:EditableObjectBase in selectedObjects)
					{
						obj.MoveBy(dx, dy);
					}					
					drag_mouseX = mxs;
					drag_mouseY = mys;
				}
				else if (subMode == "dragrot")
				{
					var dx:Number = mxs - drag_mouseX;
					drag_mouseX = mxs;
					for each(var obj:EditableObjectBase in selectedObjects)
					{
						obj.RotateBy(dragRot_WorldCentreX,dragRot_WorldCentreY,dx*0.01);
					}					
					
				}
				
			}
			else
			{
				var obj:EditableObjectBase = PhysEditor.HitTestAnyObject(mxs, mys,mx,my);
				hoveredObj = obj;				
			}
			
		}
		
		function getClass(obj:Object):Class 
		{
			return Class(getDefinitionByName(getQualifiedClassName(obj))); 
		}		
		
		public override function OnMouseWheel(delta:int):void
		{
			
		}
		
		function CentreOnObjectCurrentObject()
		{
			if (selectedObjects == null) return;
			if (selectedObjects.length != 1) return;
			var eo:EditableObjectBase = selectedObjects[0];
			PhysEditor.scrollX = eo.GetCentreHandle().x - Defs.displayarea_w2;
			PhysEditor.scrollY = eo.GetCentreHandle().y - Defs.displayarea_h2;
			PhysEditor.zoom = PhysEditor.linZoom = 1;
		}

		function StepMoveSelected(dx:Number, dy:Number)
		{
			if (selectedObjects == null) return;
			if (KeyReader.Down(KeyReader.KEY_CONTROL))
			{
				dx *= 10;
				dy *= 10;
			}
			for each(var obj:EditableObjectBase in selectedObjects)
			{
				obj.MoveBy(dx,dy);
			}					
		}
		
		
		
		public override function Update():void
		{
			super.Update();
			
			
			if (KeyReader.Pressed(KeyReader.KEY_NUM_8))
			{
				StepMoveSelected(0, -1);
			}
			if (KeyReader.Pressed(KeyReader.KEY_NUM_4))
			{
				StepMoveSelected(-1,0);
			}
			if (KeyReader.Pressed(KeyReader.KEY_NUM_6))
			{
				StepMoveSelected(1,0);
			}
			if (KeyReader.Pressed(KeyReader.KEY_NUM_2))
			{
				StepMoveSelected(0, 1);
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_HOME))
			{
				CentreOnObjectCurrentObject();
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_T))
			{
				MakeTemplateFromSelection();
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_L) && (KeyReader.Down(KeyReader.KEY_SHIFT) == true))
			{
				SetAllLevelsAllObjectsDefaultGameLayers();
				return;
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_X))
			{
				XFlipObjectsAboutThemselves();
//				XFlipLevel(mxs);
				return;
			}
			
			
			
			if(KeyReader.Pressed(KeyReader.KEY_TAB) && KeyReader.Down(KeyReader.KEY_CONTROL) )
			{
				if (KeyReader.Down(KeyReader.KEY_SHIFT))
				{
					PhysEditor.UndoTakeSnapshot();
					PhysEditor.RemoveEverything();
				}
			}

			
			if (KeyReader.Pressed(KeyReader.KEY_D))
			{
				PhysEditor.UndoTakeSnapshot();
				DuplicateSelectedObjects();
			}
			if (KeyReader.Down(KeyReader.KEY_DELETE) || KeyReader.Down(KeyReader.KEY_SQUIGGLE))
			{
				PhysEditor.UndoTakeSnapshot();
				DeleteSelectedObjects();
			}
			
			
			if (KeyReader.Down(KeyReader.KEY_CONTROL))
			{
				SetSubMode("drag");				
			}	
			else if (KeyReader.Down(KeyReader.KEY_R))
			{
				SetSubMode("dragrot");				
			}	
			else if (KeyReader.Down(KeyReader.KEY_SHIFT))
			{
				if (subMode != "dragbox")
				{
					dragRectX0 = mxs;
					dragRectY0 = mys;
					dragRectX1 = mxs;
					dragRectY1 = mys;
					ClearSelected();					
				}
				SetSubMode("dragbox");				
			}	
			else if (KeyReader.Pressed(KeyReader.KEY_C))
			{
				CopySelection();
			}
			else if (KeyReader.Pressed(KeyReader.KEY_V))
			{
				PasteSelection();
			}
			else if (KeyReader.Pressed(KeyReader.KEY_Q))
			{
				ClearSelected();
			}
			else if (KeyReader.Pressed(KeyReader.KEY_S))
			{
				SelectAllWithSameLibClass();
			}
			else if (KeyReader.Pressed(KeyReader.KEY_J))
			{
				RandomiseSelectedObjectsUsingLibClass();
			}
			else if (KeyReader.Pressed(KeyReader.KEY_A))
			{
				SelectAll();
			}
			else if (KeyReader.Pressed(KeyReader.KEY_L) && (KeyReader.Down(KeyReader.KEY_SHIFT) == false))
			{
				SetDefaultGameLayers();
			}
			else
			{
				if (subMode == "dragbox")
				{
					SelectInDragBox(true);
				}
				SetSubMode("null");				
			}
		}
		
		var drag_mouseX:Number = 0;
		var drag_mouseY:Number = 0;
		
		public override function Render(bd:BitmapData):void
		{
			UpdateMenu();
			super.Render(bd);
			
			bd.fillRect(Defs.screenRect, 0xff445566);
			PhysEditor.RenderBackground(bd);
			PhysEditor.Editor_RenderGrid(bd);
		
		
			PhysEditor.RenderSortedEdObjs();
			PhysEditor.Editor_RenderJoints(bd);

			PhysEditor.Editor_RenderMiniMap();
			

			if (hoveredObj != null)
			{
				hoveredObj.RenderHighlighted(EditableObjectBase.HIGHLIGHT_HOVER);
				
			}
			for each(var obj:EditableObjectBase in selectedObjects)
			{
				obj.RenderHighlighted(EditableObjectBase.HIGHLIGHT_SELECTED);
			}
			
			if (subMode == "dragbox")
			{
				var r:Rectangle = GetDragRectangle().clone();
				
				var r1:Rectangle = PhysEditor.GetMapPosRect(r);
				
				PhysEditor.FillRectangle(r1, 0xffffff, 1, 0.4);
				PhysEditor.RenderRectangle(r1, 0xffffff, 1, 1);
				
				Utils.RenderRectangle(bd, r1, 0xffffffff);
			}

			if (subMode == "dragrot")
			{
				Utils.RenderCircle(bd, dragRot_CentreX, dragRot_CentreY, 10, 0xffffffff);
			}
			
		}
		public override function RenderHud(x:int,y:int):int
		{
			var s:String;
			s = "Click Objects To Select / unselect";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "CTRL: drag selected";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "R: rotate selected";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "Q: Clear All Selected";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "A: Select All";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "C: Copy Selection";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "V: Paste Selection";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "L: Set All SELECTED Objects Default Layers";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "Shift-L: Set All Objects Default Layers (ALL LEVELS!)";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "S: Select all with same library class";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "J: Jiggle (randomise) selected objects";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "X: Xflip selected objects";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "D: Duplicate selection";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "T: make template from selection";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "Home: Centre on selection";
			y += PhysEditor.AddInfoText("a", x, y, s);
			
			if (hoveredObj != null)
			{
				s = "Hovered: "+hoveredObj.GetEditorHoverName();
				y += PhysEditor.AddInfoText("a", x, y, s);
			}
			
			return y;
		}
		
		var subMode:String;
		function SetSubMode(s:String)
		{
			subMode = s;
			
			//Utils.trace("setting sub mode " + s);
			
			
			if (s == "drag")
			{
				PhysEditor.CursorText_Set("Drag Selected Objects");
			}
			else if (s == "dragbox")
			{
				PhysEditor.CursorText_Set("Drag Selection Box");
			}
			else if (s == "dragrot")
			{
				PhysEditor.CursorText_Set("Drag Rotation");
			}
			else
			{
				PhysEditor.CursorText_Set("");
			}
		}
		
		function GetDragRectangle():Rectangle
		{
			var x0:int = dragRectX0;
			var x1:int = dragRectX1;
			var y0:int = dragRectY0;
			var y1:int = dragRectY1;
			if (dragRectX1 < dragRectX0)
			{						
				x0  = dragRectX1;
				x1  = dragRectX0;
			}
			if (dragRectY1 < dragRectY0)
			{						
				y0  = dragRectY1;
				y1  = dragRectY0;
			}
			
			var r:Rectangle = new Rectangle(x0, y0, (x1 - x0), (y1 - y0));					
			return r;
		}

		function DeleteSelectedObjects()
		{
			for each(var obj:EditableObjectBase in selectedObjects)
			{
				if (obj.classType != "joint")
				{
					PhysEditor.DeleteObject(obj);				
					PhysEditor.editModeObj_Joints.UpdateJoints_ObjectDeleted(obj.id);
				}
			}
			for each(var obj:EditableObjectBase in selectedObjects)
			{
				if (obj.classType == "joint")
				{
					PhysEditor.DeleteObject(obj);				
				}
			}
			ClearSelected();
			hoveredObj = null;
		}
		
		public function AddTemplate(template:LayoutTemplate)
		{
			PhysEditor.UndoTakeSnapshot();
			
			var paramsToChange:Array = new Array();
			
			
			var xoffset:Number = PhysEditor.scrollX+(Defs.displayarea_w2);
			var yoffset:Number = PhysEditor.scrollY+(Defs.displayarea_h2);
			
			PhysEditor.ClearAllPreviousIDs();


			var dupelist:Array = new Array();
			for each(var obj:EditableObjectBase in template.instances)
			{
				dupelist.push(obj);
			}
			for each(var obj:EditableObjectBase in template.lines)
			{
				dupelist.push(obj);
			}
			for each(var obj:EditableObjectBase in template.joints)
			{
				dupelist.push(obj);
			}

			
			var a:Array = new Array();
			for each(var obj:EditableObjectBase in dupelist)
			{
				
				var obj1:EditableObjectBase = obj.Duplicate();
				if (obj1 != null)
				{
					obj1.prev_id = obj.id;
					obj1.id = PhysEditor.CreateNewUniqueID();
					a.push(obj1);
					obj1.MoveBy(xoffset, yoffset);

					
					var paramIndex:int = 0;
					for each(var p:ObjParameter in obj1.objParameters.list)
					{
						var op:ObjParam = ObjectParameters.GetObjectParamByName(p.name);
						if (op != null)
						{
							if (op.type == "linelink")
							{
								paramsToChange.push(p);
							}
							if (op.type == "objlink")
							{
								paramsToChange.push(p);
							}
						}
						paramIndex++;
					}
					
				}
			}

			for each(var p:ObjParameter in paramsToChange)
			{
				for each(var obj1:EditableObjectBase in a)
				{
					if (obj1.prev_id == p.value)
					{
						p.value = obj1.id;
					}
				}
			}
			
			
			ClearSelected();
			for each(var obj:EditableObjectBase in a)
			{
				if (obj.classType == "obj") PhysEditor.GetCurrentLevelInstances().push(obj);
				if (obj.classType == "line") PhysEditor.GetCurrentLevelLines().push(obj);
				if (obj.classType == "joint") 
				{
					PhysEditor.GetCurrentLevelJoints().push(obj);
				}
				AddToSelected(obj);
			}
			
			// link up joints with new objects:
			for each(var obj:EditableObjectBase in a)
			{
				trace(" obj id: " + obj.id + "   previd: " + obj.prev_id);
			}
			for each(var obj:EditableObjectBase in a)
			{
				if (obj.classType == "joint")
				{
					var j:EdJoint = obj as EdJoint;
					j.UpdateLinkages();
				}
//				AddToSelected(obj);
			}
			
			
			PhysEditor.ClearAllPreviousIDs();
		}
			
			
		
		function CopySelection()
		{
			copiedObjects = new Vector.<EditableObjectBase>();
			for each(var obj:EditableObjectBase in selectedObjects)
			{
				copiedObjects.push(obj);
			}
			trace("copied " + copiedObjects.length + " objects");
		}
		function PasteSelection()
		{
			if (copiedObjects.length == 0) return;
			
			PhysEditor.UndoTakeSnapshot();
			
			var paramsToChange:Array = new Array();
			
			
			var xoffset:Number = mxs;
			var yoffset:Number = mys;
			
			PhysEditor.ClearAllPreviousIDs();


			var dupelist:Array = new Array();
			for each(var obj:EditableObjectBase in copiedObjects)
			{
				dupelist.push(obj.Duplicate());
			}

			
			var a:Array = new Array();
			var firstObj:EditableObjectBase = dupelist[0];
			
			for each(var obj:EditableObjectBase in dupelist)
			{
				
				var obj1:EditableObjectBase = obj.Duplicate();
				if (obj1 != null)
				{
					obj1.prev_id = obj.id;
					obj1.id = PhysEditor.CreateNewUniqueID();
					a.push(obj1);
					
					var centre:Point = firstObj.GetCentreHandle();
					obj1.MoveBy(-centre.x+xoffset, -centre.y+yoffset);

					var centre1:Point = obj1.GetCentreHandle();
					trace(centre.x + " / " + centre1.x);
					
					var paramIndex:int = 0;
					for each(var p:ObjParameter in obj1.objParameters.list)
					{
						var op:ObjParam = ObjectParameters.GetObjectParamByName(p.name);
						if (op != null)
						{
							if (op.type == "linelink")
							{
								paramsToChange.push(p);
							}
							if (op.type == "objlink")
							{
								paramsToChange.push(p);
							}
						}
						paramIndex++;
					}
					
				}
			}

			for each(var p:ObjParameter in paramsToChange)
			{
				for each(var obj1:EditableObjectBase in a)
				{
					if (obj1.prev_id == p.value)
					{
						p.value = obj1.id;
					}
				}
			}
			
			
			for each(var obj:EditableObjectBase in a)
			{
				if (obj.classType == "obj") PhysEditor.GetCurrentLevelInstances().push(obj);
				if (obj.classType == "line") PhysEditor.GetCurrentLevelLines().push(obj);
				if (obj.classType == "joint") 
				{
					PhysEditor.GetCurrentLevelJoints().push(obj);
				}
			}
			
			// link up joints with new objects:
			for each(var obj:EditableObjectBase in a)
			{
				trace(" obj id: " + obj.id + "   previd: " + obj.prev_id);
			}
			for each(var obj:EditableObjectBase in a)
			{
				if (obj.classType == "joint")
				{
					var j:EdJoint = obj as EdJoint;
					j.UpdateLinkages();
				}
//				AddToSelected(obj);
			}
			
			
			PhysEditor.ClearAllPreviousIDs();
			ClearSelected();
			
		}
		
		
		function DuplicateSelectedObjects()
		{
			var paramsToChange:Array = new Array();
			
			PhysEditor.ClearAllPreviousIDs();
			
			var a:Array = new Array();
			for each(var obj:EditableObjectBase in selectedObjects)
			{
				
				var obj1:EditableObjectBase = obj.Duplicate();
				if (obj1 != null)
				{
					obj1.prev_id = obj.id;
					obj1.id = PhysEditor.CreateNewUniqueID();
					a.push(obj1);
					obj1.MoveBy(32, 32);

					
					var paramIndex:int = 0;
					for each(var p:ObjParameter in obj1.objParameters.list)
					{
						var op:ObjParam = ObjectParameters.GetObjectParamByName(p.name);
						if (op != null)
						{
							if (op.type == "linelink")
							{
								paramsToChange.push(p);
							}
							if (op.type == "objlink")
							{
								paramsToChange.push(p);
							}
						}
						paramIndex++;
					}
					
				}
			}

			for each(var p:ObjParameter in paramsToChange)
			{
				for each(var obj1:EditableObjectBase in a)
				{
					if (obj1.prev_id == p.value)
					{
						p.value = obj1.id;
					}
				}
			}
			
			
			ClearSelected();
			for each(var obj:EditableObjectBase in a)
			{
				if (obj.classType == "obj") PhysEditor.GetCurrentLevelInstances().push(obj);
				if (obj.classType == "line") PhysEditor.GetCurrentLevelLines().push(obj);
				if (obj.classType == "joint") 
				{
					PhysEditor.GetCurrentLevelJoints().push(obj);
				}
				AddToSelected(obj);
			}
			
			// link up joints with new objects:
			for each(var obj:EditableObjectBase in a)
			{
				trace(" obj id: " + obj.id + "   previd: " + obj.prev_id);
			}
			for each(var obj:EditableObjectBase in a)
			{
				if (obj.classType == "joint")
				{
					var j:EdJoint = obj as EdJoint;
					j.UpdateLinkages();
				}
//				AddToSelected(obj);
			}
			
			
			PhysEditor.ClearAllPreviousIDs();
		}
		
//----------------------------------------------------------------------------------

		function MakeTemplateFromSelection()
		{
			
			if (selectedObjects.length == 0) return;
			
			var template:LayoutTemplate = new LayoutTemplate();
			template.id = "id+" + Utils.RandBetweenInt(10000, 99999);

			var ob:EdObj;
			var line:EdLine;
			var joint:EdJoint;
			
			
			
			var centre:Point = new Point(0,0);
			var first:Boolean = true;
			var count:Number = 0;
			var objsToDupe:Array = new Array();
			
			for each(var eo:EditableObjectBase in selectedObjects)
			{
				if (eo is EdObj)
				{
					ob = eo as EdObj;
					trace("edobj "+ob.x + " " + ob.y);
					
					centre.x += ob.x;
					centre.y += ob.y;
					count++;
					objsToDupe.push(ob);
				}
				
			}
			
			for each(var eo:EditableObjectBase in selectedObjects)
			{
				if (eo is EdLine)
				{
					line = eo as EdLine;
					trace("line");
					
					var centre:Point = line.GetCentreHandle();
					
					centre.x += centre.x;
					centre.y += centre.y;
					count++;
					objsToDupe.push(line);
				}
				
			}

			for each(var eo:EditableObjectBase in selectedObjects)
			{
				if (eo is EdJoint)
				{
					joint = eo as EdJoint;
					trace("joint");
					
					var centre:Point = joint.GetCentreHandle();
					
					centre.x += centre.x;
					centre.y += centre.y;
					count++;
					objsToDupe.push(joint);
				}
				
			}
			
			
			centre.x /= count;
			centre.y /= count;
			
			
			for each(eo in objsToDupe)
			{
				var ob1:EditableObjectBase = eo.Duplicate();
				ob1.id = eo.id;
				
				trace("ob1 id " + ob1.id);
				
				ob1.MoveBy( -centre.x, -centre.y);
				if (ob1 is EdObj)
				{
					template.instances.push(ob1 as EdObj);
				}
				if (ob1 is EdLine)
				{
					template.lines.push(ob1 as EdLine)
				}
				if (ob1 is EdJoint)
				{
					template.joints.push(ob1 as EdJoint)
				}
			}
			Levels.templates.push(template);
			trace("added template " + template.id + " objs: " + objsToDupe.length);
			
		}
		
	}

}