package  
{
	if(PROJECT::useStage3D)
	{
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
	}
	import MissionPackage.Missions;
	import flash.utils.ByteArray;
	import AchievementPackage.Achievements;
	import flash.system.System;
	import flash.net.SharedObject;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class SaveData 
	{
		
		public function SaveData() 
		{
			

		}

		static var id:String = "stickninjamissions/stickyninjamissions_9995";
		
		
		
		public static function Exists():Boolean
		{
			if (Game.doWalkthrough) return false;
			var so:SharedObject = SharedObject.getLocal(id);
			if (so == null)
			{				
				trace("Shared Object: "+id+" null")
				return false;
			}
			if (so.size == 0)
			{
				trace("Shared Object: " + id + " size 0")
				so.close();
				return false;
			}

			so.close();
			return true;			
		}
		
		public static function Load():void
		{
			if (Game.doWalkthrough) return;
			var so:SharedObject = SharedObject.getLocal(id);
			if (so == null)
			{
				trace("Shared Object: "+id+" is null")
				return;
			}
			if (so.size == 0)
			{
				trace("Shared Object: " + id + " size=0")
				so.close();				
				return;
			}
			
			var ba:ByteArray = Base64.decode(so.data.str);
			ba.uncompress();
			var data0:int = ba.readInt();
			var data1:int = ba.readInt();
			var data2:int = ba.readInt();
			var data3:int = ba.readInt();
						
	
//			Levels.FromByteArray(ba);
			Missions.FromByteArray(ba);
			GameVars.FromByteArray(ba);
//			Stats.FromByteArray(ba);
//			Achievements.FromByteArray(ba);
			
			so.close();
			Utils.print("Loaded data OK");

			

		}
		
		
		public static function DontLoad():void
		{			
		}

		
		public static function Clear():void
		{
			if (Game.doWalkthrough) return;
			var so:SharedObject = SharedObject.getLocal(id);
			so.clear();
			so.close();
			so.flush();
			trace("SaveData Data Cleared");
			trace("len: " + so.size);
		}
		
		public static function DontSave():void
		{

		}

		public static function Save():void
		{
			
			if (Game.doWalkthrough) return;
			var i:int;
			var so:SharedObject = SharedObject.getLocal(id);
			if (so == null)
			{
				trace("SO null") ;
				return;
			
			}
			if (so.size == 0)
			{
				trace("SO size 0");
			}
//			if (so == null) return;
			so.clear();
			
			var ba:ByteArray = new ByteArray();
			ba.writeInt(0);	//version
			ba.writeInt(0);	//a
			ba.writeInt(0);	//b
			ba.writeInt(0);	//c
			
//			Levels.ToByteArray(ba);
			Missions.ToByteArray(ba);
			GameVars.ToByteArray(ba);
//			Stats.ToByteArray(ba);
//			Achievements.ToByteArray(ba);
			
			var byteStringA:String = Base64.encode(ba);
			ba.compress();
			
			
			var byteStringB:String = Base64.encode(ba);
			
			
			
//			trace(byteStringA);
//			trace(byteStringB);
			
			so.data.str = byteStringB;

			so.close();
			
			MobileSave(ba);

		}

		static function MobileSave(ba:ByteArray)
		{
			if(PROJECT::useStage3D)
			{
				var fs:FileStream = new FileStream();
				var file:File = File.applicationStorageDirectory.resolvePath("savedata/"+id);
				fs.open(file, FileMode.WRITE);
				fs.writeBytes(ba, 0, ba.length);
				fs.close();
				trace("The file is written.");
				trace(file.nativePath); // you can find where it is stored.
			}
		}
		
	}
	
}