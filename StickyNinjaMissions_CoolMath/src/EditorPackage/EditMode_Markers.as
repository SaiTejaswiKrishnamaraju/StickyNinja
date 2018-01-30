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
	public class EditMode_Markers extends EditMode_Base
	{
		
		var cx:Number = Defs.displayarea_w2;
		var cy:Number = Defs.displayarea_h2;
		
		public var currentObj:PhysObj;
		public var currentMarker:EdObjMarker;
		public var currentAdjustObject_mouseX:int=0;
		public var currentAdjustObject_mouseY:int=0;
		public var numObjs:int=0;
		public var currentObjIndex:int = 0;
		
		var defaultObjParams:ObjParameters;

		public function EditMode_Markers() 
		{
			
		}
		
		public override function EnterMode():void
		{
			PhysEditor.CursorText_Show();
			PhysEditor.CursorText_Set("");
			SetSubMode("null");
			
			numObjs = PhysEditor.editModeObj_Library.selectedObjects.length;
			currentObjIndex = 0;
			currentObj = null;
			if (numObjs != 0)
			{
				currentObj = PhysEditor.editModeObj_Library.selectedObjects[currentObjIndex];
			}
			
			PhysEditor.scrollX = 0;
			PhysEditor.scrollY = 0;
			PhysEditor.zoom = 1;
			
			currentMarker = null;
			defaultObjParams = null;
		}
		
		function PreviousSelection()
		{
			currentObjIndex--;
			if (currentObjIndex < 0) currentObjIndex = numObjs - 1;
			currentObj = PhysEditor.editModeObj_Library.selectedObjects[currentObjIndex];
			currentMarker = null;
		}
		function NextSelection()
		{
			currentObjIndex++;
			if (currentObjIndex >= numObjs) currentObjIndex = 0;
			currentObj = PhysEditor.editModeObj_Library.selectedObjects[currentObjIndex];
			currentMarker = null;
			
		}
		
		public override function InitOnce():void
		{
			currentObj = null;
			
			ObjectParameters.AddParamNumber("marker_x",0,false,false,0,0,0);
			ObjectParameters.AddParamNumber("marker_y",0,false,false,0,0,0);
			ObjectParameters.AddParam("marker_type", "list","normal","normal,attachment,spawn");
			ObjectParameters.AddParamString("marker_data", "");
			ObjectParameters.AddParamNumber("marker_frame",0,false,false,0,0,0);
			ObjectParameters.AddParamNumber("marker_radius",10,false,false,0,0,0);

		}
		
		public function ParameterChanged(op:ObjParameter)
		{
			trace("param changed " + op.name + "  " + op.value);
			
			currentMarker.objParameters.ParameterChanged(op,currentMarker);
			
			EditParams.AddParameterListBox(currentMarker.objParameters, ParameterChanged);
			
		}
		
		
		function UpdateParameters()
		{
			if (currentMarker != null)
			{
				currentMarker.objParameters.CopyParamsToOriginalObject(currentMarker);

				EditParams.AddParameterListBox(currentMarker.objParameters, ParameterChanged);
			}
			else
			{
				EditParams.ClearParameterListBox();
			}

			
		}

		public override function OnRightMouseDown(e:MouseEvent):void
		{
			super.OnRightMouseDown(e);
			PickMarker();
		}
		
		public override function OnMouseDown(e:MouseEvent):void
		{
			super.OnMouseDown(e);
	
			var z:Number = 1.0/PhysEditor.zoom;
			Utils.print("HERE MouseDown");
			var poi:EdObj;
			
			if(subMode == "null")
			{
				AddMarker();
			}
			else if (subMode == "drag")
			{
				currentAdjustObject_mouseX = mxs;
				currentAdjustObject_mouseY = mys;

			}
		}
		
		
		
		public override function OnMouseUp(e:MouseEvent):void
		{
			super.OnMouseUp(e);
			
			if (subMode == "drag")
			{
				subMode = "null";
			}
			
		}
		
		public override function OnMouseMove(e:MouseEvent):void
		{
			super.OnMouseMove(e);
			
			var z:Number = 1.0/PhysEditor.zoom;
			var z1:Number = 1;
			
			var poi:PhysObj;
			
			
			if (e.buttonDown)
			{
				if (currentMarker != null)
				{
					if (subMode == "drag")
					{
						var i:int = 0;
						var dx:Number = mxs - currentAdjustObject_mouseX;
						var dy:Number = mys - currentAdjustObject_mouseY;

						currentMarker.xpos += dx;
						currentMarker.ypos += dy;		
						currentAdjustObject_mouseX = mxs;
						currentAdjustObject_mouseY = mys;
						UpdateParameters();
					}
				}
			}
			
		}
		
		public override function Update():void
		{
			super.Update();
			
			// base submode either 'place', 'edit' or 'null' at all times

			if (KeyReader.Pressed(KeyReader.KEY_LEFTSQUAREBRACKET))
			{
				PreviousSelection();
			}	
			if (KeyReader.Pressed(KeyReader.KEY_RIGHTSQUAREBRACKET))
			{
				NextSelection();
			}	
			
			if (KeyReader.Pressed(KeyReader.KEY_DELETE))
			{
				DeleteCurrentMarker();
			}	
			
			if (KeyReader.Down(KeyReader.KEY_CONTROL))
			{
				SetSubMode("drag");				
			}	
			else
			{
				SetSubMode("null");		
			}
			
		}
		
		/*
		var copiedParameters:ObjParameters = null;
		function CopyParameters()
		{
			if (currentObj != null)
			{
				copiedParameters = currentObj.objParameters.Clone();
				EdConsole.Add("Copy Parameters");
			}
		}
		function PasteParameters()
		{
			if (copiedParameters == null) return;
			if (currentObj == null) return;
			PhysEditor.UndoTakeSnapshot();			
			currentObj.objParameters = copiedParameters.Clone();
			EditParams.ClearParameterListBox();
			EditParams.AddParameterListBox(currentObj.objParameters);	
			EdConsole.Add("Paste Parameters");
		}
		*/
		
		
		
		
		public override function Render(bd:BitmapData):void
		{
			super.Render(bd);
			
			
			bd.fillRect(Defs.screenRect, 0xff445566);
			PhysEditor.RenderBackground(bd);
			PhysEditor.Editor_RenderGrid(bd);
		
			if (currentObj == null) return;
			
			PhysObj.RenderAt(currentObj, cx, cy, 0, 1, bd, PhysEditor.linesScreen.graphics, false, null, null, null, false);
			
			for (var i:int = 0; i < currentObj.markers.Count(); i++)
			{
				var r:int = 3;
				var marker:EdObjMarker = currentObj.markers.Get(i);
				var x:Number = marker.xpos + cx;
				var y:Number = marker.ypos + cy;
				Utils.RenderCircle(bd, x, y, marker.radius,0xffffffff);
				Utils.RenderCircle(bd, x, y, marker.radius + 1, 0xffff0000);
				Utils.RenderDotLine(bd, x, y - r, x, y + r, 100, 0xffff0000);
				Utils.RenderDotLine(bd, x-r, y, x+r, y, 100, 0xffff0000);
			}
			
			if (currentMarker != null)
			{
				if (PhysEditor.updateTimer & 4)
				{
					
					var x:Number = currentMarker.xpos + cx;
					var y:Number = currentMarker.ypos + cy;
					Utils.RenderCircle(bd, x, y, currentMarker.radius,0xff00ff00);
					Utils.RenderCircle(bd, x, y, currentMarker.radius + 1, 0xff0000ff);
				}
				
			}
			
		}
		
		public override function RenderHud(x:int,y:int):int
		{
			var s:String;
			if (currentObj == null) return y;
		
			y += PhysEditor.AddInfoText("a", x, y, "Current Obj Index " + int(currentObjIndex+1) + "/" + numObjs);
			y += PhysEditor.AddInfoText("a", x, y, "Current Obj " + currentObj.name);
			y += PhysEditor.AddInfoText("a", x, y, "Left Click : place a marker");
			y += PhysEditor.AddInfoText("a", x, y, "Right Click : Select a marker");
			y += PhysEditor.AddInfoText("a", x, y, "Delete : Delete current marker");
			y += PhysEditor.AddInfoText("a", x, y, "Ctrl : Drag Marker");
			y += PhysEditor.AddInfoText("a", x, y, "[: Previous Obj");
			y += PhysEditor.AddInfoText("a", x, y, "]: Next Obj");

			return y;
		}
		
		
		
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------

		

		var subMode:String;
		function SetSubMode(s:String)
		{
			subMode = s;
			
			PhysEditor.CursorText_Set(s);
			
		}
		

		
		
		function DeleteCurrentMarker()
		{
			if (currentMarker != null)
			{
				currentObj.markers.Delete(currentMarker);
				currentMarker = null;
			}
		}
		function PickMarker()
		{
			currentMarker = currentObj.markers.TestPickLocalSpace(mxs - cx, mys - cy);
			if (currentMarker == null) return;			
			UpdateParameters();			
			defaultObjParams = currentMarker.objParameters.Clone();		
			trace(defaultObjParams.ToStringAll());
		}

		function AddMarker()
		{
			var x:Number = mxs - cx;
			var y:Number = mys - cy;
			
			if (defaultObjParams != null)
			{
				currentMarker = currentObj.markers.Add(x, y, defaultObjParams.GetValueString("marker_type"), defaultObjParams.GetValueString("marker_data"), defaultObjParams.GetValueNumber("marker_radius"));
			}
			else
			{
				currentMarker = currentObj.markers.Add(x, y, "", "", 10);
				
			}
			
		}
		
	}

}