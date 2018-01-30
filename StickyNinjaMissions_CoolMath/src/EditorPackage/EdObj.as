package EditorPackage
{
	import EditorPackage.ObjParameters;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
//	import GameObjects.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EdObj extends EditableObjectBase 
	{
		public var instanceName:String;
		//public var initParams:String;
		public var initFunctionParams:String;
		public var typeName:String;
		public var x:Number;
		public var y:Number;
		public var rot:Number;
		public var scale:Number;
		public var isXFlipped:Boolean;
		
		public var sortZ:Number;
		public var frame:Number;
		
		
		public function EdObj() 
		{
			super();
			classType = "obj";
			scale = 1;
			isXFlipped = false;
//			initParams = "";
			instanceName = "";
			typeName = "";
			x = y = 0;

		}
		
		// goes through the definitions
		public function GetParameterListForExport():String
		{
			var exportStr:String = ""
			
			var po:PhysObj = Game.objectDefs.FindByName(typeName);
			
			for (var i:int = 0; i < po.instanceParams.length; i++)
			{
				var s:String = po.instanceParams[i];
				exportStr += s + "=";
				var s1:String = objParameters.GetValueString(s);
				exportStr += s1;
				if (i != po.instanceParams.length - 1) exportStr += ",";				
			}
			return exportStr;
		}
		
		public function Clone():EdObj
		{
			var clone:EdObj = new EdObj();
			
			clone.classType = classType;
			clone.instanceName = instanceName;
			//clone.initParams = initParams;
			clone.typeName = typeName;
			clone.x = x;
			clone.y = y;
			clone.rot = rot;
			clone.scale = scale;
			clone.isXFlipped = isXFlipped;
			clone.id = id;
			clone.objParameters = objParameters.Clone();

			return clone;
		}
		
		
		
//-------------------------------------------------------------------------------------------------------------------		
		
		public override function RenderHighlighted(highlightType:int):void
		{
			var po:PhysObj = Game.objectDefs.FindByName(typeName);				
			var p:Point = PhysEditor.GetMapPos(x,y);
				
			
			if (highlightType == HIGHLIGHT_HOVER)
			{
				var ct:ColorTransform = new ColorTransform(1, 1, 1, 1, 255,0,0, 0);
				PhysObj.RenderAt(po, p.x, p.y, rot, scale * PhysEditor.zoom, PhysEditor.screenBD, PhysEditor.linesScreen.graphics, true,null,null,ct,isXFlipped);				
			}
			else if (highlightType == HIGHLIGHT_SELECTED)
			{
				var ct:ColorTransform = new ColorTransform(1, 1, 1, 1, 128,128,128, 0);
				PhysObj.RenderAt(po, p.x, p.y, rot, scale * PhysEditor.zoom, PhysEditor.screenBD, PhysEditor.linesScreen.graphics, true,null,null,ct,isXFlipped);				
			}
			
		}

		public override function Render():void
		{
			var po:PhysObj = Game.objectDefs.FindByName(typeName);
			if (po != null)
			{
				var layer:int = GetCurrentLayer();
				if (EditorLayers.IsVisible(layer) == true)
				{				
					if (po.editorRenderFunctionName != null && po.editorRenderFunctionName != "" &&  po.editorRenderFunctionName != "null")
					{
						var renderer:Editor_GameRenderer = new Editor_GameRenderer();
						renderer[po.editorRenderFunctionName](po, this);
					}
					else
					{
						var p:Point = PhysEditor.GetMapPos(x, y);
						PhysObj.RenderAt(po, p.x, p.y, rot, scale * PhysEditor.zoom, PhysEditor.screenBD, PhysEditor.linesScreen.graphics, true, null, null, null, isXFlipped);				
						
						/*
						if (po.markers.Count() != 0)
						{
							for (var markerIndex:int = 0; markerIndex < po.markers.Count(); markerIndex++)
							{							
								PhysObj.RenderMarkerAt(po, p.x,p.y, rot, scale * PhysEditor.zoom,  PhysEditor.screenBD, PhysEditor.linesScreen.graphics,null,null,false,markerIndex);
							}
						}
						*/
						
					}
				}
			}
			
		}
		
		
		public override function GetEditorHoverName():String
		{
			return "OBJ: " + typeName;
		}

		public override function MoveBy(_x:Number, _y:Number):void
		{
			x += _x;
			y += _y;			
			PhysEditor.editModeObj_Joints.UpdateJoints_ObjectMoved(id,_x,_y);
			
		}

		public override function RotateBy(cx:Number, cy:Number,da:Number):void
		{
			rot += Utils.RadToDeg(da);
			
			var dx:Number = x;
			var dy:Number = y;
			
			
			var m:Matrix = new Matrix();
			m.rotate(da);
			var p:Point = new Point(x - cx, y - cy);
			p = m.transformPoint(p);
			x = cx + p.x;
			y = cy + p.y;
			
			dx = x - dx;
			dy = y - dy;
			
//			PhysEditor.editModeObj_Joints.UpdateJoints_ObjectMoved(id,dx,dy,da);
			
		}
		
		public override function XFlip(centreX:Number):void
		{
			x = centreX - x;
			rot = -rot;
		}

		public override function SelfXFlip():void
		{
			isXFlipped = (isXFlipped == false);
		}
		
		
		public override function GetCentreHandle():Point
		{
			return new Point(x,y);
		}
		
		
		public override function HitTestRectangle(r:Rectangle):Boolean
		{
			if (r.containsPoint(new Point(x, y))) 
			{
				return true;			
			}
			return false;
		}
		
		public override function Duplicate():EditableObjectBase
		{
			var dup:EditableObjectBase = Clone() as EditableObjectBase;
			CopyBaseToDuplicate(dup);
			return dup;
		}
//--------------------------------------------------------------------------------------------------------

		public override function GetStandardParameters():ObjParameters
		{
			var standardParameters:ObjParameters = new ObjParameters();
			standardParameters.Add("obj_rot", rot.toString(), true, "rot", "number");
			standardParameters.Add("obj_scale", scale.toString(), true, "scale", "number");
			standardParameters.Add("obj_xflip", isXFlipped.toString(), true, "isXFlipped", "bool");
			return standardParameters;
		}
	

		public override function SetStandardParameter(op:ObjParameter)
		{
			op.SetOriginalValue(this);
		}
		
	}		
}






