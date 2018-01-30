package AchievementPackage
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class Achievement 
	{
		public var index:int;
		public var name:String;
		public var description:String;
		public var toUnlockText:String;
		public var complete:Boolean;
		public var testList:Vector.<AchievementTest>;
		public var completeFunction:String;
		public var completeFunctionParams:String;
		public var specificLevel:int;
		public var specificLevelName:String;
		public var specificCharIndex:int;
		public var specificBikeIndex:int;
		public var specificsString:String;
		public var specificsList:Array;
		public var cash:int;
		
		var popupFrame:int;
		
		public function Achievement() 
		{
			name = "undefined";
			description = "undefined";
			complete = false;
			
			completeFunction = null;			
			completeFunctionParams = null;			
			specificLevel = -1;
			specificLevelName = "";
			
			testList = new Vector.<AchievementTest>();
		}
		
	}
	
}
// cD$we&7X7sGy
