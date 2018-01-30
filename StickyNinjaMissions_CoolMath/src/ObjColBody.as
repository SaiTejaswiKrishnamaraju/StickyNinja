package  
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	class ObjColBody
	{
		var type:int;
		var shapes:Array;
		public function ObjColBody()
		{
			shapes = new Array();
		}
		public function AddShape(a:Array)
		{
			var b:Array = new Array;
			for each(var p:Point in a)
			{
				b.push(p.clone());
			}
			shapes.push(b);		
		}
		
	}
	
}