package  
{
	import flash.geom.Point;
	
	/**
	* ...
	* @author Default
	*/
	public class Vec 
	{
		public var rot:Number;
		public var speed:Number;
		public function Vec() 
		{
			rot = 0.0;
			speed = 0.0;
		}
		public function SetFromDxDy(dx:Number, dy:Number)
		{
			speed = Math.sqrt( (dx * dx) + (dy * dy) );
			rot = Math.atan2(dy, dx);
		}
		public function Set(_r:Number, _s:Number)
		{
			rot = _r;
			speed = _s;
		}
		public function SetAng(_r:Number)
		{
			rot = _r;
		}

		public function NearRot(r:Number, d:Number):Boolean
		{
			var a:Number = rot - r;
			
			var aa:Number = Math.abs(a);
			
			if (a > Math.PI)
			{
				if (r < rot) 
					r += Math.PI*2;
				else
					r -= Math.PI*2;
				a = rot - r;
			}
			
			if (Math.abs(a) <= d) return true;
			return false;
		}
		
		
		public function Add(v:Vec)
		{
			var x0:Number = Math.cos(rot) * speed;
			var y0:Number = Math.sin(rot) * speed;
			var x1:Number = Math.cos(v.rot) * v.speed;
			var y1:Number = Math.sin(v.rot) * v.speed;
			
			var dx:Number = x0 + x1;
			var dy:Number = y0 + y1;

			rot = Math.atan2(dy, dx);
			speed = Math.sqrt( (dx * dx) + (dy * dy) );	
		}
		
		public function GetUnitTangent():Point
		{
			var r:Number = rot + (Math.PI * 0.5);
			var p:Point = new Point(Math.cos(r), Math.sin(r));
			return p;
		}
		
		public function X():Number
		{
			return Math.cos(rot) * speed;
		}
		public function Y():Number
		{
			return Math.sin(rot) * speed;
		}

		public function UnitX():Number
		{
			return Math.cos(rot);
		}
		public function UnitY():Number
		{
			return Math.sin(rot);
		}
		
		
		public function AddRot(d:Number):void
		{
			rot += d;
			NormalizeRot();
		}
		
		public function dotRot(r:Number):Number
		{
			var x0:Number = Math.cos(rot);
			var y0:Number = Math.sin(rot);
			var x1:Number = Math.cos(r);
			var y1:Number = Math.sin(r);
			var dot:Number = (x0 * x1) + (y0 * y1);
			return dot;
		}
		
		function NormalizeRot():void
		{
			while (rot < 0)
			{
				rot += Math.PI * 2;
			}
			while (rot > Math.PI*2)
			{
				rot -= Math.PI * 2;
			}
		}

		
		function RotateToRequiredRot(rv:Number,xpos:Number,ypos:Number,toPosX:Number,toPosY:Number):Boolean
		{
			var requiredRot:Number = Math.atan2(toPosY - ypos, toPosX - xpos);
			
			var r1a:Number = requiredRot + (Math.PI / 2.0);
			var d1:Number = Utils.DotProduct(Math.cos(rot), Math.sin(rot),Math.cos(r1a), Math.sin(r1a));
			if (NearRot(requiredRot, rv)) 
			{
				rot = requiredRot;
				return true;
			}

			if (d1 < 0)
			{
				AddRot( rv);
			}
			else
			{
				AddRot( -rv);
			}
			return false;
			
		}
		
	}
	
}