package  
{
	/**
	 * ...
	 * @author 
	 */
	public class Skill 
	{
		public var name:String;
		public var level:int;
		public var maxLevel:int;
		
		public function Skill(_name:String,_maxLevel:int) 
		{
			name = _name;
			level = 0;
			maxLevel = _maxLevel;
		}
		
		public function GetUpgradeCost():int
		{
			var priceList:Array = new Array( 50, 100, 150,200, 250, 300, 350, 400, 450, 500,900,1000,1100,1200);
			var priceList_TopSpeed:Array = new Array( 50, 100, 150,200, 300, 400, 500, 600, 700, 800,900,1000,1100,1200);
			
			
			var i:int = level;
			if (i < 0) i = 0;
			if (i >= priceList.length) i = priceList.length - 1;
			
			var cost:int = priceList[i];
			
			if (name == "topspeed")
			{
				cost = priceList_TopSpeed[i];
			}
			
			return cost;
		}
		public function Upgrade()
		{
			level++;
			if (level > maxLevel) level = 0;
		}
		
		public function GetPercent():Number
		{
			return Utils.ScaleTo(0, 100, 0, maxLevel, level);
		}
		
	}

}