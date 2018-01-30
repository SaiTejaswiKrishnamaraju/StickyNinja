package  
{
	import EditorPackage.PolyMaterials;
	/**
	 * ...
	 * @author 
	 */
	public class PolyDefs 
	{
		public static var instanceParams:Array;
		public static var instanceParamsDefaults:Array;
		
		public function PolyDefs() 
		{
			
		}
		
		public static function InitOnce()
		{
			instanceParams = new Array();
			instanceParamsDefaults = new Array();

			ObjectParameters.AddParam("line_material", "materiallist", PolyMaterials.GetNameByIndex(0), PolyMaterials.GetMaterialNameList());
			ObjectParameters.AddParamBool("line_spline", false);
			ObjectParameters.AddParamNumber("surface_depth",20,false,false,0,0,1);
			ObjectParameters.AddParamNumber("surface_random", 20,false,false,0,0,1);
			ObjectParameters.AddParamNumber("poly_tex_rotation", 0,true,true,0,360,10);
			ObjectParameters.AddParamNumber("poly_tex_scale", 1,false,false,0,0,1);
			
			instanceParams.push("editor_layer");
			instanceParamsDefaults.push("1");
			instanceParams.push("game_layer");
			instanceParamsDefaults.push("Centre");
			instanceParams.push("line_material");
			instanceParamsDefaults.push(PolyMaterials.GetNameByIndex(0));
			instanceParams.push("line_spline");
			instanceParamsDefaults.push("false");
		
			
			instanceParams.push("surface_depth");
			instanceParamsDefaults.push("40");
			instanceParams.push("surface_random");
			instanceParamsDefaults.push("20");

			instanceParams.push("poly_tex_rotation");
			instanceParamsDefaults.push("0");
			instanceParams.push("poly_tex_scale");
			instanceParamsDefaults.push("1");
			
		}

		
	}

}