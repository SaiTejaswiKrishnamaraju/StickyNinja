package
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PhysObj_Body 
	{
		public var name:String;
		public var shapes:Array;
		public var fixed:Boolean;
//		public var linearDamping:Number;
//		public var angularDamping:Number;
		
		public var pos:Point;
		
		
		
		public function PhysObj_Body() 
		{
			shapes = new Array();
			name = "";
			pos = new Point();
			fixed = true;
//			linearDamping = 0.1;
//			angularDamping = 1;
		}
		
		public function ToXML():String
		{
			var s:String = "";
			s += '<body name="' + name + '" ';
			s += 'pos="' + pos.x+','+pos.y + '" ';
			s += 'fixed="' + fixed + '" ';
			s += ">";
			s += '\n';
			
			var t:String = "\t\t";
			
			for each(var shape:PhysObj_Shape in shapes)
			{
				s += t + shape.ToXML();
				
			}
			
			t= "\t";
			
			s += t+'</body>';
			s += '\n';
			return s;
		}
		
	}
	
}