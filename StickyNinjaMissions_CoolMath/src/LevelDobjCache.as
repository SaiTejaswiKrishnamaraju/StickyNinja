package  
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import TexturePackage.PreparingModifier;
	/**
	 * ...
	 * @author ...
	 */
	public class LevelDobjCache 
	{
		static var list:Vector.<DisplayObj>;
		
		
		public function LevelDobjCache() 
		{
			
		}
		
		public static function InitOnce()
		{
			list = new Vector.<DisplayObj>();
		}
		
		
		public static function InitForLevel()
		{
			list = new Vector.<DisplayObj>();
		}
		
		public static function ExitForLevel()
		{
			
		}
		
		
		public static function Add(mcName:String,modifier:PreparingModifier,scale:Number,_frameCB:Function):DisplayObj
		{
			var classRef:Class = null;
			
			try
			{
				classRef = getDefinitionByName(mcName) as Class;
			}
			catch (e:Error)
			{
				Utils.traceerror("LevelDobjCache - can't find obj: " + mcName);
				return null;
			}
			var mc:MovieClip = new classRef() as MovieClip
			var dobj:DisplayObj = new DisplayObj(mc , scale, modifier,_frameCB);
			list.push(dobj);
			mc = null;
			
			//Utils.print("LevelDobjCache: Added " + mcName + ".  ListLen:" + list.length);
			
			return dobj;
		}
		
		
	}

}