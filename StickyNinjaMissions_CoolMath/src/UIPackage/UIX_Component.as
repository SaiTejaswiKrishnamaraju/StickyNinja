package UIPackage 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author 
	 */
	public class UIX_Component 
	{
		public static const TYPE_NORMAL:String = "normal";
		public static const TYPE_DRAGBOX:String = "dragbox";
		public static const TYPE_TEXT:String = "text";
		public static const TYPE_INPUTTEXT:String = "inputtext";
		
		public var name:String;
		public var mcName:String;
		public var frame:int;
		public var type:String;
		public var uiPage:int;
		public var autoType:String;		// this defines a button action type. maybe it should be called that. eg. Facebook, more games, etc.
		
		var instances:Vector.<UIX_Instance>;
		var collisions:Vector.<UIX_ComponentCollisionItem>;

		
		public var dobj:DisplayObj
		public var editor_mc:MovieClip;
		
		public function UIX_Component() 
		{
			name = "";
			mcName = "";
			frame = 0;
			instances = new Vector.<UIX_Instance>();
			collisions = new Vector.<UIX_ComponentCollisionItem>();
			editor_mc = null;
			dobj = null;
			type = TYPE_NORMAL;
		}

		public function GetInstances():Vector.<UIX_Instance>
		{
			return instances;
		}
		
		public function FromXML(xml:XML)
		{
			instances = new Vector.<UIX_Instance>();
			collisions = new Vector.<UIX_ComponentCollisionItem>();
			
			name = XmlHelper.GetAttrString(xml.@name, "undefined_name");
			mcName = XmlHelper.GetAttrString(xml.@mc, "");
			type = XmlHelper.GetAttrString(xml.@type, TYPE_NORMAL);
			frame = XmlHelper.GetAttrInt(xml.@frame, 1);
			autoType = XmlHelper.GetAttrString(xml.@autotype, "");
			uiPage =  XmlHelper.GetAttrInt(xml.@uipage, 0);

			var numCol:int = xml.collision.length();
			for (var i:int = 0; i < numCol; i++)
			{
				var x:XML = xml.collision[i];
				var coll:UIX_ComponentCollisionItem = new UIX_ComponentCollisionItem();
				coll.FromXML(x);
				collisions.push(coll);
			}
			
			if (collisions.length == 0)
			{
				var coll:UIX_ComponentCollisionItem = new UIX_ComponentCollisionItem();
				coll.type = "rectangle";
				coll.rect = new Rectangle(0,0,16,16);
				collisions.push(coll);				
			}
			
			var num:int = xml.instance.length();
			for (var i:int = 0; i < num; i++)	
			{
				var x:XML = xml.instance[i];
				var instance:UIX_Instance = new UIX_Instance();
				instance.FromXML(x);
				instances.push(instance);
			}
			
			editor_mc = null;
			
			if (PROJECT::isFinal == false)
			{
				if (mcName != "")
				{
					var classRef:Class;
					editor_mc = new MovieClip();
					try
					{
					
						classRef = getDefinitionByName(mcName) as Class;
						editor_mc = new classRef() as MovieClip;				
					}
					catch (e)
					{
						Utils.traceerror("ERROR, can't find movieclip: " + mcName);
					}
				}
			}
			
		}

		
		public function ToXML():String
		{
			var s:String = "";
			s += '<component name="' + name +'" ';
			s += 'type="' + type+'" ';
			s += 'mc="' + mcName+'" ';
			s += 'frame="' + frame+'" ';
			s += 'autotype="' + autoType+'" ';
			s += 'uipage="' + uiPage+'" ';
			s += '>';

			s += "\n";
			for each(var coll:UIX_ComponentCollisionItem in collisions)
			{
				s += " "+coll.ToXML();
				s += "\n";
			}
			for each(var inst:UIX_Instance in instances)
			{
				s += " "+inst.ToXML();
				s += "\n";
			}
			s += '</component>';
			return s;			
		}

		
		
		public function GetBoundingRect():Rectangle
		{
			if (type == TYPE_TEXT)
			{
				return new Rectangle(-50, -10, 100, 30);
				
			}
			if (type == TYPE_INPUTTEXT)
			{
				return new Rectangle(-50, -10, 100, 30);
				
			}
			
			if (editor_mc == null)
			{
				return new Rectangle(0, 0, 100,100);
			}
			return editor_mc.getBounds(null);
		}
		
		public function DoHitTest(x:Number, y:Number, m:Matrix3D):Boolean
		{
			for each(var coll:UIX_ComponentCollisionItem in collisions)
			{
				if (coll.DoHitTest(x, y, m)) return true;
			}
			return false;
		}
		public function DoHitTestRect(r:Rectangle, m:Matrix3D):Boolean
		{
			for each(var coll:UIX_ComponentCollisionItem in collisions)
			{
				if (coll.DoHitTestRect(r, m)) return true;
			}
			return false;
		}
		
		public function RenderCollision(bd:BitmapData,m:Matrix3D,_xoff:Number=0,_yoff:Number=0,color:uint = 0xffff00ff)
		{
			for each(var coll:UIX_ComponentCollisionItem in collisions)
			{
				coll.Render(bd, m,_xoff,_yoff,color);
			}
		}
		
		public function GetCollisions():Vector.<UIX_ComponentCollisionItem>
		{
			return collisions;
		}
		public function CloneCollisions():Vector.<UIX_ComponentCollisionItem>
		{
			var v:Vector.<UIX_ComponentCollisionItem> = new Vector.<UIX_ComponentCollisionItem>();
			for each(var item:UIX_ComponentCollisionItem in collisions)
			{
				v.push(item.Clone());
			}
			return v;
		}
		public function CopyInCollisions(cols:Vector.<UIX_ComponentCollisionItem>)
		{
			collisions = new Vector.<UIX_ComponentCollisionItem>();
			for each(var item:UIX_ComponentCollisionItem in cols)
			{
				collisions.push(item.Clone());
			}
		}

		public function GetCollisionBounds():Rectangle
		{
			var rect:Rectangle = new Rectangle();
			for each(var coll:UIX_ComponentCollisionItem in collisions)
			{
				rect = coll.rect.clone();
			}
			return rect;
		}
	}
}