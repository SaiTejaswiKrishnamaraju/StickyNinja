package EditorPackage 
{
	/**
	 * ...
	 * @author ...
	 */
	public class PolyMaterials 
	{
		static var list:Vector.<PolyMaterial>
		
		public function PolyMaterials() 
		{
			
		}
		public static function GetByName(name:String)
		{
			for each(var pm:PolyMaterial in list)
			{
				if (pm.name == name) return pm;
			}
			return null;
		}
		
		
		
		public static function GetNameByIndex(index:int):String
		{
			return list[index].name;
		}
		public static function GetMaterialNameList():String
		{
			var s:String = "";
			var max:int = list.length;
			for (var i:int = 0; i < max; i++)
			{
				var pm:PolyMaterial = list[i];
				s += pm.name;
				if (i != max - 1) s += ",";
			}
			return s;
		}
		public static function InitOnce()
		{
			var x:XML = ExternalData.PolyMaterialsXML;
			list = new Vector.<PolyMaterial>();
			
			for (var i:int = 0; i < x.polymat.length(); i++)
			{
				var mx:XML = x.polymat[i];
				var matobj:PolyMaterial = new PolyMaterial();
				
				matobj.instanceParams = new Array();
				matobj.instanceParamsDefaults = new Array();

				
				matobj.name = XmlHelper.GetAttrString(mx.@name, "");
				matobj.materialName = XmlHelper.GetAttrString(mx.@material, "average");
				matobj.initFunctionName = XmlHelper.GetAttrString(mx.@initfunction, "");
				matobj.editorRenderFunctionName = XmlHelper.GetAttrString(mx.@editorrender, null);
				
				matobj.graphicName = XmlHelper.GetAttrString(mx.@clip, "");
				matobj.initType = XmlHelper.GetAttrString(mx.@inittype, "poly");
				matobj.edType = XmlHelper.GetAttrString(mx.@edtype, "poly");
				
				matobj.fillFrame = 0;
				matobj.fillFrame1 = 0;
				matobj.fillFrame2 = 0;
				
				var fs:String = XmlHelper.GetAttrString(mx.@frame, "1");
				
				matobj.fillName = fs;
				
				var fsa:Array = fs.split(",");
				if (fsa.length >= 1) matobj.fillFrame = fsa[0]-1;
				if (fsa.length >= 2) matobj.fillFrame1 = fsa[1]-1;
				if (fsa.length >= 3) matobj.fillFrame2 = fsa[2]-1;
				
				
				matobj.fixed = XmlHelper.GetAttrBoolean(mx.@fixed, true);
				matobj.defaultGameLayer = XmlHelper.GetAttrString(mx.@gamelayer, "Centre");
				
				var s:String = XmlHelper.GetAttrString(mx.@col, "0,0");
				var a:Array = s.split(",");

				var s1:String = XmlHelper.GetAttrString(mx.@sensor, "0,0");
				var a1:Array = s1.split(",");

				var s2:String = XmlHelper.GetAttrString(mx.@fluid, "0,0");
				var a2:Array = s2.split(",");
				
				matobj.collisionCategory = int(a[0]);
				matobj.collisionMask = int(a[1]);

				matobj.sensorCategory = int(a1[0]);
				matobj.sensorMask = int(a1[1]);
				
				matobj.fluidCategory = int(a2[0]);
				matobj.fluidMask = int(a2[1]);
				
				
				for (var j:int = 0; j < mx.parameter.length(); j++)
				{
					var px:XML = mx.parameter[i];
					matobj.instanceParams.push(XmlHelper.GetAttrString(px.@name, ""));
					matobj.instanceParamsDefaults.push(XmlHelper.GetAttrString(px.@def, ""));
				}
				
				list.push(matobj);
			}			
		}
		
		
	}

}