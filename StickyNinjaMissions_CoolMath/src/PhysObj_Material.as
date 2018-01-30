package  
{
	import nape.phys.Material;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class PhysObj_Material
	{
		var name:String;
		var density:Number;
		var friction_dynamic:Number;
		var friction_static:Number;
		var friction_rolling:Number;
		var elasticity:Number;
		
		public function PhysObj_Material() 
		{
			name = "";
			density = 1;
			friction_dynamic = 1;
			friction_static = 1;
			friction_rolling = 1;
			elasticity = 0;
		}
		
		public function Clone():PhysObj_Material
		{
			var copy:PhysObj_Material = new PhysObj_Material();
			copy.name = name;
			copy.density = density;
			copy.friction_dynamic = friction_dynamic;
			copy.friction_static = friction_static;
			copy.friction_rolling = friction_rolling;
			copy.elasticity = elasticity;
			return copy;
		}
		
		public function FromXML(x:XML)
		{
			name = XmlHelper.GetAttrString(x.@name, "");
			density = XmlHelper.GetAttrNumber(x.@density, 1);
			friction_static = XmlHelper.GetAttrNumber(x.@friction_static, 1);
			friction_dynamic = XmlHelper.GetAttrNumber(x.@friction_dynamic, friction_static);
			friction_rolling = XmlHelper.GetAttrNumber(x.@friction_rolling, friction_dynamic);
			elasticity = XmlHelper.GetAttrNumber(x.@elasticity, 1);
			Utils.print(" Phys Material " + name + "  d:" + density + "  f:" + friction_static + "  el:" + elasticity);
		}
		
		public function MakeNapeMaterial():Material
		{
			var m:Material = new Material();
			m.density = density;
			m.dynamicFriction = friction_dynamic;
			m.rollingFriction = friction_rolling;
			m.staticFriction = friction_static;
			m.elasticity = elasticity;
			return m;
		}
		
	}

}