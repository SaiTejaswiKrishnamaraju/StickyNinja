package  
{
	import UIPackage.UIX_Instance;
	/**
	 * ...
	 * @author 
	 */
	public class PlayerBoost 
	{
		public var value:int;
		public var inUse:Boolean;
		public var index:int;
		public var hudInst:UIX_Instance;
		public var maxValue:int;
		
		public function PlayerBoost(_index:int,_initFull:Boolean) 
		{
			maxValue = 5;
			value = 0;
			if (_initFull) value = maxValue;
			
			
			inUse = false;
			index = _index;
			hudInst = null;
		}
		
	}

}