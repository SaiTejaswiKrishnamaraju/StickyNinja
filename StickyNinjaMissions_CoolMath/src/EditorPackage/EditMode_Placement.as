package EditorPackage 
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditMode_Placement extends EditMode_Base
	{
		
		public function EditMode_Placement() 
		{
			
		}
		public override function EnterMode():void
		{
		}
		public override function InitOnce():void
		{
			
		}
		public override function OnMouseDown(e:MouseEvent):void
		{
			super.OnMouseDown(e);
			
			PhysEditor.UndoTakeSnapshot();
			
			var level_instances:Array = PhysEditor.GetCurrentLevelInstances();
			
			var posx:Number = mxs;
			var posy:Number = mys;
			var physObj:PhysObj;
			
			for each (var ob:Object in PhysEditor.currentPieceList)
			{
				physObj = Game.objectDefs.GetByIndex(ob.id);
				var pieceName:String = physObj.name;

				if (KeyReader.Down(KeyReader.KEY_1))
				{
					var ppp:Point = PhysEditor.SnapToObjects(mxs, mys);
					if (ppp != null)
					{
						Utils.print("snapped to point :" + mxs + " " + mys + "   ->   " + ppp.x + " " + ppp.y);
						posx = ppp.x;
						posy = ppp.y;
					}
				}
				
				var pi:EdObj = Levels.CreateLevelObjInstanceAt(pieceName, posx + ob.xoff, posy + ob.yoff, ob.rot, ob.scale,"",ob.initParams);
				
				var physobj:PhysObj = Game.objectDefs.FindByName(pieceName);
				if (physobj != null)
				{
					pi.objParameters.ClearAll();
					for (var i:int = 0; i < physObj.instanceParams.length; i++)
					{
						pi.objParameters.AddOrSet(physObj.instanceParams[i], physObj.instanceParamsDefaults[i]);
					}
				}
				
				level_instances.push(pi);
				PhysEditor.SetCurrentLevelInstances(level_instances);
			}
			
		}
		public override function OnMouseUp(e:MouseEvent):void
		{
			
		}
		public override function OnMouseMove(e:MouseEvent):void
		{
			
		}
		public override function OnMouseWheel(delta:int):void
		{
			if (KeyReader.Down(KeyReader.KEY_SHIFT) )
			{
				var rv:Number = 1;
				if (KeyReader.Down(KeyReader.KEY_CONTROL) == false)
				{
					rv *= 10;
				}
				var rotvel = 0;
				if (delta > 0) rotvel = rv;
				if (delta < 0) rotvel = -rv;
				
				PhysEditor.UndoTakeSnapshot();
				CurrenPiece_AddRot(rotvel);
			}
			else if (KeyReader.Down(KeyReader.KEY_CONTROL) )
			{
				var rv:Number = 0.1;
				var rotvel = 0;
				if (delta > 0) rotvel = rv;
				if (delta < 0) rotvel = -rv;
				
				PhysEditor.UndoTakeSnapshot();
				CurrenPiece_AddScale(rotvel);
			}
			else
			{
				if (delta > 0) IncCurrentPiece();
				if (delta < 0) DecCurrentPiece();
			}
			
		}
		public override function Update():void
		{
			if (KeyReader.Down(KeyReader.KEY_P) == true)	// pick a piece
			{
				var poi:EdObj = PhysEditor.HitTestPhysObjGraphics(mx, my);
				if (poi)
				{
					PhysEditor.ClearCurrentPieces();
					PhysEditor.AddCurrentPiece( Game.objectDefs.FindIndexByName(poi.typeName), 0, 0, 0,poi.x,poi.y,poi.objParameters.ToString());
				}				
			}
			
			
			if (KeyReader.Down(KeyReader.KEY_SHIFT) == true)
			{
				if (KeyReader.Pressed(KeyReader.KEY_UP))
				{
					PhysEditor.UndoTakeSnapshot();
					IncCurrentPiece();
				}
				if (KeyReader.Pressed(KeyReader.KEY_DOWN))
				{
					PhysEditor.UndoTakeSnapshot();
					DecCurrentPiece();
				}

				var rv:Number = 1;
				if (KeyReader.Down(KeyReader.KEY_CONTROL) == false)
				{
					rv *= 10;
				}
				if (KeyReader.Down(KeyReader.KEY_LEFT))
				{
					PhysEditor.UndoTakeSnapshot();
					CurrenPiece_AddRot( -rv);
					
				}
				if (KeyReader.Down(KeyReader.KEY_RIGHT))
				{
					PhysEditor.UndoTakeSnapshot();
					CurrenPiece_AddRot( rv);
					
				}
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
			
			var physObj:PhysObj;
			
			for each(var ob:Object in PhysEditor.currentPieceList)
			{
				physObj = Game.objectDefs.GetByIndex(ob.id);
				var p:Point = PhysEditor.GetMapPos(mxs+ob.xoff,mys+ob.yoff);
				PhysObj.RenderAt(physObj, p.x,p.y, ob.rot,ob.scale*PhysEditor.zoom,bd,PhysEditor.linesScreen.graphics,true);
			}
			
		}
		public override function RenderHud(x:int,y:int):int
		{
			var s:String = "";
			for each(var ob:Object in PhysEditor.currentPieceList)
			{
				var physObj:PhysObj = Game.objectDefs.GetByIndex(ob.id);
				s += physObj.name + " ";					
			}
			y += PhysEditor.AddInfoText("a", x, y, s);
			
			s = "ScrollPos: " + Math.round(PhysEditor.scrollX) + " " + Math.round(PhysEditor.scrollY);
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "CursorPos: " + int(MouseControl.x + PhysEditor.scrollX) + " " + int(MouseControl.y + PhysEditor.scrollY);
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "P: Pick a piece";
			y += PhysEditor.AddInfoText("a", x, y, s);
			return y;
		}
		
//---------------------------------------------------------------------------------------------------

		function CurrenPiece_AddScale(rv:Number)
		{
			for each (var ob:Object in PhysEditor.currentPieceList)
			{
				ob.scale += Number(rv);
			}			
		}
		function CurrenPiece_AddRot(rv:Number)
		{
			for each (var ob:Object in PhysEditor.currentPieceList)
			{
				ob.rot += Number(rv);
			}
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
		}

		
	}

}