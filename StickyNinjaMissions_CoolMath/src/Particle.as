package  
{
	import EditorPackage.EdObjMarker;
	import flash.display.ActionScriptVersion;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	* ...
	* @author Default
	*/
	class Particle
	{
		static var gmat:Matrix = new Matrix();
		static var gpoint:Point = new Point();
		var active:Boolean;
		var xpos:Number;
		var ypos:Number;
		var xpos1:Number;
		var ypos1:Number;
		var startx:Number;
		var starty:Number;
		var timer:Number;
		var timerMax:Number;
		public var xvel:Number;
		public var yvel:Number;
		var yacc:Number;
		var graphicID:int;
		var frame:Number;
		var frameVel:Number;
		var speed:Number;
		var dir:Number;
		var scale:Number;
		var radius:Number;
		var dirVel:Number;
		var alpha:Number;
		var alphaAdd:Number;
		var maxframe:int;
		var counter:int;
		var visible:Boolean;
		var updateFunction:Function;
		var mode:int;
		var color:uint;
		var angle:Number;
		var angleVel:Number;
		var dobj:DisplayObj;
		var movementVec:Vec;
		
		
//-------------------------------------------------------------------------------------------------		
// Standard update functions
//-------------------------------------------------------------------------------------------------		
		
		function UpdateVelsTimer()
		{
			xpos += xvel;
			ypos += yvel;
			timer--;
			if (timer <= 0)
			{
				active = false;
			}
		}
		function UpdateAnimAndStop()
		{
			xpos += xvel;
			ypos += yvel;
			if(PlayAnimation())
			{
				active = false;
			}
		}

		
		
//-------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------		
		
		public function InitSmoke(_name:String):void
		{
			var v:Number = Utils.RandBetweenFloat(0, 1);
			var r:Number = Utils.RandCircle();
			xvel = Math.cos(r) * v;
			yvel = Math.sin(r) * v;
			
			dobj = GraphicObjects.GetDisplayObjByName(_name);
			
			updateFunction = UpdateSmoke;
			frameVel = Utils.RandBetweenFloat(0.6,1);
			frame = 0;
			maxframe = dobj.GetNumFrames() - 1;
//			angle = Utils.RandCircle();
//			scale = Utils.RandBetweenFloat(0.1, 1.1);
			timer = 0;
			visible = false;

		}

		
		function UpdateSmoke():void
		{
			xvel *= 0.9;
			yvel *= 0.9;
			xpos += xvel;
			ypos += yvel;
			
			visible = false;
			timer++;
			if (timer > 1)
			{
				visible = true;
				if (PlayAnimation())
				{
					active = false;
				}
			}
		}
		
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------

		public function InitDivot():void
		{
			var v:Number = Utils.RandBetweenFloat(3, 6);
			var r:Number = Utils.RandCircle();
			xvel = Math.cos(r) * v;
			yvel = Math.sin(r) * v;
			
			yvel = Utils.RandBetweenFloat( -3, -6);
			
			dobj = GraphicObjects.GetDisplayObjByName("divots");
			
			updateFunction = UpdateDivot;
			frame = Utils.RandBetweenInt(0, dobj.GetNumFrames() - 1);
			angle = Utils.RandCircle();
			
			timer = 20;
		}

		
		
		function UpdateDivot():void
		{
			yvel += 0.3;
			xpos += xvel;
			ypos += yvel;
			
			timer --;
			if (timer <= 10)
			{
				alpha = Utils.ScaleTo(0, 1, 0, 10, timer);
			}
			
			if (timer <= 0)
			{
				active = false;
			}
		}

//---------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------		
		
		public function InitSandShower():void
		{
			var v:Number = Utils.RandBetweenFloat(3, 6);
			var r:Number = Utils.RandCircle();
			xvel = Math.cos(r) * v;
			yvel = Math.sin(r) * v;
			
			yvel = Utils.RandBetweenFloat( -3, -6);
			
			dobj = GraphicObjects.GetDisplayObjByName("sandParticles");
			
			updateFunction = UpdateSandShower;
			frame = Utils.RandBetweenInt(0, dobj.GetNumFrames() - 1);
			angle = Utils.RandCircle();
			
			timer = 20;
		}

		
		
		function UpdateSandShower():void
		{
			yvel += 0.3;
			xpos += xvel;
			ypos += yvel;
			
			timer --;
			if (timer <= 10)
			{
				alpha = Utils.ScaleTo(0, 1, 0, 10, timer);
			}
			
			if (timer <= 0)
			{
				active = false;
			}
		}
		
//---------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------		
		
		public function InitCloudShower():void
		{
			var v:Number = Utils.RandBetweenFloat(3, 6);
			var r:Number = Utils.RandCircle();
			xvel = Math.cos(r) * v;
			yvel = Math.sin(r) * v;
			
			yvel = Utils.RandBetweenFloat( -3, -6);
			
			dobj = GraphicObjects.GetDisplayObjByName("sandParticles");
			
			updateFunction = UpdateCloudShower;
			frame = Utils.RandBetweenInt(0, dobj.GetNumFrames() - 1);
			angle = Utils.RandCircle();
			
			timer = 20;
		}

		
		
		function UpdateCloudShower():void
		{
			yvel += 0.3;
			xpos += xvel;
			ypos += yvel;
			
			timer --;
			if (timer <= 10)
			{
				alpha = Utils.ScaleTo(0, 1, 0, 10, timer);
			}
			
			if (timer <= 0)
			{
				active = false;
			}
		}
		
//---------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------		
		
		public function InitStarShower():void
		{
			var v:Number = Utils.RandBetweenFloat(3, 6);
			var r:Number = Utils.RandCircle();
			xvel = Math.cos(r) * v;
			yvel = Math.sin(r) * v;
			
			dobj = GraphicObjects.GetDisplayObjByName("star_particle");
			
			updateFunction = UpdateStarShower;
			frame = Utils.RandBetweenInt(0, dobj.GetNumFrames() - 1);
			angle = Utils.RandCircle();
			
			timer = 20;
		}

		
		
		function UpdateStarShower():void
		{
			yvel += 0.3;
			xpos += xvel;
			ypos += yvel;
			
			timer --;
			if (timer <= 10)
			{
				alpha = Utils.ScaleTo(0, 1, 0, 10, timer);
			}
			
			if (timer <= 0)
			{
				active = false;
			}
		}
		
//---------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------		
		
		public function InitFeather(mcName:String,_frame:int):void
		{
			
			xvel = Utils.RandBetweenFloat( -2, 2);
			yvel = Utils.RandBetweenFloat( -1, -2);
			
			dobj = GraphicObjects.GetDisplayObjByName(mcName);
			
			updateFunction = UpdateFeather;
			frame = _frame;
			angle = Utils.RandCircle();
			
			timer = 60;
		}

		
		
		function UpdateFeather():void
		{
			xpos += xvel;
			ypos += yvel;
			
			timer --;
			if (timer <= 10)
			{
				alpha = Utils.ScaleTo(0, 1, 0, 10, timer);
			}
			
			if (timer <= 0)
			{
				active = false;
			}
		}

//---------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------		
		
		public function InitSparkle(mcName:String,_frame:int):void
		{
			
			xvel = Utils.RandBetweenFloat( -2, 2);
			yvel = Utils.RandBetweenFloat( -1, -2);
			
			dobj = GraphicObjects.GetDisplayObjByName(mcName);
			
			updateFunction = UpdateSparkle;
			frame = _frame;
			angle = Utils.RandCircle();
			
			timer = 60;
		}

		
		
		function UpdateSparkle():void
		{
			xpos += xvel;
			ypos += yvel;
			
			timer --;
			if (timer <= 10)
			{
				alpha = Utils.ScaleTo(0, 1, 0, 10, timer);
			}
			
			if (timer <= 0)
			{
				active = false;
			}
		}
		
//---------------------------------------------------------------------------------------------

		
//-------------------------------------------------------------------------------------------------		

		public function InitExplosion_Small():void
		{			
			dobj = GraphicObjects.GetDisplayObjByName("explosion_2");			
			updateFunction = UpdateExplosion;
			frameVel = 1;			
			maxframe = dobj.GetNumFrames();
			frame = 0;
		}

		public function InitExplosion_Large():void
		{			
			dobj = GraphicObjects.GetDisplayObjByName("explosion_3");			
			updateFunction = UpdateExplosion;
			frameVel = 1;			
			maxframe = dobj.GetNumFrames();
			frame = 0;
		}

		public function InitExplosion_Mushroom():void
		{			
			dobj = GraphicObjects.GetDisplayObjByName("mushroomCloud");			
			updateFunction = UpdateExplosion;
			frameVel = 1;			
			maxframe = dobj.GetNumFrames();
			frame = 0;
		}

		public function InitExplosion_Shockwave():void
		{			
			dobj = GraphicObjects.GetDisplayObjByName("shockWave");			
			updateFunction = UpdateExplosion;
			frameVel = 1;			
			maxframe = dobj.GetNumFrames();
			frame = 0;
		}
		
		public function InitExplosion_BloodPuff():void
		{			
			dobj = GraphicObjects.GetDisplayObjByName("bloodPuff");			
			updateFunction = UpdateExplosion;
			frameVel = 1;			
			maxframe = dobj.GetNumFrames();
			frame = 0;
		}
		
		function UpdateExplosion():void
		{
			if(PlayAnimation())
			{
				active = false;
			}			
		}

//-------------------------------------------------------------------------------------------------		

		public function UpdateShard():void
		{
			xpos += xvel;
			ypos += yvel;
			yvel += 0.3;
			if (ypos > 500)
			{
				active = false;
			}
			angle += dirVel;
		}
		
		var velmul:Number;
		public function InitShard(_type:int,_r:Number):void
		{			
			if(_type == 0) dobj = GraphicObjects.GetDisplayObjByName("gem1_shards");			
			else if(_type == 1) dobj = GraphicObjects.GetDisplayObjByName("gem2_shards");			
			else if(_type == 2) dobj = GraphicObjects.GetDisplayObjByName("gem3_shards");			
			else if(_type == 3) dobj = GraphicObjects.GetDisplayObjByName("gem4_shards");			
			else if(_type == 4) dobj = GraphicObjects.GetDisplayObjByName("gem5_shards");			
			else if(_type == 5) dobj = GraphicObjects.GetDisplayObjByName("gem6_shards");			
			else if(_type == 6) dobj = GraphicObjects.GetDisplayObjByName("gem9_shards");			
			else if(_type == 7) dobj = GraphicObjects.GetDisplayObjByName("gem8_shards");			
			//else if(_type == 7) dobj = GraphicObjects.GetDisplayObjByName("gem8_shards");			
			updateFunction = UpdateShard;
			frameVel = 0;		
			maxframe = dobj.GetNumFrames();
			frame = 0;
			frame = Utils.RandBetweenInt(0, dobj.GetNumFrames() - 1);
			
			var _d:Number = 6;
			
			var r:Number = Utils.RandCircle();
			var d:Number = _d;	// Utils.RandBetweenFloat(5, 10);
			xpos += Math.cos(r) * d;
			ypos += Math.sin(r) * d;
			
			var _d:Number = 3;
			//var r:Number = _r;	// Utils.RandCircle();
			var d:Number = _d;	// Utils.RandBetweenFloat(2, 6);
			xvel = Math.cos(r) * d;
			yvel = Math.sin(r) * d;
			
			velmul = Utils.RandBetweenFloat(0.8, 0.95);
			angle = Utils.RandCircle();
			dirVel = Utils.RandBetweenFloat( -0.4, 0.4);
		}

		
//-------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------		
		


		function PlayAnimation():Boolean
		{
			frame = frame + frameVel;
			if(frame >= maxframe) 
			{
				frame = maxframe;
				return true;
			}
			return false;
		}
		function CycleAnimation():Boolean
		{
			frame = frame + frameVel;
			if(frame >= maxframe) 
			{
				frame = 0;
				return true;
			}
			return false;
		}

		//-----------------------------------------------------------------------------------------		
		//-----------------------------------------------------------------------------------------		

		
		function UpdateWaterSplash()
		{
			if (PlayAnimation())
			{
				active = false;
			}
			
/*			
			xpos += xvel;
			ypos += yvel;
			yvel += 0.1;
			timer--;
			if (timer <= 0)
			{
				active = false;
			}
			*/
			
		}
		
		function UpdateSandSplash()
		{
			xpos += xvel;
			ypos += yvel;
			yvel += GameVars.gravity_GO;
			timer--;
			if (timer <= 0)
			{
				active = false;
			}
			
		}
		
		function InitSandSplash(_amt:Number)
		{
			InitMudSplash(_amt);
			dobj = GraphicObjects.GetDisplayObjByName("SandSpray");
			frame = dobj.GetRandomFrame();
			
		}
		function InitMudSplash(_amt:Number)
		{
			updateFunction = UpdateSandSplash;
			dobj = GraphicObjects.GetDisplayObjByName("MudSpray");
			frame = dobj.GetRandomFrame();
			
			
			
			movementVec.Set(-(Math.PI/2) + Utils.RandBetweenFloat( -1, 0.2), Utils.ScaleTo(1,4,0,1,_amt)+Utils.RandBetweenFloat(0,2));
			xvel = movementVec.X();
			yvel = movementVec.Y();
			timer = Utils.RandBetweenInt(40, 60);
		}

		function InitSurfaceFX(_amt:Number,clipName:String)
		{
			updateFunction = UpdateSandSplash;
			dobj = GraphicObjects.GetDisplayObjByName(clipName);
			frame = dobj.GetRandomFrame();
			
			movementVec.Set(-(Math.PI/2) + Utils.RandBetweenFloat( -1, 0.2), Utils.ScaleTo(1,4,0,1,_amt)+Utils.RandBetweenFloat(0,2));
			xvel = movementVec.X();
			yvel = movementVec.Y();
			timer = Utils.RandBetweenInt(40, 60);
//			scale = Utils.RandBetweenFloat(0.5, 1);
		}
		
		
		function InitWaterSplash(_parentGO:GameObj)
		{
			
			var pgo:GameObj = GameVars.playerGO;
			
			var vel:Number = pgo.GetBodyLinearVelocity(0).length;
			var amt:Number = Utils.ScaleToPreLimit(0, 1, 0, 600, vel);
			
			updateFunction = UpdateWaterSplash;
			dobj = GraphicObjects.GetDisplayObjByName("WaterSpray");
			dobj = GraphicObjects.GetDisplayObjByName("WaterSplash");
			frame = dobj.GetRandomFrame();
			
			scale = Utils.RandBetweenFloat(0.5, 1);
			
			frame = 0;
			frameVel = Utils.RandBetweenFloat(0.3, 0.6);
			maxframe = dobj.GetNumFrames();
			
//			movementVec.Set(-(Math.PI/2) + Utils.RandBetweenFloat( -1, 0.2), Utils.ScaleTo(1,3,0,1,amt)+Utils.RandBetweenFloat(0,2));
//			xvel = movementVec.X();
//			yvel = movementVec.Y();
//			timer = Utils.RandBetweenInt(10,20);
			
		}
		
		//-----------------------------------------------------------------------------------------		
		//-----------------------------------------------------------------------------------------		
		
		function InitRockDebris(_large:Boolean = false)
		{
			updateFunction = UpdateSandSplash;
			dobj = GraphicObjects.GetDisplayObjByName("FallingRock1");
			frame = dobj.GetRandomFrame();
			scale = Utils.RandBetweenFloat(0.4, 0.6);
			
			if (_large)
			{
				xpos += Utils.RandBetweenFloat( -30, 30);
				ypos += Utils.RandBetweenFloat( -30, 30);				
			}
			else
			{
				xpos += Utils.RandBetweenFloat( -10, 10);
				ypos += Utils.RandBetweenFloat( -10, 10);
			}
			
			angle = Utils.RandCircle();			
			
			movementVec.Set(-(Math.PI/2) + Utils.RandBetweenFloat( -1, 0.2), Utils.RandBetweenFloat(1,3));
			xvel = movementVec.X();
			yvel = movementVec.Y();
			timer = Utils.RandBetweenInt(40, 60);
//			scale = Utils.RandBetweenFloat(0.5, 1);
			
		}
		
		function InitStalagtiteDebris()
		{
			updateFunction = UpdateSandSplash;
			dobj = GraphicObjects.GetDisplayObjByName("Stalagtite");
			frame = dobj.GetRandomFrame();
			scale = Utils.RandBetweenFloat(0.4, 0.5);
			
			xpos += Utils.RandBetweenFloat( -10, 10);
			ypos += Utils.RandBetweenFloat( -10, 10);
			
			angle = Utils.RandCircle();
			
			movementVec.Set(-(Math.PI/2) + Utils.RandBetweenFloat( -1, 0.2), Utils.RandBetweenFloat(1,3));
			xvel = movementVec.X();
			yvel = movementVec.Y();
			timer = Utils.RandBetweenInt(40, 60);
//			scale = Utils.RandBetweenFloat(0.5, 1);
			
		}

		function UpdateTurboFlame()
		{
			alpha += alphaAdd;
			if (alpha <= 0)
			{
				alpha = 0;
				active = false;
			}
		}
		function InitTurboFlame()
		{
			updateFunction = UpdateTurboFlame;
			dobj = GraphicObjects.GetDisplayObjByName("flameParticle");
			frame = dobj.GetRandomFrame();
			scale = Utils.RandBetweenFloat(0.8,1.2);

			alpha = 1;
			alphaAdd = Utils.RandBetweenFloat( -0.1, -0.15);
			
		}
//------------------------------------------------------------------------------------------------

		public function UpdateTreasurePickup()
		{	
			var goPlayer:GameObj = GameVars.playerGO;
			
			movementVec.SetFromDxDy(goPlayer.xpos - xpos, goPlayer.ypos - ypos);
			movementVec.speed = Utils.ScaleTo(0, 12, 0, timerMax, timer);
			timer++;
			
			xpos += movementVec.X();
			ypos += movementVec.Y();
			
//			var go:GameObj = GameObjects.AddObj(xpos, ypos, zpos + 1);
//			go.InitTreasurePickupTrail();
			
			var d2:Number = 10*10;
			if (Utils.Dist2BetweenPoints(xpos, ypos, goPlayer.xpos, goPlayer.ypos) < d2)
			{
				active = false;
			}
		}
		public function InitTreasurePickup(multiplier:int)
		{
			updateFunction = UpdateTreasurePickup;
			dobj = GraphicObjects.GetDisplayObjByName("obj_treasure_coin");
			frame = Utils.LimitNumber(1, dobj.GetNumFrames() - 1, multiplier);
			timer = 0;
			timerMax = Defs.fps * 1.5;
		}

//------------------------------------------------------------------------------------------------


		public function UpdatePow()
		{
			scale += 0.1;
			dir += 0.02;
			timer--;
			if (timer <= 0)
			{
				active = false;
			}
			
		}
		public function InitPow()
		{
			scale = 1;
			timer = 5;
			updateFunction = UpdatePow;
			dobj = GraphicObjects.GetDisplayObjByName("fx_pow");
			frame = 0;
		}

//------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------


		public function UpdateCombo()
		{
			scale += 0.01;
			timer--;
			if (timer <= 0)
			{
				active = false;
			}
			
		}
		public function InitCombo(multiplier:int)
		{
			scale = 1;
			timer = 50;
			updateFunction = UpdateCombo;
			dobj = GraphicObjects.GetDisplayObjByName("ui_score_combo");
			frame = Utils.LimitNumber(1, dobj.GetNumFrames() - 1, multiplier);
		}

//------------------------------------------------------------------------------------------------

		public function UpdateBreakable_Piece()
		{			
			angle += angleVel;
			xpos += xvel;
			ypos += yvel;
			yvel += 0.05;
			timer--;
			if (timer <= 0)
			{
				active = 0;
			}
			alpha = Utils.ScaleTo(0, 1, 0, timerMax, timer);
		}
		
		public function InitBreakablePiece(def:BreakablePieceDef ,rotat:Number)
		{
			updateFunction = UpdateBreakable_Piece;
			dobj = GraphicObjects.GetDisplayObjByName(def.objname);
			frame = 0;
						
			gmat.identity();
			gmat.rotate(rotat);
			gpoint.x = def.x;
			gpoint.y = def.y;
			gpoint = gmat.transformPoint(gpoint);
			xpos += gpoint.x;
			ypos += gpoint.y;
			
			angle = rotat;
			
			movementVec.rot = Utils.RandBetweenFloat( -Math.PI / 2, 0);
			movementVec.speed = Utils.RandBetweenFloat( 10,15);
			
			xvel = movementVec.X();
			yvel = movementVec.Y();
			angleVel = Utils.RandBetweenFloat(0.1, 0.2);
			if (Utils.RandBetweenInt(0, 1000) < 500) angleVel = -angleVel;
			timer = timerMax = Utils.RandBetweenInt(70,80);
			
		}

		public function InitBreakablePieceFromMarker(_baseName:String,marker:EdObjMarker ,rotat:Number)
		{
			updateFunction = UpdateBreakable_Piece;
			dobj = GraphicObjects.GetDisplayObjByName(_baseName);
			frame = dobj.GetRandomFrame();
						
			gmat.identity();
			gmat.rotate(rotat);
			gpoint.x = marker.xpos;
			gpoint.y = marker.ypos;
			gpoint = gmat.transformPoint(gpoint);
			xpos += gpoint.x;
			ypos += gpoint.y;
			
			angle = rotat;
			
			movementVec.rot = Utils.RandCircle();
			movementVec.speed = Utils.RandBetweenFloat(2,3);
			
			xvel = movementVec.X();
			yvel = movementVec.Y();
			angleVel = Utils.RandBetweenFloat(0.1, 0.2);
			if (Utils.RandBetweenInt(0, 1000) < 500) angleVel = -angleVel;
			timer = timerMax = Utils.RandBetweenInt(70,80);
			
			dir = Utils.RandCircle();
			
		}
		
		
	}
	
}