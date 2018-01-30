package  
{
	/**
	 * ...
	 * @author 
	 */
	public class SurfaceParameter 
	{
		public var polyTypeName:String;
		public var particleName:String;
		public var particleMass:Number;
		public var particleFrequency:Number;
		
		public var landForce:Number;	// 0-1
		public var landAmtOfParticles0:int;	// 0-x
		public var landAmtOfParticles1:int;	// 0-x
		
		public var skidFrequency:Number;	// 0-1
		
		public function SurfaceParameter() 
		{
			SetLandParams();
			SetSkidParams();
		}
		
		public function SetLandParams(a:Number=1,b:int=5,c:int=10)
		{
			landForce = a;
			landAmtOfParticles0 = b;
			landAmtOfParticles1 = c;
		}

		public function SetSkidParams(a:Number=0.5)
		{
			skidFrequency = a;
		}
		
	}

}