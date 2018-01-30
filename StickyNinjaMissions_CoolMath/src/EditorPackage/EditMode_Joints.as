package EditorPackage 
{
	import EditorPackage.EditParamUI.EditParams;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditMode_Joints extends EditMode_Base
	{
		var addlineActive:Boolean;
		var newLineType:int;
		var hoveredObj:EditableObjectBase;
		var selectedJoint:EdJoint;
		var copiedParameters:ObjParameters;
		var currentAdjustObject_mouseX:int=0;
		var currentAdjustObject_mouseY:int=0;
		
		public function EditMode_Joints() 
		{
			
		}
		
		public override function EnterMode():void
		{
			PhysEditor.CursorText_Show();
			PhysEditor.CursorText_Set("");
			SetSubMode("null");
			selectedJoint = null;
			hoveredObj = null;
		}
		public override function InitOnce():void
		{
			copiedParameters = null;
			hoveredObj = null;
		}
		
		
		public function UpdateJoints_ObjectDeleted(objID:String)
		{
			if (objID == "") return;
			var jointList:Array = GetCurrentLevelJoints();	
			var deleteList:Array = new Array();
			for each(var joint:EdJoint in jointList)
			{
				if (joint.obj0Name == objID || joint.obj1Name == objID)
				{
					deleteList.push(joint);
				}
			}
			for each(joint in deleteList)
			{
				jointList.splice(jointList.indexOf(joint), 1);
			}
		}
		
		public function UpdateJoints_ObjectMoved(objID:String, x:Number, y:Number,da:Number = 0)
		{
			if (objID == "") return;
			var jointList:Array = GetCurrentLevelJoints();			
			for each(var joint:EdJoint in jointList)
			{
				if (joint.type == EdJoint.Type_Distance) 
				{
					if (joint.obj0Name == objID)
					{
						joint.dist_pos0.x += x;
						joint.dist_pos0.y += y;
					}
					if (joint.obj1Name == objID)
					{
						joint.dist_pos1.x += x;
						joint.dist_pos1.y += y;
					}
				}
			}
			
		}
		
		

		
		function RemoveAllJoints()
		{
			PhysEditor.GetCurrentLevel().joints = new Array();
		}
		
		
		public function GetJointAtPosition(x:int, y:int):EdJoint
		{
			var jointList:Array = GetCurrentLevelJoints();			
			for each(var joint:EdJoint in jointList)
			{
				if (joint.HitTest(x, y)) return joint;
			}
			return null;			
		}

		public function HitTestRectangle(r:Rectangle):Array
		{
			var a:Array = new Array();
			var jointList:Array = GetCurrentLevelJoints();			
			for each(var joint:EdJoint in jointList)
			{
				if (joint.HitTestRectangle(r)) a.push(joint);
			}
			return a;			
		}
		

		function RemoveJoint(j:EdJoint)
		{
			RemoveMarkedJoints(j);
			PhysEditor.DeleteJoint(j);
		}
		function AddRevoluteJoint(x:Number, y:Number):EdJoint
		{
			var j:EdJoint = new EdJoint();
			j.SetType(EdJoint.Type_Rev);
			j.rev_pos = new Point(x, y);
			
			var jointList:Array = GetCurrentLevelJoints();			
			jointList.push(j);
			
			Utils.print("added revolute joint " + x + " " + y);
			return j;
		}

		function AddPrismaticJoint(x:Number, y:Number):EdJoint
		{
			var j:EdJoint = new EdJoint();
			j.SetType(EdJoint.Type_Prismatic);
			j.prism_pos = new Point(x, y);
			j.prism_pos1 = new Point(x, y);
			
			var jointList:Array = GetCurrentLevelJoints();			
			jointList.push(j);
			
			Utils.print("added prismatic joint " + x + " " + y);
			return j;
		}
		
		function AddDistanceJoint():EdJoint
		{
			var j:EdJoint = new EdJoint();
			j.SetType(EdJoint.Type_Distance);
			var jointList:Array = GetCurrentLevelJoints();			
			jointList.push(j);
			
			Utils.print("added distance joint");
			return j;
		}
		
		function AddSwitchJoint():EdJoint
		{
			var j:EdJoint = new EdJoint();
			j.SetType(EdJoint.Type_Switch);
			var jointList:Array = GetCurrentLevelJoints();			
			jointList.push(j);
			
			Utils.print("added switch joint");
			return j;
		}
		
		function AddLogicJoint():EdJoint
		{
			var j:EdJoint = new EdJoint();
			j.SetType(EdJoint.Type_LogicLink);
			var jointList:Array = GetCurrentLevelJoints();			
			jointList.push(j);
			
			Utils.print("added logic joint");
			return j;
		}

		function AddWeldJoint():EdJoint
		{
			var j:EdJoint = new EdJoint();
			j.SetType(EdJoint.Type_Weld);
			var jointList:Array = GetCurrentLevelJoints();			
			jointList.push(j);
			
			Utils.print("added weld joint");
			return j;
		}
		
		function CopyParameters(j:EdJoint)
		{
			if (j == null) return;
			copiedParameters = j.objParameters.Clone();
		}
		function PasteParameters(j:EdJoint)
		{
			if (j == null) return;
			if (copiedParameters == null) return;			
			j.objParameters = copiedParameters.Clone();
		}
		
		var currentJoint:EdJoint = null;
		public override function OnMouseDown(e:MouseEvent):void
		{
			super.OnMouseDown(e);
			
			var obj:EditableObjectBase;
//			var poi:EdObj;
//			var line:EdLine;

			
			if (subMode == "newrev")
			{
				PhysEditor.UndoTakeSnapshot();
				currentJoint = AddRevoluteJoint(mxs, mys);
				SetSubMode("firstrev");
			}
			else if (subMode == "newprism")
			{
				PhysEditor.UndoTakeSnapshot();
				currentJoint = AddPrismaticJoint(mxs, mys);
				
				obj = GetCurrentObj();
				if (obj)
				{
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj0Name = obj.id;
				}
				SetSubMode("secondprism");
			}
			else if (subMode == "secondprism")
			{
				PhysEditor.UndoTakeSnapshot();
				
				obj = GetCurrentObj();
				if (obj)
				{
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj1Name = obj.id;
				}
				SetSubMode("firstprismaxis");				
				
			}
			else if (subMode == "firstprismaxis")
			{				
				currentJoint.prism_pos = new Point(mxs, mys);
				SetSubMode("secondprismaxis");
			}
			else if (subMode == "secondprismaxis")
			{				
				currentJoint.prism_pos1 = new Point(mxs, mys);
				SetSubMode("null");
			}
			
			else if (subMode == "new_switch")
			{
				GetHoveredObjIncludingJoints();	
				obj = hoveredObj;
				if (obj)
				{					
					PhysEditor.UndoTakeSnapshot();
					currentJoint = AddSwitchJoint();
					
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj0Name = obj.id;
					SetSubMode("second_switch");
					
				}
			}
			else if (subMode == "second_switch")
			{
				GetHoveredObjIncludingJoints();				
				obj = hoveredObj;
				if (obj)
				{					
					PhysEditor.UndoTakeSnapshot();					
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj1Name = obj.id;
					SetSubMode("null");					
				}
			}
			
			else if (subMode == "new_logic")
			{
				GetHoveredObj();				
				obj = GetCurrentObj();
				if (obj)
				{					
					PhysEditor.UndoTakeSnapshot();
					currentJoint = AddLogicJoint();
					
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj0Name = obj.id;
					SetSubMode("second_logic");
					
				}
			}
			else if (subMode == "second_logic")
			{
				GetHoveredObjIncludingJoints();				
				obj = GetCurrentObjIncludingJoints();
				if (obj)
				{					
					PhysEditor.UndoTakeSnapshot();					
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj1Name = obj.id;
					SetSubMode("null");					
				}
			}
			else if (subMode == "new_weld")
			{
				GetHoveredObj();				
				obj = GetCurrentObj();
				if (obj)
				{					
					PhysEditor.UndoTakeSnapshot();
					currentJoint = AddWeldJoint();
					
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj0Name = obj.id;
					SetSubMode("second_weld");
					
				}
			}
			else if (subMode == "second_weld")
			{
				GetHoveredObj();				
				obj = GetCurrentObj();
				if (obj)
				{					
					PhysEditor.UndoTakeSnapshot();					
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj1Name = obj.id;
					SetSubMode("null");					
				}
			}
			
			else if (subMode == "newdist")
			{
				GetHoveredObj();
				
				obj = GetCurrentObj();
				if (obj)
				{
					
					PhysEditor.UndoTakeSnapshot();
					currentJoint = AddDistanceJoint();
					
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj0Name = obj.id;
					currentJoint.dist_pos0.x = mxs;
					currentJoint.dist_pos0.y = mys;
					currentJoint.obj1Name = obj.id;
					currentJoint.dist_pos1.x = mxs;
					currentJoint.dist_pos1.y = mys;
					SetSubMode("seconddist");
					
				}
				else
				{
					currentJoint = AddDistanceJoint();
					currentJoint.dist_pos0.x = mxs;
					currentJoint.dist_pos0.y = mys;
					currentJoint.dist_pos1.x = mxs;
					currentJoint.dist_pos1.y = mys;
					SetSubMode("seconddist");										
				}
			}
			else if (subMode == "firstdist")
			{
				obj = GetCurrentObj();
				if (obj)
				{
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj0Name = obj.id;
					currentJoint.dist_pos0.x = mxs;
					currentJoint.dist_pos0.y = mys;
					SetSubMode("seconddist");					
				}
				else
				{
					currentJoint.obj0Name = "";
					currentJoint.dist_pos0.x = mxs;
					currentJoint.dist_pos0.y = mys;
					SetSubMode("seconddist");
				}
			}
			else if (subMode == "seconddist")
			{
				obj = GetCurrentObj();
				if (obj)
				{
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj1Name = obj.id;
					currentJoint.dist_pos1.x = mxs;
					currentJoint.dist_pos1.y = mys;
					SetSubMode("null");					
				}
				else
				{
					currentJoint.obj1Name = "";
					currentJoint.dist_pos1.x = mxs;
					currentJoint.dist_pos1.y = mys;
					SetSubMode("null");
				}
			}

			else if (subMode == "firstrev")
			{				
				
				obj = GetCurrentObj();
				if (obj)
				{
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj0Name = obj.id;
				}
				SetSubMode("secondrev");
				
			}
			else if (subMode == "secondrev")
			{
				obj = GetCurrentObj();
				if (obj)
				{
					if (obj.id == "") obj.id = PhysEditor.CreateNewUniqueID();
					currentJoint.obj1Name = obj.id;
				}
				SetSubMode("null");
				
			}
			else if(subMode == "drag")
			{
				
				selectedJoint = GetJointAtPosition(mxs, mys);
				currentJoint = selectedJoint;
				if (selectedJoint != null)
				{
					currentAdjustObject_mouseX = mx;
					currentAdjustObject_mouseY = my;
				}
			
			}
			else
			{
				selectedJoint = GetJointAtPosition(mxs, mys);
				currentJoint = selectedJoint;

				if (selectedJoint != null)
				{
					EditParams.AddParameterListBox(selectedJoint.objParameters);
				}
				else
				{
					EditParams.ClearParameterListBox();
				}
			
			}
		}
		
		public override function OnMouseUp(e:MouseEvent):void
		{
			super.OnMouseUp(e);

			var poi:EdObj;
			var line:EdLine;
			
		}
		
		
		var hoveredJoint:EditableObjectBase = null;
		function ClearHoveredJoint()
		{
			hoveredJoint = null;
		}
		function GetHoveredJoint()
		{
			hoveredJoint = null;
			var obj:EditableObjectBase = PhysEditor.HitTestJoint(mxs, mys);
			if (obj != null)
			{
				if (obj.classType == "joint")
				{
					hoveredJoint = obj;				
				}
			}
		}
		function GetHoveredObj():EditableObjectBase
		{
			hoveredObj = null;
			var obj:EditableObjectBase = PhysEditor.HitTestAnyObjectNoJoints(mxs, mys, mx, my);
			if (obj != null)
			{
				hoveredObj = obj;				
			}
			return hoveredObj;
		}
		function GetHoveredObjIncludingJoints():EditableObjectBase
		{
			hoveredObj = null;
			var obj:EditableObjectBase = PhysEditor.HitTestAnyObject(mxs, mys, mx, my);
			if (obj != null)
			{
				hoveredObj = obj;				
			}
			return hoveredObj;
		}

		function GetCurrentObjIncludingJoints():EditableObjectBase
		{
			var obj:EditableObjectBase = PhysEditor.HitTestAnyObject(mxs, mys, mx, my);
			return obj;			
		}
		function GetCurrentObj():EditableObjectBase
		{
			var obj:EditableObjectBase = PhysEditor.HitTestAnyObjectNoJoints(mxs, mys, mx, my);
			if (obj != null)
			{
				if (obj.classType != "joint")
				{
					return obj;
				}
			}
			return null;
		}
		
		
		public override function OnMouseMove(e:MouseEvent):void
		{
			super.OnMouseMove(e);
			
			var obj:EditableObjectBase;
			
			var poi:EdObj;
			var line:EdLine;

			var l:Level = GetCurrentLevel();
			
			ClearHoveredJoint();
			hoveredObj = null;
			
			if (e.buttonDown == false) 
			{
				if (subMode == "newdist" || subMode == "firstdist")
				{
					obj = GetHoveredObj();
					if (obj == null)
					{
						PhysEditor.CursorText_Set("[DIST] First Object: BG");
					}
					else 
					{
						PhysEditor.CursorText_Set("[DIST] First Object: "+obj.GetEditorHoverName());
					}
					
				}
				else if (subMode == "seconddist")
				{
					obj = GetHoveredObj();
					if (obj == null)
					{
						PhysEditor.CursorText_Set("[DIST] Second Object: BG");
					}
					else 
					{
						PhysEditor.CursorText_Set("[DIST] Second Object: "+obj.GetEditorHoverName());
					}
					
				}
				
				else if (subMode == "new_switch")
				{
					obj = GetHoveredObjIncludingJoints();
					if (obj == null)
					{
						PhysEditor.CursorText_Set("[SWITCH] First Object: BG");
					}
					else 
					{
						PhysEditor.CursorText_Set("[SWITCH] First Object: "+obj.GetEditorHoverName());
					}
					
				}
				else if (subMode == "second_switch")
				{
					obj = GetHoveredObjIncludingJoints();
					if (obj == null)
					{
						PhysEditor.CursorText_Set("[SWITCH] Second Object: BG");
					}
					else 
					{
						PhysEditor.CursorText_Set("[SWITCH] Second Object: "+obj.GetEditorHoverName());
					}
					
				}

				else if (subMode == "new_logic")
				{
					obj = GetHoveredObj();
					if (obj == null)
					{
						PhysEditor.CursorText_Set("[LOGIC] First Object: BG");
					}
					else 
					{
						PhysEditor.CursorText_Set("[LOGIC] First Object: "+obj.GetEditorHoverName());
					}
					
				}
				else if (subMode == "second_logic")
				{
					obj = GetHoveredObjIncludingJoints();
					if (obj == null)
					{
						PhysEditor.CursorText_Set("[LOGIC] Second Object: BG");
					}
					else 
					{
						PhysEditor.CursorText_Set("[LOGIC] Second Object: "+obj.GetEditorHoverName());
					}
					
				}

				else if (subMode == "new_weld")
				{
					obj = GetHoveredObj();
					if (obj == null)
					{
						PhysEditor.CursorText_Set("[WELD] First Object: BG");
					}
					else 
					{
						PhysEditor.CursorText_Set("[WELD] First Object: "+obj.GetEditorHoverName());
					}
					
				}
				else if (subMode == "second_weld")
				{
					obj = GetHoveredObj();
					if (obj == null)
					{
						PhysEditor.CursorText_Set("[WELD] Second Object: BG");
					}
					else 
					{
						PhysEditor.CursorText_Set("[WELD] Second Object: "+obj.GetEditorHoverName());
					}
					
				}
				
				else if (subMode == "firstrev")
				{				
					GetHoveredObj();

					obj = GetCurrentObj();
					if (obj == null)
					{
						PhysEditor.CursorText_Set("[REV] First Object: BG");
					}
					else 
					{
						PhysEditor.CursorText_Set("[REV] First Object: "+obj.GetEditorHoverName());
					}
				}
				else if (subMode == "secondrev")
				{
					GetHoveredObj();
					
					obj = GetCurrentObj();
					if (obj == null)
					{
						PhysEditor.CursorText_Set("[REV] Second Object: BG");
					}
					else 
					{
						PhysEditor.CursorText_Set("[REV] Second Object: "+obj.GetEditorHoverName());
					}
				}
				
				else if(subMode == "drag")
				{
					GetHoveredJoint();
				}
				else if (subMode == "null")
				{
					GetHoveredJoint();
				}
				
				return;
			}
			
			if(subMode == "drag")
			{
				if (selectedJoint != null)
				{
					var dx:Number = mx - currentAdjustObject_mouseX;
					var dy:Number = my - currentAdjustObject_mouseY;
					selectedJoint.MoveBy(dx, dy);
					currentAdjustObject_mouseX = mx;
					currentAdjustObject_mouseY = my;					
				}			
			}
			
			
			
			
		}
		
		
		public override function OnMouseWheel(delta:int):void
		{
			
		}
		
		var subMode:String;
		function SetSubMode(s:String)
		{
			subMode = s;
			
			//Utils.trace("setting sub mode " + s);
			
			if (s == "new_switch")
			{
				PhysEditor.CursorText_Set("new switch joint - first object");
			}
			if (s == "swcond_switch")
			{
				PhysEditor.CursorText_Set("switch joint - second object");
			}
			if (s == "new_logic")
			{
				PhysEditor.CursorText_Set("new logic joint - first object");
			}
			if (s == "second_logic")
			{
				PhysEditor.CursorText_Set("logic joint - second object");
			}
			if (s == "new_weld")
			{
				PhysEditor.CursorText_Set("new weld joint - first object");
			}
			if (s == "second_weld")
			{
				PhysEditor.CursorText_Set("weld joint - second object");
			}
			if (s == "newprism")
			{
				PhysEditor.CursorText_Set("new prismatic joint - first object");
			}
			if (s == "secondprism")
			{
				PhysEditor.CursorText_Set("prism select second object");
			}
			if (s == "firstprismaxis")
			{
				PhysEditor.CursorText_Set("prism select axis point A");
			}
			if (s == "secondprismaxis")
			{
				PhysEditor.CursorText_Set("prism select axis point A");
			}
			if (s == "firstdist")
			{
				PhysEditor.CursorText_Set("first dist point");
			}
			if (s == "seconddist")
			{
				PhysEditor.CursorText_Set("second dist point");
			}
			if (s == "firstrev")
			{
				PhysEditor.CursorText_Set("[REV] first object");
			}
			if (s == "secondrev")
			{
				PhysEditor.CursorText_Set("[REV] second object");
			}
			
			if (s == "null")
			{
				PhysEditor.CursorText_Set("");
			}
			if (s == "newrev")
			{
				PhysEditor.CursorText_Set("new revolute joint");
			}
			if (s == "newdist")
			{
				PhysEditor.CursorText_Set("new distance joint");
			}
			if (s == "drag")
			{
				PhysEditor.CursorText_Set("drag joint");
			}
			
			
		}
		
		public override function Update():void
		{
			super.Update();
			
			
			if (selectedJoint != null)
			{
				if (KeyReader.Pressed(KeyReader.KEY_E))
				{
					if (selectedJoint.type == EdJoint.Type_Rev)
					{
						SetSubMode("firstrev");
					}
					if (selectedJoint.type == EdJoint.Type_Distance)
					{
						SetSubMode("firstrev");
					}
				}
				else if (KeyReader.Pressed(KeyReader.KEY_C))
				{
					CopyParameters(selectedJoint);
				}
				else if (KeyReader.Pressed(KeyReader.KEY_V))
				{
					PhysEditor.UndoTakeSnapshot();
					PasteParameters(selectedJoint);
				}
				else if (KeyReader.Down(KeyReader.KEY_DELETE) || KeyReader.Down(KeyReader.KEY_SQUIGGLE))
				{
					PhysEditor.UndoTakeSnapshot();
					RemoveJoint(selectedJoint);
				}
				
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_R))
			{
				SetSubMode("newrev");
			}
			else if (KeyReader.Pressed(KeyReader.KEY_D))
			{
				SetSubMode("newdist");
			}
			else if (KeyReader.Pressed(KeyReader.KEY_P))
			{
				SetSubMode("newprism");
			}
//			else if (KeyReader.Pressed(KeyReader.KEY_S))
//			{
//				SetSubMode("new_switch");
//			}
			else if (KeyReader.Pressed(KeyReader.KEY_L))
			{
				SetSubMode("new_logic");
			}
			else if (KeyReader.Pressed(KeyReader.KEY_W))
			{
				SetSubMode("new_weld");
			}

			
			if (subMode == "null" || subMode=="drag" )
			{
				if (KeyReader.Down(KeyReader.KEY_CONTROL))
				{
					SetSubMode("drag");
				}
				else
				{
					SetSubMode("null");
				}
			}
			if(KeyReader.Pressed(KeyReader.KEY_TAB) && KeyReader.Down(KeyReader.KEY_CONTROL) )
			{
				PhysEditor.UndoTakeSnapshot();
				if (KeyReader.Down(KeyReader.KEY_SHIFT))
				{
					PhysEditor.RemoveEverything();
				}
				RemoveAllJoints();
			}
		}
		
		function RemoveMarkedJoints(ob:EditableObjectBase)
		{
			if (hoveredJoint == ob) hoveredJoint = null;
			if (selectedJoint == ob) 
			{
				EditParams.ClearParameterListBox();
				selectedJoint = null;
			}
		}
		
		public override function Render(bd:BitmapData):void
		{
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
			if (hoveredJoint)
			{
				hoveredJoint.RenderHighlighted(EditableObjectBase.HIGHLIGHT_HOVER);
			}
			if (selectedJoint)
			{
				selectedJoint.RenderHighlighted(EditableObjectBase.HIGHLIGHT_SELECTED);
			}
			
		}
		public override function RenderHud(x:int,y:int):int
		{
			var s:String;
			
			s = "R: Add Revolute Joint";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "D: Add Distance Joint";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "P: Add Prismatic Joint";
			y += PhysEditor.AddInfoText("a", x, y, s);
//			s = "S: Add Switch Joint";
//			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "L: Add Logic Joint";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "W: Add Weld Joint";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "DEL: Delete Joint";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "C: Copy parameters";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "V: Paste parameters";
			y += PhysEditor.AddInfoText("a", x, y, s);
			
			
			if (currentJoint != null)
			{				
				s = "Link A: " + currentJoint.obj0Name + "    Link B:" + currentJoint.obj1Name;
				y += PhysEditor.AddInfoText("a", x, y, s);

			}
			
			return y;
		}

//-----------------------------------------------------------------------------------------------------

	}

}