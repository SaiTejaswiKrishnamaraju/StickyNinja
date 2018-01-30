package  
{
	/**
	 * ...
	 * @author 
	 */
	public class WalkthroughRecording 
	{
		var levelName:String;
		var list:Vector.<WalkthroughRecordingPoint>;
		var time:int;
		var playbackPos:int;
		
		public function WalkthroughRecording(_levelName:String) 
		{
			levelName = _levelName;
			list = new Vector.<WalkthroughRecordingPoint>();
			time = 0;
		}
		
		public function Add(_x:int,_y:int,_button:Boolean) 
		{
			var p:WalkthroughRecordingPoint = new WalkthroughRecordingPoint(_x, _y, _button, time);
			list.push(p);
			time++;
		}
		
		public function StartPlayback()
		{
			playbackPos = 0;
		}
		public function HasFinished():Boolean
		{
			if (playbackPos >= list.length - 1) return true;
			return false;
		}
		public function GetNextPoint():WalkthroughRecordingPoint
		{
			if(list.length == 0) return new WalkthroughRecordingPoint(0, 0, false, 0);
			var pos:int = playbackPos;
			if (pos < 0) pos = 0;
			if (pos >= list.length) pos = list.length - 1;
			
			var p:WalkthroughRecordingPoint = list[pos];
			playbackPos++;
			return p;
			
		}

		public function ExportXML()
		{
			var sss:String = "";
			
			sss += '<recording level="' + levelName + '"';
			sss += ' poss="';
			
			var i:int = 0;
			for each(var p:WalkthroughRecordingPoint in list)
			{
				var b:int = 0;
				if (p.mouseButton) b = 1;
				sss += p.x + "," + p.y + "," + b;
				if (i != list.length - 1)
				{
					sss += ",";
				}
				i++;
			}
			sss += '" />';
			sss += "\n";
				
			Utils.print(sss);
			ExternalData.OutputString(sss);
		}
		
		
	}

}