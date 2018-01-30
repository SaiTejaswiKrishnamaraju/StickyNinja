package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class HintPopup 
	{
		var text:String;
		var shown:Boolean;
		
		var timer:int;
		var active:Boolean;
		var mc:MovieClip;
		
		public function HintPopup(_text:String) 
		{
			text = _text;
			shown = false;
			active = false;
			timer = 0;
		}
		
		public function Clone():HintPopup
		{
			var clone:HintPopup = new HintPopup("");
			clone.text = text;
			return clone;
		}
		
	}

}