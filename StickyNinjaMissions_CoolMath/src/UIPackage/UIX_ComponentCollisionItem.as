package UIPackage 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class UIX_ComponentCollisionItem 
	{
		public var type:String;
		public var rect:Rectangle;
		public var circlePos:Point;
		public var circleRadius:Number;
		
		
		public function UIX_ComponentCollisionItem() 
		{
			rect = new Rectangle();
			circlePos = new Point();
		}
		
		public function Clone()
		{
			var item:UIX_ComponentCollisionItem = new UIX_ComponentCollisionItem();
			item.type = type;
			item.rect = rect.clone();
			item.circlePos = circlePos.clone();
			item.circleRadius = circleRadius;
			return item;
		}
		public function InitRect(r:Rectangle)
		{
			rect = r.clone();
			type = "rectangle";
		}
		public function FromXML(xml:XML)
		{
			type = XmlHelper.GetAttrString(xml.@type, "null");
			var values:String = XmlHelper.GetAttrString(xml.@values, "0,0,0,0");
			var va:Array = values.split(",");
			
			if (type == "rectangle")
			{
				rect = new Rectangle(va[0], va[1], (va[2] - va[0]) + 1, (va[3] - va[1]) + 1);
				Utils.print("colrect " + rect);
			}
			else if (type == "circle")
			{
				circlePos = new Point(va[0], va[1]);
				circleRadius = va[2];
			}
		}
		

		public function ToXML():String
		{
			var s:String = "";
			s += '<collision type="' + type +'" ';
			
			if (type == "rectangle")
			{
				s += 'values="' + rect.x + ','+ rect.y + ',' + int(rect.right-1) + ',' + int(rect.bottom-1) + '" ';
			}
			else if (type == "circle")
			{
				s += 'values="' + circlePos.x + ','+ circlePos.y + ',' + circleRadius + '" ';
			}
			s += ' />';
			return s;			
		}
		
		
		public function DoHitTest(x:Number, y:Number, m:Matrix3D):Boolean		
		{
			if (type == "rectangle") 
			{
				var r1:Rectangle = Utils.Matrix3DTransformRectangle(m, rect);
				return r1.contains(x, y);
			}
			else if (type == "circle")
			{
				var p0:Point = Utils.Matrix3DTransformPoint(m, circlePos);
				var radP:Point = Utils.Matrix3DTransformPoint(m, new Point(circleRadius, 0));
				var len:Number = circleRadius;	// radP.length;
				if (Utils.DistBetweenPoints(x, y, p0.x,p0.y) < len) return true;
			}
			return false;
		}

		public function DoHitTestRect(r:Rectangle, m:Matrix3D):Boolean		
		{
			if (type == "rectangle") 
			{
				var r1:Rectangle = Utils.Matrix3DTransformRectangle(m, rect);
				var intersection:Rectangle = r1.intersection(r);
				if (intersection.width == 0) return false;
				if (intersection.height == 0) return false;
				return true;
			}
			else if (type == "circle")
			{
				trace("DoHitTestRect circle collision not implemented");
				return false;
			}
			return false;
		}
		
		public function Render(bd:BitmapData, m:Matrix3D,_xoff:Number=0,_yoff:Number=0,color:uint = 0xffff00ff)		
		{
			if (type == "rectangle") 
			{
				var r1:Rectangle = Utils.Matrix3DTransformRectangle(m, rect);
				r1.x += _xoff;
				r1.y += _yoff;
				Utils.RenderRectangle(bd, r1, color);
			}
			else if (type == "circle")
			{
				var p0:Point = Utils.Matrix3DTransformPoint(m, circlePos);
				var radP:Point = Utils.Matrix3DTransformPoint(m, new Point(circleRadius, 0));
				var len:Number = circleRadius;	// radP.length;
				Utils.RenderCircle(bd, p0.x+_xoff, p0.y+_yoff, len, color);
			}
		}
		
		
	}

}