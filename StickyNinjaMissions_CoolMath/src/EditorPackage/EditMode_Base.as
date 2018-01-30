package EditorPackage 
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditMode_Base
	{
		
		public function EditMode_Base() 
		{
			
		}
		
		public function InitOnce():void
		{
			editSubMode  = 0;
		}

		public function ExitMode():void
		{
			
		}
		public function EnterMode():void
		{
			PhysEditor.CursorText_Hide();
			PhysEditor.CursorText_Set("");
			editSubMode  = 0;
			rightButtonDown = false;
		}
		
		
		var rightButtonDown:Boolean;
		var editSubMode:int;
		var mx:int;
		var my:int;
		var sx:Number;
		var sy:Number;
		var mxs:int;
		var mys:int;

		var mxs_nogrid:int;
		var mys_nogrid:int;
		
		function GetMousePositions(e:MouseEvent)
		{
			PhysEditor.GetMousePositionsXY(e.stageX, e.stageY);
			mx = PhysEditor.mx;
			my = PhysEditor.my;
			mxs = PhysEditor.mxs;
			mys = PhysEditor.mys;
			sx = PhysEditor.sx;
			sy = PhysEditor.sy;
			mxs_nogrid = PhysEditor.mxs_nogrid;
			mys_nogrid = PhysEditor.mys_nogrid;
			return;
						
		}
		
		public function OnRightMouseDown(e:MouseEvent):void
		{
			rightButtonDown = true;			
			GetMousePositions(e);
		}
		public function OnRightMouseUp(e:MouseEvent):void
		{
			rightButtonDown = false;			
			GetMousePositions(e);
		}
		public function OnMouseDown(e:MouseEvent):void
		{
			GetMousePositions(e);
		}
		public function OnMouseUp(e:MouseEvent):void
		{
			GetMousePositions(e);
		}
		public function OnMouseMove(e:MouseEvent):void
		{
			GetMousePositions(e);
		}
		public function OnMouseWheel(delta:int):void
		{
			
		}
		public function Update():void
		{
//			GetMousePositions();
		}
		public function Render(bd:BitmapData):void
		{
//			GetMousePositions();
		}
		public function RenderHud(x:int,y:int):int
		{
			return y;
		}
		
		
		function GetCurrentLevel():Level
		{
			return PhysEditor.GetCurrentLevel();
		}
		function GetCurrentLevelJoints():Array
		{
			return PhysEditor.GetCurrentLevel().joints;
		}
		function GetCurrentLevelInstances():Array
		{
			return PhysEditor.GetCurrentLevelInstances();
		}
		function GetCurrentLevelLines():Array
		{
			return PhysEditor.GetCurrentLevelLines();
		}
		function SetCurrentLevelInstances(instances:Array):void
		{
			PhysEditor.SetCurrentLevelInstances(instances);
		}
		
	}

}