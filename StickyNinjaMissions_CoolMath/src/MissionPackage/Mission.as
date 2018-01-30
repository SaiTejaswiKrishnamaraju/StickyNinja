package MissionPackage
{
	/**
	 * ...
	 * @author 
	 */
	public class Mission 
	{
		public var index:int;
		public var id:String;
		public var name:String;
		public var description:String;
		public var missionLevels:Vector.<MissionLevel>;
		
		public var available:Boolean;
		public var newlyAvailable:Boolean;
		
		public function Mission() 
		{
			missionLevels = new Vector.<MissionLevel>();
			available = false;
			newlyAvailable = false;
		}
		
		public function AddLevel(_name:String,_levelName:String=""):MissionLevel
		{
			var ml:MissionLevel = new MissionLevel();
			ml.name = _name;
			ml.levelName = _levelName;
			missionLevels.push(ml);
			return ml;
		}
		
	}

}