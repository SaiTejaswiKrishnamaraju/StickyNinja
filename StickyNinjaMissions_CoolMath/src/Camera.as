package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class Camera
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var dragStartX:Number;
		public var dragStartY:Number;
		
		public var fov:Number;
		var fl:Number;
		
		var oldX:Number;
		var oldY:Number;		
		var cx:Number;
		var cy:Number;		
		var maxX:Number;
		var maxY:Number;
		var minX:Number;
		var minY:Number;
		var toDX:Number;
		var toDY:Number;
		var toX:Number;
		var toY:Number;
		var scale:Number;
		
		
		
		
		public function Camera() 
		{
			Reset();
		}
		
		var savedx:Number;
		var savedy:Number;
		public function PushPos()
		{
			savedx = x;
			savedy = y;
		}
		public function PopPos()
		{
			x = savedx;
			y = savedy;
		}
		
		public function ResetBounds()
		{
			minX = 12345678;
			maxX = 12345678;
			minY = 12345678;
			maxY = 12345678;			
		}
		
		public function UpdatePosition(px:Number, py:Number,linv:Point)
		{
//			UpdateShakeCam(5);
			
			oldX = x;
			oldY = y;
			
		
			var dx:Number;
			var dy:Number;
			
			var xoff:Number = 320;
			var yoff:Number = 240;
			
			
			cx = px;
			cy = py;
			
			var ang:Number = Math.atan2(linv.y, linv.x);
			var speed:Number = Utils.GetLength(linv.x,linv.y);
			
			if (speed < 3)
			{
				dx = 0;
				dy = 0;
			}
			else
			{
				speed = Utils.LimitNumber(3, 10, speed);				
				var dist:Number = Utils.ScaleTo(0, 150, 0, 30, speed);
				dx = Math.cos(ang) * dist;
				dy = Math.sin(ang) * dist;
			}			
			
			toDX += (dx - toDX) * 0.1;
			toDY += (dy - toDY) * 0.1;
			
			x = (px - xoff) + toDX;
			y = (py - yoff) + toDY;

			
//			x += shakeCamX;
//			y += shakeCamY;
			
			
			if (minX != 12345678 && minY != 12345678)
			{
				if (x < minX) x = minX;
				if (y < minY) y = minY;
				if (x > (maxX - Defs.displayarea_w) ) x = (maxX - Defs.displayarea_w);
				if (y > (maxY - Defs.displayarea_h) ) y = (maxY - Defs.displayarea_h);
			}
			
			scale = 1;
			
		}
		public function Reset()
		{
			fl = Defs.displayarea_w / 2;
			fov = 60;
			x = 0;
			y = 0;
			z = 0;
			oldX = 0;
			oldY = 0;
			cx = 0;
			cy = 0;		
			maxX = minX = 0;
			maxY = minY = 0;
			toDX = toDY = 0;
			scale = 1;
			toX = 0;
			toY = 0;
		}

		static var shakeCamToX:Number = 0;
		static var shakeCamToY:Number = 0;
		static var shakeCamX:Number = 0;
		static var shakeCamY:Number = 0;
		static var shakeCamDX:Number = 0;
		static var shakeCamDY:Number = 0;
		static var shakeCamTimer:int = 50;
		static var shakeCamTimerMax:int = 50;
		static function UpdateShakeCam(speed:Number):void 
		{
			shakeCamTimer--;
			if (shakeCamTimer <= 0)
			{
				shakeCamTimer = Utils.RandBetweenInt(5,20);
				shakeCamTimerMax = shakeCamTimer;
				
				
				var dist:Number = Utils.ScaleTo(2,20, 0, 30, speed);

				shakeCamToX = Utils.RandBetweenFloat( -dist,dist);
				shakeCamToY = Utils.RandBetweenFloat( -dist,dist);
				
				shakeCamDX = (shakeCamToX - shakeCamX) / shakeCamTimer;
				shakeCamDY = (shakeCamToY - shakeCamY) / shakeCamTimer;
				
			}
			
			
			shakeCamX += shakeCamDX;	// (shakeCamToX - shakeCamX) * 0.1;
			shakeCamY += shakeCamDY;	// (shakeCamToY - shakeCamY) * 0.1;
		}
		
		
		
		public var transformX:Number;
		public var transformY:Number;
		public var transformZ:Number;
		
		
		public function PerspectiveTransformGetScale(screenZ:Number):Number
		{
			transformZ = screenZ - z;
			var scale:Number = fl / (fl + transformZ);
			scale *= 1;	// fov;
			return scale;			
		}
		public function PerspectiveTransform(screenX:Number,screenY:Number,screenZ:Number):Number
		{
	//		tvs[i].x_ = cx + fov * tv.x_ / (cameraZ - tv.z_);
	//			tvs[i].y_ = cy + fov * tv.y_ / (cameraZ - tv.z_);
				
			var cx:Number = Defs.displayarea_w / 2;	// centreX
			var cy:Number = Defs.displayarea_h / 2; // centreY
			
			screenX -= cx;
			screenY -= cy;
			
			transformZ = screenZ - z;
			var scale:Number = fl / (fl + transformZ);
			scale *= 1;	// fov;
			
			transformX = cx + (screenX * scale);
			transformY = cy + (screenY * scale);
			
			return scale;
			
		}
		
		
		
	}

}