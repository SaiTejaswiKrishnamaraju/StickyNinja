package 
{
	import flash.net.FileReference;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PhysObjs 
	{
		public var list:Array;
		
		public function PhysObjs() 
		{
			list = new Array();
			InitObjectParameters();
		}

		
		function InitObjectParameters()
		{
			ObjectParameters.AddParamString("po_name","default");
			ObjectParameters.AddParamString("po_libclass","generic");
			ObjectParameters.AddParamBool("po_hasphysics",true);
			ObjectParameters.AddParamBool("po_staticobj",false);
			ObjectParameters.AddParamString("po_initfunction", "");
		}

		
		
		public function InitFromXml(x:XML):void
		{
			list = new Array();
			var i:int;
			
			for (i = 0; i < x.physobj.length(); i++)
			{
				var px:XML = x.physobj[i];
				var physobj:PhysObj = new PhysObj();
				physobj.FromXml(px);
				list.push(physobj);
			}			
		}
		
		
		public function FindIndexByName(name:String):int
		{
			var index:int = 0;
			for each(var po:PhysObj in list)
			{
				if (po.name == name)
				{
					return index;
				}
				index++;
			}
			trace("ERROR PhysObjs FindByName " + name);
			return 0;
		}
		
		
		public function FindByName(name:String):PhysObj
		{
			for each(var po:PhysObj in list)
			{
				if (po.name == name)
				{
					return po;
				}
			}
			trace("ERROR PhysObjs FindByName " + name);
			return null;
		}
		
		public function GetNum():int
		{
			return list.length;
		}

		public function GetByIndex(index:int):PhysObj
		{
			return list[index];
		}

//----------------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------------		
		public function SaveXML()
		{
			var sss:String = "";
			sss += "<data>\n";
			
			for each(var po:PhysObj in list)
			{
				sss += po.ToXML();
				sss += "\n";				
			}
			
			sss += "</data>\n";
			trace(sss);
			
			var fileRef:FileReference;
			fileRef = new FileReference();
			fileRef.save(sss,"Objects_Data.xml");			
		}
		
		
	}
	
}