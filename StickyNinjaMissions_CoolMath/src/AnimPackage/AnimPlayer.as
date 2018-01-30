package AnimPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class AnimPlayer 
	{
		public var go:GameObj;
		public var pos:Number;
		public var frame:Number;
		public var def:AnimDefinition;
		public var speed:Number;
		
		public function CycleAnimation():Boolean
		{
			var retval:Boolean = false;
			pos += speed;
			if (pos < 0)
			{
				retval = true;
				pos = def.frames.length - 1;
			}
			if (pos >= def.frames.length)
			{
				retval = true;
				pos = 0;
			}
			frame = def.frames[int(pos)];
			go.frame = frame;
			return retval;
		}

		public function PlayAnimation():Boolean
		{
			var retval:Boolean = false;
			pos += speed;
			if (pos < 0)
			{
				retval = true;
				pos = 0;
			}
			if (pos >= def.frames.length)
			{
				retval = true;
				pos = def.frames.length - 1;
			}
			frame = def.frames[int(pos)];
			go.frame = frame;
			return retval;
		}

		public function SetRandom(reset:Boolean,... args)
		{
			var r:int = Utils.RandBetweenInt(0, args.length - 1);
			Set(args[r], reset);
		}
		
		
		public function Set(name:String, reset:Boolean=true)
		{
			def = AnimDefinitions.Get(name);
			go.dobj = GraphicObjects.GetDisplayObjByName(def.mcName);
			
			if (reset)
			{
				pos = 0;
			}
			else
			{
				if (pos >= def.frames.length) pos = def.frames.length - 1;
			}
			frame = def.frames[int(pos)];	
			speed = def.speed;
			go.frame = frame;
			go.xflip = def.xflip;
		}
		
		public function AnimPlayer(_go:GameObj) 
		{
			go = _go;
		}
		
	}

}