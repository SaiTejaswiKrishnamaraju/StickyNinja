package  
{
	import AnimPackage.AnimHierarchy;
	import AudioPackage.Audio;
	import EditorPackage.EdJoint;
	import EditorPackage.EdLine;
	import EditorPackage.EdObj;
	import EditorPackage.GameLayers;
	import EditorPackage.PolyMaterial;
	import EditorPackage.PolyMaterials;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import nape.callbacks.InteractionCallback;
	import nape.constraint.Constraint;
	import nape.constraint.DistanceJoint;
	import nape.dynamics.Contact;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.shape.Shape;

	if (PROJECT::useStage3D)
	{
		import flash.display3D.textures.Texture;
	}
	
	public class GameObj_Base
	{
		public var listIndex:int;
		public var activeListIndex:int;
		public var inactiveListIndex:int;
		public var isAwake:Boolean;
		
		public var miniMapRenderFunction:Function;
		public var preRenderFunction:Function;
		public var preRenderFunction1:Function;
		public var renderFunction:Function;
		public var clipFunction:Function;
		public var updateFunction:Function;
		public var keepAwakeFunction:Function;
		public var updateFromPhysicsFunction:Function;
		public var onClickedFunction:Function;
		public var canClickFunction:Function;
		public var onMouseOverFunction:Function;
		public var onMouseOutFunction:Function;
		public var updateFunction1:Function;
		public var switchFunction:Function;
		public var renderShadowFunction:Function;
		public var doSwitchFunction:Function;	
		
		
		public var isJointObj:Boolean;
		public var switchFlag:Boolean;
		public var minimapID:int;
		public var isStaticObject:Boolean;
		
		public var gmat3d:Matrix3D;
		public var gmat:Matrix;
		public var grect:Rectangle;
		public var gpoint:Point;
		public var gpoint1:Point;

		// sort variables:
		public var sort:GameObj_Base;
		public var zposInt:int;
		public var next:GameObj_Base;
		
		
		public var originalLevelEdObj:EdObj;
		public var edJoint:EdJoint;
		public var canRestartHere:Boolean;
		public var bd:BitmapData; 
		public var id:String;
		public var xpos:Number;
		public var ypos:Number;
		public var xpos1:Number;
		public var ypos1:Number;
		public var oldxpos:Number;
		public var oldypos:Number;
		public var oldrot:Number;
		public var xpos2:Number;
		public var xpos3:Number;
		public var ypos2:Number;
		public var zpos:Number;
		public var camZ:Number;
		public var zvel:Number;
		public var active:Boolean;
		public var killed:Boolean;
		public var visible:Boolean;
		public var renderShadowFlag:Boolean;
		public var starty:Number;
		public var startx:Number;
		public var startz:Number;
		public var type:int;
		public var subtype:int;
		public var state:int;
		public var state1:int;
		public var nextState:int;
		public var controlIndex:int;
		public var xoffset:Number;
		public var yoffset:Number;
		public var origxvel:Number;
		public var xvel:Number;
		public var yvel:Number;
		public var xacc:Number;
		public var yacc:Number;
		public var timer:Number;
		public var timer1:Number;
		public var timer2:Number;
		public var timer3:Number;
		public var timerMax:Number
		public var timer1Max:Number
		public var timer2Max:Number
		public var timer3Max:Number

		public var animHierarchy:AnimHierarchy;
		public var dobj:DisplayObj;
		public var dobj1:DisplayObj;
		public var dobj2:DisplayObj;
		public var dobj3:DisplayObj;
		
		public var frame:Number;
		public var frame1:Number;
		public var frame2:Number;
		public var frame3:Number;
		public var frameVel:Number;
		public var frameVel1:Number;
		public var frameVel2:Number;
		public var animBouncing:Boolean;
		
		public var isPolyObject:Boolean;
		public var polyMaterial:PolyMaterial;
		var clickTestType:int;

		public var radius:Number;
		public var colOffsetX:Number;
		public var colOffsetY:Number;

		public var movementVec:Vec;
		public var movementVec1:Vec;
		public var driveVec:Vec;
		var initParams:String;
		var initFunctionVarString:String;
		public var linkedPhysLine:EdLine;
		var hitIsOngoing_Nape:Boolean = false;
		var hitIsSensor:Boolean = false;
		
		
		public var useMultiplePhysicsUpdates:Boolean;
		
		public var oldDir:Number;
		public var dir:Number;
		public var dir1:Number;
		public var todir:Number;
		public var toPosX:Number;
		public var toPosY:Number;
		public var speed:Number;
		public var origspeed:Number;
		public var count:int;
		public var hitTimer:Number;
		var minFrame:int;
		var maxFrame:int;
		var rotVel:Number;
		var dist:Number;		// generic dist stuff
		var flashTimer:int;
		var flashTimerMax:int;
		var flashFlag:Boolean;
		public var xflip:Boolean;
		var healthBarTimer:int;
		var health:Number;
		var maxHealth:Number;
		
		var logicLink0:Array;
		var logicLink1:Array;

		var path:Poly;
		var maxSpeed:Number;
		var currentMaxSpeed:Number;
		var parentObj:GameObj;
		var targetObj:GameObj;
				
		var updateInWalkthrough:Boolean;
		var respawnArea:Boolean;		
		var inFrontZone:Poly;		
		public var name:String;
		public var collisionType:String;
		public var collisionExtra:String;
		public var scale:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		var scale1:Number;
		var uniqueID:int;
		var isPhysObj:Boolean;
		public var alpha:Number;
		var alphaVel:Number;
		var renderSmooth:Boolean;

		var currentPoly:Poly;
		
		var sortByY:Boolean;
		var isVehicle:Boolean;
		var soundTimer:int;

		var onHitSceneryFunction:Function;
		var onHitExplosionFunction:Function;
		var onHitFunction:Function;
		var onHitPersistFunction:Function;
		var onHitRemoveFunction:Function;
		var removeFunction:Function;
		var nape_bodyOffset:Vec2;
		var nape_bodies:Vector.<Body>;
		var nape_joints:Vector.<Constraint>;
		var joints:Array;
		var physobj:PhysObj;
		var scoreType:String;
		var score:int;
		var hit_sfx_name:String;
		var break_sfx_name:String;
		var singleHitResponse:Boolean;
		
		var jointList:Array;
		var hitShapeName:String;
		
		var isIndependant:Boolean;
		
		var s3dTriListIndex:int;
		var s3dTriListIndex1:int;
		var s3dTriListIndex2:int;
		var m3d:Matrix3D;
		var ct:ColorTransform;
		var hitOpponentLast:Boolean
		
		public function GameObj_Base()
		{
			gmat3d = new Matrix3D();
			gmat = new Matrix();
			grect = new Rectangle();
			gpoint = new Point();
			xpos = 0;
			ypos = 0;
			zpos = 1;
			camZ = 0;
			starty = 0;
			startx = 0;
			active = false;
			killed = false;
			zpos = 0;
			frame =0;
			frameVel = 1;
			controlIndex = 0;
			timer = 0;
			timer1 = 0;
			radius = 14;
			minFrame = 0;
			maxFrame = 0;
			movementVec = new Vec();
			movementVec1 = new Vec();
			dobj = null;
			dobj1 = null;
			dobj2 = null;
			isIndependant = false;
			m3d = new Matrix3D();
			ct = new ColorTransform();

		}
		
		
		public function Init(_type:int):void
		{
			id = "";
			var i0:int = 0;
			var f0:Number = 0;
			
			canRestartHere = false;
			
			s3dTriListIndex = -1;
			
			isIndependant = false;
			type = _type;
			state = i0;
			xvel = f0;
			yvel = f0;
			frame = f0;
			frameVel = f0;
			animBouncing = false;
			timer = f0;
			hitTimer =f0;
			flashTimer = i0;
			flashFlag = false;
			dir = 0;
			todir = 0;
			healthBarTimer = 0;
			health = 1.0;
			zvel = 0.0;
			name = "";
			collisionType = "";
			collisionExtra = "";
			scale = 1.0;
			xflip = false;
			doSwitchFunction = null;
			renderShadowFunction = null;
			updateFunction = null;
			updateFromPhysicsFunction = null;
			updateFunction1 = null;
			preRenderFunction = null;
			preRenderFunction1 = null;
			renderFunction = null;
			clipFunction = null;
			miniMapRenderFunction = null;
			switchFunction = null;
			visible = true;
			renderShadowFlag = false;
			ClearColFlags();
			isPhysObj = false;
			alpha = 1.0;
			xpos1 = 0;
			ypos1 = 0;
			renderSmooth = true;
			frameVel = 1;
			isVehicle = false;
			sortByY = false;
			killed = false;
			initParams = "";
			dobj = null;
			dobj1 = null;
			dobj2 = null;
			
			logicLink0 = new Array();
			logicLink1 = new Array();
			
			clickTestType = 0;
			
			jointList = new Array();

			physobj = null;
			onHitSceneryFunction = null;
			onHitFunction = null;
			onHitExplosionFunction = null;
			onHitRemoveFunction = null;
			onHitPersistFunction = null;
			removeFunction = null;
			
			linkedPhysLine = null;
			
			joints = new Array();
			polyMaterial = null;
			isPolyObject = false;
			respawnArea = false;
			scoreType = "";
			hit_sfx_name = "";
			break_sfx_name = "";
			singleHitResponse = false;
			keepAwakeFunction = null;
			useMultiplePhysicsUpdates = false;
			isAwake = true;
			
			onClickedFunction = null;
			canClickFunction = null;
			onMouseOverFunction = null;
			onMouseOutFunction = null;
			isJointObj = false;
			
			updateInWalkthrough = false;
			hitOpponentLast = false;
			minimapID = -1;
			
			isStaticObject = false;
			nape_bodies = null;
			
			ct.alphaMultiplier = ct.redMultiplier = ct.greenMultiplier = ct.blueMultiplier = 1;
			ct.alphaOffset = ct.redOffset = ct.greenOffset = ct.blueOffset = 0;
		}

		
		public var colFlag_jumpon:Boolean;
		public var colFlag_playercanbekilled:Boolean;
		public var colFlag_killPlayer:Boolean;
		public var colFlag_canBePickedUp:Boolean;
		public var colFlag_dontDamagePlayer:Boolean;
		public var colFlag_canBeShot:Boolean;
		public var colFlag_isBullet:Boolean;
		public var colFlag_isEnemy:Boolean;
		public var colFlag_isEnemyBullet:Boolean;
		public var colFlag_isPlatform:Boolean;
		public var colFlag_isPowerup:Boolean;
		public var colFlag_isSwitch:Boolean;
		public var colFlag_isBouncyPad:Boolean;
		public var colFlag_isCheckpoint:Boolean;
		public var colFlag_isShop:Boolean;
		public var colFlag_isBall:Boolean;
		public var colFlag_isHose:Boolean;
		public var colFlag_isPlayer:Boolean;
		public var colFlag_isPhysObj:Boolean;
		public var colFlag_isGoPhysObj:Boolean;
		public var colFlag_isRemovable:Boolean;
		
		function ClearColFlags()
		{
			colFlag_jumpon = false;
			colFlag_killPlayer = false;
			colFlag_playercanbekilled = false;
			colFlag_dontDamagePlayer = false;
			colFlag_canBePickedUp = false;
			colFlag_canBeShot = false;
			colFlag_isBullet = false;
			colFlag_isPlatform = false;
			colFlag_isPowerup = false;
			colFlag_isBouncyPad = false;
			colFlag_isCheckpoint = false;
			colFlag_isShop = false;
			colFlag_isEnemyBullet = false;
			colFlag_isEnemy = false;
			colFlag_isBall = false;
			colFlag_isHose = false;
			colFlag_isPlayer = false;
			colFlag_isPhysObj = false;
			colFlag_isGoPhysObj = false;
			colFlag_isSwitch = false;
			colFlag_isRemovable = false;
		}

//---------------------------------------------------------------------------------------------
// Render Functions:
//---------------------------------------------------------------------------------------------

		// returns true if clipped, false if no clip
		public function ClipFunction_NoClip():Boolean
		{
			return false;
		}
		public function TestClip():Boolean
		{
			if (clipFunction != null)
			{
				return clipFunction();
			}
			if (xpos < Game.camera.x - 500) return true;
			if (ypos < Game.camera.y - 500) return true;
			if (xpos > Game.camera.x+Defs.displayarea_w + 500) return true;
			if (ypos > Game.camera.y + Defs.displayarea_h + 500) return true;
			return false;
		}
		
		public function ClipFunction_Big():Boolean
		{
			if (xpos < Game.camera.x - 500) return true;
			if (ypos < Game.camera.y - 500) return true;
			if (xpos > Game.camera.x+Defs.displayarea_w + 500) return true;
			if (ypos > Game.camera.y + Defs.displayarea_h + 500) return true;
			return false;
			
		}

		public function ClipFunction_Player():Boolean
		{
			if (xpos < Game.camera.x -50) return true;
			if (ypos < Game.camera.y -150) return true;
			if (xpos > Game.camera.x+Defs.displayarea_w +50) return true;
			if (ypos > Game.camera.y + Defs.displayarea_h +100) return true;
			return false;			
		}

		
		public function Render(_bd:BitmapData):void
		{		
			bd = _bd;
			if (visible == false) return;
			
			if (renderFunction != null)
			{
				renderFunction();
			}
			else
			{
				RenderDispObjNormally();
			}			
		}
		
		public function RenderShadow(_bd:BitmapData):void
		{		
			bd = _bd;
			if (visible == false) return;
			if (renderShadowFlag == false) return;
			if (dobj == null) return;
			
			
			if (renderShadowFunction != null)
			{
				renderShadowFunction();
			}
			else
			{
				//RenderDispObjShadow();
			}
		}
		
		var shadowCT:ColorTransform = new ColorTransform(1, 1, 1, 1, -255, -255, -255, -128);
		
//=================================================
		
		function RenderDispObjNormally(_useScroll:Boolean = true,renderOffset:Vec2=null)
		{
			RenderDispObjAt(xpos, ypos, dobj, frame, ct, dir, scale, _useScroll,renderOffset);
		}
		
		function RenderDispObjAt(_xpos:Number,_ypos:Number, _dobj:DisplayObj,_frame:int,_ct:ColorTransform = null,_dir:Number=0, _scale:Number=1,_useScroll:Boolean=true,renderOffset:Vec2=null,alpha:Number=1)
		{
			if (_dobj == null) return;
			var sc:Number = _scale;
			
			var xp:Number = Math.round(_xpos);
			var yp:Number =  Math.round(_ypos);
			if (_useScroll)
			{
				xp =  Math.round(_xpos) - Math.round(Game.camera.x);
				yp =  Math.round(_ypos) - Math.round(Game.camera.y);
				var zp:Number = camZ- Game.camera.z;
			
				if (zp != 0)
				{
					var camScale:Number = Game.camera.PerspectiveTransform(xp,yp,zp);
					sc *= camScale;
					xp = Game.camera.transformX;
					yp = Game.camera.transformY;
				}			
			}
			
			
			if (alpha != 1)
			{
				ct.alphaMultiplier = alpha;
				_ct = ct;
			}

			
			
			if (sc != 1.0 || _dir != 0.0 || _ct != null)
			{
				if (xflip)
				{
					_dobj.RenderAtRotScaled_Xflip( _frame, bd, xp, yp, sc,_dir,_ct,renderSmooth);					
				}
				else
				{
					if (renderOffset != null)
					{
						_dobj.RenderAtRotScaled_Offset( _frame, bd, xp, yp, -renderOffset.x,-renderOffset.y,sc,_dir,_ct,renderSmooth);					
					}
					else
					{
						_dobj.RenderAtRotScaled( _frame, bd, xp, yp, sc,_dir,_ct,renderSmooth);											
					}
					
				}
			}
			else
			{
				if (xflip)
				{
					_dobj.RenderAtXFlip( _frame, bd, xp, yp);
				}
				else
				{
					_dobj.RenderAt( _frame, bd, xp, yp);
				}
			}			
			
		}

		
		
		function RenderCollision():void
		{
			if (EngineDebug.IsSet(1) == false) return;
			if (colFlag_isGoPhysObj == false) return;
			
			
			
			var x:Number = 0;
			var y:Number = 0;
			x += xpos;
			x -= Game.camera.x;
			x += colOffsetX;
			y += ypos;
			y -= Game.camera.y;
			y += colOffsetY;
			Utils.RenderCircle(bd, x, y, radius, 0xffffffff);
		}

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------
// General Helpers
//-------------------------------------------------------------------------------------------
		

		function IsInWorld(radius:Number):Boolean
		{
			if (xpos < 0 - radius) return false;
			if (ypos < 0 - radius) return false;
			if (xpos > Defs.displayarea_w + radius) return false;
			if (ypos > Defs.displayarea_h+ radius) return false;
			return true;
		}
		
//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------

		public function GetDirBetween(x0,y0,x1,y1):Number
		{
			var d = Math.atan2(y1-y0,x1-x0);
			return d;
		}

//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------
		
		public function GetVelFromDir(vel:Number)
		{
			xvel = Math.cos(dir) * vel;
			yvel = Math.sin(dir) * vel;
		}

//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------
		
		
		public function CycleAnimationEx():Boolean
		{
			var looped:Boolean = false;
			
			if (animBouncing == false)
			{
				frame += frameVel;
				var numFrames = maxFrame - minFrame;
				if(frame > maxFrame) 
				{
					frame = frame - numFrames;
					looped = true;
				}
				if(frame <minFrame)
				{
					frame += numFrames;
					looped= true;
				}
			}
			else
			{
				frame += frameVel;
				var numFrames = maxFrame - minFrame;
				if(frame > maxFrame) 
				{
					frameVel *= -1;
					frame = maxFrame;
					looped = true;
				}
				if(frame <minFrame)
				{
					frameVel *= -1;
					frame = minFrame;
					looped= true;
				}				
			}
			return looped;
		}
		public function PlayAnimationEx():Boolean
		{
			var looped:Boolean = false;
			frame += frameVel;
			if(frame > maxFrame) 
			{
				frame = maxFrame;
				looped = true;
			}
			if(frame <minFrame)
			{
				frame =minFrame;
				looped= true;
			}
			return looped;
		}

		public function CycleAnimation():void
		{
			var fv:Number = frameVel;
			var maxframe:int = dobj.GetNumFrames();

			frame += fv;
			if(frame >= maxframe) frame -= (maxframe);
			if (frame < 0) frame += (maxframe);
		}
		public function CycleAnimation1():void
		{
			var fv:Number = frameVel1;
			var maxframe:int = dobj1.GetNumFrames();

			frame1 += fv;
			if(frame1 >= maxframe) frame1 -= (maxframe);
			if (frame1 < 0) frame += (maxframe);
		}

		public function PlayAnimation():Boolean
		{
			var maxframe:int = dobj.GetNumFrames()-1;
			frame += frameVel;
			if(frame > maxframe) 
			{
				frame = maxframe;
				return true;
			}
			if(frame < 0) 
			{
				frame = 0;
				return true;
			}
			return false;
		}
		public function PlayAnimation1():Boolean
		{
			var maxframe:int = dobj1.GetNumFrames()-1;
			frame1 += frameVel1;
			if(frame1 >= maxframe) 
			{
				frame1 = maxframe;
				return true;
			}
			return false;
		}
		public function PlayAnimation2():Boolean
		{
			var maxframe:int = dobj2.GetNumFrames()-1;
			frame2 += frameVel2;
			if(frame2 >= maxframe) 
			{
				frame2 = maxframe;
				return true;
			}
			return false;
		}

//----------------------------------------------------------------------------------------
// Update functions:
//----------------------------------------------------------------------------------------
		
		public function Update():void
		{

			if (keepAwakeFunction != null)
			{
				keepAwakeFunction();
			}
			
			if (updateFunction != null)
			{
				updateFunction();
			}	
			
			if (sortByY)
			{
				//zpos = 0 - (ypos * 0.01);
			}
		}
		
		
//---------------------------------------------------------------------------------------------
// Sleep / wake functions
//---------------------------------------------------------------------------------------------


		public function InitKeepAwakeFunction()
		{
			if (physobj != null)
			{
				if (physobj.wakeFunctionName != "")
				{
					keepAwakeFunction = this[physobj.wakeFunctionName];
				}
			}
			
		}
	


		function KeepAwake_Constant()
		{
			WakeUpPhysics();
		}
		
		
		
		

		function WakeUpPhysics()
		{
			if (isAwake) return;
			isAwake = true;
			PhysicsBase.GetNapeSpace().bodies.add(nape_bodies[0]);
			trace("waking " + name);
		}
		function SleepPhysics()
		{
			if (isAwake == false) return;
			isAwake = false;
			PhysicsBase.GetNapeSpace().bodies.remove(nape_bodies[0]);
			trace("putting to sleep" + name);
		}
		
		

		

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
// Path and switch generic objects:
//---------------------------------------------------------------------------------------------

		var switch_timer:int;
		var switchType:String;
		function InitGameObj_Switch()
		{
			colFlag_isSwitch = true;
			name = "switch";
			
			Utils.GetParams(initParams);

			switchType = Utils.GetParam("type");
			
			if (switchType == "") switchType = "once";

			if (switchType == "once")
			{
				doSwitchFunction = SwitchedGameObj_Switch;				
				updateFunction = null;
				state = 0;
				frame = dobj.GetFrameIndexLabel("on");
			}
			if (switchType == "timed")
			{
				switch_timer = Utils.GetParamNumber("switch_time") * Defs.fps;
				doSwitchFunction = SwitchedGameObj_TimedSwitch;				
				updateFunction = UpdateGameObj_TimedSwitch;
				frame = dobj.GetFrameIndexLabel("on");
			}
			if (switchType == "2way")
			{
				doSwitchFunction = SwitchedGameObj_TwoWaySwitch;				
				updateFunction = UpdateGameObj_TwoWaySwitch;
				frame = dobj.GetFrameIndexLabel("on");
				state = 0;
			}
			switchContactList = new Array();
		}
		
		var switchContactList:Array;
		
		function Switch_IsInContactList(go:GameObj):Boolean
		{
			if (switchContactList.indexOf(go) == -1) return false;
			return true;
		}
		function Switch_AddToContactList(go:GameObj)
		{
			switchContactList.push(go);
		}
		function Switch_RemoveFromContactList(go:GameObj)
		{
			var index:int = switchContactList.indexOf(go);
			switchContactList.splice(index, 1);
		}
		function Switch_IsDown():Boolean
		{
			if (switchType == "once") 
			{
				if (state == 0) return false;
				return true;
			}
			if (switchType == "timed") 
			{
				if (state == 0) return false;
				return true;
			}
			if (switchType == "2way") 
			{
				if (state == 0) return false;
				return true;
			}
			return false;
		}
		
		
//-------------------------------------

		function SwitchedGameObj_TwoWaySwitch():Boolean
		{
			
			if (state == 0)
			{
				state = 1;
				frame = dobj.GetFrameIndexLabel("off");
				return true;
			}
			else
			{
				state = 0;
				frame = dobj.GetFrameIndexLabel("on");
				return true;				
			}
			return false;
		}
		
//-------------------------------------

		function UpdateGameObj_TwoWaySwitch()
		{
			/*
			if (controlMode == 0)	
			{
				controlMode = 2;
			}
			else
			{
				controlMode = 1;
			}
			*/
		}
		
		
//-------------------------------------

		function SwitchedGameObj_Switch():Boolean
		{
			
			if (state == 1) return false;
			
			if (state == 0)
			{
				state = 1;
				state = 1;
				frame = dobj.GetFrameIndexLabel("off");
				return true;
			}
			return false;
		}
		
//-------------------------------------
		function UpdateGameObj_TimedSwitch()
		{
			if (state == 1)
			{
				timer--;
				if (timer <= 0)
				{
					Game.DoGameObjSwitch(this);
					state = 0;					
				}
			}			
		}
		
//------------------------------------------		
		
		function SwitchedGameObj_TimedSwitch():Boolean
		{
			
			var retval:Boolean = true;
			
			if (state == 0)
			{
//				go.controlMode = 1;
				state = 1;
				timer = switch_timer;
				retval = true;
			}
			else
			{
				retval = false;
			}
			return retval;
		}
		
//-----------------------------------------------------------------------------------------------------

		function Update_SimpleRotator()
		{
			dir += rotVel;
			dir = Utils.NormalizeRot(dir);
		}
		
		
		function Init_SimpleRotator()
		{
			Utils.print("Init_SimpleRotator");			
			Utils.GetParams(initParams);
			
			rotVel = Utils.DegToRad(Utils.GetParamNumber("rotation_speed", 0));
			
			updateFunction = Update_SimpleRotator;
			
			
		}
		
//-----------------------------------------------------------------------------------------------------

		function Update_PlayAnimList()
		{
			if (PlayAnimationEx())
			{
				Utils.GetParams(initFunctionVarString);
				currentAnim++;
				if (currentAnim >= numAnims) currentAnim = 0;
				var s:String = Utils.paramNames[currentAnim];
				frameVel = Number(Utils.paramValues[currentAnim]);
				SetAnimRange(s + "_start", s + "_end", true);
			}
		}
		
		
		var numAnims:int;
		var currentAnim:int;
		function Init_PlayAnimList()
		{
			Utils.print("Init_PlayAnimList");			
			Utils.GetParams(initFunctionVarString);
			
			numAnims = Utils.paramNames.length;
			currentAnim = 0;
			
			updateFunction = Update_PlayAnimList;
			
			var s:String = Utils.paramNames[currentAnim];
			frameVel = Number(Utils.paramValues[currentAnim]);
			SetAnimRange(s + "_start", s + "_end", true);
			
		}

		
//-----------------------------------------------------------------------------------------------------

		function Set_SwitchedAnim(_mode:int)
		{
			state = _mode;
			if (state == 0) SetAnimRange("idle_off_start", "idle_off_end", true);
			if (state == 1) SetAnimRange("off_on_start", "off_on_end", true);
			if (state == 2) SetAnimRange("idle_on_start", "idle_on_end", true);
			if (state == 3) SetAnimRange("on_off_start", "on_off_end", true);
		}
		function Update_SwitchedAnim()
		{
			if (state == 0)
			{
				CycleAnimationEx();
			}
			else if (state == 1)
			{
				if (PlayAnimationEx()) Set_SwitchedAnim(2);
			}
			else if (state == 2)
			{
				CycleAnimationEx();
			}
			else if (state == 3)
			{
				if (PlayAnimationEx()) Set_SwitchedAnim(0);
			}
		}
		
		function SwitchFunction_SwitchedAnim()
		{
			if (state == 0)
			{
				if (dobj.DoesFrameIndexLabelExist("off_on_start"))
				{
					Set_SwitchedAnim(1);
				}
				else
				{
					Set_SwitchedAnim(2);
				}
			}
			else if(state == 2)
			{
				if (dobj.DoesFrameIndexLabelExist("on_off_start"))
				{
					Set_SwitchedAnim(3);
				}
				else
				{
					Set_SwitchedAnim(0);
				}
			}
		}
		
		function Init_SwitchedAnim()
		{
			Utils.print("Init SwitchedAnim");			
			Utils.GetParams(initParams);
			
			updateFunction = Update_SwitchedAnim;
			switchName = Utils.GetParamString("switch","");
			var startPos:int = Utils.GetParamInt("startpos",0);
			
			Set_SwitchedAnim(startPos);
			
			
			switchFunction = null;
			if (switchName != "") 
			{
				switchFunction = SwitchFunction_SwitchedAnim;
			}
			
		}

//-----------------------------------------------------------------------------------------------------


		var lineLinearPos:Number;
		var lineSpeed:Number;
		var lineIndex:int;
		var lineLoop:Boolean;
		var lineResetAtEnd:Boolean;
		var lineSpline:Boolean;
		var lineRotateToPath:Boolean;
		var path_pointtoobjectName:String;
		
		var switchName:String;
		var switchName1:String;

//-----------------------------------------------------------------------------------------------------------				
		
		public function InitPhysObj_Path_Virtual()
		{
			InitPhysObj_Path();
			visible = false;
			if (Game.usedebug) visible = true;
		}

		public function InitPhysObj_Path_Sticky()
		{
			InitPhysObj_Path();
			collisionType = "sticky";
		}
		
		function InitPhysObj_Path_Normal()
		{
			InitPhysObj_Path();
		}
		function InitPhysObj_Path_Deadly()
		{
			InitPhysObj_Path();
			name = "death";
//			onHitFunction = OnHitSpikes;				

		}

		
		
		
		function InitGameObj_Path()
		{
			
			Utils.print("Init path object");
			
			Utils.GetParams(initParams);
			
			for (var i:int = 0; i < Utils.paramNames.length; i++)
			{
				Utils.print("InitGameObj_Path: Param " + i + ":  " + Utils.paramNames[i] + "   =   " + Utils.paramValues[i]);
			}
			
			
			var lineName:String = Utils.GetParam("path_line", "");
			if (lineName == "")
			{
				lineIndex = -1;
			}
			else
			{
				lineIndex = Game.GetLineIndexByName(lineName);				
			}
				
			if (lineIndex == -1)
			{
				updateFunction = null;
			}
			
			
			lineSpeed = 1 / (Utils.GetParamNumber("path_speed")*Defs.fps) ;
			lineLoop = Utils.GetParamBool("path_loop");
			switchName = Utils.GetParam("path_switch","");
			lineResetAtEnd = Utils.GetParamBool("path_endreset");
			lineSpline = Utils.GetParamBool("path_spline");
			lineRotateToPath = Utils.GetParamBool("path_rotatetopath",false);
			lineLinearPos = 0;
			var startPos:Number = Utils.GetParamNumber("path_startpos", 0);
			
			lineLinearPos = startPos;
			
			var twoway:Boolean = Utils.GetParamBool("path_2way");
			
			
			state = 1;
			switchFunction = null;
			updateFunction = null;
			if (lineIndex != -1) 
			{
				if (switchName != "") 
				{
					state = 0;
					switchFunction = SwitchFunction_Path;
				}
				else
				{
					state = 1;
				}
				updateFunction = UpdateObj_Path;

			}
			
			if (twoway)
			{
				updateFunction = UpdateObj_Path_2way;				
				if (switchName != "") 
				{
					switchFunction = SwitchFunction_Path_2way;
					updateFunction = UpdateObj_Path_2way_switched;				
				}
			}
		}

		function SwitchFunction_Path_2way()
		{
			if (state == 0)	// stopped
			{
				state = 1;
			}
			else if(state == 1)
			{
			Utils.print("path 2way 2");
				state = 2;
			}
			else
			{
			Utils.print("path 2way 1");
				state = 1;
			}
		}

		function UpdateObj_Path_2way()
		{
			if (lineRotateToPath)
			{
				dir = GetLineAngle();
			}
			
			if (state == 0)
			{
				state = 1;
			}
			
			if(state == 1)
			{			
				var pos:Point = UpdateLine(lineSpeed);
				xpos = pos.x;
				ypos = pos.y;
				if (lineLinearPos >= 1) state = 2;
			}
			else if(state == 2)
			{			
				var pos:Point = UpdateLine(-lineSpeed);			
				xpos = pos.x;
				ypos = pos.y;
				if (lineLinearPos <= 0) state = 1;
			}
		}
		
		function UpdateObj_Path_2way_switched()
		{
			if (lineRotateToPath)
			{
				dir = GetLineAngle();
			}
			
			if (state == 0)
			{
				var pos:Point = UpdateLine(0);			
				xpos = pos.x;
				ypos = pos.y;				
			}
			else if(state == 1)
			{			
				var pos:Point = UpdateLine(lineSpeed);			
				xpos = pos.x;
				ypos = pos.y;
			}
			else if(state == 2)
			{			
				var pos:Point = UpdateLine(-lineSpeed);			
				xpos = pos.x;
				ypos = pos.y;
			}
		}				
		
//-------------------------------------------------------------------------------		
		function SwitchFunction_Path()
		{
			if (state == 0)
			{
				state = 1;
			}
		}
		function UpdateObj_Path()
		{
			
			if (lineRotateToPath)
			{
				dir = GetLineAngle();
			}
			
			if (state == 0)
			{
				var pos:Point = UpdateLine(0);			
				xpos = pos.x;
				ypos = pos.y;
			}
			else
			{	
				var pos:Point = UpdateLine(lineSpeed);			
				xpos = pos.x;
				ypos = pos.y;
				
				if (lineLoop == false)
				{
					if (lineLinearPos >= 1)
					{
						lineLinearPos = 1;
						if (lineResetAtEnd)
						{
							lineLinearPos = 0;
						}
						state = 0;
					}
				}				
			}
			
		}				
		function GetLineAngle():Number
		{
			var line:EdLine = Levels.GetCurrent().lines[lineIndex];
			if (line == null) return 0;
			
			var p0:Point;
			var p1:Point;
			if (lineLinearPos < 0.5)
			{
				p0 = line.GetInterpolatedPoint_SegmentRatio(lineLinearPos, lineLoop, lineSpline);
				p1 = line.GetInterpolatedPoint_SegmentRatio(lineLinearPos+0.01, lineLoop, lineSpline);
			}
			else
			{
				p0 = line.GetInterpolatedPoint_SegmentRatio(lineLinearPos-0.01, lineLoop, lineSpline);
				p1 = line.GetInterpolatedPoint_SegmentRatio(lineLinearPos, lineLoop, lineSpline);
			}
			
			var ang:Number = Math.atan2(p1.y - p0.y, p1.x - p0.x);
			return ang;
		}
		function UpdateLine(_spd:Number):Point
		{
			lineLinearPos += _spd;
			if (lineLinearPos > 1) 
			{
				if(lineLoop == true)
					lineLinearPos -= 1;
				else
					lineLinearPos = 1;
			}
			if (lineLinearPos < 0) 
			{
				if(lineLoop == true)
					lineLinearPos += 1;
				else
					lineLinearPos = 0;
			}
			
			var line:EdLine = Levels.GetCurrent().lines[lineIndex];
			if (line == null) return new Point(0, 0);
			
			var p:Point;
			
			//var pathEaseName:String;
			//var pathEaseValue:Number;
			
			var lp:Number = lineLinearPos;

			if (pathEaseName != null && pathEaseName != "" && pathEaseName != "linear")
			{
				lp = Ease.EaseByName(pathEaseName, lp, pathEaseValue);
			}
			
			if (lineLoop == true && lineSpline == false)
			{
				p = line.GetInterpolatedPoint_SegmentRatio(lp,lineLoop, lineSpline);
			}
			else
			{
				p = line.GetInterpolatedPoint_EqualSpacing(lp, lineLoop, lineSpline);
			}
			return p;			
		}

//--------------------------------------------------------------------------------------------------
// Standard from-data generic updates
//--------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------			
		function GameObj_InitInvisible():void
		{
			visible = false;
		}

//------------------------------------------------------------------------------------------------------------			
		function GameObj_InitCycleAnim():void
		{
			updateFunction = GameObj_UpdateCycleAnim;
			frameVel = 1;
		}
		function GameObj_UpdateCycleAnim():void
		{
			CycleAnimation();
		}

		function GameObj_UpdateCycleAnimEx():void
		{
			CycleAnimationEx();
		}
		function GameObj_UpdatePlayAnimEx():void
		{
			CycleAnimationEx();
		}
		
		function InitSortByY():void
		{
			sortByY = true;
		}		

//------------------------------------------------------------------------------------------------------------		
// Animation
//------------------------------------------------------------------------------------------------------------		

		function SetAnimRangeSingle(name, reset:Boolean = true, _bounce:Boolean = false )
		{
			animBouncing = _bounce;
//			if (animBouncing) Utils.trace("bouncing init");
			SetAnimRange(name, name + "_end", reset,_bounce);
		}
		function SetAnimRange(fr0Name:String,fr1Name:String,reset:Boolean=true, _bounce:Boolean = false)
		{
			animBouncing = _bounce;
			minFrame = dobj.GetFrameIndexLabel(fr0Name);
			maxFrame = dobj.GetFrameIndexLabel(fr1Name);
			if (frame < minFrame) frame = minFrame;
			if (frame > maxFrame) frame = maxFrame;
			if (reset)
			{
				frame = minFrame;
			}
		}


		var anims:Array;
		function SetAnim(name:String,reset:Boolean=true,_bounce:Boolean = false)
		{
			dobj = GraphicObjects.GetDisplayObjByName(name);
			minFrame = 0;
			maxFrame = dobj.GetNumFrames() - 1;
			
			// For timeline based anims:
			
//			for each(var a:Anim in anims)
//			{
//				if (a.name == name)
//				{
//					minFrame = a.minFrame;
//					maxFrame = a.maxFrame;
//					frameVel = a.speed;
//				}
//			}

			if (frame < minFrame) frame = minFrame;
			if (frame > maxFrame) frame = maxFrame;
			if (reset)
			{
				frame = minFrame;
			}
		}

//---------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------
// Physics stuff:
//---------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------

	

		public function SetBodyShapeRadius(bodyIndex:int,shapeIndex:int,radius:Number)
		{
			var b:Body = nape_bodies[bodyIndex];
			var c:Circle = b.shapes.at(shapeIndex) as Circle;
			c.radius = radius;
		}

		public function SetBodyShapeMaterial(bodyIndex:int,shapeIndex:int,materialName:String)
		{
			var physMaterial:PhysObj_Material = Game.GetPhysMaterialByName(materialName);
			var b:Body = nape_bodies[bodyIndex];
			var s:Shape = b.shapes.at(shapeIndex);
			s.material = physMaterial.MakeNapeMaterial();
		}
		
		
		public function GetBodyLinearVelocity(index:int):Vec2
		{
			return nape_bodies[index].velocity;
		}

		public function RemovePhysObjJoints()
		{

			
			for each(var j:Constraint in nape_joints)
			{
				if (j != null)
				{
					if (PhysicsBase.GetNapeSpace().constraints.has(j))
					{
						PhysicsBase.GetNapeSpace().constraints.remove(j);
						
						for each(var go:GameObj in GameObjects.objs)
						{
							if (go.active && go.isJointObj)
							{
								go.JointObject_JointRemoved(j);
							}
						}
						
					}
				}
			}
			nape_joints = new Vector.<Constraint>();
			
			var b:Body = nape_bodies[0];
			for (var i:int = 0; i < b.constraints.length; i++)
			{
				var c:Constraint = b.constraints.at(i);
				PhysicsBase.GetNapeSpace().constraints.remove(c);
			}
			
		}
		
		

		public function RemovePhysObj()
		{
			for each(var j:Constraint in nape_joints)
			{
				if (PhysicsBase.GetNapeSpace().constraints.has(j))
				{
					PhysicsBase.GetNapeSpace().constraints.remove(j);
					
					for each(var go:GameObj in GameObjects.objs)
					{
						if (go.active && go.isJointObj)
						{
							go.JointObject_JointRemoved(j);
						}
					}
					
				}
			}
			nape_joints = new Vector.<Constraint>();
			
			var b:Body = nape_bodies[0];
			for (var i:int = 0; i < b.constraints.length; i++)
			{
				var c:Constraint = b.constraints.at(i);
				PhysicsBase.GetNapeSpace().constraints.remove(c);
			}
			
			for each(var b:Body in nape_bodies)
			{
				PhysicsBase.GetNapeSpace().bodies.remove(b);				
			}
			nape_bodies = new Vector.<Body>();
			
			
		}		
		
		function RemoveObject(_func:Function=null)
		{
			if (_func != null)
			{
				removeFunction = _func;
			}
			killed = true;										
		}
		
		
		public function GetBody(index:int):Body
		{
			var body:Body = nape_bodies[index];
			return body;
		}
		public function GetBodyMass(index:int):Number
		{
			var body:Body = nape_bodies[index];
			return body.mass;
		}		
		
		public function ApplyImpulse(_x:Number, _y:Number):void
		{
			for each(var b:Body in nape_bodies)
			{
				b.applyImpulse(new Vec2(_x, _y));
//				b.applyLocalImpulse(new Vec2(_x, _y));
			}
		}
		
		public function ApplyForce(_x:Number, _y:Number):void
		{
			for each(var b:Body in nape_bodies)
			{
				b.velocity.x += _x;
				b.velocity.y += _y;
			}
		}
		
		
		public function SetBodyLinearVelocity(index:int, x:Number, y:Number)
		{
			var b:Body = nape_bodies[index];
			b.velocity.x = x;
			b.velocity.y = y;
			
		}
		public function SetBodyAngularVelocity(index:int,r:Number)
		{
			var b:Body = nape_bodies[index];
			b.angularVel = r;
		}

		public function GetBodyAngle(index:int):Number
		{
			var body:Body = nape_bodies[index];
			return body.rotation;
		}
		
		public function SetBodyAngle(index:int,ang:Number)
		{
			var body:Body = nape_bodies[index];
			body.rotation = ang;
		}
		
		public function SetBodyXForm_Immediate(_index:int, _x:Number, _y:Number, rot:Number):void
		{
			var body:Body = nape_bodies[0];
			if (body.type == BodyType.STATIC)
			{
				body.type = BodyType.KINEMATIC;				
			}
			body.position.setxy(_x, _y);
			body.rotation = rot;
		}
		public function SetBodyXForm(_index:int,_x:Number, _y:Number,rot:Number):void
		{
			var body:Body = nape_bodies[0];
			body.type = BodyType.KINEMATIC;
			
			var dx:Number = _x - body.position.x;
			var dy:Number = _y - body.position.y;
			var da:Number = rot - body.rotation;
			
			var ts:Number = PhysicsBase.nape_oneOverTimeStep;
			dx *= ts;
			dy *= ts;
			da *= ts;
			
			body.velocity.setxy(dx,dy);
			body.angularVel = da;
		}

		public function SetBodyXFormDynamic(_index:int,_x:Number, _y:Number,rot:Number):void
		{
			var body:Body = nape_bodies[0];
			body.type = BodyType.DYNAMIC;
			
			var dx:Number = _x - body.position.x;
			var dy:Number = _y - body.position.y;
			var da:Number = rot - body.rotation;
			
			var ts:Number = PhysicsBase.nape_oneOverTimeStep;
			dx *= ts;
			dy *= ts;
			da *= ts;
			
			body.velocity.setxy(dx,dy);
			body.angularVel = da;
		}
		
		// assuming one body / one shape
		public function GetBodyCollisionMask():int
		{
			var body:Body;
			var shape:Shape;
			body = nape_bodies[0];
			for (var s:int = 0; s < body.shapes.length; s++)
			{
				shape = body.shapes.at(s);
				return shape.filter.collisionMask;
			}			
			return 0;
		}
		
		// assuming one body / one shape
		public function GetBodySensorMask():int
		{
			var body:Body;
			var shape:Shape;
			body = nape_bodies[0];
			for (var s:int = 0; s < body.shapes.length; s++)
			{
				shape = body.shapes.at(s);
				return shape.filter.sensorMask;
			}			
			return 0;
		}
		
		public function SetBodyCollisionMask(_bodyIndex:int=-1,_mask:int=0):void
		{
			var body:Body;
			var shape:Shape;
			
			if (_bodyIndex == -1)
			{
				for (var i:int = 0; i < nape_bodies.length; i++)
				{
					SetBodyCollisionMask(i, _mask);
				}
			}
			else
			{
				body = nape_bodies[_bodyIndex];
				for (var s:int = 0; s < body.shapes.length; s++)
				{
					shape = body.shapes.at(s);
					shape.filter.collisionMask = _mask;
				}
			}
			
		}

		public function SetBodyShapeCollisionMask(_bodyIndex:int=0,_shapeIndex:int=0,_mask:int=0):void
		{
			var body:Body;
			var shape:Shape;
			
			body = nape_bodies[_bodyIndex];
			shape = body.shapes.at(_shapeIndex);
			shape.filter.collisionMask = _mask;
			
		}
		
		public function SetBodySensorMask(_bodyIndex:int=-1,_mask:int=0):void
		{
			var body:Body;
			var shape:Shape;
			
			if (_bodyIndex == -1)
			{
				for (var i:int = 0; i < nape_bodies.length; i++)
				{
					SetBodySensorMask(i, _mask);
				}
			}
			else
			{
				body = nape_bodies[_bodyIndex];
				for (var s:int = 0; s < body.shapes.length; s++)
				{
					shape = body.shapes.at(s);
					shape.filter.sensorMask = _mask;
				}
			}			
		}
		
		
		
		var hitInteractionCallback_Nape:InteractionCallback;
		var hitContactPoint_Nape:Contact;
		var hitUserData_Nape:Contact;
		
		
//---------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------		

		function HitPhysObj_HitSwitch(goHitter:GameObj)
		{
			if (goHitter.name != "missile") return;
			if (doSwitchFunction != null)
			{
				Utils.print("doing switch ");	// + pi.switchName);
				if (doSwitchFunction()) 
				{
					Utils.print("switch hit");
					Game.DoSwitch(this as GameObj);
				}
			}
		}
		function InitPhysObj_HitSwitch()
		{
			InitPhysObj_Switch();
			onHitFunction = HitPhysObj_HitSwitch;
			
		}
//-------------------------------------------------------------------------------------------		
		function InitPhysObj_Switch()
		{
			
			Utils.GetParams(initParams);

			var switchType:String = Utils.GetParam("type");
			
			if (switchType == "") switchType = "once";

			if (switchType == "once")
			{
				doSwitchFunction = SwitchedPhysObj_Switch;				
				updateFunction = UpdatePhysObj_SwitchOnce;
				state = 0;
			}
			if (switchType == "timed")
			{
				switch_timer = Utils.GetParamNumber("switch_time") * Defs.fps;
				doSwitchFunction = SwitchedPhysObj_TimedSwitch;				
				updateFunction = UpdatePhysObj_TimedSwitch;
			}
			if (switchType == "2way")
			{
				doSwitchFunction = SwitchedPhysObj_TwoWaySwitch;				
				updateFunction = UpdatePhysObj_TwoWaySwitch;
				state = 0;
			}
			frame = 0;
		}

		function SwitchedPhysObj_TwoWaySwitch():Boolean
		{
			
			
			if (state == 0)
			{
				state = 1;
				timer = 10;
				return true;
			}
			return false;
		}

		
		function SwitchedPhysObj_TwoWaySwitch_Anim():Boolean
		{
			
			
			if (state == 0)
			{
				Utils.print("2way 0");
				if (frame == minFrame)
				{
					state = 1;
					return true;
				}
			}
			else
			{
				Utils.print("2way 0");
				if (frame == maxFrame)
				{
					state = 0;
					return true;				
				}
			}
			return false;
		}
		
//-------------------------------------

		function UpdatePhysObj_TwoWaySwitch()
		{
			
			//go.SetAnimRangeSingle("switch",false);

			if (state == 0)	
			{
				frame = 0;

				//go.frameVel = -1;
				//go.PlayAnimationEx();
			}
			else
			{
				frame = 1;
				timer--;
				if (timer <= 0)
				{
					state = 0;
				}
				//go.frameVel = 1;
				//go.PlayAnimationEx();
			}
//			Utils.trace("frame "+go.frame+"    "+go.minFrame+" "+go.maxFrame+"   "+go.frameVel+"     mode="+controlMode);

		}
		
		
//-------------------------------------

		function SwitchedPhysObj_Switch():Boolean
		{
			
			Utils.print("SwitchedPhysObj_Switch");
			
			if (state == 1) return false;
			
			state = 1;
			Game.DoSwitch(this as GameObj);

			//go.SetAnimRangeSingle("switch");
			frame  = 1;
			return true;
		}
		
//-------------------------------------
		function UpdatePhysObj_SwitchOnce()
		{
			if (state == 0)
			{
				
			}
			else if (state == 1)
			{
				
				frame = 1;
			}
			
			/* animated
			if (controlMode == 0)
			{
				
			}
			else if (controlMode == 1)
			{
				var go:GameObj = GetGameObject(0);
				go.PlayAnimationEx();
			}
			*/
		}
		function UpdatePhysObj_TimedSwitch()
		{
			if (state == 1)
			{
				timer--;
				if (timer <= 0)
				{
//					go.GameObj_Switch_StopTimer();
					Game.DoSwitch(this as GameObj);
					state = 0;					
				}
			}			
		}
		
//------------------------------------------		
		
		function SwitchedPhysObj_TimedSwitch():Boolean
		{
			var retval:Boolean = true;
			
			if (state == 0)
			{
//				GameObj_Switch_StartTimer(switch_timer);
//				go.controlMode = 1;
				state = 1;
				timer = switch_timer;
				retval = true;
			}
			else
			{
				retval = false;
			}
			return retval;
		}
		
		

		var pathSwitchTimer:int;
		var pathSwitchControlMode:int;
		var pathSwitchDoneOnce:Boolean;
		function InitPhysObj_PathSwitch()
		{
			InitPhysObj_Path();
			onHitFunction = HitPhysObj_HitSwitch;
			
			pathSwitchTimer = 0;
			pathSwitchControlMode = 0;
			updateFunction1 = updateFunction;
			
			
			var switchType:String = Utils.GetParam("type");
			
			if (switchType == "") switchType = "once";

			if (switchType == "once")
			{
				pathSwitchDoneOnce = false;
				doSwitchFunction = SwitchedPhysObj_PathSwitch_Once;				
				updateFunction = UpdatePhysObj_PathSwitch_Once;
			}
			if (switchType == "timed")
			{
				switch_timer = Utils.GetParamNumber("switch_time") * Defs.fps;
				//doSwitchFunction = SwitchedPhysObj_TimedSwitch;				
				updateFunction = UpdatePhysObj_PathSwitch_Once;
			}
			if (switchType == "2way")
			{
				doSwitchFunction = SwitchedPhysObj_PathSwitch_TwoWay;				
				updateFunction = UpdatePhysObj_PathSwitch_TwoWay;
			}
		}
		function SwitchedPhysObj_PathSwitch_TwoWay():Boolean
		{
			if (pathSwitchControlMode != 0) return false;
			pathSwitchTimer = 20;
			pathSwitchControlMode = 1;
			
			return true;
		}
		function SwitchedPhysObj_PathSwitch_Once():Boolean
		{
			if (pathSwitchDoneOnce) return false;
			if (pathSwitchControlMode == 0) 
				pathSwitchControlMode = 1;
			else
				pathSwitchControlMode = 0;
			pathSwitchDoneOnce = true;
			return true;
		}
		function UpdatePhysObj_PathSwitch_TwoWay()
		{
			updateFunction1();
			if (pathSwitchControlMode == 0)
			{
				frame = 1;				
			}
			else if (pathSwitchControlMode == 1)
			{
				frame = 0;
				pathSwitchTimer--;
				if (pathSwitchTimer <= 0)
				{
					pathSwitchControlMode = 0;
				}
			}			
		}
		function UpdatePhysObj_PathSwitch_Once()
		{
			
			updateFunction1();
			if (pathSwitchControlMode == 0)
			{
			}
			else if (pathSwitchControlMode == 1)
			{
				pathSwitchTimer--;
				if (pathSwitchTimer <= 0)
				{
					pathSwitchControlMode = 0;
				}
			}
			frame = 1;
			if (pathSwitchDoneOnce) frame = 2;

		}


		var pathEaseName:String;
		var pathEaseValue:Number;
		var pathControlMode:int;
		function InitPhysObj_Path_Old()
		{
			useMultiplePhysicsUpdates = true;
			
			Utils.print("Init path object");
			
			Utils.GetParams(initParams);
			
			pathEaseName = Utils.GetParamString("path_ease","linear");
			pathEaseValue = Utils.GetParamNumber("path_easevalue",1);
			
			for (var i:int = 0; i < Utils.paramNames.length; i++)
			{
				Utils.print("Param " + i + ":  " + Utils.paramNames[i] + "   =   " + Utils.paramValues[i]);
			}
			
			initParams = "editor_layer=1,path_line=path01,path_speed=8,path_loop=true,path_spline=false,path_endreset=false,path_startpos=0,path_2way=false,path_rotatetopath=false,path_startmoving=true"
			
			var lineName:String = Utils.GetParam("path_line", "");
			if (lineName == "")
			{
				lineIndex = -1;
			}
			else
			{
				lineIndex = GetLineIndexByName(lineName);				
			}
				
			if (lineIndex == -1)
			{
				updateFunction = null;
			}
			
			dir = GetBodyAngle(0);
			
			lineSpeed = 1 / (Utils.GetParamNumber("path_speed")*Defs.fps) ;
			lineLoop = Utils.GetParamBool("path_loop");
			
			switchName = Game.GetSwitchJointName(id);
			
			lineResetAtEnd = Utils.GetParamBool("path_endreset");
			lineSpline = Utils.GetParamBool("path_spline");
			lineRotateToPath = Utils.GetParamBool("path_rotatetopath",false);
			var lineStartMoving:Boolean = Utils.GetParamBool("path_startmoving",true);
			lineLinearPos = 0;
			var startPos:Number = Utils.GetParamNumber("path_startpos", 0);
			
			lineLinearPos = startPos;
			
			var twoway:Boolean = Utils.GetParamBool("path_2way");
			
			pathPos = new Point();

			pathControlMode = 0;
			switchFunction = null;
			updateFunction = null;
			
			var pos:Point = UpdateLine(0);	
			pathPos.x = pos.x;
			pathPos.y = pos.y;
			xpos = oldxpos = pos.x;
			ypos = oldypos = pos.y;
			oldrot = dir;
			
			
			SetBodyXForm_Immediate(0, xpos, ypos, dir);
			
			if (lineIndex != -1) 
			{
				switchFunction = SwitchFunction_PhysObj_Path;				
				updateFunction = UpdatePhysObj_Path;

			}
			
			if (twoway)
			{
				updateFunction = UpdatePhysObj_Path_2way;				
				if (switchName != "") 
				{
					switchFunction = SwitchFunction_PhysObj_Path_2way;
					updateFunction = UpdatePhysObj_Path_2way_switched;				
				}
			}
			if (lineStartMoving) pathControlMode = 1;
			
			//renderFunction = RenderPathDebug;
		}
		
		var pathPos:Point;
		
		function RenderPathDebug()
		{
			//Utils.trace("pathpos " + pathPos.x + " " + pathPos.y);
			Utils.RenderCircle(bd, pathPos.x, pathPos.y, 10, 0xffffffff);
		}

		function SwitchFunction_PhysObj_Path_2way()
		{
			if (pathControlMode == 0)	// stopped
			{
				pathControlMode = 1;
			}
			else if(pathControlMode == 1)
			{
				pathControlMode = 2;
			}
			else
			{
				pathControlMode = 1;
			}
		}

		function UpdatePhysObj_Path_2way()
		{
			if (lineRotateToPath)
			{
				dir = GetLineAngle();
			}
			
			if (pathControlMode == 0)
			{
				pathControlMode = 1;
			}
			
			if(pathControlMode == 1)
			{			
				
				var pos:Point = UpdateLine(lineSpeed);		
				pathPos.x = pos.x;
				pathPos.y = pos.y;
				SetBodyXForm(0, pos.x , pos.y, dir);	
				if (lineLinearPos >= 1) pathControlMode = 2;
			}
			else if(pathControlMode == 2)
			{			
				var pos:Point = UpdateLine( -lineSpeed);			
				pathPos.x = pos.x;
				pathPos.y = pos.y;
				SetBodyXForm(0, pos.x, pos.y, dir);		
				if (lineLinearPos <= 0) pathControlMode = 1;
			}
		}
		
		function UpdatePhysObj_Path_2way_switched()
		{
			if (lineRotateToPath)
			{
				dir = GetLineAngle();
			}
			
			if (pathControlMode == 0)
			{
				var pos:Point = UpdateLine(0);			
				pathPos.x = pos.x;
				pathPos.y = pos.y;
				SetBodyXForm(0, pos.x, pos.y, dir);
				
			}
			else if(pathControlMode == 1)
			{			
				var pos:Point = UpdateLine(lineSpeed);			
				pathPos.x = pos.x;
				pathPos.y = pos.y;
				SetBodyXForm(0, pos.x, pos.y, dir);				
			}
			else if(pathControlMode == 2)
			{			
				var pos:Point = UpdateLine( -lineSpeed);			
				pathPos.x = pos.x;
				pathPos.y = pos.y;
				SetBodyXForm(0, pos.x, pos.y, dir	);		
			}
		}				
		
//-------------------------------------------------------------------------------		
		function SwitchFunction_PhysObj_Path()
		{
			if (pathControlMode == 0)
			{
				pathControlMode = 1;
			}
			else
			{
				pathControlMode = 0;
			}
		}
		
		function UpdatePhysObj_Path()
		{
			
			if (lineRotateToPath)
			{
				dir = GetLineAngle();
			}
			
			if (pathControlMode == 0)
			{
				
				var pos:Point = UpdateLine(0);	
				pathPos.x = pos.x;
				pathPos.y = pos.y;
				SetBodyXForm(0, pos.x, pos.y, dir);
			}
			else
			{	
				var pos:Point = UpdateLine(lineSpeed);	
				pathPos.x = pos.x;
				pathPos.y = pos.y;
				SetBodyXForm(0, pos.x, pos.y, dir);
				
				if (lineLoop == false)
				{
					if (lineLinearPos >= 1)
					{
						lineLinearPos = 1;
						if (lineResetAtEnd)
						{
							lineLinearPos = 0;
						}
						pathControlMode = 0;
					}
				}				
			}
			
		}				

		
		
		
		function GetLineIndexByName(name:String):int
		{
			var l:Level = Levels.GetCurrent();
			var index:int = 0;
			for each(var line:EdLine in l.lines)
			{
				if (line.id == name)
				{
					return index;
				}
				index++;
			}
			return -1;
		}

		
		
		function RenderPhysicsLineObjectInner_Surface()
		{
			
		}

		function RenderPhysicsLineObjectInner()
		{
			if (Game.gameState == Game.gameState_UI) return;
			
			var x:Number = Math.round(xpos);
			var y:Number =  Math.round(ypos);
			x -= Math.round(Game.camera.x);
			y -= Math.round(Game.camera.y);
			
//			var x:Number = xpos - Game.camera.x;
//			var y:Number = ypos - Game.camera.y;

			var g:Graphics = Game.fillScreenMC.graphics;
			g.clear();

			var sx:Number = Math.round(Game.camera.x);
			var sy:Number = Math.round(Game.camera.y);
			
			var z:int = zpos;
			
			var bmat:Matrix = new Matrix();
//			bmat.rotate(dir);
//			bmat.translate(xpos, ypos);
			bmat.translate( -sx,-sy);
			
			var p0:Point;
			var p1:Point;
			
			var newpoints:Array = new Array();
			
			var m:Matrix = new Matrix();
			m.rotate(dir);
			
			var sc:Number = Game.camera.scale;
			
			var r:Rectangle = new Rectangle(0, 0, 1, 1);
			
			var index:int = 0;
			for each(var p:Point in linkedPhysLine.points)
			{
				p0 = p.clone();
				p0.x -= linkedPhysLine.centrex;
				p0.y -= linkedPhysLine.centrey;
				p0 = m.transformPoint(p0);
				p0.x += xpos;
				p0.y += ypos;
				p0.x -= sx;
				p0.y -= sy;
				p0.x *= sc;
				p0.y *= sc;
				newpoints.push(p0);
				
				if (index == 0)
				{
					r = new Rectangle(p0.x, p0.y, 1, 1);
				}
				else
				{
					if (p0.x < r.left) r.left = p0.x;
					if (p0.x > r.right) r.right = p0.x;
					if (p0.y < r.top) r.top = p0.y;
					if (p0.y > r.bottom) r.bottom = p0.y;
				}
				index++;
				
			}
			
			
			
			//g.lineStyle(lineRender_lineThickness, lineRender_LineColor, lineRender_LineAlpha);
			if (false)	//name == "sticky")
			{
				g.lineStyle(null, null, 0);
			}
			else
			{
				g.lineStyle(2, lineRender_Color, 1);
			}
			
			//g.beginFill(lineRender_Color, 1);
			
			g.beginBitmapFill(dobj.GetBitmapData(frame), bmat, true);
			
			var gradientColors:Array = new Array(lineRender_Color0, lineRender_Color1);
			var gradientAlphas:Array = new Array(1,1);
			var gradientRatios:Array = new Array(0, 255);
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(r.width, r.height, 0, r.x, r.y);
			
			//g.beginGradientFill(GradientType.LINEAR, gradientColors, gradientAlphas, gradientRatios, gradientMatrix);
			
//			Shaders.shader.data.src.input = dobj.GetBitmapData(frame);			
//			g.beginShaderFill(Shaders.shader, bmat);
			
			g.lineStyle(null, null, 0);

			if (name == "line_for_show")
			{
				g.lineStyle(2, 0xffffff, 1);
				
				p1 = newpoints[0].clone();
				g.moveTo(p1.x,p1.y);
				for (var i:int = 1; i <newpoints.length; i++)
				{
					p0 = newpoints[i];
					g.lineTo(p0.x,p0.y);
				}	
				bd.draw(Game.fillScreenMC, null, null, null, null, false);
				return;

			}
			
				

			
			
			p1 = newpoints[0].clone();
			g.moveTo(p1.x,p1.y);
			for (var i:int = 1; i <newpoints.length; i++)
			{
				p0 = newpoints[i].clone();
				g.lineTo(p0.x,p0.y);
			}	
			g.lineTo(p1.x, p1.y);
			g.endFill();


			if (false)
			{
				g.lineStyle(2, lineRender_Color, 1);
				for (var i:int = 0; i <newpoints.length; i++)
				{
					var j:int = i + 1;
					if (j >= newpoints.length) j = 0;
					p0 = newpoints[i].clone();
					p1 = newpoints[j].clone();
					if (p0.x < p1.x)
					{
						g.moveTo(p0.x,p0.y);
						g.lineTo(p1.x, p1.y);
					}
				}
			}	
			bd.draw(Game.fillScreenMC, null, null, null, null, false);
			
			if (name == "death")
			{
				var dob:DisplayObj = GraphicObjects.GetDisplayObjByName("terrainSpikes");
				var numf:int = dob.GetNumFrames()-1;
				Utils.RandSetSeed(123456789101112);
				
				for (var j:int = 0; j <newpoints.length; j++)
				{
					var k:int = j + 1;
					if (k >= newpoints.length) k = 0;
					p0 = newpoints[j].clone();
					p1 = newpoints[k].clone();
					
					
					
					var dx:Number = p1.x - p0.x;
					var dy:Number = p1.y - p0.y;
					var adx:Number = Math.abs(dx);
					var ady:Number = Math.abs(dy);
					
					var rot:Number = Math.atan2(dy, dx);
					
					var len:Number = Utils.DistBetweenPoints(p0.x, p0.y, p1.x, p1.y);
					var segDist:Number = 7;
					var numSegs:int = len / segDist;
					dx /= numSegs;
					dy /= numSegs;
					
					
					for (var i:int = 0; i < numSegs; i++)
					{
						p0.x += dx;
						p0.y += dy;
						var p:Point = p0.clone();
						p.x += Utils.RandBetweenFloat_Seeded( -1, 1);
						p.y += Utils.RandBetweenFloat_Seeded(-1,1);
						var f:int = Utils.RandBetweenInt_Seeded(0, numf);
						dob.RenderAtRotScaled(f, bd, p.x, p.y,1,rot,null,true);
					}
				}
			}
			
			
			if (false)	//name == "grass")
			{
				var dob:DisplayObj = GraphicObjects.GetDisplayObjByName("grass");
				var numf:int = dob.GetNumFrames()-1;
				Utils.RandSetSeed(123456789101112);
				
				for (var j:int = 0; j <newpoints.length; j++)
				{
					var k:int = j + 1;
					if (k >= newpoints.length) k = 0;
					p0 = newpoints[j].clone();
					p1 = newpoints[k].clone();
					
					var dx:Number = p1.x - p0.x;
					var dy:Number = p1.y - p0.y;
					var adx:Number = Math.abs(dx);
					var ady:Number = Math.abs(dy);
					
					if ( (p0.x < p1.x) && (adx > ady) )
					{
						var len:Number = Utils.DistBetweenPoints(p0.x, p0.y, p1.x, p1.y);
						var segDist:Number = 3;
						var numSegs:int = len / segDist;
						dx /= numSegs;
						dy /= numSegs;
						
						
						for (var i:int = 0; i < numSegs; i++)
						{
							p0.x += dx;
							p0.y += dy;
							var p:Point = p0.clone();
							p.x += Utils.RandBetweenFloat_Seeded( -1, 1);
							p.y += Utils.RandBetweenFloat_Seeded(2, 6);
							var f:int = Utils.RandBetweenInt_Seeded(0, numf);
							dob.RenderAt(f, bd, p.x, p.y);
						}
					}
					else
					{
						var dx:Number = p1.x - p0.x;
						var dy:Number = p1.y - p0.y;
						var len:Number = Utils.DistBetweenPoints(p0.x, p0.y, p1.x, p1.y);
						var segDist:Number = 3;
						var numSegs:int = len / segDist;
						dx /= numSegs;
						dy /= numSegs;
						
					
						
						for (var i:int = 0; i < numSegs; i++)
						{
							p0.x += dx;
							p0.y += dy;
							var p:Point = p0.clone();
							p.x += Utils.RandBetweenFloat_Seeded( -1, 1);
							p.y += Utils.RandBetweenFloat_Seeded(0, 2);
							
							var xx:int = p.x;
							var yy:int = p.y;
							var rand:int = Utils.RandBetweenInt(1, 2);
							
							if (rand == 0)
							{
								
							}
							else if (rand == 1)
							{
								bd.setPixel32(xx, yy, 0);
								bd.setPixel32(xx+1, yy, 0);
								bd.setPixel32(xx, yy+1, 0);
								bd.setPixel32(xx+1, yy+1, 0);
							}
							else if (rand == 2)
							{
								bd.setPixel32(xx-1, yy-1, 0);
								bd.setPixel32(xx-1, yy+1, 0);
								bd.setPixel32(xx+1, yy-1, 0);
								bd.setPixel32(xx+1, yy+1, 0);
								bd.setPixel32(xx, yy, 0);
							}
							
						}
						
					}
				}
				
			}
			

			
		}
		
		function RenderPhysicsLineObjectInner_Shadow()
		{
			return;
			var x:Number = xpos - Game.camera.x;
			var y:Number = ypos - Game.camera.y;

			var g:Graphics = Game.fillScreenMC.graphics;
			g.clear();
			
			var p0:Point;
			var p1:Point;
			
			var newpoints:Array = new Array();
			
			var m:Matrix = new Matrix();
			m.rotate(dir);
			
			for each(var p:Point in linkedPhysLine.points)
			{
				p0 = p.clone();
				p0.x -= linkedPhysLine.centrex;
				p0.y -= linkedPhysLine.centrey;
				p0 = m.transformPoint(p0);
				p0.x += xpos;
				p0.y += ypos;
				newpoints.push(p0);
			}
			
			
			g.lineStyle(null,null,0);
			g.beginFill(0, 1);
			
			p1 = newpoints[0].clone();
			g.moveTo(p1.x,p1.y);
			for (var i:int = 1; i <newpoints.length; i++)
			{
				p0 = newpoints[i].clone();
				g.lineTo(p0.x,p0.y);
			}	
			g.lineTo(p1.x, p1.y);
			g.endFill();
			
			
		}
		
		
		function RenderPhysicsLineObjectShadow()
		{
			RenderPhysicsLineObjectInner();
			var shadowMat:Matrix = new Matrix();
//			shadowMat.translate(Game.shadowOffsetX, Game.shadowOffsetY);
			//bd.draw(Game.fillScreenMC, shadowMat,null, null, null, false);
			bd.draw(Game.fillScreenMC, shadowMat,shadowCT, null, null, false);
			
		}
		
		function RenderPhysicsLineObject()
		{
			if (invisibleTimer == 0)
			{			
				RenderPhysicsLineObjectInner();
			}
			RenderInvisibleBar(0,0);
			
		}
		function UpdatePhysicsLineObject()
		{
			//Utils.trace("phys "+xpos+" "+ypos);
		}
		
		
		var lineRender_Mode:String;
		var lineRender_Color:uint;
		var lineRender_Color0:uint;
		var lineRender_Color1:uint;
		var lineRender_LineColor:uint;
		var lineRender_LineAlpha:Number;
		var lineRender_lineThickness:Number;
		
		function InitPhysicsLineObject(_line:EdLine)
		{
			isPolyObject = true;
			linkedPhysLine = _line;
			visible = true;
			updateFunction = UpdatePhysicsLineObject;
			renderFunction = RenderPhysicsLineObject;
			lineRender_Mode	= "";
			lineRender_Color = 0x808080;
			lineRender_LineColor = 0x0000a0;
			lineRender_LineAlpha = 1;
			lineRender_lineThickness = 0;
			renderShadowFunction = RenderPhysicsLineObjectShadow;
			renderShadowFlag = true;
			frame = 0;
			
			var polyMatName:String = linkedPhysLine.objParameters.GetValueString("line_material");
			polyMaterial = PolyMaterials.GetByName(polyMatName);
			frame = polyMaterial.fillFrame;

			var layerZpos:Number = GameLayers.GetZPosByName(linkedPhysLine.objParameters.GetValueString("game_layer"));
			zpos = layerZpos;
			
			var initFunc:String = polyMaterial.initFunctionName;
			
			id = linkedPhysLine.id;
			
			dobj = GraphicObjects.GetDisplayObjByName(polyMaterial.graphicName);

			if (initFunc != null && initFunc != "")
			{
				this[initFunc]();
			}
			
		}

		function InitPhysicsLineObject_Nape(_line:EdLine,_body:Body)
		{
			isPolyObject = true;
			nape_bodies = new Vector.<Body>();
			if (_body != null)
			{
				nape_bodies.push(_body);
			}
			linkedPhysLine = _line;
			visible = true;
			updateFunction = UpdatePhysicsLineObject;
			renderFunction = RenderPhysicsLineObject;
			lineRender_Mode	= "";
			lineRender_Color = 0x808080;
			lineRender_LineColor = 0x0000a0;
			lineRender_LineAlpha = 1;
			lineRender_lineThickness = 0;
			renderShadowFunction = RenderPhysicsLineObjectShadow;
			renderShadowFlag = true;
			frame = 0;
			
			var polyMatName:String = linkedPhysLine.objParameters.GetValueString("line_material");
			polyMaterial = PolyMaterials.GetByName(polyMatName);
			frame = polyMaterial.fillFrame;

			var layerZpos:Number = GameLayers.GetZPosByName(linkedPhysLine.objParameters.GetValueString("game_layer"));
			zpos = layerZpos;
			
			var initFunc:String = polyMaterial.initFunctionName;
			
			id = linkedPhysLine.id;
			
			dobj = GraphicObjects.GetDisplayObjByName(polyMaterial.graphicName);

			if (initFunc != null && initFunc != "")
			{
				this[initFunc]();
			}
			
		}
		
		
		function SetPolysMaterial_Nape(materialName:String)
		{
			var physMaterial:PhysObj_Material = Game.GetPhysMaterialByName(materialName);
			
			
			for (var i:int = 0; i < nape_bodies.length; i++) 
			{
				var b:Body = nape_bodies[i];
				
				// set material here
				
			}
		

		}
/*		
		function SetPolysMaterial(materialName:String)
		{
			var physMaterial:PhysObj_Material = Game.GetPhysMaterialByName(materialName);

			var b:b2Body = bodies[0];			
			var s:b2Shape;
			
			for (s = b.GetShapeList(); s; s = s.GetNext())
			{
				s.m_friction = physMaterial.friction;
				s.m_restitution = physMaterial.restitution;
				s.m_density = physMaterial.density;
			}
		}
		*/
		
		
		var invisibleTimer:int;
		var invisibleTimerMax:int;
		function UpdateInvisibleTimer():Boolean
		{
			if (invisibleTimer == 0) return false;
			invisibleTimer--;
			if (invisibleTimer <= 0)
			{
				invisibleTimer = 0;
				return true;
			}
			return false;
		}
		function InitInvisibleTimer()
		{
			invisibleTimer = invisibleTimerMax = 0;
		}
		function SetInvisibleTimer(time:int)
		{
			invisibleTimer = invisibleTimerMax = time;
		}
		function RenderInvisibleBar(x:Number,y:Number)
		{
			
			if (invisibleTimer == 0) return;
			
			var w:int = 30;
			var h:int = 5;
			
			var r:Rectangle = new Rectangle(xpos + x + ( -w / 2), ypos + y, w, h);
			
			bd.fillRect(r, 0xff000000);
			
			r.width = Utils.ScaleTo(0, w, 0, invisibleTimerMax, invisibleTimer);
			bd.fillRect(r, 0xffff0000);
		}

		var jointController_joints:Vector.<Constraint>;
		function InitGameObjJoint_Null(cons:Vector.<Constraint>)
		{
			jointController_joints = null;
			visible = false;
		}
		
		
		
		
		function RenderJointRenderer()
		{
			
			for each(var c:Constraint in jointController_joints)
			{
				if (c is DistanceJoint)
				{
					var d:DistanceJoint = c as DistanceJoint;
					
					var p0:Point = new Point(d.anchor1.x, d.anchor1.y);
					var p1:Point = new Point(d.anchor2.x, d.anchor2.y);
					
					
					gmat.identity();
					gmat.rotate(d.body1.rotation);
					p0 = gmat.transformPoint(p0);
					gmat.identity();
					gmat.rotate(d.body2.rotation);
					p1 = gmat.transformPoint(p1);
					
					p0.x += d.body1.position.x;
					p0.y += d.body1.position.y;
					p1.x += d.body2.position.x;
					p1.y += d.body2.position.y;
					
//					var p0:Point = new Point(d.body1.position.x + d.anchor1.x, d.body1.position.y + d.anchor1.y);
//					var p1:Point = new Point(d.body2.position.x + d.anchor2.x, d.body2.position.y + d.anchor2.y);
					
					p0.x -= Game.camera.x;
					p1.x -= Game.camera.x;
					p0.y -= Game.camera.y;
					p1.y -= Game.camera.y;

					if (PROJECT::useStage3D)
					{

						var dob:DisplayObj = GraphicObjects.GetDisplayObjByName("whiteRect");
						var tx:s3dTex = dob.GetTexture(0);
						var dof:DisplayObjFrame = dob.GetFrame(0);			
							
						s3d.RenderLineA(tx, p0.x,p0.y,p1.x,p1.y, dof.u0,dof.v0,dof.u1,dof.v1);
					}
					else
					{

						
						var g:Graphics = Game.fillScreenMC.graphics;
						g.clear();
						g.lineStyle(3, 0xF7ECC7, 1);
						g.moveTo(p0.x, p0.y);
						g.lineTo(p1.x, p1.y);
						bd.draw(Game.fillScreenMC);
					}
					
				}
			}
		}
		
//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				

//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				


		function SwitchOnceHit(goHitter:GameObj)
		{
			if (state != 0) return false;
			if (goHitter.name != "player") return;
			state = 1;
			frame  = 1;
			return true;
			
		}
		function UpdateSwitchOnce()
		{
			if (state == 0)
			{
				
			}
			else if (state == 1)
			{			
				Game.DoSwitch(this);				
				frame = 1;
				state = 2;
			}			
		}
		
		
		function InitSwitch_Once()
		{			
			Utils.GetParams(initParams);
			switchType = "once";
			onHitFunction = SwitchOnceHit;				
			updateFunction = UpdateSwitchOnce;
			state = 0;			
		}

//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				

		function Switch2WayHit(goHitter:GameObj)
		{
			if (goHitter.collisionType != "football" && goHitter.collisionType != "beachball" ) return;
			
			if (state != 0) return false;
			if (timer > 0) return;
			
			timer = 3;
			if (switchFlag == false)
			{
				state = 1;
			}
			else
			{
				state = 2;
			}
			return true;
			
		}
		function UpdateSwitch2Way()
		{
			if (state == 0)
			{
				
			}
			else if (state == 1)
			{			
				Game.DoSwitch(this);				
				frame = 1;
				switchFlag = true;
				state = 0;
			}			
			else if (state == 2)
			{
				Game.DoSwitch(this);				
				frame = 0;
				switchFlag = false;
				state = 0;
			}
			timer--;
			if (timer <= 0) timer = 0;
		}
		
		
		function InitSwitch_2Way()
		{			
			Utils.GetParams(initParams);
			switchType = "once";
			onHitFunction = Switch2WayHit;				
			updateFunction = UpdateSwitch2Way;
			state = 0;	
			switchFlag = false;
			timer = 0;
		}

		
//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				

		function SwitchWeightHitPersist(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (goHitter.physobj == null) return;
			if (state != 2) return false;
			//if (goHitter.physobj.name != "ball_large" && goHitter.physobj.name != "bowlingBall" ) return false;			
			
			goHitter.nape_bodies[0].velocity.y -= 0.00000001;
			
			timer = 4;
		}
		function SwitchWeightHit(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (goHitter.physobj == null) return;
			if (state != 0) return false;
			
			//if (goHitter.physobj.name != "ball_large" && goHitter.physobj.name != "bowlingBall" ) return false;
			
			Utils.print("SwitchWeightHit");
			
			
			
			if (switchFlag == false)
			{
				state = 1;
			}
			return true;
			
		}
		function UpdateSwitchWeight()
		{
			if (state == 0)
			{
				
			}
			else if (state == 1)
			{			
				Game.DoSwitch(this);				
				frame = 1;
				switchFlag = true;
				state = 2;
				timer = 4;
			}			
			else if (state == 2)
			{
				timer--;
				if (timer <= 0)
				{
					Game.DoSwitch(this);				
					frame = 0;
					switchFlag = false;
					state = 0;
				}
			}
			
		}
		
		
		function InitSwitch_Weight()
		{			
			Utils.GetParams(initParams);
			switchType = "2way";
			onHitFunction = SwitchWeightHit;				
			onHitPersistFunction = SwitchWeightHitPersist;				
			updateFunction = UpdateSwitchWeight;
			state = 0;	
			switchFlag = false;
		}

//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				

		function SwitchTimerHit(goHitter:GameObj)
		{
			if (state != 0) return false;
			if (goHitter.collisionType != "football" && goHitter.collisionType != "beachball" ) return;
			
			state = 1;
			timer = switch_timer;

			return true;
			
		}
		function UpdateSwitchTimer()
		{
			if (state == 0)
			{
				
			}
			else if (state == 1)
			{			
				Game.DoSwitch(this);				
				frame = 1;
				state = 2;
				timer1 = 8;
				switchFlag = true;
			}			
			else if (state == 2)
			{
				minFrame = 1;
				maxFrame = dobj.GetNumFrames() - 1;
				frame = int( Utils.ScaleTo(minFrame, maxFrame, 0, switch_timer, timer) );
				timer--;
				if (timer <= 0)
				{
					Game.DoSwitch(this);				
					frame = 0;
					state = 0;
					switchFlag = false;
				}
				timer1--;
				if (timer1 <= 0)
				{
					timer1 = 8;
				}
			}
		}
		
		
		function InitSwitch_Timer()
		{			
			Utils.GetParams(initParams);
			switch_timer = Utils.GetParamNumber("switch_time") * Defs.fps;

			switchType = "timer";
			onHitFunction = SwitchTimerHit;				
			updateFunction = UpdateSwitchTimer;
			state = 0;	
			switchFlag = false;
		}

//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				

		function Switchable_Disappear_Switched()
		{
			if (state != 0) return;
			if (switchFlag == false)
			{
				state = 1;				
			}
			else
			{
				state = 2;
			}
		}
		function UpdateSwitchable_Disappear()
		{
			if (state == 0)
			{
				PlayAnimation();
			}
			else if (state == 1)
			{
				SetBodyCollisionMask(0, 0);
				state = 0;
				switchFlag = true;
				frameVel = 1;
			}
			else if (state == 2)
			{
				SetBodyCollisionMask(0, 15);
				state = 0;		
				switchFlag = false;
				frameVel = -1;
			}
		}
		function InitSwitchable_Disappear()
		{
			frameVel = -1;
			Utils.GetParams(initParams);
			switchName = Utils.GetParamString("switch_name","");
			updateFunction = UpdateSwitchable_Disappear;
			switchFunction = Switchable_Disappear_Switched;
			switchFlag = false;
		}
		
		function InitJointRenderer()
		{
			visible = false;
		}
		
		function ClipTest(rad:Number = 40 ):Boolean
		{
			if (GameVars.takingADump) return true;
			if (xpos + rad < Game.camera.x) return false;
			if (ypos + rad < Game.camera.y) return false;
			if (xpos - rad > Game.camera.x + Defs.displayarea_w) return false;
			if (ypos - rad > Game.camera.y + Defs.displayarea_h) return false;
			return true;
		}

		
		function LimitVelocity_Nape(max:Number)
		{
			var b:Body = nape_bodies[0];
			var vel:Vec2 = b.velocity;
			
			if (vel.length > max)
			{
				var v:Vec = new Vec();
				v.SetFromDxDy(vel.x, vel.y);
				v.speed = max;
				b.velocity.x = v.X();
				b.velocity.y = v.Y();
			}
		}
		
		function LimitXVelocity_Nape(max:Number)
		{
			var b:Body = nape_bodies[0];
			var vel:Vec2 = b.velocity;
			
			
			if(Math.abs (vel.x) > max)
			{
				if (vel.x > 0)
				{
					vel.x = max;
				}
				else
				{
					vel.x = -max;
				}
			}
		}

		function LimitYVelocity_Nape(max:Number)
		{
			var b:Body = nape_bodies[0];
			var vel:Vec2 = b.velocity;
			
			
			if(Math.abs (vel.y) > max)
			{
				if (vel.y > 0)
				{
					vel.y = max;
				}
				else
				{
					vel.y = -max;
				}
			}
		}
		
		
		
		function LimitVelocity_B2D(max:Number)
		{
			/*
			var b:b2Body = bodies[0];
			var vel:b2Vec2 = b.GetLinearVelocity();
			if (vel.Length() > max)
			{
				var v1:b2Vec2 = vel.Copy();
				v1.Normalize();
				v1.Multiply(max);
				b.SetLinearVelocity(v1);
			}
			*/
			
		}

		function LimitXVelocity_B2D(max:Number)
		{
			/*
			var b:b2Body = bodies[0];
			var vel:b2Vec2 = b.GetLinearVelocity();
			if(Math.abs (vel.x) > max)
			{
				if (vel.x > 0)
				{
					vel.x = max;
				}
				else
				{
					vel.x = -max;
				}
				b.SetLinearVelocity(vel);
			}
			*/
		}
		function GetUniqueId()
		{
			var s:String = "uidig_";
			for (var i:int = 0; i < 6; i++)
			{
				s += Utils.RandBetweenInt(0, 99);
			}
			id = s;
			
		}		
		
		
		/*
//-----------------------------------------------------------------

function OnHit$(SelText)(goHitter:GameObj)
{
	if (goHitter == null) return;
}
function Render$(SelText)()
{
}
function Update$(SelText)()
{
}
function Init$(SelText)()
{
	onHitFunction = OnHit$(SelText);				
	renderFunction = Render$(SelText);
	updateFunction = Update$(SelText);			
}

		*/
		
		function SFX_OneShot(name:String,_positional:Boolean = true,_volume:Number=1)
		{
			var x:Number = xpos - Game.camera.x;
			x = Utils.LimitNumber(0, Defs.displayarea_w,x);
			
			var pan:Number = Utils.ScaleTo( -1, 1, 0, Defs.displayarea_w, x);
			
			Audio.OneShot(name, pan, _volume);
		}

		
		var path_startmode:String;
		var path_endmode:String;
		var path_switchmode:String;
		function InitPhysObj_Path()
		{
			Utils.GetParams(initParams);
			
			path_startmode = Utils.GetParamString("path_startmode", "start");
			path_endmode = Utils.GetParamString("path_endmode", "stop");
			path_switchmode = Utils.GetParamString("path_switchmode", "stop");
			
			pathEaseName = Utils.GetParamString("path_ease","linear");
			pathEaseValue = Utils.GetParamNumber("path_easevalue",1);
			
			for (var i:int = 0; i < Utils.paramNames.length; i++)
			{
				//Utils.print("Param " + i + ":  " + Utils.paramNames[i] + "   =   " + Utils.paramValues[i]);
			}
			
			var lineName:String = Utils.GetParam("path_line", "");
			if (lineName == "")
			{
				Utils.print("ERROR: Path Object has no line");
				return;
			}
			lineIndex = GetLineIndexByName(lineName);				
			
			var line:EdLine = Levels.GetCurrent().lines[lineIndex];
			
			lineSpline = line.IsSpline();
			
			dir = GetBodyAngle(0);
			
			lineSpeed = 1 / (Utils.GetParamNumber("path_speed")*Defs.fps) ;
			
			switchName = Game.GetSwitchJointName(id);
			
			lineRotateToPath = Utils.GetParamBool("path_rotatetopath",false);
			var startPos:Number = Utils.GetParamNumber("path_startpos", 0);			
			lineLinearPos = startPos;
			path_pointtoobjectName = Utils.GetParamString("path_pointtoobject","");
			
			pathPos = new Point();

			pathControlMode = 0;
			switchFunction = null;
			updateFunction = null;
			
			var pos:Point = UpdateLine(0);	
			pathPos.x = pos.x;
			pathPos.y = pos.y;
			xpos = oldxpos = pos.x;
			ypos = oldypos = pos.y;
			oldrot = dir;
			
			
			SetBodyXForm_Immediate(0, xpos, ypos, dir);
			
			switchFunction = SwitchFunction_PhysObj_Path_New;				
			updateFunction = UpdatePhysObj_Path_New;
			
			// start / stop
			if (path_startmode == "stop") pathControlMode = 0;
			if (path_startmode == "start") 
			{
				pathControlMode = 1;
			}
			if (path_startmode == "start_reverse") 
			{
				pathControlMode = 1;
				lineSpeed *= -1;
			}
			
		}
		
		
		function SwitchFunction_PhysObj_Path_New()
		{
			if (path_switchmode == "start")
			{
				WakeConnectedPhysicsObjects();
				pathControlMode = 1;
			}
			if (path_switchmode == "start_doubleswitch")	// for timed switches
			{
				if (lineLinearPos == 0)
				{
					lineSpeed = Math.abs(lineSpeed);
				}
				else
				{
					lineSpeed = -Math.abs(lineSpeed);
				}
				pathControlMode = 1;
			}
			if (path_switchmode == "stop")
			{
				pathControlMode = 0;
			}
			if (path_switchmode == "toggle_dir")
			{
				lineSpeed *= -1;
				pathControlMode = 1;
			}
			if (path_switchmode == "toggle_movement")
			{
				pathControlMode = 1 - pathControlMode;
			}
		}
		
		function UpdatePhysObj_Path_SetPos()
		{
			var pos:Point = UpdateLine(0);	
			pathPos.x = pos.x;
			pathPos.y = pos.y;
			SetBodyXForm(0, pos.x, pos.y, dir);			
		}
		function UpdatePhysObj_Path_New()
		{
			if (lineRotateToPath)
			{
				dir = GetLineAngle();
			}
			
			if (path_pointtoobjectName != "")
			{
				var go:GameObj = GameObjects.GetGameObjById(path_pointtoobjectName);
				if (go != null)
				{
					dir = Math.atan2(go.ypos - ypos, go.xpos-xpos);
				}
			}
			
			if (pathControlMode == 0)		// stationary
			{
				UpdatePhysObj_Path_SetPos();
			}
			else if (pathControlMode == 1)		// moving
			{				
				// path_endmode = bounce / stop / loop
				
				lineLoop = false;
				if (path_endmode == "loop") lineLoop = true;
				
				lineLinearPos += lineSpeed;
				
				if (path_endmode == "loop")
				{
					if (lineLinearPos > 1) lineLinearPos -= 1;
					else if (lineLinearPos < 0) lineLinearPos += 1;					
				}
				else if (path_endmode == "bounce")
				{
					if (lineLinearPos > 1)
					{
						lineLinearPos = 1;
						lineSpeed *= -1;
					}
					else if (lineLinearPos < 0)
					{
						lineLinearPos = 0
						lineSpeed *= -1;
					}
				}
				else if (path_endmode == "stop")
				{
					if (lineLinearPos > 1) 
					{
						lineLinearPos = 1;
						pathControlMode = 0;
					}
					else if (lineLinearPos < 0) 
					{
						pathControlMode = 0;
						lineLinearPos = 0;
					}
				}
				else if (path_endmode == "reset")
				{
					if (lineLinearPos > 1) 
					{
						lineLinearPos = 0;
						pathControlMode = 0;
					}
					else if (lineLinearPos < 0) 
					{
						lineLinearPos = 1;
						pathControlMode = 0;
					}
				}
				
				var line:EdLine = Levels.GetCurrent().lines[lineIndex];
				if (line == null) return new Point(0, 0);
				
				var p:Point;
				
				//var pathEaseName:String;
				//var pathEaseValue:Number;
				
				var lp:Number = lineLinearPos;

				if (pathEaseName != null && pathEaseName != "" && pathEaseName != "linear")
				{
					lp = Ease.EaseByName(pathEaseName, lp, pathEaseValue);
				}
				
				if (lineLoop == true && lineSpline == false)
				{
					p = line.GetInterpolatedPoint_SegmentRatio(lp,lineLoop, lineSpline);
				}
				else
				{
					p = line.GetInterpolatedPoint_EqualSpacing(lp, lineLoop, lineSpline);
				}
				
				
				UpdatePhysObj_Path_SetPos();
			}
		}

//---------------------------------------------------------------------------------------------

		function WakeConnectedPhysicsObjects()
		{
			if (nape_joints == null) return;
			if (nape_joints.length == 0) return;			
			for each(var j:Constraint in nape_joints)
			{
				j.visitBodies(WakeConnectedObjectsCB);				
			}
		}

		function WakeConnectedObjectsCB(b:Body)
		{
			b.velocity.y += 0.00000001;	// wake him up, hopefully
		}

//---------------------------------------------------------------------------------------------
// Generator generic functions
//---------------------------------------------------------------------------------------------

		
	}

}