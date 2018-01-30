package EditorPackage 
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class ObjParameters
	{
		public var list:Vector.<ObjParameter>;
		
		public function ObjParameters() 
		{
			list = new Vector.<ObjParameter>();
		}
		
		public function CopyParamsToOriginalObject(obj:Object)
		{
			for each(var param:ObjParameter in list)
			{
				if (param.origVariableName != null)
				{
					if (param.origVariableType == "number")
					{
						param.value = String(obj[param.origVariableName]);
					}
					else if (param.origVariableType == "vector3")
					{
						var v3d:Vector3D = obj[param.origVariableName]
						param.value = v3d.x + "." + v3d.y + "." + v3d.z;
					}
					else
					{
						param.value = String(obj[param.origVariableName]);
					}
				}
			}			
		}
		public function ParameterChanged(param:ObjParameter,obj:Object)
		{
			if (Exists(param.name))
			{
				SetParam(param.name, param.value)
				param.multipleValues = false;
				
				
				if (param.origVariableName != null)
				{
					if (param.origVariableType == "number")
					{
						obj[param.origVariableName] = param.value;
					}
					else if (param.origVariableType == "vector3")
					{
						var a:Array = param.value.split(".");
						obj[param.origVariableName].x = a[0];
						obj[param.origVariableName].y = a[1];
						obj[param.origVariableName].z = a[2];
					}
					else
					{
						obj[param.origVariableName] = param.value;
					}
				}
			}
			
		}
		
		
		public function AddMultiParameters(otherParams:ObjParameters)
		{
			if (otherParams == null) return;
			for each(var p:ObjParameter in otherParams.list)
			{
				var shouldAdd:Boolean = true;
				for (var i:int = 0; i < list.length; i++)
				{
					var origp:ObjParameter = list[i];
					
					if (p.origVariableName != null)
					{
						var aa:int = 0;
					}
					
					if (origp.name == p.name)
					{
						// parameter already exists
						if (origp.value == p.value)
						{
							
						}
						else
						{						
							origp.value = "----";
							origp.multipleValues = true;
						}
						
						shouldAdd = false;
					}
				}
				
				if (shouldAdd)
				{
					
					Add(p.name, p.value,false,p.origVariableName,p.origVariableType);
				}
			}
			
		}
		
		
		
		
		public function Clone():ObjParameters
		{
			var op:ObjParameters = new ObjParameters();
			
			op.list = new Vector.<ObjParameter>();
			for each(var p:ObjParameter in list)
			{
				op.list.push(p.Clone());
			}
			return op;			
		}
		
		public function GetByIndex(index:int):ObjParameter
		{
			return list[index];
		}
		public function ClearAll()
		{
			list = new Vector.<ObjParameter>();
		}
		public function AddOrSet(name:String, value:String)
		{
			if (value == null)	// get absolute devault
			{
				value = ObjectParameters.GetDefault(name);
			}
			for (var i:int = 0; i < list.length; i++)
			{
				var p:ObjParameter = list[i];
				if (p.name == name)
				{
					p.value = value;
					return;
				}
			}
			Add(name, value);
		}
		
		public function Add(name:String, value:String,_temporary:Boolean=false,_origVariableName:String=null,_origVariableType:String="number")
		{
			if (value == null)	// get absolute devault
			{
				value = ObjectParameters.GetDefault(name);
			}
			var op:ObjParameter = new ObjParameter();
			op.name = name;
			op.value = value;
			op.temporary = _temporary;
			op.origVariableName = _origVariableName;
			op.origVariableType = _origVariableType;
			list.push(op);
		}
		
		public function ToString():String
		{
			var s:String = "";
			
			var a:Array = new Array();
			for each(var p:ObjParameter in list)
			{
				if (p.temporary == false)
				{
					a.push(p);
				}				
			}
			
			
			for (var i:int = 0; i < a.length; i++)
			{
				var p:ObjParameter = a[i];
				s += p.name;
				s += "=";
				s += p.value;
				if (i != a.length - 1) s += ",";
			}
			return s;
		}
		public function ToStringAll():String
		{
			var s:String = "";
			
			var a:Array = new Array();
			for each(var p:ObjParameter in list)
			{
				a.push(p);
			}
			
			
			for (var i:int = 0; i < a.length; i++)
			{
				var p:ObjParameter = a[i];
				s += p.name;
				s += "=";
				s += p.value;
				if (i != a.length - 1) s += ",";
			}
			return s;
		}
		
		public function ValuesFromString(s:String)
		{
			Utils.GetParams(s);
			
			for (var i:int = 0; i < list.length; i++)
			{
				var p:ObjParameter = list[i];
				if (Utils.GetParamExists(p.name))
				{
					p.value = Utils.GetParamString(p.name, p.value);
				}
			}
		}

		public function CreateAllFromString(s:String)
		{
			Utils.GetParams(s);

			ClearAll();
			for (var i:int = 0; i < Utils.paramNames.length; i++)
			{
				AddOrSet(Utils.paramNames[i], Utils.paramValues[i]);
			}
		}
		
		public function SetValueBoolean(param:String,val:Boolean)
		{
			var s:String = "false";
			if (val == true) s = "true";
			SetParam(param, s);
		}
		public function SetValueString(param:String,val:String)
		{
			SetParam(param, val);
		}
		public function SetValueNumber(param:String,val:Number)
		{
			var n:String = String(val);
			SetParam(param, n);
		}
		public function SetValueInt(param:String,val:int)
		{
			var i:String = String(val);
			SetParam(param, i);
		}
		
		public function GetValueBoolean(param:String):Boolean
		{
			var s:String = GetParam(param);
			if (s == "true") return true;
			return false;
		}
		public function GetValueString(param:String,_default:String=""):String
		{
			var s:String = GetParam(param);
			return s;
		}
		public function GetValueNumber(param:String):Number
		{
			var s:String = GetParam(param);			
			return Number(s);
		}
		public function GetValueInt(param:String,_default:int=0):int
		{
			var s:String = GetParam(param);			
			return int(s);
		}
		
		
		
		function Exists(param:String):Boolean
		{
			for (var i:int = 0; i < list.length; i++)
			{
				var p:ObjParameter = list[i];
				if (p.name == param) return true;
			}
			return false;
		}
		function GetParam(param:String):String
		{
			for (var i:int = 0; i < list.length; i++)
			{
				var p:ObjParameter = list[i];
				if (p.name == param) return p.value;
			}
			return "";
		}

		function GetParamInstance(param:String):ObjParameter
		{
			for (var i:int = 0; i < list.length; i++)
			{
				var p:ObjParameter = list[i];
				if (p.name == param) return p;
			}
			return null;
		}
		
		function SetParam(param:String,val:String):String
		{
			for (var i:int = 0; i < list.length; i++)
			{
				var p:ObjParameter = list[i];
				if (p.name == param)
				{
					p.value = val;
				}
			}
			return "";
		}
		
	}

}