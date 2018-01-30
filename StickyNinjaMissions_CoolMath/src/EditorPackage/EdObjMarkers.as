package EditorPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class EdObjMarkers 
	{
		public var markers:Vector.<EdObjMarker>;
		
		public function EdObjMarkers() 
		{
			markers = new Vector.<EdObjMarker>();
		}

		public function Delete(m:EdObjMarker)
		{
			var index:int = markers.indexOf(m);
			if (index != -1)
			{
				markers.splice(index, 1);
			}
		}
		public function Count():int
		{
			return markers.length;
		}
		public function Get(index:int):EdObjMarker
		{
			return markers[index];
		}
		public function GetList():Vector.<EdObjMarker>		
		{
			return markers;
		}
		public function GetListByType(type:String):Vector.<EdObjMarker>		
		{
			var v:Vector.<EdObjMarker> = new Vector.<EdObjMarker>();
			for each(var m:EdObjMarker in markers)
			{
				if (m.type == type)
				{
					v.push(m);
				}
			}
			return v;
		}
		public function GetSingleByType(type:String):EdObjMarker
		{
			for each(var m:EdObjMarker in markers)
			{
				if (m.type == type)
				{
					return m;
				}
			}
			return null;
		}
		
		public function Add(x:Number, y:Number, type:String, data:String, radius:Number):EdObjMarker
		{
			var m:EdObjMarker = new EdObjMarker();
			m.xpos = x;
			m.ypos = y;
			m.type = type;
			m.data = data;
			m.radius = radius;		
			markers.push(m);
			return m;
		}
		public function TestPickLocalSpace(x:int,y:int):EdObjMarker
		{
			for each(var m:EdObjMarker in markers)
			{
				var d:Number = Utils.DistBetweenPoints(x, y, m.xpos, m.ypos);
				if (d < m.radius)
				{
					return m;
				}
			}
			return null;
		}
		
		public function FromXML(x:XML)
		{
			for (var i:int = 0; i < x.marker.length(); i++)
			{
				var mx:XML = x.marker[i];
				var m:EdObjMarker = new EdObjMarker();
				m.frame = XmlHelper.GetAttrNumber(mx.@frame, 0);
				m.xpos = XmlHelper.GetAttrNumber(mx.@x, 0);
				m.ypos = XmlHelper.GetAttrNumber(mx.@y, 0);
				m.radius = XmlHelper.GetAttrNumber(mx.@radius, 10);
				m.type = XmlHelper.GetAttrString(mx.@type, "");
				m.data = XmlHelper.GetAttrString(mx.@data, "");
				m.UpdateParams();
				markers.push(m);
			}
		}
		
		public function ToXml():String
		{
			var s:String = "";
			for each(var m:EdObjMarker in markers)
			{
				s += '\t<marker ';
				s += 'frame="'+m.frame+'" ';
				s += 'x="'+m.xpos+'" ';
				s += 'y="'+m.ypos+'" ';
				s += 'type="'+m.type+'" ';
				s += 'radius="'+m.radius+'" ';
				s += 'data="' + m.data + '" />';
				s += '\n';
			}
			return s;
		}
		
	}

}