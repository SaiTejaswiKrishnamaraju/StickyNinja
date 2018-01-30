package  
{
	/**
	 * ...
	 * @author 
	 */
	public class CharDef 
	{
		
		public var name:String;
		public var displayName:String;
		public var mcName:String;
		public var description:String;
		public var index:int;
		public var hierarchyID:int;
		public var bikesAllowed:Array;
		
		public var skills:Array;
		public var inv:InventoryItem;

		
		
		public function Export():String
		{
			var s:String = "";
			s += "\t\t\tcharList["+index+"].Setup(";
			s += '"'+name+'"' +",";
			s += '"'+mcName+'"' +",";
			s += '"'+displayName+'"' +",";
			s += hierarchyID +",";
			s += skills[0] +",";
			s += skills[1] +",";
			s += skills[2] +",";
			s += skills[3] +",";
			s += skills[4] +",";
			s += skills[5] +",";
			s += '"'+description+'"' +");";
			return s;
		}
		
		public function CharDef() 
		{
			
			skills = new Array();
			name = "";
			index = 0;
			bikesAllowed = new Array(0, 1, 2);
			description = "description";
			
			for (var i:int = 0; i < 6; i++)
			{
				skills.push(Utils.RandBetweenInt(0, 100));
			}
		}
		
		public function Setup(n:String,mcn:String,_displayName:String,_hierarchyID:int,sk0:int,sk1:int,sk2:int,sk3:int,sk4:int,sk5:int,_desc:String)
		{
			name = n;
			displayName = _displayName;
			mcName = mcn;
			hierarchyID = _hierarchyID;
			
			skills[0] = sk0;
			skills[1] = sk1;
			skills[2] = sk2;
			skills[3] = sk3;
			skills[4] = sk4;
			skills[5] = sk5;
			
			description = _desc;
			
//			inv = Inventory.SetupNewItem("char_" + name, "character", displayName);
//			inv.charDef = this;
		}
		
		
		public function GetCharSkill(skillIndex):Number
		{
			if (GameVars.useFeature5)
			{
				return 100;
			}
			return skills[skillIndex];
		}
		
		public function GetSkillValue(skillIndex:int):int
		{
			var charSkill:Number = GetCharSkill(skillIndex);
			var upgradeSkill:Number = Skills.GetPercentByIndex(skillIndex);
			
			var stats_character_percent:Number = Vars.GetVarAsNumber("stats_character_percent");
			var stats_upgrade_percent:Number = Vars.GetVarAsNumber("stats_upgrade_percent");
			
			// from 0-100 to 0-1
			stats_character_percent *= 0.01;
			stats_upgrade_percent *= 0.01;
			
			var total:Number = (charSkill * stats_character_percent) + (upgradeSkill * stats_upgrade_percent);
			
			return total;
		}
	}

}