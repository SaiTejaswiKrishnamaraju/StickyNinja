package  
{
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class ObjParam
	{
		public var name:String;
		public var type:String;
		public var defaultValue:String;
		public var valueList:Array;
		
		public var number_useRangeMin:Boolean;
		public var number_useRangeMax:Boolean;
		public var number_min:Number;
		public var number_max:Number;
		public var number_step:Number;
		
		public function ObjParam() 
		{
			name = "";
			type = "";
			defaultValue = "";
			valueList = new Array();
			
			number_useRangeMin = false;
			number_useRangeMax = false;
			number_min = 0;
			number_max = 0;
			number_step = 1;
		}
		
		public function AddValuesString(vals:String):void 
		{
			if (vals == null) return;
			if (vals == "") return;
			valueList = vals.split(",");
		}
		
	}

}