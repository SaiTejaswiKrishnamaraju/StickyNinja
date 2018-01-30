package  
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class GrassSegment 
	{
		var list:Vector.<GrassItem>;
		var x0:Number;
		var x1:Number;
		var y0:Number;
		var y1:Number;
		var boundingRect:Rectangle;
		
		public function GrassSegment() 
		{
			list = new Vector.<GrassItem>();
		}
		
	}

}