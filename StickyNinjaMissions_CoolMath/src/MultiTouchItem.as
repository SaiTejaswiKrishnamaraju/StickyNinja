package  
{
	/**
	 * ...
	 * @author 
	 */
	public class MultiTouchItem 
	{
		public var touchID:int;
		public var x:Number;
		public var y:Number;
		public var justPressed:Boolean;
		
		
		public function MultiTouchItem() 
		{
			MakeInactive();
		}
		
		public function MakeInactive()
		{
			touchID = -1;
			justPressed = false;
		}

		public function IsActive():Boolean
		{
			return (touchID != -1);
		}
		
	}

}