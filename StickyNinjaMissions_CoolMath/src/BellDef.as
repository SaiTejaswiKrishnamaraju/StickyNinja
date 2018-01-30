package  
{
	/**
	 * ...
	 * @author 
	 */
	public class BellDef 
	{
		public var name:String;
		public var displayName:String;
		public var soundName:String;
		public var index:int;
		public var inv:InventoryItem;

		
		
		
		public function BellDef(_name:String, _displayName:String, _soundName:String) 		
		{
			index = 0;
			name = _name;
			displayName = _displayName
			soundName = _soundName;		
			
//			inv = Inventory.SetupNewItem(name, "bell", displayName);
//			inv.bellDef = this;

		}
		
	}

}