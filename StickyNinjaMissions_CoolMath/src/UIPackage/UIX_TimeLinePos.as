package UIPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class UIX_TimeLinePos 
	{
		public var timeSeconds:Number;
		public var functionName:String;
		public var functionData:String;
		
		public function UIX_TimeLinePos() 
		{
			timeSeconds = 0;
			functionName = "";
			functionData = "";
		}
		
		public function FromXML(xml:XML)
		{
			timeSeconds = XmlHelper.GetAttrNumber(xml.@time, 0);
			functionName = XmlHelper.GetAttrString(xml.@func, "");
			functionData = XmlHelper.GetAttrString(xml.@data, "");
			trace(timeSeconds + " " + functionName + " " + functionData);
		}
		
		public function ToXML():String
		{
			var s:String = "";
			s += '<timepos time="' + timeSeconds +'" ';
			s += 'func="' + functionName +'" ';
			s += 'data="' + functionData +'"/>';			
			return s;			
		}
		
		
	}

}