package AnimPackage  
{
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author 
	 */
	public class AnimHierarchyFramePart 
	{
		var x:Number;
		var y:Number;
		var r_degrees_original:Number;
		var r_degrees:Number;
		var partName:String;
		var dobjName:String;
		var dobj:DisplayObj;
		var scale:Number;
		var colorTransform:ColorTransform;
		var frame:int;
		var visible:Boolean;
		var interpolate:Boolean;
		var transformedX:Number;
		var transformedY:Number;

		
		public function Clone():AnimHierarchyFramePart
		{
			var p:AnimHierarchyFramePart = new AnimHierarchyFramePart();
			p.x = x;
			p.y = y;
			p.r_degrees = r_degrees;
			p.r_degrees_original = r_degrees_original;
			p.partName = partName;
			p.dobjName = dobjName;
			p.scale = scale;
			p.colorTransform = Utils.CopyColorTransform(colorTransform);
			p.frame = frame;
			p.visible = visible;
			p.interpolate = interpolate;
			p.dobj = dobj;
			return p;
		}
		
		public function AnimHierarchyFramePart() 
		{
			colorTransform = null;
			frame = 0;
			visible = true;
			interpolate = true;
			dobj = null;
		}
		
	}

}