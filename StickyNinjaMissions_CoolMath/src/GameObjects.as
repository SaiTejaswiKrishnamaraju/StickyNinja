
package
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.getTimer;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;

	public class GameObjects
	{
		public static var objs:Vector.<GameObj>;
		public static var staticObjs:Vector.<GameObj>;
		public static var activeIndices:Vector.<int>;
		public static var inactiveIndices:Vector.<int>;
		public static var zorder:Array;
		public static var zorderVect:Vector.<GameObj_Base>;
		public static var zorderVectLength:int;
		public static var numActive:int;
		public static var numInactive:int;
		public static var numobjs:int;
		public static var numStaticObjs:int;
		
		
		public static function InitOnce(_numObjs:int)
		{
			numobjs = _numObjs;
			numStaticObjs = Defs.maxStaticGameObjects;
			objs = new Vector.<GameObj>(numobjs);
			staticObjs = new Vector.<GameObj>(numStaticObjs);
			zorder = new Array(numobjs);
			zorderVect = new Vector.<GameObj_Base>(1000, true);
			zorderVectLength = 0;

			var i;
			for(i=0; i<numobjs; i++)
			{
				objs[i] = new GameObj();
				objs[i].listIndex = i;
			}		

			for(i=0; i<numStaticObjs; i++)
			{
				staticObjs[i] = new GameObj();
				staticObjs[i].listIndex = i;
			}		
			
			numActive = 0;
			numInactive = numobjs; 
			
			dummyObject = new GameObj();
		}
		
		public function GameObjGroup()
		{
		}

		public static function ClearAll()
		{
			var i:int;
			for(i=0; i<numobjs; i++)
			{
				objs[i].active = false;
				objs[i].listIndex = i;
			}		
			for(i=0; i<numStaticObjs; i++)
			{
				staticObjs[i].active = false;
				staticObjs[i].listIndex = i;
			}		
			numActive = 0;
			numInactive = numobjs; 
		}

		public static function GetGOByIndex(_index:int):GameObj
		{
			return objs[_index];
		}
		
		
		public static var lastGenIndex:int;
		public static function AddObj(_xpos:Number,_ypos:Number,_zpos:Number):GameObj
		{
			
			var i:int;
			for(i=0; i<numobjs; i++)
			{				
				if(objs[i].active == false)
				{
					var go:GameObj = objs[i];
					go.active = true;
					go.zpos = _zpos;
					go.xpos = _xpos;
					go.ypos = _ypos;
					go.startx = _xpos;
					go.starty = _ypos;
					go.startz = _zpos;
					go.Init(0);
					lastGenIndex = i;
					
					return objs[i];
				}
			}	
			trace("ERROR! NO FREE OBJECTS");
			lastGenIndex = -1;
			return dummyObject;
		}

		public static function AddObjAtEnd(_xpos:Number,_ypos:Number,_zpos:Number):GameObj
		{
			
			var i:int;
			for(i=numobjs-1; i>=0; i--)
			{				
				if(objs[i].active == false)
				{
					var go:GameObj = objs[i];
					go.active = true;
					go.zpos = _zpos;
					go.xpos = _xpos;
					go.ypos = _ypos;
					go.startx = _xpos;
					go.starty = _ypos;
					go.startz = _zpos;
					go.Init(0);
					lastGenIndex = i;
					
					return objs[i];
				}
			}	
			trace("ERROR! NO FREE OBJECTS");
			lastGenIndex = -1;
			return dummyObject;
		}
		
		public static function AddStaticObj(_xpos:Number,_ypos:Number,_zpos:Number):GameObj
		{
			
			var i:int;
			for(i=0; i<numStaticObjs; i++)
			{				
				if(staticObjs[i].active == false)
				{
					var go:GameObj = staticObjs[i];
					go.active = true;
					go.zpos = _zpos;
					go.xpos = _xpos;
					go.ypos = _ypos;
					go.startx = _xpos;
					go.starty = _ypos;
					go.startz = _zpos;
					go.Init(0);
					go.isStaticObject = true;
					return staticObjs[i];
				}
			}	
			trace("ERROR! NO FREE STATIC OBJECTS");
			return dummyObject;
		}
		
		
		public static var dummyObject:GameObj;
		
		public static function ForEachActive(cb:Function):void
		{
			var go:GameObj;
			var list:Array = new Array();
			for each(go in objs)
			{
				if (go.active)
				{
					cb(go)
				}
			}
		}
		
		
		var v:Vector.<GameObj> = new Vector.<GameObj>(1000);
		// render all objects taking z order into account
		public static function zcompare(x:Point, y:Point):Number
		{
			if (x.y > y.y) return -1;
			if (x.y < y.y) return 1;
			return 0;
			
		}
		
		
		static var q0:Vector.<GameObj_Base> = new Vector.<GameObj_Base>(256, true);
		static var q1:Vector.<GameObj_Base> = new Vector.<GameObj_Base>(256, true);
		
		static function RadixSort(a:Vector.<GameObj_Base>,totalLength:int)
		{
			if (totalLength == 0) return;
			var first:GameObj_Base;
			
			for (var i:int = 0; i < 256; i++)
			{
				q0[i] = null;
				q1[i] = null;
			}
			
			for (var i:int = 0; i < totalLength - 1; i++)
			{
				a[i].next = a[i + 1];
			}
			a[totalLength - 1].next = null;
			
			first = a[0];
			
            
            var i:int = 0;
            var k:int;
            var f:GameObj_Base = first;
            var p:GameObj_Base, c:GameObj_Base;
            c = f;
            while (c) {
                c.sort = q0[k = (255 & c.zposInt)];
                q0[k] = c;
                c = c.next;
            }
            
            i = 256;
            while (i--) {
                c = q0[i];
                while (c) {
                    p = c.sort;
                    c.sort = q1[k = (65280 & c.zposInt) >> 8];
                    q1[k] = c;
                    c = p;
                }
            }
            
			var index:int = totalLength-1;
			var output:int;
            i = 0;
            k = 0;
//            trace("sorted----");
            while (i < 255) {
                c = q1[i];
                while (c) {
                    output = c.zposInt;
					a[index--] = c;
//                    trace(output);
                    c = c.sort;
                }
                i++;
            }
            	
//			trace("sorted lengths: " + a.length + "  " + index);
//			return a;
		}
		
		public static function Render(bd:BitmapData):void
		{
			var go:GameObj;
			var i:int;

			
			var numclipped:int = 0;
			var numnotclipped:int = 0;
			var staticsRendered:int = 0;

			i = 0;
			for each(go in objs)
			{
				if (go.active)
				{
					if (go.TestClip() == false)
					{
						go.zposInt = int(go.zpos+20000);
						zorderVect[i++] = go;
						numnotclipped++;
					}
					else
					{
						numclipped++;
					}
				}
			}
			
			var loopCount:int = 1;
			

			for (var lp:int = 0; lp < loopCount; lp++)
			{
				for each(go in staticObjs)
				{
					if (go.active)
					{
						if (go.TestClip() == false)
						{
							go.zposInt = int(go.zpos + 20000);
							zorderVect[i++] = go;
							numnotclipped++;
							staticsRendered++;
						}
						else
						{
							numclipped++;
						}
					}				
				}
			}
			
			//trace("clip: " + numnotclipped + " " + numclipped);
//			trace("staticsRendered: " + staticsRendered);
			
			
//			for each(var go:GameObj in objs)
//			{
//				go.Render(bd);
//			}
//			return;
			
			
			
			/*
			i = 0;
			zorder.splice(0, zorder.length);
			for each(go in objs)
			{
				if (go.active && go.visible)
				{
					go.zposInt = int(go.zpos);
					zorder.push(go);
					i++;
				}
			}
			for each(go in staticObjs)
			{
				if (go.active && go.visible)
				{
					go.zposInt = int(go.zpos);
					zorder.push(go);
					i++;
				}
			}
			zorder.sortOn("zpos",Array.NUMERIC|Array.DESCENDING);
			*/


			/*
			i = 0;
			for each(go in objs)
			{
				if (go.active && go.visible)
				{
					go.zposInt = int(go.zpos+20000);
					zorderVect[i] = go;
					i++;
				}
			}
			for each(go in staticObjs)
			{
				if (go.active && go.visible)
				{
					go.zposInt = int(go.zpos+20000);
					zorderVect[i] = go;
					i++;
				}
			}
			*/
			
			zorderVectLength = i;

			RadixSort(zorderVect,zorderVectLength);
			
			
			
			
			for (var a:int = 0; a <i; a++)
			{
				go = zorderVect[a] as GameObj;
				//go = zorder[a];
				go.Render(bd);
			}

			
		}

		// Update all objects if they are active.
		public static function CountByName(_name:String):int
		{
			var count:int = 0;
			var i:int;
			for(i=0; i<objs.length; i++)
			{
				if(objs[i].active == true && objs[i].name == _name )
				{
					count++;
				}
			}
			return count;
		}
		public static function CountActive():int
		{
			var count:int = 0;
			var i:int;
			for(i=0; i<objs.length; i++)
			{
				if(objs[i].active == true)
				{
					count++;
				}
			}
			return count;
		}
		public static function CountStaticActive():int
		{
			var count:int = 0;
			var i:int;
			for(i=0; i<staticObjs.length; i++)
			{
				if(staticObjs[i].active == true)
				{
					count++;
				}
			}
			return count;
		}
		
		public static function Update():void
		{

			for each(var go:GameObj in objs)
			{
				if(go.active == true)
				{					
					go.Update();
				}
			}
			
		}
		public static function UpdateWalkthroughObjects():void
		{

			for each(var go:GameObj in objs)
			{
				if(go.active == true)
				{
					if (go.updateInWalkthrough)
					{
						go.Update();
					}
				}
			}
			
		}
		public static function KillObjects():void
		{
			for each(var go:GameObj in objs)
			{
				if(go.active == true && go.killed)
				{
					go.active = false;	
					if (go.removeFunction != null)
					{
						go.removeFunction();
					}
//					deleteList.push(go);
				}
			}
			
//			for each(go in deleteList)
//			{
//				if (go.removeFunction != null)
//				{
//					go.removeFunction();
//				}
//			}			
			
		}
		
		static var addList:Array;
		public static function DoAddList():void
		{
			for each(var o1:Object in addList)
			{
				o1.fn(o1.o);
			}
		}
		public static function ClearAddList():void
		{
			if (addList == null || addList.length != 0)
			{
			addList = new Array();
			}
		}

		public static function AddToAddList(_fn:Function,ob:Object):void
		{
			var o1:Object = new Object();
			o1.fn = _fn;
			o1.o = ob;
			addList.push(o1);
		}
		
//---------------------------------------------------------------------------------------------------------		
		
		static function GetGameObjListByNameList(names:String):Array
		{
			var list:Array = new Array;
			
			var nameList:Array = names.split(",");
			for each(var name:String in nameList)
			{
				var l1:Array = GetGameObjListByName(name);
				for each(var go:GameObj in l1)
				{
					list.push(go);
				}
				l1 = null;
			}
			return list;
		}

		
		static function GetGameObjListByName(name:String):Array
		{
			var list:Array = new Array();
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active==true && go.name == name)
				{
					list.push(go);
				}
			}
			return list;
		}
		static function GetGameObjVectorByName(name:String):Vector.<GameObj>
		{
			var list:Vector.<GameObj> = new Vector.<GameObj>();
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active==true && go.name == name)
				{
					list.push(go);
				}
			}
			return list;
		}

		static function GetGameObjByName(name:String):GameObj
		{
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active==true && go.name == name)
				{
					return go;
				}
			}
			return null;
		}
		
		
		static function GetGameObjById(id:String):GameObj
		{
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active==true && go.id == id)
				{
					return go;
				}
			}
			return null;
		}

		static function GetGameObjByLineName(name:String):GameObj
		{
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.linkedPhysLine != null)
				{
					if (go.linkedPhysLine.id == name) return go;
				}
			}
			return null;
		}
		
		
		static function GetGameObjListByFlag(name:String):Array
		{
			var list:Array = new Array();
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active==true && go[name] == true)
				{
					list.push(go);
				}
			}
			return list;
		}
		
		static function GetNearestGameObjByName(name:String, x:Number, y:Number):GameObj
		{
			var nearestGO:GameObj;
			var nearestD:int = 999999;
			var go:GameObj;
			for each(go in GameObjects.objs)
			{
				if (go.active && go.name == name)
				{
					var d:Number = Utils.DistBetweenPoints(x, y, go.xpos, go.ypos);
					if (d < nearestD)
					{
						nearestD = d;
						nearestGO = go;
					}
				}
			}
			return nearestGO;
		}
		
		
		static function UpdateSingleGOsFromPhysics(go:GameObj):void
		{
			go.xpos = go.nape_bodies[0].position.x;
			go.ypos =  go.nape_bodies[0].position.y;
		}
		
		static function UpdateGOsFromPhysics_Nape():void
		{
			var go:GameObj;
			
			var objs:Vector.<GameObj> = GameObjects.objs;
			
			var bodyList:BodyList = PhysicsBase.GetNapeSpace().bodies;
			
			for (var i:int = 0; i < bodyList.length; i++) 
			{
				var b:Body = bodyList.at(i);
				var bud:PhysObj_BodyUserData = b.userData.data as PhysObj_BodyUserData;
				if (bud != null)
				{
					go = bud.gameObject;
					
					if (go != null)
					{
						if (go.updateFromPhysicsFunction != null)
						{
							go.updateFromPhysicsFunction(b);
						}
						else
						{
							go.oldxpos = go.xpos;
							go.oldypos = go.ypos;
							go.oldDir = go.dir;
							
							go.xpos = b.position.x;
							go.ypos = b.position.y;
							go.dir = b.rotation;								
						}
					}
				}
			}
		}
		
		static function PreUpdateGOsBeforePhysics():void
		{
			var go:GameObj;
			
			var objs:Vector.<GameObj> = GameObjects.objs;
			
			var bodyList:BodyList = PhysicsBase.GetNapeSpace().bodies;
			for (var i:int = 0; i < bodyList.length; i++) 
			{
				var b:Body = bodyList.at(i);
				var bud:PhysObj_BodyUserData = b.userData.data as PhysObj_BodyUserData;
				if (bud != null)
				{
					go = bud.gameObject;
					
					if (go != null)
					{
						go.oldxpos = go.xpos;
						go.oldypos = go.ypos;
						go.oldrot = go.dir;
					}
				}
			}
			
			
//			for each(var go:GameObj in GameObjects.objs)
//			{
//				if (go.active)
//				{
//					go.oldxpos = go.xpos;
//					go.oldypos = go.ypos;
//					go.oldrot = go.dir;
//				}
//			}
		}
		

		
	}
	
	
}
