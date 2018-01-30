package AnimPackage 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class AnimDefinitions 
	{
		public static var defs:Vector.<AnimDefinition>;
		public static var dict:Dictionary;
		
		public function AnimDefinitions() 
		{
			
		}
		
		public static function InitOnce()
		{
			ReInit(0);
		}
		public static function ReInit(playerIndex:int)
		{
			defs = new Vector.<AnimDefinition>();
			dict = new Dictionary();
			if (playerIndex == 0)
			{
				AddDef("player_idle", "player_a_idle", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_look", "player_a_look", 0.1, new Array(0, 1, 2, 3,4,5,6,7,8,7,6,5,4,3,2,1));
				AddDef("player_charge", "player_a_charge", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_fly_left", "player_a_fly_right", 0.1, new Array(0, 1, 2, 1),true);
				AddDef("player_fly_right", "player_a_fly_right", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_fly_up", "player_a_fly_up", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_fly_down", "player_a_fly_down", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_exit", "player_a_zen", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_dead", "player_a_hit", 0.1, new Array(0, 1, 2, 1));
			}

			if (playerIndex == 1)
			{
				AddDef("player_idle", "player_a_idle_nunja", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_look", "player_a_look_nunja", 0.1, new Array(0, 1, 2, 3,4,5,6,7,8,7,6,5,4,3,2,1));
				AddDef("player_charge", "player_a_charge_nunja", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_fly_left", "player_a_fly_right_nunja", 0.1, new Array(0, 1, 2, 1),true);
				AddDef("player_fly_right", "player_a_fly_right_nunja", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_fly_up", "player_a_fly_up_nunja", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_fly_down", "player_a_fly_down_nunja", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_exit", "player_a_zen_nunja", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_dead", "player_a_hit_nunja", 0.1, new Array(0, 1, 2, 1));
			}
			
			if (playerIndex == 2)
			{
				AddDef("player_idle", "player_a_idle_master", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_look", "player_a_look_master", 0.1, new Array(0, 1, 2, 3,4,5,6,7,8,7,6,5,4,3,2,1));
				AddDef("player_charge", "player_a_charge_master", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_fly_left", "player_a_fly_right_master", 0.1, new Array(0, 1, 2, 1),true);
				AddDef("player_fly_right", "player_a_fly_right_master", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_fly_up", "player_a_fly_up_master", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_fly_down", "player_a_fly_down_master", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_exit", "player_a_zen_master", 0.1, new Array(0, 1, 2, 1));
				AddDef("player_dead", "player_a_hit_master", 0.1, new Array(0, 1, 2, 1));
			}

			
			
			AddDef("enemy_a_fly", "enemy_a_fly", 0.2, new Array(0, 1, 2, 3,2,1));
			AddDef("enemy_a_idle", "enemy_a_idle", 0.2, new Array(0, 1, 2, 3,2,1));
			AddDef("enemy_a_idle_lookright", "enemy_a_idle_lookright", 0.2, new Array(0, 1, 2,3,2, 1));
			AddDef("enemy_a_idle_lookleft", "enemy_a_idle_lookright", 0.2, new Array(0, 1, 2,3,2, 1),true);
			AddDef("enemy_a_hit", "enemy_a_hit", 0.2, new Array(0, 1, 2, 3,2,1));
			AddDef("enemy_b_fly", "enemy_b_fly", 0.1, new Array(0, 1, 2, 3,2,1));
			AddDef("enemy_b_idle", "enemy_b_idle", 0.1, new Array(0, 1, 2, 3,2,1));
			AddDef("enemy_b_idle_lookright", "enemy_b_idle_lookright", 0.1, new Array(0, 1, 2,3,2, 1));
			AddDef("enemy_b_idle_lookleft", "enemy_b_idle_lookright", 0.1, new Array(0, 1, 2,3,2, 1),true);
			AddDef("enemy_b_hit", "enemy_b_hit", 0.1, new Array(0, 1, 2, 3,2,1));
			AddDef("enemy_c_idle", "enemy_c_idle", 0.1, new Array(0, 1, 2, 3,2,1));
			AddDef("enemy_c_idle_lookright", "enemy_c_idle_lookright", 0.1, new Array(0, 1, 2,3,2, 1));
			AddDef("enemy_c_idle_lookleft", "enemy_c_idle_lookright", 0.1, new Array(0, 1, 2,3,2, 1),true);
			AddDef("enemy_c_hit", "enemy_c_hit", 0.1, new Array(0, 1, 2, 3,2,1));
		}
		
		
		public static function Get(name:String):AnimDefinition
		{
			return dict[name];
		}
		
		static function AddDef(name:String, mc:String, speed:Number, frames:Array = null,_xflipped:Boolean=false)
		{
			var def:AnimDefinition = new AnimDefinition();
			def.name = name;
			def.mcName = mc;
			def.speed = speed;
			def.frames = new Array();
			def.xflip = _xflipped;
			for each(var f:int in frames)
			{
				def.frames.push(f);
			}
			defs.push(def);
			dict[name] = def;
		}

		
		
	}

}