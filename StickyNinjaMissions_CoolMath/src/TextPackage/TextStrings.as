package TextPackage 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import UIPackage.UIX_Instance;
	/**
	 * ...
	 * @author 
	 */
	public class TextStrings 
	{
		
		[Embed(source = "../../bin/TextStrings.xml", mimeType = "application/octet-stream")] 
        static var class_embedded_XML:Class; 		
		
		
		static var xml:XML;
		public static var list:Vector.<TextString>;
		public static var dict:Dictionary;
		
		static var initialised:Boolean = false;

		public static var LANGUAGE_EN:int = 0;	// english
		public static var LANGUAGE_FR:int = 1;	// french
		public static var LANGUAGE_DE:int = 2;	// german
		public static var LANGUAGE_PT:int = 3;	// portuguese
		public static var LANGUAGE_ES:int = 4;	// spanish
		public static var LANGUAGE_NL:int = 5;	// dutch
		public static var LANGUAGE_TR:int = 6;	// turkish
		public static var LANGUAGE_SE:int = 7;	// swedish
		public static var LANGUAGE_IT:int = 8;	// italian
		
		public static var languageLabels = new Array(
					"en", "fr", "de", "pt", "es", "nl", "tr", "se","it");
		
		
		public static var currentLanguage:int = LANGUAGE_EN;
						
		public static function GetLabelFromIndex(index:int):String
		{
			return languageLabels[index];
		}
		
		public static var supportedLanguages:Array = new Array(
						LANGUAGE_EN,
						LANGUAGE_FR,
						LANGUAGE_DE,
						LANGUAGE_PT,
						LANGUAGE_ES,
						LANGUAGE_NL,
						LANGUAGE_TR,
						LANGUAGE_SE
						//LANGUAGE_IT
						);
		
		public function TextStrings() 
		{
			
		}
		
		public static function InitOnce()
		{
			list = new Vector.<TextString>();
			dict = new Dictionary();
			
			XML.ignoreWhitespace = true;
            xml = new XML(new class_embedded_XML()) as XML; 
			
			var num:int = xml.textstring.length();
			for (var i:int = 0; i < num; i++)
			{
				var x:XML;
				x = xml.textstring[i];
				var adt:TextString= new TextString();
				adt.FromXML(x);
				list.push(adt);
				dict[adt.name.toLowerCase()] = adt;
			}
			initialised = true;
		}
		
		public static function GetLocalisedText(str:String):String
		{
			var ts:TextString = dict[str.toLowerCase()];
			if (ts == null) return str;
			return ts.GetLocalisedText();
		}
		
		
		public static function GetTextString(str:String):TextString
		{
			if (dict == null) return null;
			var ts:TextString = dict[str];
			return ts;
		}

		
		public static function SetAnimatedButtonText(mc:MovieClip,strName:String = null)
		{
			if (initialised == false) return;
			var txt:TextString;
			if (strName == null)
			{
				if ( mc.buttonName == null) return;
				var s:String = mc.buttonName.text.toLowerCase();
				s = s.replace("\r", "");
				s = s.replace("\n", "");
				
				txt = GetTextString(s);
			}
			else
			{
				txt = GetTextString(strName);
			}
			if (txt != null)
			{
				mc.buttonName.text = txt.GetLocalisedText();
			}
		}
		
		public static function ReplaceInstText(inst:UIX_Instance, strName:String = null)
		{
			if (inst == null) return;
			var txt:TextString;
			var origStr:String = inst.GetText();
			if (strName == null)
			{
				
				var s:String = origStr.toLowerCase();
				s = s.replace("\r", "");
				s = s.replace("\n", "");				
				txt = GetTextString(s);
			}
			else
			{
				txt = GetTextString(strName);
			}
			
			if (txt != null)
			{
				inst.SetText(txt.GetLocalisedText());
			}
			else
			{
				if (strName != null)
				{
					inst.SetText(strName);
				}
			}
			
		}
		public static function ReplaceTextFieldText(tf:TextField,strName:String = null)
		{
			if (tf == null) return;
			var txt:TextString;
			if (strName == null)
			{
				
				var s:String = tf.text.toLowerCase();
				s = s.replace("\r", "");
				s = s.replace("\n", "");
				
				txt = GetTextString(s);
			}
			else
			{
				txt = GetTextString(strName);
			}
			
			if (txt != null)
			{
				tf.text = txt.GetLocalisedText();
			}
			else
			{
				if (strName != null)
				{
					tf.text = strName;
				}
			}
			

				
			if (tf.text == "\n") return;
			if (tf.text == "\r") return;
			if (tf.text == "") return;
			tf.text = tf.text.replace("\r", "");
			tf.text = tf.text.replace("\n", "");
			
			// fit to the text field
			var tFormat:TextFormat;
			
			var carryOn:Boolean = true;
			do
			{
				carryOn = true;
				if (tf.numLines != 1)
				{
					
					tFormat = tf.getTextFormat();
					
					var size:Number = tFormat.size as Number;
					size --;
					tFormat.size = size;
					tf.setTextFormat(tFormat);
					carryOn = false;
					if (size < 8)
					{
						carryOn = true;
					}
				}
			}while (carryOn == false)
			
		}
		
		
		
	}

}