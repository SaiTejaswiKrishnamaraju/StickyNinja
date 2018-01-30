package MissionPackage 
{
	import flash.display.BitmapData;
	import TextPackage.TextRenderer;
	/**
	 * ...
	 * @author 
	 */
	public class MissionRenderer 
	{
		
		public function MissionRenderer() 
		{
			
		}
		
		
		static var timer:Number = 0;
		public static function RenderHUD(bd:BitmapData)
		{
			var ml:MissionLevel = Missions.GetCurrentMissionLevel();
			var s:String;
			
			var scl:Number = 1 + (Math.cos(timer) * 0.05);
			timer += 0.1;
			
			var x:Number = 30;
			var y:Number = Defs.displayarea_h - 30;
			
			for each(var mo:MissionObjective in ml.objectives)
			{
				mo.RenderHud(bd,x, y, scl);
				y -= 30;
			}
			
		}
		
	}

}