package UIPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class UIX_PageDef 
	{
		var name:String;
		var instances:Vector.<UIX_Instance>;
		var timeLines:Vector.<UIX_TimeLine>;
		var dPadControls:Vector.<UIX_DpadControl>;
		
		public function UIX_PageDef() 
		{
			
		}
		
		public function SetDpadControls(from:String, up:String, right:String, down:String, left:String)
		{
			dPadControls.push(new UIX_DpadControl(from, up, right, down, left)); 
		}
		public function RemoveDpadControl(ctrl:UIX_DpadControl)
		{
			dPadControls = dPadControls.splice(dPadControls.indexOf(ctrl), 1);
		}
		public function GetDpadControlByFromName(name:String):UIX_DpadControl
		{
			for each(var ctrl:UIX_DpadControl in dPadControls)
			{
				if (ctrl.from == name) return ctrl;
			}
			return null;
		}
		
		public function GetInstances():Vector.<UIX_Instance>
		{
			return instances;
		}
		public function SetInstances(_instances:Vector.<UIX_Instance>)
		{
			instances = _instances;
		}
		
		public function FromXML(xml:XML)
		{
			instances = new Vector.<UIX_Instance>();
			timeLines = new Vector.<UIX_TimeLine>();
			dPadControls = new Vector.<UIX_DpadControl>();
			
			name = XmlHelper.GetAttrString(xml.@name, "undefined_name");
			
			var num:int = xml.instance.length();
			for (var i:int = 0; i < num; i++)
			{
				var x:XML = xml.instance[i];
				var instance:UIX_Instance = new UIX_Instance();
				instance.parentInst = null;
				instance.FromXML(x);
				instances.push(instance);
			}			
			
			
			var num:int = xml.timeline.length();
			for (var i:int = 0; i < num; i++)
			{
				var x:XML = xml.timeline[i];
				var tl:UIX_TimeLine = new UIX_TimeLine();
				tl.FromXML(x);
				timeLines.push(tl);
			}			

			var num:int = xml.dpad.length();
			for (var i:int = 0; i < num; i++)
			{
				var x:XML = xml.dpad[i];
				var dp:UIX_DpadControl = new UIX_DpadControl();
				dp.FromXML(x);
				dPadControls.push(dp);
			}			
			
			Validate();
		}
		
		function Validate()
		{
			var instNames:Array = new Array();
			for each(var inst:UIX_Instance in instances)
			{
				var s:String = inst.GetInstanceName();
				if (s != "")
				{
					if (instNames.indexOf(s) != -1)
					{
						trace("error, duplicate instance name: " + s);
						var a:int = 0;
					}
				}
				instNames.push(s);
			}
		}
		
		public function ToXML():String
		{
			var s:String = "";
			s += '<page name="' + name + '">';
			s += "\n";
			for each(var inst:UIX_Instance in instances)
			{
				s += inst.ToXML();
				s += "\n";
			}
			
			for each(var tl:UIX_TimeLine in timeLines)
			{
				s += tl.ToXML();
				s += "\n";
			}
			
			for each(var ctrl:UIX_DpadControl in dPadControls)
			{
				s += ctrl.ToXML();
				s += "\n";
			}
			s += '</page>';
			return s;			
		}
		
		
	}

}