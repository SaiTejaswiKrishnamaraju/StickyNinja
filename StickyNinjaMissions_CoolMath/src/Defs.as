package  
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Default
	*/
	public class Defs 
	{
		
		public static const maxParticles:int = 70;
		public static const maxGameObjects:int = 200;
		public static const maxStaticGameObjects:int = 300;

		public static const editor_area_w:int = 1300;
		public static const editor_x:int = 800;
		
		public static const displayarea_w:int = 800;
		public static const displayarea_h:int = 512;
		public static const gamearea_h:int = 512;
		public static const displayarea_w2:int = 800/2;
		public static const displayarea_h2:int = 512/2;
		public static var update_fps:Number = 60;
		public static var fps:Number = 60;
		public static var ui_fps:Number = 60;
		
		public static var screenRect:Rectangle = new Rectangle(0, 0, displayarea_w, displayarea_h);
		public static var pointZero:Point = new Point(0, 0);
		
		public function Defs() 
		{

		}
		
	}
	
}