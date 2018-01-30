package EditorPackage 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class EditorLayers 
	{
		static var layers:Vector.<EditorLayer>;
		static var layersMC:MovieClip;
		
		public function EditorLayers() 
		{
			
		}
		
		public static function InitOnce()
		{
			layers = new Vector.<EditorLayer>();
			layers.push(new EditorLayer(0, "Layer 1"));
			layers.push(new EditorLayer(1, "Layer 2"));
			layers.push(new EditorLayer(2, "Layer 3"));
			layers.push(new EditorLayer(3, "Layer 4"));
			
			layers[0].active = true;
			
			layersMC = new MovieClip();
			var y:int = 0;
			for each(var l:EditorLayer in layers)
			{
				l.mc.y = y;
				layersMC.addChild(l.mc);
				y += 20;				
			}
			UpdateUI();
		}
		
		public static function UpdateUI()
		{
			for each(var l:EditorLayer in layers)
			{
				l.UpdateUI();
			}
		}
		public static function GetContainer():MovieClip
		{
			return layersMC;
		}
		public static function ShowUI(show:Boolean)
		{
			
		}
		
		public static function GetName(index:int):String
		{
			return layers[index].name;
		}
		public static function ToggleVisibility(index:int)
		{
			layers[index].ToggleVisibility();
		}

		public static function ToggleUIVisibility()
		{
			layersMC.visible = (layersMC.visible == false);
		}
		
		public static function SetActive(index:int)
		{
			for each(var l:EditorLayer in layers)
			{
				l.active = false;
			}
			layers[index].active = true;
		}

		// returns index+1 (1-4)
		public static function GetActive():int
		{
			for each(var l:EditorLayer in layers)
			{
				if (l.active) return l.index+1;
			}
			return 0;
		}
		
		
		public static function ToggleLocked(index:int)
		{
			layers[index].ToggleLocked();
		}
		public static function IsVisible(index:int):Boolean
		{
			return layers[index].IsVisible();
		}
		public static function IsLocked(index:int):Boolean
		{
			return layers[index].IsLocked();
		}
		
	}

}