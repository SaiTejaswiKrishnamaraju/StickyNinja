package TextPackage 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class TextString 
	{
		var name:String;
		var dictionary:Dictionary;
		
		public function TextString() 
		{
			
		}
		public function FromXML(x:XML)
		{
			dictionary = new Dictionary();
			
			name = XmlHelper.GetAttrString(x.@name, "");
			var attrs:XMLList = x.attributes();
			for each(var label:String in TextStrings.languageLabels)
			{
				
				 for each (var attr : XML in attrs)
				{
					if (attr.name() == label)
					{
						var s:String = attr.valueOf();
						s = s.replace("ß", "ss");
						
						dictionary[label] = s;
					}
				}
			}
			
			if (dictionary["en"] == "")
			{
				dictionary["en"] = name;
			}
			
			/*
			english = XmlHelper.GetAttrString(x.@eng, "");
			french = XmlHelper.GetAttrString(x.@fre, "");
			spanish = XmlHelper.GetAttrString(x.@esp, "");
			portuguese = XmlHelper.GetAttrString(x.@por, "");
			turkish = XmlHelper.GetAttrString(x.@tur, "");
			polish = XmlHelper.GetAttrString(x.@pol, "");
			*/
		}
		
		public function GetLocalisedText():String
		{
			return dictionary[TextStrings.languageLabels[TextStrings.currentLanguage]];
//			return name;
		}
		
	}

}