package EditorPackage 
{
	import EditorPackage.EditParamUI.EditParams;
	import EditorPackage.Menu.ButtonMenu;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import UIPackage.UI;
	import UIPackage.UIX;
	import UIPackage.UIX_Component;
	import UIPackage.UIX_ComponentCollisionItem;
	import UIPackage.UIX_DpadControl;
	import UIPackage.UIX_Instance;
	import UIPackage.UIX_PageDef;
	import UIPackage.UIX_PageInstance;
	/**
	 * ...
	 * @author ...
	 */
	public class EditMode_UI extends EditMode_Base
	{
		var drag_mouseX:Number = 0;
		var drag_mouseY:Number = 0;
		var dragRot_WorldCentreX:Number;
		var dragRot_CentreX:Number;
		var dragRot_WorldCentreY:Number;
		var dragRot_CentreY:Number;
		var dragScale_mouseX:Number = 0;
		var dragScale_mouseY:Number = 0;

		public var dragRectX0:int;
		public var dragRectX1:int;
		public var dragRectY0:int;
		public var dragRectY1:int;
		
		var selectedObjects:Vector.<UIX_Instance>;
		var selectedParameters:ObjParameters;
		
		var currentEditInstance:UIX_Instance;
		
		var placementInstance:UIX_Instance;

		var dragCollisionMode:Boolean;
		
		public var currentPageIndex:int;
		
		public function EditMode_UI() 
		{
			
			
		}
		
		
		public function ToUndo(undo:Object)
		{
			var instances:Vector.<UIX_Instance> = UIX.GetPageDefByIndex(currentPageIndex).GetInstances();

			var a:Array = new Array();
			
			for each(var inst:UIX_Instance in instances)
			{
				a.push(inst.Clone());
			}
			
			undo.ui = a;
		}

		public function AfterUndo()
		{
			ClearSelected();
		}
		public function FromUndo(undo:Object)
		{
			var instances:Vector.<UIX_Instance> = new Vector.<UIX_Instance>();

			var a:Array = undo.ui;
			
			for each(var inst:UIX_Instance in a)
			{
				instances.push(inst.Clone());
			}
			UIX.GetPageDefByIndex(currentPageIndex).SetInstances(instances);
			
		}
		
		public function CreatePlacementInstanceFromLibraryComponent(comp:UIX_Component)
		{
			placementInstance = new UIX_Instance();
			placementInstance.componentName = comp.name;
			placementInstance.SetComponentFromName();
			placementInstance.z = 0;			
		}

		public function CreateInstanceFromComponent(comp:UIX_Component):UIX_Instance
		{
			var inst:UIX_Instance = new UIX_Instance();
			inst.componentName = comp.name;
			inst.SetComponentFromName();
			return inst;
		}
		
		public override function InitOnce():void
		{
			selectedObjects = new Vector.<UIX_Instance>();
			currentPageIndex = 0;
		}
		public override function EnterMode():void
		{
			PhysEditor.CursorText_Show();
			PhysEditor.CursorText_Set("");
			SetSubMode("null");
			
			collisionsCopy = null;
			dragCollisionMode = false;
			selectedObjects = new Vector.<UIX_Instance>();
			
			PhysEditor.scrollX = 0;
			PhysEditor.scrollY = 0;
			PhysEditor.zoom = PhysEditor.linZoom = 1;

			currentEditInstance = null;
			placementInstance = null;
			selectedParameters = null;
			
			menu = new ButtonMenu();
			
			menu.AddItem("Align X",ButtonClicked_AlignX);
			menu.AddItem("Space X",ButtonClicked_SpaceX);
			menu.AddItem("Centre X",ButtonClicked_CentreX);
			menu.AddSpacer();
			menu.AddItem("Align Y",ButtonClicked_AlignY);
			menu.AddItem("Space Y",ButtonClicked_SpaceY);
			menu.AddItem("Centre Y",ButtonClicked_CentreY);
			menu.AddSpacer();
			menu.AddItem("Draw Collision",ButtonClicked_StartDrawCollision);
			menu.AddItem("Copy Collision",ButtonClicked_CopyCollision);
			menu.AddItem("Paste Collision",ButtonClicked_PasteCollision);
			menu.AddSpacer();
			menu.AddItem("Set Transon Order",ButtonClicked_SetTransonOrder);
			 
			PhysEditor.editorMC.addChild(menu.mc);
			menu.mc.x = Defs.editor_x+340;
			menu.mc.y = 70;
			
		}
		
		public override function ExitMode():void
		{
			PhysEditor.editorMC.removeChild(menu.mc);
			menu = null;			
		}		
		var menu:ButtonMenu;
		
		function ButtonClicked_SetTransonOrder()
		{
			if (selectedObjects == null) return;
			if (selectedObjects.length < 1) return;
			PhysEditor.UndoTakeSnapshot();				

			var delay:Number = 1;
			for each(var inst:UIX_Instance in selectedObjects)
			{
				inst.transonDelay = delay;
				delay++;
			}
			
		}
		function ButtonClicked_AlignX()
		{
			if (selectedObjects.length < 2) return;
			PhysEditor.UndoTakeSnapshot();				

			var inst0:UIX_Instance = selectedObjects[0];
			for each(var inst1:UIX_Instance in selectedObjects)
			{
				inst1.x = inst0.x;
			}
		}

		function ButtonClicked_CentreX()
		{
			if (selectedObjects.length < 2) return;
			PhysEditor.UndoTakeSnapshot();			
			
			SortSelectedObjectsInX();
			
			var a:Array = new Array();
			var left:Number = 9999999;
			var right:Number = -9999999;
			
			for each(var inst1:UIX_Instance in selectedObjects)
			{
				a.push(inst1.x);
				
				var bounds:Rectangle = inst1.component.GetBoundingRect();
				bounds.x += inst1.x;
				bounds.y += inst1.y;
				
				if (bounds.left < left) left = bounds.left;
				if (bounds.right > right) right = bounds.right;
				
			}			
			var total:Number  = (right - left)/2;
			var offset:Number = (Defs.displayarea_w2-total)-a[0];
			var i:int = 0;
			for each(var inst1:UIX_Instance in selectedObjects)
			{			
				inst1.x = a[i] +offset; 
				i++;
			}
			
		}

		function ButtonClicked_CentreY()
		{
			if (selectedObjects.length < 2) return;
			PhysEditor.UndoTakeSnapshot();			
			
			SortSelectedObjectsInY();
			
			var a:Array = new Array();
			var top:Number = 9999999;
			var bottom:Number = -9999999;
			
			for each(var inst1:UIX_Instance in selectedObjects)
			{
				a.push(inst1.y);
				
				var bounds:Rectangle = inst1.component.GetBoundingRect();
				bounds.x += inst1.x;
				bounds.y += inst1.y;
				
				if (bounds.top < top) top = bounds.top;
				if (bounds.bottom > bottom) bottom = bounds.bottom;
				
			}			
			var total:Number  = (bottom - top)/2;
			var offset:Number = (Defs.displayarea_h2-total)-a[0];
			var i:int = 0;
			for each(var inst1:UIX_Instance in selectedObjects)
			{			
				inst1.y = a[i] +offset; 
				i++;
			}
			
		}
		
		
		var currentSpaceX:int = 50;
		function ButtonClicked_SpaceX()
		{
			EdModalDialog.Start("Space Selected Items Horizontally", currentSpaceX.toString(), ButtonClicked_SpaceX_Result);
		}
		function ButtonClicked_SpaceX_Result(result:EdModalDialogResult)
		{
			if (result.yes == false) return;
			if (selectedObjects.length < 2) return;

			var adder:int = result.resultInt;
			var offset:int = 0;
			currentSpaceX = result.resultInt;
			
			SortSelectedObjectsInX();
			
			var inst0:UIX_Instance = selectedObjects[0];
			for each(var inst1:UIX_Instance in selectedObjects)
			{
				inst1.x = inst0.x + offset;
				offset += adder;
			}			
		}
		var currentSpaceY:int = 50;
		function ButtonClicked_SpaceY()
		{
			EdModalDialog.Start("Space Selected Items Vertically", currentSpaceY.toString(), ButtonClicked_SpaceY_Result);
		}
		function ButtonClicked_SpaceY_Result(result:EdModalDialogResult)
		{
			if (result.yes == false) return;
			if (selectedObjects.length < 2) return;

			var adder:int = result.resultInt;
			var offset:int = 0;
			currentSpaceY = result.resultInt;
			
			SortSelectedObjectsInY();
			
			var inst0:UIX_Instance = selectedObjects[0];
			for each(var inst1:UIX_Instance in selectedObjects)
			{
				inst1.y = inst0.y + offset;
				offset += adder;
			}			
		}
		
		function SortSelectedObjectsInX()
		{
			if (selectedObjects.length < 2) return;			
			selectedObjects = selectedObjects.sort(SortInXCompareFunc);			
		}		
		function SortInXCompareFunc(x:UIX_Instance, y:UIX_Instance):Number
		{
			if (x.x < y.x) return -1;
			if (x.x > y.x) return 1;
			return 0;
		}
		function SortSelectedObjectsInY()
		{
			if (selectedObjects.length < 2) return;			
			selectedObjects = selectedObjects.sort(SortInYCompareFunc);			
		}		
		function SortInYCompareFunc(x:UIX_Instance, y:UIX_Instance):Number
		{
			if (x.y < y.y) return -1;
			if (x.y > y.y) return 1;
			return 0;
		}

		
		
		function ButtonClicked_AlignY()
		{
			if (selectedObjects == null) return;
			if (selectedObjects.length < 2) return;
			PhysEditor.UndoTakeSnapshot();				
			
			var inst0:UIX_Instance = selectedObjects[0];
			for each(var inst1:UIX_Instance in selectedObjects)
			{
				inst1.y = inst0.y;
			}
		}
		
		function ButtonClicked_CopyCollision()
		{
			if (selectedObjects == null) return;
			if (selectedObjects.length != 1) return;	
			var comp:UIX_Component = UIX.GetComponentByName(selectedObjects[0].componentName);			
			collisionsCopy = comp.CloneCollisions();
			
		}
		function ButtonClicked_PasteCollision()
		{
			if (selectedObjects == null) return;
			if (selectedObjects.length == 0) return;	
			if (collisionsCopy == null) return;
			for each(var inst:UIX_Instance in selectedObjects)
			{
				var comp:UIX_Component = UIX.GetComponentByName(inst.componentName);			
				comp.CopyInCollisions(collisionsCopy);			
			}
		}
		
		function ButtonClicked_StartDrawCollision()
		{
			if (dragCollisionMode) return;
			if (selectedObjects == null) return;
			if (selectedObjects.length != 1) return;
			var inst:UIX_Instance = selectedObjects[0];
			
			dragCollisionMode = true;
			
			dragCollisionInst = inst;
			
			SetSubMode("dragcollision");
		}
		
		
		
	
		public override function OnRightMouseDown(e:MouseEvent):void
		{
			super.OnRightMouseDown(e);
			
			if (subMode == "dpadlink")
			{
				SetSubMode("null");
			}

			
			ClearSelected();
			var obj:UIX_Instance = HitTestInstance(mxs, mys,mx,my);
			ToggleSelected(obj);							
			
		}
		
		function DragCollision_Start()
		{
			trace("DragCollision_Start");
			dragCollisionX0 = mxs;
			dragCollisionY0 = mys;
			dragCollisionX1 = mxs;
			dragCollisionY1 = mys;
		}
		function DragCollision_Move()
		{
			trace("DragCollision_Move");
			dragCollisionX1 = mxs;
			dragCollisionY1 = mys;			
		}
		function DragCollision_End()
		{
			trace("DragCollision_End");
			dragCollisionX1 = mxs;
			dragCollisionY1 = mys;
			dragCollisionMode = false;
			SetSubMode("");
		}
		function DragCollision_Render(bd:BitmapData)
		{
			if (dragCollisionMode == false) return;
			
			PhysEditor.linesScreen.graphics.clear();
						
			var r:Rectangle = Utils.RectangleFromCoords(dragCollisionX0, dragCollisionY0, dragCollisionX1, dragCollisionY1);
			
			var r1:Rectangle = r.clone();
			r1.x -= PhysEditor.scrollX;
			r1.y -= PhysEditor.scrollY;
			
			PhysEditor.RenderRectangle(r1, 0xffffff, 2, 1);
			
			PhysEditor.screenBD.draw(PhysEditor.linesScreen);
			
			var comp:UIX_Component = UIX.GetComponentByName(dragCollisionInst.componentName);
			
			var collisions:Vector.<UIX_ComponentCollisionItem> = comp.GetCollisions();
			if (collisions.length == 0)
			{
				collisions.push(new UIX_ComponentCollisionItem());
			}
			
			r.x -= dragCollisionInst.x;
			r.y -= dragCollisionInst.y;
			
			collisions[0].InitRect(r);
			
		}
		
		
		var collisionsCopy:Vector.<UIX_ComponentCollisionItem> = null;
		var dragCollisionInst:UIX_Instance;
		var dragCollisionX0:Number;
		var dragCollisionY0:Number;
		var dragCollisionX1:Number;
		var dragCollisionY1:Number;
		
		public override function OnMouseDown(e:MouseEvent):void
		{
			super.OnMouseDown(e);			
			
			if (dragCollisionMode)
			{
				DragCollision_Start();
				return;
			}
			
			if (subMode == "dpadlink")
			{
				AddDpadLink();

				return;
			}
			
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
			else if (subMode == "place")
			{
				PhysEditor.UndoTakeSnapshot();				
				placementInstance.x = mxs;
				placementInstance.y = mys;
				AddInstance(placementInstance);
				placementInstance = null;
				SetSubMode("null");
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
			else if (subMode == "dragscale")
			{
				PhysEditor.UndoTakeSnapshot();
				dragScale_mouseX = mxs;
				dragScale_mouseY = mys;
			}
			else
			{
			
				var obj:UIX_Instance = HitTestInstance(mxs, mys,mx,my);
				ToggleSelected(obj);				
			}
			
		}
		
		
		public override function OnMouseUp(e:MouseEvent):void
		{
			super.OnMouseUp(e);
			
			if (dragCollisionMode)
			{
				DragCollision_End();
				return;
			}
			if (subMode == "dragbox")
			{
				SelectInDragBox(true);
				KeyReader.ClearKey(KeyReader.KEY_SHIFT);
			}
			
			if (subMode != "place" && subMode != "dpadlink")
			{
				SetSubMode("null");
			}
			
		}
		public override function OnMouseMove(e:MouseEvent):void
		{
			super.OnMouseMove(e);

			
			if (e.buttonDown == false)
			{
				if (subMode == "place")
				{
					placementInstance.x = mxs;
					placementInstance.y = mys;
				}
			}
			else
			{

				if (dragCollisionMode)
				{
					DragCollision_Move();
					return;
				}
				
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
					for each(var obj:UIX_Instance in selectedObjects)
					{
						obj.MoveBy(dx, dy,0);
					}					
					drag_mouseX = mxs;
					drag_mouseY = mys;
					SetSelectedParameters();
				}
				else if (subMode == "dragrot")
				{
					var dx:Number = mxs - drag_mouseX;
					drag_mouseX = mxs;
					for each(var obj:UIX_Instance in selectedObjects)
					{
						obj.RotateBy(dragRot_WorldCentreX,dragRot_WorldCentreY,dx*0.01);
					}					
					SetSelectedParameters();
					
				}
				else if (subMode == "dragscale")
				{
					var dx:Number = mxs - dragScale_mouseX;
					var dy:Number = mys - dragScale_mouseY;
					dragScale_mouseX = mxs;
					dragScale_mouseY = mys;
					for each(var obj:UIX_Instance in selectedObjects)
					{
						if (KeyReader.Down(KeyReader.KEY_SHIFT))
						{
							dy = dx;
						}						
						obj.ScaleBy(dx,dy);
					}					
					SetSelectedParameters();
					
				}
				
			}
		}
		
		function StepMoveSelected(dx:Number, dy:Number)
		{
			if (KeyReader.Down(KeyReader.KEY_CONTROL))
			{
				dx *= 10;
				dy *= 10;
			}
			for each(var obj:UIX_Instance in selectedObjects)
			{
				obj.MoveBy(dx,dy);
			}					
		}
		
		public override function OnMouseWheel(delta:int):void
		{
			
		}
		
		function NextPage()
		{
			currentPageIndex++;
			if ( currentPageIndex >= UIX.GetNumPageDefs()) currentPageIndex = 0;
		}
		function PrevPage()
		{
			currentPageIndex--;
			if ( currentPageIndex < 0) currentPageIndex = UIX.GetNumPageDefs() - 1;
		}
		
		public override function Update():void
		{
			super.Update();
			
			if (KeyReader.Pressed(KeyReader.KEY_A))
			{
				SelectAll();
			}
			if (KeyReader.Pressed(KeyReader.KEY_8))
			{
				PrevPage();
			}
			if (KeyReader.Pressed(KeyReader.KEY_9))
			{
				NextPage();
			}
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
			if (KeyReader.Pressed(KeyReader.KEY_L))
			{
				StartDpadLinkage();
			}
			if (KeyReader.Down(KeyReader.KEY_CONTROL))
			{
				SetSubMode("drag");				
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
				CopySelected();
			}
			else if (KeyReader.Pressed(KeyReader.KEY_V))
			{
				PasteSelected();
			}			
			else if (KeyReader.Pressed(KeyReader.KEY_O))
			{
				MakeComponentFromSelected();
			}
			else if (KeyReader.Pressed(KeyReader.KEY_X))
			{
				UIX.SaveXML();
			}
			else if (KeyReader.Down(KeyReader.KEY_E))
			{
				if (selectedObjects.length == 1)
				{
					SetCurrentEditInstance(selectedObjects[0]);
					PhysEditor.scrollX = -Defs.displayarea_w2;
					PhysEditor.scrollY = -Defs.displayarea_h2;
				}
			}	
			else if (KeyReader.Down(KeyReader.KEY_W))
			{
				SetCurrentEditInstance(null);
				PhysEditor.scrollX = 0;
				PhysEditor.scrollY = 0;
			}	
			else if (KeyReader.Down(KeyReader.KEY_R))
			{
				SetSubMode("dragrot");				
			}	
			else if (KeyReader.Down(KeyReader.KEY_S))
			{
				SetSubMode("dragscale");				
			}	
			else if (KeyReader.Pressed(KeyReader.KEY_D))
			{
				PhysEditor.UndoTakeSnapshot();
				DuplicateSelectedObjects();
			}			
			else if (KeyReader.Pressed(KeyReader.KEY_DELETE))
			{
				PhysEditor.UndoTakeSnapshot();
				DeleteSelectedObjects();
			}			
			else
			{
				if (subMode == "dragbox")
				{
					SelectInDragBox(true);
				}
				if (subMode != "place" && subMode != "dpadlink" && subMode != "dragcollision")
				{
					SetSubMode("null");				
				}
				
			}
			
		}
		
		
		
		function HitTestInstance(x:Number, y:Number, screenX:Number, screenY:Number):UIX_Instance
		{
			UpdatePageInst();
			mouseX = x;
			mouseY = y;
			releasePressedInstances = new Array();
			

			for each(var inst:UIX_Instance in pageInst.pageInstance.childInstances)
			{
				if (EditorLayers.IsLocked(inst.editorLayer - 1) == false)
				{
					inst.topParent = inst;
					inst.isTopParent = true;
					currentTopParent = inst;				
					for each(var inst:UIX_Instance in inst.childInstances)
					{
						SetTopParentInner(inst);
					}						
				}
			}
			
			for each(var inst:UIX_Instance in pageInst.pageInstance.childInstances)
			{
				if (EditorLayers.IsLocked(inst.editorLayer - 1) == false)
				{
					ButtonsHandleReleaseInner(inst);
				}
			}
			
			if (releasePressedInstances.length == 0) return null;
			releasePressedInstances = releasePressedInstances.sortOn("z");
									
//			for each(var inst:UIX_Instance in releasePressedInstances)
//			{
//				trace(inst.GetInstanceName()+" : "+inst.z)				
//			}
			
			var inst:UIX_Instance = releasePressedInstances[0]; // top of list
			trace(inst.componentName);
			return inst.topParent.pageDefInstance;
		}

		var currentTopParent:UIX_Instance;
		function SetTopParentInner(parentInst:UIX_Instance)
		{
			parentInst.topParent = currentTopParent;
			parentInst.isTopParent = false;
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				SetTopParentInner(inst);
			}									
		}
		
		var mouseX:int = 0;
		var mouseY:int = 0;
		var releasePressedInstances:Array;
		function ButtonsHandleReleaseInner(parentInst:UIX_Instance)
		{
			parentInst.SetComponentFromName();
			if (parentInst.component != null)
			{
				if (parentInst.HitTestUsingMatrix(mouseX, mouseY))
				{
					releasePressedInstances.push(parentInst);
				}
			}
			
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				ButtonsHandleReleaseInner(inst);
			}		
		}
		
		
//----------------------------------		
		function HitTestInstance1(x:Number, y:Number,screenX:Number,screenY:Number):UIX_Instance
		{
			UpdatePageInst();
			var obj:UIX_Instance = null;

			var zorder:Array = pageInst.GetZSortedInstances();

			for (var i:int = zorder.length - 1; i >= 0; i--)
			{
				var inst:UIX_Instance = zorder[i];
				
//				if(inst.component.DoHitTest(x, y, new Matrix3D()))
//				{
//					return inst.pageDefInstance;
//				}

				
				if (inst.boundingRectangle.contains(x, y))
				{
					return inst.pageDefInstance;
				}
			}

			return null;
		}
		
		
		var pageInst:UIX_PageInstance;
		function UpdatePageInst()
		{
			if (currentEditInstance == null)
			{
				pageInst = new UIX_PageInstance();
				var pageDef:UIX_PageDef = GetPageDef();
				pageInst.CreateFromPageDef(pageDef);
				pageInst.UpdateEditor();
			}
			else
			{
				pageInst = new UIX_PageInstance();
				var comp:UIX_Component = currentEditInstance.component;	// UIX.GetComponentByName(currentEditInstance.componentName);
				pageInst.CreateFromComponentDef(comp);
				pageInst.UpdateEditor();
				
			}
			
		}
		
		public override function Render(bd:BitmapData):void
		{
			super.Render(bd);
			
			
			
			bd.fillRect(Defs.screenRect, 0xff800000);
			PhysEditor.RenderBackground(bd);
					
			UpdatePageInst();
			
			var instances:Vector.<UIX_Instance> = GetInstances();

			for each(var inst:UIX_Instance in instances)
			{
				inst.editor_selected = false;
				if (IsInSelectedList(inst)) 
				{
					inst.editor_selected = true;	
				}
			}
			
			
			pageInst.RenderEditor(bd);
			
			var zorder:Array = GetZSortedInstances(true);
			
			for each(var inst:UIX_Instance in instances)	//zorder)
			{
				var selected:Boolean = false;
				if (IsInSelectedList(inst)) selected = true;				
				//inst.RenderAtEditor(bd, selected);
				//Utils.RenderRectangle(bd, inst.boundingRectangle, 0xffffffff);
				if (selected)
				{
					inst.component.RenderCollision(bd, inst.currentMatrix,-PhysEditor.scrollX+1,-PhysEditor.scrollY+1,0xffffffff);
					inst.component.RenderCollision(bd, inst.currentMatrix,-PhysEditor.scrollX+2,-PhysEditor.scrollY+2,0xffffffff);
					inst.component.RenderCollision(bd, inst.currentMatrix,-PhysEditor.scrollX+3,-PhysEditor.scrollY+3,0xffffffff);
					
//					PhysEditor.RenderRectangle(inst.boundingRectangle,0xff0000,3,1);
//					Utils.RenderRectangle(bd, inst.boundingRectangle, 0xffff0000);
				}
			}			
			

			if (currentEditInstance != null)
			{
				/*
				bd.applyFilter(bd, bd.rect, Defs.pointZero, UI.greyFilter);
				
				var m:Matrix3D = currentEditInstance.GetWorldPositionMatrix();
				
				var zorder:Array = GetZSortedInstances(false);
				
				currentEditInstance.RenderAtEditor(bd);
				for each(var inst:UIX_Instance in zorder)
				{
					inst.RenderAtEditorMatrix(m,bd);
				}	
				*/
			}
			
			
			if (subMode == "place")
			{
				if (placementInstance != null)
				{
					placementInstance.RenderAtEditor(bd);
				}
			}
			if (subMode == "dragrot")
			{
				Utils.RenderCircle(bd, dragRot_CentreX, dragRot_CentreY, 10, 0xffffffff);
			}
			if (subMode == "dragbox")
			{
				var r:Rectangle = GetDragRectangle().clone();
				
				var r1:Rectangle = PhysEditor.GetMapPosRect(r);
				
				PhysEditor.FillRectangle(r1, 0xffffff, 1, 0.4);
				PhysEditor.RenderRectangle(r1, 0xffffff, 1, 1);
				
				Utils.RenderRectangle(bd, r1, 0xffffffff);
			}
			
			DragCollision_Render(bd);
			
			RenderGuides(bd);
		}
		
		static function RenderGuides(bd:BitmapData)
		{
			if (PhysEditor.zoom != 1) return;
			
			PhysEditor.linesScreen.graphics.clear();
			
			
			var g:Graphics = PhysEditor.linesScreen.graphics;
			g.lineStyle(1, 0xffffffff, 2);
			
			
			var middleX:Number = Defs.displayarea_w2;
			var middleY:Number = Defs.displayarea_h2;
			
			g.moveTo(0,middleY);
			g.lineTo(Defs.displayarea_w,middleY);

			g.moveTo(middleX,0);
			g.lineTo(middleX, Defs.displayarea_h);
			
			PhysEditor.screenBD.draw(PhysEditor.linesScreen);
			
		}
		
		
		
		function GetPageDef():UIX_PageDef
		{
			return UIX.GetPageDefByIndex(currentPageIndex);
		}
		function GetInstances(_pageInstances:Boolean = false):Vector.<UIX_Instance>
		{
			var instances:Vector.<UIX_Instance> = null;
			if (currentEditInstance == null || _pageInstances == true)
			{
				instances = UIX.GetPageDefByIndex(currentPageIndex).GetInstances();
			}
			else
			{
				instances = currentEditInstance.GetComponentInstances();
			}
			return instances;
		}
		
		function GetZSortedInstances(_pageInstances:Boolean = false):Array
		{
			var instances:Vector.<UIX_Instance> = GetInstances(_pageInstances);
			CalculateInstanceBounds(instances);
			
			var zorder:Array = new Array();
			for each(var inst:UIX_Instance in instances)
			{
				zorder.push(inst);
			}
			zorder.sortOn("z",Array.NUMERIC|Array.DESCENDING);
			return zorder;
		}
		
		function CalculateInstanceBounds(instances:Vector.<UIX_Instance>)
		{
			var m:Matrix3D = new Matrix3D();
			
			for each(var inst:UIX_Instance in instances)
			{
				CalculateInstanceBounds_Inner(m,inst);				
			}
			
			for each(var inst:UIX_Instance in instances)
			{
				GetFullBoundingRect(inst);
			}
		}
		function GetFullBoundingRect(inst:UIX_Instance):Rectangle
		{
			var comp:UIX_Component = inst.component;	// UIX.GetComponentByName(inst.componentName);
			for each(var inst1:UIX_Instance in comp.GetInstances())
			{
				var newInst:UIX_Instance = inst1.Clone();
				inst.boundingRectangle = inst.boundingRectangle.union(GetFullBoundingRect(newInst));
			}
			return inst.boundingRectangle;
		}
		
		function CalculateInstanceBounds_Inner(m:Matrix3D,inst:UIX_Instance)
		{
			inst.currentMatrix = inst.CalcMatrix(m);
			inst.ownBoundingRectangle = inst.GetBoundsRect(m);
			inst.boundingRectangle = inst.GetBoundsRect(m);
			
			var comp:UIX_Component = inst.component;	// UIX.GetComponentByName(inst.componentName);
			for each(var inst1:UIX_Instance in comp.GetInstances())
			{
				var newInst:UIX_Instance = inst1.Clone();
				CalculateInstanceBounds_Inner(inst.currentMatrix, inst1);
			}
		}

		
		public override function RenderHud(x:int,y:int):int
		{
			var s:String;

				s = "Screen: " + pageInst.pageName;
				y += PhysEditor.AddInfoText("a", x, y, s);
			
			if (selectedObjects.length == 1)
			{
				var inst:UIX_Instance = selectedObjects[0];
				s = "component: "+inst.componentName+"  id:"+inst.GetInstanceName()+ "   x:" + inst.x + "  y:" + inst.y + "  z:" + inst.z;
				y += PhysEditor.AddInfoText("a", x, y, s);
				
			}
			
			s = "Click Objects To Select / unselect";
			y += PhysEditor.AddInfoText("a", x, y, s);
			
			s = "Mouse x:" + int(mxs) + "  y:" + int(mys);
			y += PhysEditor.AddInfoText("a", x, y, s);

			
			if (selectedObjects.length == 1)
			{
				var pageDef:UIX_PageDef = GetPageDef();
				var ctrl:UIX_DpadControl = pageDef.GetDpadControlByFromName(selectedObjects[0].GetInstanceName());
				if (ctrl == null)
				{
					s = "NO DPAD CONTROLS DEFINED";
				}
				else
				{
					s = "DPAD: " + ctrl.up + " / " + ctrl.right + " " + ctrl.down + " / " + ctrl.left;
				}
				y += PhysEditor.AddInfoText("a", x, y, s);
			}
			
			return y;
			
			
		}
		
		var subMode:String;
		function SetSubMode(s:String)
		{
			subMode = s;
			
//			trace("setting sub mode " + s);
			
			
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
			else if (s == "dragscale")
			{
				PhysEditor.CursorText_Set("Drag Scale");
			}
			else if (s == "dpadlink")
			{
				if(dpadLinkStage == 0) PhysEditor.CursorText_Set("Select link UP");
				if(dpadLinkStage == 1) PhysEditor.CursorText_Set("Select link RIGHT");
				if(dpadLinkStage == 2) PhysEditor.CursorText_Set("Select link DOWN");
				if(dpadLinkStage == 3) PhysEditor.CursorText_Set("Select link LEFT");
			}
			else if (s == "place")
			{
				PhysEditor.CursorText_Set("Place");
			}
			else if (s == "dragcollision")
			{
				PhysEditor.CursorText_Set("Drag Collision Box");
			}
			else
			{
				PhysEditor.CursorText_Set("");
			}
		}

		function ClearSelected()
		{
			selectedObjects = new Vector.<UIX_Instance>();
			EditParams.ClearParameterListBox();
		}
		function SelectAll()
		{
			ClearSelected();
			for each(var obj:UIX_Instance in GetInstances())
			{
				AddToSelected(obj);
			}
		}
		function ToggleSelected(obj:UIX_Instance)
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
		function IsInSelectedList(obj:UIX_Instance):Boolean
		{
			if (obj == null) return false;
			var a:int = selectedObjects.indexOf(obj);
			return (a != -1);			
		}
		function AddToSelected(obj:UIX_Instance,updateParameters:Boolean=true)
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
		function RemoveFromSelected(obj:UIX_Instance)
		{
			if (obj == null) return;
			var a:int = selectedObjects.indexOf(obj);
			if (a != -1)
			{			
				selectedObjects.splice(a, 1);
			}
			SetSelectedParameters();
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
					var inst:UIX_Instance = selectedObjects[i];
					var params:ObjParameters = inst.objParameters.Clone();
					
					for each(var param:ObjParameter in params.list)
					{
						if (param.origVariableName != null)
						{
							if (param.origVariableType == "number")
							{
								param.value = String(inst[param.origVariableName]);
							}
							else if (param.origVariableType == "vector3")
							{
								var v3d:Vector3D = inst[param.origVariableName]
								param.value = v3d.x + "." + v3d.y + "." + v3d.z;
							}
							else
							{
								param.value = String(inst[param.origVariableName]);
							}
						}
					}
					
					selectedParameters.AddMultiParameters(params);
				}
				
				EditParams.AddParameterListBox(selectedParameters,ParameterChanged);
			}
		}
		
		public function ParameterChanged(op:ObjParameter)
		{
			trace("param changed " + op.name + "  " + op.value);
			
			for (var i:int = 0; i < selectedObjects.length; i++)
			{
				var inst:UIX_Instance = selectedObjects[i];
				var params:ObjParameters = inst.objParameters;
				
				if (params.Exists(op.name))
				{
					params.SetParam(op.name, op.value)
					op.multipleValues = false;
					
					var param:ObjParameter = params.GetParamInstance(op.name);
					
					
					if (param.origVariableName != null)
					{
						if (param.origVariableType == "number")
						{
							inst[param.origVariableName] = param.value;
						}
						if (param.origVariableType == "vector3")
						{
							var a:Array = param.value.split(".");
							inst[param.origVariableName].x = a[0];
							inst[param.origVariableName].y = a[1];
							inst[param.origVariableName].z = a[2];
						}
						
						
					}
				}
			}
			EditParams.AddParameterListBox(selectedParameters,ParameterChanged);
		}
		
		
		
		function DeleteInstance(inst:UIX_Instance)
		{
			var instances:Vector.<UIX_Instance> = GetInstances();
			if (instances.indexOf(inst) != -1)
			{
				instances.splice(instances.indexOf(inst), 1);
			}						
			
		}
		function DeleteSelectedObjects()
		{			
			for each(var inst:UIX_Instance in selectedObjects)
			{
				DeleteInstance(inst);
			}
			ClearSelected();
		}

		var copiedObjects:Array = null;
		function CopySelected()
		{
			var instances:Vector.<UIX_Instance> = GetInstances();
			
			copiedObjects = new Array();
			for each(var inst:UIX_Instance in selectedObjects)
			{
				var clone:UIX_Instance = inst.Clone();
				copiedObjects.push(clone);
				trace("copying " + clone.componentName);
			}			
		}
		function PasteSelected()
		{
			if (copiedObjects == null) return;
			var instances:Vector.<UIX_Instance> = GetInstances();
			
			ClearSelected();
			for each(var inst:UIX_Instance in copiedObjects)
			{
				var clone:UIX_Instance = inst.Clone();
				clone.x += 30;
				clone.y += 30;
				trace("pasting " + clone.componentName);
				instances.push(clone);
				AddToSelected(clone);
			}			
		}
		
		function DuplicateSelectedObjects()
		{
			var instances:Vector.<UIX_Instance> = GetInstances();
			
			var newOnes:Array = new Array();
			for each(var inst:UIX_Instance in selectedObjects)
			{
				var clone:UIX_Instance = inst.Clone();
				clone.x += 30;
				clone.y += 30;
				instances.push(clone);
				newOnes.push(clone);
			}
			ClearSelected();
			for each(var clone:UIX_Instance in newOnes)
			{
				AddToSelected(clone);
			}
			
		}
		
		function SetCurrentEditInstance(inst:UIX_Instance)
		{
			currentEditInstance = inst;
		}

		
		function AddInstance(inst:UIX_Instance)
		{
			var instances:Vector.<UIX_Instance> = GetInstances();
			instances.push(inst.Clone());
		}
		
		function MakeComponentFromSelected()
		{
			if (selectedObjects.length < 2) return;
			
			var comp:UIX_Component = new UIX_Component();
			comp.name = "newone"+Utils.RandBetweenInt(1000000,9999999);
			
			
			var aveX:Number = 0;
			var aveY:Number = 0;
			var furthestZ:int = -99999999;
			for each(var inst:UIX_Instance in selectedObjects)
			{
				aveX += inst.x;
				aveY += inst.y;
				if (inst.z > furthestZ) furthestZ = inst.z;
			}
			aveX /= selectedObjects.length;
			aveY /= selectedObjects.length;
			
			for each(var inst:UIX_Instance in selectedObjects)
			{
				var i2:UIX_Instance = inst.Clone();
				i2.x -= aveX;
				i2.y -= aveY;
				i2.z -= furthestZ;
				comp.GetInstances().push(i2);
			}
			UIX.GetComponents().push(comp);
			
			// delete originals
			
			CreatePlacementInstanceFromLibraryComponent(comp);
			var newInst:UIX_Instance = CreateInstanceFromComponent(comp);
			newInst.z = furthestZ;
			newInst.x = aveX;
			newInst.y = aveY;
			AddInstance(newInst);
			
			DeleteSelectedObjects();
			
			
			
		}
		
//--------------------------------------------------------------------------------------
		var dpadLinkStage:int;
		var dpadLinkObjs:Array;
		
		function StartDpadLinkage()
		{
			if (selectedObjects.length != 1)
			{
				trace("StartDpadLinkage: must select one object");
				return;
			}
			dpadLinkObjs = new Array();
			dpadLinkStage = 0;
			SetSubMode("dpadlink");	
		}
		function AddDpadLink()
		{
			var obj:UIX_Instance = HitTestInstance(mxs, mys, mx, my);
			
			if (obj == null)
			{
				dpadLinkObjs.push("");
			}
			else
			{
				dpadLinkObjs.push(obj.GetInstanceName());
			}
			dpadLinkStage++;
			
			trace("selected link " + obj);
			if (dpadLinkStage < 4)
			{
				SetSubMode("dpadlink");
			}
			else
			{
				var current:UIX_Instance = selectedObjects[0];				
				var pageDef:UIX_PageDef = GetPageDef();
				
				
				var currentCtrl:UIX_DpadControl = pageDef.GetDpadControlByFromName(current.GetInstanceName());
				if (currentCtrl != null)
				{
					pageDef.RemoveDpadControl(currentCtrl);
				}
				pageDef.SetDpadControls(current.GetInstanceName(),dpadLinkObjs[0], dpadLinkObjs[1], dpadLinkObjs[2], dpadLinkObjs[3]);				
				SetSubMode("null");				
			}

		}
//-------------------------------------------------------------
		function SelectInDragBox(updateParameters:Boolean = true)
		{
			var eob:EdObj;
			var r:Rectangle = GetDragRectangle();

			ClearSelected();			
			var list:Array = HitTestInstancesRect(r, mx, my);
			for each(var inst:UIX_Instance in list)
			{
				ToggleSelected(inst);							
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

		function HitTestInstancesRect(r:Rectangle, screenX:Number, screenY:Number):Array
		{
			UpdatePageInst();
			var list:Array = new Array();
			
			var instances:Vector.<UIX_Instance> = GetInstances();
			for each(var inst:UIX_Instance in instances)
			{
				if (EditorLayers.IsLocked(inst.editorLayer - 1) == false)
				{
					if (inst.HitTestRectUsingMatrix(r))
					{
						list.push(inst);
					}
				}
			}
			return list;
		}
		
	}

}