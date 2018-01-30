package PlayerRecordPackage  
{
	import com.adobe.crypto.MD5;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class PlayerRecordings 
	{
		
		static var PATH:String = "http://www.turbonuke.com/Generic_Runs_Admin/";
		static var GAME_NAME:String = "stickyninjamissions";
		static var CYCLO_KEY:String = "ahfuhea8347an38akjh3kuha8";
		
		[Embed(source = "../../bin/runs.bin", mimeType = "application/octet-stream")] 
        public static var runs_bin:Class; 
		
		public function PlayerRecordings() 
		{
			
		}
		
		public static function InitOnce()
		{
			GetRunsFromBinary();
		}
		
		public static function DeleteRunByID(runid:int,_cb:Function)
		{
			RetrieveRecording_Callback = _cb;
			
			loader_recording = new URLLoader();
			loader_recording.addEventListener(Event.COMPLETE, DeleteRunByID_Done);
			
			var req:String = PATH + "GenericRuns_GetRun.php?func=DeleteByID&raceid="+runid;
			var request:URLRequest = GetURLRequestFromPath(req);
			
			loader_recording.load(request);			
		}
		public static function DeleteRunByID_Done(event:Event)
		{
			trace(loader_recording.data);
			RetrieveRecording_Callback();
		}
		
		
		
		static var RetrieveRecording_Callback:Function;
		public static function GetAllRaceData(_cb:Function)
		{
			RetrieveRecording_Callback = _cb;
			
			loader_recording = new URLLoader();
			loader_recording.addEventListener(Event.COMPLETE, GetAllRaceData_Done);
			loader_recording.addEventListener(IOErrorEvent.IO_ERROR, GetAllRaceData_Error);
			var req:String = PATH + "GenericRuns_GetRun.php?func=GetAllRaceData&game_name=" + GAME_NAME;
			//req += "&version=" + version;	// +AddRandomValue();
			var request:URLRequest = GetURLRequestFromPath(req);
			
			loader_recording.load(request);			
		}
		
		
		public static var serverTrackRaceDataList:Array;
		static var retrieveList:Array;
		public static function GetAllRaceData_Error(e:IOErrorEvent)
		{
			trace("GetAllRaceData_Error: " + e.text);
		}
		public static function GetAllRaceData_Done(event:Event)
		{
			var uv:URLVariables = new URLVariables(loader_recording.data);
			var levels:String = uv["levels"];
			
			Utils.print("Got track data " + levels);
			
			retrieveList = new Array();
			if (levels != null && levels != "")
			{
				retrieveList = levels.split(",");
			}
			
			for (var i:int = 0; i < retrieveList.length; i++)
			{
				Utils.print(">"+i + ": " + retrieveList[i]);
			}
			
			serverTrackRaceDataList = new Array();
			
			var max:int = 7;
			
			var num:int = retrieveList.length / max;
			Utils.print("creating sdata list");
			Utils.print(num + " "+retrieveList.length + " " + num * max);
			
			for (var i:int = 0; i < num; i++)
			{
				var pr:PlayerRecording = new PlayerRecording();
				
				pr.db_id = retrieveList[(i * max) + 0];
				//pr.player_name = retrieveList[(i * max) + 1];
				pr.time = retrieveList[(i * max) + 2];
				pr.bike_id = retrieveList[(i * max) + 3];
				pr.bell_id = retrieveList[(i * max) + 4];
				pr.levelID = retrieveList[(i * max) + 6];
				pr.char_id = retrieveList[(i * max) + 5];
				//pr.user_id = retrieveList[(i * max) + 6];
				serverTrackRaceDataList.push(pr);
				
			}
			
			
			RetrieveRecording_Callback();
			
		}
		
		
		
		static var loadedAllRunsCB:Function;
		static var currentLoadingID:int;
		static var idList:Array;
		public static var loader_recording:URLLoader;
		public static var loadedRuns:Array;
		
		public static function LoadRaceDataFromServer_IDList(listString:String,cb:Function=null)
		{
			loadedAllRunsCB = cb;
			loadedRuns = new Array();
			idList = listString.split(",");
			if (idList == null) return;
			if (idList.length == 0) return;
			
			currentLoadingID = 0;
			
			loader_recording = new URLLoader();
			loader_recording.addEventListener(Event.COMPLETE, RetrieveRecording_Done);
			
			var runid:int = idList[currentLoadingID];
			var req:String = PATH + "GenericRuns_GetRun.php?func=GetRunByID&runid="+runid;
			var request:URLRequest = GetURLRequestFromPath(req);
			loader_recording.load(request);
			
		}
		public static function LoadRaceDataFromServer_IDArray(_idList:Array,cb:Function=null)
		{
			loadedAllRunsCB = cb;
			loadedRuns = new Array();
			if (_idList == null) return;
			if (_idList.length == 0) return;
			idList = new Array();
			for each(var i:int in _idList)
			{
				idList.push(i);
			}
			
			currentLoadingID = 0;
			
			loader_recording = new URLLoader();
			loader_recording.addEventListener(Event.COMPLETE, RetrieveRecording_Done);
			
			var runid:int = idList[currentLoadingID];
			var req:String = PATH + "GenericRuns_GetRun.php?func=GetRunByID&runid="+runid;
			var request:URLRequest = GetURLRequestFromPath(req);
			loader_recording.load(request);
			
		}
		
		public static function RetrieveRecording_Done(event:Event)
		{
			try
			{
				var uv:URLVariables = new URLVariables(String(loader_recording.data));
			}
			catch (e:Error)
			{
				return;
			}
			
			if (uv == null) 
			{
				RetrieveRecording_Error("URLVariables");
				return;
			}
			
			var pr:PlayerRecording = new PlayerRecording();
			pr.FromURLVariables(uv);
			loadedRuns.push(pr);
			
			
			currentLoadingID++;
			if (currentLoadingID < idList.length)
			{
				loader_recording = new URLLoader();
				loader_recording.addEventListener(Event.COMPLETE, RetrieveRecording_Done);
				
				var runid:int = idList[currentLoadingID];
				var req:String = PATH + "GenericRuns_GetRun.php?func=GetRunByID&runid="+runid;
				var request:URLRequest = GetURLRequestFromPath(req);
				loader_recording.load(request);
			}
			else
			{
				if (loadedAllRunsCB != null)
				{
					loadedAllRunsCB();
				}
			}
			
		}
		
		public static function RetrieveRecording_Error(errString:String)
		{
			var str:String = "RetrieveRecording_Error [" + currentLoadingID + "]  " + errString;
			Utils.print("");			
			Utils.print("");			
			Utils.print(str);			
			Utils.print("");			
			Utils.print("");			
		}
		
		static function GetURLRequestFromPath(fullpath:String):URLRequest
		{
			var useGet:Boolean = false;
			if (useGet)
			{
				var request:URLRequest = new URLRequest(fullpath);
				request.method = URLRequestMethod.GET;
				return request;
			}
			
			//use POST
			var strings:Array = fullpath.split("?");
			var base:String = strings[0];
			var ext:String = strings[1];
			//Utils.print("GetURLRequestFromPath " + strings.length);
			
//			Utils.print("Path: " + fullpath);
			//Utils.print("base: " + base);
			//Utils.print("ext: " + ext);

			
			
			var vars:URLVariables = new URLVariables(ext);

			/*
			var varlist:Array = ext.split("&");
			for each(var s:String in varlist)
			{
				var varstrs:Array = s.split("=");
				
				vars[ varstrs[0] ] = varstrs[1];
			}
			*/

			
			var request:URLRequest = new URLRequest(fullpath);
			request.method = URLRequestMethod.POST;
			request.data = vars;
			return request;
			
		}
		
		
		
		
		static var loader:URLLoader;
		public static function SubmitRecording(pr:PlayerRecording)
		{
			
			var path:String = PATH+"GenericRuns_AddRun.php?";
			
			var vars:URLVariables = new URLVariables();
			vars.player_name = pr.player_name;
			vars.game_name = GAME_NAME;
			vars.time = pr.time;
			vars.bike_id = pr.bike_id;
			vars.bell_id = pr.bell_id;
			vars.char_id = pr.char_id;
			vars.level_id_str = pr.levelID;
			vars.data =  pr.RunToString();
			vars.version = pr.version;
			var date:Date = new Date();
			vars.timeStamp = date.toUTCString();

			var hashStr:String = "";
			hashStr += vars.player_name;
			hashStr += vars.game_name;
			hashStr += vars.time;
			hashStr += vars.bike_id;
			hashStr += vars.bell_id;
			hashStr += vars.char_id;
			hashStr += vars.level_id_str;
			hashStr += vars.data;
			hashStr += vars.version;
			hashStr += vars.timeStamp;
			hashStr += CYCLO_KEY;
			var hash:String = MD5.hash(hashStr);
			vars.hash = hash;
			
			Utils.print("vars hash: " + hash);
						
			var request:URLRequest = new URLRequest(path);
			request.method = URLRequestMethod.POST;
            request.data = vars;
		
			
		   try {
			   loader = new URLLoader();
			   loader.dataFormat = URLLoaderDataFormat.VARIABLES;
	   			loader.addEventListener(Event.COMPLETE, SendRecording_Complete);
	   			loader.addEventListener("httpResponseStatus", SendRecording_httpResponseStatus);
	   			loader.addEventListener("httpStatus", SendRecording_httpStatus);
	   			loader.addEventListener("securityError", SendRecording_securityError);
	   			loader.addEventListener("ioError", SendRecording_ioError);
	   			loader.addEventListener("progress", SendRecording_progress);
	   			loader.addEventListener("open", SendRecording_open);

			   loader.load(request);
				Utils.print("Stats sent to server");
            }
            catch (e:Error) 
			{
				Utils.print(e.message);
                // handle error here
            }
		}

		public static function SendRecording_httpResponseStatus(e:Event)
		{
			Utils.print("SendRecording_httpResponseStatus");
		}
		public static function SendRecording_httpStatus(e:Event)
		{
			Utils.print("SendRecording_httpStatus");
		}
		public static function SendRecording_securityError(e:Event)
		{
			Utils.print("SendRecording_securityError");
		}
		public static function SendRecording_ioError(e:Event)
		{
			Utils.print("SendRecording_ioError");
		}
		public static function SendRecording_progress(e:Event)
		{
			Utils.print("SendRecording_progress");
		}
		public static function SendRecording_open(e:Event)
		{
			Utils.print("SendRecording_open");
		}
		public static function SendRecording_Complete(e:Event)
		{
			var uv:URLVariables = new URLVariables(loader.data);
			var lastid:String = uv["lastid"];
			var error:String = uv["error"];
//			Utils.print("Sent Recording, RunID=" + lastid + "  bikeID=" + Game.currentBikeIndex + "  bellID=0" + "   levelID=" + int(Game.currentLevel + 1) );
			Utils.print("Sent Recording, error = " + error);
//			sendRecording_raceID = lastid;
//			sendRecording_CB();
		}
		
		
		public static function GetRunsFromBinary()
		{
			if (Game.useLocalRuns == false) return;
			
			loadedRuns = new Array();
			
			Utils.print("inflating bytearray");
			var ba:ByteArray = new runs_bin() as ByteArray;
			ba.uncompress();
			Utils.print("ba " + ba.length);
			Utils.print("inflating bytearray done");

			var numRecordings:int = ba.readInt();
			Utils.print("num runs: " + numRecordings);

			for (var runIndex:int = 0; runIndex < numRecordings; runIndex++)
			{
				var pr:PlayerRecording = new PlayerRecording();
				pr.levelID = ba.readUTF();
				pr.time = ba.readInt();
				pr.bike_id = ba.readInt();
				pr.bell_id= ba.readInt();
				pr.char_id = ba.readInt();
				pr.db_id = ba.readInt();

				
				pr.RunDataFromByteArray_Compressed(ba);
				loadedRuns.push(pr);
			}
			
			Utils.print("databaseRuns len " + loadedRuns.length);
		}
		
		public static function SaveRunsToBinary()
		{
			var allruns:Array = loadedRuns;
			
			
			var i:int;
			var numRecordings:int = allruns.length;
			
			var ba_fullsize:ByteArray = new ByteArray();
			var ba:ByteArray = new ByteArray();
			ba.writeInt(numRecordings);
			
			for (var runIndex:int = 0; runIndex < numRecordings; runIndex++)
			{
				var pr:PlayerRecording = allruns[runIndex];
				
				ba.writeUTF(pr.levelID);
				ba.writeInt(pr.time);
				ba.writeInt(pr.bike_id);
				ba.writeInt(pr.bell_id);
				ba.writeInt(pr.char_id);
				ba.writeInt(pr.db_id);

				ba_fullsize.writeUTF(pr.levelID);
				ba_fullsize.writeInt(pr.time);
				ba_fullsize.writeInt(pr.bike_id);
				ba_fullsize.writeInt(pr.bell_id);
				ba_fullsize.writeInt(pr.char_id);
				ba_fullsize.writeInt(pr.db_id);
				
				pr.RunDataToByteArray_Compressed(ba);
				pr.RunDataToByteArray(ba_fullsize);
				
			}
			
			trace("saved " + numRecordings + " runs");
			trace(" pre-compression size " + ba_fullsize.length + " / " + ba.length);
			ba_fullsize.compress();
			ba.compress();
			trace(" post-compression size " + ba_fullsize.length + " / " + ba.length);
			
			var fr:FileReference = new FileReference();
			fr.save(ba,"runs.bin");
			
		}
			
	}

}