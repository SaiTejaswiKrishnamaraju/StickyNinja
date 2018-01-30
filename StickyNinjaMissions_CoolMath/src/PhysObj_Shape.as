package
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PhysObj_Shape 
	{
		public static const Type_Poly:int = 0;
		public static const Type_Circle:int = 1;
		
		public var type:int;
		public var name:String;
		public var collisionCategory:int;
		public var collisionMask:int;
		public var sensorCategory:int;
		public var sensorMask:int;
		public var fluidCategory:int;
		public var fluidMask:int;
		public var shiftCOM:Boolean;		// shift centre of mass when creating object
		
		public var materialName:String;
		
		public var poly_points:Array;
		public var poly_rot:Number;
		
		public var circle_pos:Point;
		public var circle_radius:Number;
		
		public function PhysObj_Shape() 
		{
			type = 0;
			name = "";
			poly_points = new Array();
			circle_pos = new Point();
			circle_radius = 0;
			poly_rot = 0;
			collisionCategory = 0;
			collisionMask = 0;
			materialName = "";
			shiftCOM = false;
		}
		

		
		public function ToXML():String
		{
			var s:String = "";
			var t:String = "";

			var typename:String;
			
			if (type ==  Type_Circle) typename = "circle";
			if (type ==  Type_Poly) typename = "poly";
			
			s += '<shape type="' + typename+ '" ';
			s += 'name="' + name + '" ';
			s += 'col="' + collisionCategory + ',' + collisionMask + '" ';
			s += 'sensor="' + sensorCategory + ',' + sensorMask + '" ';
			s += 'shiftcom="' + shiftCOM + '" ';

			if (typename == "circle")
			{
				s += 'pos="' + circle_pos.x + ',' + circle_pos.y + '" ';
				s += 'radius="' + circle_radius + '" ';
			}
			
			//vertices="-15,-10, 15,-10, 15,0, -15,0"
			if (typename == "poly")
			{
				s += 'rot="' + poly_rot + '" ';				
				s += 'vertices="';
				for (var i:int = 0; i < poly_points.length; i++)
				{
					var p:Point = poly_points[i];
					s += p.x + ',' + p.y;
					if (i != poly_points.length - 1)
					{
						s += ', ';
					}
				}
				s += '" ';
				
			}
			
			s += 'material="' + materialName + '" />';
			s += '\n';
			
			return s;
		}
		
		public function Caclulate()
		{
			if (type == Type_Poly)
			{
				var m:Matrix = new Matrix();
				m.rotate(poly_rot);
				var newpts:Array = new Array();
				for each(var p:Point in poly_points)
				{
					var p1:Point = m.transformPoint(p);
					newpts.push(p1);
				}
				poly_points = newpts;
			}
		}
		
	}
	
}