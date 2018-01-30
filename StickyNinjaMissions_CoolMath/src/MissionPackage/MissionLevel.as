package MissionPackage
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class MissionLevel 
	{
		public var name:String;
		public var levelName:String;
		
		
		public var objectives:Vector.<MissionObjective>;

		// game info
		public var medalJumps:Array;
		
		// savable data:
		public var bestJumps:int;
		public var complete:Boolean;
		public var played:Boolean;
		public var result:int;
		public var available:Boolean;
		public var newlyAvailable:Boolean;
		
		
		public function ToByteArray(ba:ByteArray)
		{			
			ba.writeInt(bestJumps);
			ba.writeBoolean(complete);
			ba.writeBoolean(played);
			ba.writeInt(result);
			ba.writeBoolean(available);
			ba.writeBoolean(newlyAvailable);
		}
		public function FromByteArray(ba:ByteArray)
		{			
			bestJumps = ba.readInt();
			complete = ba.readBoolean();
			played = ba.readBoolean();
			result = ba.readInt();
			available = ba.readBoolean();
			newlyAvailable = ba.readBoolean();
		}
		
		public function MissionLevel() 
		{
			objectives = new Vector.<MissionObjective>();
			complete = false;
			medalJumps = new Array(0, 0);
			played = false;
			bestJumps = 9999999999;
			result = 0;
			available = false;
			newlyAvailable = false;
			
		}
		
		//gold, silver, and bronze is implied
		public function SetJumpMedals(j0:int, j1:int)
		{
			medalJumps[0] = j0;
			medalJumps[1] = j1;
		}
		
		public function AddObjective(_name:String,_type:String,_value:Object)
		{
			var mo:MissionObjective = new MissionObjective();
			mo.name = _name;
			mo.type = _type;
			mo.value = _value;
			objectives.push(mo);
		}
		
		
		public function TestPass():Boolean
		{
			var passedCount:int = 0;
			
			// ALL objectives passed
			for each(var mo:MissionObjective in objectives)
			{
				if (mo.TestPass())
				{
					passedCount++;
				}
			}
			
			return (passedCount >= objectives.length);
			
		}
		public function IsDoorAlwaysOpen():Boolean
		{
			for each(var mo:MissionObjective in objectives)
			{
				if (mo.IsDoorAlwaysOpen())
				{
					return true;
				}
			}
			return false;
		}
		public var lastFailure:String;
		public function Update():String
		{
			
			var failed:Boolean = false;
			
			// ANY objective failed?
			for each(var mo:MissionObjective in objectives)
			{
				if (mo.TestFail())
				{
					lastFailure = mo.lastFailure;
					failed = true;
				}
			}
			
			if (failed)
			{
				trace("FAILED");
				return MissionResult.FAIL;
			}
			return MissionResult.NONE;
		}
		
		
	}

}