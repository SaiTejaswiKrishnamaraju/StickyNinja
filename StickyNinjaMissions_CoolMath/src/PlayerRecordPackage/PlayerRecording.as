package PlayerRecordPackage
{
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class PlayerRecording 
	{
		public var db_id:int;
		public var player_name:String;
		public var levelID:String;
		public var time:int;
		public var bike_id:int;
		public var bell_id:int;
		public var char_id:int;
		public var version:int;
		public var list:Vector.<PlayerRecordingItem>;
		public var actions:Vector.<PlayerRecordAction>;
		
		public function PlayerRecording() 
		{
			list = new Vector.<PlayerRecordingItem>();
			actions = new Vector.<PlayerRecordAction>();
			levelID = "1_1";
			time = 0;
			bike_id = 0;
			bell_id = 0;
			char_id = 0;
			version = 1;
			player_name = "julian";
		}
		
		public function NewItem():PlayerRecordingItem
		{
			var pri:PlayerRecordingItem = new PlayerRecordingItem();
			list.push(pri);
			return pri;
		}
		public function AddActionAndUseCurrentPosition( _action:int,_x:int,_y:int,_data:int)
		{
			var act:PlayerRecordAction = new PlayerRecordAction(0, _action, _x, _y, _data);
			act.pos = list.length;
			actions.push(act);
			trace("Added action " + _action + " at pos " + act.pos);
		}
		
		public function Clone():PlayerRecording
		{
			var pr:PlayerRecording = new PlayerRecording();
			
			
			pr.db_id = db_id;
			pr.player_name = player_name
			pr.levelID = levelID;
			pr.time = time;
			pr.bike_id = bike_id;
			pr.bell_id = bell_id;
			pr.char_id = char_id;
			pr.version = version;
		
			
			
			for each(var pri:PlayerRecordingItem in list)
			{
				pr.list.push(pri.Clone());
			}
			for each(var act:PlayerRecordAction in actions)
			{
				pr.actions.push(act.Clone());
			}
			return pr;
		}
		
		public function GetItem(position:Number):PlayerRecordingItem
		{
			var p:int = position;
			if (list.length == 0) return null;
			if (p < 0) p = 0;
			if (p >= list.length) p = list.length - 1;
  			return list[p];
		}
		
		
		
		public function StringToRun(data:String)
		{
			player_name = "hello";
			db_id = 0;
			time = 1000;
			bike_id = 0;
			bell_id = 0;
			char_id = 0;
			levelID = "hello";
			
			var ba:ByteArray = Base64.decode(data);
			//if(ba == null) RetrieveRecording_Error("Base64.decode");
			
			ba.position = 0;
			
			var compressedLen:int = ba.length;
			ba.uncompress();
			var origLen:int = ba.length;
			

			Utils.print("bytearray length " + origLen+" / "+compressedLen);
			//Utils.print("totals: " + totalSize+" / "+totalCompressedSize);
			
			var len:int = ba.length;
			
			
			//len -= 4;
			//len -= (numActions * 16);
			
			var itemLen:int = 10 * 4;
			
			var numItems:int = len / itemLen;
			
			var mult:int = numItems * itemLen;
			if(mult != len) PlayerRecordings.RetrieveRecording_Error("length mismatch "+mult+" "+len);
			
			if (numItems == 0)
			{
				PlayerRecordings.RetrieveRecording_Error("length");
			}
			
			
			var i:int = 0;
			for (i = 0; i < numItems; i++)
			{
				var pri:PlayerRecordingItem = new PlayerRecordingItem();
				pri.action = ba.readInt();
				pri.x = ba.readInt();
				pri.y = ba.readInt();
				pri.wheel0_x = ba.readInt();
				pri.wheel0_y = ba.readInt();
				pri.wheel0_rot = ba.readFloat();
				pri.wheel1_x = ba.readInt();
				pri.wheel1_y = ba.readInt();
				pri.wheel1_rot = ba.readFloat();
				var dir:int = ba.readInt();
				pri.rot = Utils.ScaleTo(0, Math.PI * 2, 0, 255, dir);
				pri.frame = 0;
				
				list.push(pri);
			}
		}
		public function RunToString():String
		{
			var byteArray:ByteArray = new ByteArray();
			
			var act:PlayerRecordAction;
			byteArray.writeInt(actions.length);
			for (var i:int = 0; i < actions.length; i++)
			{
				act = actions[i];
				byteArray.writeInt(act.pos);
				byteArray.writeInt(act.action);
				byteArray.writeInt(act.x);
				byteArray.writeInt(act.y);
				byteArray.writeInt(act.data);
			}
			
			byteArray.writeInt(list.length);
			var pri:PlayerRecordingItem;
			for (var i:int = 0; i < list.length; i++)
			{
				pri = list[i];
				byteArray.writeInt(int(pri.action));
				byteArray.writeInt(int(pri.x));
				byteArray.writeInt(int(pri.y));
				byteArray.writeInt(int(pri.wheel0_x));
				byteArray.writeInt(int(pri.wheel0_y));
				byteArray.writeFloat(int(pri.wheel0_rot));
				byteArray.writeInt(int(pri.wheel1_x));
				byteArray.writeInt(int(pri.wheel1_y));
				byteArray.writeFloat(int(pri.wheel1_rot));
				var r:Number = Utils.NormalizeRot(pri.rot);
				var dir:int = Utils.ScaleTo(0, 255, 0, Math.PI * 2, r);
				byteArray.writeInt(int(dir));
				
			}
			Utils.print("bytearray length " + byteArray.length);
			byteArray.compress();
			
			Utils.print("bytearray compressed length " + byteArray.length);

			var byteString:String = Base64.encode(byteArray);
			return byteString;
			
		}
		
		public function RunDataToByteArray(ba:ByteArray)
		{
			ba.writeInt(actions.length);
			for (var i:int = 0; i < actions.length; i++)
			{
				var act:PlayerRecordAction = actions[i];
				ba.writeInt(act.pos);
				ba.writeInt(act.action);
				ba.writeInt(act.x);
				ba.writeInt(act.y);
				ba.writeInt(act.data);
			}
			
			ba.writeInt(list.length);
			
			var pri:PlayerRecordingItem;
			for (var i:int = 0; i < list.length; i++)
			{
				pri = list[i];
				ba.writeInt(int(pri.action));
				ba.writeInt(int(pri.x));
				ba.writeInt(int(pri.y));
				ba.writeInt(int(pri.wheel0_x));
				ba.writeInt(int(pri.wheel0_y));
				ba.writeFloat(int(pri.wheel0_rot));
				ba.writeInt(int(pri.wheel1_x));
				ba.writeInt(int(pri.wheel1_y));
				ba.writeFloat(int(pri.wheel1_rot));
				var r:Number = Utils.NormalizeRot(pri.rot);
				var dir:int = Utils.ScaleTo(0, 255, 0, Math.PI * 2, r);
				ba.writeInt(int(dir));
				
			}			
		}

		
		
		public function RunDataToByteArray_Compressed(ba:ByteArray)
		{
			
			var pri:PlayerRecordingItem;

			var dx:int = 0;
			var dy:int = 0;
			
			
			var numToWrite:int = 0;
			var skipcount:int = 0;
			for (var i:int = 0; i < list.length; i++)
			{
				if (skipcount == 0)
				{
					numToWrite++;
				}
				skipcount++;
				if (skipcount >= GameVars.rundata_skip) skipcount = 0;
			}
			
			ba.writeInt(actions.length);
			for (var i:int = 0; i < actions.length; i++)
			{
				var act:PlayerRecordAction = actions[i];
				ba.writeInt(act.pos);
				ba.writeInt(act.action);
				ba.writeInt(act.x);
				ba.writeInt(act.y);
				ba.writeInt(act.data);
			}
			
			ba.writeInt(numToWrite);
			
			var skipcount:int = 0;
			for (var i:int = 0; i < list.length; i++)
			{
				pri = list[i];
				
				if (skipcount == 0)
				{
				
					ba.writeShort(int(pri.x));
					ba.writeShort(int(pri.y));
					
					dx = pri.wheel0_x - pri.x;
					dy = pri.wheel0_y - pri.y;
					
					ba.writeByte(int(dx));
					ba.writeByte(int(dy));
					
					var r:Number = Utils.NormalizeRot(pri.wheel0_rot);
					var dir:int = Utils.ScaleTo(0, 255, 0, Math.PI * 2, r);
					ba.writeByte(int(dir));
					
					dx = pri.wheel1_x - pri.x;
					dy = pri.wheel1_y - pri.y;
					
					ba.writeByte(int(dx));
					ba.writeByte(int(dy));
					
					var r:Number = Utils.NormalizeRot(pri.wheel1_rot);
					var dir:int = Utils.ScaleTo(0, 255, 0, Math.PI * 2, r);
					ba.writeByte(int(dir));
					
					var r:Number = Utils.NormalizeRot(pri.rot);
					var dir:int = Utils.ScaleTo(0, 255, 0, Math.PI * 2, r);
					ba.writeByte(int(dir));
				}
				skipcount++;
				if (skipcount >= GameVars.rundata_skip) skipcount = 0;
			}			
		}
		
		public function RunDataFromByteArray_Compressed(ba:ByteArray)
		{
			
			var numActions:int = ba.readInt();
			for (var i:int = 0; i < numActions; i++)
			{
				var act:PlayerRecordAction = new PlayerRecordAction(0,0,0,0,0);
				act.pos = ba.readInt();
				act.action = ba.readInt();
				act.x = ba.readInt();
				act.y = ba.readInt();
				act.data = ba.readInt();
			}
			
			var numRecords:int = ba.readInt();
			
			var dx:int = 0;
			var dy:int = 0;
			
			for (var i:int = 0; i < numRecords; i++)
			{
				var pri:PlayerRecordingItem = new PlayerRecordingItem();
				
				pri.x = ba.readShort();
				pri.y = ba.readShort();
				
				dx = ba.readByte();
				dy = ba.readByte();
				pri.wheel0_x = pri.x + dx;
				pri.wheel0_y = pri.y + dy;
				
				var dir:int = ba.readByte();
				pri.wheel0_rot = Utils.ScaleTo(0, Math.PI * 2, 0, 255, dir);
				
				dx = ba.readByte();
				dy = ba.readByte();
				pri.wheel1_x = pri.x + dx;
				pri.wheel1_y = pri.y + dy;
				
				var dir:int = ba.readByte();
				pri.wheel1_rot = Utils.ScaleTo(0, Math.PI * 2, 0, 255, dir);
				
				var dir:int = ba.readByte();
				pri.rot = Utils.ScaleTo(0, Math.PI * 2, 0, 255, dir);
				
				list.push(pri);
			}			
		}
		
		
		public function RunDataFromByteArray(ba:ByteArray)
		{
			var numRecords:int = ba.readInt();
			for (var i:int = 0; i < numRecords; i++)
			{
				var pri:PlayerRecordingItem = new PlayerRecordingItem();
				
				pri.action = ba.readInt();
				pri.x = ba.readInt();
				pri.y = ba.readInt();
				pri.wheel0_x = ba.readInt();
				pri.wheel0_y = ba.readInt();
				pri.wheel0_rot= ba.readFloat();
				pri.wheel1_x = ba.readInt();
				pri.wheel1_y = ba.readInt();
				pri.wheel1_rot= ba.readFloat();
				var dir:int = ba.readInt();
				pri.rot = Utils.ScaleTo(0, Math.PI * 2, 0, 255, dir);
				
				list.push(pri);
			}			
		}

		
		public function FromURLVariables(uv:URLVariables)
		{
			player_name = uv["player_name"];
			db_id = uv["id"];
			time = uv["time"];
			bike_id = uv["bike_id"];
			bell_id = uv["bell_id"];
			char_id = uv["char_id"];
			levelID = uv["level_id_str"];
			var data:String = uv["data"];
			
			
			//if (player_name==null) RetrieveRecording_Error("name null");
			//if (player_name.length > 20) RetrieveRecording_Error("name length");
			//if (player_name == "") RetrieveRecording_Error("name short");
			//if(bike_id <0) RetrieveRecording_Error("bike 1");
			//if(bike_id > PlayerBikes.bikes.length) RetrieveRecording_Error("bike 2");

			//Utils.trace("Player_name "+player_name);
			//Utils.trace("time "+time);
			//Utils.trace("bike_id "+bike_id);
			//Utils.trace("bell_id "+bell_id);
			//Utils.trace("level_id "+level_id);
			//Utils.trace("user_id "+user_id);
			//Utils.trace("data "+data);
			
			var ba:ByteArray = Base64.decode(data);
			if (ba == null) return;
			
			ba.position = 0;
			
			var compressedLen:int = ba.length;
			ba.uncompress();
			var origLen:int = ba.length;
			
			
//			totalCompressedSize += compressedLen;
//			totalSize += origLen;

			Utils.print("bytearray length " + origLen+" / "+compressedLen);
			//Utils.print("totals: " + totalSize+" / "+totalCompressedSize);
			
			var len:int = ba.length;
			
			var numActions:int = ba.readInt();
			
			
			actions = new Vector.<PlayerRecordAction>();
			
			for (var i:int = 0; i < numActions; i++)
			{
				var actionPos:int = ba.readInt();
				var actionAction:int = ba.readInt();
				var actionX:int = ba.readInt();
				var actionY:int = ba.readInt();
				var actionData:int = ba.readInt();
				var pra:PlayerRecordAction = new PlayerRecordAction(actionPos, actionAction,actionX,actionY,actionData);
				actions.push(pra);
			}
			
			var numItems:int = ba.readInt();
			
			if (numItems == 0)
			{
				PlayerRecordings.RetrieveRecording_Error("length");
			}
			
			
			var i:int = 0;
			for (i = 0; i < numItems; i++)
			{
				var pri:PlayerRecordingItem = new PlayerRecordingItem();
				pri.action = ba.readInt();
				pri.x = ba.readInt();
				pri.y = ba.readInt();
				pri.wheel0_x = ba.readInt();
				pri.wheel0_y = ba.readInt();
				pri.wheel0_rot = ba.readFloat();
				pri.wheel1_x = ba.readInt();
				pri.wheel1_y = ba.readInt();
				pri.wheel1_rot = ba.readFloat();
				var dir:int = ba.readInt();
				pri.rot = Utils.ScaleTo(0, Math.PI * 2, 0, 255, dir);
				pri.frame = 0;
				
				list.push(pri);
			}
			
		}
		
	}

}