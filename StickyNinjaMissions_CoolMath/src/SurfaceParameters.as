package  
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class SurfaceParameters 
	{
		public static var dict:Dictionary;
		
		
		public function SurfaceParameters() 
		{
			
		}
		
		public static function AddSurface(_name:String,_pname:String,_mass:Number,_freq:Number)
		{
			var param:SurfaceParameter = new SurfaceParameter();
			param.polyTypeName = _name;
			param.particleName = _pname;
			param.particleMass = _mass;
			param.particleFrequency = _freq;
			dict[_name] = param;
			return param;
		}
		public static function GetByPolyTypeName(name:String):SurfaceParameter
		{
			return dict[name];
		}
		public static function InitOnce()
		{
			dict = new Dictionary();
			var sf:SurfaceParameter;
			
			var normalAmt:Number = 0.01;
			
			sf = AddSurface("poly_surface_1", "fx_surface_1", 1, normalAmt);
			sf.SetLandParams(1,5,10);
			sf.SetSkidParams(1);
			sf=AddSurface("poly_surface_2", "fx_surface_2", 1, normalAmt);
			sf=AddSurface("poly_surface_3", "fx_surface_3", 1, normalAmt);
			sf=AddSurface("poly_surface_4", "fx_surface_4", 1, normalAmt);
			sf=AddSurface("poly_surface_5", "fx_surface_5", 1, normalAmt);
			sf=AddSurface("poly_surface_6", "fx_surface_6", 1, normalAmt);
			sf=AddSurface("poly_surface_7", "fx_surface_7", 1, normalAmt);
			sf=AddSurface("poly_surface_8", "fx_surface_8", 1, normalAmt);
			sf=AddSurface("poly_surface_9", "fx_surface_8", 1, normalAmt);
			
			sf=AddSurface("poly_collide_1", "fx_surface_1", 1, normalAmt);
			sf=AddSurface("poly_collide_2", "fx_surface_2", 1, normalAmt);
			sf=AddSurface("poly_collide_3", "fx_surface_3", 1, normalAmt);
			sf=AddSurface("poly_collide_4", "fx_surface_4", 1, normalAmt);
			sf=AddSurface("poly_collide_5", "fx_surface_5", 1, normalAmt);
			sf=AddSurface("poly_collide_6", "fx_surface_6", 1, normalAmt);
			sf=AddSurface("poly_collide_7", "fx_surface_7", 1, normalAmt);
			sf=AddSurface("poly_collide_8", "fx_surface_8", 1, normalAmt);
			
			sf=AddSurface("poly_collide_mud", "fx_surface_mud", 1, normalAmt);
			sf=AddSurface("poly_collide_ice", "fx_surface_ice", 1, normalAmt);
			//AddSurface("poly_collide_dirt", "fx_surface_dirt", 1, 1);
			//AddSurface("poly_collide_water", "fx_surface_1", 1, 1);
		}
		
	}

}