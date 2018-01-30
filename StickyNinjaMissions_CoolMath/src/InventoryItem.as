package  
{
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class InventoryItem
	{
		public var name:String;
		public var owned:Boolean;
		public var index:int;
		public var type:String;
		public var description:String;
		public var displayName:String;
		public var smallName:String;
		public var bikeID:int;
		public var beenUsed:Boolean;
		public var used:Boolean;
		
		public var charDef:CharDef;
		public var bikeDef:BikeDef;
		public var bellDef:BellDef;
		
		public function InventoryItem() 
		{
			index = 0;
			name = "";
			displayName = "";
			smallName = "";
			owned = false;
			type = "object";
			description = "";
			beenUsed = false;
			used = true;
			charDef = null;
			bikeDef = null;
			bellDef = null;
		}

		
		
	}

}