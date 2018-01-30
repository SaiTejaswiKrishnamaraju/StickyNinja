package  
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class Stats 
	{
		
		public function Stats() 
		{
			
		}
		
		public static var statList:Vector.<Stat>;
		
		public static function GetCount():int
		{
			return statList.length;
		}
		
		public static function GetString(index:int)
		{
			var s:String = GetNameString(index) + ":  " + GetValueString(index);
			return s;
		}

		public static function GetNameString(index:int)
		{
			var stat:Stat = statList[index];
			var s:String = stat.name;
			return s;
		}
		
		public static function GetValueString(index:int)
		{
			var stat:Stat = statList[index];
			
			var valString:String = stat.value.toString();
			if (stat.displayType == "time")
			{
				valString =  Utils.CounterToMinutesSecondsMilisecondsString(stat.value);
			}
			if (stat.displayType == "dollar")
			{
				valString =  "$" + valString;
			}
			return valString;
		}
		
		
		public static function GetValueByName(name:String):int
		{
			for each(var stat:Stat in statList)
			{
				if (stat.name == name) 
				{
					if (stat.displayType == "time")
					{
						return int(stat.value / Defs.fps);
					}
					return stat.value;
				}
			}
			Utils.traceerror("can't find stat: " + name);
			return 0;
		}
		
		public static function GetAllString():String
		{
			var s:String = "";
			for (var i:int = 0; i < statList.length; i++)
			{
				s += GetString(i);
				s += "\n";
			}
			return s;
		}
		
		public static function GetAllNamesString():String
		{
			var s:String = "";
			for (var i:int = 0; i < statList.length; i++)
			{
				s += GetNameString(i);
				s += "\n";
			}
			return s;
		}
		
		public static function GetAllValuesString():String
		{
			var s:String = "";
			for (var i:int = 0; i < statList.length; i++)
			{
				s += GetValueString(i);
				s += "\n";
			}
			return s;
		}
		
		public static function InitOnce()
		{
			ResetStats();
		}
		
		public static function AddStat(name:String)
		{
			var stat:Stat;
			stat = new Stat(name);		//
			statList.push(stat);
		}
		public static function AddStat_Time(name:String)
		{
			var stat:Stat;
			stat = new Stat(name);
			stat.displayType = "time";			
			statList.push(stat);
		}
		public static function AddStat_Dollar(name:String)
		{
			var stat:Stat;
			stat = new Stat(name);
			stat.displayType = "dollar";			
			statList.push(stat);
		}
		
		public static function ResetStats()
		{
			statList = new Vector.<Stat>();

			AddStat_Time("Total Time Played");			//
			AddStat_Time("Total Nitro Time");			//
			AddStat("Total Rolls");			//
			AddStat("Total Vehicles Smashed");	// 
			AddStat("Total Jumps");	// 
			AddStat("All Coin Levels");	// 
			AddStat_Dollar("Most Money In Bank");		//
			AddStat("Wins");		//
			AddStat("Top Threes");		//
			AddStat("Score");		//
		}
		
		public static function Add(name:String, value:int)
		{
			for each(var stat:Stat in statList)
			{
				if (stat.name == name)
				{
					stat.Add(value);
					return;
				}
			}
			Utils.traceerror("ERROR: missing stat: " + name);			
		}
		
		public static function Test(name:String, value:int)
		{
			for each(var stat:Stat in statList)
			{
				if (stat.name == name)
				{
					stat.Test(value);
					return;
				}
			}
			Utils.traceerror("ERROR: missing stat: " + name);
		}
		
		
		public static function ToByteArray(ba:ByteArray)
		{			
			for each (var s:Stat in statList)
			{
				ba.writeInt(s.value);
				ba.writeBoolean(s.hasBeenSet);
			}			
		}
		
		
		public static function FromByteArray(ba:ByteArray)
		{			
			for each (var s:Stat in statList)
			{
				s.value = ba.readInt();
				s.hasBeenSet = ba.readBoolean();
			}			
		}
		
		
	}

}