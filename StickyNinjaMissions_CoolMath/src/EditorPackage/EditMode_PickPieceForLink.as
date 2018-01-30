package EditorPackage 
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditMode_PickPieceForLink extends EditMode_Base
	{
		public var pickedObject:EdObj;
		public var returnFunction:Function;
		public var hoveredObj:EdObj;
		
		public function EditMode_PickPieceForLink() 
		{
			
		}
		public override function EnterMode():void
		{
			PhysEditor.CursorText_Show();
			pickedObject = null;
			hoveredObj = null;
		}
		public override function InitOnce():void
		{
			hoveredObj = null;

		}
		public override function OnMouseDown(e:MouseEvent):void
		{
			super.OnMouseDown(e);
			pickedObject = null;
			var poi:EdObj = PhysEditor.HitTestPhysObjGraphics(mx, my,false);
			pickedObject = poi;
			returnFunction(pickedObject);
		}
		public override function OnMouseUp(e:MouseEvent):void
		{
			
		}
		public override function OnMouseMove(e:MouseEvent):void
		{
			super.OnMouseMove(e);
			hoveredObj = PhysEditor.HitTestPhysObjGraphics(mx, my, false)
			
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
			if (hoveredObj != null)
			{
				hoveredObj.RenderHighlighted(EditableObjectBase.HIGHLIGHT_HOVER);
				
			}
		}
		public override function RenderHud(x:int,y:int):int
		{
			var s:String;
			s = "Pick an Object";
			y += PhysEditor.AddInfoText("a", x, y, s);
			return y;
		}
		
	}

}