package  
{
	import EditorPackage.EdLine;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import nape.geom.Vec2;
	import nape.geom.Vec2List;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import TextPackage.TextRenderer;
	
	/**
	* ...
	* @author Default
	*/
	public class EngineDebug 
	{
		static var useTimers:Boolean = false;
		static var timerNames:Array;
		static var timerStartTimes:Array;
		static var timerTimes:Array;
		
		public static var mobileTest0:Boolean = false;		// backgrounds
		public static var mobileTest1:Boolean = false;
		public static var mobileTest2:Boolean = false;
		public static var mobileTest3:Boolean = false;
		public static var mobileTest4:Boolean = false;
		public static var mobileTest5:Boolean = false;
		public static var mobileTest6:Boolean = false;
		public static var mobileTest7:Boolean = false;
		public static var mobileTest8:Boolean = false;
		public static var mobileTest9:Boolean = false;
		public static var mobileTest10:Boolean = false;
		public static var mobileTest11:Boolean = false;
		public static var mobileTest12:Boolean = false;
		public static var mobileTest13:Boolean = false;
		public static var mobileTest14:Boolean = false;
		public static var mobileTest15:Boolean = false;
		
		public static var mobileTestInt0:int= 0;
		public static var mobileTestInt1:int= 0;
		public static var mobileTestInt2:int= 0;
		public static var mobileTestInt3:int= 0;
		public static var mobileTestInt4:int= 0;
		public static var mobileTestInt5:int= 0;
		public static var mobileTestInt6:int= 0;
		public static var mobileTestInt7:int= 0;
		
		public static var debugMode:int = 0;
		public function EngineDebug() 
		{
			
		}
		
		public static function InitOnce()
		{
			timerNames = new Array();
			timerStartTimes = new Array();
			timerTimes = new Array();
		}
		
		public static function IsSet(mask:int):Boolean
		{
			if ( (debugMode & mask) == 0) return false;
			return true;
		}

		static var immediateTime:int;
		public static function StartImmediateTimer()
		{
			if (useTimers == false) return;
			if (Game.usedebug == false) return;
			immediateTime = getTimer();
		}
		public static function StopImmediateTimer(s:String)
		{
			if (useTimers == false) return;
			if (Game.usedebug == false) return;
			var t:int = getTimer() - immediateTime;
			Utils.print("Immediate Timer: " + t + " - " + s);
		}
		
		public static function StartTimers()
		{
			if (useTimers == false) return;
			if (Game.usedebug == false) return;
			timerNames = new Array();
			timerTimes = new Array();
			timerStartTimes = new Array();
			StartTimer("total");
		}

		public static function StopTimers()
		{
			if (useTimers == false) return;
			if (Game.usedebug == false) return;
			EndTimer("total");
		}
		
		
		
		public static var timerStrings:Array = null;
		public static function GetTimerString(index:int):String
		{
			if (useTimers == false) return "";
			if (Game.usedebug == false) return "";
			if (timerStrings == null) return "";
			if ( index < 0) return "";
			if ( index >= timerStrings.length) return "";
			return timerStrings[index];
		}
		public static function CreateGetTimerStrings()
		{
			if (useTimers == false) return;
			if (Game.usedebug == false) return;
			timerStrings = new Array();
			for (var i:int = 0; i < 10; i++) timerStrings.push("");
			
			var totalTime:Number = timerTimes[0];
			var y:int = 100;
			var x:int = 10;
			var s:String;
			var i:int;
			for (i = 0; i < timerNames.length; i++)
			{
				var percent:Number = 100 / totalTime * timerTimes[i];
				s = timerNames[i] + " : " + timerTimes[i];
				timerStrings[i] = s;
			}
		}
		public static function RenderTimers(bd:BitmapData)
		{
			if (useTimers == false) return;
			if (Game.usedebug == false) return;
			if (PROJECT::useStage3D) return;
			if (bd == null) return;
			if (IsSet(2) == false) return;
			var totalTime:Number = timerTimes[0];
			var y:int = 100;
			var x:int = 10;
			var s:String;
			var i:int;
			for (i = 0; i < timerNames.length; i++)
			{
				var percent:Number = 100 / totalTime * timerTimes[i];
				s = "Timer " + timerNames[i] + " : " + timerTimes[i] + "   (" + int(percent).toString() + "%";
				TextRenderer.RenderAt(0,bd, x, y, s, 0, 1, TextRenderer.JUSTIFY_LEFT);
				y += 15;
			}
		}
		
		public static function StartTimer(name:String)
		{
			if (Game.usedebug == false) return;
			timerNames.push(name);
			timerStartTimes.push(getTimer());
			timerTimes.push(getTimer());
		}
		public static function EndTimer(name:String)
		{
			if (Game.usedebug == false) return;
			var i:int = 0;
			for each(var s:String in timerNames)
			{
				if (s == name)
				{
					timerTimes[i] = getTimer() - timerStartTimes[i];
				}
				i++;
			}
		}

//--------------------------------------------------------------------------------------------------------

		static function RenderNape(bd:BitmapData):void
		{
			if (IsSet(4) == false) return;
			var bodyList:BodyList = PhysicsBase.GetNapeSpace().bodies;
			
			var col_body:uint = 0xffff0000;
			var col_sensor:uint = 0xff00ff00;
			
			for (var i:int = 0; i < bodyList.length; i++) 
			{
				var b:Body = bodyList.at(i);
				
				for (var j:int = 0; j < b.shapes.length; j++)
				{
					
					
					var shape:Shape = b.shapes.at(j);
					
					var col:uint = col_body;
					if (shape.sensorEnabled)
					{
						col = col_sensor;
					}
					
					if (shape.isPolygon())
					{
						var poly:Polygon = shape.castPolygon;
						var v2list:Vec2List = poly.worldVerts;
						for (var k:int = 0; k < v2list.length-1; k++)
						{
							var v0:Vec2 = v2list.at(k);
							var v1:Vec2 = v2list.at(k+1);
							var x:Number = v0.x - Game.camera.x;
							var y:Number = v0.y - Game.camera.y;
							var x1:Number = v1.x - Game.camera.x;
							var y1:Number = v1.y - Game.camera.y;
							
							Utils.RenderDotLine(bd, x, y, x1, y1, 50, col);
						}
					}
					else if (shape.isCircle())
					{
						var c:Circle = shape.castCircle;
						var v0:Vec2 = c.worldCOM;
						var x:Number = v0.x - Game.camera.x;
						var y:Number = v0.y - Game.camera.y;
						Utils.RenderCircle(bd, x, y, c.radius, col);
						
					}
				}
					
			}
		}
		static function RenderLines(bd:BitmapData):void
		{
			if (bd == null) return;
			if (IsSet(1) == false) return;
			var sx:Number = Game.camera.x;
			var sy:Number = Game.camera.y;
			
			var lev:Level = Levels.GetCurrent();
			for each(var line:EdLine in lev.lines)
			{
				var i:int;
				var count:int = line.points.length;
				for (i = 0; i < count - 1; i++)
				{
					var x0:Number = line.points[i+0].x - sx;
					var y0:Number = line.points[i+0].y - sy;
					var x1:Number = line.points[i+1].x - sx;
					var y1:Number = line.points[i+1].y - sy;
					
					//if (line.type == 1)
					{
						Utils.RenderDotLine(bd, x0, y0, x1, y1, 1000, 0xffffff00);
						//GraphicObjects.RenderStringAt(bd, GraphicObjects.gfx_font1, x0, y0, i.toString());
					}
					//if (line.type == 2)
					//{
					//	Utils.RenderDotLine(bd, x0, y0, x1, y1, 1000, 0xffff00ff);
					//}
				}
				
				
			}
			
			
		}

		
	}
	
}