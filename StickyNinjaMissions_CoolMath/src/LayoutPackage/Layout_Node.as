package LayoutPackage
{
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class Layout_Node
	{
		public var id:String;
		public var label:String;
		public var layouttype:String;
		public var type:String;
		
		public function Layout_Node() 
		{
			id = "";
			label = "";
			layouttype = "";
			type = "";
		}
		
		public function Validate()
		{
			if (type == "level")
			{
				var lev:String = label.replace("level_", "");
				if (Levels.GetLevelById(lev) == null)
				{
					Utils.traceerror("ERROR VALIDATING LAYOUT: Level doesn't exist: " + label);
				}
			}
			if (type == "requirement")
			{
				if (label != "" && label != "null")
				{
					if (Inventory.GetItemByName(label) == null)
					{
						Utils.traceerror("ERROR VALIDATING LAYOUT: Requirement item doesn't exist: " + label);
					}
				}
			}
			/*
			if (type == "award")
			{
				if (label != "" && label != "null")
				{
					if (Inventory.GetItemByName(label) == null)
					{
						Utils.traceerror("ERROR VALIDATING LAYOUT: Award item doesn't exist: " + label);
					}
				}
			}
			*/
		}
		
	}

}