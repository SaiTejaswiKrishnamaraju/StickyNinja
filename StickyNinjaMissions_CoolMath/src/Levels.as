package  
{
	import EditorPackage.EdJoint;
	import EditorPackage.EdLine;
	import EditorPackage.EdObj;
	import EditorPackage.LayoutTemplate;
	import fl.controls.List;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class Levels
	{
		public static var currentIndex:int;
		public static var list:Vector.<Level>;
		public static var templates:Vector.<LayoutTemplate>;
		
		public function Levels() 
		{
			
		}
		
		public static function SetCurrentByName(name:String)
		{
			for (var i:int = 0; i < list.length; i++)
			{
				if (list[i].name == name) currentIndex = i;
			}
		}
		
		public static function GetCurrent():Level
		{
			if (currentIndex < 0) return null;
			if (currentIndex >= list.length) return null;
			LoadLevel(currentIndex, false);
			return list[currentIndex];
		}
		
		public static function CountPerfectLevels():int
		{
			var count:int = 0;
			for each(var l:Level in list)
			{
				if (l.complete && l.rating != 0)
				{
					count++;
				}
			}
			return count;
		}
		public static function CountCompleteLevels():int
		{
			var count:int = 0;
			for each(var l:Level in list)
			{
				if (l.complete)
				{
					count++;
				}
			}
			return count;
		}

		
		public static function LoadAll()
		{
			list = new Vector.<Level>();
			var x:XML = ExternalData.levelsXml;
			var num = x.level.length();
			for (var i:int = 0; i < num; i++)
			{
				PreLoadLevel(i);
				LoadLevel(i);
			}
			x = null;
			
			ValidateLevels();
			LoadTemplates();
		}

		public static function LoadTemplates()
		{
			templates = new Vector.<LayoutTemplate>();
			var x:XML = ExternalData.LayoutTemplatesXML;
			var num = x.template.length();
			for (var i:int = 0; i < num; i++)
			{
				LoadTemplate(x.template[i]);
			}
			System.disposeXML(ExternalData.LayoutTemplatesXML);
			ExternalData.LayoutTemplatesXML = null;
			
		}
		
		static function ValidateLevels()
		{
			var ids:Array = new Array();
			
			for each(var l:Level in list)
			{
//				trace("level id " + l.id);

				if (ids.indexOf(l.id) != -1)
				{
					trace ("DUPLICATE LEVEL ID !!!!!");
				}
				ids.push(l.id);
			}
			
			return;
			
			var carsUsed:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0);
			var bgsUsed:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0);
			var names:Dictionary = new Dictionary();
			var carNames:Array = new Array(
				"Training",
				"Coupe",
				"Dakar",
				"Hummer",
				"Milk Float",
				"4x4",
				"Messerschmitt",
				"School Bus",
				"Dune Buggy"
				);
			
			var levelIndex:int = 0;
			for each(var l:Level in list)
			{
				var carType:String = "";
				
				var carCount:int = 0;
				var manCount:int = 0;
				var levelInfoCount:int = 0;
				var endCount:int = 0;
				
				for each(var inst:EdObj in l.instances)
				{
					if (inst.typeName == "Man") manCount++;
					if (inst.typeName == "LevelInfo") 
					{
						var bgIndex:int = inst.objParameters.GetValueInt("level_background");
						bgIndex--;
						bgsUsed[bgIndex]++;
						levelInfoCount++;
					}
					if (inst.typeName == "EndPost") endCount++;
					if (inst.typeName.search("CarStartPoint") != -1) 
					{
						var s:String = inst.typeName.substr(13);
						var si:int = int(s);
						
						carsUsed[si]++;
						
						carCount++;
					}
				}
				
				var aa:Object = names[l.name];
				if (names[l.name] == null)
				{
					names[l.name] = 1;
				}
				else
				{
					names[l.name]++;
				}
				
				
				
				levelIndex++;
				
//				trace("Level " + levelIndex + " : " + l.name);
//				trace(" " + manCount + " " + levelInfoCount + " " + endCount + " " + carCount);
				
				if (manCount != 1) trace("Level " + levelIndex + " : " + l.name+",   manCount="+manCount);
				if (levelInfoCount != 1) trace("Level " + levelIndex + " : " + l.name+",   levelInfoCount="+levelInfoCount);
				if (endCount != 1) trace("Level " + levelIndex + " : " + l.name+",   endCount="+endCount);
				if (carCount != 1) trace("Level " + levelIndex + " : " + l.name+",   carCount="+carCount);
			}
			trace("Cars used count:");
			for (var i:int = 0; i < 8; i++)
			{
				trace(" " + int(i+1) + ": " + carsUsed[i] + " times  (" + carNames[i] + ")" );
			}
			trace("BGs used count:");
			for (var i:int = 0; i < 8; i++)
			{
				trace(" " + int(i+1) + ": " + bgsUsed[i]+" times");
			}
			
			trace("Duplicate Level names:");
			for (var key:Object in names) 
			{
				var count:int = names[key];
				if (count != 1)
				{
					trace(" " + key.toString() + " : " + names[key]);
				}
			}
			
		}
		
		
		static function LoadTemplate(x:XML)
		{
			var template:LayoutTemplate;
			template = new LayoutTemplate();	
			template.id = XmlHelper.GetAttrString(x.@id,"1");
			LoadObjects(template, x);
			LoadLines(template, x);
			LoadJoints(template, x);
			templates.push(template);
		}
		
		public static function PreLoadLevel(l:int)
		{
			var x:XML = ExternalData.levelsXml;
			x = x.level[l];
			var level:Level;
			level = new Level();	
			
			level.fullyLoaded = false;

			level.available = false;
			level.complete = false;
			
			level.id = XmlHelper.GetAttrString(x.@id,"1");
			level.name = XmlHelper.GetAttrString(x.@name,"undefined");
			level.displayName = XmlHelper.GetAttrString(x.@displayname,"undefined");
			level.category = XmlHelper.GetAttrInt(x.@category, 0);
			level.bgFrame = XmlHelper.GetAttrInt(x.@bg, 1);
			level.creator = XmlHelper.GetAttrString(x.@creator, "");
			
			
			LoadGameSpecificLevelData(level, x);
			
			var i:int;
			for (i = 0; i < x.helpscreen.length(); i++)
			{
				var xx:XML = x.helpscreen[i];
				level.helpscreenFrames.push(XmlHelper.GetAttrInt(xx.@frame, 0));
				
			}
		
//			Utils.trace("initing level " + l);
			
			list.push(level);
			
			
		}

		
		public static function LoadGameSpecificLevelData(level:Level,x:XML)
		{
			level.goldKicks = XmlHelper.GetAttrInt(x.soccerballs.@gold, 1);
			level.failKicks = XmlHelper.GetAttrInt(x.soccerballs.@fail, 3);
			
			level.totalCoins = 0;
			level.hasTrophy = false
			level.trophyIndex = 0;
			
			var i:int;
			var j:int;
			for (j = 0; j < x.objgroup.length(); j++)
			{
				var objgrx:XML = x.objgroup[j];
				for (i = 0; i < objgrx.obj.length(); i++)
				{
					var lo:XML = objgrx.obj[i];
					var type:String = lo.@type;
					if (type == "pickup_normal")
					{
						level.totalCoins++;
					}
					if (type.search("pickup_trophy_") != -1)
					{
						var s:String = type.substr(14);
						level.trophyIndex = int(s);
						
						level.hasTrophy = true;
					}
				}				
			}
		}
		
		public static function GetGameSpecificLevelDataXML(_level:int):String
		{
			var s:String;
			var l:Level = GetLevel(_level);
			s = '\t<soccerballs'
			s += ' gold="' + l.goldKicks + '"';
			s += ' fail="' + l.failKicks + '"';
			s += ' />';
			return s;
		}
		
		
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------

		static function LoadObjects(level:LevelBase, x:XML)
		{
			var i:int;
			var j:int;
			
			level.instances = new Array();
			
			for (j = 0; j < x.objgroup.length(); j++)
			{
				var objgrx:XML = x.objgroup[j];
				for (i = 0; i < objgrx.obj.length(); i++)
				{
					var lo:XML = objgrx.obj[i];

					
					var id:String = XmlHelper.GetAttrString(lo.@id, "");
					var type:String = lo.@type;
					var px:Number = Number(lo.@x);
					var py:Number = Number(lo.@y);
					var rot:Number = Number(lo.@rot);
					var scale:Number = XmlHelper.GetAttrNumber(lo.@scale, 1);
					var params:String = XmlHelper.GetAttrString(lo.@params, "");
					var xf:Boolean = XmlHelper.GetAttrBoolean(lo.@xflip, false);

					var po:PhysObj = Game.objectDefs.FindByName(type);
					if (po == null)
					{
						trace("Loading level id "+level.id+":  Missing Object: " + type);
					}
					else
					{
						var params1:String = po.GetInstanceParamsAsString();
						
						params = params1 + "," + params;
						
						var inst:EdObj = CreateLevelObjInstanceAt(type, px, py, rot, scale, "", params);
						inst.isXFlipped = xf;
						inst.id = id;
						level.instances.push(inst);
					}
				}
				
			}
			
			for (i = 0; i < x.obj.length(); i++)
			{
				
				var lo:XML = x.obj[i];

				var id:String = XmlHelper.GetAttrString(lo.@id, "");
				var type:String = lo.@type;
				var px:Number = Number(lo.@x);
				var py:Number = Number(lo.@y);
				var rot:Number = Number(lo.@rot);
					var scale:Number = XmlHelper.GetAttrNumber(lo.@scale, 1);
				var params:String = XmlHelper.GetAttrString(lo.@params, "");
				var xf:Boolean = XmlHelper.GetAttrBoolean(lo.@xflip, false);

				var inst:EdObj = CreateLevelObjInstanceAt(type, px, py, rot, scale,"", params);
				inst.isXFlipped = xf;
				inst.id = id;
				level.instances.push(inst);
			}
		}
		
//--------------------------------------------------------------------------------------------------
		
		static function LoadJoints(level:LevelBase, x:XML)
		{
			var i:int;
			var j:int;
			level.joints = new Array();
			for (i = 0; i < x.joints.joint.length(); i++)
			{				
				var jx:XML = x.joints.joint[i];
				var joint:EdJoint = new EdJoint();

				joint.id = XmlHelper.GetAttrString(jx.@id, "");
				var typeStr:String = XmlHelper.GetAttrString(jx.@type, "");
				if (typeStr == "rev")
				{
					joint.SetType(EdJoint.Type_Rev);
					joint.obj0Name = XmlHelper.GetAttrString(jx.@objid0, "");
					joint.obj1Name = XmlHelper.GetAttrString(jx.@objid1, "");
					joint.rev_pos.x = XmlHelper.GetAttrNumber(jx.@x, 0);
					joint.rev_pos.y = XmlHelper.GetAttrNumber(jx.@y, 0);
					
				}				
				if (typeStr == "dist")
				{
					joint.SetType(EdJoint.Type_Distance);
					joint.obj0Name = XmlHelper.GetAttrString(jx.@objid0, "");
					joint.obj1Name = XmlHelper.GetAttrString(jx.@objid1, "");
					joint.dist_pos0.x = XmlHelper.GetAttrNumber(jx.@x0, 0);
					joint.dist_pos0.y = XmlHelper.GetAttrNumber(jx.@y0, 0);
					joint.dist_pos1.x = XmlHelper.GetAttrNumber(jx.@x1, 0);
					joint.dist_pos1.y = XmlHelper.GetAttrNumber(jx.@y1, 0);
				}				
				if (typeStr == "prism")
				{
					joint.SetType(EdJoint.Type_Prismatic);					
					joint.obj0Name = XmlHelper.GetAttrString(jx.@objid0, "");
					joint.obj1Name = XmlHelper.GetAttrString(jx.@objid1, "");
					joint.prism_pos.x = XmlHelper.GetAttrNumber(jx.@x0, 0);
					joint.prism_pos.y = XmlHelper.GetAttrNumber(jx.@y0, 0);
					joint.prism_pos1.x = XmlHelper.GetAttrNumber(jx.@x1, 0);
					joint.prism_pos1.y = XmlHelper.GetAttrNumber(jx.@y1, 0);
				}				
				if (typeStr == "switch")
				{
					joint.SetType(EdJoint.Type_Switch);					
					joint.obj0Name = XmlHelper.GetAttrString(jx.@objid0, "");
					joint.obj1Name = XmlHelper.GetAttrString(jx.@objid1, "");
				}				
				if (typeStr == "logic")
				{
					joint.SetType(EdJoint.Type_LogicLink);					
					joint.obj0Name = XmlHelper.GetAttrString(jx.@objid0, "");
					joint.obj1Name = XmlHelper.GetAttrString(jx.@objid1, "");
				}				
				if (typeStr == "weld")
				{
					joint.SetType(EdJoint.Type_Weld);					
					joint.obj0Name = XmlHelper.GetAttrString(jx.@objid0, "");
					joint.obj1Name = XmlHelper.GetAttrString(jx.@objid1, "");
				}				
				var params:String = XmlHelper.GetAttrString(jx.@params, "");
				joint.objParameters.ValuesFromString(params);
				level.joints.push(joint);
			}
			
		}
		static function LoadLines(level:LevelBase, x:XML)
		{
			var i:int;
			var j:int;

			level.lines = new Array();
			
			for (i = 0; i < x.line.length(); i++)
			{				
				var linex:XML = x.line[i];
				var line:EdLine = new EdLine();
				line.id = XmlHelper.GetAttrString(linex.@id, "");
				line.type = XmlHelper.GetAttrInt(linex.@type, 0);
				for (j = 0; j < linex.points.length(); j++)
				{
					var pointsx:XML = linex.points[j];
					var pointsstr:String = XmlHelper.GetAttrString(pointsx.@a,"");
					var pts:Array = Utils.PointArrayFromString(pointsstr);
					for each(var p1:Point in pts)
					{
						line.points.push(p1);
					}
				}
				var params:String = XmlHelper.GetAttrString(linex.@params, "");
				line.objParameters.ValuesFromString(params);
				
				level.lines.push(line);
			}				
		}
		
		public static function LoadLevel(l:int,simple:Boolean=true)
		{
			
			level = list[l];

			
			if (level.fullyLoaded) return;
			
			var x:XML = ExternalData.levelsXml;
			x = x.level[l];
			
			var level:Level;
			
			
			level.Calculate();
			
			level.fullyLoaded = true;
			
			LoadLines(level, x);

			LoadObjects(level, x);

			LoadJoints(level, x);
			
			
			var i:int;
			var j:int;
			
			if (x.map.length() != 0)
			{
				level.map = new Array();
				var xm:XML = x.map[0];
				level.mapMinX=XmlHelper.GetAttrInt(xm.@minx, 0);
				level.mapMaxX=XmlHelper.GetAttrInt(xm.@maxx, 0);
				level.mapMinY=XmlHelper.GetAttrInt(xm.@miny, 0);
				level.mapMaxY = XmlHelper.GetAttrInt(xm.@maxy, 0);
				level.mapCellW = XmlHelper.GetAttrInt(xm.@cellw, 32);
				level.mapCellH = XmlHelper.GetAttrInt(xm.@cellh, 32);
				
				for (j = 0; j < xm.mapdata.length(); j++)
				{
					var xmd:XML = xm.mapdata[j];
					var xmdstr:String = XmlHelper.GetAttrString(xmd.@a, "");
					var pts:Array = Utils.HexArrayFromString(xmdstr);
					for each(var char:int in pts)
					{
						level.map.push(char);
					}					
				}			
			}
		}

		
		public static function GetCurrentLevelInstances():Array
		{
			if (currentIndex < 0) return null;
			if (currentIndex >= list.length) return null;
			LoadLevel(currentIndex, false);
			return list[currentIndex].instances;
		}

		public static function GetCurrentLevelJoints():Array
		{
			if (currentIndex < 0) return null;
			if (currentIndex >= list.length) return null;
			LoadLevel(currentIndex, false);
			return list[currentIndex].joints;
		}
		
		
		public static function GetLevel(_lev:int):Level
		{
			if (_lev < 0) return null;
			if (_lev >= list.length) return null;
			LoadLevel(_lev, false);
			return list[_lev];
		}

		
		public static function GetLevelById(_id:String):Level
		{
			var index:int = 0;
			for each(var l:Level in list)
			{
				if (l.id == _id) 
				{
					LoadLevel(index, false);
					return l;
				}
				index++;
			}
			return null;
		}

		public static function GetLevelIndexById(_id:String):int
		{
			var index:int = 0;
			for each(var l:Level in list)
			{
				if (l.id == _id) 
				{
					return index;
				}
				index++;
			}
			return 0;
		}
		
		public static function GetLevelIndexByName(_name:String):int
		{
			var index:int = 0;
			for each(var l:Level in list)
			{
				if (l.name == _name) 
				{
					return index;
				}
				index++;
			}
			return 0;
		}

		public static function GetLevelByName(_name:String):Level
		{
			for each(var l:Level in list)
			{
				if (l.name == _name) 
				{
					return l;
				}
			}
			return null;
		}
		
		public static function GetHighestAvailableLevelIndex():int
		{
			var index:int = 0;
			var i:int = 0;
			for each(var l:Level in list)
			{
				if (l.available)
				{
					index = i;
				}
				i++;
			}
			return index;
		}
		
		
		public static function GetLevelLight(_lev:int):Level
		{
			if (_lev < 0) return null;
			if (_lev >= list.length) return null;
			return list[_lev];
		}
		
		public static function CreateLevelObjInstanceAt(objName:String, _x:Number, _y:Number, _rotDeg:Number, _scale:Number,instanceName:String = "",params:String = "",_isXFlipped:Boolean=false):EdObj
		{
			var instance:EdObj = new EdObj();
			instance.typeName = objName;
			instance.x = _x;
			instance.y = _y;
			instance.rot = _rotDeg;
			instance.scale = _scale;
			instance.isXFlipped = _isXFlipped;
			instance.instanceName = instanceName;
			if (params != null)
			{
				instance.objParameters.CreateAllFromString(params);
			}
			return instance;			
		}

		public static function IncrementLevel()
		{
			currentIndex++;
			if (currentIndex >= list.length) currentIndex = 0;
		}
		
		public static function DecrementLevel()
		{
			currentIndex--;
			if (currentIndex < 0) currentIndex = list.length - 1;
		}
		
		
		public static function ClearAll()
		{
			for each(var l:Level in list)
			{
				l.locked = true;
				l.complete = false;
				l.available = false;
				l.bestScore = 0;
				l.percentage = 0;
				l.bestPercentage = 0;
				l.rating = 0;
				l.newlyAvailable = false;
				l.gotBonus = false;
				l.bestPlace = 999999999;
				l.bestTime = 999999999;
				l.endLightColor = 0;
				l.bestShots = 99999;
				l.completionLevel = 0;
				
				if (Game.unlockEverything)
				{
					l.locked = false;
					l.available = true;
				}
			}			
		}
		
		
		public static function ToByteArray(ba:ByteArray)
		{
			for each(var l:Level in list)
			{
				ba.writeInt(l.bestScore);
				ba.writeBoolean(l.available);
				ba.writeBoolean(l.complete);
				ba.writeBoolean(l.locked);
				ba.writeInt(l.bestPlace);
				ba.writeInt(l.bestTime);
				ba.writeBoolean(l.newlyAvailable);
				ba.writeBoolean(l.beenPlayed);
				ba.writeInt(l.rating);
				ba.writeInt(l.bestShots);
				ba.writeInt(l.completionLevel);
				ba.writeBoolean(l.gotBonus);
			}
		}
		
		public static function FromByteArray(ba:ByteArray)
		{
			for each(var l:Level in list)
			{									
				l.bestScore = ba.readInt();
				l.available = ba.readBoolean();
				l.complete = ba.readBoolean();
				l.locked = ba.readBoolean();
				l.bestPlace = ba.readInt();
				l.bestTime = ba.readInt();
				l.newlyAvailable = ba.readBoolean();
				l.beenPlayed = ba.readBoolean();
				l.rating = ba.readInt();
				l.bestShots = ba.readInt();
				l.completionLevel = ba.readInt();
				l.gotBonus =ba.readBoolean();
			}			
		}
		
		
	}

}