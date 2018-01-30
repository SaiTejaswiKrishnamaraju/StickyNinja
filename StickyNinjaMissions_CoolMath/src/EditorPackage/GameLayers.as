package EditorPackage 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class GameLayers 
	{
		static var layers:Vector.<GameLayer>;
		static var nameDictionary:Dictionary
		
		public function GameLayers() 
		{
			
		}
		
		public static function GetZPosByName(name:String):Number
		{
			if (nameDictionary[name] == undefined) return 0;
			return nameDictionary[name].zpos;
		}
		public static function GetByName(name:String):GameLayer
		{
			if (nameDictionary[name] == undefined) return null;
			return nameDictionary[name];
		}
		public static function InitOnce()
		{
			var x:XML = ExternalData.GameLayersXML;
			layers = new Vector.<GameLayer>();
			nameDictionary = new Dictionary();
			for (var i:int = 0; i < x.gamelayer.length(); i++)
			{
				var lx:XML = x.gamelayer[i];
				var gl:GameLayer = new GameLayer();
				gl.FromXML(lx);
				layers.push(gl);
				nameDictionary[gl.name] = gl;
			}
			
			if (layers.length != 0)
			{
				var s:String = "";
				for (var i:int = 0; i < layers.length; i++)
				{
					gl = layers[i];
					s += gl.name;
					if (i != layers.length - 1)
					{
						s += ",";
					}
				}
				ObjectParameters.AddParam("game_layer", "list", layers[0].name, s);
			}
		}
		
	}

}