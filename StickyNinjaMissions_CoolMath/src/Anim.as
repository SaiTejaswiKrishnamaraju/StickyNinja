package  
{
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class Anim
	{
		var name:String;
		var minFrame:int;
		var maxFrame:int;
		var speed:Number;
		
		public function Anim(_n:String,_min:int,_max:int,_spd:Number=1) 
		{
			name = _n;
			minFrame = _min-1;
			maxFrame = _max-1;
			speed = _spd;
		}
		
	}

}