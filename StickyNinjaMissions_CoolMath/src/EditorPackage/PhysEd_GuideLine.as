package EditorPackage 
{
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class PhysEd_GuideLine
	{
		public var x0:Number;
		public var x1:Number;
		public var y0:Number;
		public var y1:Number;
		public var type:int;	// 0 = horiz, 1 = vert
		public var level:Boolean;
		
		public function PhysEd_GuideLine(l0:Number, l1:Number, p:Number, _type:Number,_level:Boolean)
		{
			type = _type;
			level = _level;
			if (type == 0)
			{
				x0 = l0;
				x1 = l1;
				y0 = p;
				y1 = p;
			}
			else
			{
				y0 = l0;
				y1 = l1;
				x0 = p;
				x1 = p;			
			}
		}
	}

}