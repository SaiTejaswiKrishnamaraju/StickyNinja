package UIPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class UIX_GameObjects 
	{
		
		public function UIX_GameObjects() 
		{
			
		}
		
		public var goList:Vector.<UIX_GameObj>;
		

		public function Start()
		{
			goList = new Vector.<UIX_GameObj>();
		}
		
		public function AddInstance(inst:UIX_Instance):UIX_GameObj
		{			
			
			if (inst == null)
			{
				Utils.traceerror("ERROR - UIX_GameObjects. AddInstance inst==null. Returning dummy GameObject");
				var go:UIX_GameObj = new UIX_GameObj();
				return go;
			}
			
			var xs:Number = 1;	// ScreenSize.GetHudXScale();
			var ys:Number = 1;	// ScreenSize.GetHudYScale();
			var xo:Number = 0;	// ScreenSize.GetHudXOffset();
			var yo:Number = 0;	// ScreenSize.GetHudYOffset();
			
			for each(var go:UIX_GameObj in goList)
			{				
				if(go.active == false)
				{
					go.InitHudObject();
					
					go.uixInstance = inst;
					go.active = true;
					go.xpos = inst.x;
					go.ypos = inst.y;
					go.scaleX = inst.scaleX
					go.scaleY = inst.scaleY
					go.dir = inst.rot;
					go.alpha = inst.alpha;
					go.frame = inst.frame;
					go.startx = go.xpos;
					go.starty = go.ypos;
					inst.gameObj = go;
					return go;
				}
			}	
			
//			trace("UIX_GameObjects - adding new object");
			
			go = new UIX_GameObj();
			go.listIndex = goList.length;
			go.active = true;
			go.InitHudObject();
			
			go.uixInstance = inst;
			go.active = true;
			go.xpos = inst.x;
			go.ypos = inst.y;
			go.scaleX = inst.scaleX
			go.scaleY = inst.scaleY
			go.dir = inst.rot;
			go.alpha = inst.alpha;
			go.startx = go.xpos;
			go.starty = go.ypos;
			go.frame = inst.frame;
			inst.gameObj = go;
			
			goList.push(go);
			
			return go;
			
			
			
		} 
		
		public function Update()
		{
			for each(var go:UIX_GameObj in goList)
			{
				if (go.active) 
				{
					go.Update();
				}
			}
			for each(var go:UIX_GameObj in goList)
			{
				if (go.active)
				{
					go.uixInstance.ClearMatrixCache();
					go.uixInstance.x = go.xpos;
					go.uixInstance.y = go.ypos;
					go.uixInstance.scaleX = go.scaleX;
					go.uixInstance.scaleY = go.scaleY;
					go.uixInstance.rot =go.dir;
					go.uixInstance.alpha =go.alpha;
					go.uixInstance.frame =go.frame;
					
				}
			}
		}
		
		//function RenderGameObjects(bd:BitmapData)
		//{
		//	for each(var go:HudGameObj in goList)
		//	{
		//		if(go.active) go.Render(bd);
		//	}
		//}
		
		
	}

}