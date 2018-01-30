package  
{
	/**
	 * ...
	 * @author 
	 */
	public class TweenTrack 
	{
		public var timer:Number;
		public var totalTime:Number;
		public var easeName:String;
		public var easeValue:Number;
		public var type:String;
		
		public var list:Array;
		
		public var step:int;
		public var value:Number;
		public var varName:String;
		
		public var go:GameObj_Base;
		public var variableName:String;
		
		public function TweenTrack(_go:GameObj_Base,_varName:String) 
		{
			go = _go;
			variableName = _varName;
			list = new Array();
		}
		
		public function Update():Boolean
		{
			if (list == null) return true;
			if (list.length == 0) return true;
			if (step >= list.length) return true;
			var ts:TweenStep = list[step];
			var done:Boolean = ts.Update();
						
			if (ts.type == "value")
			{
				value = ts.val;
				go[variableName] = value;
			}
			else
			{
				go[variableName] = value;				
			}
			
			if (done)
			{
				step++;
				if (step >= list.length) return true;
			}
			return false;
		}
		
		public function Set(_val:Number)
		{
			value = _val;
		}
		
		public function AddStep_Pause(_timeSeconds:Number)
		{
			var step:TweenStep = new TweenStep();
			step.InitPause(_timeSeconds);
			list.push(step);
		}

		public function AddStep(_v0:Number,_v1:Number, _timeSeconds:Number, _easeName:String, _easeValue:Number)
		{
			var step:TweenStep = new TweenStep();
			step.Init(_v0,_v1,_timeSeconds,_easeName,_easeValue);
			list.push(step);
		}

		public function AddStep_Set(_value:Number,_timeSeconds:Number)
		{
			var step:TweenStep = new TweenStep();
			step.InitSet(_value,_timeSeconds);
			list.push(step);
		}
		
	}

}