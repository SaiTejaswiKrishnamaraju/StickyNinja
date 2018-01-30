package  
{
	import flash.geom.Point;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.PreCallback;
	import nape.callbacks.PreFlag;
	import nape.dynamics.Arbiter;
	import nape.dynamics.ArbiterList;
	import nape.dynamics.CollisionArbiter;
	import nape.dynamics.Contact;
	import nape.geom.Vec2;
	import zpp_nape.dynamics.ZPP_SensorArbiter;
	/**
	 * ...
	 * @author 
	 */
	public class NapeContacts 
	{
		
		public function NapeContacts() 
		{
			
		}

		public static function BeginCollideA(cb:InteractionCallback)
		{
			//Utils.trace("collide a");
			var contact:Contact = null;
			var arbiterList:ArbiterList = cb.arbiters;
			for (var i:int = 0; i < arbiterList.length; i++)
			{
				var arbiter:Arbiter = arbiterList.at(i);
				if (arbiter.isCollisionArbiter())
				{
					var ca:CollisionArbiter = arbiter.collisionArbiter;
					contact = ca.contacts.at(0);
					
				}
				if (arbiter.isSensorArbiter())
				{					
					var a:int = 0;
				}
			}
			
			//------------------------------------------
			// This is for secondary world. 
			// ONLY DOING OBJECT AGAINST MATERIAL!!!!
			//------------------------------------------
			
			var go0:GameObj = null;
			var go1:GameObj = null;
			var bud0:PhysObj_BodyUserData;
			var bud1:PhysObj_BodyUserData;
			if (cb.int1.userData.data is PhysObj_BodyUserData)
			{
				bud0 = cb.int1.userData.data as PhysObj_BodyUserData;
				if (bud0 == null) return;
				if (bud0.gameObject != null) 
				{
					go0 = bud0.gameObject;
				}
				else
				{
					go0 = bud0.independantGO;
				}
			}
			else if(cb.int1.userData.data is PhysObj_Material)
			{
			}
			
			if (cb.int2.userData.data is PhysObj_BodyUserData)
			{
				bud1 = cb.int2.userData.data as PhysObj_BodyUserData;
				if (bud1 == null) return;
				if (bud1.gameObject != null) 
				{
					go1 = bud1.gameObject;
				}
				else
				{
					go1 = bud1.independantGO;
				}
			}
			else if(cb.int2.userData.data is PhysObj_Material)
			{
				
			}
			
			if (go0 != null)
			{
				var name:String = go0.name;
				go0.hitShapeName = "";
				go0.hitContactPoint_Nape = contact;
				go0.hitUserData_Nape = cb.int2.userData.data;
			}
			if (go1 != null)
			{
				var name:String = go1.name;
				go1.hitShapeName = "";
				go1.hitContactPoint_Nape = contact;
				go1.hitUserData_Nape = cb.int1.userData.data;
			}
			
			
			if (go0 != null && go0.hitUserData_Nape != null)
			{			
				if (go0.onHitFunction != null) 
				{
					go0.onHitFunction(null);
				}
			}
			if (go1 != null && go1.hitUserData_Nape != null)
			{			
				if (go1.onHitFunction != null) 
				{
					go1.onHitFunction(null);
				}
			}
			
		}
		
		public static function FluidSensor(cb:InteractionCallback)
		{
			//trace("fluid");
			
			var bud0:PhysObj_BodyUserData = cb.int1.userData.data as PhysObj_BodyUserData;
			var bud1:PhysObj_BodyUserData = cb.int2.userData.data as PhysObj_BodyUserData;
			
			if (bud0 == null) return;
			if (bud1 == null) return;
			
			var go0:GameObj = null;
			var go1:GameObj = null;
			
			
		}
		
		public static function OngoingSensor(cb:InteractionCallback)
		{
			isOngoing = true;
			Sensor_Inner(cb);
		}
		public static function BeginSensor(cb:InteractionCallback)
		{
			isOngoing = false;
			Sensor_Inner(cb);
		}
		
		
		public static function Sensor_Inner(cb:InteractionCallback)
		{
			var contact:Contact = null;
			
			var isSensorHit:Boolean = true;
			
			
			var arbiterList:ArbiterList = cb.arbiters;
			for (var i:int = 0; i < arbiterList.length; i++)
			{
				var arbiter:Arbiter = arbiterList.at(i);
				if (arbiter.isSensorArbiter())
				{
					var bud0:PhysObj_BodyUserData = cb.int1.userData.data as PhysObj_BodyUserData;
					var bud1:PhysObj_BodyUserData = cb.int2.userData.data as PhysObj_BodyUserData;
					
					if (bud0 != null && bud1 != null)
					{
					
						var go0:GameObj = null;
						var go1:GameObj = null;
						
						go0 = bud0.gameObject;
						go1 = bud1.gameObject;
						
						if (go0 != null)
						{
							go0.hitShapeName = "";
							go0.hitContactPoint_Nape = contact;
							go0.hitInteractionCallback_Nape = cb;
							go0.hitIsOngoing_Nape = isOngoing;
							go0.hitIsSensor = isSensorHit;
						}
						if (go1 != null)
						{
							go1.hitShapeName = "";
							go1.hitContactPoint_Nape = contact;
							go1.hitInteractionCallback_Nape = cb;
							go1.hitIsOngoing_Nape = isOngoing;
							go1.hitIsSensor = isSensorHit;
						}
						
						if (go0 != null && go1 != null)
						{			
							if (isOngoing)
							{
								if (go0.onHitPersistFunction != null) 
								{
									go0.onHitPersistFunction(go1);
								}
								if (go1.onHitPersistFunction != null) 
								{
									go1.onHitPersistFunction(go0);
								}							
							}
							else
							{
							
								if (go0.onHitFunction != null) 
								{
									go0.onHitFunction(go1);
								}
								if (go1.onHitFunction != null) 
								{
									go1.onHitFunction(go0);
								}
							}
						}
					}
				}
			}
		}
		
		
		
		
		public static function BeginPre(cb:PreCallback)
		{
			if (!cb.arbiter.isCollisionArbiter())
			{
				return PreFlag.ACCEPT;
			}
			
			var bud0:PhysObj_BodyUserData = cb.int1.userData.data as PhysObj_BodyUserData;
			var bud1:PhysObj_BodyUserData = cb.int2.userData.data as PhysObj_BodyUserData;
			
			if (bud0 == null) return PreFlag.ACCEPT;
			if (bud1 == null) return PreFlag.ACCEPT;
			
			var go0:GameObj = null;
			var go1:GameObj = null;
			if (bud0.gameObject != null) 
			{
				go0 = bud0.gameObject;
				
			}
			else 
			{
				return PreFlag.ACCEPT;
			}
			if (bud1.gameObject != null) 
			{
				go1 = bud1.gameObject;
			}
			else 
			{
				return PreFlag.ACCEPT;
			}
			
			trace("pre collision "+go0.name + "-" + go1.name);
			
			var doit:Boolean = false;
			if (go0.name == "player")
			{
				if (go1.name == "breakable")
				{
					doit = true;
				}				
			}
			if (go1.name == "breakable")
			{
				if (go0.name == "player")
				{
					doit = true;
				}				
			}
			
			if (doit)
			{
//				return PreFlag.IGNORE;
			}
			return PreFlag.ACCEPT;
		}
		public static function BeginCollide(cb:InteractionCallback)
		{
			isOngoing = false;
			BeginCollide_Inner(cb);
		}
		public static function OngoingCollide(cb:InteractionCallback)
		{			
			isOngoing = true;
			BeginCollide_Inner(cb);
		}

		static var isOngoing:Boolean;
		
		public static function BeginCollide_Inner(cb:InteractionCallback)
		{
			var contact:Contact = null;
			
			var isSensorHit:Boolean = false;
			
			var arbiterList:ArbiterList = cb.arbiters;
			
			if (arbiterList.length > 1)
			{
				var ais:int = 0 ;
			}
			
			for (var i:int = 0; i < arbiterList.length; i++)
			{
				var arbiter:Arbiter = arbiterList.at(i);
				if (arbiter.isCollisionArbiter())
				{
					var ca:CollisionArbiter = arbiter.collisionArbiter;
					contact = ca.contacts.at(0);	
					
					
					var bud0:PhysObj_BodyUserData = cb.int1.userData.data as PhysObj_BodyUserData;
					var bud1:PhysObj_BodyUserData = cb.int2.userData.data as PhysObj_BodyUserData;
					
					var go0:GameObj = null;
					var go1:GameObj = null;
					if (bud0 != null && bud1 != null)
					{
						go0 = bud0.gameObject;
						go1 = bud1.gameObject;
						
						if (go0 != null)
						{
							go0.hitShapeName = "";
							go0.hitContactPoint_Nape = contact;
							go0.hitInteractionCallback_Nape = cb;
							go0.hitIsOngoing_Nape = isOngoing;
							go0.hitIsSensor = isSensorHit;
						}
						if (go1 != null)
						{
							go1.hitShapeName = "";
							go1.hitContactPoint_Nape = contact;
							go1.hitInteractionCallback_Nape = cb;
							go1.hitIsOngoing_Nape = isOngoing;
							go1.hitIsSensor = isSensorHit;
						}
						
						if (go0 != null && go1 != null)
						{			
							if (isOngoing)
							{
								if (go0.onHitPersistFunction != null) 
								{
									go0.onHitPersistFunction(go1);
								}
								if (go1.onHitPersistFunction != null) 
								{
									go1.onHitPersistFunction(go0);
								}							
							}
							else
							{
							
								if (go0.onHitFunction != null) 
								{
									go0.onHitFunction(go1);
								}
								if (go1.onHitFunction != null) 
								{
									go1.onHitFunction(go0);
								}
							}
						}
					}
					
				}
			}
		}

		
		
	}

}