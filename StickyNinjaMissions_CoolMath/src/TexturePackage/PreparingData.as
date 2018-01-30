package TexturePackage
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import UIPackage.PreparingObject;
	/**
	 * ...
	 * @author 
	 */
	public class PreparingData 
	{
		
		[Embed(source = "../../Fonts/BPreplayBold_24.xml", mimeType = "application/octet-stream")] 
        private static var class_font_BPreplayBold_24:Class; 
		
		
		public function PreparingData() 
		{
			
		}
		
		public static function CanDisposePage(pageIndex:int):Boolean
		{
			pageIndex++;
			for each(var i:int in neverDisposeList)
			{
				if (pageIndex == i) return false;
			}
			return true;
		}
				
		public static var neverDisposeList:Array = new Array(1, 1, 1);
		
		
		public static var predefinedTextureSizes:Array = new Array(
			new Point(2048, 2048),
			new Point(2048, 2048)
			);
		
			

		static var compression_normal_both = new PreparingCompression(0,0);
		static var compression_none_both = new PreparingCompression(1,1);

		static var mod_separate_128x128:PreparingModifier = new PreparingModifier("page", "separate", false,new Rectangle(0,0,128,128));

		
		static var mod_separate_background:PreparingModifier = new PreparingModifier("page", "separate", false,new Rectangle(0,0,1024,512) );
		static var mod_separate_surface:PreparingModifier = new PreparingModifier("page", "separate", false,new Rectangle(0,0,512,64) );
		static var mod_separate_2048:PreparingModifier = new PreparingModifier("page", "separate", false,new Rectangle(0,0,2048,2048) );
		
		static var mod_separate:PreparingModifier = new PreparingModifier("page", "separate", false);
		static var mod_separate_scale_up:PreparingModifier = new PreparingModifier("page", "separate_scale_up", false);
		
		static var mod_skipbitmapcreate = new PreparingModifier("skip_bitmap_create", "", false);
		
		static var mod_skip:PreparingModifier = new PreparingModifier("skip", "",false);
		static var mod_default:PreparingModifier = new PreparingModifier("page", "1",true,null,compression_none_both,1);
		static var mod_ui:PreparingModifier = new PreparingModifier("page", "2",true,null,compression_none_both,1);
		static var mod_bg:PreparingModifier = new PreparingModifier("page", "1",true,null,compression_none_both,1);
		static var mod_fg:PreparingModifier = new PreparingModifier("page", "1",true,null,compression_none_both,1);
		static var mod_hud:PreparingModifier = new PreparingModifier("page", "2",true,null,compression_none_both,1);
//		static var mod_font:PreparingModifier = new PreparingModifier("page", "4",true);
		
				

		static var modifyList:Array = new Array(
				"BPreplayBold_24",mod_hud,
				"HighlandsCondensedBold_48",mod_hud,
				"Component_HelpScreen",mod_separate,
				"Component_HelpScreenMobile",mod_separate,
				"Component_HelpScreenOuya",mod_separate,
				"Component_Screen_MobileVersion",mod_separate,
				"Component_Background",mod_separate,
				"Component_TitlePlayers",mod_separate,
				"Component_Background",mod_separate,
				"Component_TitlePlayers",mod_separate,
				"Component_TitleBackdrop",mod_separate,
				"background", mod_separate,
				"ui_separatetexture_hint_popup", mod_separate,
				"$separatetexture_", mod_separate,
				"$_bg_", mod_bg,
				"$_fg_", mod_fg,
				"polyfill_bg", mod_separate_128x128,
				"polyfill", mod_separate_128x128
				
				);
				
	
	
	public static var preparingList:Array = new Array(
		
	new PreparingObject("font", "BPreplayBold_24",null,class_font_BPreplayBold_24),

new PreparingObject("gfx","enemy_jetpack"),
new PreparingObject("gfx","enemy_a_base"),
new PreparingObject("gfx","enemy_a_idle"),
new PreparingObject("gfx","enemy_a_fly"),
new PreparingObject("gfx","enemy_b_idle"),
new PreparingObject("gfx","enemy_b_fly"),
new PreparingObject("gfx","enemy_c_fly"),
new PreparingObject("gfx","enemy_c_idle"),
new PreparingObject("gfx","enemy_a_hit"),
new PreparingObject("gfx","enemy_b_hit"),
new PreparingObject("gfx","enemy_c_hit"),
new PreparingObject("gfx","enemy_a_idle_lookright"),
new PreparingObject("gfx","enemy_b_idle_lookright"),
new PreparingObject("gfx","enemy_c_idle_lookright"),
new PreparingObject("gfx","enemy_b_base"),
new PreparingObject("gfx", "enemy_c_base"),

new PreparingObject("gfx","player_a_base"),
new PreparingObject("gfx","player_a_idle"),
new PreparingObject("gfx","player_a_charge"),
new PreparingObject("gfx","player_a_zen"),
new PreparingObject("gfx","player_a_spin_right"),
new PreparingObject("gfx","player_a_fly_up"),
new PreparingObject("gfx","player_a_fly_down"),
new PreparingObject("gfx","player_a_fly_right"),
new PreparingObject("gfx","player_a_hit"),
new PreparingObject("gfx", "player_a_look"),

new PreparingObject("gfx","player_a_base_nunja"),
new PreparingObject("gfx","player_a_idle_nunja"),
new PreparingObject("gfx","player_a_charge_nunja"),
new PreparingObject("gfx","player_a_zen_nunja"),
new PreparingObject("gfx","player_a_spin_right_nunja"),
new PreparingObject("gfx","player_a_fly_up_nunja"),
new PreparingObject("gfx","player_a_fly_down_nunja"),
new PreparingObject("gfx","player_a_fly_right_nunja"),
new PreparingObject("gfx","player_a_hit_nunja"),
new PreparingObject("gfx", "player_a_look_nunja"),

new PreparingObject("gfx","player_a_base_master"),
new PreparingObject("gfx","player_a_idle_master"),
new PreparingObject("gfx","player_a_charge_master"),
new PreparingObject("gfx","player_a_zen_master"),
new PreparingObject("gfx","player_a_spin_right_master"),
new PreparingObject("gfx","player_a_fly_up_master"),
new PreparingObject("gfx","player_a_fly_down_master"),
new PreparingObject("gfx","player_a_fly_right_master"),
new PreparingObject("gfx","player_a_hit_master"),
new PreparingObject("gfx", "player_a_look_master"),


new PreparingObject("gfx","Help1"),
new PreparingObject("gfx","obj_fg_water_block"),
new PreparingObject("gfx","obj_chopper_blades"),
new PreparingObject("gfx","obj_chopper"),
new PreparingObject("gfx","obj_carriage"),
new PreparingObject("gfx","obj_timer"),
new PreparingObject("gfx","obj_trolley"),
new PreparingObject("gfx","obj_bg_tree_a"),
new PreparingObject("gfx","obj_bg_tree_b"),
new PreparingObject("gfx","obj_bg_tree_c"),
new PreparingObject("gfx","obj_bg_window_a"),
new PreparingObject("gfx","obj_bg_window_b"),
new PreparingObject("gfx","fragment_glass"),
new PreparingObject("gfx","obj_triangle"),
new PreparingObject("gfx","obj_laser_pointer"),
new PreparingObject("gfx","obj_ladder"),
new PreparingObject("gfx","obj_pipe_slide"),
new PreparingObject("gfx","polyfill"),
new PreparingObject("gfx","polyfill_bg"),
new PreparingObject("gfx","obj_bg_garage"),
new PreparingObject("gfx","obj_bg_garage_close"),
new PreparingObject("gfx","obj_bg_lamppost_day"),
new PreparingObject("gfx","obj_bg_lamppost_night"),
new PreparingObject("gfx","obj_treasure_fruit_a"),
new PreparingObject("gfx","obj_fg_guide_sign"),
new PreparingObject("gfx","obj_fg_guide_sign_neon"),
new PreparingObject("gfx","obj_track"),
new PreparingObject("gfx","obj_track_long"),
new PreparingObject("gfx","obj_subwaycar"),
new PreparingObject("gfx","obj_conveyor"),
new PreparingObject("gfx","obj_car_a"),
new PreparingObject("gfx","obj_car_b"),
new PreparingObject("gfx","obj_car_c"),
new PreparingObject("gfx","obj_fire_hydrant"),
new PreparingObject("gfx","obj_bench"),
new PreparingObject("gfx","obj_phone_box"),
new PreparingObject("gfx","obj_arcade_machine"),
new PreparingObject("gfx","fragment_dark"),
new PreparingObject("gfx","fragment_white"),
new PreparingObject("gfx","obj_cone"),
new PreparingObject("gfx","obj_barrier"),
new PreparingObject("gfx","obj_bg_wirefence"),
new PreparingObject("gfx","obj_lift"),
new PreparingObject("gfx","obj_lift_small"),
new PreparingObject("gfx","obj_roof_bouncy"),
new PreparingObject("gfx","obj_ball_smallhard"),
new PreparingObject("gfx","obj_fg_bush_a"),
new PreparingObject("gfx","obj_bg_bush_a"),
new PreparingObject("gfx","obj_fg_bush_b"),
new PreparingObject("gfx","obj_bg_bush_b"),
new PreparingObject("gfx","obj_fg_bush_c"),
new PreparingObject("gfx","obj_bg_bush_c"),
new PreparingObject("gfx","fx_splash_particle"),
new PreparingObject("gfx","obj_rope"),
new PreparingObject("gfx","background"),
new PreparingObject("gfx","obj_rock_big"),
new PreparingObject("gfx","fragment_rock"),
new PreparingObject("gfx","obj_tetsubishi"),
new PreparingObject("gfx","obj_fire_ball"),
new PreparingObject("gfx","obj_exit"),
new PreparingObject("gfx","obj_exit_anim"),
new PreparingObject("gfx","obj_exit_back"),
new PreparingObject("gfx","obj_blade_spinning"),
new PreparingObject("gfx","obj_fence_wood"),
new PreparingObject("gfx","obj_bridge_rope"),
new PreparingObject("gfx","obj_mushroom_bouncy"),
new PreparingObject("gfx","obj_platform_metal"),
new PreparingObject("gfx","obj_platform_metal_white"),
new PreparingObject("gfx","obj_platform_stone"),
new PreparingObject("gfx","obj_platform_metal_x4"),
new PreparingObject("gfx","obj_platform_stone_x4"),
new PreparingObject("gfx","obj_platform_metal_white_x4"),
new PreparingObject("gfx","obj_block_deadly"),
new PreparingObject("gfx","obj_block_bouncy"),
new PreparingObject("gfx","obj_block_smooth"),
new PreparingObject("gfx","obj_block_smooth_slide"),
new PreparingObject("gfx","obj_block_break"),
new PreparingObject("gfx","obj_block_vanish"),
new PreparingObject("gfx","obj_block_sticky"),
new PreparingObject("gfx","obj_roof_vent"),
new PreparingObject("gfx","obj_treasure_diamond"),
new PreparingObject("gfx","obj_treasure_gold"),
new PreparingObject("gfx","obj_treasure_chicken"),
new PreparingObject("gfx","obj_treasure_coin"),
new PreparingObject("gfx","obj_treasure_coin_glint"),
new PreparingObject("gfx","obj_treasure_can"),
new PreparingObject("gfx","ui_score_general"),
new PreparingObject("gfx","ui_score_combo"),
new PreparingObject("gfx","ui_heart"),
new PreparingObject("gfx","ui_cursor"),
new PreparingObject("gfx","ui_cursor_arrow"),
new PreparingObject("gfx","obj_exit_arrow"),
new PreparingObject("gfx","obj_exit_arrow_icon"),
new PreparingObject("gfx","ui_cursor_no"),
new PreparingObject("gfx","powerup_shuriken_anim"),
new PreparingObject("gfx","powerup_life_anim"),
new PreparingObject("gfx","obj_switch"),
new PreparingObject("gfx","obj_ninja_sword"),
new PreparingObject("gfx","obj_shuriken"),
new PreparingObject("gfx","obj_shuriken_player"),
new PreparingObject("gfx","obj_waterbomb"),
new PreparingObject("gfx","fx_pow"),
new PreparingObject("gfx","fx_ninja_charge"),
new PreparingObject("gfx","fx_general_gfx"),
new PreparingObject("gfx","fx_general_force"),
new PreparingObject("gfx","fx_treasure_shrapnel"),
new PreparingObject("gfx","fx_wind"),
new PreparingObject("gfx","fx_splat"),
new PreparingObject("gfx","fx_splash"),
new PreparingObject("gfx","fx_smoke1"),
new PreparingObject("gfx","fx_smoke3"),
new PreparingObject("gfx","fx_smoke_ninjajump"),
new PreparingObject("gfx","fx_smoke2"),
new PreparingObject("gfx","fx_shrapnel"),
new PreparingObject("gfx","fx_water"),
new PreparingObject("gfx","fx_visual_shrapnel_ninja"),
new PreparingObject("gfx","fx_explosion"),
new PreparingObject("gfx","fx_sparkles"),
new PreparingObject("gfx","fx_sparkle"),
new PreparingObject("gfx","obj_fountain"),
new PreparingObject("gfx","obj_waterwheel"),
new PreparingObject("gfx","obj_ferriswheel"),
new PreparingObject("gfx","obj_fixed_joint"),
new PreparingObject("gfx","obj_fg_fixed_joint"),
new PreparingObject("gfx","obj_chainlink"),
new PreparingObject("gfx","obj_chainlink_end"),
new PreparingObject("gfx","obj_bg_torch"),
new PreparingObject("gfx","obj_fg_lamp"),
new PreparingObject("gfx","obj_fg_lamp_unlit"),
new PreparingObject("gfx","obj_palm_trunk"),
new PreparingObject("gfx","obj_palm_leaves"),
new PreparingObject("gfx","obj_steps_wood"),
new PreparingObject("gfx","obj_garagedoor"),
new PreparingObject("gfx","obj_garagedoor_large"),
new PreparingObject("gfx","obj_pipe_slide_45"),
new PreparingObject("gfx","obj_block_small"),
new PreparingObject("gfx","obj_rock"),
new PreparingObject("gfx","obj_skull"),
new PreparingObject("gfx","obj_roof"),
new PreparingObject("gfx","obj_glasspane"),
new PreparingObject("gfx","obj_glasspane_tall"),
new PreparingObject("gfx","obj_bg_glasspane"),
new PreparingObject("gfx","obj_log_100x25"),
new PreparingObject("gfx","obj_log_100x10"),
new PreparingObject("gfx","obj_log_200x25"),
new PreparingObject("gfx","obj_ship"),
new PreparingObject("gfx","obj_log_50x25"),
new PreparingObject("gfx","obj_platform_crumbly"),
new PreparingObject("gfx","obj_plank_long_sticky"),
new PreparingObject("gfx","obj_trapdoor"),
new PreparingObject("gfx","obj_branch_a"),
new PreparingObject("gfx","obj_branch_b"),
new PreparingObject("gfx","obj_surfboard"),
new PreparingObject("gfx","obj_skateboard"),
new PreparingObject("gfx","obj_pillar_50x150"),
new PreparingObject("gfx","obj_pillar_square_50x150"),
new PreparingObject("gfx","obj_bar_metal_long"),
new PreparingObject("gfx","obj_bar_metal"),
new PreparingObject("gfx","obj_plank"),
new PreparingObject("gfx","obj_plank_fixed"),
new PreparingObject("gfx","obj_plank_fixed_x2"),
new PreparingObject("gfx","obj_spikebar"),
new PreparingObject("gfx","obj_fg_fire_block"),
new PreparingObject("gfx","obj_fire_spawner"),
new PreparingObject("gfx","obj_spikebar_small"),
new PreparingObject("gfx","obj_rope_long"),
new PreparingObject("gfx","obj_floor_wood_long"),
new PreparingObject("gfx","obj_floor_wood"),
new PreparingObject("gfx","obj_vase"),
new PreparingObject("gfx","obj_fg_lantern"),
new PreparingObject("gfx","obj_fg_lantern_unlit"),
new PreparingObject("gfx","obj_ball_spiky"),
new PreparingObject("gfx","obj_ball"),
new PreparingObject("gfx","obj_ball_fixed"),
new PreparingObject("gfx","obj_mushroom_bouncy_top"),
new PreparingObject("gfx","obj_ball_bouncy"),
new PreparingObject("gfx","obj_parachute"),
new PreparingObject("gfx","obj_cloud_bouncy"),
new PreparingObject("gfx","obj_barrel_explosive"),
new PreparingObject("gfx","obj_barrel_wood"),
new PreparingObject("gfx","obj_barrel"),
new PreparingObject("gfx","obj_bin"),
new PreparingObject("gfx","obj_windblock"),
new PreparingObject("gfx","obj_kite"),
new PreparingObject("gfx","obj_crate_wood"),
new PreparingObject("gfx","obj_box"),
new PreparingObject("gfx","obj_shark"),
new PreparingObject("gfx","obj_pathline_marker"),
new PreparingObject("gfx","obj_pathline_marker_blocked"),
new PreparingObject("gfx","obj_wheel"),
new PreparingObject("gfx","obj_wheel_tyre"),
new PreparingObject("gfx","obj_wheel_small"),
new PreparingObject("gfx","obj_wheel_large"),
new PreparingObject("gfx","ninja_blocked"),
new PreparingObject("gfx","obj_chainlink_hook"),
new PreparingObject("gfx","obj_barrel_wood_front"),
new PreparingObject("gfx","fragment_wood"),
new PreparingObject("gfx","obj_chair"),
new PreparingObject("gfx","obj_lifebuoy"),
new PreparingObject("gfx","obj_table_wood"),
new PreparingObject("gfx","obj_parasol_bouncy"),
new PreparingObject("gfx","obj_table_wood_alt"),
new PreparingObject("gfx","obj_container_front"),
new PreparingObject("gfx","obj_container_side"),
new PreparingObject("gfx","obj_boat"),
new PreparingObject("gfx","obj_spring_bouncy"),
new PreparingObject("gfx","obj_capstan_bouncy"),
new PreparingObject("gfx","obj_boat_vent"),
new PreparingObject("gfx","new_ninja"),
new PreparingObject("gfx","editorobj_hintpopup_trigger"),
new PreparingObject("gfx","ui_separatetexture_hint_popup")

	
		);
		
		
		
	}

}