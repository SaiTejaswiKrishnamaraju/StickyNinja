package EditorPackage 
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditMode_Map extends EditMode_Base
	{
		var mapper_transparency:int = 5;
		var mapper_currentCell:int = 1;
		var mapper_brushType:int = 0;
		var brushes:Array;
		var mapCols:Array;
		var mapColNames:Array;
		
		public function EditMode_Map() 
		{
			
		}
		public override function InitOnce():void
		{
			mapCols = new Array();
			mapColNames = new Array();
			mapCols.push(0);
			
			mapColNames.push("blank");
			mapCols.push(0xffff00);
			mapColNames.push("rough01");
			mapCols.push(0xff00ff);
			mapColNames.push("water");
			mapCols.push(0x00ffff);
			mapColNames.push("cliff");
			mapCols.push(0x0000ff);
			mapColNames.push("undefined");
			mapCols.push(0xffff00);
			mapColNames.push("undefined");
			mapCols.push(0xff00ff);
			mapColNames.push("undefined");
			mapCols.push(0xffffff);
			mapColNames.push("undefined");
			mapCols.push(0xff0000);
			mapColNames.push("undefined");
			
			var brush:Array;
			brushes = new Array();

			brush = new Array();
			brush.push(new Point(0, 0));
			brushes.push(brush);
			
			brush = new Array();
			brush.push(new Point(0, 0));
			brush.push(new Point(1, 0));
			brush.push(new Point(0, 1));
			brush.push(new Point(1, 1));
			brushes.push(brush);
			
			brush = new Array();
			brush.push(new Point(0, 0));
			brush.push(new Point(-1, 0));
			brush.push(new Point(1, 0));
			brush.push(new Point(0, 1));
			brush.push(new Point(0, -1));
			brushes.push(brush);

			brush = new Array();
			brush.push(new Point(-1, 0));
			brush.push(new Point(0, 0));
			brush.push(new Point(1, 0));
			brush.push(new Point(-1, 1));
			brush.push(new Point(0, 1));
			brush.push(new Point(1, 1));
			brush.push(new Point(-1, -1));
			brush.push(new Point(0, -1));
			brush.push(new Point(1, -1));
			brushes.push(brush);
			
			mapper_currentCell = 1;
			mapper_brushType = 0;
			
			mapper_transparency = 2;
			
		}
		public override function OnMouseDown(e:MouseEvent):void
		{
			super.OnMouseDown(e);
			Mapper_PlotCell(mapper_currentCell);
			
		}
		public override function OnMouseUp(e:MouseEvent):void
		{
			
		}
		public override function OnMouseMove(e:MouseEvent):void
		{
			
		}
		public override function OnMouseWheel(delta:int):void
		{
			if (delta > 0) Mapper_IncCurrentCell();
			if (delta < 0) Mapper_DecCurrentCell();		
		}
		public override function Update():void
		{
			super.Update();
			if (KeyReader.Down(KeyReader.KEY_1) == true)
			{
				Mapper_PlotCell(0);
			}
			if (KeyReader.Pressed(KeyReader.KEY_2) == true)
			{
				Mapper_DecCurrentCell();
			}
			if (KeyReader.Pressed(KeyReader.KEY_3) == true)
			{
				Mapper_IncCurrentCell();
			}
			if (KeyReader.Pressed(KeyReader.KEY_4) == true)
			{
				Mapper_Fill(mapper_currentCell);
			}
			if (KeyReader.Pressed(KeyReader.KEY_5) == true)
			{
				Mapper_CycleBrush();
			}
			if (KeyReader.Pressed(KeyReader.KEY_6) == true)
			{
				Mapper_CycleTransparency();
			}
			
		}
		public override function Render(bd:BitmapData):void
		{
			super.Render(bd);
			
			bd.fillRect(Defs.screenRect, 0xff445566);
			PhysEditor.RenderBackground(bd);			
			PhysEditor.Editor_RenderObjects();
			PhysEditor.Editor_RenderMiniMap();
			PhysEditor.Editor_RenderLines1();
			Mapper_RenderMap();
			Mapper_RenderCursor();
			
		}
		public override function RenderHud(x:int,y:int):int
		{
			var s:String;
			var l:Level = GetCurrentLevel();
			s = "ScrollPos: " + Math.round(PhysEditor.scrollX) + " " + Math.round(PhysEditor.scrollY);
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "CursorPos: " + int(MouseControl.x + PhysEditor.scrollX) + " " + int(MouseControl.y + PhysEditor.scrollY);
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "Offset / Size: " + l.mapMinX + "," + l.mapMinY + "   " + ((l.mapMaxX - l.mapMinX) + 1) + "," + ((l.mapMaxY - l.mapMinY) + 1);
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "1: Erase cell(s)";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "2/3: Current Piece: " + int(mapper_currentCell+1) + " / "+mapCols.length+"  ("+mapColNames[mapper_currentCell]+")   ";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "4: Fill ";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "5: Brush: " + int(mapper_brushType + 1) +" / " + brushes.length;
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "6: Display : " + mapper_transparency +" / 5";
			y += PhysEditor.AddInfoText("a", x, y, s);
			return y;
		}

		
		
//-------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------


		function mapper_ExpandMap(mx:int, my:int)
		{
			var newMap:Array;
			var l:Level = GetCurrentLevel();
			
			
			var newMinX:int = l.mapMinX;
			var newMaxX:int = l.mapMaxX;
			var newMinY:int = l.mapMinY;
			var newMaxY:int = l.mapMaxY;
			
			var offsetX:int = 0;
			var offsetY:int = 0;
			
			if (mx < l.mapMinX)
			{
				newMinX = mx;
			}
			if (my < l.mapMinY)
			{
				newMinY = my;
			}
			
			if (mx > l.mapMaxX)
			{
				newMaxX = mx;
			}
			if (my > l.mapMaxY)
			{
				newMaxY = my;
			}
			
			offsetX = newMinX - l.mapMinX;
			offsetY = newMinY - l.mapMinY;

//			Utils.trace("expanding mapper " + l.mapMinX + "," + l.mapMinY + " " + l.mapMaxX + "," + l.mapMaxY);
//			Utils.trace("to cell " + mx + "  " + my);
//			Utils.trace("with offset " + offsetX + "  " + offsetY);
			
			var i:int;
			
			var newW:int = (newMaxX - newMinX) + 1;
			var newH:int = (newMaxY - newMinY) + 1;
			var oldW:int = (l.mapMaxX - l.mapMinX) + 1;
			var oldH:int = (l.mapMaxY - l.mapMinY) + 1;
			
			newMap = new Array(newW * newH);
			for (i = 0; i < newW * newH; i++)
			{
				newMap[i] = 0;
			}
			
			
			var y:int;
			var x:int;
			for (y = 0; y < oldH; y++)
			{
				for (x = 0; x < oldW; x++)
				{
					var c:int = l.map[x + (y * oldW)];
					newMap[x - offsetX + ( (y - offsetY) * newW)] = c;
				}				
			}
			
			
			l.mapMinX = newMinX;
			l.mapMaxX = newMaxX;
			l.mapMinY = newMinY;
			l.mapMaxY = newMaxY;
			l.map = newMap;
//			Utils.trace("to " + l.mapMinX + "," + l.mapMinY + " " + l.mapMaxX + "," + l.mapMaxY);
			
		}
		
		
		function Mapper_IncCurrentCell()
		{
			mapper_currentCell++;
			if (mapper_currentCell >= mapCols.length) mapper_currentCell = 0;
		}
		function Mapper_CycleTransparency()
		{
			mapper_transparency++;
			if (mapper_transparency >= 6) mapper_transparency = 0;
		}
		function Mapper_CycleBrush()
		{
			mapper_brushType++;
			if (mapper_brushType >= brushes.length) mapper_brushType = 0;
			
		}
		function Mapper_DecCurrentCell()
		{
			mapper_currentCell--;
			if (mapper_currentCell <0) mapper_currentCell = mapCols.length-1;
		}

		
		var fillList:Array;
		var fillList1:Array;
		
		var fillOrigCell:int;
		
		function Mapper_Fill(cellID:int)
		{
			var l:Level = GetCurrentLevel();
			var mx:int = MouseControl.x;
			var my:int = MouseControl.y;
			mx += PhysEditor.scrollX;
			my += PhysEditor.scrollY;
			mx /= l.mapCellW;
			my /= l.mapCellH;
			
			fillList = new Array();
			
			fillOrigCell = Mapper_GetCell(mx, my);
			
			Mapper_PutCell(mx, my, cellID);
			Mapper_PutFillCell(mx-1, my, cellID,fillList);
			Mapper_PutFillCell(mx+1, my, cellID,fillList);
			Mapper_PutFillCell(mx, my-1, cellID,fillList);
			Mapper_PutFillCell(mx, my + 1, cellID, fillList);
			
			var done:Boolean = false;
			
			do
			{
				fillList1 = new Array();
				for each(var o:Object in fillList)
				{
					Mapper_PutFillCell(o.x-1, o.y, cellID,fillList1);
					Mapper_PutFillCell(o.x+1, o.y, cellID,fillList1);
					Mapper_PutFillCell(o.x, o.y-1, cellID,fillList1);
					Mapper_PutFillCell(o.x, o.y + 1, cellID, fillList1);
					
				}
				if (fillList1.length != 0)
				{
					fillList = fillList1;
				}
				else
				{
					done = true;
				}
			}while (done == false);
			
			
/*
			var x:int;
			var y:int;
			var doit:Boolean;
			
			doit = true;
			x = mx;
			y = my;
			do
			{
				Mapper_PutCell(x, y, cellID);
				x--;
				if (x < l.mapMinX)
				{
					doit = false;
				}
				else if (Mapper_GetCell(x, y) != 0) doit = false;
			}while (doit == true);
			
			doit = true;
			x = mx;
			y = my;
			do
			{
				Mapper_PutCell(x, y, cellID);
				x++;
				if (x > l.mapMaxX)
				{
					doit = false;
				}
				else if (Mapper_GetCell(x, y) != 0) doit = false;
			}while (doit == true);
			*/
		}
		
		function Mapper_PutFillCell(mx:int,my:int,cellID:int,fl:Array)
		{
//			Utils.trace("trying cell " + mx + "," + my );
			var l:Level = GetCurrentLevel();
			if (mx < l.mapMinX) return;
			if (my < l.mapMinY) return;
			if (mx > l.mapMaxX) return;
			if (my > l.mapMaxY) return;
	//		Utils.trace("in bounds");
			
			var oldW:int = (l.mapMaxX - l.mapMinX) + 1;			
			mx -= l.mapMinX;
			my -= l.mapMinY;			
			var cell:int = l.map[mx + (my * oldW)];
			
//			Utils.trace("cell contains "+cell);
			
			if (cell != fillOrigCell) return;
			
			l.map[mx + (my * oldW)] = cellID;
			
			mx += l.mapMinX;
			my += l.mapMinY;			
			
			
			var o:Object = new Object();
			o.x = mx;
			o.y = my;
			fl.push(o);
//			Utils.trace("added cell at " + mx + "," + my);
		}
		
		function Mapper_GetCell(mx:int, my:int):int
		{
			var l:Level = GetCurrentLevel();
			var oldW:int = (l.mapMaxX - l.mapMinX) + 1;			
			mx -= l.mapMinX;
			my -= l.mapMinY;			
			return l.map[mx + (my * oldW)];	
		}
		function Mapper_PutCell(mx:int,my:int,cellID:int)
		{
			var l:Level = GetCurrentLevel();
			var oldW:int = (l.mapMaxX - l.mapMinX) + 1;			
			mx -= l.mapMinX;
			my -= l.mapMinY;			
			l.map[mx + (my * oldW)] = cellID;
			
		}
		
		
		
		function Mapper_PlotCell(cellID:int)
		{
			var brush:Array = brushes[mapper_brushType];
			
			var l:Level = GetCurrentLevel();

			for each(var p:Point in brush)
			{
			
				var mx:int = MouseControl.x;
				var my:int = MouseControl.y;
				mx += PhysEditor.scrollX;
				my += PhysEditor.scrollY;
				mx /= l.mapCellW;
				my /= l.mapCellH;

				mx += p.x;
				my += p.y;
				
				if (mx < l.mapMinX || mx > l.mapMaxX || my < l.mapMinY || my > l.mapMaxY)
				{
					mapper_ExpandMap(mx, my);
				}
				
				var oldW:int = (l.mapMaxX - l.mapMinX) + 1;
				
				mx -= l.mapMinX;
				my -= l.mapMinY;
				
				
				l.map[mx + (my * oldW)] = cellID;
			}

		}

		function Mapper_RenderMap()
		{
			if (mapper_transparency == 0) return;
			var trans:Number = Utils.ScaleTo(0, 1, 0, 5, mapper_transparency);
			
			var l:Level = GetCurrentLevel();
			var cy:int;
			var cx:int;
			
			var r:Rectangle = new Rectangle(0, 0, l.mapCellW - 1, l.mapCellH - 1);
			
			var oldW:int = (l.mapMaxX - l.mapMinX) + 1;
			var oldH:int = (l.mapMaxY - l.mapMinY) + 1;
			
			
			for (cy = 0; cy < oldH; cy++)
			{
				for (cx = 0; cx < oldW; cx++)
				{
					var c:int = l.map[ (cy * oldW) + cx];
					if (c != 0)
					{
						r.x = ((cx+l.mapMinX) * l.mapCellW) - PhysEditor.scrollX;
						r.y = ( (cy + l.mapMinY) * l.mapCellH) - PhysEditor.scrollY;
						
						
						PhysEditor.FillRectangle(r, mapCols[c], 0,trans);
					}
				}
				
			}
			
		}


		function Mapper_RenderCursor()
		{
			var l:Level = GetCurrentLevel();
			var brush:Array = brushes[mapper_brushType];
			
			for each(var p:Point in brush)
			{
			
			
				var mx:int = MouseControl.x;
				var my:int = MouseControl.y;
				
				mx += PhysEditor.scrollX;
				my += PhysEditor.scrollY;

				mx /= l.mapCellW;
				my /= l.mapCellH;
				mx += p.x;
				my += p.y;
				mx *= l.mapCellW;
				my *= l.mapCellH;
				
				mx -= PhysEditor.scrollX;
				my -= PhysEditor.scrollY;
				
				
				PhysEditor.RenderRectangle(new Rectangle(mx, my, l.mapCellW - 1, l.mapCellH - 1), 0xffff8080, 2);
			}
			
		}
		
		
	}

}