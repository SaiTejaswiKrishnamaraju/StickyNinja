package  
{
	if (PROJECT::isMobile)
	{
		import com.adobe.errors.IllegalStateError;
		import flash.events.TouchEvent;
	}
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class MultiTouchHandler 
	{
		
		static var items:Vector.<MultiTouchItem>;
		static var maxItems:int = 10;
		
		public static var singleReleased:Boolean = false;
		public static var singleX:Number = 0;
		public static var singleY:Number= 0;
		public static var singleDown:Boolean = false;
		public static var singleID:int;
		
		public static function InitForLevel()
		{
			singleReleased = false;
			singleDown = false;
			singleID = -1;
		}
		
		public static var lastTouchPointNormalisedX:Number = 0;
		public static var lastTouchPointNormalisedY:Number = 0;
		public static var lastTouchPointX:Number;
		public static var lastTouchPointY:Number;
		public static var lastTouchPointScreenX:Number;
		public static var lastTouchPointScreenY:Number;
		
		public static function TestAreaDown(r:Rectangle):Boolean
		{
			for each(var item:MultiTouchItem in items)
			{
				if (item.IsActive())
				{
					if (r.containsPoint(new Point(item.x, item.y))) 
					{
						lastTouchPointNormalisedX = Utils.ScaleToPreLimit( -1, 1, r.left, r.right, item.x);
						lastTouchPointNormalisedY = Utils.ScaleToPreLimit( -1, 1, r.top, r.bottom, item.y);
						lastTouchPointX = item.x - (r.left + (r.width / 2));
						lastTouchPointY = item.y - (r.top + (r.height / 2));
						lastTouchPointScreenX = item.x;
						lastTouchPointScreenY = item.y;
						return true;
					}
				}
			}
			return false;
		}
		
		public static function TestAreaPressed(r:Rectangle):Boolean
		{
			for each(var item:MultiTouchItem in items)
			{
				if (item.IsActive())
				{
					if (item.justPressed)
					{
						item.justPressed = false;
						if (r.containsPoint(new Point(item.x, item.y))) return true;
						
					}
				}
			}
			return false;
		}
		
		static function GetItemByTouchID(id:int):MultiTouchItem
		{
			trace("GetItemByTouchID " + id);
			for each(var item:MultiTouchItem in items)
			{
				if (item.touchID == id) return item;
			}
			return null;
		}
		static function GetFreeItem():MultiTouchItem
		{
			trace("GetFreeItem");
			for each(var item:MultiTouchItem in items)
			{
				if (item.touchID == -1) 
				{
					item.justPressed = false;
					return item;
				}
			}
			return null;
		}

		static function GetOrAddItemByTouchID(id:int):MultiTouchItem
		{
			trace("GetOrAddItemByTouchID " + id);
			var item:MultiTouchItem = GetItemByTouchID(id);
			if (item == null)
			{
				item = GetFreeItem();
				item.touchID = id;

			}
			return item;
		}
		
		public function MultiTouchHandler() 
		{
			
		}

		
		public static function Exit()
		{
			if (PROJECT::isMobile)
			{
				//Game.main.stage.removeEventListener(TouchEvent.TOUCH_TAP, touchTapHandler);
				Game.main.stage.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
				Game.main.stage.removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);
				Game.main.stage.removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			}
			
		}
		public static function Init()
		{
			items = new Vector.<MultiTouchItem>();
			for (var i:int = 0; i < maxItems; i++)
			{
				items.push(new MultiTouchItem());
			}
			
			if (PROJECT::isMobile)
			{
				//Game.main.stage.addEventListener(TouchEvent.TOUCH_TAP, touchTapHandler);
				Game.main.stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
				Game.main.stage.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
				Game.main.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			}
			InitForLevel();
		}
		
		
		if (PROJECT::isMobile)
		{
		static function touchTapHandler(e:TouchEvent)
		{
			trace("touch tap");
			var x:Number = ScreenSize.XtoUnit(e.stageX);
			var y:Number = ScreenSize.YtoUnit(e.stageY);

		}

		
		static function touchMoveHandler(e:TouchEvent)
		{
			trace("touch move");
			var x:Number = ScreenSize.XtoUnit(e.stageX);
			var y:Number = ScreenSize.YtoUnit(e.stageY);
			
			//var s:String = "BEGIN " + e.touchPointID + ": " + int(e.stageX) + " " + int(e.stageY) +"   " + x + " " + y;
			//var go:GameObj = GameObjects.AddObj(0, 0, -1000);
			//go.InitDebugMessage(s);
			

			var scalex:Number = ScreenSize.fullScreenScale;
			var scaley:Number =  ScreenSize.fullScreenScale;			
			var mx:Number = Utils.ScaleToPreLimit(0, Defs.displayarea_w, ScreenSize.fullScreenScaleXOffset, ScreenSize.gameStageWidth - ScreenSize.fullScreenScaleXOffset, e.stageX);
			var my:Number = Utils.ScaleToPreLimit(0, Defs.displayarea_h, 0, ScreenSize.gameStageHeight, e.stageY);
			singleX = mx;
			singleY = my;
		
		
			if (singleDown == false)
			{
				singleID = e.touchPointID;
				singleDown = true;
				singleReleased = false;
			}
			
			var item:MultiTouchItem = GetOrAddItemByTouchID(e.touchPointID);
			
			if (item != null)
			{
				item.x = ScreenSize.GetScaledMousePosX(e.stageX);
				item.y = ScreenSize.GetScaledMousePosY(e.stageY);
			}

		}
			
		static function touchEndHandler(e:TouchEvent)
		{
			trace("touch end ");
			var x:Number = ScreenSize.XtoUnit(e.stageX);
			var y:Number = ScreenSize.YtoUnit(e.stageY);

			//var s:String = "END " + e.touchPointID + ": " + int(e.stageX) + " " + int(e.stageY) +"   " + x + " " + y;
			//var go:GameObj = GameObjects.AddObj(0, 0, -1000);
			//go.InitDebugMessage(s);
			
			
			if (singleDown)
			{
				if (e.touchPointID == singleID)
				{
					singleReleased = true;
					singleDown = false;
				}
			}
			var scalex:Number = ScreenSize.fullScreenScale;
			var scaley:Number =  ScreenSize.fullScreenScale;			
			var mx:Number = Utils.ScaleToPreLimit(0, Defs.displayarea_w, ScreenSize.fullScreenScaleXOffset, ScreenSize.gameStageWidth - ScreenSize.fullScreenScaleXOffset, e.stageX);
			var my:Number = Utils.ScaleToPreLimit(0, Defs.displayarea_h, 0, ScreenSize.gameStageHeight, e.stageY);
			singleX = mx;
			singleY = my;
			
			var item:MultiTouchItem = GetItemByTouchID(e.touchPointID);
			if (item != null)
			{
				item.MakeInactive();
			}
			
		}
		static function touchBeginHandler(e:TouchEvent)
		{
		trace("touch begin");
			
		
			var x:Number = ScreenSize.XtoUnit(e.stageX);
			var y:Number = ScreenSize.YtoUnit(e.stageY);
			
			//var s:String = "BEGIN " + e.touchPointID + ": " + int(e.stageX) + " " + int(e.stageY) +"   " + x + " " + y;
			//var go:GameObj = GameObjects.AddObj(0, 0, -1000);
			//go.InitDebugMessage(s);
			

			var scalex:Number = ScreenSize.fullScreenScale;
			var scaley:Number =  ScreenSize.fullScreenScale;			
			var mx:Number = Utils.ScaleToPreLimit(0, Defs.displayarea_w, ScreenSize.fullScreenScaleXOffset, ScreenSize.gameStageWidth - ScreenSize.fullScreenScaleXOffset, e.stageX);
			var my:Number = Utils.ScaleToPreLimit(0, Defs.displayarea_h, 0, ScreenSize.gameStageHeight, e.stageY);
			singleX = mx;
			singleY = my;
		
		
			if (singleDown == false)
			{
				singleID = e.touchPointID;
				singleDown = true;
				singleReleased = false;
			}
			
			var item:MultiTouchItem = GetOrAddItemByTouchID(e.touchPointID);
			
			if (item != null)
			{
				item.x = ScreenSize.GetScaledMousePosX(e.stageX);
				item.y = ScreenSize.GetScaledMousePosY(e.stageY);

//				item.x = x;
//				item.y = y;
				item.justPressed = true;
			}

		}
		}
		
		
		
	}

}