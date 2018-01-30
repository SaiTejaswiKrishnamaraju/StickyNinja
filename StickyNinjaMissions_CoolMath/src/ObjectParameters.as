package  
{
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class ObjectParameters
	{
		static var objparamList:Array;
		
		public function ObjectParameters() 
		{
			
		}
		
		
		public static function InitOnce()
		{
			LoadObjectParams();
		}
		
		public static function GetObjParamString(paramList:Array,defaultsList:Array):String
		{
			var i:int;
			var num:int = paramList.length;
			var s:String = "";
			for (i = 0; i < num; i++)
			{
				var pstr:String = paramList[i];
				var def:String = defaultsList[i];
				Utils.print("param " + pstr+" "+def);
				var op:ObjParam = GetObjectParamByName(pstr);
				s += op.name;
				s += "=";
				if (def != "")	// per-instance default overrides generic default:
				{
					s += def;
				}
				else
				{
					s += op.defaultValue;
				}
				if (i != num - 1)
				{
					s += ",";
				}				
			}
			return s;
		}
		public static function GetObjectParamByName(name:String):ObjParam
		{
			for each(var o:ObjParam in objparamList)
			{
				if (o.name == name) return o;
			}
			return null;
		}
		
		public static function GetDefault(name:String):String
		{
			for each(var o:ObjParam in objparamList)
			{
				if (o.name == name) 
				{
					return o.defaultValue;
				}
			}
			return null;
		}
		
		static public function AddParamBool(_name:String, _defaultValue:Boolean):void 
		{
			var _def:String = "false";
			if (_defaultValue == true) _def = "true";
			AddParam(_name, "bool", _def, "");
		}
		
		static public function AddParamAngle(_name:String, _defaultValue:Number):void
		{
			var op:ObjParam = AddParam(_name, "angle", _defaultValue.toString(), "");
			
		}
		static public function AddParamNumber(_name:String, _defaultValue:Number,_useRangeMin:Boolean,_useRangeMax:Boolean,_min:Number,_max:Number,_step:Number):void 
		{
			var op:ObjParam = AddParam(_name, "number", _defaultValue.toString(), "");
			op.number_useRangeMin = _useRangeMin;
			op.number_useRangeMax = _useRangeMax;
			op.number_min = _min;
			op.number_max = _max;
			op.number_step = _step;
			
		}
		
		static public function AddParamString(_name:String, _defaultValue:String):void 
		{
			AddParam(_name, "", _defaultValue, "");
		}

		static public function AddParamColor(_name:String, _defaultValue:String):void 
		{
			AddParam(_name, "color", _defaultValue, "");
		}
		
		static public function AddParam(_name:String,_type:String,_defaultValue:String,_values:String):ObjParam 
		{
			var op:ObjParam = GetObjectParamByName(_name);
			if (op != null) return op;
			
			op = new ObjParam();
			op.name = _name;
			op.type = _type;
			op.defaultValue = _defaultValue;
			op.AddValuesString(_values);
			objparamList.push(op);
			return op;
		}
		
		static public function LoadObjectParams()
		{
			objparamList = new Array();
			var x:XML = ExternalData.ObjectParamsXML;
			var num = x.objparam.length();
			for (var i:int = 0; i < num; i++)
			{
				var xx:XML = x.objparam[i];
				var op:ObjParam = new ObjParam();
				op.name = XmlHelper.GetAttrString(xx.@name, "");
				op.type = XmlHelper.GetAttrString(xx.@type, "");
				op.defaultValue = XmlHelper.GetAttrString(xx.@def, "");
				op.AddValuesString(XmlHelper.GetAttrString(xx.@values, ""));
				objparamList.push(op);
			}			
		}
		
		
	}

}