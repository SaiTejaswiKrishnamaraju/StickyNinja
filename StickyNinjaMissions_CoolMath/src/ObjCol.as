package  
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ObjCol 
	{
		var bodies:Array;
		var joints:Array;
		
		public function ObjCol() 
		{
			bodies = new Array();
			joints = new Array();
		}
		
		public function AddJoint(_x:Number, _y:Number, _type:int,b0:int,b1:int,vals:Array)
		{
			var j:ObjColJoint = new ObjColJoint();
			j.x = _x;
			j.y = _y;
			j.type = _type;
			j.b0 = b0;
			j.b1 = b1;
			
			if (j.type == 0)	// rotational
			{
				j.enableLimit = vals[0];
				j.lowerAngle = vals[1];
				j.upperAngle = vals[2];
				j.enableMotor = vals[3];
				j.motorSpeed = vals[4];
				j.maxMotorTorque = vals[5];
				
			}
			
			joints.push(j);
		}
		
		public function AddBody(_type:int,a:Array):ObjColBody
		{
			var body:ObjColBody = new ObjColBody();	
			body.type = _type;
			body.AddShape(a);
			bodies.push(body);
			return body;
		}

		
	}
	
}



