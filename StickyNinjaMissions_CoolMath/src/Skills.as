package  
{
	/**
	 * ...
	 * @author 
	 */
	public class Skills 
	{
		static var list:Vector.<Skill>;
		
		public static const SKILL_TOPSPEED:int = 0;
		public static const SKILL_ACCEL:int = 1;
		public static const SKILL_BRAKES:int = 2;
		public static const SKILL_SPIN:int =3;
		public static const SKILL_JUMP:int = 4;
		public static const SKILL_NITRO_AMT:int = 5;
		public static const SKILL_NITRO_VEL:int = 6;
		public static const SKILL_NITRO_TIME:int =7;
		
		public function Skills() 
		{
			
		}
		
		public static function ResetEverything()
		{
			list = new Vector.<Skill>();
			var s:Skill;
			
			list.push(new Skill("topspeed",16));
			list.push(new Skill("accel",16));
			list.push(new Skill("brakes",16));
			list.push(new Skill("spin",16));
			list.push(new Skill("jumps",16));
			list.push(new Skill("nitro_amt",16));
			list.push(new Skill("nitro_vel",16));
			list.push(new Skill("nitro_time",16));
			
		}

		
		public static function InitOnce()
		{
			ResetEverything();
		}
		
		public static function IsFullyUpgraded():Boolean
		{
			for each(var s:Skill in list)
			{
				if (s.level != s.maxLevel) return false;
			}			
			return true;
		}
		public static function SetFull()
		{
			for each(var s:Skill in list)
			{
				s.level = s.maxLevel;
			}
		}
		
		public static function GetPercentByIndex(index:int):Number
		{
			var s:Skill = list[index];
			return s.GetPercent();
		}
		public static function GetByIndex(index:int):Skill
		{
			return list[index];
		}
		public static function GetByName(name:String):Skill
		{
			for each(var s:Skill in list)
			{
				if (s.name == name) return s;
			}
			return null;
		}
		
		public static function ToSharedObject():Object
		{
			var o:Object = new Object();
			o.levels = new Array();
			
			for each (var s:Skill in list)
			{
				o.levels.push(s.level);
			}
			
			return o;
		}
		
		public static function FromSharedObject(o:Object)
		{
			if (o == null) return;
			if (o.levels == null) return;
			
			var index:int = 0;
			
			for each(var i:int in o.levels)
			{
				list[index].level = i;
				index++;
			}
		}

		
		
	}

}