package UIPackage
{
	import AudioPackage.Audio;
	import EditorPackage.EditMode_Lines;
	import EditorPackage.EdLine;
	import EditorPackage.ObjParameters;
	import EditorPackage.PhysEditor;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import LicPackage.LicDef;
	import TextPackage.TextRenderer;
	
	/**
	 * ...
	 * @author
	 */
	public class UIX_Instance
	{
		public var componentName:String;
		public var component:UIX_Component;
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var editorLayer:int;
		public var transonDelay:Number;
		public var transonType:String;
		public var transonFunc:String;
		public var scaleX:Number;
		public var scaleY:Number;
		public var rot:Number;
		public var frame:int;
		public var colorMultiply:Vector3D;
		public var alpha:Number;
		public var render_colorMultiply:Vector3D;
		public var render_alpha:Number;
		public var childInstances:Vector.<UIX_Instance>;
		public var childInstanceDict:Dictionary;
		public var parentInst:UIX_Instance;
		public var pageDefInstance:UIX_Instance;
		public var topParent:UIX_Instance;
		public var isTopParent:Boolean;
		public var currentMatrix:Matrix3D;
		public var ownBoundingRectangle:Rectangle;
		public var boundingRectangle:Rectangle;
		public var objParameters:ObjParameters;
		public var userData:Object;
		public var visible:Boolean;
		public var blackout:Boolean;
		public var isHilighted:Boolean;
		public var movieClipDisplayChild:MovieClip;
		public var movieClipDisplayChildX:Number;
		public var movieClipDisplayChildY:Number;
		public var renderFunction:Function;
		
		public var colorTransform:ColorTransform;
		public var cachedMatrix:Matrix3D;
		public var matrixIsCached:Boolean;
		
		public var editor_selected:Boolean;
		public var gameObj:UIX_GameObj;
		
		public var transition_startx:Number;
		public var transition_endx:Number;
		public var transition_startalpha:Number;
		public var transition_endalpha:Number;
		
		var textparent:int;	// how many stages up do you go for your button text
		
		var button_user_clickCallback:Function;
		var button_user_hoverCallback:Function;
		var button_user_outCallback:Function;
		var button_isClicking:Boolean;
		var button_clickTimer:int;
		var button_clickTimerMax:int;
		var button_isHovered:Boolean;
		var button_useTick:Boolean;
		var button_tickState:Boolean;
		public var button_canPress:Boolean;
		public var mouseEnabled:Boolean;
		
//		<instance name="" component="Component_Background" pos="0,0" scale="1,1" rot="0" />
		
		var dragBox_x:Number;
		var dragBox_minX:Number;
		var dragBox_maxX:Number;
		var dragBox_CB:Function;
		var dragBox_dragActive:Boolean;

		var updateButton_oldX:Number;
		var updateButton_oldY:Number;
		var updateButton_oldRot:Number;
		var updateButton_oldScaleX:Number;
		var updateButton_oldScaleY:Number;
		var updateButton_oldAlpha:Number;
		var updateButton_oldColorMultiply:Vector3D;
		function UpdateButton()
		{
			if (button_isHovered)
			{
				updateButton_oldX = x;
				updateButton_oldY = y;
				updateButton_oldRot = rot;
				updateButton_oldScaleX = scaleX;
				updateButton_oldScaleY = scaleY;
				updateButton_oldAlpha = alpha;
				updateButton_oldColorMultiply = colorMultiply.clone();
				//scaleX *= 1.1;
				//scaleY *= 1.1;
				//x -= 3;
				//y -= 3;
				//rot -= 5;
				
				
				var v:Number = 1.5 + (Math.sin(Game.main.mainCounter* 0.1) * 0.2);
				colorMultiply.x = v;
				colorMultiply.y = v;
				colorMultiply.z = v;
				ClearMatrixCache();
			}
			if (button_isClicking)
			{
				updateButton_oldX = x;
				updateButton_oldY = y;
				updateButton_oldRot = rot;
				updateButton_oldScaleX = scaleX;
				updateButton_oldScaleY = scaleY;
				updateButton_oldAlpha = alpha;
				updateButton_oldColorMultiply = colorMultiply.clone();
				
				
				var e:Number = 0;
				if ( button_clickTimer <= 3)
				{
					e = Utils.ScaleTo(0, 1, 0, 3, button_clickTimer);
				}
				else
				{
					e = Utils.ScaleTo(1, 0, 3, button_clickTimerMax, button_clickTimer);
				}
				
//				var e:Number = Ease.Power_InOut(  Utils.ScaleTo(0, 1, 0, button_clickTimerMax, button_clickTimer), 2);
				
				var s:Number = Utils.ScaleTo(1, 0.9, 0, 1,e);
				
				if (component.dobj != null)
				{
					//x += component.dobj.GetWidth(0)*0.5 * (1-s);
					//y += component.dobj.GetHeight(0) * 0.5 * (1 - s);
				}
				
				scaleX *= s;
				scaleY *= s;
				//x -= 3;
				//y -= 3;
				//rot -= 5;

				ClearMatrixCache();
			}
		}
		function UpdateButtonPostRender()
		{
			if (button_isHovered)
			{
				x = updateButton_oldX;
				y = updateButton_oldY;
				rot = updateButton_oldRot;
				scaleX = updateButton_oldScaleX;
				scaleY = updateButton_oldScaleY;
				alpha = updateButton_oldAlpha;
				colorMultiply.x = updateButton_oldColorMultiply.x;
				colorMultiply.y = updateButton_oldColorMultiply.y;
				colorMultiply.z = updateButton_oldColorMultiply.z;
				ClearMatrixCache();
			}
			if (button_isClicking)
			{
				x = updateButton_oldX;
				y = updateButton_oldY;
				rot = updateButton_oldRot;
				scaleX = updateButton_oldScaleX;
				scaleY = updateButton_oldScaleY;
				alpha = updateButton_oldAlpha;
				colorMultiply.x = updateButton_oldColorMultiply.x;
				colorMultiply.y = updateButton_oldColorMultiply.y;
				colorMultiply.z = updateButton_oldColorMultiply.z;
				button_clickTimer++;
				if (button_clickTimer > button_clickTimerMax)
				{
					Audio.OneShot("sfx_click",0.2);

					button_clickTimer = 0;
					button_isClicking = false;
					if (button_user_clickCallback != null)
					{
						button_user_clickCallback(this);
					}
				
				}
				ClearMatrixCache();
			}
		}

		function MouseClick_Mobile()
		{
			if (button_useTick)
			{
				button_tickState = (button_tickState == false);
				Child("tick").visible = button_tickState;				
			}
			button_isClicking = true;
			button_clickTimer = 0;
		}
		function MouseClick()
		{
			if (PROJECT::useStage3D)
			{
				return MouseClick_Mobile();
			}
			if (button_useTick)
			{
				button_tickState = (button_tickState == false);
				Child("tick").visible = button_tickState;				
			}
			
			Audio.OneShot("sfx_click",0.2);
			
			if (button_user_clickCallback != null)
			{
				button_user_clickCallback(this);
			}
		}
		function MouseOver()
		{
//			trace("hovered "+GetInstanceName());
			button_isHovered = true;
			if (button_user_hoverCallback != null)
			{
				button_user_hoverCallback(this);
			}
		}
		function MouseOut()
		{
			button_isHovered = false;
			if (button_user_outCallback != null)
			{
				button_user_outCallback(this);
			}
		}
		
		function AddChildInst(inst:UIX_Instance)
		{
			childInstances.push(inst);
			childInstanceDict[inst.GetInstanceName()] = inst;
		}


		public function Child(instName:String):UIX_Instance
		{
			return childInstanceDict[instName];
			/*
			for each (var child:UIX_Instance in childInstances)
			{
				if (child.GetInstanceName() == instName)
				{
					return child;
				}
			}
			return null;
			*/
		}
		
		public function GetInstanceName():String
		{
			return objParameters.GetValueString("uix_instancename");
		}
		public function SetInstanceName(s:String)
		{
			return objParameters.SetValueString("uix_instancename",s);
		}
		
		public function SetColorFromColorTransform(ct:ColorTransform)
		{
			colorMultiply.x = ct.redOffset;
			colorMultiply.y = ct.greenOffset;
			colorMultiply.z = ct.blueOffset;
		}

		public function SetColorInt(r:int,g:int,b:int)
		{
			colorMultiply.x = 1 / 255 * r;
			colorMultiply.y = 1 / 255 * g;
			colorMultiply.z = 1 / 255 * b;
		}
		
		public function ButtonSetHighlight(val:Boolean)
		{
			isHilighted = val;
			var selectedInst:UIX_Instance = Child("selected");
			if (selectedInst != null)
			{
				selectedInst.visible = isHilighted;
			}
		}

		
		public function AddMovieClipDisplayChild(mc:MovieClip, x:Number, y:Number)
		{
			
			var mcx:int = mc.x;
			var mcy:int = mc.y;
			
			movieClipDisplayChild = mc;
			movieClipDisplayChildX = x;
			movieClipDisplayChildY = y;
		}
		public function RemoveMovieClipDisplayChild()
		{
			var parent:Stage = LicDef.GetStage().stage;

			if (movieClipDisplayChild.parent == parent)
			{
				parent.removeChild(movieClipDisplayChild);
			}
			movieClipDisplayChild = null;
		}
		
		public function SetText(text:String)
		{
			var comp:UIX_Component = component;	// UIX.GetComponentByName(componentName);

			if (comp.type == UIX_Component.TYPE_TEXT)
			{
				objParameters.SetValueString("uix_text",text);
			}
			else
			{
				objParameters.SetValueString("uix_text",text);
//				trace("SetText trying to set a non text-type component");
			}
		}
		public function GetText():String
		{
			var comp:UIX_Component = component
			var txt:String = "";
			
			if (comp.type == UIX_Component.TYPE_TEXT)
			{
				txt = objParameters.GetValueString("uix_text");
			}
			else if (comp.type == UIX_Component.TYPE_INPUTTEXT)
			{
				txt = objParameters.GetValueString("uix_text");
			}
			else
			{
				txt = objParameters.GetValueString("uix_text");
			}
			return txt;
		}
		
		
		public function GetZSortedInstances():Array
		{		
			var zorder:Array = new Array();
			for each(var inst:UIX_Instance in childInstances)
			{
				zorder.push(inst);
			}
			zorder.sortOn("z",Array.NUMERIC|Array.DESCENDING);
			return zorder;
			
		}
		
		public function SetComponentFromName()
		{
			component = null;
			if (componentName != null && componentName != "")
			{
				component = UIX.GetComponentByName(componentName);
			}
		}
		public function UIX_Instance()
		{
			transonFunc = "InitAppear";
			transonType = "none";
			transonDelay = 0;
			editorLayer = 1;
			userData = new Object();
			componentName = "";
			component = null;
			x = 0;
			y = 0;
			z = 0;
			scaleX = 1;
			scaleY = 1;
			rot = 0;
			frame = 0;
			childInstances = new Vector.<UIX_Instance>();
			childInstanceDict = new Dictionary();
			currentMatrix = new Matrix3D();
			mouseEnabled = false;
			boundingRectangle = new Rectangle(0, 0, 1, 1);
			ownBoundingRectangle = new Rectangle(0, 0, 1, 1);
			visible = true;
			blackout = false;
			isHilighted = false;
			editor_selected = false;
			gameObj = null;
			
			colorTransform = new ColorTransform();
			cachedMatrix = new Matrix3D();
			matrixIsCached = false;
			
			alpha = 1;
			render_alpha = 1;
			colorMultiply = new Vector3D();
			render_colorMultiply = new Vector3D();
			colorMultiply.x = colorMultiply.y = colorMultiply.z = 1;
			render_colorMultiply.x = render_colorMultiply.y = render_colorMultiply.z = 1;
			
			button_clickTimer = 0;
			button_clickTimerMax = 10;
			button_isClicking = false;
			button_isHovered = false;
			button_canPress = false;
			button_useTick = false;
			button_tickState = false;
			
			renderFunction = null;
			
			movieClipDisplayChild = null;
			
			dragBox_CB = null;
			dragBox_minX = 0;
			dragBox_maxX = 0;
			dragBox_x = 0;
			dragBox_dragActive = false;
			
			objParameters = new ObjParameters();
			objParameters.Add("uix_instancename", null);
			objParameters.Add("uix_text", null);
			objParameters.Add("uix_textscale", null);
			objParameters.Add("uix_textalign", null);
			
			objParameters.Add("uix_x", null,true,"x");
			objParameters.Add("uix_y", null,true,"y");
			objParameters.Add("uix_z", null,true,"z");
			objParameters.Add("uix_scale_x", null,true,"scaleX");
			objParameters.Add("uix_scale_y", null,true,"scaleY");
			objParameters.Add("uix_rot", null,true,"rot");
			objParameters.Add("uix_alpha", null,true,"alpha");
			objParameters.Add("uix_color", "1.1.1", true, "colorMultiply", "vector3");
			objParameters.Add("uix_editorlayer", "1", true, "editorLayer");
			objParameters.Add("uix_transon_delay", "0", true, "transonDelay");
			objParameters.Add("uix_transon_type", "none", true, "transonType");
			objParameters.Add("uix_transon_func", "InitAppear", true, "transonFunc");
			
			
			
		}
		
		public function Clone():UIX_Instance
		{
			var c:UIX_Instance = new UIX_Instance();
			c.componentName = componentName;
			c.component = component;
			c.x = x;
			c.y = y;
			c.z = z;
			c.scaleX = scaleX;
			c.scaleY = scaleY;
			c.rot = rot;
			c.frame = frame;
			c.visible = visible;
			c.blackout = blackout;
			c.alpha = alpha;
			c.colorMultiply.x = colorMultiply.x;
			c.colorMultiply.y = colorMultiply.y;
			c.colorMultiply.z = colorMultiply.z;
			c.textparent = textparent;
			c.objParameters = objParameters.Clone();
			c.currentMatrix = currentMatrix.clone();
			c.boundingRectangle = boundingRectangle.clone();
			c.ownBoundingRectangle = ownBoundingRectangle.clone();
			c.editorLayer = editorLayer;
			c.transonDelay = transonDelay;
			c.transonType = transonType;
			c.transonFunc = transonFunc;

			return c;
		}
		
		public function FromXML(xml:XML)
		{
			componentName = XmlHelper.GetAttrString(xml.@component, "undefined_componentname");
			var s:String = XmlHelper.GetAttrString(xml.@params, "");
			objParameters.ValuesFromString(s);

			var a:Array = XmlHelper.GetAttrString(xml.@pos, "0,0,0").split(",");
			x = a[0];
			y = a[1];
			z = a[2];
			scaleX = XmlHelper.GetAttrPoint(xml.@scale).x;
			scaleY = XmlHelper.GetAttrPoint(xml.@scale).y;
			rot = XmlHelper.GetAttrNumber(xml.@rot);
			alpha = XmlHelper.GetAttrNumber(xml.@alpha);
			var colorArray:Array = XmlHelper.GetAttrString(xml.@color, "1.1.1").split(".");
			
			textparent = XmlHelper.GetAttrInt(xml.@textparent,0);
			transonDelay = XmlHelper.GetAttrNumber(xml.@transonDelay,0);
			transonType = XmlHelper.GetAttrString(xml.@transonType,"none");
			transonFunc = XmlHelper.GetAttrString(xml.@transonFunc,"InitAppear");
		}
		
		
		public function ToXML():String
		{
			var s:String = "";
			s += '<instance component="' + componentName +'" ';
			s += 'params="' + objParameters.ToString() + '"';
			s += 'pos="' + x + ',' + y + ',' + z + '" ';
			s += 'scale="' + scaleX + ',' + scaleY + '" ';
			s += 'rot="' + rot+'" ';
			s += 'alpha="' + alpha+'" ';
			s += 'color="' + colorMultiply.x+"."+colorMultiply.y+"."+colorMultiply.z+'" ';
			s += 'textparent="' + textparent+'" ';
			s += 'transonDelay="' + transonDelay+'" ';
			s += 'transonType="' + transonType+'" ';
			s += 'transonFunc="' + transonFunc+'" ';
			s += ' />';
			return s;			
		}
		
		
		public function ScaleBy(dx:Number,dy:Number):void
		{
			dx *= 0.01;
			dy *= 0.01;
			scaleX += dx;
			scaleY += dy;
		}
		public function RotateBy(cx:Number, cy:Number,da:Number):void
		{
			rot += Utils.RadToDeg(da);
			
			var dx:Number = x;
			var dy:Number = y;
			
			var m:Matrix3D= new Matrix3D();
			m.appendRotation(Utils.RadToDeg(da),Vector3D.Z_AXIS);
			var p:Vector3D = new Vector3D(x - cx, y - cy,0);
			p = m.transformVector(p);
			x = cx + p.x;
			y = cy + p.y;
			
			dx = x - dx;
			dy = y - dy;
			
		}
		public function MoveBy(dx:Number, dy:Number,dz:Number=0)
		{
			x += dx;
			y += dy;
			z += dz;
//			trace("pos " + x + " " + y + " " + z);
		}
		
		public function GetBoundsRect(parentM:Matrix3D = null):Rectangle
		{
			var comp:UIX_Component = component;	// UIX.GetComponentByName(componentName);
			var m:Matrix3D = new Matrix3D();
			m.appendRotation(-rot,Vector3D.Z_AXIS);
			m.appendScale(scaleX, scaleY,1);
			m.appendTranslation(x, y, 0);
			
			if (parentM != null)
			{
				m.append(parentM);
			}
			
			var r:Rectangle = comp.GetBoundingRect();
			
			var p:Vector3D = new Vector3D(r.x,r.y);
			p = m.transformVector(p);
			
			var p1:Vector3D = new Vector3D(r.right,r.top);
			p1 = m.transformVector(p1);

			var p2:Vector3D = new Vector3D(r.right,r.bottom);
			p2 = m.transformVector(p2);

			var p3:Vector3D = new Vector3D(r.left,r.bottom);
			p3 = m.transformVector(p3);
			
			
			r.x = p.x;
			r.y = p.y;
			r.right = p.x;
			r.bottom = p.y;
			
			if (p1.x > r.right) r.right = p1.x;
			if (p2.x > r.right) r.right = p2.x;
			if (p3.x > r.right) r.right = p3.x;

			if (p1.y > r.bottom) r.bottom = p1.y;
			if (p2.y > r.bottom) r.bottom = p2.y;
			if (p3.y > r.bottom) r.bottom = p3.y;
			
			if (p1.x < r.left) r.left = p1.x;
			if (p2.x < r.left) r.left = p2.x;
			if (p3.x < r.left) r.left = p3.x;

			if (p1.y < r.top) r.top = p1.y;
			if (p2.y < r.top) r.top = p2.y;
			if (p3.y < r.top) r.top = p3.y;
			
			
			return r;
		}
		
		
		
		
		public function GetWorldPositionMatrix():Matrix3D
		{
			var m:Matrix3D = new Matrix3D();
			m.appendRotation(rot,Vector3D.Z_AXIS);
			m.appendScale(scaleX, scaleY,1);
			m.appendTranslation(x, y, 0);
			return m;			
		}
		
		public function RenderInRectangle(bd:BitmapData, destRect:Rectangle)
		{
			var comp:UIX_Component = component;	// UIX.GetComponentByName(componentName);
			
			var x:Number = destRect.x;	// +(destRect.width / 2);
			var y:Number = destRect.y;	// +(destRect.height / 2);
			
			var scale:Number = 1;
			var br:Rectangle = comp.GetBoundingRect();
			
			if (br.width > br.height)
			{
				scale = destRect.width / br.width;
			}
			else
			{
				scale = destRect.height / br.height;
			}
			
			var xo:Number = br.x;
			var yo:Number = br.y;
			
			
//			scale = 0.5;
			var m:Matrix3D = new Matrix3D();
			m.appendTranslation(x/scale, y/scale,0);
			m.appendScale(scale, scale,1);
			m.appendTranslation(-xo*scale, -yo*scale,0);
			RenderAtEditorMatrix(m, bd);
			
			Utils.RenderRectangle(bd, destRect, 0xffff0000);
			
		}
		

		
		function GetTextAlign():int
		{
			var textInst:UIX_Instance = this;
			for (var i:int = 0; i < textparent; i++)
			{
				textInst = textInst.parentInst;
			}
			
			var s:String = textInst.objParameters.GetValueString("uix_textalign");
			if (s == "left") return TextRenderer.JUSTIFY_LEFT;
			if (s == "right") return TextRenderer.JUSTIFY_RIGHT;
			return TextRenderer.JUSTIFY_CENTRE;
		}
		
		// get uix_text parameter from the highest point you can.
		function GetButtonText():String
		{
			var textInst:UIX_Instance = this;
			for (var i:int = 0; i < textparent; i++)
			{
				textInst = textInst.parentInst;
			}
			var s:String = textInst.objParameters.GetValueString("uix_text");
			return s;
		}
		function GetButtonTextScale():Number
		{
			var textInst:UIX_Instance = this;
			for (var i:int = 0; i < textparent; i++)
			{
				textInst = textInst.parentInst;
			}
			var textScale:Number = textInst.objParameters.GetValueNumber("uix_textscale");
			return textScale;
		}
		
		public function RenderAtEditor(bd:BitmapData, selected:Boolean = false)
		{
			var m:Matrix3D = new Matrix3D();
			RenderAtEditorMatrix(m, bd);			
		}
		public function RenderAtEditorMatrix(parentM:Matrix3D,bd:BitmapData)
		{
			var comp:UIX_Component = component;	// UIX.GetComponentByName(componentName);
			var m:Matrix3D = new Matrix3D();
			m.appendRotation(rot,Vector3D.Z_AXIS);
			m.appendScale(scaleX, scaleY,1);
			m.appendTranslation(x, y,0);
			
			m.append(parentM);

			if (comp.type == UIX_Component.TYPE_NORMAL)
			{				
				if (comp.editor_mc != null)
				{
					comp.editor_mc.gotoAndStop(comp.frame);
					bd.draw(comp.editor_mc, Utils.Matrix3DToMatrix(m));
				}
			}
			else if (comp.type == UIX_Component.TYPE_TEXT)
			{				
				var str:String = "string test";
				var rr:Number =  0;	// Utils.GetRotFromMatrix(m);
				var ss:Number = 1;	// Utils.GetScaleFromMatrix(m);
				
				TextRenderer.RenderAt(0,bd, m.position.x, m.position.y, str,rr,ss);
			}
			else if (comp.type == UIX_Component.TYPE_INPUTTEXT)
			{				
				var str:String = "string test";
				var rr:Number =  0;	// Utils.GetRotFromMatrix(m);
				var ss:Number = 1;	// Utils.GetScaleFromMatrix(m);
				
				TextRenderer.RenderAt(0,bd, m.position.x, m.position.y, str,rr,ss);
			}
			
			for each(var inst:UIX_Instance in comp.instances)
			{
				inst.RenderAtEditorMatrix(m, bd);
			}
		
		}

		
		public function RenderSingleUsingMatrix(bd:BitmapData,_xoff:Number=0,_yoff:Number=0)
		{
			
			var m:Matrix3D = currentMatrix;
			m.appendTranslation(_xoff, _yoff, 0);		// this gets unappended at the end of the func
			
			var comp:UIX_Component = component;	// UIX.GetComponentByName(componentName);
			if (comp != null)
			{
				
				colorTransform.redMultiplier = render_colorMultiply.x;
				colorTransform.greenMultiplier= render_colorMultiply.y;
				colorTransform.blueMultiplier = render_colorMultiply.z;
				colorTransform.alphaMultiplier = render_alpha;
				
				
				if (blackout)
				{
					colorTransform.redMultiplier *= 0.25;
					colorTransform.greenMultiplier *= 0.25;
					colorTransform.blueMultiplier *= 0.25;
				}
				
				if (render_alpha != 0)
				{
					if (render_alpha == 1)
					{
						s3d.SetCurrentShader("normal");					
					}
					else
					{
						s3d.SetCurrentShader("alphamul");					
					}
					if ( (colorTransform.redMultiplier != 1) || (colorTransform.greenMultiplier!= 1) || (colorTransform.blueMultiplier != 1) )
					{
						s3d.SetCurrentShader("colormul");					
					}
					
					
					if (comp.type == UIX_Component.TYPE_NORMAL)
					{				
						if (renderFunction != null)
						{
							renderFunction(this,frame,bd,m,colorTransform);
						}
						else
						{
							if (comp.dobj != null)
							{
								if (comp.dobj.DoesFrameExist(comp.frame-1 + frame) == false)
								{								
									trace("ERROR Frame out of range DOBJ " + comp.name + " " + int(comp.frame-1) + " / " + frame);
								}
								else
								{
									comp.dobj.RenderAtMatrix3D(comp.frame-1 + frame, bd, m, colorTransform);
								}
							}
						}
					}
					else if (comp.type == UIX_Component.TYPE_TEXT)
					{				
						var str:String = GetButtonText();
						var align:int = GetTextAlign();
						var decomposed:Vector.<Vector3D> = m.decompose(Orientation3D.EULER_ANGLES);
						var rr:Number = decomposed[1].z;	// Utils.GetRotFromMatrix(m);
						var ss:Number = GetButtonTextScale() * decomposed[2].y;	// Utils.GetScaleFromMatrix(m);				
						TextRenderer.RenderAt(0,bd, m.position.x, m.position.y, str,rr,ss,align,colorTransform);
					}	
					else if (comp.type == UIX_Component.TYPE_INPUTTEXT)
					{				
						var str:String = GetButtonText();
						var decomposed:Vector.<Vector3D> = m.decompose(Orientation3D.EULER_ANGLES);
						var rr:Number = decomposed[1].z;	// Utils.GetRotFromMatrix(m);
						var ss:Number = GetButtonTextScale() * decomposed[2].y;	// Utils.GetScaleFromMatrix(m);				
						TextRenderer.RenderAt(0,bd, m.position.x, m.position.y, str,rr,ss,TextRenderer.JUSTIFY_CENTRE,colorTransform);
					}	
					
					if (movieClipDisplayChild != null)
					{
						var parent:Stage = LicDef.GetStage().stage;
						if(movieClipDisplayChild.parent != parent)
						{

							parent.addChild(movieClipDisplayChild);
						}
						
						var xx:Number = (m.position.x * ScreenSize.fullScreenScale) + ScreenSize.fullScreenScaleXOffset
						var yy:Number = (m.position.y * ScreenSize.fullScreenScale) + ScreenSize.fullScreenScaleYOffset
						
						if (PROJECT::isMobile == false)
						{
							xx = m.position.x;
							yy = m.position.y;
						}
						
						movieClipDisplayChild.x = xx + movieClipDisplayChildX;
						movieClipDisplayChild.y = yy + movieClipDisplayChildY;
					}
				}
			}
			m.appendTranslation(-_xoff, -_yoff, 0);
		}
		
		public function GetComponentInstances():Vector.<UIX_Instance>
		{
			var comp:UIX_Component = component;	// UIX.GetComponentByName(componentName);
			return comp.instances;			
		}
		
		public function ClearMatrixCache()
		{
			matrixIsCached = false;
			for each(var inst:UIX_Instance in childInstances)
			{
				inst.ClearMatrixCache();
			}
		}
		
		
		var calcmatrix_v:Vector3D = new Vector3D();
		public function CalcMatrix(parentMatrix:Matrix3D=null):Matrix3D
		{
			if (matrixIsCached == false)
			{
				var c:UIX_Component = this.component;
				var nm:String = this.componentName;
				
				
				cachedMatrix.identity();
				cachedMatrix.appendRotation(rot, Vector3D.Z_AXIS);
				cachedMatrix.appendScale(scaleX, scaleY, 1);			

				if (parentMatrix != null)
				{
					cachedMatrix.append(parentMatrix);
				}
				
				calcmatrix_v.x = x;
				calcmatrix_v.y = y;
				calcmatrix_v.z = 0;
				if (parentMatrix != null && ( (x != 0) || (y != 0) ) )
				{				
					calcmatrix_v = parentMatrix.deltaTransformVector(calcmatrix_v);
				}			
				cachedMatrix.appendTranslation(calcmatrix_v.x, calcmatrix_v.y, 0);	
				matrixIsCached = true;
			}

			
			return cachedMatrix;
		}
		
		
		
		public function RenderBoundingRect(bd:BitmapData)
		{
			if (boundingRectangle != null)
			{
				Utils.RenderRectangle(bd, boundingRectangle, 0xffffffff);
			}
		}
		
		public function HitTestUsingMatrix(mx:Number=0, my:Number=0):Boolean
		{
			return component.DoHitTest(mx, my, currentMatrix);
			
			/*
			if (boundingRectangle.contains(mx, my))
			{
				return true;
			}
			return false;
			*/
		}

		public function HitTestRectUsingMatrix(r:Rectangle):Boolean
		{
			return component.DoHitTestRect(r, currentMatrix);
		}
		
	}

}