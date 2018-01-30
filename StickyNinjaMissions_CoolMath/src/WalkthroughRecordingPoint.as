package  
{
	/**
	 * ...
	 * @author 
	 */
	public class WalkthroughRecordingPoint 
	{
		var x:int;
		var y:int;
		var mouseButton:Boolean;
		var time:int;
		
		public function WalkthroughRecordingPoint(_x:int,_y:int,_button:Boolean,_time:int) 
		{
			x = _x;
			y = _y;
			mouseButton = _button;
			time = _time;
		}
		
		public function Clone():WalkthroughRecordingPoint
		{
			var p:WalkthroughRecordingPoint = new WalkthroughRecordingPoint(x, y, mouseButton, time);
			return p;
		}
		
		
	}

}