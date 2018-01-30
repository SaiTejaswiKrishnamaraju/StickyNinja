package  
{
	import EditorPackage.EdJoint;
	import EditorPackage.EdLine;
	import EditorPackage.EdObj;
	import EditorPackage.GameLayers;
	import EditorPackage.ObjParameters;
	import EditorPackage.PolyMaterial;
	import EditorPackage.PolyMaterials;
	import flash.Boot;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.callbacks.Listener;
	import nape.callbacks.PreListener;
	import nape.constraint.AngleJoint;
	import nape.constraint.Constraint;
	import nape.constraint.DistanceJoint;
	import nape.constraint.LineJoint;
	import nape.constraint.MotorJoint;
	import nape.constraint.PivotJoint;
	import nape.constraint.WeldJoint;
	import nape.dynamics.InteractionFilter;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	
	import nape.geom.*;
	import nape.phys.*;
	import nape.space.*;
	import nape.util.*;
	
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class PhysicsBase
	{
		public static var useNape:Boolean = true;
		
		
		private static var nape_space0:Space;
		private static var nape_space1:Space;
		private static var nape_space2:Space;
		public static var nape_debug:BitmapDebug;		
		public static var nape_cbtype_default:CbType;
		public static var nape_timeStep:Number = 1 / 60;
		public static var nape_velIterations:Number = 10;
		public static var nape_posIterations:Number = 10;
		public static var nape_numSteps:int = 1;
		public static var nape_Gravity:Number= 300;
		public static var nape_oneOverTimeStep:Number = 1 / nape_timeStep;
		
		static var fluidProperties:FluidProperties = new FluidProperties(10,30);
		
		static var current_space:Space;
		
		public static function SetCurrentSpace(index:int)
		{
			if(index == 0) current_space = nape_space0;
			if(index == 1) current_space = nape_space1;
		}
		public static function GetNapeSpace():Space
		{
			return current_space;
		}
		
		static var shapeCache:Object;

		
		static var interactionListener:InteractionListener;
		static var interactionListener1:InteractionListener;
		static var interactionListener2:InteractionListener;
		static var interactionListener3:InteractionListener;
		static var interactionListener4:InteractionListener;
		static var preListener1:PreListener;
		
		public static function AddListenersA():void
		{
			//nape_space0.listeners.add(interactionListenerA);			
		}
		public static function RemoveListenersA():void
		{
			//nape_space0.listeners.remove(interactionListenerA);
		}
		
		
		public static function AddListeners():void
		{
			//nape_space0.listeners.add(interactionListener);
			//nape_space0.listeners.add(interactionListener1);
			//nape_space0.listeners.add(interactionListener2);			
		}
		public static function RemoveListeners():void
		{
			//nape_space0.listeners.remove(interactionListener);
			//nape_space0.listeners.remove(interactionListener1);
			//nape_space0.listeners.remove(interactionListener2);			
		}
		
		
		public static function SetGravity(g:Number):void
		{
			var v:Vec2 = new Vec2(0, g);
			nape_space0.gravity = v;
//			nape_space1.gravity = v;
//			nape_space2.gravity = v;
			nape_Gravity = g;
		}
		public static function InitNape():void
		{
			var a = new flash.Boot();
			
			shapeCache = new Object();
			
			nape_space0 = new Space(new Vec2(0, nape_Gravity),null);
//			nape_space1 = new Space(new Vec2(0, nape_Gravity), null);
//			nape_space2 = new Space(new Vec2(0, nape_Gravity), null);
			
			//trace(nape_space0.worldLinearDrag);
			//trace(nape_space0.worldAngularDrag);
			
			nape_space0.worldLinearDrag = 0;	// 0.05;
			nape_space0.worldAngularDrag = 0;	// 0.05;
			
			current_space = nape_space0;
			
//			nape_debug = new BitmapDebug(Defs.displayarea_w, Defs.displayarea_h, 0x0);
			
			nape_cbtype_default = new CbType();
			
			interactionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, nape_cbtype_default, nape_cbtype_default, NapeContacts.BeginCollide);
			interactionListener1 = new InteractionListener(CbEvent.ONGOING, InteractionType.COLLISION, nape_cbtype_default, nape_cbtype_default, NapeContacts.OngoingCollide);
			interactionListener2 = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, nape_cbtype_default, nape_cbtype_default, NapeContacts.BeginSensor);
			interactionListener3 = new InteractionListener(CbEvent.ONGOING, InteractionType.SENSOR, nape_cbtype_default, nape_cbtype_default, NapeContacts.OngoingSensor);
			
//			preListener1 = new PreListener(InteractionType.COLLISION, nape_cbtype_default, nape_cbtype_default, NapeContacts.BeginPre);


			nape_space0.listeners.add(interactionListener);
			nape_space0.listeners.add(interactionListener1);
			nape_space0.listeners.add(interactionListener2);			
			nape_space0.listeners.add(interactionListener3);			
//			nape_space0.listeners.add(preListener1);			
			
			
			InitObjectParameters();
			
		}
		
		public static function TimeStep()
		{
			GetNapeSpace().step(nape_timeStep, 10, 10);
		}
		
		static function InitObjectParameters()
		{
			ObjectParameters.AddParamBool("fixed", true);
			
			ObjectParameters.AddParamBool("collide_joined", false);
			
			ObjectParameters.AddParamBool("dist_soft", false);
			ObjectParameters.AddParamNumber("dist_soft_frequency", 0.5,true,false,0,0,0.1);
			ObjectParameters.AddParamNumber("dist_limit", 0,false,false,0,0,50);
			
			ObjectParameters.AddParamBool("weld_soft", false);
			ObjectParameters.AddParamNumber("weld_soft_frequency", 0.5, true, false, 0, 0, 0.1);
			
			ObjectParameters.AddParamBool("rev_soft", false);
			ObjectParameters.AddParamNumber("rev_soft_frequency", 0.5, true, false, 0, 0, 0.1);
			ObjectParameters.AddParamBool("rev_enablelimit", false);
			ObjectParameters.AddParamAngle("rev_lowerangle", 0);
			ObjectParameters.AddParamAngle("rev_upperangle", 0);
			ObjectParameters.AddParamBool("rev_enablemotor", false);
			ObjectParameters.AddParamNumber("rev_motorrate", 10,false,false,0,0,1);
			ObjectParameters.AddParamNumber("rev_motorratio", 1,false,false,0,0,1);
			ObjectParameters.AddParamNumber("rev_motormax", 10000,false,false,0,0,1);

			ObjectParameters.AddParam("joint_initfunction", "list", "InitGameObjJoint_Null", "InitGameObjJoint_Null,InitGameObjJoint_Trapeze,InitGameObjJoint_Trapeze1,InitGameObjJoint_LoweringDistance,InitGameObjJoint_RaisingDistance,InitGameObjJoint_SwitchedDistance,InitJoint_RotateSwitch,InitJoint_RotateSwitch_StopGo,InitJoint_Render,InitJoint_RotateConstant");
		
			ObjectParameters.AddParamBool("take_surface_pos", false);
			ObjectParameters.AddParamBool("take_surface_dir", false);
			ObjectParameters.AddParamBool("place_surface_dir", false);
	
			
		}
		
		public static function Init():void
		{
			InitNape();
		}
		
		public function PhysicsBase() 
		{
			
		}

		
		

		static function InitLines(addGameObjectsPerPoly:Boolean = true)
		{
			var b:Body;
			
			var p:Point;
			var p0:Point;
			var p1:Point;
			var p2:Point;
			var p3:Point;
			var i:int;

			var ud:PhysObj_BodyUserData = new PhysObj_BodyUserData();
			ud.bodyName = "wall";
			
			
			var height:Number = 50;
			var l :Level = Levels.GetCurrent();
			
			
			for each(var line:EdLine in l.lines)
			{
				if (line.type == 0)
				{
					var points:Array = line.points;
					var linetype:int = line.type;
					
					if (line.IsSpline())
					{
						points = line.GetCatmullRomPointsList(points, 0, 0);
					}
						
					var polyMaterial:PolyMaterial = PolyMaterials.GetByName(line.objParameters.GetValueString("line_material"));
					var physMaterial:PhysObj_Material = Game.GetPhysMaterialByName(polyMaterial.materialName);
					var interactionFilter:InteractionFilter = new InteractionFilter(polyMaterial.collisionCategory,polyMaterial.collisionMask,polyMaterial.sensorCategory, polyMaterial.sensorMask,polyMaterial.fluidCategory, polyMaterial.fluidMask);

					var sensorEnabled:Boolean = false;
					var fluidEnabled:Boolean = false;
					if (polyMaterial.sensorCategory != 0) sensorEnabled = true;
					if (polyMaterial.fluidCategory != 0) fluidEnabled = true;
					
					
					if (polyMaterial.initType == "path")
					{
					}				
					else if (polyMaterial.initType == "nophysics")
					{
						var centrePoint:Point = line.CalculateCentre();
						var go:GameObj = GameObjects.AddObj(0, 0, 0);	// centrePoint.x, centrePoint.y, 0);
						go.InitPhysicsLineObject(line);
					}			
					else if (polyMaterial.initType == "poly")
					{
						if (points.length >= 3)
						{					
							// check for duplicate points
							
							if (Game.usedebug)
							{
								for each(var pt:Point in points)
								{
									var count:int = 0;
									for each(var pt1:Point in points)
									{
										if (pt.x == pt1.x && pt.y == pt1.y)
										{
											count++;
										}
									}
								}
								if (count != 1)
								{
									trace("ERROR DUPLICATE POINTS");
								}
							}
							
							
							var cx:Number = 0;
							var cy:Number = 0;
							var nape_points:Array = new Array();
							for each(var pt:Point in points)
							{
								nape_points.push(new Vec2(pt.x, pt.y));
								cx += pt.x;
								cy += pt.y;
							}
							cx /= points.length;
							cy /= points.length;
							
							for each(var v:Vec2 in nape_points)
							{
								v.x -= cx;
								v.y -= cy;
							}
							
							
							var gp:GeomPoly = new GeomPoly(nape_points);
							if (gp.isClockwise() == false)
							{
								Utils.traceerror("ERROR poly isn't clockwise");
								Utils.traceerror("points " +
										points[0].x+" "+points[0].y+"  "+
										points[1].x+" "+points[1].y+"  "+
										points[2].x + " " + points[2].y);
								var aaa:int = 0;
								break;
							}
							if (gp.isSimple() == false)
							{
								Utils.traceerror("ERROR poly isn't Simple");
								Utils.traceerror("points " +
										points[0].x+" "+points[0].y+"  "+
										points[1].x+" "+points[1].y+"  "+
										points[2].x + " " + points[2].y);
								var aaa:int = 0;
								break;
							}
							var gpl:GeomPolyList = gp.triangularDecomposition();
							b = new Body(BodyType.STATIC, new Vec2(cx, cy));
							
							
							for (var gpindex:int = 0; gpindex < gpl.length; gpindex++)
							{
								var gp:GeomPoly = gpl.at(gpindex);
								var poly:Polygon = new Polygon(gp, physMaterial.MakeNapeMaterial(), interactionFilter);
								
								poly.userData.data = new Object();
								poly.userData.data.name = physMaterial.name;
								
								poly.sensorEnabled = sensorEnabled;
								poly.fluidEnabled = fluidEnabled;
								
								if (fluidEnabled) poly.fluidProperties = fluidProperties;
								
								b.shapes.add(poly);
							}
								 
							if (polyMaterial.fixed)
							{
								
							}
							else
							{
								b.type = BodyType.DYNAMIC;
							}
								
							line.centrex = cx;
							line.centrey = cy;
							
							var thisud:PhysObj_BodyUserData = ud.Clone();
							
							if (addGameObjectsPerPoly)
							{
								//var centrePoint:Point = line.CalculateCentre();
								var go:GameObj = GameObjects.AddObj(cx,cy, 0);
								go.InitPhysicsLineObject_Nape(line, b);
								thisud.gameObjectIndex = go.listIndex;
								thisud.gameObject = go;
								b.userData.data = thisud;	
							}
							else
							{
								b.userData.data = physMaterial.Clone();
							}
							
							
							b.cbTypes.add(PhysicsBase.nape_cbtype_default);
							GetNapeSpace().bodies.add(b);
						}
					}
					else if (polyMaterial.initType == "surface")
					{
						if (points.length >= 2)
						{					
							var cx:Number = 0;
							var cy:Number = 0;
							var nape_points:Array = new Array();
							for (var i:int = 0; i < points.length-1; i++)
							{
								var j:int = i + 1;
								if (j >= points.length) j = 0;
								var pt:Point = points[i];
								var pt1:Point = points[j];
								if (pt1.x > pt.x)
								{
									nape_points.push(new Vec2(pt.x, pt.y));
									cx += pt.x;
									cy += pt.y;
								}
								else
								{
									//trace("SURFACE "+ pt.x + "  " + pt1.x);
								}
							}
							cx /= nape_points.length;
							cy /= nape_points.length;
							
							for each(var v:Vec2 in nape_points)
							{
								v.x -= cx;
								v.y -= cy;
							}
							
							if (isNaN(cx) == false)
							{
								b = new Body(BodyType.STATIC, new Vec2(cx, cy));
								
								for (var i:int = 0; i < nape_points.length - 1; i++)
								{
									var lv:Array = new Array();
									
									var vpt:Vec2 = nape_points[i].copy();
									var vpt1:Vec2 = nape_points[i + 1].copy();						
									var vpt2:Vec2 = nape_points[i + 1].copy();						
									var vpt3:Vec2 = nape_points[i + 0].copy();	
									vpt2.y += 20;
									vpt3.y += 20;
									lv.push(vpt);
									lv.push(vpt1);
									lv.push(vpt2);
									lv.push(vpt3);
								
									var poly:Polygon = new Polygon(lv, physMaterial.MakeNapeMaterial(), interactionFilter);
									
									poly.userData.data = new Object();
									poly.userData.data.name = physMaterial.name;
									
									poly.sensorEnabled = sensorEnabled;
									poly.fluidEnabled = fluidEnabled;
									if (fluidEnabled) poly.fluidProperties = fluidProperties;
									
									b.shapes.add(poly);
								}
									
								if (polyMaterial.fixed)
								{
									
								}
								else
								{
									b.type = BodyType.DYNAMIC;
								}
									
								line.centrex = cx;
								line.centrey = cy;
								
								var thisud:PhysObj_BodyUserData = ud.Clone();
								
								if (addGameObjectsPerPoly)
								{
									//var centrePoint:Point = line.CalculateCentre();
									var go:GameObj = GameObjects.AddObj(cx,cy, 0);
									go.InitPhysicsLineObject_Nape(line, b);
									thisud.gameObjectIndex = go.listIndex;
									thisud.gameObject = go;
									b.userData.data = thisud;	
								}
								else
								{
									b.userData.data = physMaterial.Clone();
								}
								
								
								b.cbTypes.add(PhysicsBase.nape_cbtype_default);
								GetNapeSpace().bodies.add(b);
							}
						}
					}
					else if (polyMaterial.initType == "ceiling")
					{
						if (points.length >= 2)
						{					
							var cx:Number = 0;
							var cy:Number = 0;
							var nape_points:Array = new Array();
							for (var i:int = 0; i < points.length-1; i++)
							{
								var j:int = i + 1;
								if (j >= points.length) j = 0;
								var pt:Point = points[i];
								var pt1:Point = points[j];
								if (pt1.x > pt.x)
								{
									nape_points.push(new Vec2(pt.x, pt.y));
									cx += pt.x;
									cy += pt.y;
								}
								else
								{
									//trace("SURFACE "+ pt.x + "  " + pt1.x);
								}
							}
							cx /= nape_points.length;
							cy /= nape_points.length;
							
							for each(var v:Vec2 in nape_points)
							{
								v.x -= cx;
								v.y -= cy;
							}
							
							if (isNaN(cx) == false)
							{
								b = new Body(BodyType.STATIC, new Vec2(cx, cy));
								
								for (var i:int = 0; i < nape_points.length - 1; i++)
								{
									var lv:Array = new Array();
									
									var vpt:Vec2 = nape_points[i].copy();
									var vpt1:Vec2 = nape_points[i + 1].copy();						
									var vpt2:Vec2 = nape_points[i + 1].copy();						
									var vpt3:Vec2 = nape_points[i + 0].copy();	
									vpt2.y -= 20;
									vpt3.y -= 20;
									lv.push(vpt);
									lv.push(vpt1);
									lv.push(vpt2);
									lv.push(vpt3);
								
									var poly:Polygon = new Polygon(lv, physMaterial.MakeNapeMaterial(), interactionFilter);
									
									poly.userData.data = new Object();
									poly.userData.data.name = physMaterial.name;
									
									poly.sensorEnabled = sensorEnabled;
									poly.fluidEnabled = fluidEnabled;
									if (fluidEnabled) poly.fluidProperties = fluidProperties;
									
									b.shapes.add(poly);
								}
									
								if (polyMaterial.fixed)
								{
									
								}
								else
								{
									b.type = BodyType.DYNAMIC;
								}
									
								line.centrex = cx;
								line.centrey = cy;
								
								var thisud:PhysObj_BodyUserData = ud.Clone();
								
								if (addGameObjectsPerPoly)
								{
									//var centrePoint:Point = line.CalculateCentre();
									var go:GameObj = GameObjects.AddObj(cx,cy, 0);
									go.InitPhysicsLineObject_Nape(line, b);
									thisud.gameObjectIndex = go.listIndex;
									thisud.gameObject = go;
									b.userData.data = thisud;	
								}
								else
								{
									b.userData.data = physMaterial.Clone();
								}
								
								
								b.cbTypes.add(PhysicsBase.nape_cbtype_default);
								GetNapeSpace().bodies.add(b);
							}
						}
					}
				}
			}
			
		}
		
		
		
		
		static function AddPhysObjAt(objName:String, _x:Number, _y:Number, _rotDeg:Number,scale:Number,instanceName:String="",initParams:String = "",_id:String="",independantGO:Boolean = false,_xflip:Boolean=false):GameObj
		{
			
			var go:GameObj;
			
			
			var physobj:PhysObj = Game.objectDefs.FindByName(objName);
			if (physobj == null)
			{
				Utils.traceerror("error in AddPhysObjAt() - can't find object " + objName);
				return null;
			}
			
			if (independantGO == false)
			{
				if (physobj.staticGameObj)
				{
					go = GameObjects.AddStaticObj(_x, _y, 0);
				}
				else
				{
					go = GameObjects.AddObj(_x, _y, 0);
				}
			}
			else
			{
				go = new GameObj();
				go.isIndependant = true;
			}
			
			
			
			
			var rot:Number = Utils.DegToRad(_rotDeg);			

			go.nape_bodies = new Vector.<Body>();
			go.nape_joints = new Vector.<Constraint>();
			go.initParams = initParams;
			go.id = _id;
			
			go.physobj = physobj;

			go.InitKeepAwakeFunction();

			go.initFunctionVarString = physobj.initFunctionParameters;
			
			if (_xflip) go.xflip = true;
			
			Utils.GetParams(initParams);			
			var layerZpos:Number = GameLayers.GetZPosByName(Utils.GetParamString("game_layer"));
			go.zpos = layerZpos;
			
			var isFixed:Boolean =Utils.GetParamBool("fixed");
			
			go.dir = Utils.DegToRad(_rotDeg);
			go.scale = scale;
			
			//go.InitPhysicsObject(graphic.graphicID, graphic.frame, _x, _y, "", false);
			go.colFlag_isPhysObj = true;
			go.isPhysObj = true;
			go.physObjOffsetX = 0;	// _x;
			go.physObjOffsetY = 0;	// _y;
			//go.physObjInitVarString = _initvarstring;
			
			var bodyOffset:Vec2 = new Vec2(0, 0);
			
			var jointxoff:Number
			var jointyoff:Number
			
			var i:int;
			
			var b:Body;

			var m:Matrix = new Matrix();
			m.rotate(rot);
			m.scale(scale, scale);
			
			
			if (physobj.bodies.length > 1)
			{
				Utils.traceerror("EEEEEEEEERRRRRRRROOOOOOOOOORRRRR physobj.bodies.length= " + physobj.bodies.length);
			}
			
			
			if (physobj.graphics.length != 0)
			{
				var graphic:PhysObj_Graphic = physobj.graphics[0];
				
				go.dobj = GraphicObjects.GetDisplayObjByName(graphic.graphicName);
				go.frame = graphic.frame;

			}
			
			
			for each(var body:PhysObj_Body in physobj.bodies)		// there should be only one now.
			{
				
				var bodyxoff:Number = body.pos.x;
				var bodyyoff:Number = body.pos.y;
				
				if (isNaN(m.a))
				{
					var aaa:int = 0;
				}
				
				var p:Point = new Point(bodyxoff,bodyyoff);
				p = m.transformPoint(p);
				bodyxoff = p.x;
				bodyyoff = p.y;
				
				b = new Body();
				b.position.setxy(_x + bodyxoff, _y + bodyyoff);
				
				
				b.rotation = rot;
				
				if (_xflip)
				{
					b.rotation = -rot;
				}
				
				
				
				
				var bud:PhysObj_BodyUserData = new PhysObj_BodyUserData();
				bud.type = objName;
				bud.bodyName = body.name;
				bud.gameObjectIndex = go.listIndex;
				bud.gameObject = go;
				if (go.isIndependant == true)
				{
					bud.gameObjectIndex = -1;
					bud.independantGO = go;
				}
				if (go.isStaticObject)
				{
					bud.gameObjectIndex = -1;
				}
				
				b.userData.data = bud;
				
				

				var shapeIndex:int = 0;
				for each(var shape:PhysObj_Shape in body.shapes)
				{
					var physMaterial:PhysObj_Material = Game.GetPhysMaterialByName(shape.materialName);

					if (shape.type == PhysObj_Shape.Type_Poly)
					{
						var triangulatePoly:Boolean = true;
						if (triangulatePoly == false)
						{						
							var interactionFilter:InteractionFilter = new InteractionFilter(shape.collisionCategory, shape.collisionMask, shape.sensorCategory, shape.sensorMask, shape.fluidCategory, shape.fluidMask);
							
							var sensorEnabled:Boolean = false;
							var fluidEnabled:Boolean = false;
							if (shape.sensorCategory != 0) sensorEnabled = true;
							if (shape.fluidCategory != 0) fluidEnabled = true;
							
							var points:Array = shape.poly_points;
							
							var localVerts:Array = new Array()
							for each(var pt:Point in points)
							{
								localVerts.push(Vec2.fromPoint(pt));
							}
							
							if (_xflip)
							{
								for each(var v2:Vec2 in localVerts)
								{
//									v2.x = -v2.x;
								}
							}
							
							
							var gp:GeomPoly = new GeomPoly(localVerts);
							if (gp.isConvex() == true)
							{
								var aaaa:int = 0;
							}
							
							var poly:Polygon = new Polygon(localVerts,  physMaterial.MakeNapeMaterial(), interactionFilter);
							
							poly.userData.data = new Object();
							poly.userData.data.name = physMaterial.name;
							poly.userData.data.shapeName = shape.name;
							
							poly.sensorEnabled = sensorEnabled;
							poly.fluidEnabled = fluidEnabled;
							if (fluidEnabled) poly.fluidProperties = fluidProperties;
							
							b.shapes.add(poly);
						}
						else
						{
							var points:Array = shape.poly_points;
							if (points.length >= 3)
							{
								
								var pointsToProcess:Array = new Array();
								for each(var p:Point in points)
								{
									var pp:Point = new Point(p.x, p.y);
									if (_xflip) 
									{
										// gets here
										pp.x = -pp.x;
									}
									pointsToProcess.push(pp);
								}

								
								var triangulate:Triangulate = new Triangulate();
								var triangulatedVerts:Array = triangulate.process(pointsToProcess);
								
								if (triangulatedVerts == null)
								{									
									Utils.traceerror("object failed triangulating: " + pointsToProcess.length);
								}
								else
								{
//									Utils.print("object triangulating: " + pointsToProcess.length + "  ->  " + triangulatedVerts.length);
									
								}
								var numTris:int = int(triangulatedVerts.length / 3);
								for (var t:int = 0; t < numTris; t++)
								{
									var p0:Point = triangulatedVerts[(t * 3) + 0];
									var p1:Point = triangulatedVerts[(t * 3) + 1];
									var p2:Point = triangulatedVerts[(t * 3) + 2];

																		
									var interactionFilter:InteractionFilter = new InteractionFilter(shape.collisionCategory, shape.collisionMask, shape.sensorCategory, shape.sensorMask, shape.fluidCategory, shape.fluidMask);
									
									var sensorEnabled:Boolean = false;
									var fluidEnabled:Boolean = false;
									if (shape.sensorCategory != 0) sensorEnabled = true;
									if (shape.fluidCategory != 0) fluidEnabled = true;
				
									var poly:Polygon = new Polygon([Vec2.fromPoint(p0), Vec2.fromPoint(p1), Vec2.fromPoint(p2)],  physMaterial.MakeNapeMaterial(), interactionFilter);
									poly.userData.data = new Object();
									poly.userData.data.name = physMaterial.name;
									poly.userData.data.shapeName = shape.name;
									
									poly.sensorEnabled = sensorEnabled;
									poly.fluidEnabled = fluidEnabled;
									if (fluidEnabled) poly.fluidProperties = fluidProperties;
									
									b.shapes.add(poly);
									
								}
									
							}
						}
					}
					else if (shape.type == PhysObj_Shape.Type_Circle)
					{
						var shapeName:String = objName + "_" + shapeIndex;
						
						if (IsShapeInCache(shapeName))
						{
//							trace(shapeName + " already in cache");
							
							var nape_circle:Circle = (GetShapeFromCache(shapeName).copy()) as Circle;							
							nape_circle.filter = nape_circle.filter.copy();
							
							
							nape_circle.userData.data = new Object();
							nape_circle.userData.data.name = physMaterial.name;
							nape_circle.userData.data.shapeName = shape.name;
							
							if (fluidEnabled) nape_circle.fluidProperties = fluidProperties;
							
						}
						else
						{
							var circle_pos:Vec2 = new Vec2(shape.circle_pos.x * scale, shape.circle_pos.y * scale);
							var nape_circle:Circle = new Circle(shape.circle_radius * scale, circle_pos);
							
							
							nape_circle.material = physMaterial.MakeNapeMaterial();
							var interactionFilter:InteractionFilter = new InteractionFilter(shape.collisionCategory, shape.collisionMask, shape.sensorCategory, shape.sensorMask, shape.fluidCategory, shape.fluidMask);
							
							var sensorEnabled:Boolean = false;
							var fluidEnabled:Boolean = false;
							if (shape.sensorCategory != 0) sensorEnabled = true;
							if (shape.fluidCategory != 0) fluidEnabled = true;
							
							nape_circle.filter = interactionFilter;
							
							nape_circle.sensorEnabled = sensorEnabled;
							nape_circle.fluidEnabled = fluidEnabled;
							
							nape_circle.userData.data = new Object();
							nape_circle.userData.data.name = physMaterial.name;
							nape_circle.userData.data.shapeName = shape.name;
							
							if (fluidEnabled) nape_circle.fluidProperties = fluidProperties;
							
							AddShapeToCache(shapeName, nape_circle.copy());
//							trace(shapeName + " adding to cache");
							
						}
						
						b.shapes.add(nape_circle);

						
					}
					shapeIndex++;
				}
				
				
				
				b.isBullet = false;
				
				//if (body.fixed)
				if (isFixed)
				{
					b.type = BodyType.STATIC;
				}
				else
				{
					b.type = BodyType.DYNAMIC;
				}
				b.angularVel = 0;
				b.velocity.setxy(0, 0);
				
				
				bodyOffset = b.localCOM.copy();
				if (shape.shiftCOM)
				{
					b.align();
				}
				
				
				
				b.cbTypes.add(PhysicsBase.nape_cbtype_default);
				GetNapeSpace().bodies.add(b);
				go.nape_bodies.push(b);
				
				b.disableCCD = true;
				
			}	

//			try
//			{
				GameObjects.UpdateSingleGOsFromPhysics(go);
				if (physobj.initFunctionName != "")
				{
					go.nape_bodyOffset = bodyOffset.copy();
					go[physobj.initFunctionName]();
					
				}
//			}catch (err:Error)
//			{
//				Utils.traceerror("init function doesn't exist: " + physobj.initFunctionName);
//			}
			
			
			return go;

			
		}
		
		public static function InitJoints()
		{
			var l:Level = Levels.GetCurrent();
			var jointList:Array = Levels.GetCurrentLevelJoints();
			for each(var joint:EdJoint in jointList)
			{
				AddJoint_Nape(joint);
			}			
		}

		public static function TestLogicLink(joint:EdJoint):Boolean
		{
			if (joint.type == EdJoint.Type_LogicLink)
			{
				var go0:GameObj = GameObjects.GetGameObjById(joint.obj0Name);
				var go1:GameObj = GameObjects.GetGameObjById(joint.obj1Name);
				if (go0 != null && go1 != null)
				{
				
					go0.logicLink0 = null;
					go0.logicLink1.push(go1);
					go1.logicLink0.push(go0);
					go1.logicLink1 = null;
				}
				else
				{
					if (CONFIG::debug) // traces inside this block because of compiler issue in release mode :(
					{
						if (go0 == null) 
						{
							var a:int = 0;	
							trace("JOINT ERROR " + joint.obj0Name);
						}
						if (go1 == null) 
						{
							var b:int = 0;
							trace("JOINT ERROR " + joint.obj1Name);
						}
					}
				}
				return true;
			}
			return false;
		}
		
		public static function AddJoint_Nape(joint:EdJoint):Vector.<Constraint>
		{
			var p:Point;
			var p1:Point;
			var joinedBodiesCollide:Boolean = joint.objParameters.GetValueBoolean("collide_joined");
			var joinedBodiesIgnoreCollision:Boolean = (joinedBodiesCollide == false);
			
			var cons:Vector.<Constraint> = new Vector.<Constraint>();
			if(TestLogicLink(joint))
			{
				
			}
			else if (joint.type != EdJoint.Type_Switch)
			{
				var jb0:Body = PhysicsBase.GetNapeSpace().world;
				var jb1:Body = PhysicsBase.GetNapeSpace().world;
				if (joint.obj0Name == "")
				{
//					Utils.print("jb0 using ground");
				}
				else
				{
					var go0:GameObj = GameObjects.GetGameObjById(joint.obj0Name);
					var go0a:GameObj = GameObjects.GetGameObjByLineName(joint.obj0Name);
					if (go0 != null) 
					{
						if (go0.nape_bodies == null)
						{
							Utils.traceerror("ERROR: jb0 joint.obj0Name "+joint.obj0Name);
						}						
						jb0 = go0.nape_bodies[0];
//						Utils.print("jb0 joint.obj0Name "+joint.obj0Name);
					}
					else if (go0a != null)
					{
						if (go0a.nape_bodies == null)
						{
							Utils.traceerror("ERROR: jb0a joint.obj0Name "+joint.obj0Name);
						}						
						jb0 = go0a.nape_bodies[0];
//						Utils.print("jb0 joint.obj0Name is a line: "+joint.obj0Name);
					}
					else
					{
						Utils.traceerror("jb0 gameobject not found "+joint.obj0Name);
					}					
				}
				if (joint.obj1Name == "")
				{
//					Utils.print("jb1 using ground");
				}
				else
				{
					var go1:GameObj = GameObjects.GetGameObjById(joint.obj1Name);
					var go1a:GameObj = GameObjects.GetGameObjByLineName(joint.obj1Name);
					if (go1 != null) 
					{
						jb1 = go1.nape_bodies[0];
//						Utils.print("jb1 joint.obj1Name "+joint.obj1Name);
					}
					else if (go1a != null)
					{
						jb1 = go1a.nape_bodies[0];
//						Utils.print("jb0 joint.obj1Name is a line: "+joint.obj1Name);
					}
					else
					{
						Utils.traceerror("jb1 gameobject not found "+joint.obj1Name);
					}									
				}
			}
			
			
			if (joint.type == EdJoint.Type_Rev)
			{
//				Utils.print("adding joint here " + jb0 + " " + jb1);
				p = new Point(joint.rev_pos.x,joint.rev_pos.y);
				
				var v0:Vec2 = Vec2.fromPoint(p);

				var jb0Dynamic:Boolean = false;
				var jb1Dynamic:Boolean = false;
				if (jb0.type == BodyType.DYNAMIC) jb0Dynamic = true;
				if (jb1.type == BodyType.DYNAMIC) jb1Dynamic = true;
				
				if (jb0Dynamic == false && jb1Dynamic == false)
				{
					Utils.traceerror("REV JOINT ERROR: Both bodies non-dynamic: " + joint.obj0Name + " / " + joint.obj1Name);
					return cons;
				}
				

				var pivotjoint:PivotJoint = new PivotJoint(jb0, jb1,jb0.worldPointToLocal(v0),jb1.worldPointToLocal(v0));
				pivotjoint.ignore = joinedBodiesIgnoreCollision;
				
				PhysicsBase.GetNapeSpace().constraints.add(pivotjoint);
				cons.push(pivotjoint);
				
				
				
				var soft:Boolean = joint.objParameters.GetValueBoolean("rev_soft");
				if (soft)
				{
					var frequency:Number = joint.objParameters.GetValueNumber("rev_soft_frequency");
					pivotjoint.stiff = false;
					pivotjoint.frequency = frequency;
				}
				
				var enableMotor:Boolean = joint.objParameters.GetValueBoolean("rev_enablemotor");
				if (enableMotor)
				{
					var motorRate:Number = joint.objParameters.GetValueNumber("rev_motorrate");
					var motorRatio:Number = joint.objParameters.GetValueNumber("rev_motorratio");
					var motorMax:Number = joint.objParameters.GetValueNumber("rev_motormax");
					var motorJoint:MotorJoint = new MotorJoint(jb0, jb1, motorRate, motorRatio);
					motorJoint.ignore = joinedBodiesIgnoreCollision;
					
					motorJoint.maxForce = motorMax;
					
					GetNapeSpace().constraints.add(motorJoint);
					cons.push(motorJoint);

				}
				
				var enableLimit:Boolean = joint.objParameters.GetValueBoolean("rev_enablelimit");
				if (enableLimit)
				{
					var minAngle:Number = Utils.DegToRad(joint.objParameters.GetValueNumber("rev_lowerangle"));
					var maxAngle:Number = Utils.DegToRad(joint.objParameters.GetValueNumber("rev_upperangle"));

					var angleJoint:AngleJoint = new AngleJoint(jb0, jb1, minAngle, maxAngle, 1);
					angleJoint.ignore = joinedBodiesIgnoreCollision;
					GetNapeSpace().constraints.add(angleJoint);
					cons.push(angleJoint);
				}
				
				
			}
			if (joint.type == EdJoint.Type_Weld)
			{
				var phase:Number = jb1.rotation - jb0.rotation;
				
				//Utils.trace("phase " + phase);
				//Utils.trace("jb0.rotation " + jb0.rotation);
				//Utils.trace("jb1.rotation " + jb1.rotation);
				
				
				var v0:Vec2 = new Vec2(jb1.position.x-jb0.position.y, jb1.position.y-jb0.position.y);
				
				var m:Matrix = new Matrix();
				var p:Point = new Point();

				m.identity();
				m.rotate(jb0.rotation);
				p.x = v0.x;
				p.y = v0.y;
				p = m.transformPoint(p);
				
				//v0.x = p.x;
				//v0.y = p.y;
				
				if (jb0.type != BodyType.DYNAMIC && jb1.type != BodyType.DYNAMIC )
				{
					Utils.traceerror("ERRROOORR Weld joints cannot have both bodies non-dynamic");
					Utils.traceerror("Weld joint not being created");
				}
				else
				{
					
					
					var weldJoint:WeldJoint = new WeldJoint(jb0, jb1,jb0.worldPointToLocal(v0),jb1.worldPointToLocal(v0) , phase);
					weldJoint.ignore = joinedBodiesIgnoreCollision;
					var soft:Boolean = joint.objParameters.GetValueBoolean("weld_soft");
					if (soft)
					{
						var frequency:Number = joint.objParameters.GetValueNumber("weld_soft_frequency");
						weldJoint.stiff = false;
						weldJoint.frequency = frequency;
					}

					GetNapeSpace().constraints.add(weldJoint);
					cons.push(weldJoint);
				}				
				
			}
			
			if (joint.type == EdJoint.Type_Distance)
			{
				
				var v0:Vec2 = new Vec2(joint.dist_pos0.x,joint.dist_pos0.y);
				var v1:Vec2 = new Vec2(joint.dist_pos1.x,joint.dist_pos1.y);
				
				var m:Matrix = new Matrix();
				var p:Point = new Point();
				var p1:Point = new Point();

				m.identity();
				m.rotate(jb0.rotation);
				p.x = v0.x;
				p.y = v0.y;
				p = m.transformPoint(p);

				m.identity();
				m.rotate(jb1.rotation);
				p1.x = v1.x;
				p1.y = v1.y;
				p1 = m.transformPoint(p1);
				
				if (isNaN(joint.dist_min))
				{
					joint.dist_min = joint.dist_max = Utils.DistBetweenPoints(p.x, p.y, p1.x, p1.y);
				}
				
//				var dist:Number = Utils.DistBetweenPoints(joint.dist_pos0.x, joint.dist_pos0.y, joint.dist_pos1.x, joint.dist_pos1.y);				
//				var dist_limit:Number = joint.objParameters.GetValueNumber("dist_limit");
				
				var distJoint = new DistanceJoint(jb0, jb1, jb0.worldPointToLocal(v0),jb1.worldPointToLocal(v1), joint.dist_min,joint.dist_max);
				distJoint.ignore = joinedBodiesIgnoreCollision;
				
				var soft:Boolean = joint.objParameters.GetValueBoolean("dist_soft");
				if (soft)
				{
					var frequency:Number = joint.objParameters.GetValueNumber("dist_soft_frequency");
					distJoint.stiff = false;
					distJoint.damping = 1;
					distJoint.frequency = frequency;
				}

				GetNapeSpace().constraints.add(distJoint);
				cons.push(distJoint);
			}
			if (joint.type == EdJoint.Type_Line)
			{
				
				var anchor0:Vec2 = new Vec2(joint.line_pos0.x,joint.line_pos0.y);
				var anchor1:Vec2 = new Vec2(joint.line_pos1.x,joint.line_pos1.y);
				
				var m:Matrix = new Matrix();
				var p:Point = new Point();
				var p1:Point = new Point();

				m.rotate(Utils.DegToRad(joint.line_angDegrees));
				p = new Point(0, 1);
				p = m.transformPoint(p);
				var directionVec:Vec2 = new Vec2(p.x,p.y);
				
				
				var lineJoint:LineJoint = new LineJoint(jb0, jb1, jb0.worldPointToLocal(anchor0), jb1.worldPointToLocal(anchor1), directionVec, joint.line_min, joint.line_max);
				lineJoint.ignore = joinedBodiesIgnoreCollision;
				
				var soft:Boolean = joint.objParameters.GetValueBoolean("dist_soft");
				if (soft)
				{
					var frequency:Number = joint.objParameters.GetValueNumber("dist_soft_frequency");
					lineJoint.stiff = false;
					lineJoint.frequency = frequency;
				}

				GetNapeSpace().constraints.add(lineJoint);
				cons.push(lineJoint);
			}
			
			// add constraints to gameObjects:
			
			AddConstraintsToGameObj(go0,cons);
			AddConstraintsToGameObj(go0a,cons);
			AddConstraintsToGameObj(go1,cons);
			AddConstraintsToGameObj(go1a,cons);
			
			
			var jointGO:GameObj = null;
			var jointGOControlIndex:int = -1;
			var gameObjInitName:String = joint.objParameters.GetValueString("joint_initfunction");
			if (gameObjInitName != null)
			{
				if (gameObjInitName != "" && gameObjInitName != "InitGameObjJoint_Null")
				{
					jointGO = GameObjects.AddObj(0, 0, 0);
					jointGO.edJoint = joint;
					jointGO.id = joint.id;
					jointGO[gameObjInitName](cons);
					jointGOControlIndex = jointGO.controlIndex;
//					Utils.print("joint id " + joint.id);
				}
			}
			
			
			return cons;
		}
		
		static function AddConstraintsToGameObj(go:GameObj, cons:Vector.<Constraint>)
		{
			if (go == null) return;
			if (go.nape_joints == null) go.nape_joints = new Vector.<Constraint>();
			for each(var con:Constraint in cons)
			{
				go.nape_joints.push(con);
			}
		}
		
		
		static function AddShapeToCache(name:String, shape:Shape)
		{
			shapeCache[name] = shape;
		}
		static function IsShapeInCache(name:String):Boolean
		{
			var o:Shape = shapeCache[name];
			if (o != null) return true;
			return false;
		}
		static function GetShapeFromCache(name:String):Shape
		{
			var o:Shape = shapeCache[name];
			return o;
		}
		
	}

}