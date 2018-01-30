package EditorPackage.Menu 
{
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import UIPackage.UI;
	/**
	 * ...
	 * @author 
	 */
	public class ButtonMenu 
	{
		
		public var mc:MovieClip;
		public var buttons:Array;
		public var add_y:Number;
		
		public function ButtonMenu() 
		{
			buttons = new Array();
			add_y = 0;
			mc = new MovieClip();
			
		}
		
		public function AddItem(_txt:String,_func:Function,_testFunc:Function=null)
		{
			var b:ButtonMenuButton = new ButtonMenuButton(_txt,_func,_testFunc);
			b.mc.x = 0;
			b.mc.y = add_y;
			buttons.push(b);
			
			add_y += 20;
			mc.addChild(b.mc);
		}
		
		public function AddSpacer()
		{
			add_y += 10;
		}

		public static var greyFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0]);
		public static var blackFilter:ColorMatrixFilter = new ColorMatrixFilter([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0]);
		
		public function Update()
		{
			for each(var b:ButtonMenuButton in buttons)
			{
				if (b.testFunc != null)
				{
					b.state = b.testFunc(b);
					if (b.state == ButtonMenuButtonState.NORMAL)
					{
						b.mc.filters = [];
					}					
					else if (b.state == ButtonMenuButtonState.GREYED)
					{
						b.mc.filters = [greyFilter];
					}
					else if (b.state == ButtonMenuButtonState.HIDDEN)
					{
						b.mc.filters = [blackFilter];
					}
				}
			}
		}
		
	}

}