package EditorPackage 
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditMode_PickLineForLink extends EditMode_Base
	{
		
		public var pickedLine:EdLine;
		public var returnFunction:Function;
		var hoveredLine:EdLine;
		
		public function EditMode_PickLineForLink () 
		{
			
		}
		public override function EnterMode():void
		{
			PhysEditor.CursorText_Show();
			hoveredLine = null;
		}
		public override function InitOnce():void
		{
			
		}
		public override function OnMouseDown(e:MouseEvent):void
		{
			pickedLine = null;
			super.OnMouseDown(e);
			PhysEditor.editModeObj_Lines.currentLineIndex = -1;
			
			var line:EdLine = PhysEditor.HitTestLineArea(mxs, mys);
			
			pickedLine = line;
			returnFunction(pickedLine);
			
		}
		public override function OnMouseUp(e:MouseEvent):void
		{
			
		}
		public override function OnMouseMove(e:MouseEvent):void
		{
			super.OnMouseMove(e);
			hoveredLine = null;
			hoveredLine = PhysEditor.HitTestLineArea(mxs, mys);
			
		}
		public override function OnMouseWheel(delta:int):void
		{
			
		}
		public override function Update():void
		{
			
		}
		public override function Render(bd:BitmapData):void
		{
			bd.fillRect(Defs.screenRect, 0xff334455);
			PhysEditor.RenderBackground(bd);
			PhysEditor.Editor_RenderObjects();
			PhysEditor.Editor_RenderPickedObjectsHilight();
			PhysEditor.Editor_RenderMiniMap();
			PhysEditor.Editor_RenderLines1();
			PhysEditor.HighlightLinePoly(hoveredLine);

		}
		public override function RenderHud(x:int,y:int):int
		{
			return y;
		}
		
	}

}