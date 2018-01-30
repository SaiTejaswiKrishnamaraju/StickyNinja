package EditorPackage 
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditMode_ObjCol extends EditMode_Base
	{
		var addlineActive:Boolean;
		var newLineType:int;
		
		var objLines:Array;
		
		public function EditMode_ObjCol() 
		{
			
		}
		
		public override function EnterMode():void
		{
			PhysEditor.CursorText_Show();
			PhysEditor.CursorText_Set("");
			SetSubMode("null");
			objLines = new Array();
			PhysEditor.scrollX = 0;
			PhysEditor.scrollY = 0;
			
		}
		public override function InitOnce():void
		{
			currentLineIndex = -1;
			currentPointIndex = -1;
			addlineActive = false;
			newLineType = 0;			
			var l:Level = GetCurrentLevel();
			currentLineIndex = 0;
			objLines = new Array();
		}
		
		
		public override function OnMouseDown(e:MouseEvent):void
		{
			super.OnMouseDown(e);
			
			if (subMode == "pick")
			{
				Lines_SelectLine(mxs, mys);
			}
			else if (subMode == "scaleline")
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_StartScale(mxs, mys);				
			}
			else if (subMode == "newline")
			{
				PhysEditor.UndoTakeSnapshot();
				addlineActive = true;
				currentPointIndex = -1;
				Lines_NewLine();
				Lines_AddPoint(mxs, mys);
				return;
			}
			else if (subMode == "dragpoint")
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_SelectPoint(mxs, mys);				
			}
			else if (subMode == "dragline")
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_SelectPoint(mxs, mys);				
			}
			else if (subMode == "selectpoint")
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_SelectPoint(mxs, mys);				
			}
			else if (subMode == "deleteline")
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_SelectLine(mxs, mys);
				Lines_DeleteSelectedLine();
			}
			else if (subMode == "deletepoint")
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_DeletePoint(mxs, mys);
			}
			else if (subMode == "insertpoint")
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_InsertPointAtMousePos(mxs, mys);
			}
			else if (subMode == "insertafter")
			{
				PhysEditor.UndoTakeSnapshot();
				Lines_InsertPoint(mxs, mys);				
			}
			else
			{
				if (addlineActive)
				{
					PhysEditor.UndoTakeSnapshot();
					Lines_AddPoint(mxs, mys);
				}
			}
		}
		
		public override function OnMouseUp(e:MouseEvent):void
		{
			super.OnMouseUp(e);
			
			if (subMode == "scaleline")
			{
				var scale:Number = 1 + ((mxs - scaleCentreX) * 0.001);
				Lines_Scale(scale);
			}
		}
		
		
		public override function OnMouseMove(e:MouseEvent):void
		{
			super.OnMouseMove(e);
			var l:Level = GetCurrentLevel();
			
			if (e.buttonDown == false) return;
			
			if (subMode == "dragpoint")
			{
				if (currentPointIndex != -1)
				{
					var p:Point = objLines[currentLineIndex].points[currentPointIndex];
					p.x = mxs;
					p.y = mys;
				}
			}
			if (subMode == "dragline")
			{
				if (currentPointIndex != -1)
				{
					var p:Point = objLines[currentLineIndex].points[currentPointIndex];
					var dx:Number = mxs - p.x;
					var dy:Number = mys - p.y;
					for each(var p:Point in objLines[currentLineIndex].points)
					{
						p.x += dx;
						p.y += dy;							
					}
				}
			}
			else if (subMode == "scaleline")
			{
				var scale:Number = 1 + ((mxs - scaleCentreX) * 0.001);
				Lines_Scale(scale);
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
			if (s == "pick")
			{
				PhysEditor.CursorText_Set("pick line");
			}
			if (s == "addpoint")
			{
				PhysEditor.CursorText_Set("add point");
			}
			if (s == "newline")
			{
				PhysEditor.CursorText_Set("new line");
			}
			if (s == "dragpoint")
			{
				PhysEditor.CursorText_Set("drag point");
			}
			if (s == "dragline")
			{
				PhysEditor.CursorText_Set("drag line");
			}
			if (s == "deleteline")
			{
				PhysEditor.CursorText_Set("delete line");
			}
			if (s == "deletepoint")
			{
				PhysEditor.CursorText_Set("delete point");
			}
			if (s == "insertpoint")
			{
				PhysEditor.CursorText_Set("insert on line");
			}
			if (s == "selectpoint")
			{
				PhysEditor.CursorText_Set("select point");
			}
			if (s == "scaleline")
			{
				PhysEditor.CursorText_Set("scale line");				
			}
			if (s == "insertafter")
			{
				PhysEditor.CursorText_Set("insert after selected");
			}
			
			
		}
		
		public override function Update():void
		{
			super.Update();
			
			
			if (KeyReader.Down(KeyReader.KEY_T))
			{
				SetSubMode("scaleline");
			}
			else if (KeyReader.Down(KeyReader.KEY_L))
			{
				SetSubMode("pick");
			}
			else if (KeyReader.Down(KeyReader.KEY_N))
			{
				SetSubMode("newline");
			}
			else if (KeyReader.Down(KeyReader.KEY_SHIFT))
			{
				SetSubMode("dragpoint");
			}
			else if (KeyReader.Down(KeyReader.KEY_CONTROL))
			{
				SetSubMode("dragline");
			}
			else if (KeyReader.Down(KeyReader.KEY_DELETE) || KeyReader.Down(KeyReader.KEY_SQUIGGLE))
			{
				SetSubMode("deleteline");
			}
			else if (KeyReader.Down(KeyReader.KEY_D))
			{
				SetSubMode("deletepoint");
			}
			else if (KeyReader.Down(KeyReader.KEY_S))
			{
				SetSubMode("insertpoint");
			}
			else if (KeyReader.Down(KeyReader.KEY_Q))
			{
				SetSubMode("selectpoint");
			}
			else if (KeyReader.Down(KeyReader.KEY_A))
			{
				SetSubMode("insertafter");
			}
			else 
			{
				if (addlineActive)
				{
					SetSubMode("addpoint");
				}
				else
				{
					SetSubMode("null");
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
			
			if (KeyReader.Pressed(KeyReader.KEY_1))
			{
				DecCurrentPiece();
			}					
			if (KeyReader.Pressed(KeyReader.KEY_2))
			{
				IncCurrentPiece();
			}				
			
			if (KeyReader.Pressed(KeyReader.KEY_P))
			{
				PrintOut();
			}				
			
			
		}
		
		function PrintOut()
		{
			var centre:Point = ObjCol_GetCentrePos();
			
			var point:Point = new Point();
			var s:String;
			var ss:String = "";
			
			//vertices="0,0, 55,0, 55,14, 0,14"
			
			if (objLines.length == 0) return;
			
			//for each(var line:PhysLine in objLines)
			var line:PhysLine = objLines[0];
			{
				var i:int;
				var j:int;
				
				var points:Array = line.points;
				
				var numPoints:int = points.length;
				var numPerLine:int = 100000;
				var numGroups:int = numPoints / numPerLine;
				var numRemainder:int = numPoints % numPerLine;
				var count:int = 0;
				
				
				for (i = 0; i < numGroups; i++)
				{
					var s1:String = 'vertices ="';
					for (j = 0; j < numPerLine; j++)
					{
						point = points[count++];
						s1 += int(point.x-centre.x) + "," + int(point.y-centre.y);
						if (j != numPerLine-1) s1 += ", ";
					}
					s1 += '"';
					s = s1;
					ss += s;	// + "\n";
					Utils.print(s);
				}
				if (numRemainder != 0)
				{
					var s1:String = 'vertices ="';
					for (j = 0; j < numRemainder; j++)
					{
						point = points[count++];
						s1 += int(point.x-centre.x) + "," + int(point.y-centre.y);
						if (j != numRemainder-1) s1 += ", ";
					}
					s1 += '"';
					s = s1;
					ss += s;	// + "\n";
					Utils.print(s);
					
				}
				
			}
				
			System.setClipboard(ss);

		}
		
		function DecCurrentPiece()
		{
			for each (var ob:Object in PhysEditor.currentPieceList)
			{
				ob.id--;
				if (ob.id < 0)
				{
					ob.id = Game.objectDefs.GetNum() - 1;
				}
			}
			GetObjectLines();
		}
	
		function IncCurrentPiece()
		{
			for each (var ob:Object in PhysEditor.currentPieceList)
			{
				ob.id++;
				if (ob.id > Game.objectDefs.GetNum() - 1) 
				{
					ob.id = 0;
				}
			}
			GetObjectLines();
		}
		
		
		function GetObjectLines()
		{
			objLines = new Array();
		}
		
		function PreviousPiece()
		{
			Utils.print("PreviousPiece not implemented yet");
		}
		function NextPiece()
		{
			Utils.print("NextPiece not implemented yet");
		}
		
		
		public override function Render(bd:BitmapData):void
		{
			super.Render(bd);
			bd.fillRect(Defs.screenRect, 0xff445566);
			RenderCurrentPiece(bd);
			Editor_RenderObjectCollisionLines(false);
			PhysEditor.Editor_RenderLineToCursor();
		}
		public override function RenderHud(x:int,y:int):int
		{
			var s:String;
			s = "I: Line ID: ";
			if (currentLineIndex != -1)
			{
				var line:PhysLine = GetCurrentLevel().lines[currentLineIndex];									
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
			s = "D: Delete Point";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "SHIFT Drag Point";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "CTRL Drag Line";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "N: New line";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "S: Insert Point On Line";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "Q: Select Point";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "A: Insert Point After";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "T: Scale Line (drag)";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "8: Change Type";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "R: Reverse Line Direction";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "[ and ]: Move to first / last point of selected line";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "ScrollPos: " + Math.round(PhysEditor.scrollX) + " " + Math.round(PhysEditor.scrollY);
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "CursorPos: " + int((MouseControl.x + PhysEditor.scrollX)-ObjCol_GetCentrePos().x) + " " + int((MouseControl.y + PhysEditor.scrollY)-ObjCol_GetCentrePos().y);
			y += PhysEditor.AddInfoText("a", x, y, s);
			
			if (currentLineIndex != -1)
			{
				var line:PhysLine = GetCurrentLevel().lines[currentLineIndex];				
				
			}
			return y;
		}

//-----------------------------------------------------------------------------------------------------

		
		var currentLineIndex:int;
		var currentPointIndex:int;

		
		function Lines_EnterID()
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			var line:PhysLine = objLines[currentLineIndex];
			PhysEditor.AddTextEntry(100,100, "line id ",line.id,  Lines_EnterID_Done);
		}
		function Lines_EnterID_Done(text:String)
		{
			var l:Level = GetCurrentLevel();
			var line:PhysLine = objLines[currentLineIndex];
			line.id = text;
		}
		
		
		function Lines_Reverse()
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			
			var pts:Array = objLines[currentLineIndex].points;
			
			var newpts:Array = pts.reverse();
			
			objLines[currentLineIndex].points = newpts;
			
		}
		function Lines_AddPoint(x:Number, y:Number)
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			var p:Point = new Point(x, y);
			var pts:Array = objLines[currentLineIndex].points;
			pts.push(p);
			objLines[currentLineIndex].points = pts;			
		}
		
		function Lines_InsertPointAtMousePos(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			if (currentLineIndex == -1) return;
			
			var numPoints = objLines[currentLineIndex].points.length;
			var a0:Array = objLines[currentLineIndex].points;
			
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
				var a0:Array = objLines[currentLineIndex ].points;
				
				if (currentPointIndex == a0.length - 1) return;
				
				var newPoint:Point = new Point(x, y);
				
				a0.splice(currentPointIndex+1, 0, newPoint);
				
//				objLines[currentPointIndex].points = a0;
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
			
			
			var a0:Array = objLines[selectedLineIndex].points;
			
			if (selectedPointIndex == a0.length - 1) return;
			var p0:Point = a0[selectedPointIndex].clone();
			var p1:Point = a0[selectedPointIndex + 1].clone();
			
			var newPoint:Point = new Point(x,y);
			
			a0.splice(selectedPointIndex+1, 0, newPoint);
			
			objLines[selectedLineIndex].points = a0;
			currentPointIndex++;
		}
		
		
		function Lines_DeleteSelectedLine()
		{
			var l:Level = GetCurrentLevel();
			if (currentLineIndex != -1)
			{
				
				var a2:Array = new Array();
				var index:int = 0;
				for each(var line:PhysLine in objLines)
				{
					if ( index != currentLineIndex)
					{
						a2.push(line.Clone());
					}
					index++;
				}
				objLines = a2;
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
			
			for each (var line:PhysLine in objLines)
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
				var a0:Array = objLines[selectedLineIndex].points;
				var a1:Array = new Array();
				var i:int;
				for (i = 0; i < a0.length; i++)
				{
					if (i != selectedPointIndex)
					{
						a1.push(a0[i].clone());
					}
				}
				objLines[selectedLineIndex].points = a1;
				
				var a2:Array = new Array();
				for each(var line:PhysLine in objLines)
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
				objLines = a2;
				currentPointIndex = -1;
			}
			
		}
		function Lines_ScrollToFirstPointOfSelectedLine()
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			var a:Array = objLines[currentLineIndex].points;
			var p:Point = a[0];
			PhysEditor.scrollX = p.x - (Defs.displayarea_w * 0.5);
			PhysEditor.scrollY = p.y - (Defs.displayarea_h * 0.5);
		}
		
		function Lines_ScrollToLastPointOfSelectedLine()
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			var a:Array = objLines[currentLineIndex].points;
			var p:Point = a[a.length - 1];
			PhysEditor.scrollX = p.x - (Defs.displayarea_w * 0.5);
			PhysEditor.scrollY = p.y - (Defs.displayarea_h * 0.5);
		}
		
		
		function Lines_NewLine()
		{
			
			var line:PhysLine = new PhysLine();
			line.type = newLineType;
			var l:Level = GetCurrentLevel();
			objLines.push(line);
			currentLineIndex = objLines.length - 1;
			Utils.print("New line " + currentLineIndex);
		}
		
		function Lines_SelectLine(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			var lineIndex:int = 0;
			currentLineIndex = -1;
			for each (var line:PhysLine in objLines)
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
			for each (var line:PhysLine in objLines)
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
		
		
		function Lines_MovePoints(x:Number, y:Number)
		{
			if (currentLineIndex == -1) return;
			var l:Level = GetCurrentLevel();
			var points:Array = objLines[currentLineIndex].points;
			
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
			
			for each (var line:PhysLine in objLines)
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
				var points:Array = objLines[selectedLineIndex].points;
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
				objLines[selectedLineIndex].points = ps;
			}
		}
		
		
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
				for each(var p:Point in objLines[currentLineIndex].points)
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
				for (var i:int = 0; i < objLines[currentLineIndex].points.length; i++ )					
				{
					var p:Point = scalePositions[i];						
					var x:Number = scaleCentreX + ((p.x - scaleCentreX) * scale);
					var y:Number = scaleCentreY + ((p.y - scaleCentreY) * scale);
					objLines[currentLineIndex].points[i] = new Point(x, y);						
				}
			}
		}
		
		function Lines_SelectPoint(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			var lineIndex:int = 0;
//			currentLineIndex = -1;
			currentPointIndex = -1;
			for each (var line:PhysLine in objLines)
			{
				var pointIndex:int = 0;
				for each(var p:Point in line.points)
				{
					if (Utils.DistBetweenPoints(p.x, p.y, x, y) < 3)
					{
						currentLineIndex = lineIndex;
						currentPointIndex = pointIndex;
						return;
					}
					pointIndex++;
				}
				lineIndex++;
			}
		}
		
		function Editor_RenderObjectCollisionLines(_useCursor:Boolean = false)
		{
//			if (editModeObj_Lines.addlineActive == false) _useCursor = false;
//			if (editModeObj_Lines.subMode != "addpoint") _useCursor = false;
			
			var p0:Point = new Point();
			var p1:Point = new Point();
			var r:Rectangle = new Rectangle();
			
			var l:Level = GetCurrentLevel();
			var bd:BitmapData = Game.main.screenBD;
			var lineIndex:int = 0;
			for each(var line:PhysLine in objLines)
			{
				var points:Array = line.points;
				if (lineIndex == currentLineIndex && _useCursor) 
				{
					var mx:int = MouseControl.x;
					var my:int = MouseControl.y;		
					points = new Array();
					for each(var p0:Point in line.points)
					{
						points.push(p0.clone());
					}
					points.push(new Point(mx+PhysEditor.scrollX, my+PhysEditor.scrollY));
				}
				
				var lineMode:int = 0;
				var doNormals:Boolean = false;
				if ( (lineMode & PhysEditor.LM_LINK) != 0) doNormals = true;
				var col:uint = 0xffffff;
				var thickness:int = 1;
				if (lineIndex == currentLineIndex) 
				{
//					col = 0xffffffff;
					thickness = 2;
				}
				if (points.length >= 2)
				{
					var i:int;
					for (i = 0; i < points.length - 1; i++)
					{
						p0 = points[i];
						p1 = points[i + 1];
						PhysEditor.RenderLine(p0.x - PhysEditor.scrollX, p0.y - PhysEditor.scrollY, p1.x - PhysEditor.scrollX, p1.y - PhysEditor.scrollY,col,thickness,1,doNormals);
					}
					if ( (lineMode & PhysEditor.LM_LINK) != 0)
					{
						p0 = points[points.length-1];
						p1 = points[0];
						PhysEditor.RenderLine(p0.x - PhysEditor.scrollX, p0.y - PhysEditor.scrollY, p1.x - PhysEditor.scrollX, p1.y - PhysEditor.scrollY,col,thickness,1,doNormals);
					}
				}
				if ( (lineMode & PhysEditor.LM_FILL) != 0)
				{
					PhysEditor.FillPoly(points, col, 0.1);
				}
				for (i = 0; i < points.length; i++)
				{
					col = 0xffff0000;
					if (lineIndex == currentLineIndex && currentPointIndex == i) col = 0xffffff00;
					var off1:int = 2;
					var off2:int = 4;
					if (lineIndex == PhysEditor.hoverLineIndex && PhysEditor.hoverPointIndex == i)
					{
						off1 = 3;
						off2 = 6;
					}
					
					
					r.x = points[i].x - off1 - PhysEditor.scrollX;
					r.y = points[i].y - off1 - PhysEditor.scrollY;
					r.width = off2;
					r.height = off2;
					PhysEditor.RenderRectangle(r, col);
				}
				lineIndex++;
			}			
		}
		
		
		function ObjCol_GetCentrePos():Point
		{
			
			var x:Number = Defs.displayarea_w / 2;
			var y:Number = Defs.displayarea_h / 2;
			return new Point(x, y);
			
		}
		
		public function RenderCurrentPiece(bd:BitmapData):void
		{
			var physObj:PhysObj;
			var cp:Point = ObjCol_GetCentrePos().clone();
			cp.x -= PhysEditor.scrollX;
			cp.y -= PhysEditor.scrollY;
			if ( PhysEditor.currentPieceList.length == 1)
			{
				bd.fillRect(Defs.screenRect, 0xff445566);
				var ob:Object = PhysEditor.currentPieceList[0];
				physObj = Game.objectDefs.GetByIndex(ob.id);
				
				
				
				PhysObj.RenderAt(physObj, cp.x, cp.y, 0, 1, bd, PhysEditor.linesScreen.graphics, false);	// objCol_ShowOtherCol);
				
			}
			
			Utils.RenderDotLine(bd, cp.x - 10, cp.y, cp.x + 10, cp.y, 100, 0xff0000);
			Utils.RenderDotLine(bd, cp.x, cp.y-10, cp.x, cp.y+10, 100, 0xff0000);
			
			
			/*
			var newbd:BitmapData = new BitmapData(400, 400, false, 0);
			
			var m:Matrix = new Matrix();
			m.scale(2, 2);
			m.translate( -200, -200);				
			newbd.draw(bd, m);
			
			m.identity();
			m.translate(400, 000);
			bd.draw(newbd, m);
			*/
		}
		
	}

}