package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	/**
	 * ...
	 * @author 
	 */
	public class CustomCursor 
	{
		
		public function CustomCursor() 
		{
			
		}
		
		public static function Use(b:Boolean)
		{
			return;
			if (PROJECT::useStage3D)
			{
				return;
			}
			if (b)
			{
				Mouse.cursor = "pointer";	
			}
			else
			{
				Mouse.cursor = "null";
			}
			
		}
		public static function InitOnce()
		{
			return;
			if (PROJECT::useStage3D)
			{
				return;
			}
			var cursorData:MouseCursorData;

			var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName("Cursor_Pointer");
			cursorData = new MouseCursorData();
			cursorData.hotSpot = new Point(5,2);
			var bitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>(dobj.GetNumFrames(), true);
			for (var i:int = 0; i < dobj.GetNumFrames(); i++)
			{
				bitmapDatas[i] = dobj.GetBitmapData(i);
			}
			cursorData.data = bitmapDatas;
			cursorData.frameRate = 30;
			Mouse.registerCursor("pointer", cursorData);
			
			var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName("Cursor_CanPress");
			cursorData = new MouseCursorData();
			cursorData.hotSpot = new Point(7,2);
			var bitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>(dobj.GetNumFrames(), true);
			for (var i:int = 0; i < dobj.GetNumFrames(); i++)
			{
				bitmapDatas[i] = dobj.GetBitmapData(i);
			}
			cursorData.data = bitmapDatas;
			cursorData.frameRate = 30;
			Mouse.registerCursor("canpress", cursorData);
			
			var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName("Cursor_Pointer_CantPress");
			cursorData = new MouseCursorData();
			cursorData.hotSpot = new Point(5,2);
			var bitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>(dobj.GetNumFrames(), true);
			for (var i:int = 0; i < dobj.GetNumFrames(); i++)
			{
				bitmapDatas[i] = dobj.GetBitmapData(i);
			}
			cursorData.data = bitmapDatas;
			cursorData.frameRate = 30;
			Mouse.registerCursor("cantpress", cursorData);
			
		}
		
//					SetCustomCursor();
//Mouse.cursor = "canpress";

	}

}