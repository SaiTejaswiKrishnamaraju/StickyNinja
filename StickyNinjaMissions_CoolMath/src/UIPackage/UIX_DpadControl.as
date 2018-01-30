package UIPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class UIX_DpadControl 
	{
		public var from:String;
		public var up:String;
		public var down:String;
		public var left:String;
		public var right:String;
		public var hoverCallback:Function;
		
		public static const DIR_UP:int = 0;
		public static const DIR_RIGHT:int = 1;
		public static const DIR_DOWN:int = 2;
		public static const DIR_LEFT:int = 3;
		
		public function UIX_DpadControl(_from:String="",_up:String="",_right:String="",_down:String="",_left:String="") 
		{
			from = _from;
			up = _up;
			right = _right;
			down = _down;
			left = _left;
			hoverCallback = null;
			
		}
		
		public function GetByIndex(index:int):String
		{
			if (index == 0) return up;
			if (index == 1) return right;
			if (index == 2) return down;
			if (index == 3) return left;
			return up;
		}
		
		
		public function Clone():UIX_DpadControl
		{
			var ctrl:UIX_DpadControl = new UIX_DpadControl(from, up, right, down, left);
			ctrl.hoverCallback = hoverCallback;
			return ctrl;
		}
		
		public function ToXML():String
		{
			var s:String = "";
			s += '<dpad from="' + from +'" ';
			s += 'up="' + up +'" ';
			s += 'right="' + right +'" ';
			s += 'down="' + down +'" ';
			s += 'left="' + left +'" ';			
			s += '/>';
			return s;			
		}
		
		public function FromXML(xml:XML)
		{
			from = XmlHelper.GetAttrString(xml.@from, "");
			up = XmlHelper.GetAttrString(xml.@up, "");
			right = XmlHelper.GetAttrString(xml.@right, "");
			down = XmlHelper.GetAttrString(xml.@down, "");
			left = XmlHelper.GetAttrString(xml.@left, "");
		}


		
		
	}

}