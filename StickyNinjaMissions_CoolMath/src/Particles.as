package {
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;

	public class Particles
	{
		public static const type_dust = 0;
		
		static var max:int;
		static var list:Vector.<Particle>;
		static var nextIndex:int;

		public static function InitOnce(_max:int):void
		{
			max = _max;
			nextIndex =0;
			list = new Vector.<Particle>(max);
			var i:int;
			var j:int;
			for(i=0; i<max; i++)
			{				
				list[i] = new Particle();
				list[i].movementVec = new Vec();
				list[i].active = false;
			}			
		}
		
		public function Particles():void
		{
		}
		
		public static function CountActive():int
		{
			var numActive:int = 0;
			var i:int;
			for(i=0; i<max; i++)
			{				
				if (list[i].active)
				{
					numActive++;
				}
			}			
			return numActive;
		}
		
		public static function GetNextIndex():int
		{
			return nextIndex;
		}
		
		public static function Reset()
		{
			nextIndex =0;
			var i:int;
			for(i=0; i<max; i++)
			{				
				list[i].active = false;
			}			
		}
		

		
		public static function Add(xpos:Number,ypos:Number):Particle
		{
			var vel:Number;
			var ang:Number;
			var p:Particle = list[nextIndex];
			nextIndex++;
			if(nextIndex >= max) nextIndex = 0;			// always overwrite particle - cyclic loop
			p.active = true;
			p.timer =0;
			p.alpha = 1.0;
			p.visible = true;				
			p.xpos = xpos;
			p.ypos = ypos;
			p.angle = 0;
			p.scale = 1;
			p.dobj = null;
			return p;
		}
		
		public static function Update()
		{
			var i:int;
			for(i=0; i<max; i++)
			{				
				var p:Particle = list[i];
				if(p.active == true)
				{
					p.updateFunction();
				}
			}						
		}
		
		static var ct:ColorTransform = new ColorTransform();

		public static function Render(_bd:BitmapData)
		{
			
			var bd:BitmapData = _bd;
			
			var camScale:Number = Game.camera.scale;
			
			
			
			var x0:Number = 0 - 16;
			var x1:Number = Defs.displayarea_w + 16;
			var y0:Number = 0 - 16;
			var y1:Number = Defs.displayarea_h + 16;
			var sx:Number = Game.camera.x;
			var sy:Number = Game.camera.y;
			var i:int;
			var j:int;
			for(i=0; i<max; i++)
			{				
				var p:Particle = list[i];
				if(p.active && p.visible )
				{
			
					var xp1:Number = (p.xpos - sx) * camScale;
					var yp1:Number = ( p.ypos - sy) * camScale;
					
					var sc:Number = camScale;
					
					if (p.dobj != null)
					{
						if (p.angle == 0 && p.alpha ==1 && p.scale == 1)
						{
							p.dobj.RenderAt( int(p.frame), bd, xp1, yp1);	
						}
						else
						{
							if (p.alpha == 1)
							{
								p.dobj.RenderAtRotScaled( int(p.frame), bd, xp1, yp1, p.scale, p.angle);								
							}
							else
							{
								ct.alphaMultiplier = p.alpha;
								p.dobj.RenderAtRotScaled( int(p.frame), bd, xp1, yp1, p.scale, p.angle, ct);
							}
						}
					}
				}
			}
		}
	}
	
	
}

