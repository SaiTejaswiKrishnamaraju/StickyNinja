package  
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class PhysObj_BodyUserData 
	{
		public var type:String;
		public var bodyName:String;
		public var gameObjectIndex:int;
		public var gameObject:GameObj;
		public var id:int;	// generic ID
		public var independantGO:GameObj;
		
		public function PhysObj_BodyUserData() 
		{
			type = "";
			bodyName = "";
			gameObjectIndex = -1;
			id = 0;
			independantGO = null;
			gameObject = null;
		}
		
		public function Clone():PhysObj_BodyUserData
		{
			var copy:PhysObj_BodyUserData = new PhysObj_BodyUserData();
			copy.type = type;
			copy.bodyName = bodyName;
			copy.gameObjectIndex = gameObjectIndex;
			copy.id = id;
			copy.independantGO = independantGO;
			return copy;
		}
		
	}
	
}