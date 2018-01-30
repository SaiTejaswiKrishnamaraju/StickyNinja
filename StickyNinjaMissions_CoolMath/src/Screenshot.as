package  
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Julian
	 */
	public class Screenshot 
	{
		
		public function Screenshot() 
		{
			
		}
		
		
		static var currentDrawScreenAbsoluteRectangle:Rectangle;
		
		static var bitmaps:Array;
		
		public static function Level_Dump()
		{
			GameVars.takingADump = true;
			EngineDebug.StartImmediateTimer();
			
			var bRect:Rectangle = Game.boundingRectangle.clone();
			
			var bd:BitmapData = new BitmapData(bRect.width, bRect.height, false, 0);

			Game.camera.PushPos();
			Game.camera.x = bRect.x;
			Game.camera.y = bRect.y;
			GameObjects.Render(bd);
			Game.camera.PopPos();
			
			GameVars.takingADump = false;
			
			
			var fr:FileReference = new FileReference();
			fr.addEventListener(Event.COMPLETE, Level_Dump_OneComplete);
			

			var l:Level = Levels.GetCurrent();
			var lname:String = l.name;
			lname = lname.replace(" ", "_");
			lname = lname.replace("/", "_");
			var name:String = "screenshot_level_" + (Levels.currentIndex + 1) + "__" + lname+".png";

			// pngs
			var ba:ByteArray = PNGEncoder.encode(bd);
			fr.save(ba, name);
			
			Utils.print("saved level screenshot " + name + "  " + bRect);
			
			
		}
		
		static function Level_Dump_OneComplete(e:Event)
		{
			EngineDebug.StopImmediateTimer("Level_Dump");			
		}
		
		
	}

}