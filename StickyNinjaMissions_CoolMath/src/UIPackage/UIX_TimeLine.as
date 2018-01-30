package UIPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class UIX_TimeLine 
	{
		var instanceName:String;
		var positions:Vector.<UIX_TimeLinePos>;
		
		public function UIX_TimeLine() 
		{
			instanceName = "";
			positions = new Vector.<UIX_TimeLinePos>();
		}
		
		public function FromXML(xml:XML)
		{
			instanceName = XmlHelper.GetAttrString(xml.@instance, "");
			
			positions = new Vector.<UIX_TimeLinePos>();
			
			var num:int = xml.timepos.length();
			for (var i:int = 0; i < num; i++)
			{
				var x:XML = xml.timepos[i];
				var pos:UIX_TimeLinePos= new UIX_TimeLinePos();
				pos.FromXML(x);
				positions.push(pos);
			}			
		}
		
		public function ToXML():String
		{
			var s:String = "";
			s += '<timeline instance="' + instanceName +'"> ';
			
			for each( var pos:UIX_TimeLinePos in positions)
			{
				s += pos.ToXML();
				s += " ";
			}
			
			s += '</timeline>';
			return s;			
			
		}
		
		
	}

}