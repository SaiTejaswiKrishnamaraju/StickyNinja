package  AnimPackage 
{
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author 
	 */
	public class AnimHierarchyFrame 
	{
		public var parts:Vector.<AnimHierarchyFramePart>;
		var vertexBufferIndex:int;
		var vertexBufferStartIndex:int;
		var vertexBufferLength:int;
		
		public function Clone():AnimHierarchyFrame
		{
			var f:AnimHierarchyFrame = new AnimHierarchyFrame();
			f.parts = new Vector.<AnimHierarchyFramePart>();
			for each(var p:AnimHierarchyFramePart in parts)
			{
				f.parts.push(p.Clone());
			}
			f.vertexBufferIndex = vertexBufferIndex;
			return f;
		}
		
		public function AnimHierarchyFrame() 
		{
			parts = new Vector.<AnimHierarchyFramePart>();
			vertexBufferIndex = -1;
			vertexBufferStartIndex = 0;
			vertexBufferLength = 0;
		}
		
	}

}