package  
{
	/**
	 * ...
	 * @author 
	 */
	public class Stat 
	{
		public var name:String;
		var value:int;
		var type:String;
		var hasBeenSet:Boolean;
		var newRecordSet:Boolean;
		var displayPopup:Boolean;
		var displayType:String;
		
		var isBestPerLevelType:Boolean;
		var bestValueForLevel:int;
		
		public function Stat(_name:String,_displayPopup:Boolean = false,_type:String="highest") 
		{
			name = _name;
			type = _type;
			value = 0;
			if (type == "lowest") value = 99999999;
			hasBeenSet = false;
			newRecordSet = false;
			displayPopup = _displayPopup;
			displayType = "";
			isBestPerLevelType = false;
			InitForLevel();
			bestValueForLevel = 0;
		}
		
		public function InitForLevel()
		{
			if (isBestPerLevelType)
			{
				bestValueForLevel = 0;
				if (type == "lowest") bestValueForLevel = 99999999;				
			}
		}
		public function Test(newValue:int)
		{
			if (type == "highest")
			{
				if (newValue > value)
				{
					value = newValue;
					newRecordSet = true;
					hasBeenSet = true;
				}
			}
			if (type == "lowest")
			{
				if (newValue < value)
				{
					value = newValue;
					newRecordSet = true;
					hasBeenSet = true;
				}
			}
			if (newRecordSet)
			{
				Utils.print("stat set " + name + "  " + value);
			}
		}
		
		public function Add(adder:int)
		{
			if (isBestPerLevelType)
			{
				bestValueForLevel += adder;
				if (bestValueForLevel > value)
				{
					value = bestValueForLevel;
				}
				return;
			}
			
			if (type == "highest")
			{
				value += adder;
				newRecordSet = true;
				hasBeenSet = true;
			}
			if (newRecordSet)
			{
//				Utils.print("stat set " + name + "  " + value);
			}
		}
		
	}

}