package  
{
	import AchievementPackage.Achievement;
	/**
	 * ...
	 * @author 
	 */
	public class GrassFrame 
	{
		var mcName:String;
		var frameIndex:int;
		var dof:DisplayObjFrame;
		var dofs:Vector.<DisplayObjFrame>;
		var scales:Vector.<Number>;
		var rots:Vector.<int>;
		
		public function GrassFrame(_index:int,_name:String) 
		{
			frameIndex = _index;
			mcName = _name;
			dofs = new Vector.<DisplayObjFrame>();
			scales = new Vector.<Number>();
			rots = new Vector.<int>();
		}
		
		public function AddDof(dof:DisplayObjFrame, scale:Number,_rotint:int)
		{
			dofs.push(dof);
			scales.push(scale);
			rots.push(_rotint);
		}
		
		public function GetNearestScaleFrame(scale:Number)
		{
			var bestI:int = 0;
			var bestD:Number = 9999;
			for (var i:int = 0; i < dofs.length; i++)
			{
				var s:Number = scales[i];
				var d:Number = Math.abs(s - scale);
				if (d < bestD)
				{
					bestD = d;
					bestI = i;
				}
			}
			return bestI;
		}
		
	}

}