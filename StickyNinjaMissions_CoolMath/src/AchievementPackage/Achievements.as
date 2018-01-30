package AchievementPackage
{
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Achievements 
	{
		
		[Embed(source = "../../bin/Achievements.xml", mimeType = "application/octet-stream")] 
        static var class_embedded_XML:Class; 
		
		static var xml:XML;
		
		public static var list:Vector.<Achievement>;
		public static var unlockedList:Vector.<Achievement>;
		public static var testFunctions:AchievementTestFunctions;
		static var displayQueue:AchievementDisplayQueue;
		static var currentAch:Achievement;
		
		
		static function LoadXml()
		{
			var x:XML = xml;
			var numAch:int = x.achievement.length();
			for (var i:int = 0; i < numAch; i++)
			{
				var ax:XML = x.achievement[i];
				var ach:Achievement = new Achievement();
				ach.index = i;
				ach.specificLevelName = XmlHelper.GetAttrString(ax.@specificlevel,"1-01");
				ach.specificsString = XmlHelper.GetAttrString(ax.@specifics, "");
				
				ach.specificCharIndex = -1;
				ach.specificBikeIndex = -1;
				
				ach.specificsList = new Array();
				ach.specificsList = ach.specificsString.split(",");
				
				ach.name = XmlHelper.GetAttrString(ax.@name,"undefined");
				ach.description = XmlHelper.GetAttrString(ax.@desc, "undefined");
				ach.toUnlockText = XmlHelper.GetAttrString(ax.@tounlock, "undefined");
				ach.completeFunction = XmlHelper.GetAttrString(ax.pass.@func, "");
				ach.completeFunctionParams = XmlHelper.GetAttrString(ax.pass.@params, "");
				 
				ach.cash = 100;
				ach.name = GetFullString(ach.name);
				ach.description = GetFullString(ach.description);
				ach.toUnlockText = GetFullString(ach.toUnlockText);
				
				var numTests:int = ax.test.length();
				for (var j:int = 0; j < numTests; j++)
				{
					var tx:XML = ax.test[j];
					
					var test:AchievementTest = new AchievementTest();
					test.functionName = XmlHelper.GetAttrString(tx.@func, "");
					test.functionParams = XmlHelper.GetAttrString(tx.@params, "");
					test.PreCalc();
					ach.testList.push(test);
					
				}
				
				ach.specificLevel = int(ach.specificLevelName) - 1;
				
				
				if (ach.specificsList.length == 3)
				{
					ach.specificLevelName = ach.specificsList[0];
//					ach.specificCharIndex = Inventory.GetItemByName("char_" + ach.specificsList[1]).charDef.index;
//					ach.specificBikeIndex = Inventory.GetItemByName("bike_" + ach.specificsList[2]).bikeDef.index
					
				}
				
				
				
				list.push(ach);
			}
			
			//ExportAchievementInfo();
			
//			trace("num achievements: " + numAch);
		}
		
		
		static function ExportAchievementInfo()
		{
			var index:int = 1;
			trace("----------------------------------------------------");
			for each(var ach:Achievement in list)
			{
				trace("UID:   " + index);
				trace("TITLE: " + ach.name);
				trace("DESC:  " + ach.toUnlockText);
				trace("-----------------------------");
				index++;
			}
			trace("----------------------------------------------------");
		}
		
		public static function ClearAll() 
		{
			for each(var ach:Achievement in list)
			{
				ach.complete = false;
			}			
		}
		public static function InitForLevel() 
		{
			cycleIndex = 0;
			cycleNumPerloop = 1;
		}
		public static function InitOnce() 
		{
			testFunctions = new AchievementTestFunctions();
			displayQueue = new AchievementDisplayQueue();
			
			list = new Vector.<Achievement>();
			unlockedList = new Vector.<Achievement>();

			XML.ignoreWhitespace = true;
            xml = new XML(new class_embedded_XML()) as XML; 

			LoadXml();
			
			displayQueue.Reset();
			
//			Utils.print("INITIALISING "+list.length+" ACHIEVEMENTS");
			
		}
		function Achievements() 
		{
			
		}
		

		
		
		static function GetFullString(s:String,replaceLevel:Boolean = true):String
		{
			var num:int;
			var s1:String;
			var a:Array = new Array();
			a = s.split(" ");
	
			var newstring:String = "";
			
			if (s == "Level Completion")
			{
				var aaa:int = 0;
			}
			
			for each( var word:String in a)
			{
				if (word == " ")
				{
					
				}
				else
				{
					{
						newstring += word;
						newstring += " ";
					}
				}
			}
			if (newstring.charAt(newstring.length - 1) == " ")
			{
				newstring = newstring.substring(0, newstring.length - 1);
			}
			return newstring;
		}
		
		

		static public function GetNumAchievements():int
		{
			return list.length;
		}
	
		static public function CountAchievementsComplete():int
		{
			var count:int = 0;
			for each(var ach:Achievement in list)
			{
				if(ach.complete)
				{
					count++;
				}
			}			
			return count;
		}
		
		static public function GetAchievementIndex(ach:Achievement):int
		{
			var index:int = 0;
			for each(var ach1:Achievement in list)
			{
				if (ach1 == ach)
				{
					return index;
				}
				index++;
			}			
			return 0;
		}
		
		static public function HasAchievement(name:String):Boolean
		{
			var ach:Achievement  = GetAchievementByName(name);
			if (ach == null) return false;
			return ach.complete;
		}
		static public function GetAchievementByName(name:String):Achievement
		{
			for each(var ach:Achievement in list)
			{
				if (ach.name == name)
				{
					return ach;
				}
			}			
			return null;
		}

		static public function GetAchievementByIndex(index:int):Achievement
		{
			if (index < 0) return null;
			if (index >= list.length) return null;
			return list[index];
		}
		
		
		static public function AllComplete():Boolean
		{
			for each(var ach:Achievement in list)
			{
				if (ach.complete == false)
				{
					return false;
				}
			}			
			return true;
		}
		
		
		static public function TestNone()
		{
			unlockedList = new Vector.<Achievement>();
		}
		
		public static var cycleIndex:int;
		public static var cycleNumPerloop:int;
		
		static public function TestInner(ach:Achievement)
		{
			if (ach.complete == false)
			{
				var doit:Boolean = true;
				if (ach.specificLevel != -1)
				{
					if (ach.specificLevel != Levels.currentIndex) doit = false;
				}
				if (doit)
				{
					//Utils.print("Testing " + ach.name);
					
					var numCorrect:int = 0;
					var numTests:int = ach.testList.length;
					for (var testIndex:int = 0; testIndex < numTests; testIndex++)
					{
						var test:AchievementTest = ach.testList[testIndex];
						var testFuncName:String = test.functionName;
						//var testFuncParams:String = test.functionParams;
						
						//Utils.GetParams(testFuncParams);
						Utils.paramDictionary = test.precalcedParamDictionary;
						//Utils.paramNames = test.precalcedParamNames;
						//Utils.paramValues = test.precalcedParamValues;
						var result:Boolean = testFunctions[testFuncName]();
						if (result)
						{
							numCorrect++;
						}
						else
						{
							break;
						}
					}
					if (numCorrect == numTests)		// AND all the tests.
					{
						//Utils.print("achievement " + ach.name + " successful");
						currentAch = ach;
						Utils.GetParams(ach.completeFunctionParams);
						testFunctions[ach.completeFunction]();
						ach.complete = true;
						unlockedList.push(ach);
//							AddCash(ach);
						
					}
					else
					{
//							Utils.print("achievement " + ach.name + " failed");													
					}
				}
			}
			
		}
		static public function TestAll(cycleTests:Boolean=true)
		{
			testFunctions.UpdateFromGameVars();
			unlockedList = new Vector.<Achievement>();
			
			if (cycleTests == false)
			{
				for each(var ach:Achievement in list)
				{
					TestInner(ach);
				}
			}			
			else
			{
				var ach:Achievement = list[cycleIndex];
				TestInner(ach);
				cycleIndex++;
				if (cycleIndex >= list.length) cycleIndex = 0;
			}
			
			displayQueue.AddUnlockedList(unlockedList);

		}
		
		
		static function AddCash(ach:Achievement)
		{
//			var c:int = 1;
//			GameVars.cash += c;
//			GameVars.levelCash += c;
//			ach.cash = c;
		}
		
		static public function UpdateDisplayQueue():Boolean
		{
			return displayQueue.Update();
		}
		
		static public function GetLevelAchievements(_level:int):Array
		{
			_level++;
			var newarray:Array = new Array();
			for each(var ach:Achievement in list)
			{
				if (ach.specificLevel == _level)
				{
					newarray.push(ach);
				}
			}
			return newarray;
		}
		
		public static function ResetForLevel():void 
		{
			displayQueue.Reset();
			testFunctions.ResetForLevel();
		}
		
		//--------------------------------------------------------------------------------------------------------
		//--------------------------------------------------------------------------------------------------------

		
		public static function ToByteArray(ba:ByteArray)
		{
			for each (var ach:Achievement in list)
			{
				ba.writeBoolean(ach.complete);
			}						
		}
				
		public static function FromByteArray(ba:ByteArray)
		{			
			for each (var ach:Achievement in list)
			{
				ach.complete = ba.readBoolean();
			}			
		}
		
		//--------------------------------------------------------------------------------------------------------
		
		
	}
	
}