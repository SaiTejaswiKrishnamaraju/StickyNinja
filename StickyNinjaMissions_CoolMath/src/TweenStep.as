package  
{
	/**
	 * ...
	 * @author 
	 */
	public class TweenStep 
	{
		public var val:Number;
		public var val0:Number;
		public var val1:Number;
		public var timer:Number;
		public var totalTime:Number;
		public var easeName:String;
		public var easeValue:Number;
		public var type:String;
		
		public function TweenStep() 
		{
			
		}
		
		public function Init(_v0:Number,_v1:Number, _timeSeconds:Number, _easeName:String, _easeValue:Number)
		{
			type = "value";
			val = val0 = _v0;
			val1 = _v1;
			timer = 0;
			totalTime = _timeSeconds * Defs.fps;
			easeName = _easeName;
			easeValue = _easeValue;
		}
		public function InitPause( _timeSeconds:Number)
		{
			type = "pause";
			timer = 0;
			totalTime = _timeSeconds * Defs.fps;
			easeName = "linear";
			easeValue = 1;
		}
		public function InitSet( _value:Number,_timeSeconds:Number)
		{
			type = "value";
			val = val0 = _value;
			val1 = _value;
			timer = 0;
			totalTime = _timeSeconds * Defs.fps;
			easeName = Ease.EASE_LINEAR;
			easeValue = 0;
		}
		public function SetValue(_v:Number)
		{
			type = "value";
			val = val0 = _v;
			val1 = _v;
		}
		
		
		public function Update():Boolean
		{
			timer++;
			if (timer >= totalTime)
			{
				timer = totalTime;
			}
			
			if (type == "value")
			{			
				var v:Number = Utils.ScaleTo(0, 1, 0, totalTime, timer);
				v = Ease.EaseByName(easeName, v, easeValue);
				val = Utils.ScaleTo(val0, val1, 0, 1, v);
				if (timer == totalTime) return true;
			}
			else if (type == "pause")
			{
				if (timer == totalTime) return true;
			}
			return false;			
		}
		
	}

}