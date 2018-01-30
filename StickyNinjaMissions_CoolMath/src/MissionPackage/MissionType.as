package MissionPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class MissionType 
	{
		public static var FINISH:String = "finish";
		public static var HEALTH:String = "health";
		public static var JUMPS:String = "jumps";
		public static var TIME:String = "time";
		public static var SMASHES:String = "smashes";
		public static var KILLS:String = "kills";
		public static var VEHICLEKILLS:String = "vehiclekills";
		public static var TREASURE:String = "treasure";
		public static var COMBOKILLS:String = "combokills";
		public static var BESTMULTIPLIER:String = "bestmultiplier";
		public static var STEALTH:String = "stealth";
		public static var SHURIKEN:String = "shuriken";
		public static var LEVELSCORE:String = "levelscore";
		
		
		public static function GetIndex(s:String):int
		{
			var list:Array = new Array(
			FINISH, HEALTH, JUMPS, TIME, SMASHES, KILLS, VEHICLEKILLS, TREASURE, COMBOKILLS, BESTMULTIPLIER, STEALTH, SHURIKEN,LEVELSCORE);
			return list.indexOf(s);
		}
		
		public function MissionType() 
		{
			
		}
		
	}

}