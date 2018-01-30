package EditorPackage
{
	import EditorPackage.ObjParameters;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EdJoint extends EditableObjectBase
	{
		public static const Type_Rev:int = 0;
		public static const Type_Distance:int = 1;
		public static const Type_Prismatic:int = 2;
		public static const Type_Mouse:int = 3;
		public static const Type_Pulley:int = 4;
		public static const Type_Switch:int = 5;
		public static const Type_LogicLink:int = 6;
		public static const Type_Weld:int = 7;
		public static const Type_Line:int = 8;
		
		
		public var type:int;
		public var name:String;
		public var obj0Name:String;
		public var obj1Name:String;
		
		public var rev_pos:Point;
		public var rev_enableLimit:Boolean;
		public var rev_lowerAngle:Number;
		public var rev_upperAngle:Number;
		public var rev_enableMotor:Boolean;
		public var rev_motorSpeed:Number;
		public var rev_maxMotorTorque:Number;

		public var dist_pos0:Point;
		public var dist_pos1:Point;
		public var dist_min:Number;
		public var dist_max:Number;
		
		public var prism_pos:Point;
		public var prism_pos1:Point;
		public var prism_lowerTranslation:Number;
		public var prism_upperTranslation:Number;
		public var prism_enableLimit:Boolean;
		public var prism_enableMotor:Boolean;
		public var prism_motorSpeed:Number;
		public var prism_maxMotorForce:Number;
		public var prism_axisangle:Number;
		
		public var line_pos0:Point;
		public var line_pos1:Point;
		public var line_min:Number;
		public var line_max:Number;
		public var line_angDegrees:Number;
				
		public function EdJoint() 
		{
			super();
			classType = "joint";
			type = 0;
			name = "";
			obj0Name = "";
			obj1Name = "";
			
			rev_pos = new Point(0, 0);
			rev_enableLimit = false;
			rev_lowerAngle = 0;
			rev_upperAngle = 0;
			rev_enableMotor = false;
			rev_motorSpeed = 0;
			rev_maxMotorTorque = 0;
			
			prism_pos = new Point(0, 0);
			prism_pos1 = new Point(0, 0);
			prism_lowerTranslation = 0;
			prism_upperTranslation = 0;
			prism_enableLimit = false;
			prism_enableMotor = false;
			prism_motorSpeed = 0;
			prism_maxMotorForce = 0;
			prism_axisangle = 0;
			
			dist_pos0 = new Point(0, 0);
			dist_pos1 = new Point(0, 0);
			dist_min = NaN;
			dist_max = NaN;
			
			
		}
		
		public function SetType(_type:int)
		{
			type = _type;
			
			objParameters = new ObjParameters();
			if (type == Type_Distance)
			{			
				objParameters.Add("collide_joined", "false");
				objParameters.Add("dist_soft", "false");
				objParameters.Add("dist_soft_frequency", "0.5");
				objParameters.Add("dist_limit", "0");
				objParameters.Add("joint_initfunction", "InitGameObjJoint_Null");				
			}
			else if (type == Type_Rev)
			{
				objParameters.Add("collide_joined", "false");
				objParameters.Add("rev_soft", "false");
				objParameters.Add("rev_soft_frequency", "0.5");
				objParameters.Add("rev_enablelimit", "false");
				objParameters.Add("rev_lowerangle", "0");
				objParameters.Add("rev_upperangle", "0");				
				objParameters.Add("rev_enablemotor", "false");				
				objParameters.Add("rev_motorrate", "0");				
				objParameters.Add("rev_motorratio", "0");				
				objParameters.Add("rev_motormax", "10000");				
				objParameters.Add("joint_initfunction", "InitGameObjJoint_Null");				
			}
			else if(type == Type_Prismatic)
			{
				objParameters.Add("collide_joined", "false");
				objParameters.Add("prismatic_enablelimit", "false");
				objParameters.Add("prismatic_lowertranslation", "0");				
				objParameters.Add("prismatic_uppertranslation", "0");				
				objParameters.Add("prismatic_enablemotor", "false");				
				objParameters.Add("prismatic_motorspeed", "0");				
				objParameters.Add("prismatic_maxmotorforce", "0");				
				objParameters.Add("joint_initfunction", "InitGameObjJoint_Null");				
			}
			else if(type == Type_Switch)
			{
			}
			else if(type == Type_LogicLink)
			{
			}
			else if(type == Type_Weld)
			{
				objParameters.Add("collide_joined", "false");
				objParameters.Add("weld_soft", "false");
				objParameters.Add("weld_soft_frequency", "0.5");
			}
			
		}
		
		public function Clone():EdJoint
		{
			var j:EdJoint = new EdJoint();
			
			j.classType = classType;
			j.objParameters = objParameters.Clone();
			
			j.type = type;
			j.name = name;
			j.obj0Name = obj0Name;
			j.obj1Name = obj1Name;
			
			j.rev_pos = rev_pos.clone();
			j.rev_enableLimit = rev_enableLimit;
			j.rev_lowerAngle = rev_lowerAngle;
			j.rev_upperAngle = rev_upperAngle;
			j.rev_enableMotor = rev_enableMotor;
			j.rev_motorSpeed = rev_motorSpeed;
			j.rev_maxMotorTorque = rev_maxMotorTorque;
			
			j.prism_pos = prism_pos.clone();
			j.prism_pos1 = prism_pos1.clone();
			j.prism_lowerTranslation = prism_lowerTranslation;
			j.prism_upperTranslation = prism_upperTranslation;
			j.prism_enableLimit = prism_enableLimit;
			j.prism_enableMotor = prism_enableMotor;
			j.prism_motorSpeed = prism_motorSpeed;
			j.prism_maxMotorForce = prism_maxMotorForce;
			j.prism_axisangle = prism_axisangle;
			
			j.dist_pos0 = dist_pos0.clone();
			j.dist_pos1 = dist_pos1.clone();
			
			
			
			return j;
		}
		
		
		public override function RotateBy(cx:Number, cy:Number,da:Number):void
		{
			if (type == EdJoint.Type_Rev) 
			{
				
				var m:Matrix = new Matrix();
				m.rotate(da);
				var p:Point = new Point(rev_pos.x - cx, rev_pos.y - cy);
				p = m.transformPoint(p);
				rev_pos.x = cx + p.x;
				rev_pos.y = cy + p.y;
				
			}
		}
		
		
		public function UpdateLinkages()
		{
			var obj:EditableObjectBase;
			if (type == EdJoint.Type_Rev) 
			{
				obj = PhysEditor.GetAnyObjectByPreviousId(obj0Name);
				if (obj != null) obj0Name = obj.id;
				obj = PhysEditor.GetAnyObjectByPreviousId(obj1Name);
				if (obj != null) obj1Name = obj.id;
			}
			else if (type == EdJoint.Type_Distance)
			{
				obj = PhysEditor.GetAnyObjectByPreviousId(obj0Name);
				if (obj != null) obj0Name = obj.id;
				obj = PhysEditor.GetAnyObjectByPreviousId(obj1Name);
				if (obj != null) obj1Name = obj.id;
			}
			else if (type == EdJoint.Type_Prismatic)
			{
				obj = PhysEditor.GetAnyObjectByPreviousId(obj0Name);
				if (obj != null) obj0Name = obj.id;
				obj = PhysEditor.GetAnyObjectByPreviousId(obj1Name);
				if (obj != null) obj1Name = obj.id;
			}
			else if (type == EdJoint.Type_Switch)
			{
				obj = PhysEditor.GetAnyObjectByPreviousId(obj0Name);
				if (obj != null) obj0Name = obj.id;
				obj = PhysEditor.GetAnyObjectByPreviousId(obj1Name);
				if (obj != null) obj1Name = obj.id;
			}
			else if (type == EdJoint.Type_LogicLink)
			{
				obj = PhysEditor.GetAnyObjectByPreviousId(obj0Name);
				if (obj != null) obj0Name = obj.id;
				obj = PhysEditor.GetAnyObjectByPreviousId(obj1Name);
				if (obj != null) obj1Name = obj.id;
			}
			else if (type == EdJoint.Type_Weld)
			{
				obj = PhysEditor.GetAnyObjectByPreviousId(obj0Name);
				if (obj != null) obj0Name = obj.id;
				obj = PhysEditor.GetAnyObjectByPreviousId(obj1Name);
				if (obj != null) obj1Name = obj.id;
			}
			return false;
			
		}
		public override function HitTestRectangle(r:Rectangle):Boolean
		{
			if (type == EdJoint.Type_Rev) 
			{
				if (r.contains(rev_pos.x, rev_pos.y)) return true;
				if (obj0Name != "")
				{
					var inst:EdObj = PhysEditor.GetInstanceById(obj0Name);
					if (inst != null)
					{
						if (r.contains(inst.x, inst.y)) return true;
					}
				}
				if (obj1Name != "")
				{
					var inst:EdObj = PhysEditor.GetInstanceById(obj1Name);
					if (inst != null)
					{
						if (r.contains(inst.x, inst.y)) return true;
					}
				}
			}
			else if (type == EdJoint.Type_Distance)
			{
				if (r.contains(dist_pos0.x, dist_pos0.y)) return true;
				if (r.contains(dist_pos1.x, dist_pos1.y)) return true;
			}
			else if (type == EdJoint.Type_Prismatic)
			{
				if (r.contains(prism_pos.x, prism_pos.y)) return true;
				if (r.contains(prism_pos1.x, prism_pos1.y)) return true;
			}
			else if (type == EdJoint.Type_Switch)
			{
				if (obj0Name != "")
				{
					var inst:EdObj = PhysEditor.GetInstanceById(obj0Name);
					if (inst != null)
					{
						if (r.contains(inst.x, inst.y)) return true;
					}
				}
				if (obj1Name != "")
				{
					var inst:EdObj = PhysEditor.GetInstanceById(obj1Name);
					if (inst != null)
					{
						if (r.contains(inst.x, inst.y)) return true;
					}
				}
			}
			else if (type == EdJoint.Type_LogicLink)
			{
				
				if (obj0Name != "" && obj1Name != "")
				{
					var instbase:EditableObjectBase = PhysEditor.GetAnyObjectById(obj0Name);
					var instbase1:EditableObjectBase = PhysEditor.GetAnyObjectById(obj1Name);
					if (instbase != null && instbase1 != null)
					{
						if (r.contains(instbase.GetCentreHandle().x, instbase.GetCentreHandle().y))
						{
							return true;
						}
						if (r.contains(instbase1.GetCentreHandle().x, instbase1.GetCentreHandle().y))
						{
							return true;
						}

					}
				}
			}
			else if (type == EdJoint.Type_Weld)
			{
				if (obj0Name != "")
				{
					var inst:EdObj = PhysEditor.GetInstanceById(obj0Name);
					if (inst != null)
					{
						if (r.contains(inst.x, inst.y)) return true;
					}
				}
				if (obj1Name != "")
				{
					var inst:EdObj = PhysEditor.GetInstanceById(obj1Name);
					if (inst != null)
					{
						if (r.contains(inst.x, inst.y)) return true;
					}
				}
			}
			return false;
		}
		
		
		public override function HitTest(x:int, y:int):Boolean
		{
			var zp:Point;
			var zp1:Point;
			
			if (type == EdJoint.Type_Rev) 
			{
				var d:Number = Utils.DistBetweenPoints(x, y, rev_pos.x, rev_pos.y);
				if (d < 10)
				{
					return true;
				}
				if (obj0Name != "")
				{
					var inst:EdObj = PhysEditor.GetInstanceById(obj0Name);
					if (inst != null)
					{
						var hit:Boolean = CollideWithLine(rev_pos.x, rev_pos.y, inst.x, inst.y, x, y, 2);
						if (hit) return true;
					}
				}
				if (obj1Name != "")
				{
					var inst:EdObj = PhysEditor.GetInstanceById(obj1Name);
					if (inst != null)
					{
						var hit:Boolean = CollideWithLine(rev_pos.x, rev_pos.y, inst.x, inst.y, x, y, 2);
						if (hit) return true;
					}
				}
				
				
			}
			if (type == EdJoint.Type_Distance)
			{
				var d:Number = Utils.DistBetweenPoints(x, y, dist_pos0.x, dist_pos0.y);
				if (d < 10)
				{
					return true;
				}
				var d:Number = Utils.DistBetweenPoints(x, y, dist_pos1.x, dist_pos1.y);
				if (d < 10)
				{
					return true;
				}
			
				return CollideWithLine(dist_pos0.x, dist_pos0.y, dist_pos1.x, dist_pos1.y, x, y, 2);

			}
			if (type == EdJoint.Type_Prismatic)
			{
				return CollideWithLine(prism_pos.x, prism_pos.y, prism_pos1.x, prism_pos1.y, x, y, 2);
			}
			
			if (type == EdJoint.Type_Switch) 
			{
				if (obj0Name != "" && obj1Name != "")
				{
					var inst:EdObj = PhysEditor.GetInstanceById(obj0Name);
					var inst1:EdObj = PhysEditor.GetInstanceById(obj1Name);
					if (inst != null && inst1 != null)
					{
						var hit:Boolean = CollideWithLine(inst.x, inst.y, inst1.x, inst1.y, x, y, 2);
						if (hit) return true;
					}
				}
				
			}
			if (type == EdJoint.Type_LogicLink) 
			{
				if (obj0Name != "" && obj1Name != "")
				{
					var instbase:EditableObjectBase = PhysEditor.GetAnyObjectById(obj0Name);
					var instbase1:EditableObjectBase = PhysEditor.GetAnyObjectById(obj1Name);
					if (instbase != null && instbase1 != null)
					{
						zp= (instbase.GetCentreHandle());
						zp1= (instbase1.GetCentreHandle());
						var hit:Boolean = CollideWithLine(zp.x, zp.y, zp1.x, zp1.y, x, y, 2);
						if (hit) return true;
					}
				}
				
				
			}
			if (type == EdJoint.Type_Weld) 
			{
				if (obj0Name != "" && obj1Name != "")
				{
					var inst:EdObj = PhysEditor.GetInstanceById(obj0Name);
					var inst1:EdObj = PhysEditor.GetInstanceById(obj1Name);
					if (inst != null && inst1 != null)
					{
						var hit:Boolean = CollideWithLine(inst.x, inst.y, inst1.x, inst1.y, x, y, 2);
						if (hit) return true;
					}
				}
				
				
			}
			
			return false;
		}
		
		function CollideWithLine(x0:Number,y0:Number,x1:Number,y1:Number,x:Number,y:Number,dist:Number):Boolean
		{
			var t:Number = Collision.ClosestPointOnLine(x0,y0,x1,y1, x, y);
			if (t >= 0.0 && t <= 1)
			{
				if (Utils.DistBetweenPoints(x, y, Collision.closestX, Collision.closestY) <= dist)
				{
					return true;
				}
			}
			return false;
		}
		
		
		public override function Render():void
		{
			if (type == EdJoint.Type_Rev) RenderRevJoint(1);
			if (type == EdJoint.Type_Distance) RenderDistanceJoint(1);
			if (type == EdJoint.Type_Prismatic) RenderPrismaticJoint(1);
			if (type == EdJoint.Type_Switch) RenderSwitchJoint(1);
			if (type == EdJoint.Type_LogicLink) RenderLogicLinkJoint(1);
			if (type == EdJoint.Type_Weld) RenderWeldJoint(1);
			
		}
		
		public override function RenderHighlighted(highlightType:int):void
		{
			PhysEditor.linesScreen.graphics.clear();

			var alpha:Number = 0.1;
			var radAdd:int = 0;
			if (highlightType == HIGHLIGHT_HOVER)
			{
				alpha = 1;
				radAdd = 3;
			}
			else if (highlightType == HIGHLIGHT_SELECTED)
			{
				alpha = 1;
				radAdd = 1;
			}
			
			if (type == EdJoint.Type_Rev) RenderRevJoint(alpha,radAdd);
			if (type == EdJoint.Type_Distance) RenderDistanceJoint(alpha,radAdd);
			if (type == EdJoint.Type_Prismatic) RenderPrismaticJoint(alpha, radAdd);
			if (type == EdJoint.Type_Switch) RenderSwitchJoint(alpha, radAdd);
			if (type == EdJoint.Type_LogicLink) RenderLogicLinkJoint(alpha, radAdd);
			if (type == EdJoint.Type_Weld) RenderWeldJoint(alpha, radAdd);
			
			PhysEditor.screenBD.draw(PhysEditor.linesScreen);
		}
		
		
		function RenderRevJoint(alpha:Number, radAdd:int = 0 )
		{
			var zoom:Number = PhysEditor.zoom;
			
			var zp:Point;
			var zp1:Point;
			
			zp = PhysEditor.GetMapPos(rev_pos.x, rev_pos.y);			
			PhysEditor.FillCircle(zp.x, zp.y, 6+radAdd, 0xff0000,1,alpha);
			PhysEditor.RenderCircle(zp.x, zp.y, 6+radAdd, 0,2,alpha);
			
			if (obj0Name != "")
			{
				var inst:EditableObjectBase = PhysEditor.GetAnyObjectById(obj0Name);
				if (inst != null)
				{
					zp1 = PhysEditor.GetMapPosPoint(inst.GetCentreHandle());
					
					PhysEditor.RenderLine(zp.x, zp.y, zp1.x,zp1.y,0xff0000,2+radAdd,alpha);
					PhysEditor.FillCircle(zp1.x,zp1.y, 3+radAdd, 0xffffff,1,alpha);

				}
			}
			if (obj1Name != "")
			{
				var inst:EditableObjectBase = PhysEditor.GetAnyObjectById(obj1Name);
				if (inst != null)
				{
					zp1 = PhysEditor.GetMapPosPoint(inst.GetCentreHandle());
					zp = PhysEditor.GetMapPos(rev_pos.x, rev_pos.y);
					
					PhysEditor.RenderLine(zp.x, zp.y, zp1.x,zp1.y,0xff0000,2+radAdd,alpha);
					PhysEditor.FillCircle(zp1.x,zp1.y, 3+radAdd, 0xffffff,1,alpha);
				}
			}
		}
		
		function RenderPrismaticJoint(alpha:Number, radAdd:int = 0)
		{
			var zp:Point;
			var zp1:Point;
			zp = PhysEditor.GetMapPos(prism_pos.x, prism_pos.y);
			zp1 = PhysEditor.GetMapPos(prism_pos1.x, prism_pos1.y);
			
			PhysEditor.RenderLine(zp.x, zp.y, zp1.x,zp1.y,0xffffff,2+radAdd,alpha);
		}
		function RenderDistanceJoint(alpha:Number, radAdd:int = 0)
		{
			var zp:Point;
			var zp1:Point;
			
			zp = PhysEditor.GetMapPos(dist_pos0.x, dist_pos0.y);
			zp1 = PhysEditor.GetMapPos(dist_pos1.x, dist_pos1.y);
			
			PhysEditor.RenderLine(zp.x, zp.y, zp1.x,zp1.y,0x00ffff,2+radAdd,alpha);
			PhysEditor.FillCircle(zp.x,zp.y, 5+radAdd, 0x00cccc,alpha);
			PhysEditor.FillCircle(zp1.x,zp1.y, 5+radAdd, 0x00cccc,alpha);
			
		}
		
		function RenderSwitchJoint(alpha:Number, radAdd:int = 0 )
		{
			var zoom:Number = PhysEditor.zoom;
			
			var zp:Point;
			var zp1:Point;
			
			if (obj0Name != "" && obj1Name != "")
			{
				var inst:EditableObjectBase = PhysEditor.GetAnyObjectById(obj0Name);
				var inst1:EditableObjectBase = PhysEditor.GetAnyObjectById(obj1Name);
				if (inst != null && inst1 != null)
				{
					zp= PhysEditor.GetMapPosPoint(inst.GetCentreHandle());
					zp1= PhysEditor.GetMapPosPoint(inst1.GetCentreHandle());
					PhysEditor.FillCircle(zp.x,zp.y, 3+radAdd, 0xff00ff,1,alpha);
					PhysEditor.FillCircle(zp1.x,zp1.y, 3+radAdd, 0xff00ff,1,alpha);
					PhysEditor.RenderLine(zp.x, zp.y, zp1.x,zp1.y,0xff00ff,2+radAdd,alpha);

				}
			}
		}
		
		function RenderLogicLinkJoint(alpha:Number, radAdd:int = 0 )
		{
			var zoom:Number = PhysEditor.zoom;
			
			var zp:Point;
			var zp1:Point;
			
			if (obj0Name != "" && obj1Name != "")
			{
				var inst:EditableObjectBase = PhysEditor.GetAnyObjectById(obj0Name);
				var inst1:EditableObjectBase = PhysEditor.GetAnyObjectById(obj1Name);
				if (inst != null && inst1 != null)
				{
					zp= PhysEditor.GetMapPosPoint(inst.GetCentreHandle());
					zp1= PhysEditor.GetMapPosPoint(inst1.GetCentreHandle());
					PhysEditor.FillCircle(zp.x,zp.y, 3+radAdd, 0xff00ff,1,alpha);
					PhysEditor.FillCircle(zp1.x,zp1.y, 3+radAdd, 0xff00ff,1,alpha);
					PhysEditor.RenderLine(zp.x, zp.y, zp1.x,zp1.y,0xff00ff,2+radAdd,alpha);

				}
			}
		}
		
		function RenderWeldJoint(alpha:Number, radAdd:int = 0 )
		{
			var zoom:Number = PhysEditor.zoom;
			
			var zp:Point;
			var zp1:Point;
			
			if (obj0Name != "" && obj1Name != "")
			{
				var inst:EditableObjectBase = PhysEditor.GetAnyObjectById(obj0Name);
				var inst1:EditableObjectBase = PhysEditor.GetAnyObjectById(obj1Name);
				if (inst != null && inst1 != null)
				{
					zp= PhysEditor.GetMapPosPoint(inst.GetCentreHandle());
					zp1= PhysEditor.GetMapPosPoint(inst1.GetCentreHandle());
					PhysEditor.FillCircle(zp.x,zp.y, 3+radAdd, 0xff00ff,1,alpha);
					PhysEditor.FillCircle(zp1.x,zp1.y, 3+radAdd, 0xff00ff,1,alpha);
					PhysEditor.RenderLine(zp.x, zp.y, zp1.x,zp1.y,0xff00ff,2+radAdd,alpha);

				}
			}
		}
		
		public override function GetEditorHoverName():String
		{
			var s:String = "";
			if (type == Type_Rev) s = "rev";
			if (type == Type_Distance) s = "dist";
			if (type == Type_Prismatic) s = "prims";
			if (type == Type_Mouse) s = "mouse";
			if (type == Type_Pulley) s = "pulley";
			if (type == Type_Switch) s = "switch";
			if (type == Type_LogicLink) s = "logic";
			if (type == Type_Weld) s = "weld";
		
			return "JNT: " + s;
		}
		
		public function GetExportXMLString():String
		{
			var s:String = "";
			if (type == EdJoint.Type_Rev)
			{
				s = '\t\t<joint type="rev"' +
						' id="' + id + '"' +
						' objid0="' + obj0Name + '"' +
						' objid1="' + obj1Name + '"' +
						' x="' + rev_pos.x + '"' +
						' y="' + rev_pos.y + '"' +
						' params="' + objParameters.ToString() + '"' +
						' />';

			}
			if (type == EdJoint.Type_Distance)
			{
				s = '\t\t<joint type="dist"' +
						' id="' + id + '"' +
						' objid0="' + obj0Name + '"' +
						' objid1="' + obj1Name + '"' +
						' x0="' + dist_pos0.x + '"' +
						' y0="' + dist_pos0.y + '"' +
						' x1="' + dist_pos1.x + '"' +
						' y1="' + dist_pos1.y + '"' +
						' params="' + objParameters.ToString() + '"' +
						' />';

			}
			if (type == EdJoint.Type_Prismatic)
			{
				s = '\t\t<joint type="prism"' +
						' id="' + id + '"' +
						' objid0="' + obj0Name + '"' +
						' objid1="' + obj1Name + '"' +
						' x0="' + prism_pos.x + '"' +
						' y0="' + prism_pos.y + '"' +
						' x1="' + prism_pos1.x + '"' +
						' y1="' + prism_pos1.y + '"' +
						' params="' + objParameters.ToString() + '"' +
						' />';

			}
			if (type == EdJoint.Type_Switch)
			{
				s = '\t\t<joint type="switch"' +
						' id="' + id + '"' +
						' objid0="' + obj0Name + '"' +
						' objid1="' + obj1Name + '"' +
						' params="' + objParameters.ToString() + '"' +
						' />';

			}
			if (type == EdJoint.Type_LogicLink)
			{
				s = '\t\t<joint type="logic"' +
						' id="' + id + '"' +
						' objid0="' + obj0Name + '"' +
						' objid1="' + obj1Name + '"' +
						' params="' + objParameters.ToString() + '"' +
						' />';

			}
			if (type == EdJoint.Type_Weld)
			{
				s = '\t\t<joint type="weld"' +
						' id="' + id + '"' +
						' objid0="' + obj0Name + '"' +
						' objid1="' + obj1Name + '"' +
						' params="' + objParameters.ToString() + '"' +
						' />';

			}
			return s;
		}

		public override function MoveBy(x:Number, y:Number):void
		{
			var v:Point = new Point(x, y);
			prism_pos = prism_pos.add(v);
			prism_pos1 = prism_pos1.add(v);
			rev_pos = rev_pos.add(v);
			dist_pos0 = dist_pos0.add(v);
			dist_pos1 = dist_pos1.add(v);
		}
		
		public override function Duplicate():EditableObjectBase
		{
			var dup:EditableObjectBase = Clone() as EditableObjectBase;
			CopyBaseToDuplicate(dup);
			return dup;
		}

		public override function GetCentreHandle():Point
		{
			if (type == Type_Distance)
			{
				return new Point( (dist_pos0.x + dist_pos1.x) / 2, (dist_pos0.y + dist_pos1.y) / 2);
			}
			else if (type == Type_Rev)
			{
				return new Point(rev_pos.x, rev_pos.y);
			}
			return new Point(0, 0);
		}
		
	}
	
}