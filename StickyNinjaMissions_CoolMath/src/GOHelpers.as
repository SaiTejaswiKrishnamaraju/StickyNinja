package  
{
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.shape.Circle;
	/**
	 * ...
	 * @author 
	 */
	public class GOHelpers 
	{
		
		public function GOHelpers() 
		{
			
		}
		
		
		public static function DoExplosion(origGO:GameObj, centreX:Number, centreY:Number, maxRadius:Number, maxForce:Number)
		{
			var v:Vec = new Vec();
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active && go != origGO)
				{
					var dx:Number = go.xpos - centreX;
					var dy:Number = go.ypos - centreY;
					
					v.SetFromDxDy(dx, dy);
					if (v.speed <= maxRadius)
					{
						v.speed = maxForce;
						go.ApplyImpulse(v.X(), v.Y() );	
						
						Utils.print( v.X()+" "+ v.Y() +"   "+v.speed);	
					}
					
				}
			}
		}
		
	}

}