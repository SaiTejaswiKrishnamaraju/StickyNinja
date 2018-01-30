package  
{
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class Inventory
	{
		public static var items:Vector.<InventoryItem>;
		public function Inventory() 
		{
		}
		
		public static function InitOnce()
		{
			items = new Vector.<InventoryItem>();
			
			var x:XML = ExternalData.xml;
			var count:int = x.inventory.item.length();
			var i:int;
			for (i = 0; i < count; i++)
			{
				var ix:XML = x.inventory.item[i];
				var item:InventoryItem = new InventoryItem();
				
				
				
				item.used = XmlHelper.GetAttrBoolean(ix.@used, true);
				item.name = XmlHelper.GetAttrString(ix.@name, "");
				item.displayName = XmlHelper.GetAttrString(ix.@dispname, item.name);
				item.type = XmlHelper.GetAttrString(ix.@type, "object");
				item.description = XmlHelper.GetAttrString(ix.@desc, "description of the object");
				item.bikeID = XmlHelper.GetAttrInt(ix.@bike, 1);
				item.index = i;
				
				/*
				if (item.type == "bike")
				{
					item.description = "IT'S A NEW CYCLIST TO PLAY WITH";
					item.displayName = "";
					var bike:PlayerBikeData = PlayerBikes.GetBikeData(item.bikeID - 1)
					if (bike == null)
					{
						Utils.trace("-------------------ERROR in bike item: " + item.name + " " + item.bikeID);
					}
					else
					{
						item.displayName = bike.name;
					}
				}
				*/
				
				//Utils.print("inventory item: " + item.name);
				items.push(item);
			}						
		}
		
		public static function SetupNewItem(name:String, type:String,_displayName:String,_smallName:String=""):InventoryItem
		{
			var item:InventoryItem;
			item = GetItemByName(name);
			if (item != null) return item;
			
			var item:InventoryItem = new InventoryItem();
			item.name = name;
			item.displayName = _displayName;
			item.smallName = _smallName;
			item.type = type;
			items.push(item);
			return item;
		}
		
		public static function AnyNewItems():Boolean
		{
			for each(var item:InventoryItem in items)
			{
				if (item.owned && (item.beenUsed == false) && item.type != "bike")
				{
					return true;
				}
			}
			return false;
		}

		
		
		public static function GetItemOwned(name:String):Boolean
		{
			for each(var item:InventoryItem in items)
			{
				if (item.name == name)
				{
					if (item.owned) return true;
				}
			}
			return false;
		}
		public static function GetItemByName(name:String):InventoryItem
		{
			for each(var item:InventoryItem in items)
			{
				if (item.name == name) return item;
			}
			return null;
		}
		public static function GetItemByIndex(index:int):InventoryItem
		{
			return items[index];
		}
		public static function GetBikeItemByBikeID(id:int):InventoryItem
		{
			for each(var item:InventoryItem in items)
			{
				if (item.type == "bike")
				{
					if (item.bikeID == id) return item;
				}
			}
			return null;
		}
		
		public static function AwardItem(name:String):void
		{
			var item:InventoryItem = GetItemByName(name);
			if (item != null)
			{
				item.owned = true;
				item.beenUsed = false;
			}
			else
			{
				Utils.traceerror("AwardItem  fail " + name);
			}
		}

		public static function GetTotal():int
		{
			var count:int = 0;
			for each(var item:InventoryItem in items)
			{
				if (item.used)
				{
					count++;
				}
			}			
			return count;
		}
		public static function GetTotalUnlocked():int
		{
			var count:int = 0;
			for each(var item:InventoryItem in items)
			{
				if (item.owned) count++;
			}			
			return count;
		}
		
		
		public static function GetTotalBikesUnlocked():int
		{
			var count:int = 0;
			for each(var item:InventoryItem in items)
			{
				if (item.type == "bike")
				{
					if (item.owned) count++;
				}
			}			
			return count;
		}
		
		public static function UnlockAll()
		{
			for each(var item:InventoryItem in items)
			{
				item.owned = true;
			}			
		}
		
		public static function ClearAll()
		{
			for each(var item:InventoryItem in items)
			{
				item.owned = false;
				item.beenUsed = false;
			}			
		}
		
		public static function ToSharedObject():Object
		{
			var o:Object = new Object();
			for each(var item:InventoryItem in items)
			{
				o[item.name] = item.owned;
				var s:String = "used_" + item.name;
				o[s] = item.beenUsed;
			}
			return o;
		}
		
		public static function FromSharedObject(o:Object)
		{
			if (o == null) return;
			for each(var item:InventoryItem in items)
			{
				if (o[item.name])
				{
					item.owned = o[item.name];
					var s:String = "used_" + item.name;
					item.beenUsed = o[s];
				}
			}			
		}
		
	}

}