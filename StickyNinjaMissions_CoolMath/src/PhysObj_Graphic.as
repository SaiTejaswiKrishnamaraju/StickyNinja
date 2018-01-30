package 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PhysObj_Graphic 
	{
		public var graphicName:String;
		public var frame:int;
		public var offset:Point;
		public var rot:Number;
		
		public function PhysObj_Graphic() 
		{
			graphicName = "";
			frame = 0;
			offset = new Point(0, 0);
			rot = 0;

		}
		
	//		<graphic clip = "bomb_squad" frame = "1" pos = "0,0" rot="0" zoffset="0" />					
	
		public function ToXML():String
		{
			var s:String = "";
			s += '<graphic clip="' + graphicName + '" ';
			s += 'frame="' + int(frame+1) + '" ';
			s += 'pos="' + offset.x+','+offset.y + '" ';
			s += 'rot="' + rot + '" />';
			
			s += '\n';
			
			return s;			
		}
		
		public function Calculate()
		{
		}
		
	}
	
}