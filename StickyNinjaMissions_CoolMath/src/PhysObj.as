package
{
	import EditorPackage.EdJoint;
	import EditorPackage.EdObj;
	import EditorPackage.EdObjMarker;
	import EditorPackage.EdObjMarkers;
	import EditorPackage.GameLayers;
	import EditorPackage.ObjParameters;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PhysObj 
	{
		public var bodies:Array;
		public var joints:Array;
		public var graphics:Array;
		public var instanceParams:Array;
		public var instanceParamsDefaults:Array;
		
		public var markers:EdObjMarkers;
		
		public var name:String;
		public var displayInLibrary:Boolean;
		public var editorRenderFunctionName:String;
		public var initFunctionName:String;
		public var secondaryInitFunctionName:String;
		public var initFunctionParameters:String;
		public var libraryClass:String;
		public var hasPhysics:Boolean;
		public var staticGameObj:Boolean;
		public var snapToFloor:Boolean;
		public var wakeFunctionName:String;

		
		public var objParameters:ObjParameters;
		
		
		public function PhysObj() 
		{
			objParameters = new ObjParameters();
			objParameters.Add("po_name", null);
			objParameters.Add("po_libclass", null);
			objParameters.Add("po_hasphysics", null);
			objParameters.Add("po_staticobj", null);
			objParameters.Add("po_initfunction", null);
			markers = new EdObjMarkers();
		}
		

		public function GetInstanceParamDefault(name:String):String
		{
			for (var i:int = 0; i < instanceParams.length; i++)
			{
				if(instanceParams[i] == name)
				return instanceParamsDefaults[i];
			}
			return "";
		}
		
		public function GetInstanceParamsAsString():String
		{
			var s:String = "";
			for (var i:int = 0; i < instanceParams.length; i++)
			{
				s += instanceParams[i];
				s += "=";
				s += instanceParamsDefaults[i];
				if (i != instanceParams.length - 1) s += ",";
				
			}
			return s;
		}
		
		function GetGraphic(gx:XML):PhysObj_Graphic
		{
			var graphic:PhysObj_Graphic = new PhysObj_Graphic();
			graphic.graphicName = gx.@clip;
			graphic.frame = XmlHelper.GetAttrInt(gx.@frame) - 1;
			graphic.offset = PointFromString(gx.@pos);
			
			graphic.rot = Number(gx.@rot);
			graphic.Calculate();
			return graphic;
		}
		
		function GetSfx(sx:XML)
		{
		}
		
		
//-- Game Specific Stuff END		
		
		public function ToXML():String
		{
			var s:String = "";
			var t:String = "\t";
			
			s += '<physobj name ="' + name + '" ';
			s += 'inlibrary="' + displayInLibrary + '" ';
			s += 'initfunction="' + initFunctionName + '" ';
			s += 'initparams="' + initFunctionParameters + '" ';
			s += 'initfunction2="' + secondaryInitFunctionName + '" ';
			s += 'editorrender="' + editorRenderFunctionName + '" ';
			s += 'libclass="' + libraryClass + '" ';
			s += 'hasphysics="' + hasPhysics + '" ';
			s += 'staticobj="' + staticGameObj + '" ';
			s += 'snaptofloor="' + snapToFloor + '" ';
			s += 'wakefunction="' + wakeFunctionName + '" >';
			
			s += '\n';
			
			s += markers.ToXml();			
			
//		<parameter name="game_layer" def="Scenery" />
			for (var i:int = 0; i < instanceParams.length; i++)
			{
				var param:String = instanceParams[i];
				var paramDef:String = instanceParamsDefaults[i];
				
				s += t+'<parameter name="' + param + '" def="' + paramDef + '" />';
				s += '\n';				
			}
			
//		<graphic clip = "bomb_squad" frame = "1" pos = "0,0" rot="0" zoffset="0" />					
			
			for each(var g:PhysObj_Graphic in graphics)
			{
				s += t+g.ToXML();
			}
		
//		<body name="fix" pos="0,0" fixed="false" sensor="false">
//			<graphic clip = "rolling_rock" frame = "1" pos = "0,0" rot="0" zoffset="0" />					
//			<shape type="circle" pos="0,0" name="" col="8,15" sensor="0,0" radius="37" material="heavy" />
//		</body>
			
			for each(var b:PhysObj_Body in bodies)
			{
				s += t+b.ToXML();
			}
			

			
			s += '</physobj>';
			s += '\n';				
			return s;

			
		}


		public function FromXml(x:XML):void
		{
			var i:int;
			var j:int;
			var k:int;
			
			bodies = new Array();
			joints = new Array();
			graphics = new Array();
			instanceParams = new Array();
			instanceParamsDefaults = new Array();
			
			var graphic:PhysObj_Graphic;
			
			name = x.@name;
			displayInLibrary = XmlHelper.GetAttrBoolean(x.@inlibrary, false);
			initFunctionName = XmlHelper.GetAttrString(x.@initfunction, "");
			secondaryInitFunctionName = XmlHelper.GetAttrString(x.@initfunction2, "");
			initFunctionParameters = XmlHelper.GetAttrString(x.@initparams, "");
			editorRenderFunctionName = XmlHelper.GetAttrString(x.@editorrender, null);
			libraryClass = XmlHelper.GetAttrString(x.@libclass, "");
			hasPhysics = XmlHelper.GetAttrBoolean(x.@hasphysics, true);
			
			staticGameObj = XmlHelper.GetAttrBoolean(x.@staticobj, false);
			
			snapToFloor = XmlHelper.GetAttrBoolean(x.@snaptofloor, false);
			wakeFunctionName = XmlHelper.GetAttrString(x.@wakefunction, "");
			
			GetSfx(x.sfx[0]);
			
			markers = new EdObjMarkers();
			markers.FromXML(x);
			
			for (i = 0; i < x.parameter.length(); i++)
			{
				var px:XML = x.parameter[i];
				AddParamIfNotExist(XmlHelper.GetAttrString(px.@name, ""), XmlHelper.GetAttrString(px.@def, ""));
			}

			
			for (i = 0; i < x.graphic.length(); i++)
			{
				var gx:XML = x.graphic[j];
				graphics.push(GetGraphic(gx));
			}
			
			
			for (i = 0; i < x.body.length(); i++)
			{
				var typename:String;
				var bx:XML = x.body[i];
				var body:PhysObj_Body = new PhysObj_Body();
				body.name = bx.@name;
				body.fixed = BooleanFromString(bx.@fixed);
				
				body.pos = PointFromString(bx.@pos);
				
//				body.linearDamping = 0;	// XmlHelper.GetAttrNumber(bx.@lineardamping, body.linearDamping);
//				body.angularDamping = 0;	// XmlHelper.GetAttrNumber(bx.@angulardamping, body.angularDamping);
				
				
				// Shapes:
				for (j = 0; j < bx.shape.length(); j++)
				{
					var sx:XML = bx.shape[j];
					var shape:PhysObj_Shape = new PhysObj_Shape();
					shape.name = sx.@name;
					typename = sx.@type;
					var colpt:Point = PointFromString(sx.@col,"0,0");
					var sensorpt:Point = PointFromString(sx.@sensor,"0,0");
					shape.collisionCategory = XmlHelper.GetAttrInt(colpt.x);
					shape.collisionMask = XmlHelper.GetAttrInt(colpt.y);
					shape.sensorCategory = XmlHelper.GetAttrInt(sensorpt.x);
					shape.sensorMask = XmlHelper.GetAttrInt(sensorpt.y);
					shape.shiftCOM = XmlHelper.GetAttrBoolean(sx.@shiftcom, false);
		
					
					shape.materialName = XmlHelper.GetAttrString(sx.@material, "");
					
					var gs:Number = 1;	// GameVars.globalScale;
					
					if (typename == "circle")
					{
						shape.type = PhysObj_Shape.Type_Circle;
						shape.circle_pos = PointFromString(sx.@pos);
						shape.circle_radius = XmlHelper.GetAttrNumber(sx.@radius);
						
						if (true)
						{
							shape.circle_pos.x *= gs;
							shape.circle_pos.y *= gs;
							shape.circle_radius *= gs;
						}
						
					}
					else if (typename == "poly")
					{
						shape.type = PhysObj_Shape.Type_Poly;
						shape.poly_points = PointArrayFromString(sx.@vertices);
						
						if (true)
						{
							for each(var p:Point in shape.poly_points)
							{
								p.x *= gs;
								p.y *= gs;
							}
						}
						
						shape.poly_rot = Utils.DegToRad(XmlHelper.GetAttrNumber(sx.@rot));
					}
					shape.Caclulate();
					body.shapes.push(shape);
				}
				bodies.push(body);
				
			}
			
			AddParamIfNotExist("editor_layer", "1");
			AddParamIfNotExist("game_layer", "true");
			
			

			
			if (bodies[0] != null)
			{
				if (bodies[0].fixed) 
				{
					AddParamIfNotExist("fixed", "true");
				}
				else
				{
					AddParamIfNotExist("fixed", "false");
				}
			}

			/*
			//Joints:
			for (i = 0; i < x.joint.length(); i++)
			{
				var jx:XML = x.joint[i];
				var joint:EdJoint = new EdJoint();
				joint.name = jx.@name;
				joint.obj0Name = jx.@body0;
				joint.obj1Name = jx.@body1;
				
				typename = jx.@type;
				
				if (typename == "rev")
				{
					joint.type = EdJoint.Type_Rev;
					joint.rev_pos = PointFromString(jx.@pos);					
					joint.rev_enableLimit = BooleanFromString(jx.@enablelimit);
					joint.rev_lowerAngle = Utils.DegToRad(XmlHelper.GetAttrNumber(jx.@lowerangle));
					joint.rev_upperAngle = Utils.DegToRad(XmlHelper.GetAttrNumber(jx.@upperangle));
					joint.rev_enableMotor = BooleanFromString(jx.@enablemotor);
					joint.rev_motorSpeed = Number(jx.@motorspeed);
					joint.rev_maxMotorTorque = Number(jx.@maxmotortorque);
				}
				else if (typename == "distance")
				{
					joint.type = EdJoint.Type_Distance;
					joint.dist_pos0 = PointFromString(jx.@pos);					
					joint.dist_pos1 = PointFromString(jx.@pos1);										
				}
				else if (typename == "mouse")
				{
					joint.type = EdJoint.Type_Mouse;
				}
				else if (typename == "prismatic")
				{
					joint.type = EdJoint.Type_Prismatic;
					joint.prism_pos = PointFromString(jx.@pos);					
					joint.prism_enableLimit = BooleanFromString(jx.@enablelimit);
					joint.prism_lowerTranslation = Number(jx.@lowertranslation);
					joint.prism_upperTranslation = Number(jx.@uppertranslation);
					joint.prism_enableMotor = BooleanFromString(jx.@enablemotor);
					joint.prism_axisangle = Number(jx.@axisangle) - Number(90);
					joint.prism_motorSpeed = Number(jx.@motorspeed);
					joint.prism_maxMotorForce = Number(jx.@maxmotorforce);
				}
				joints.push(joint);
			}
			*/
			
		}
		
		function AddParamIfNotExist(a:String, b:String)
		{
			var addit:Boolean = true;
			var i:int = 0;
			for each(var s:String in instanceParams)
			{
				if (s == a)
				{
					addit = false;
				}
				i++;
			}
			if (addit)
			{
				instanceParams.push(a);
				instanceParamsDefaults.push(b);
			}			
			
		}
		
		// returns a point from a string in the form "x,y"
		function PointFromString(s:String,defaultValue:String = "0,0"):Point
		{
			if (s == undefined || s=="")
			{
				var a:Array = defaultValue.split(",");
				return new Point(a[0], a[1]);
			}

			var a:Array = s.split(",");
			
			var p:Point = new Point(0, 0);
			if (a.length != 2)
			{
				trace("PointfromString. Error, numpoints=" + a.length+"  "+s);
				return p;
			}
			
			p.x = Number(a[0]);
			p.y = Number(a[1]);
			return p;
		}

		function PointArrayFromString(s:String):Array
		{
			var pointArray:Array = new Array();
			
			var a:Array = s.split(",");
			
			if (a.length < 2 || (a.length%2)==1)
			{
				trace("PointArrayFromString. Error, numpoints=" + a.length+" , string= "+s);
				return pointArray;
			}
			
			var i:int;
			var num:int = a.length / 2;
			for (i = 0; i < num; i++)
			{
				var p:Point = new Point(0, 0);
				p.x = Number(a[(i*2)+0]);
				p.y = Number(a[(i * 2) + 1]);
				pointArray.push(p);
			}
			
			return pointArray;
		}
		
		function BooleanFromString(s:String):Boolean
		{
			var retval:Boolean = false;
			
			s = s.toUpperCase();
			
			if (s == "1") retval = true;
			if (s == "TRUE") retval = true;
			return retval;
		}
		

		public function JointIndexFromName(name:String):int
		{
			for (var i:int = 0; i < joints.length; i++)
			{
				var j:EdJoint = joints[i];
				if (j.name == name) return i;
			}
			trace("ERROR PhysObj JointIndexFromName " + name);
			return 0;

		}
		public function BodyIndexFromName(name:String):int
		{
			for (var i:int = 0; i < bodies.length; i++)
			{
				var b:PhysObj_Body = bodies[i];
				if (b.name == name) return i;
			}
			trace("ERROR PhysObj BodyIndexFromName " + name);
			return 0;

		}
		
		public function BodyFromName(name:String):PhysObj_Body
		{
			for (var i:int = 0; i < bodies.length; i++)
			{
				var b:PhysObj_Body = bodies[i];
				if (b.name == name) return b;
			}
			trace("ERROR PhysObj BodyFromName " + name);
			return null;

		}
		
		static var renderPoint:Point = new Point();
		static var renderMatrix:Matrix = new Matrix();
		static var p0:Point = new Point();
		static var p1:Point = new Point();

		public static function RenderMarkerAt(physObj:PhysObj, x:Number, y:Number, _rotDeg:Number, _scale:Number, bd:BitmapData, g:Graphics = null, destRect:Rectangle = null, maxDestRect:Rectangle = null, xflip:Boolean = false, markerIndex:int = 0)
		{
			var colorTransform:ColorTransform = null;
			var renderCollision:Boolean = false;
			var scale:Number = _scale;
			var xp:Number;
			var yp:Number;
						
			var a:Matrix;
			xp = x;
			yp = y;
			
			var body:PhysObj_Body;
			var graphic:PhysObj_Graphic;
			var graphics:Array = new Array();
			
			for each(graphic in physObj.graphics)
			{
				var o:Object = new Object();
				o.graphic = graphic;
				o.x = 0;
				o.y = 0;
				graphics.push(o);					
			}
			
			
		
			for each(var o:Object in graphics)
			{
				graphic = o.graphic;
				var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName(graphic.graphicName);
				if (dobj != null)
				{
					var gr_x:Number = o.x;
					var gr_y:Number = o.y;
					
					if (dobj.GetBitmapData(graphic.frame) != null)
					{
						if (destRect != null)
						{
						}
						else if (maxDestRect != null)
						{
							var w:Number = dobj.GetWidth(graphic.frame);
							var h:Number = dobj.GetHeight(graphic.frame);
							
							var scaleW:Number = maxDestRect.width/w;
							var scaleH:Number = maxDestRect.height / h;
							var scl:Number = scaleW;
							if (scaleH < scaleW) scl = scaleH;
							
							if (scl > 1) scl = 1;
							
							xp -= ((w*scl) / 2);
							yp -= ((h*scl) / 2);

							xp += gr_x;
							yp += gr_y;
							
							var bitmapData:BitmapData =dobj.GetBitmapData(graphic.frame);

							renderMatrix.identity();
							renderMatrix.scale(scl, scl);
							if (xflip)
							{
								renderMatrix.scale(-1, 1);
							}
							renderMatrix.translate(xp, yp);
							
							var marker:EdObjMarker = physObj.markers.Get(markerIndex);
							renderMatrix.translate(marker.xpos,marker.ypos);

							g.beginFill(0xffffff, 1);
							g.drawCircle(renderMatrix.tx, renderMatrix.ty, marker.radius);
							g.endFill();
						}
						else
						{
							var rot:Number = Utils.DegToRad(_rotDeg + graphic.rot);
											
							renderPoint.x = graphic.offset.x;
							renderPoint.y = graphic.offset.y;
							
							renderPoint.x += gr_x;
							renderPoint.y += gr_y;

							renderMatrix.identity();						
							renderMatrix.rotate(Utils.DegToRad(_rotDeg));
							//renderMatrix.scale(scale,scale);
							
							var marker:EdObjMarker = physObj.markers.Get(markerIndex);
							renderMatrix.translate(marker.xpos, marker.ypos);
							
							renderPoint = renderMatrix.transformPoint(renderPoint);

							xp = (x) +renderPoint.x;
							yp = (y) + renderPoint.y;
							
							
							Utils.RenderCircle(bd, xp, yp, marker.radius, 0xffffffff);
							Utils.RenderCircle(bd, xp, yp, marker.radius+1, 0xffff0000);
							Utils.RenderCircle(bd, xp, yp, 3, 0xffffffff);
							Utils.RenderCircle(bd, xp, yp, 4, 0xffff0000);
							
							g.beginFill(0xffffff, 1);
							g.drawCircle(xp,yp,marker.radius);
							g.endFill();
							
						}

					}
					else
					{
						trace("missing obj");
					}
				}
			}
		}
		
		
		public static function RenderAt(physObj:PhysObj, x:Number, y:Number, _rotDeg:Number, _scale:Number, bd:BitmapData, g:Graphics = null, _collision:Boolean = false, destRect:Rectangle = null, maxDestRect:Rectangle = null, colorTransform:ColorTransform = null ,xflip:Boolean=false)
		{
			var renderCollision:Boolean = _collision;
			var scale:Number = _scale;
			var xp:Number;
			var yp:Number;
						
			var a:Matrix;
			xp = x;
			yp = y;
			
			var body:PhysObj_Body;
			var graphic:PhysObj_Graphic;
			var graphics:Array = new Array();
			
			for each(graphic in physObj.graphics)
			{
				var o:Object = new Object();
				o.graphic = graphic;
				o.x = 0;
				o.y = 0;
				graphics.push(o);					
			}
			
			
		
			for each(var o:Object in graphics)
			{
				graphic = o.graphic;
				var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName(graphic.graphicName);
				if (dobj != null)
				{
					var gr_x:Number = o.x;
					var gr_y:Number = o.y;
					
					if (dobj.GetBitmapData(graphic.frame) != null)
					{
						if (destRect != null)
						{
							var w:Number = dobj.GetWidth(graphic.frame);
							var h:Number = dobj.GetHeight(graphic.frame);
							var scaleW:Number = destRect.width/w;
							var scaleH:Number = destRect.height / h;
							var scl:Number = scaleW;
							if (scaleH < scaleW) scl = scaleH;
							xp -= (destRect.width / 2);
							yp -= (destRect.height / 2);

							xp += gr_x;
							yp += gr_y;
							
							var bitmapData:BitmapData =dobj.GetBitmapData(graphic.frame);

							renderMatrix.identity();
							renderMatrix.scale(scl, scl);
							if (xflip)
							{
								renderMatrix.scale(-1, 1);
							}

							if (bitmapData != null)
							{					
								bd.draw(bitmapData, renderMatrix,colorTransform,null,null,true);								
							}
						}
						else if (maxDestRect != null)
						{
							var w:Number = dobj.GetWidth(graphic.frame);
							var h:Number = dobj.GetHeight(graphic.frame);
							
							var scaleW:Number = maxDestRect.width/w;
							var scaleH:Number = maxDestRect.height / h;
							var scl:Number = scaleW;
							if (scaleH < scaleW) scl = scaleH;
							
							if (scl > 1) scl = 1;
							
							xp -= ((w*scl) / 2);
							yp -= ((h*scl) / 2);

							xp += gr_x;
							yp += gr_y;
							
							var bitmapData:BitmapData =dobj.GetBitmapData(graphic.frame);

							renderMatrix.identity();
							renderMatrix.scale(scl, scl);
							if (xflip)
							{
								renderMatrix.scale(-1, 1);
							}
							renderMatrix.translate(xp,yp);

							if (bitmapData != null)
							{					
								bd.draw(bitmapData, renderMatrix,colorTransform,null,null,true);								
							}
						}
						else
						{
							var rot:Number = Utils.DegToRad(_rotDeg + graphic.rot);
											
							renderPoint.x = graphic.offset.x;
							renderPoint.y = graphic.offset.y;
							
							renderPoint.x += gr_x;
							renderPoint.y += gr_y;

							renderMatrix.identity();						
							renderMatrix.rotate(Utils.DegToRad(_rotDeg));
							//renderMatrix.scale(scale,scale);
							renderPoint = renderMatrix.transformPoint(renderPoint);
							
							xp = (x) +renderPoint.x;
							yp = (y) + renderPoint.y;
							
							if (xflip == false)
							{
								GraphicObjects.GetDisplayObjByName(graphic.graphicName).RenderAtRotScaled(graphic.frame, bd, xp, yp,  scale, rot, colorTransform );
							}
							else
							{
								GraphicObjects.GetDisplayObjByName(graphic.graphicName).RenderAtRotScaled_Xflip(graphic.frame, bd, xp, yp,  scale, rot, colorTransform );
								
							}
						}
					}
					else
					{
						trace("missing obj");
					}
				}
			}
			if (dobj != null)
			{
				for each(body in physObj.bodies)
				{
					if (renderCollision)
					{
						if (g != null)
						{
							renderMatrix.identity();
							var rot:Number = Utils.DegToRad(_rotDeg);
							if (rot != 0)
							{
								renderMatrix.rotate(rot);
							}
							if (scale != 1)
							{
								renderMatrix.scale(scale,scale);
							}
							if (xflip)
							{
								renderMatrix.scale( -1, 1);
							}
							
							var scl:Number = 1;
							var xoff:Number = 0;
							var yoff:Number = 0;
							if (maxDestRect != null)
							{
								var w:Number = dobj.GetWidth(graphic.frame);
								var h:Number = dobj.GetHeight(graphic.frame);
								
								var scaleW:Number = maxDestRect.width/w;
								var scaleH:Number = maxDestRect.height / h;
								var scl:Number = scaleW;
								if (scaleH < scaleW) scl = scaleH;
								
								if (scl > 1) scl = 1;
								
								//xoff = dobj.GetXOffset(graphic.frame)*scl;
								//yoff = dobj.GetYOffset(graphic.frame) * scl;
								
	//							xoff += ((w*scl) / 2);
	//							yoff += ((h*scl) / 2);

							}
							

							var i:int;
							var j:int;
							for each(var shape:PhysObj_Shape in body.shapes)
							{
								if (shape.type == PhysObj_Shape.Type_Circle)
								{
									var r:Number = shape.circle_radius*scl;
									RenderCircle(g,x+shape.circle_pos.x+body.pos.x,y+shape.circle_pos.y+body.pos.y, r, 0xffffffff,2);

								}
								if (shape.type == PhysObj_Shape.Type_Poly)
								{
									var verts:Array = shape.poly_points;
									var numVerts:int = shape.poly_points.length;
									
									for (i = 0; i < numVerts; i++)
									{
										var j:int = i + 1;
										if (j >= numVerts) j = 0;
										
										p0.x = verts[i].x;
										p0.y = verts[i].y;
										p1.x = verts[j].x;
										p1.y = verts[j].y;
										
	//									p0.x += body.pos.x;
	//									p1.x += body.pos.x;
	//									p0.y += body.pos.y;
	//									p1.y += body.pos.y;
										
										p0 = renderMatrix.transformPoint(p0);
										p1 = renderMatrix.transformPoint(p1);
										
										p0.x *= scl;
										p0.y *= scl;
										p1.x *= scl;
										p1.y *= scl;
										
										p0.x += x;
										p1.x += x;
										p0.y += y;
										p1.y += y;
										
										p0.x += xoff;
										p0.y += yoff;
										p1.x += xoff;
										p1.y += yoff;
										
										
										RenderLine(g, p0.x, p0.y, p1.x, p1.y, 0xffffffff,2,0.5);
									}
								}
								
							}
						}
					}
				}
			}
		}		
		
		static function RenderCircle(g:Graphics,x:Number, y:Number, radius:Number,col:uint, thickness:Number = 1,alpha:Number = 1)
		{
			g.lineStyle(thickness, col, alpha);
			g.drawCircle(x, y, radius);
		}
		static function RenderLine(g:Graphics,x0:Number, y0:Number, x1:Number, y1:Number, col:uint, thickness:Number = 1,alpha:Number = 1)
		{
			g.lineStyle(thickness, col, alpha);
			g.moveTo(x0, y0);
			g.lineTo(x1, y1);
		}
		static function RenderRectangle(g:Graphics,r:Rectangle, col:uint, thickness:Number = 1,alpha:Number = 1)
		{
			RenderLine(g,r.left, r.top, r.right, r.top, col,thickness,alpha);
			RenderLine(g,r.left, r.bottom, r.right, r.bottom, col,thickness,alpha);
			RenderLine(g,r.left, r.top, r.left, r.bottom,  col,thickness,alpha);
			RenderLine(g,r.right, r.top, r.right, r.bottom,  col,thickness,alpha);
		}

		
		public static function RenderOutline(physObj:PhysObj, x:Number, y:Number, _rotDeg:Number,g:Graphics)
		{
			var graphic:PhysObj_Graphic;
			var graphics:Array = new Array();
			var body:PhysObj_Body;
			for each(graphic in physObj.graphics)
			{
				graphics.push(graphic);					
			}
			
			
			
			for each(graphic in graphics)
			{
				var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName(graphic.graphicName);
				var w:Number = dobj.GetWidth(graphic.frame);
				var h:Number = dobj.GetHeight(graphic.frame);
				var r:Rectangle = new Rectangle(x + graphic.offset.x, y + graphic.offset.y, w, h);
				RenderRectangle(g, r, 0xff6080, 2);
			}
		}		

	}
	
}