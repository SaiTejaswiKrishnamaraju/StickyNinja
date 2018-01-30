package  
{
	import EditorPackage.EditMode_ObjCol;
	import EditorPackage.EdLine;
	import EditorPackage.EdObj;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class LevelBase
	{
		public var id:String;
		public var name:String;
		public var displayName:String;
		public var description:String;
		public var category:int;
		public var bgFrame:int;
		public var music:int;
		public var instances:Array;
		public var joints:Array;
		public var helpscreenFrames:Array;
		public var lines:Array;
		
		public var fillFrame:int;
		public var surfaceFrame:uint;
		public var surfaceThickness:int;
		
		public var owned:Boolean;
		
		public var completionLevel:int;
		
		public var played:Boolean;
		public var newlyAvailable:Boolean;
		public var beenPlayed:Boolean;
		public var markedAsJustUnlocked:Boolean;
		public var available:Boolean;
		public var complete:Boolean;
		public var numRockets:int;
		
		public var exclusiveChar:int;
		public var eventType:String;
		public var eventOpponentsString:String;
		public var eventWinParam:Number;
		
		public var endLightColor:int;
		
		public var cost:int;
		public var locked:Boolean;
		
		public var bestShots:int;
		public var bestScore:int;
		public var levelScore:int;
		
		public var percentage:Number;
		public var bestPercentage:Number;
		public var rating:int;
		public var lastTime:int;
		public var lastPlace:int;
		public var lastTimeTotal:int;
		public var bestPlace:int;
		public var bestTime:int;
		public var bestTimeTotal:int;
		public var goldTime:int;
		public var silverTime:int
		
		public var aiCarMaxSpeed:Number;
		public var aiCarMinSpeed:Number;
		public var raceType:String;
		public var aiCarTypeString:String;
		public var levelFunctionName:String;
		
		public var map:Array;
		public var mapCellW:int;
		public var mapCellH:int;
		public var mapMinX:int;
		public var mapMinY:int;
		public var mapMaxX:int;
		public var mapMaxY:int;
		
		public var fullyLoaded:Boolean;
		public var creator:String;
		public var gotBonus:Boolean;
		
		public function LevelBase() 
		{
			beenPlayed = false;
			locked = false;
			name = "";
			displayName = "";
			description = "";
			instances = new Array();
			joints = new Array();
			helpscreenFrames = new Array();
			lines = new Array();
			joints = new Array();
			music = 0;
			category = 0;
			fillFrame = 1;
			surfaceFrame = 5;
			surfaceThickness = 10;
			newlyAvailable = false;
			markedAsJustUnlocked = false;
			available = false;
			complete = false;
			eventType = "none";
			eventOpponentsString = "";
			eventWinParam = 1;
			exclusiveChar = 1;
			lastPlace = 9999999;
			lastTime = 9999999;
			lastTimeTotal = 9999999;
			bestTime = 99999999;
			bestTimeTotal = 9999999;
			goldTime = 10 * Defs.fps;
			silverTime = 20 * Defs.fps;
			played = false;
			numRockets = 0;
			bestPlace = 99999;
			bestScore = 0;
			bestShots = 99999;
			percentage = 0;
			bestPercentage = 0;
			creator = "";
			gotBonus = false;
			completionLevel = 0;

			var i:int;
			map = new Array();
			mapCellW = 16;
			mapCellH = 16;
			mapMinX = 0;
			mapMaxX = 0;
			mapMinY = 0;
			mapMaxY = 0;
			
			levelFunctionName = "";
			rating = 0;
			endLightColor = 0;
			
			cost = 500;
			owned = true;
			
			
			fullyLoaded = false;
		}
		public function Calculate()
		{
		}		
		
		public function GetLineByMaterial(matName:String):EdLine
		{
			for each(var l:EdLine in lines)
			{
				if (l.GetCurrentPolyMaterial().name == matName)
				{
					return l;
				}
			}
			return null;
		}
		public function GetLineByName(name:String):EdLine
		{
			for each(var l:EdLine in lines)
			{
				if (l.id == name) return l;
			}
			return null;
		}
		public function GetLineByIndex(index:int):EdLine
		{
			if (index < 0) return null;
			if (index >= lines.length) return null;
			return lines[index];
		}
		
		public function GetObjectByType(typeName:String):EdObj
		{
			for each(var eo:EdObj in instances)
			{
				if (eo.typeName == typeName)
				{
					return eo;
				}
			}
			return null;
		}
		
	}

}