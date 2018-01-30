package  
{
	/**
	 * ...
	 * @author 
	 */
	public class Tweener 
	{
		
		public var trackList:Array;		
		public var list:Array;		
		public var step:int;
		
		public function Tweener() 
		{
			trackList = new Array();
			step = 0;
		}

		public function Update():Boolean
		{
			if (trackList == null) return true;
			if (trackList.length == 0) return true;
			var ret:Boolean = false;
			
			var trueCount:int = 0;
			for each(var track:TweenTrack in trackList)
			{
				if (track.Update() == true)
				{
					trueCount++;
				}
			}
			if (trueCount == trackList.length)
			{
				return true;
			}
			return false;
		}
		
		
		
		public function AddStep(ts:TweenStep)
		{
			list.push(ts);
		}

		public function NewTrack(_go:GameObj_Base,_varName:String):TweenTrack
		{
			var tt:TweenTrack = new TweenTrack(_go,_varName);
			trackList.push(tt);
			return tt;
		}

		
	}

}