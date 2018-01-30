package PlayerRecordPackage
{
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class PlayerRecordAction
	{
		
		public static const ACTION_JUMP:int = 0;
		public static const ACTION_STUNT:int = 1;
		public static const ACTION_CROSSEDLINE:int = 2;
		public static const ACTION_HITCAR:int = 3;
		public static const ACTION_NAPEOFFSET:int = 4;
		public static const ACTION_HITNITRO:int = 5;
		
		
		public var pos:int;
		public var action:int;
		public var x:int;
		public var y:int;
		public var data:int;
		
		// runtime;
		public var done:Boolean;
		
		public function PlayerRecordAction(_pos:int, _action:int,_x:int,_y:int,_data:int) 
		{
			pos = _pos;
			action = _action;
			x = _x;
			y = _y;
			data = _data;
			done = false;
		}
		
		public function Clone():PlayerRecordAction
		{
			var act:PlayerRecordAction = new PlayerRecordAction(pos, action, x, y,data);
			return act;
		}
		
	}

}