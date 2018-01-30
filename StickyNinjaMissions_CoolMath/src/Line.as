package  
{
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Default
	*/
	public class Line 
	{
		public var x0:Number;
		public var y0:Number;
		public var x1:Number;
		public var y1:Number;
		public var nx:Number;
		public var ny:Number;
		public var dir:Number;
		public var normalDir:Number;
		public var length:Number;
		public var dx:Number;
		public var dy:Number;
		public var udx:Number;
		public var udy:Number;
		public var boundingRect:Rectangle;
		
		public function Line(_x0:Number, _y0:Number, _x1:Number, _y1:Number)
		{
			x0 = _x0;
			y0 = _y0;
			x1 = _x1;
			y1 = _y1;		
			CalcNormal();
			CalcBoundingRect();
			
					
		}	
		
		function CalcBoundingRect():void
		{
			var a:Number;
			var b:Number;
			var c:Number;
			var d:Number;
			
			a = x0;
			b = x1;
			if ( a > b)
			{
				a = x1;
				b = x0;
			}
			c = y0;
			d = y1;
			if ( c > d)
			{
				c = y1;
				d = y0;
			}
			boundingRect = new Rectangle(a, c, (b - a)+1, (d - c)+1);
			
		}
		
		function CalcNormal():void
		{
			dir = Math.atan2(y1 - y0, x1 - x0);
			normalDir= dir - (Math.PI * 0.5);
			nx = Math.cos(normalDir);
			ny = Math.sin(normalDir);	
			
			dx = x1 - x0;
			dy = y1 - y0;
			length = Math.sqrt(dx * dx + dy * dy);
			
			udx = Math.cos(dir);
			udy = Math.sin(dir);
			
		}
		
		
		
		
		
	}
	
}