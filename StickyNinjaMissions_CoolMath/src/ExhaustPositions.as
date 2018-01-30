package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class ExhaustPositions 
	{
		var points:Array;
		var rots:Array;
		public function ExhaustPositions(p0:Point, dir0:Number,p1:Point = null, dir1:Number=0,p2:Point = null,dir2:Number=0 ) 
		{
			points = new Array();
			rots = new Array();
			points.push(p0);
			rots.push(Utils.DegToRad(dir0));
			if (p1 != null) 
			{
				points.push(p1);
				rots.push(Utils.DegToRad(dir1));
			}
			if (p2 != null) 
			{
				points.push(p2);
				rots.push(Utils.DegToRad(dir2));
			}
		}
		
	}

}