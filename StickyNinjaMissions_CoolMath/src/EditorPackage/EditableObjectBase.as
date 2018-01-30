package EditorPackage 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class EditableObjectBase 
	{
		public var prev_id:String;
		public var id:String;
		public var objParameters:ObjParameters;
		public var xoff:Number;
		public var yoff:Number;
		public var switchName:String;
		public var classType = "base";
		
		public var sort_zpos:Number;
		
		
		
		public function EditableObjectBase() 
		{
			classType = "base";
			id = "";
			prev_id = "";
			objParameters = new ObjParameters();
			
			xoff = 0;
			yoff = 0;
			switchName = "";
		}
		
// Virtual functions:
	
		public function GetStandardParameters():ObjParameters
		{
			return null;
		}
		public function SetStandardParameter(op:ObjParameter)
		{
		}
	
		public function SetSortPosFromGameLayer()
		{
			sort_zpos = 0;
			if (objParameters.Exists("game_layer"))
			{
				var layerName:String = objParameters.GetValueString("game_layer");
				sort_zpos = GameLayers.GetZPosByName(layerName);
			}
		}
	
		public static const HIGHLIGHT_HOVER:int = 0;
		public static const HIGHLIGHT_SELECTED:int = 1;

		public function IsSpline():Boolean
		{
			return objParameters.GetValueBoolean("line_spline");			
		}
		
		public function GetCurrentPolyMaterial():PolyMaterial
		{
			var polyMatName:String = objParameters.GetValueString("line_material");
			var pm:PolyMaterial = PolyMaterials.GetByName(polyMatName);
			return pm;
		}
		public function GetCurrentLayer():int
		{
			var layer:int = 0;
			if (objParameters.GetParam("editor_layer") != "")
			{
				layer = objParameters.GetValueInt("editor_layer")-1;
			}
			return layer;
		}
		
		public function CopyBaseToDuplicate(dup:EditableObjectBase)
		{
			dup.id = "";
			dup.objParameters = objParameters.Clone();
			dup.xoff = xoff;
			dup.yoff = yoff;
			dup.switchName = switchName;			
			dup.classType = classType;			
		}
		public function Duplicate():EditableObjectBase
		{
			return null;
		}
		
		public function HitTestRectangle(r:Rectangle):Boolean
		{
			return false;
		}
		
		public function HitTest(x:int, y:int):Boolean
		{
			return false;
		}
		
		public function MoveBy(x:Number, y:Number):void
		{
			
		}
		
		public function RotateBy(cx:Number, cy:Number,da:Number):void
		{
			
		}
		
		
		public function Render():void
		{
			
		}
		public function RenderHighlighted(highlightType:int):void
		{
			
		}

		public function GetCentreHandle():Point
		{
			return new Point(0, 0);
		}
		
		public function XFlip(centreX:Number):void
		{
			
		}

		public function SelfXFlip():void
		{
			
		}
		
		
		public function GetEditorHoverName():String
		{
			return id;
		}
		
	}

}