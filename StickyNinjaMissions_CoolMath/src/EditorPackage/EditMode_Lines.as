package EditorPackage 
{
	import EditorPackage.EditParamUI.EditParams;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditMode_Lines extends EditMode_Base
	{
		var addlineActive:Boolean;
		var hoveredLineIndex:int;
		var hoveredPointIndex:int;
		var hoveredPointLineIndex:int;
		var dragPoint:Point;
		var lastLineSelectedIndex:int;
		var copiedParameters:ObjParameters;
		
		var freeLine_MinDist:int = 10;
		
		public function EditMode_Lines() 
		{
			
		}
		
		
		function CopyParameters()
		{
			var l:EdLine = GetCurrentLine();
			if (l == null) return;
			copiedParameters = l.objParameters.Clone();
		}
		function PasteParameters()
		{
			var l:EdLine = GetCurrentLine();
			if (l == null) return;
			if (copiedParameters == null) return;	
			PhysEditor.UndoTakeSnapshot();
			l.objParameters = copiedParameters.Clone();
		}
		
		public override function EnterMode():void
		{
			PhysEditor.CursorText_Show();
			PhysEditor.CursorText_Set("");
			SetSubMode("null");
			hoveredLineIndex = -1;
			hoveredPointIndex = -1;
			hoveredPointLineIndex = -1;
			currentLineIndex = -1;
		}
		public override function InitOnce():void
		{
			currentLineIndex = -1;
			currentPointIndex = -1;
			addlineActive = false;
			var l:Level = GetCurrentLevel();
			currentLineIndex = l.lines.length - 1;
			hoveredLineIndex = -1;
			lastLineSelectedIndex = -1;
			dragPoint = new Point(0, 0);
			copiedParameters = null
		}
	
		public override function OnRightMouseDown(e:MouseEvent):void
		{
			super.OnRightMouseDown(e);

			Lines_SelectLineByArea(mxs, mys);
			if(currentLineIndex == -1) Lines_SelectLine(mxs, mys);
			var line:EdLine = Lines_GetLineByIndex(currentLineIndex);
			lastLineSelectedIndex = currentLineIndex;
			AddLineParameterListBoxOrClear(line);
			
		}
		
		
		public override function OnMouseDown(e:MouseEvent):void
		{
			super.OnMouseDown(e);

			
			if (subMode == "scaleline")
			{
				Lines_SelectLineByArea(mxs, mys);
				Lines_StartScale(mxs, mys);				
			}
			else if (subMode == "rotateline")
			{
				Lines_SelectLineByArea(mxs, mys);
				Lines_StartRotate(mxs, mys);				
			}
			else if (subMode == "freeline")
			{
				FreeLine_Start();
			}
			else if (subMode == "newline")
			{
				PhysEditor.UndoTakeSnapshot();
				addlineActive = true;
				currentPointIndex = -1;
				Lines_NewLine();
				Lines_AddPoint(mxs, mys);
				var line:EdLine = Lines_GetLineByIndex(currentLineIndex);
				EditParams.AddParameterListBox(line.objParameters);
				SetSubMode("addpoint");
			}
			else if (subMode == "newrectangle")
			{
				PhysEditor.UndoTakeSnapshot();
				addlineActive = true;
				currentPointIndex = -1;
				Lines_NewRect();				
				var line:EdLine = Lines_GetLineByIndex(currentLineIndex);
				EditParams.AddParameterListBox(line.objParameters);
				SetSubMode("addpoint");
				return;
			}
			else if (subMode == "dragpoint")
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_SelectPoint(mxs_nogrid, mys_nogrid);				
			}
			else if (subMode == "dragline")
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_SelectLineByArea(mxs_nogrid, mys_nogrid);
				dragPoint = new Point(mxs_nogrid, mys_nogrid);
			}

			else
			{
				if (addlineActive)
				{
					if (GetCurrentLinePrimitiveType() == EdLine.PRIMITIVE_LINE)
					{
						PhysEditor.UndoTakeSnapshot();
						Lines_AddPoint(mxs, mys);
						Utils.print("adding point at " + mxs + " " + mys);
					}
				}
			}
		}
		
		public override function OnMouseUp(e:MouseEvent):void
		{
			super.OnMouseUp(e);
			
			if (subMode == "scaleline")
			{
				var scale:Number = 1 + ((mxs - scaleCentreX) * 0.005);
				Lines_Scale(scale);
			}
			else if (subMode == "freeline")
			{
				FreeLine_End();
			}
		}
		
		function GetHoveredLine()
		{
			var li:int = currentLineIndex;
			var pi:int = currentPointIndex;
			Lines_SelectLineByArea(mxs, mys);
			if (currentLineIndex == -1) Lines_SelectLine(mxs, mys);
			hoveredLineIndex = currentLineIndex;
			Lines_SelectPoint(mxs, mys);
			hoveredPointIndex = currentPointIndex;
			hoveredPointLineIndex = currentLineIndex;
			currentLineIndex = li;
			currentPointIndex = pi;
		}
		
		public override function OnMouseMove(e:MouseEvent):void
		{
			super.OnMouseMove(e);
			
			var l:Level = GetCurrentLevel();

			hoveredLineIndex = -1;
			GetHoveredLine();
			
			if (subMode == "dragline" && e.buttonDown == false)
			{
				GetHoveredLine();
			}
			if (subMode == "scaleline" && e.buttonDown == false)
			{
				GetHoveredLine();
			}
			if (subMode == "rotateline" && e.buttonDown == false)
			{
				GetHoveredLine();
			}
			
			
			if (e.buttonDown == false) return;
			
			else if (subMode == "freeline")
			{
				FreeLine_Move();
			}
			
			if (subMode == "newrectangle")
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_DragRect(mxs,mys);				
			}
			
			if (subMode == "dragpoint")
			{
				if (currentPointIndex != -1 && currentLineIndex!=-1)
				{
					var line:EdLine = l.lines[currentLineIndex];
					if (line.primitiveType == EdLine.PRIMITIVE_LINE)
					{
						UpdateObjectsWhichSnapToLines();
						var p:Point = line.points[currentPointIndex];
						p.x = mxs;
						p.y = mys;
						
						
					}
					if (line.primitiveType == EdLine.PRIMITIVE_RECTANGLE)
					{
						var p:Point = line.points[currentPointIndex];
						if (currentPointIndex == 0)
						{
							if (mxs < line.points[2].x && mys < line.points[2].y)
							{
								p.x = mxs;
								p.y = mys;
								line.points[1].y = mys;
								line.points[3].x = mxs;
							}
						}
						if (currentPointIndex == 2)
						{
							if (mxs > line.points[0].x && mys > line.points[0].y)
							{
								p.x = mxs;
								p.y = mys;
								line.points[1].x = mxs;
								line.points[3].y = mys;
							}
						}
					}					
				}
			}
			if (subMode == "dragline")
			{
				if (currentLineIndex != -1)
				{
					var dx:Number = mxs - dragPoint.x;
					var dy:Number = mys - dragPoint.y;
					for each(var p:Point in l.lines[currentLineIndex].points)
					{
						p.x += dx;
						p.y += dy;							
					}
					dragPoint = new Point(mxs, mys);
				}
			}
			else if (subMode == "scaleline")
			{
				var scale:Number = 1 + ((mxs - scaleCentreX) * 0.005);
				Lines_Scale(scale);
			}
			else if (subMode == "rotateline")
			{
				var rot:Number = ((mxs - rotateCentreX) * 0.005);
				Lines_Rotate(rot);
			}
			
		}
		
		
		function UpdateObjectsWhichSnapToLines()
		{
			var l:Level = GetCurrentLevel();
			var line:EdLine = l.lines[currentLineIndex];
			
			if (line.GetCurrentPolyMaterial().initType != "surface") return;
			
			var l1:int = currentPointIndex;
			var l0:int = currentPointIndex - 1;
			if (l0 < 0) l0 = line.points.length - 1;
			var l2:int = currentPointIndex + 1;
			if (l2 >= line.points.length) l2 = 0;
			
			
			
			for (var q:int = 0; q < 2; q++)
			{
			
				var list:Array = new Array();
				var rotlist:Array = new Array();
				var rotoffs:Array = new Array();
				var percents:Array = new Array();
				var yoffs:Array = new Array();
				
				var p:Point = line.points[l1];
				var p1:Point = line.points[l2];

				if (q == 1)
				{
					p = line.points[l0];
					p1 = line.points[l1];
				}
				
				if (p.x < p1.x)
				{
					
					
					var x0:Number = p.x;
					var x1:Number = p1.x;
					if (x0 > x1)
					{
						x0 = p1.x;
						x1 = p.x;				
					}
					var y0:Number = p.y;
					var y1:Number = p1.y;
					
					var y0test:Number = p.y;
					var y1test:Number = p1.y;
					
					if (y0test > y1test)
					{
						y0test = p1.y;
						y1test = p.y;
					}

					
					
						
					var level_instances:Array = GetCurrentLevelInstances();
					for each (var obj:EdObj in level_instances)
					{
						if (obj.y >= y0test - 20 && obj.y <= y1test + 20)
						{
							if (obj.objParameters.GetValueBoolean("take_surface_pos"))
							{
								var po:PhysObj = Game.objectDefs.FindByName(obj.typeName);
								if (obj.x >= x0 && obj.x <= x1)
								{
									list.push(obj);
									var pc:Number =Utils.ScaleTo(0, 1, x0, x1, obj.x)
									percents.push(pc);
									
									var y:Number = Utils.ScaleTo(y0, y1, 0, 1, pc);
									
									yoffs.push(obj.y - y);
								}
							}
							if (obj.objParameters.GetValueBoolean("take_surface_dir"))
							{
								var po:PhysObj = Game.objectDefs.FindByName(obj.typeName);
								if (obj.x >= x0 && obj.x <= x1)
								{
									rotlist.push(obj);
									var ang:Number = Math.atan2(p1.y - p.y, p1.x - p.x);
									rotoffs.push(ang);
								}
							}
						}
					}
				}
				

				if (list.length != 0 || rotlist.length != 0)
				{
				
					// new line positions
					
					var p:Point = new Point(mxs, mys);
					var p1:Point = line.points[l2];

					if (q == 1)
					{
						p = line.points[l0];
						p1 =  new Point(mxs, mys);
					}
					
					var x0:Number = p.x;
					var x1:Number = p1.x;
					if (x0 > x1)
					{
						x0 = p1.x;
						x1 = p.x;				
					}
					var y0:Number = p.y;
					var y1:Number = p1.y;
					
					for (var i:int = 0; i < list.length; i++)
					{
						obj = list[i];
						pc = percents[i];
						var yoff:Number = yoffs[i];
						
						var y:Number = Utils.ScaleTo(y0, y1, 0, 1, pc);
						obj.y = y + yoff;

						var x:Number = Utils.ScaleTo(x0, x1, 0, 1, pc);
						obj.x = x;
						
						
					}
					for (var i:int = 0; i < rotlist.length; i++)
					{
						obj = rotlist[i];
						var oldang:Number = rotoffs[i];
						var ang:Number = Math.atan2(p1.y - p.y, p1.x - p.x);

						obj.rot += (Utils.RadToDeg(ang - oldang));
						
					}
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
			
			if (s == "null")
			{
				PhysEditor.CursorText_Set("");
			}
			if (s == "addpoint")
			{
				PhysEditor.CursorText_Set("add point");
			}
			if (s == "newline")
			{
				PhysEditor.CursorText_Set("new line");
			}
			if (s == "freeline")
			{
				PhysEditor.CursorText_Set("free line");
			}
			if (s == "newrectangle")
			{
				PhysEditor.CursorText_Set("new rectangle");
			}
			if (s == "dragpoint")
			{
				PhysEditor.CursorText_Set("drag point");
			}
			if (s == "dragline")
			{
				PhysEditor.CursorText_Set("drag line");
			}
			if (s == "scaleline")
			{
				PhysEditor.CursorText_Set("scale line");				
			}
			if (s == "rotateline")
			{
				PhysEditor.CursorText_Set("rotate line");				
			}
			
			
		}
		
		public override function Update():void
		{
			super.Update();
			
			
			if (currentLineIndex != -1)		// a line is selected
			{
				if (currentPointIndex != -1)
				{
					if (KeyReader.Pressed(KeyReader.KEY_K))
					{
						PhysEditor.UndoTakeSnapshot();
						var firstPointIndex:int = currentPointIndex;
						Lines_SelectPoint(mxs, mys);	
						if (firstPointIndex != currentPointIndex)
						{
							Lines_SplitPoly(currentLineIndex, firstPointIndex, currentPointIndex);
						}
					}
				}
				
				
				if (KeyReader.Pressed(KeyReader.KEY_DELETE) || KeyReader.Pressed(KeyReader.KEY_SQUIGGLE))
				{
					PhysEditor.UndoTakeSnapshot();
					Lines_DeleteSelectedLine();
					EditParams.AddParameterListBoxOrClear(null);
				}
				else if (KeyReader.Pressed(KeyReader.KEY_X))
				{
					if (GetCurrentLinePrimitiveType() ==EdLine.PRIMITIVE_LINE)
					{
						PhysEditor.UndoTakeSnapshot();
						Lines_DeletePoint(mxs, mys);
					}
				}
				else if (KeyReader.Pressed(KeyReader.KEY_E))
				{
					Lines_PickPieceForObjCol();
				}
				else if (KeyReader.Pressed(KeyReader.KEY_D))
				{
					PhysEditor.UndoTakeSnapshot();
					Lines_DuplicateSelectedLine();
				}
				else if (KeyReader.Pressed(KeyReader.KEY_C))
				{
					CopyParameters();
				}
				else if (KeyReader.Pressed(KeyReader.KEY_V))
				{
					PhysEditor.UndoTakeSnapshot();
					PasteParameters();
				}
				else if (KeyReader.Pressed(KeyReader.KEY_S))
				{
					if (GetCurrentLinePrimitiveType() == EdLine.PRIMITIVE_LINE)
					{
						PhysEditor.UndoTakeSnapshot();
						Lines_InsertPointAtMousePos(mxs, mys);
					}
				}
				else if (KeyReader.Pressed(KeyReader.KEY_A))
				{
					if (GetCurrentLinePrimitiveType() == EdLine.PRIMITIVE_LINE)
					{
						PhysEditor.UndoTakeSnapshot();
						Lines_InsertPoint(mxs, mys);				
					}
				}
				else if (KeyReader.Down(KeyReader.KEY_Q))
				{
					if (GetCurrentLinePrimitiveType() ==  EdLine.PRIMITIVE_LINE)
					{					
						PhysEditor.UndoTakeSnapshot();
						Lines_SelectPoint(mxs, mys);				
					}
				}
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_L))
			{
				Lines_SelectLineByArea(mxs, mys);
				if(currentLineIndex == -1) Lines_SelectLine(mxs, mys);
				var line:EdLine = Lines_GetLineByIndex(currentLineIndex);
				lastLineSelectedIndex = currentLineIndex;
				AddLineParameterListBoxOrClear(line);
			}
			if (KeyReader.Pressed(KeyReader.KEY_N))
			{
				SetSubMode("newline");
			}
			if (KeyReader.Pressed(KeyReader.KEY_SPACE))
			{
				SetSubMode("null");
				currentLineIndex = -1;
				currentPointIndex = -1;
				AddLineParameterListBoxOrClear(null);
				
			}
			
			
			if(KeyReader.Pressed(KeyReader.KEY_TAB) && KeyReader.Down(KeyReader.KEY_CONTROL) )
			{
				PhysEditor.UndoTakeSnapshot();
				if (KeyReader.Down(KeyReader.KEY_SHIFT))
				{
					PhysEditor.RemoveEverything();
				}
				PhysEditor.GetCurrentLevel().lines = new Array();
				currentLineIndex = -1;
				currentPointIndex = -1;
			}
			
			if (KeyReader.Down(KeyReader.KEY_T))
			{
				SetSubMode("scaleline");
			}
			else if (KeyReader.Down(KeyReader.KEY_Y))
			{
				SetSubMode("rotateline");
			}
//			else if (KeyReader.Down(KeyReader.KEY_M))
//			{
//				SetSubMode("newrectangle");
//			}
			else if (KeyReader.Down(KeyReader.KEY_SHIFT))
			{
				SetSubMode("dragpoint");
			}
			else if (KeyReader.Down(KeyReader.KEY_CONTROL))
			{
				SetSubMode("dragline");
			}
			else 
			{
				if (subMode != "pick" && subMode != "newline" && subMode!="freeline")
				{
					
					if (subMode == "addpoint" && KeyReader.Pressed(KeyReader.KEY_F))
					{
						SetSubMode("freeline");
					}
					else
					{

						if (addlineActive)
						{
							if (currentLineIndex != -1)
							{
								if (GetCurrentLine().primitiveType == EdLine.PRIMITIVE_LINE)
								{
									SetSubMode("addpoint");
								}
								else
								{
									SetSubMode("null");
								}
							}
							else
							{
								SetSubMode("null");
							}
						}
						else
						{
							SetSubMode("null");
						}
					}
				}
			}
			
			var l:Level = GetCurrentLevel();
			
			if (KeyReader.Pressed(KeyReader.KEY_9))
			{
				addlineActive = (addlineActive == false);
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_R))
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_Reverse();
				return;
			}
			if (KeyReader.Pressed(KeyReader.KEY_I))
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_EnterID();
				return;
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_LEFTSQUAREBRACKET))
			{
				Lines_ScrollToFirstPointOfSelectedLine();
			}					
			if (KeyReader.Pressed(KeyReader.KEY_RIGHTSQUAREBRACKET))
			{
				Lines_ScrollToLastPointOfSelectedLine();
			}					
		}
		
		function AddLineParameterListBoxOrClear(l:EdLine)
		{
			if (l == null)
			{
				EditParams.AddParameterListBoxOrClear(null);
			}
			else
			{			
				EditParams.AddParameterListBoxOrClear(l.objParameters);
			}
		}
		
		public override function Render(bd:BitmapData):void
		{
			super.Render(bd);
			bd.fillRect(Defs.screenRect, 0xff445566);
			PhysEditor.RenderBackground(bd);
			PhysEditor.Editor_RenderGrid(bd);
			PhysEditor.RenderSortedEdObjs();
			PhysEditor.Editor_RenderMiniMap();
			PhysEditor.Editor_RenderJoints(bd);
			
			
			PhysEditor.Editor_RenderLineToCursor();
			
			
			
			
			var hoveredLine:EdLine = GetCurrentLevel().GetLineByIndex(hoveredLineIndex);
			if (hoveredLine != null)
			{
				hoveredLine.RenderHighlighted(EditableObjectBase.HIGHLIGHT_HOVER);
			}
			
			var hoveredLine:EdLine = GetCurrentLevel().GetLineByIndex(hoveredLineIndex);
			if (hoveredLine != null)
			{
				hoveredLine.RenderHighlightSelectedPoint(hoveredPointIndex, 0xffffff00, 3);
			}
			
			var l:EdLine = GetCurrentLine()
			if(l != null)
			{
				l.RenderHighlighted(EditableObjectBase.HIGHLIGHT_SELECTED);
				l.RenderHighlightSelectedPoint(currentPointIndex,0xffffffff,4);
			}
			
		}
		public override function RenderHud(x:int,y:int):int
		{
			var s:String;
			s = "I: Line ID: ";
			if (currentLineIndex != -1)
			{
				var line:EdLine = GetCurrentLevel().lines[currentLineIndex];									
				s += line.id;
			}
			else
			{
				s += "NONE";					
			}
			
			
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "L: Select Line";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "DEL: Delete Line";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "X: Delete Point";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "D: Duplicate Poly";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "SHIFT Drag Point";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "CTRL Drag Line";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "N: New line";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "F: Free Line Mode";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "M: Make Box";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "S: Insert Point On Line";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "Q: Select Point";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "A: Insert Point After";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "T: Scale Line (drag)";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "Y: Rotate Line (drag)";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "8: Change Type";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "9: Toggle addline display";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "R: Reverse Line Direction";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "[ and ]: Move to first / last point of selected line";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "ScrollPos: "+PhysEditor.scrollX+" "+PhysEditor.scrollY;
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "CursorPos: " + int(PhysEditor.mxs) + " " + int(PhysEditor.mys);
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "GridCursorPos: " + mx + "," + my + "   " + mxs + "," + mys;
			y += PhysEditor.AddInfoText("a", x, y, s);
			
			if (currentLineIndex != -1)
			{
				var line:EdLine = GetCurrentLevel().lines[currentLineIndex];				
				
			}
			return y;
		}

//-----------------------------------------------------------------------------------------------------

		
		public var currentLineIndex:int;
		public var currentPointIndex:int;

		function GetCurrentLinePrimitiveType():String
		{
			if (GetCurrentLine() == null) return "";
			return GetCurrentLine().primitiveType;
		}
		
		function GetCurrentLine():EdLine
		{
			if (currentLineIndex == -1) return null;
			var l:Level = GetCurrentLevel();
			var line:EdLine = l.lines[currentLineIndex];
			return line;
		}
		
		function Lines_EnterID()
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			var line:EdLine = l.lines[currentLineIndex];
			PhysEditor.AddTextEntry(100,100, "line id ",line.id,  Lines_EnterID_Done);
		}
		function Lines_EnterID_Done(text:String)
		{
			var l:Level = GetCurrentLevel();
			var line:EdLine = l.lines[currentLineIndex];
			line.id = text;
		}
		
		
		function Lines_Reverse()
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			
			var pts:Array = l.lines[currentLineIndex].points;
			
			var newpts:Array = pts.reverse();
			
			l.lines[currentLineIndex].points = newpts;
			
		}
		function Lines_MinDistanceBetweenPoints(dist:Number)
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();			
			var pts:Array = l.lines[currentLineIndex].points;
			var newpts:Array = new Array();
			var removecount:int = 0;
			
			for (var i:int = 0; i < pts.length; i++)
			{
				var p:Point = pts[i];
				newpts.push(p.clone());
				
				for (var j:int = i+1; j < pts.length; j++)
				{
					var p1:Point = pts[j];
					var d:Number = Utils.DistBetweenPoints(p.x, p.y, p1.x, p1.y);
					if (d < dist)
					{
						removecount++;
						i++;
					}
					else
					{
						j = 9999999;
					}
				}
			}
			
			l.lines[currentLineIndex].points = newpts;
			Utils.print("removecount " + removecount);
			
		}
		function Lines_AddPoint(x:Number, y:Number)
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			var p:Point = new Point(x, y);
			var pts:Array = l.lines[currentLineIndex].points;
			pts.push(p);
			l.lines[currentLineIndex].points = pts;			
		}
		
		function Lines_InsertPointAtMousePos(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			if (currentLineIndex == -1) return;
			
			var numPoints = l.lines[currentLineIndex].points.length;
			var a0:Array = l.lines[currentLineIndex].points;
			
			var i:int;
			for (i = 0; i < numPoints - 1; i++)
			{
				var p0:Point = a0[i];
				var p1:Point = a0[i + 1];
				
				var t:Number = Collision.ClosestPointOnLine(p0.x, p0.y, p1.x, p1.y, x, y);
				if (t >= 0.0 && t <= 1)
				{
					if (Utils.DistBetweenPoints(x, y, Collision.closestX, Collision.closestY) < 2)
					{
						currentPointIndex = i;
						Lines_InsertPointOnCurrentLine(x, y);
						return;
						
					}
				}
			}
		}
		
		function Lines_InsertPointOnCurrentLine(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			
			
			if (currentLineIndex != -1 && currentPointIndex != -1)
			{
				var a0:Array = l.lines[currentLineIndex ].points;
				
				if (currentPointIndex == a0.length - 1) return;
				
				var newPoint:Point = new Point(x, y);
				
				a0.splice(currentPointIndex+1, 0, newPoint);
				
//				l.lines[currentPointIndex].points = a0;
				currentPointIndex = currentPointIndex + 1;
			}			
		}
		
		
		function Lines_InsertPoint(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			
			var lineIndex:int = 0;
			var selectedLineIndex:int = currentLineIndex;
			var selectedPointIndex:int = currentPointIndex;
			if (selectedLineIndex == -1 || selectedPointIndex == -1) return;
			
			
			var a0:Array = l.lines[selectedLineIndex].points;
			
			if (selectedPointIndex == a0.length - 1) 
			{
				var newPoint:Point = new Point(x, y);
				a0.push(newPoint);
				l.lines[selectedLineIndex].points = a0;
				currentPointIndex++;
				return;
			}
			var p0:Point = a0[selectedPointIndex].clone();
			var p1:Point = a0[selectedPointIndex + 1].clone();
			
			var newPoint:Point = new Point(x,y);
			
			a0.splice(selectedPointIndex+1, 0, newPoint);
			
			l.lines[selectedLineIndex].points = a0;
			currentPointIndex++;
		}
		
		
		function Lines_PickPieceForObjCol()
		{
			PhysEditor.oldEditMode = PhysEditor.editMode;
			PhysEditor.editModeObj_PickPieceForLink.returnFunction = PickObjectForObjColReturnFunction;
			PhysEditor.SetEditMode(PhysEditor.editMode_PickPieceForLink,false);
			PhysEditor.CursorText_Set("Pick Object For ObjCol");
			
		}
		function PickObjectForObjColReturnFunction(poi:EdObj)
		{
			var id:String = "";
			if (poi != null)
			{
				CreateObjLineCollision(poi);
			}
			PhysEditor.SetEditMode(PhysEditor.oldEditMode,false);
			PhysEditor.CursorText_Set("");

		}
		
		function CreateObjLineCollision(poi:EdObj):void 
		{
			// Generate the poly collision from the line and the centre of the object
			var a:Array = new Array();
			var l:EdLine = GetCurrentLine();
			if (l == null) return;
			for each(var p:Point in l.points)
			{
				var p1:Point = new Point(p.x - poi.x, p.y - poi.y);
				a.push(p1);
			}
			
			
			var po:PhysObj = Game.objectDefs.FindByName(poi.typeName);
			if (po != null)
			{
				if (po.bodies.length != 0)
				{
					var b:PhysObj_Body = po.bodies[0];
					if (b.shapes.length != 0)
					{
						var shape:PhysObj_Shape = b.shapes[0];
						if (shape.type == PhysObj_Shape.Type_Poly)
						{
							shape.poly_points = new Array();
							for each(var p:Point in a)
							{
								shape.poly_points.push(p.clone());
							}
						}
						trace("POO");						
					}
				}
			}
			
			Utils.print(poi.typeName);
			
			var s:String = "";
			s += 'vertices="';
			for (var i:int = 0; i < a.length; i++)			
			{
				p = a[i];
				s += int(p.x) + "," + int(p.y);
				if (i != a.length - 1)
				{
					s += ", ";
				}
			}
			s += '"';
			Utils.print(s);
			ExternalData.OutputString(s);
			
		}
		
		
		function Lines_DuplicateSelectedLine()
		{
			var l:Level = GetCurrentLevel();
			if (currentLineIndex != -1)
			{
				var line:EdLine = l.lines[currentLineIndex];
				var newLine:EdLine = line.Clone();
				
				newLine.id = "";
				for each(var p:Point in newLine.points)
				{
					p.x += 10;
					p.y += 10;
				}				
				l.lines.push(newLine);
				currentLineIndex = l.lines.length - 1;
			}
		}

		
		function Lines_DeleteSelectedLine()
		{
			var l:Level = GetCurrentLevel();
			if (currentLineIndex != -1)
			{
				var edLine:EdLine = Lines_GetLineByIndex(currentLineIndex);
				PhysEditor.editModeObj_Joints.UpdateJoints_ObjectDeleted(edLine.id);

				
				var a2:Array = new Array();
				var index:int = 0;
				for each(var line:EdLine in l.lines)
				{
					if ( index != currentLineIndex)
					{
						a2.push(line.Clone());
					}
					index++;
				}
				l.lines = a2;
				currentPointIndex = -1;
				currentLineIndex = -1;
			}
		}
		
		
		
		function Lines_DeletePoint(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			var lineIndex:int = 0;
			var selectedLineIndex:int = -1;
			var selectedPointIndex:int = -1;
			
			for each (var line:EdLine in l.lines)
			{
				var pointIndex:int = 0;
				for each(var p:Point in line.points)
				{
					if (Utils.DistBetweenPoints(p.x, p.y, x, y) < 3*(1/PhysEditor.zoom) )
					{
						selectedLineIndex = lineIndex;
						selectedPointIndex = pointIndex;
					}
					pointIndex++;
				}
				lineIndex++;
			}
			
			if (selectedLineIndex != -1 && selectedPointIndex != -1)
			{
				var a0:Array = l.lines[selectedLineIndex].points;
				var a1:Array = new Array();
				var i:int;
				for (i = 0; i < a0.length; i++)
				{
					if (i != selectedPointIndex)
					{
						a1.push(a0[i].clone());
					}
				}
				l.lines[selectedLineIndex].points = a1;
				
				var a2:Array = new Array();
				for each(var line:EdLine in l.lines)
				{
					if (line.points.length != 0)					
					{
						a2.push(line.Clone());
					}
					else
					{
						currentLineIndex = -1;
					}
				}
				l.lines = a2;
				currentPointIndex = -1;
			}
			
		}
		function Lines_ScrollToFirstPointOfSelectedLine()
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			var a:Array = l.lines[currentLineIndex].points;
			var p:Point = a[0];
			PhysEditor.scrollX = p.x - (Defs.displayarea_w * 0.5);
			PhysEditor.scrollY = p.y - (Defs.displayarea_h * 0.5);
		}
		
		function Lines_ScrollToLastPointOfSelectedLine()
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			var a:Array = l.lines[currentLineIndex].points;
			var p:Point = a[a.length - 1];
			PhysEditor.scrollX = p.x - (Defs.displayarea_w * 0.5);
			PhysEditor.scrollY = p.y - (Defs.displayarea_h * 0.5);
		}
		

		function Lines_DragRect(x:int,y:int)
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			var line:EdLine = l.lines[currentLineIndex];
			
			if (line.points.length != 4) return;
			line.points[2].x = x;
			line.points[2].y = y;
			line.points[1].x = x;
			line.points[3].y = y;
			
		}


		function Lines_NewRect()
		{
			var line:EdLine = new EdLine();
			line.type = 0;
			var l:Level = GetCurrentLevel();
			
			var size:Number = 0;
			
			line.primitiveType = EdLine.PRIMITIVE_RECTANGLE;
			line.AddPoint(mxs, mys);
			line.AddPoint(mxs+size, mys);
			line.AddPoint(mxs+size, mys+size);
			line.AddPoint(mxs, mys+size);

			var prevLine:EdLine = GetCurrentLevel().GetLineByIndex(lastLineSelectedIndex);
			if (prevLine != null)
			{
				line.objParameters = prevLine.objParameters.Clone();
			}			
			
			
			l.lines.push(line);
			
			currentLineIndex = l.lines.length - 1;
			currentPointIndex = 2;
			
			Utils.print("New line " + currentLineIndex);
		}
		
		
		public function HitTestRectangle(r:Rectangle):Array
		{
			var a:Array = new Array();
			var list:Array = GetCurrentLevelLines();			
			for each(var line:EdLine in list)
			{
				if (line.HitTestRectangle(r)) a.push(line);
			}
			return a;			
		}

		
		function Lines_NewLine()
		{
			var prevLine:EdLine = GetCurrentLevel().GetLineByIndex(lastLineSelectedIndex);
			
			var line:EdLine = new EdLine();
			
			if (prevLine != null)
			{
				line.objParameters = prevLine.objParameters.Clone();
			}
			else
			{
				var s:String = line.objParameters.GetValueString("line_material");
				var pm:PolyMaterial = PolyMaterials.GetByName(s);
				if (pm != null)
				{
					line.objParameters.SetValueString("game_layer", pm.defaultGameLayer);
				}
			}
			line.objParameters.SetParam("editor_layer", EditorLayers.GetActive().toString());
			
			line.type = 0;
			var l:Level = GetCurrentLevel();
			l.lines.push(line);
			currentLineIndex = l.lines.length - 1;
			Utils.print("New line " + currentLineIndex);
			lastLineSelectedIndex = currentLineIndex;
		}

		function Lines_GetLineByIndex(_index:int):EdLine
		{
			if (_index == -1) return null;
			var l:Level = GetCurrentLevel();
			return l.lines[_index];
		}
		
		
		public function Lines_SelectLine(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			var lineIndex:int = 0;
			currentLineIndex = -1;
			for each (var line:EdLine in l.lines)
			{
				var i:int;
				var a0:Array = line.points;
				var numPoints:int = line.points.length;
				for (i = 0; i < numPoints; i++)
				{
					var j:int = i + 1;
					if (j >= numPoints) j = 0;
					var p0:Point = a0[i];
					var p1:Point = a0[j];
					
					var t:Number = Collision.ClosestPointOnLine(p0.x, p0.y, p1.x, p1.y, x, y);
					if (t >= 0.0 && t <= 1)
					{
						if (Utils.DistBetweenPoints(x, y, Collision.closestX, Collision.closestY) < 2)
						{
							currentLineIndex = lineIndex;
							currentPointIndex = -1;
							return;
							
						}
					}
				}
				lineIndex++;
			}
		}
		
		function Lines_SelectLineByPoint(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			var lineIndex:int = 0;
			currentLineIndex = -1;
			for each (var line:EdLine in l.lines)
			{
				for each(var p:Point in line.points)
				{
					if (Utils.DistBetweenPoints(p.x, p.y, x, y) < 3)
					{
						currentLineIndex = lineIndex;
						currentPointIndex = -1;
						return;
					}
				}
				lineIndex++;
			}
		}
		
		function Lines_SelectLineByArea(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			var lineIndex:int = 0;
			currentLineIndex = -1;
			for each (var line:EdLine in l.lines)
			{
				var layer:int = 0;
				if (line.objParameters.GetParam("editor_layer") != "")
				{
					layer = line.objParameters.GetValueInt("editor_layer")-1;
				}
				
				if (EditorLayers.IsVisible(layer) == true)
				{
					var polyMaterial:PolyMaterial = line.GetCurrentPolyMaterial();			

					if (polyMaterial.edType == "outline")
					{						
						if (line.PointOnLine(x, y))
						{
							currentLineIndex = lineIndex;
							currentPointIndex = -1;
							return;
						}
					}
					else
					{
					
						if (line.PointInPoly(x, y))
						{
							currentLineIndex = lineIndex;
							currentPointIndex = -1;
							return;
						}
					}
				}
				lineIndex++;
			}
		}
		
		function Lines_MovePoints(x:Number, y:Number)
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			var points:Array = l.lines[currentLineIndex].points;
			
			var maxd:Number = 100;
			var d:Number;
			
			
			for each(var p:Point in points)
			{
				d = Utils.DistBetweenPoints(p.x, p.y, x, y);
				if (d < maxd)
				{
					d = maxd - d;
					d = Utils.ScaleTo(0, 5, 0, maxd, d);
					if (p.y < y)
					{
						p.y -= d;
					}
					else if (p.y > y)
					{
						p.y += d;
					}
				}
			}
			
			
		}
		
		function Lines_Subdivide(x:Number, y:Number)
		{
			if (currentLineIndex == -1 || currentPointIndex == -1) return;
			
			var l:Level = GetCurrentLevel();
			var lineIndex:int = 0;
			var selectedLineIndex:int = -1;
			var selectedPointIndex:int = -1;
			
			for each (var line:EdLine in l.lines)
			{
				var pointIndex:int = 0;
				for each(var p:Point in line.points)
				{
					if (Utils.DistBetweenPoints(p.x, p.y, x, y) < 3)
					{
						selectedLineIndex = lineIndex;
						selectedPointIndex = pointIndex;
					}
					pointIndex++;
				}
				lineIndex++;
			}
			if (selectedLineIndex != -1 && selectedPointIndex != -1)
			{
				if (selectedPointIndex == currentPointIndex) return;
				var p0:int = currentPointIndex;
				var p1:int = selectedPointIndex;
				if (p1 < p0)
				{
					var p2:int = p0;
					p1 = p0;
					p0 = p2;
				}
				
				var newpoints:Array = new Array();
				
				var i:int;
				var points:Array = l.lines[selectedLineIndex].points;
				for (i = p0; i < p1; i++)
				{
					var pt0:Point = points[i].clone();
					var pt1:Point = points[i + 1].clone();
					var pt2:Point = new Point( (pt0.x + pt1.x) / 2, (pt0.y + pt1.y) / 2);
					newpoints.push(pt2);
					newpoints.push(pt1);
				}
				
				var ps:Array = new Array();
				for (i = 0; i <= p0; i++)
				{
					ps.push(points[i].clone());
				}
				for each(pt2 in newpoints)
				{
					ps.push(pt2.clone());
				}
				for (i = p1+1; i <points.length; i++)
				{
					ps.push(points[i].clone());
				}
				l.lines[selectedLineIndex].points = ps;
			}
		}
		
		
		
//---------------------------------------------------------------------------------------		
		var scaleCentreX:Number;
		var scaleCentreY:Number;
		var scalePositions:Array;
		
		function Lines_StartScale(x:Number,y:Number)
		{
			scaleCentreX = x;
			scaleCentreY = y;
			scalePositions = new Array();
			
			var l:Level = GetCurrentLevel();
			if (currentLineIndex != -1)
			{				
				for each(var p:Point in l.lines[currentLineIndex].points)
				{
					scalePositions.push(p.clone());						
				}
			}
			
		}
		function Lines_Scale(scale:Number)
		{
			var l:Level = GetCurrentLevel();
			if (currentLineIndex != -1)
			{				
				for (var i:int = 0; i < l.lines[currentLineIndex].points.length; i++ )					
				{
					var p:Point = scalePositions[i];						
					var x:Number = scaleCentreX + ((p.x - scaleCentreX) * scale);
					var y:Number = scaleCentreY + ((p.y - scaleCentreY) * scale);
					l.lines[currentLineIndex].points[i] = new Point(x, y);						
				}
			}
		}
//---------------------------------------------------------------------------------------		
		var rotateCentreX:Number;
		var rotateCentreY:Number;
		var rotatePositions:Array;
		
		function Lines_StartRotate(x:Number,y:Number)
		{
			var line:EdLine = GetCurrentLevel().GetLineByIndex(currentLineIndex);
			if (line == null) return;
			
			rotateCentreX = x;
			rotateCentreY = y;
			rotatePositions = new Array();
			
			for each(var p:Point in line.points)
			{
				rotatePositions.push(p.clone());						
			}
			
		}
		function Lines_Rotate(rot:Number)
		{
			var line:EdLine = GetCurrentLevel().GetLineByIndex(currentLineIndex);
			if (line == null) return;
			
			var m:Matrix = new Matrix();
			m.translate(-rotateCentreX, -rotateCentreY);
			m.rotate(rot);
			m.translate(rotateCentreX, rotateCentreY);

			for (var i:int = 0; i < line.points.length; i++)
			{
				var p:Point = m.transformPoint(rotatePositions[i]);
				line.points[i] = p.clone();	
			}
		}
		
//---------------------------------------------------------------------------------------		

		function Lines_SplitPoly(lineIndex:int, p0Index:int, p1Index:int)
		{
			if (lineIndex == -1) return;
			if (p0Index == -1) return;
			if (p1Index == -1) return;

			var l:Level = GetCurrentLevel();
			
			var line:EdLine = l.lines[lineIndex];
			
			var newLine0:EdLine = new EdLine();
			var newLine1:EdLine = new EdLine();
			
			
			// make poly 0:
			var i:int = p0Index;
			var doit:Boolean = true;
			do
			{		
				
				var p:Point = line.GetPoint(i).clone();
				newLine0.AddPoint(p.x, p.y);
				if (i == p1Index)
				{
					doit = false;
				}
				i++;
				if (i >= line.GetNumPoints()) i = 0;
				
			}while (doit);
			
			i = p1Index;
			doit = true;
			do
			{		
				
				var p:Point = line.GetPoint(i).clone();
				newLine1.AddPoint(p.x, p.y);
				if (i == p0Index)
				{
					doit = false;
				}
				i++;
				if (i >= line.GetNumPoints()) i = 0;
				
			}while (doit);

			
			newLine0.objParameters = line.objParameters.Clone();
			newLine1.objParameters = line.objParameters.Clone();
			newLine0.type = 0;
			newLine1.type = 0;
			
			Lines_DeleteSelectedLine();
			l.lines.push(newLine0);
			l.lines.push(newLine1);
			currentLineIndex = -1;
			currentPointIndex = -1;
			
			
			
		}

//---------------------------------------------------------------------------------------		
		function Lines_SelectPoint(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			var lineIndex:int = 0;
//			currentLineIndex = -1;
			currentPointIndex = -1;
			for each (var line:EdLine in l.lines)
			{
				var pointIndex:int = 0;
				if (line.primitiveType == EdLine.PRIMITIVE_LINE)
				{
					for each(var p:Point in line.points)
					{
						if (Utils.DistBetweenPoints(p.x, p.y, x, y) < (3*(1/PhysEditor.zoom)) )
						{
							currentLineIndex = lineIndex;
							currentPointIndex = pointIndex;
							return;
						}
						pointIndex++;
					}
				}
				if (line.primitiveType == EdLine.PRIMITIVE_RECTANGLE)
				{
					for (var i:int = 0; i <= 2; i+=2)
					{
						var p:Point = line.points[i];
						if (Utils.DistBetweenPoints(p.x, p.y, x, y) < 3)
						{
							currentLineIndex = lineIndex;
							currentPointIndex = pointIndex;
							return;
						}
						pointIndex+=2;
					}
				}
				
				lineIndex++;
			}
		}
		
		function FreeLine_Start()
		{
			PhysEditor.UndoTakeSnapshot();
			addlineActive = false;
			Lines_AddPoint(mxs, mys);
		}
		function FreeLine_Move()
		{
			Lines_AddPoint(mxs, mys);		
		}
		function FreeLine_End()
		{
			Lines_MinDistanceBetweenPoints(freeLine_MinDist);
			SetSubMode("addpoint");
			addlineActive = true;
		}
		
	}

}