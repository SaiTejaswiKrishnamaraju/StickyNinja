package EditorPackage 
{
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class ObjParameter
	{
		public var name:String;
		public var value:String;
		public var multipleValues:Boolean;
		public var temporary:Boolean;
		public var origVariableName:String;
		public var origVariableType:String;
		
		public function ObjParameter() 
		{
			multipleValues = false;
			temporary = false;
			origVariableName = null;
			origVariableType = "number";
		}
		public function Clone():ObjParameter
		{
			var p:ObjParameter = new ObjParameter();
			p.name = name;
			p.value = value;
			p.multipleValues = multipleValues;
			p.temporary = temporary;
			p.origVariableName = origVariableName;
			p.origVariableType = origVariableType;
			return p;			
		}
		
		public function SetOriginalValue(o:Object)
		{
			if (origVariableName == null) return;
			if (origVariableName == "") return;
			if (origVariableType == "number") o[origVariableName] = Number(value);
			if (origVariableType == "bool") 
			{
				if (value == "true") o[origVariableName] = true;
				if (value == "false") o[origVariableName] = false;
			}
			if (origVariableType == "int") o[origVariableName] = int(value);
			if (origVariableType == "string") o[origVariableName] = value;
		}

	}

}