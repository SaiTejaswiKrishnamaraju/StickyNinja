package  
{
	/**
	 * ...
	 * @author 
	 */
	public class GrassItem 
	{
		var origx:Number;
		var origy:Number;
		var xpos:Number;
		var ypos:Number;
		var gf:GrassFrame;
		var visible:Boolean;
		var rot:Number;
		var timer:int;
		var frameIndex:int;
		
		public function GrassItem(_x:Number,_y:Number,_gf:GrassFrame,_frameIndex:int) 
		{
			origx = _x;
			xpos = _x;
			origy = _y;
			ypos = _y;
			gf = _gf;
			visible = true;
			rot = 0;
			timer = 0;
			frameIndex = _frameIndex;
		}
		
		public function Clone():GrassItem
		{
			var clone:GrassItem = new GrassItem(xpos, ypos, gf,frameIndex);	
			clone.visible = visible;
			return clone;
		}
		
	}

}