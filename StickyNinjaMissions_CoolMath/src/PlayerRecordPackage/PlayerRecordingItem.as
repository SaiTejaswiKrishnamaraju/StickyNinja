package PlayerRecordPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class PlayerRecordingItem 
	{
		public var x:Number;
		public var y:Number;
		public var frame:int;
		public var rot:Number;
		public var wheel0_x:Number;
		public var wheel0_y:Number;
		public var wheel0_rot:Number;
		public var wheel1_x:Number;
		public var wheel1_y:Number;
		public var wheel1_rot:Number;
		public var action:int;
		
		public function PlayerRecordingItem() 
		{
			
		}
		public function Clone():PlayerRecordingItem
		{
			var pri:PlayerRecordingItem = new PlayerRecordingItem();
			pri.x = x;
			pri.y = y;
			pri.frame = frame;
			pri.rot = rot;
			pri.wheel0_x = wheel0_x;
			pri.wheel0_y = wheel0_y;
			pri.wheel0_rot = wheel0_rot;
			pri.wheel1_x = wheel1_x;
			pri.wheel1_y = wheel1_y;
			pri.wheel1_rot = wheel1_rot;
			pri.action = action;
			return pri;
		}
		

		public function SetInterpolatedItem(pri0:PlayerRecordingItem,pri1:PlayerRecordingItem,time:Number)
		{
			x = Utils.ScaleTo(pri0.x, pri1.x, 0, 1, time);
			y = Utils.ScaleTo(pri0.y, pri1.y, 0, 1, time);
			wheel0_x = Utils.ScaleTo(pri0.wheel0_x, pri1.wheel0_x, 0, 1, time);
			wheel0_y = Utils.ScaleTo(pri0.wheel0_y, pri1.wheel0_y, 0, 1, time);
			wheel1_x = Utils.ScaleTo(pri0.wheel1_x, pri1.wheel1_x, 0, 1, time);
			wheel1_y = Utils.ScaleTo(pri0.wheel1_y, pri1.wheel1_y, 0, 1, time);
			frame = pri0.frame;
			
			rot = InterpolateRot(pri0.rot,pri1.rot, time);
			wheel0_rot = InterpolateRot(pri0.wheel0_rot,pri1.wheel0_rot, time);
			wheel1_rot = InterpolateRot(pri0.wheel1_rot,pri1.wheel1_rot, time);
		}
		
		function InterpolateRot(r0:Number, r1:Number, time:Number):Number
		{
			var pi:Number = Math.PI;
			var pi2:Number = Math.PI * 2;
			
			var q0:Number = 0;
			var q1:Number = pi / 2;
			var q2:Number = pi;
			var q3:Number = pi + (pi / 2);
			
			var t:Boolean = false;
			
			if (r0 < 0) r0 += pi2;
			if (r1 < 0) r1 += pi2;
			
			if (r0 > q3)	// 3rd
			{
				if ( r1 < q1)
				{
					r1 += pi2;
				}
			}
			else if (r0 < q1)
			{
				if (r1 > q3)
				{
					r1 -= pi2;
				}
			}
			
			return Utils.ScaleToPreLimit(r0, r1, 0, 1, time);
			
		}
		
	}

}