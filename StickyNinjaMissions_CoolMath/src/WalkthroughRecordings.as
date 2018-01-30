package  
{
	/**
	 * ...
	 * @author 
	 */
	public class WalkthroughRecordings
	{
		static var list:Vector.<WalkthroughRecording>;
		
		public function WalkthroughRecordings() 
		{
			
		}
		
		public static function InitOnce()
		{
			list = new Vector.<WalkthroughRecording>();
			LoadXML();
		}
		
		public static function GetByLevelName(name:String):WalkthroughRecording
		{
			for each(var r:WalkthroughRecording in list)
			{
				if (r.levelName == name) return r;
			}
			return null;
		}
		public static function AddRecording(r:WalkthroughRecording)
		{
			r.ExportXML();
			var i:int = 0;
			for each(var rr:WalkthroughRecording in list)
			{
				if (rr.levelName == r.levelName)
				{
					list[i] = r;
					
					return;
				}
				i++;
			}
			list.push(r);
//			ExportXML();

		}
		
		public static function LoadXML()
		{
			var i:int;
			var j:int;
			var x:XML = ExternalData.levelsXml;
			var num:int = x.recording.length();
			for (i = 0; i < x.recording.length(); i++)
			{				
				var rx:XML = x.recording[i];
				var r:WalkthroughRecording = new WalkthroughRecording(rx.@level);
				var poss:String = rx.@poss;
				var a:Array = poss.split(",");
				var numPositions:int = a.length / 3;
				//Utils.trace("array name = " + r.levelName);
				//Utils.trace("array len " + a.length + " " + numPositions);
				for (j = 0; j < numPositions; j++)
				{
					var xp:int = a[(j * 3) + 0];
					var yp:int = a[(j * 3) + 1];
					var b:int = a[(j * 3) + 2];
					var mb:Boolean = false;
					if (b == 1) mb = true;
					r.Add(xp, yp, mb);
				}
				list.push(r);
			}
			//Utils.trace("Recordings list len: " + list.length);

			for each (var l:Level in Levels.list)
			{
				var gotit:Boolean = false;
				for each(r in list)
				{
					if (r.levelName == l.name)
					{
						gotit = true;
					}
				}
				if (gotit == false)
				{
//					Utils.print("Missing Recording : " + l.name);
				}
			}
		}
		public static function ExportXML()
		{
			var sss:String = "";
			
			for each(var r:WalkthroughRecording in list)
			{
				sss += '<recording level="' + r.levelName + '"';
				sss += ' poss="';
				
				var i:int = 0;
				for each(var p:WalkthroughRecordingPoint in r.list)
				{
					var b:int = 0;
					if (p.mouseButton) b = 1;
					sss += p.x + "," + p.y + "," + b;
					if (i != r.list.length - 1)
					{
						sss += ",";
					}
					i++;
				}
				sss += '" />';
				sss += "\n";
				
			}
			Utils.print(sss);
			ExternalData.OutputString(sss);

			
		}
		
	}

}