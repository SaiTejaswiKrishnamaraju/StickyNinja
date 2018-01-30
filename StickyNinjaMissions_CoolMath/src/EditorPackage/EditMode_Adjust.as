package EditorPackage 
{
	import EditorPackage.EditParamUI.EditParams;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditMode_Adjust extends EditMode_Base
	{
		static var doRandomXflipsWhenPlacingRandom:Boolean = true;
		
		public var currentAdjustObject:EdObj;
		public var currentAdjustObject_mouseX:int=0;
		public var currentAdjustObject_mouseY:int=0;
		public var currentAdjustObjectParam:int=0;
		public var dragRectX0:int;
		public var dragRectX1:int;
		public var dragRectY0:int;
		public var dragRectY1:int;

		public var currentPlacementObject:EdPlacementObj;
		public var currentPlacementObjects:Vector.<EdPlacementObj>;		// list to choose from. currentPlacementObject (above) is still uses as the actual placement obj.

		
		public function PickRandomPlacementObject()
		{
			if (currentPlacementObjects.length == 0) return;
			currentPlacementObject = currentPlacementObjects[Utils.RandBetweenInt(0, currentPlacementObjects.length - 1)];
			if (doRandomXflipsWhenPlacingRandom)
			{
				currentPlacementObject.isXFlipped = Utils.RandBool();
			}
		}
		public function ClearPlacementObjectsList()
		{
			currentPlacementObjects = new Vector.<EdPlacementObj>();
		}
		public function AddPlacementObjectToList(obj:EdPlacementObj)
		{
			currentPlacementObjects.push(obj);
		}
		
		public function EditMode_Adjust() 
		{
			
		}
		
		public override function EnterMode():void
		{
			PhysEditor.CursorText_Show();
			PhysEditor.CursorText_Set("");
			SetSubMode("null");
			
			currentPlacementObject = null;
			
			ClearPlacementObjectsList();
			
			currentAdjustObject = null;
		}
		
		public override function InitOnce():void
		{
			currentAdjustObject = null;
			InitKeypressModes();
		}
		
		
		function PickSinglePlacementObject(obj:EdPlacementObj)
		{
			currentPlacementObject = obj;
		}
		
		function SelectEditObject(poi:EdObj)
		{
			if (poi)
			{
				PickSinglePlacementObject(null);			
				currentAdjustObject = poi;
				EditParams.AddParameterListBox(poi.objParameters);
			}
			else
			{
				ClearCurrentAdjustObject();
				EditParams.ClearParameterListBox();
			}
			
		}

		public override function OnRightMouseDown(e:MouseEvent):void
		{
			super.OnRightMouseDown(e);
			PickEditPiece();
		}
		
		public override function OnMouseDown(e:MouseEvent):void
		{
			super.OnMouseDown(e);
	
			var z:Number = 1.0/PhysEditor.zoom;
			Utils.print("HERE MouseDown");
			var poi:EdObj;
			
			
			if (subMode == "place_rot")
			{
				currentAdjustObject_mouseX = mx;										
			}
			if (subMode == "place_change")
			{
				currentAdjustObject_mouseX = mx;																
			}
			if (subMode == "place_scale")
			{
				currentAdjustObject_mouseX = mx;																
			}
			if (subMode == "dragpos")
			{
				PhysEditor.UndoTakeSnapshot();

				currentAdjustObject_mouseX = mxs;																
				currentAdjustObject_mouseY = mys;																
			}
			if (subMode == "dragrot")
			{
				currentAdjustObject_mouseX = mx;																
			}
			if (subMode == "dragscale")
			{
				currentAdjustObject_mouseX = mx;																
			}
			if (subMode == "pick")
			{
				PickObject();
				
			}
			if(subMode == "place")
			{
				
				PhysEditor.UndoTakeSnapshot();
				
				
				var level_instances:Array = PhysEditor.GetCurrentLevelInstances();
				
				var physObj:PhysObj;
				
				if (currentPlacementObject != null)
				{
					
					currentPlacementObject.xpos = mxs;
					currentPlacementObject.ypos = mys;
					
					var ob:EdPlacementObj = currentPlacementObject;

					ob.xpos = mxs;
					ob.ypos = mys;

					var posx:Number = ob.xpos;
					var posy:Number = ob.ypos;

					physObj = Game.objectDefs.FindByName(ob.typeName);
					var pieceName:String = physObj.name;

					
					var pi:EdObj = Levels.CreateLevelObjInstanceAt(pieceName, posx, posy, ob.rot, ob.scale, "",null,ob.isXFlipped);	// ob.initParams);
					
					var physobj:PhysObj = Game.objectDefs.FindByName(pieceName);
					if (physobj != null)
					{
						for (var i:int = 0; i < physObj.instanceParams.length; i++)
						{
							var def:String = physObj.instanceParamsDefaults[i];
							if (def == "") def = null;
							pi.objParameters.AddOrSet(physObj.instanceParams[i], def);
						}
					}						
					if (ob.objParameters != null)
					{
						pi.objParameters = ob.objParameters.Clone();
					}
					pi.objParameters.SetParam("editor_layer", EditorLayers.GetActive().toString());
					
					level_instances.push(pi);
					PhysEditor.SetCurrentLevelInstances(level_instances);
					
					//currentAdjustObject = pi;
					//EditParams.AddParameterListBox(pi.objParameters);

					if (pi.objParameters.GetValueBoolean("take_surface_dir"))
					{
						pi.rot = Utils.RadToDeg(GetNearestLineRotation(pi.x, pi.y));
					}

					PickRandomPlacementObject();

				}
			}
		}
		
		
		function GetNearestLineRotation(xpos:Number, ypos:Number):Number
		{
			var l:Level = GetCurrentLevel();
			
			for each(var line:EdLine in l.lines)
			{
				for (var q:int = 0; q < line.points.length-1; q++)
				{
				
					var p:Point = line.points[q];
					var p1:Point = line.points[q+1];

					if (p.x < p1.x)
					{
						
						var x0:Number = p.x;
						var x1:Number = p1.x;
						var y0:Number = p.y;
						var y1:Number = p1.y;
						if (y0 > y1)
						{
							y0 = p1.y;
							y1 = p.y;
						}
						
						if (xpos >= x0 && xpos <= x1)
						{
							if (ypos >= y0 - 20 && ypos <= y1 + 20)
							{
							
								var ang:Number = Math.atan2(p1.y - p.y, p1.x - p.x);
								return ang;
							}
						}

					}
				}
			}
			return 0;
			
		}
		
		
		public override function OnMouseUp(e:MouseEvent):void
		{
			super.OnMouseUp(e);
			
			if (subMode == "place_rot") SetSubMode("place");
			if (subMode == "place_change") SetSubMode("place");
			if (subMode == "place_scale") SetSubMode("place");
			
			if (subMode == "dragpos") SetSubMode("edit");
			if (subMode == "dragrot") SetSubMode("edit");
			if (subMode == "dragscale") SetSubMode("edit");
			
		}
		
		public override function OnMouseMove(e:MouseEvent):void
		{
			super.OnMouseMove(e);
			
			var z:Number = 1.0/PhysEditor.zoom;
			var z1:Number = 1;
			
			var poi:EdObj;
			
			if (subMode == "place")
			{
				SetCurrentPlacementObjectPosition();
			}

			
			if (e.buttonDown)
			{
				if (currentPlacementObject != null)
				{
					if (subMode == "place_rot")
					{
						var dx:Number = mx - currentAdjustObject_mouseX;
						currentPlacementObject.rot += (dx * 1);
						currentAdjustObject_mouseX = mx;										
					}
					if (subMode == "place_change")
					{
						var dx:Number = mx - currentAdjustObject_mouseX;
						if (Math.abs(dx) > 10)
						{
							if (dx < 0) AddCurrentPlacementObject( -1);
							if (dx >0) AddCurrentPlacementObject( 1);
							currentAdjustObject_mouseX = mx;																
						}
					}
					if (subMode == "place_scale")
					{
						var dx:Number = mx - currentAdjustObject_mouseX;
						currentPlacementObject.scale += (dx * 0.01);
						currentAdjustObject_mouseX = mx;													
					}
				}
				if (currentAdjustObject != null)
				{
					if (subMode == "dragrot")
					{
						PhysEditor.UndoTakeSnapshot();
						var dx:Number = mx - currentAdjustObject_mouseX;
						poi = currentAdjustObject;
						poi.rot += (dx * 1);
						currentAdjustObject_mouseX = mx;										
					}
					else if (subMode == "dragscale")
					{
						PhysEditor.UndoTakeSnapshot();
						var dx:Number = mx - currentAdjustObject_mouseX;
						poi = currentAdjustObject;
						poi.scale += (dx * 0.01);
						currentAdjustObject_mouseX = mx;
					}
					else if (subMode == "dragpos")
					{
						var i:int = 0;
						poi = currentAdjustObject;
						var dx:Number = mxs - currentAdjustObject_mouseX;
						var dy:Number = mys - currentAdjustObject_mouseY;

						poi.x += dx;
						poi.y += dy;		
						PhysEditor.editModeObj_Joints.UpdateJoints_ObjectMoved(poi.id, dx, dy);
						currentAdjustObject_mouseX = mxs;
						currentAdjustObject_mouseY = mys;
					}
				}
			}
			
		}
		public override function OnMouseWheel(delta:int):void
		{
			if (currentAdjustObject != null)
			{
				var index:int;
				if (delta > 0) 
				{
					PhysEditor.UndoTakeSnapshot();
					index = Game.objectDefs.FindIndexByName(currentAdjustObject.typeName);
					index++;
					if (index >= Game.objectDefs.GetNum()) index = 0;
					currentAdjustObject.typeName = Game.objectDefs.GetByIndex(index).name;
				}
				if (delta < 0) 
				{
					PhysEditor.UndoTakeSnapshot();
					index = Game.objectDefs.FindIndexByName(currentAdjustObject.typeName);
					index--;
					if (index < 0) index = Game.objectDefs.GetNum() - 1;
					currentAdjustObject.typeName = Game.objectDefs.GetByIndex(index).name;
				}
				
			}
			
			if (currentPlacementObject != null)
			{
				var index:int;
				if (delta == 0) return;
				
				var dx:Number = 0;
				if (KeyReader.Down(KeyReader.KEY_CONTROL))
				{
					dx = delta * Utils.DegToRad(45);
					currentPlacementObject.rot += dx;
				}
				else if (KeyReader.Down(KeyReader.KEY_SHIFT))
				{
					dx = delta * 0.1;
					currentPlacementObject.scale += dx;
				}
				else
				{
					if (delta < 0) AddCurrentPlacementObject( -1);
					if (delta >0) AddCurrentPlacementObject( 1);					
				}
			}
			
			// edit current piece
			
		}
		
		var keypressModes:Array;
		function InitKeypressModes()
		{
			keypressModes = new Array();
			keypressModes.push(new EditSubModeData("null", false, 0, ""));
			keypressModes.push(new EditSubModeData("place", true, 0, "Place Object"));
			keypressModes.push(new EditSubModeData("place_scale", true, KeyReader.KEY_S, "Drag to Scale Place Object"));
			keypressModes.push(new EditSubModeData("place_rot", true, KeyReader.KEY_R, "Drag to Rotate Place Object"));
			keypressModes.push(new EditSubModeData("place_change", true, KeyReader.KEY_F, "Drag to Change Place Object"));
			keypressModes.push(new EditSubModeData("pick", true, KeyReader.KEY_P, ""));
			keypressModes.push(new EditSubModeData("duplicate", false, KeyReader.KEY_D, ""));
			keypressModes.push(new EditSubModeData("edit", true, KeyReader.KEY_E, "Edit"));
			keypressModes.push(new EditSubModeData("dragscale", true, KeyReader.KEY_S, "Drag for Scale"));
			keypressModes.push(new EditSubModeData("dragrot", true, KeyReader.KEY_R, "Drag for Rotation"));
			keypressModes.push(new EditSubModeData("dragpos", true, KeyReader.KEY_CONTROL, "Drag Object"));
			keypressModes.push(new EditSubModeData("delete", false, KeyReader.KEY_DELETE, ""));
			keypressModes.push(new EditSubModeData("copyparams", false, KeyReader.KEY_C, ""));
			keypressModes.push(new EditSubModeData("pasteparams", false, KeyReader.KEY_V, ""));
			
		}
		
		function SetCursorTextFromKeypressName(modeName:String)
		{
			for each(var mode:EditSubModeData in keypressModes)
			{
				if (modeName == mode.name)
				{
					if(mode.displayName != "") PhysEditor.CursorText_Set(mode.displayName);
				}
			}						
		}
		
		function HandleKeypressModifier(modeName:String, func:Function = null)
		{
			for each(var mode:EditSubModeData in keypressModes)
			{
				if (modeName == mode.name)
				{
					if (KeyReader.Down(mode.keyCode))
					{
						if(mode.displayName != "") PhysEditor.CursorText_Set(mode.displayName);
						if(mode.setMode) subMode = modeName;
						if(func != null) func();							
					}
				}
			}			
		}
		function HandleKeypressModifierNotHeld(modeName:String, newMode:String)
		{
			for each(var mode:EditSubModeData in keypressModes)
			{
				if (modeName == mode.name)
				{
					if (KeyReader.Down(mode.keyCode) == false)
					{
						SetSubMode(newMode);
					}
				}
			}			
		}
		
		
		function HandleKeypress(modeName:String,held:Boolean,func:Function=null)
		{
			
			for each(var mode:EditSubModeData in keypressModes)
			{
				if (modeName == mode.name)
				{
					if (held == false)
					{
						if (KeyReader.Pressed(mode.keyCode))
						{
							if(mode.displayName != "") PhysEditor.CursorText_Set(mode.displayName);
							if(mode.setMode) subMode = modeName;
							if(func != null) func();							
						}
					}
					else if (held == true)
					{
						if (KeyReader.Pressed(mode.keyCode))
						{
							if(mode.displayName != "") PhysEditor.CursorText_Set(mode.displayName);
							if(mode.setMode) subMode = modeName;
							if(func != null) func();							
						}
					}
				}
			}
			
		}
		
		public override function Update():void
		{
			super.Update();
			
			// base submode either 'place', 'edit' or 'null' at all times
			
			if (subMode == "place")
			{
				SetCurrentPlacementObjectPosition();
			}
			
			if (subMode == "place")
			{
				HandleKeypress("pick", false, PickObject);
				HandleKeypress("edit", false, PickEditPiece);		// pick edit piece
				HandleKeypress("place_scale", true, null);
				HandleKeypress("place_rot", true, null);
				HandleKeypress("place_change", true, null);
				if (KeyReader.Pressed(KeyReader.KEY_X))
				{
					XflipPlaceObject();
				}
			}
			
			if (subMode == "null")
			{
				HandleKeypress("pick", false, PickObject);
				HandleKeypress("edit", false, PickEditPiece);		// pick edit piece
			}
			


			if (subMode == "edit")	// IN edit mode
			{
				HandleKeypress("pick", false, PickObject);
				HandleKeypress("edit", false, PickEditPiece);		// pick edit piece
				HandleKeypress("duplicate", false, DuplicateEditObject);
				HandleKeypress("delete", false, DeleteEditObject);
				HandleKeypress("dragscale", true, null);
				HandleKeypress("dragrot", true, null);
				HandleKeypress("copyparams", false, CopyParameters);
				HandleKeypress("pasteparams", false, PasteParameters);
				HandleKeypressModifier("dragpos");
				if (KeyReader.Pressed(KeyReader.KEY_X))
				{
					XflipObject();
				}
				if (KeyReader.Pressed(KeyReader.KEY_HOME))
				{
					CentreOnObjectCurrentObject();
				}
				
			}
			
			if (subMode == "dragpos")
			{
				HandleKeypressModifierNotHeld("dragpos", "edit");
			}
			
			
			if(KeyReader.Pressed(KeyReader.KEY_TAB) && KeyReader.Down(KeyReader.KEY_CONTROL) )
			{
				PhysEditor.UndoTakeSnapshot();
				
				if (KeyReader.Down(KeyReader.KEY_SHIFT))
				{
					PhysEditor.RemoveEverything();
				}
				PhysEditor.GetCurrentLevel().instances = new Array();
			}
			
				
			if (currentAdjustObject != null)
			{
				
				var v:Number = 1;
				var rv:Number = 1;
				var rotvel:Number = 0;
				var xvel:Number = 0;
				var yvel:Number = 0;
				if (KeyReader.Down(KeyReader.KEY_CONTROL))
				{
					v *= 10;
					rv *= 10;
				}
				if (KeyReader.Down(KeyReader.KEY_SHIFT) )
				{
					
					if (KeyReader.Down(KeyReader.KEY_LEFT)) xvel = -v;
					if (KeyReader.Down(KeyReader.KEY_RIGHT)) xvel = v;
					if (KeyReader.Down(KeyReader.KEY_UP)) yvel = -v;
					if (KeyReader.Down(KeyReader.KEY_DOWN)) yvel = v;
					
					if (xvel != 0 || yvel != 0)
					{
						PhysEditor.UndoTakeSnapshot();
					}
					currentAdjustObject.x += xvel;
					currentAdjustObject.y += yvel;
				}
				
				if (KeyReader.Down(KeyReader.KEY_4)) currentAdjustObject.scale -= 0.01;
				if (KeyReader.Down(KeyReader.KEY_5)) currentAdjustObject.scale += 0.01;
				
				if (KeyReader.Down(KeyReader.KEY_6)) rotvel = -rv;
				if (KeyReader.Down(KeyReader.KEY_7)) rotvel = rv;

				if (KeyReader.Pressed(KeyReader.KEY_8)) 
				{
					index = Game.objectDefs.FindIndexByName(currentAdjustObject.typeName);
					index--;
					if (index < 0) index = Game.objectDefs.GetNum() - 1;
					currentAdjustObject.typeName = Game.objectDefs.GetByIndex(index).name;
				}
				if (KeyReader.Pressed(KeyReader.KEY_9)) 
				{
					var index:int = Game.objectDefs.FindIndexByName(currentAdjustObject.typeName);
					index++;
					if (index >= Game.objectDefs.GetNum()) index = 0;
					currentAdjustObject.typeName = Game.objectDefs.GetByIndex(index).name;
				}
				
				
				if (rotvel != 0)
				{
					PhysEditor.UndoTakeSnapshot();
				}
				currentAdjustObject.rot += rotvel;

				
				if (KeyReader.Pressed(KeyReader.KEY_I))
				{
					PhysEditor.UndoTakeSnapshot();
					CurrentAdjustObject_EnterID();
				}
				
			}
			if (currentPlacementObject != null)
			{
				rotvel = 0;
				
				if (KeyReader.Pressed(KeyReader.KEY_M))
				{
					PickRandomPlacementObject();
				}
				
				if (KeyReader.Down(KeyReader.KEY_4)) currentPlacementObject.scale -= 0.01;
				if (KeyReader.Down(KeyReader.KEY_5)) currentPlacementObject.scale += 0.01;
				
				if (KeyReader.Down(KeyReader.KEY_6)) rotvel = -rv;
				if (KeyReader.Down(KeyReader.KEY_7)) rotvel = rv;
				currentPlacementObject.rot += rotvel;

				if (KeyReader.Pressed(KeyReader.KEY_8)) 
				{
					index = Game.objectDefs.FindIndexByName(currentPlacementObject.typeName);
					index--;
					if (index < 0) index = Game.objectDefs.GetNum() - 1;
					currentPlacementObject.typeName = Game.objectDefs.GetByIndex(index).name;
				}
				if (KeyReader.Pressed(KeyReader.KEY_9)) 
				{
					var index:int = Game.objectDefs.FindIndexByName(currentPlacementObject.typeName);
					index++;
					if (index >= Game.objectDefs.GetNum()) index = 0;
					currentPlacementObject.typeName = Game.objectDefs.GetByIndex(index).name;
				}
				
			}
			
		}
		
		function AddCurrentPlacementObject(amt:int)
		{
			if (amt < 0)
			{
				index = Game.objectDefs.FindIndexByName(currentPlacementObject.typeName);
				index--;
				if (index < 0) index = Game.objectDefs.GetNum() - 1;
				currentPlacementObject.typeName = Game.objectDefs.GetByIndex(index).name;
			}
			if (amt > 0)
			{
				var index:int = Game.objectDefs.FindIndexByName(currentPlacementObject.typeName);
				index++;
				if (index >= Game.objectDefs.GetNum()) index = 0;
				currentPlacementObject.typeName = Game.objectDefs.GetByIndex(index).name;				
			}			
		}
		
		var copiedParameters:ObjParameters = null;
		function CopyParameters()
		{
			if (currentAdjustObject != null)
			{
				copiedParameters = currentAdjustObject.objParameters.Clone();
				EdConsole.Add("Copy Parameters");
			}
		}
		function PasteParameters()
		{
			if (copiedParameters == null) return;
			if (currentAdjustObject == null) return;
			PhysEditor.UndoTakeSnapshot();			
			currentAdjustObject.objParameters = copiedParameters.Clone();
			EditParams.ClearParameterListBox();
			EditParams.AddParameterListBox(currentAdjustObject.objParameters);	
			EdConsole.Add("Paste Parameters");
		}
		
		
		
		
		public override function Render(bd:BitmapData):void
		{
			super.Render(bd);
			
			
			bd.fillRect(Defs.screenRect, 0xff445566);
			PhysEditor.RenderBackground(bd);
			PhysEditor.Editor_RenderGrid(bd);
		
			PhysEditor.RenderSortedEdObjs();
			
			PhysEditor.Editor_RenderJoints(bd);

			//PhysEditor.Editor_RenderMiniMap();
			
			if (subMode == "edit" || subMode == "dragpos")
			{
				if (currentAdjustObject != null)
				{
					currentAdjustObject.RenderHighlighted(EditableObjectBase.HIGHLIGHT_SELECTED);
				}
			}
			
			
			if (subMode == "place" || subMode == "place_rot" || subMode == "place_scale" || subMode == "place_change")
			{
				var physObj:PhysObj;
				if (currentPlacementObject != null)
				{
					var ob:EdPlacementObj = currentPlacementObject;
					physObj = Game.objectDefs.FindByName(ob.typeName);
					var p:Point = PhysEditor.GetMapPos(ob.xpos+ob.xoff,ob.ypos+ob.yoff);
					PhysObj.RenderAt(physObj, p.x, p.y, ob.rot, ob.scale * PhysEditor.zoom, bd, PhysEditor.linesScreen.graphics, true,null,null,null,ob.isXFlipped);
				}
			}
			
		}
		
		public override function RenderHud(x:int,y:int):int
		{
			var s:String;
		
			y += PhysEditor.AddInfoText("a", x, y, "E: Pick obj to edit");
			y += PhysEditor.AddInfoText("a", x, y, "P: Pick obj to place");

			if (subMode == "null")
			{
				
			}
			if (subMode == "edit")
			{
				
				if (currentAdjustObject != null)
				{
				
				y += PhysEditor.AddInfoText("a", x, y, "X: xflip");
				y += PhysEditor.AddInfoText("a", x, y, "R: rotate");
				y += PhysEditor.AddInfoText("a", x, y, "S: scale");
				y += PhysEditor.AddInfoText("a", x, y, "F: change type");
				y += PhysEditor.AddInfoText("a", x, y, "D: duplicate");
				y += PhysEditor.AddInfoText("a", x, y, "DEL: delete");
				y += PhysEditor.AddInfoText("a", x, y, "CTRL (hold): drag");
				
				s = "";
				y += PhysEditor.AddInfoText("a", x, y, "Shift + Arrows: Move Piece");
				s = "6/7: Rotate: ";
				s+=currentAdjustObject.rot;
				y += PhysEditor.AddInfoText("a", x, y, s);
				s = "4/5: Scale: ";
				s+=currentAdjustObject.scale;
				y += PhysEditor.AddInfoText("a", x, y, s);
				s = "8/9: Change block type";
				y += PhysEditor.AddInfoText("a", x, y, s);
				y += PhysEditor.AddInfoText("a", x, y, "C: Copy Parameters");
				y += PhysEditor.AddInfoText("a", x, y, "V: Paste Parameters");
				s = "Home: Centre on selection";
				y += PhysEditor.AddInfoText("a", x, y, s);
				
				s = "I: Object ID: ";
				if (currentAdjustObject == null) 
				{
					s += "NONE";					
				}
				else
				{
					s += currentAdjustObject.id;
				}
				y += PhysEditor.AddInfoText("a", x, y, s);
				
				s = "Object type: ";
				if (currentAdjustObject == null) 
				{
					s += "NONE";					
				}
				else
				{
					s += currentAdjustObject.typeName;
				}
				y += PhysEditor.AddInfoText("a", x, y, s);
				
				y += PhysEditor.AddInfoText("a", x, y, "M: random multi object");
				
				}
				
			}
			if (subMode == "place")
			{
				y += PhysEditor.AddInfoText("a", x, y, "R: rotate");
				y += PhysEditor.AddInfoText("a", x, y, "S: scale");
				y += PhysEditor.AddInfoText("a", x, y, "F: change type");
				y += PhysEditor.AddInfoText("a", x, y, "X: xflip");
				
			}
			
			
			
			if (currentAdjustObject != null)
			{
				s = "Pos: " + currentAdjustObject.x + " " + currentAdjustObject.y + "     Rot: " + currentAdjustObject.rot;
				y += PhysEditor.AddInfoText("a", x, y, s);
			}

			return y;
		}
		
		
		
		function Editor_RenderObjects_AdjustMode(bd:BitmapData)
		{
			var level_instances:Array = GetCurrentLevelInstances();
			
			if (PhysEditor.objectZSortMode)
			{
				level_instances = PhysEditor.SortInstancesByZ(level_instances);
			}
			
			
			for each(var poi:EdObj in level_instances)
			{
				var po:PhysObj = Game.objectDefs.FindByName(poi.typeName);
				
				var p:Point = PhysEditor.GetMapPos(poi.x,poi.y);
				
				var doit:Boolean = true;
				
				if (poi == currentAdjustObject)
				{
					if (PhysEditor.updateTimer & 2) doit = false;
				}
				
				if(doit)
				{
					if (po.editorRenderFunctionName != null)
					{
						var renderer:Editor_GameRenderer = new Editor_GameRenderer();
						renderer[po.editorRenderFunctionName](po, poi);
					}
					else
					{
						PhysObj.RenderAt(po, p.x, p.y, poi.rot, poi.scale * PhysEditor.zoom, bd, PhysEditor.linesScreen.graphics, true,null,null,null,poi.isXFlipped);				
					}
				}
				
				
				
			}
		}
		
		
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------

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

		
		function ClearCurrentAdjustObject()
		{
			currentAdjustObject = null;
		}
		
		function CurrentAdjustObject_EnterID()
		{
			if (currentAdjustObject == null) return;
			PhysEditor.AddTextEntry(100,100, "object ID ",currentAdjustObject.id,  CurrentAdjustObject_EnterID_Done);
		}
		function CurrentAdjustObject_EnterID_Done(text:String)
		{
			Utils.print("here " + text);
			currentAdjustObject.id = text;
		}

		var subMode:String;
		function SetSubMode(s:String)
		{
			subMode = s;
			SetCursorTextFromKeypressName(s);
			
		}

		function CentreOnObjectCurrentObject()
		{
			if (currentAdjustObject == null) return;
			PhysEditor.scrollX = currentAdjustObject.x - Defs.displayarea_w2;
			PhysEditor.scrollY = currentAdjustObject.y - Defs.displayarea_h2;
			PhysEditor.zoom = PhysEditor.linZoom = 1;
			
			
		}
		function XflipObject()
		{
			if (currentAdjustObject == null) return;
			currentAdjustObject.isXFlipped = (currentAdjustObject.isXFlipped == false)
			
		}
		function XflipPlaceObject()
		{
			if (currentPlacementObject == null) return;
			currentPlacementObject.isXFlipped = (currentPlacementObject.isXFlipped == false)
		}
		
		function PickObject()
		{
			var poi:EdObj;

			poi = PhysEditor.HitTestPhysObjGraphics(mx, my);
			if (poi != null)
			{
				var po:EdPlacementObj = new EdPlacementObj(poi.typeName,poi.objParameters);
				po.scale = poi.scale;
				po.rot = poi.rot;
				PickSinglePlacementObject(po);
				ClearCurrentAdjustObject();
				SetSubMode("place");
				KeyReader.ClearKey(KeyReader.KEY_P);
			}
			else
			{
				PickSinglePlacementObject(null);
				ClearCurrentAdjustObject();					
				SetSubMode("null");
				KeyReader.ClearKey(KeyReader.KEY_P);
			}
			
		}

		function PickEditPiece()
		{
			var poi:EdObj;
			
			poi = PhysEditor.HitTestPhysObjGraphics(mx, my);
			SelectEditObject(poi);
			SetSubMode("edit");
		}
		
		function DeleteEditObject()
		{
			if (currentAdjustObject == null) return;

			PhysEditor.UndoTakeSnapshot();
			PhysEditor.editModeObj_Joints.UpdateJoints_ObjectDeleted(currentAdjustObject.id);
			PhysEditor.RemoveFromLevelInstances(currentAdjustObject);
			SelectEditObject(null);
			PickSinglePlacementObject(null);
		}
		
		function DuplicateEditObject()
		{
			if (currentAdjustObject == null) return;
			
			var poi:EdObj;

			var newpoi:EdObj = currentAdjustObject.Clone();
			
			var level_instances:Array = PhysEditor.GetCurrentLevelInstances();
			newpoi.x += 20;
			newpoi.y += 20;
			level_instances.push(newpoi);
			PhysEditor.SetCurrentLevelInstances(level_instances);
			ClearCurrentAdjustObject();
			SelectEditObject(newpoi);
			EditParams.AddParameterListBox(newpoi.objParameters);
			PickSinglePlacementObject(null);
			
		}
		
		function SetCurrentPlacementObjectPosition()
		{
			if (currentPlacementObject != null)
			{
				currentPlacementObject.xpos = mxs;
				currentPlacementObject.ypos = mys;
			}
		}		
	}

}