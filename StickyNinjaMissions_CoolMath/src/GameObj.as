package
{
	import AnimPackage.AnimDefinitions;
	import AnimPackage.AnimPlayer;
	import AudioPackage.Audio;
	import com.adobe.net.proxies.RFC2817Socket;
	import EditorPackage.EdJoint;
	import EditorPackage.EdObj;
	import EditorPackage.EdObjMarker;
	import EditorPackage.GameLayers;
	import EditorPackage.PhysEditor;
	import fl.managers.IFocusManager;
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.media.SoundChannel;
	import flash.ui.GameInputControl;
	import flash.ui.Mouse;
	import LicPackage.Lic;
	import LicPackage.LicDef;
	import MissionPackage.Missions;
	import MobileSpecificPackage.MobileSpecific;
	import nape.callbacks.InteractionCallback;
	import nape.constraint.AngleJoint;
	import nape.constraint.Constraint;
	import nape.constraint.DistanceJoint;
	import nape.constraint.MotorJoint;
	import nape.constraint.PivotJoint;
	import nape.constraint.WeldJoint;
	import nape.dynamics.Arbiter;
	import nape.dynamics.ArbiterList;
	import nape.dynamics.CollisionArbiter;
	import nape.dynamics.Contact;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Ray;
	import nape.geom.RayResult;
	import nape.geom.Vec2;
	import nape.geom.Vec3;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import PlayerRecordPackage.PlayerRecordAction;
	import PlayerRecordPackage.PlayerRecording;
	import PlayerRecordPackage.PlayerRecordingItem;
	import PlayerRecordPackage.PlayerRecordings;
	import TextPackage.TextRenderer;

	public class GameObj extends GameObj_Base
	{

		
//----------------------------------------------------------------------------------------
// Render functions:
//----------------------------------------------------------------------------------------


		function ShowHealthBar()
		{
			healthBarTimer = Defs.fps * 1;
		}
		function RenderHealthBar(_xoff:int,_yoff:int):void
		{
			if (healthBarTimer > 0)
			{
				var x:Number = (xpos + _xoff) - Game.camera.x;
				var y:Number = (ypos + _yoff) - Game.camera.y;
				
				
				if (PROJECT::useStage3D == false)
				{
					var rect:Rectangle = new Rectangle( x- 10, y, 20, 3);
					bd.fillRect(rect, 0xff000000);
					rect.width = Utils.ScaleTo(0, 20, 0, maxHealth, health);
					bd.fillRect(rect, 0xffff0000);
				}
			}

		}
		
		
			

		
		
		


//---------------------------------------------------------------------------------------------------


		var textMessage:String;
		var textMessage1:String;
		public function InitTextMessage(_message:String,_x:Number,_y:Number):void
		{
			textMessage = _message;
			
			updateFunction = UpdateTextMessage;
			renderFunction = RenderTextMessage;
			timer = 50;
			yvel = 0;
			zpos = -1000;
			yvel = 0;
			scale = 1;
			zvel = 0.1;
			alpha = 1;
			
		}
		function RenderTextMessage()
		{
			
			var x:Number = xpos;
			var y:Number = ypos;
			
//			var w:Number = GraphicObjects.GetStringWidth(bd, GraphicObjects.gfx_font1, x, y, textMessage);
//			GraphicObjects.RenderStringAt(bd, GraphicObjects.gfx_font1, x-(w/2), y, textMessage);
			
//			GraphicObjects.RenderStringBD(GraphicObjects.gfx_font2, textMessage);
//			GraphicObjects.RenderStringBDAt(bd, x, y,scale,0,alpha,1,1);
			
		}
		function UpdateTextMessage()
		{
			yvel -= 0.02;
			ypos += yvel;
			
			timer--;
			if (timer <= 0)
			{
				timer = 0;
				RemoveObject();
			}

			//scale -= 0.02;
			//alpha -= 0.05;
			//if (alpha < 0)
			//{
			//	alpha = 0;
			//	RemoveObject();
			//}

		}

//------------------------------------------------------------------------------	

		
		public function InitMessage(_type:int):void
		{
			updateFunction = UpdateMessage;
			timer = Defs.fps *0.8
			frame = _type;
			dobj = GraphicObjects.GetDisplayObjByName("StartRaceText");
			
		}
		function UpdateMessage()
		{
			xpos = 320 + Game.camera.x;
			ypos = 100 + Game.camera.y;
			timer--;
			if (timer <= 0)
			{
				RemoveObject();
			}
		}

//------------------------------------------------------------------------------		
		

//------------------------------------------------------------------------------------------------------------			
		

//------------------------------------------------------------------------------------------------------------			
		
		public var physObjOffsetX:Number;
		public var physObjOffsetY:Number;
		public var physObjInitVarString:String;
		public function InitPhysicsObject(_gid:int, _frame:int, _offsetX:Number = 0, _offsetY:Number = 0 ,_initvarstring:String="",_hasShadow:Boolean=false)
		{
			/*
			
			colFlag_isPhysObj = true;
			physObjOffsetX = _offsetX;
			physObjOffsetY = _offsetY;
			isPhysObj = true;
			dobj = GraphicObjects.GetDisplayObjByIndex(_gid);
			frame = _frame;
			updateFunction = UpdatePhysicsObject;
			renderShadowFlag = _hasShadow;
			physObjInitVarString = _initvarstring;
			*/
			
		}
		public function UpdatePhysicsObject()
		{
		}
		

		
		public function SetMarkerPos(x:Number, y:Number)
		{
			if (visible == false)
			{
				xpos = x;
				ypos = y;			
			}
			toPosX = x;
			toPosY = y;
			
			visible = true;
		}


//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				
		
		var fillScreenMCListMiniMap:Vector.<Shape>;
		var fillScreenMCList:Vector.<Shape>;
		var fillScreenMC:Shape;
		var fillScreenMCMiniMap:Shape;

		var surfacePointsList0:Vector.<Point>;
		var surfacePointsList1:Vector.<Point>;
		var surfacePointsList2:Vector.<Point>;
		var surfacePointsList3:Vector.<Point>;
		var surfacePointsList4:Vector.<Point>;
		
		
		
		
		function PreRenderPhysicsLineObject_Ceiling_PointsList()
		{
			surfacePointsList0 = new Vector.<Point>();
			surfacePointsList1 = new Vector.<Point>();
			surfacePointsList2 = new Vector.<Point>();
			
			fillScreenMC = new Shape();
			fillScreenMC.x = 0;
			fillScreenMC.y = 0;
			
			fillScreenMCList = new Vector.<Shape>();
			fillScreenMCListMiniMap = new Vector.<Shape>();
			
			var p0:Point;
			var p1:Point;
			var p2:Point;
			
			
			var surface_depth:Number = linkedPhysLine.objParameters.GetValueNumber("surface_depth");
			var surface_random:Number = linkedPhysLine.objParameters.GetValueNumber("surface_random");
			
			
			var num:int = linkedPhysLine.points.length;
			
			for (var i:int = 0; i < num; i++)
			{
				var p:Point = linkedPhysLine.points[i];
				p0 = p.clone();
				p1 = p0.clone();
				p1.y -= Utils.RandBetweenInt(surface_depth-surface_random,surface_depth+surface_random);
				p2 = p0.clone();
				p2.y -= 900;
				
				surfacePointsList0.push(p0);
				surfacePointsList1.push(p1);
				surfacePointsList2.push(p2);
			}
			
			s3dTriListIndex = -1;
			
		}
			
		
//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				

		var surfaceSegmentMinMaxXList:Array;
		var surfaceSegmentList0:Array;
		var surfaceSegmentList1:Array;
		var surfaceSegmentList2:Array;
		
//---------------------------------------------------------------------------------------------------		
//---------------------------------------------------------------------------------------------------		
//---------------------------------------------------------------------------------------------------		
		
		function RenderPhysicsLineObject_Ceiling_PointsList()
		{
			RenderPhysicsLineObject_Ceiling_PointsList_Inner(0, 0);
		}
		
//---------------------------------------------------------------------------------------------------		
		
		function RenderPhysicsLineObject_Ceiling_PointsList_Inner(_offsetX:Number,_offsetY:Number)
		{
			
			var xp:Number;
			var yp:Number;
			xp = Math.round(Game.camera.x);
			yp = Math.round(Game.camera.y);
			
			xp += _offsetX;
			yp += _offsetY;
			
			
			gmat.identity();
			gmat.translate(-xp,-yp);
			
			
			var len:int = surfacePointsList0.length;
			var foundA:Boolean= false;
			var foundB:Boolean = false;
			
			var x0:int = Game.camera.x;
			var x1:int = x0 + Defs.displayarea_w;

			var firstIndex:int = 0;
			var lastIndex:int = 100;
			
			var centreIndex:int = len / 2;
			var current:int = 0;
			var lookRight:Boolean = true;
			
			
			for (var i:int = 0; i < len; i++)
			{
				if (foundA == false)
				{
					if (surfacePointsList0[i].x > x0)
					{
						foundA = true;
						firstIndex = i - 1;
					}
				}
				if (foundB == false)
				{
					if (surfacePointsList0[i].x > x1)
					{
						foundB = true;
						lastIndex = i;
					}
				}
			}
			
				
			firstIndex = Utils.LimitNumber(0, len - 1, firstIndex);
			lastIndex = Utils.LimitNumber(0, len - 1, lastIndex);
			
			if (firstIndex == lastIndex)
			{
				return;
			}

			var g:Graphics = fillScreenMC.graphics;
			g.clear();
			g.lineStyle(null, null, 0);

//			firstIndex = 0;
//			lastIndex = 100;
			
			var p0:Point = new Point();
			
//			var bottom:int = Defs.displayarea_h;
			var top:int = 0;
			

			g.beginBitmapFill(dobj.GetBitmapData(frame), gmat, true);
			
			p0 = surfacePointsList0[lastIndex];
			g.moveTo(p0.x-xp, p0.y-yp);
			for (var index:int = lastIndex; index >= firstIndex; index--)
			{
				p0 = surfacePointsList0[index];
				g.lineTo(p0.x-xp, p0.y-yp);
				
			}
			p0 = surfacePointsList1[firstIndex];
			g.lineTo(p0.x-xp, top);
			p0 = surfacePointsList1[lastIndex];
			g.lineTo(p0.x-xp, top);
			g.endFill();
			
			/*
			p0 = surfacePointsList0[firstIndex];
			g.moveTo(p0.x-xp, p0.y-yp);
			g.lineStyle(6, 0x0, 1);
			g.lineBitmapStyle(dobj.GetBitmapData(frame1),gmat);
			for (var index:int = firstIndex; index <= lastIndex; index++)
			{
				var p0:Point = surfacePointsList0[index];
				g.lineTo(p0.x-xp, p0.y-yp);
			}
			*/


			
			bd.draw(fillScreenMC);	// , null, null, null, bd.rect, false);				
			
		}

		
		
//---------------------------------------------------------------------------------------------------		
//---------------------------------------------------------------------------------------------------		
//---------------------------------------------------------------------------------------------------		
		
		function RenderPhysicsLineObject_Surface_PointsList()
		{
			RenderPhysicsLineObject_Surface_PointsList_Inner(0, 0);
//			RenderPhysicsLineObject_Surface_PointsList_Inner(0, 30);
//			RenderPhysicsLineObject_Surface_PointsList_Inner(0,-30);
		}
		
//---------------------------------------------------------------------------------------------------		
		
		function RenderPhysicsLineObject_Surface_PointsList_Inner(_offsetX:Number,_offsetY:Number)
		{
			
			var xp:Number;
			var yp:Number;
			xp = Math.round(Game.camera.x);
			yp = Math.round(Game.camera.y);
			
			xp += _offsetX;
			yp += _offsetY;
			
			
			gmat.identity();
			gmat.translate(-xp,-yp);
			
			
			var len:int = surfacePointsList0.length;
			var foundA:Boolean= false;
			var foundB:Boolean = false;
			
			var x0:int = Game.camera.x;
			var x1:int = x0 + Defs.displayarea_w;

			var firstIndex:int = 0;
			var lastIndex:int = 100;
			
			var centreIndex:int = len / 2;
			var current:int = 0;
			var lookRight:Boolean = true;
			
			
			for (var i:int = 0; i < len; i++)
			{
				if (foundA == false)
				{
					if (surfacePointsList0[i].x > x0)
					{
						foundA = true;
						firstIndex = i - 1;
					}
				}
				if (foundB == false)
				{
					if (surfacePointsList0[i].x > x1)
					{
						foundB = true;
						lastIndex = i;
					}
				}
			}
			
				
			firstIndex = Utils.LimitNumber(0, len - 1, firstIndex);
			lastIndex = Utils.LimitNumber(0, len - 1, lastIndex);
			
			if (firstIndex == lastIndex)
			{
				return;
			}

			var g:Graphics = fillScreenMC.graphics;
			g.clear();
			g.lineStyle(null, null, 0);

//			firstIndex = 0;
//			lastIndex = 100;
			
			var p0:Point = new Point();
			
			var bottom:int = Defs.displayarea_h;
			
			/*
			g.beginBitmapFill(dobj.GetBitmapData(frame), gmat,true);
			
			p0 = surfacePointsList0[firstIndex];
			g.moveTo(p0.x-xp, p0.y-yp);
			for (var index:int = firstIndex; index <= lastIndex; index++)
			{
				p0 = surfacePointsList0[index];
				g.lineTo(p0.x-xp, p0.y-yp);
				
			}
			for (var index:int = lastIndex; index >= firstIndex; index--)
			{
				p0 = surfacePointsList1[index];
				g.lineTo(p0.x-xp, p0.y-yp);
				
			}
			g.endFill();
			*/

			g.beginBitmapFill(dobj.GetBitmapData(frame), gmat, true);
			
			//p0 = surfacePointsList1[firstIndex];
			p0 = surfacePointsList0[firstIndex];
			g.moveTo(p0.x-xp, p0.y-yp);
			for (var index:int = firstIndex; index <= lastIndex; index++)
			{
				//p0 = surfacePointsList1[index];
				p0 = surfacePointsList0[index];
				g.lineTo(p0.x-xp, p0.y-yp);
				
			}
			p0 = surfacePointsList1[lastIndex];
			g.lineTo(p0.x-xp, bottom);
			p0 = surfacePointsList1[firstIndex];
			g.lineTo(p0.x-xp, bottom);
			g.endFill();
			
			
			p0 = surfacePointsList0[firstIndex];
			g.moveTo(p0.x-xp, p0.y-yp);
			g.lineStyle(6, 0x0, 1);
			g.lineBitmapStyle(dobj.GetBitmapData(frame1),gmat);
			for (var index:int = firstIndex; index <= lastIndex; index++)
			{
				var p0:Point = surfacePointsList0[index];
				g.lineTo(p0.x-xp, p0.y-yp);
			}
			


			
			bd.draw(fillScreenMC);	// , null, null, null, bd.rect, false);				
			
		}


		function RenderPhysicsLineObject_Surface_PointsList_Minimap()
		{


			var xp:Number;
			var yp:Number;
			xp = Game.camera.x;
			yp = Game.camera.y;
			
			
			var g:Graphics = fillScreenMC.graphics;
			g.clear();
			
			gmat.identity();
			gmat.translate(-xp,-yp);
			
			g.lineStyle(null, null, 0);
			
			var len:int = surfacePointsList0.length;
			var foundA:Boolean= false;
			var foundB:Boolean = false;
			
			var x0:int = Game.camera.x;
			var x1:int = x0 + Defs.displayarea_w*3;

			var firstIndex:int = 0;
			var lastIndex:int = 0;
			
			for (var i:int = 0; i < len; i++)
			{
				if (foundA == false)
				{
					if (surfacePointsList0[i].x > x0)
					{
						foundA = true;
						firstIndex = i - 1;
					}
				}
				if (foundB == false)
				{
					if (surfacePointsList0[i].x > x1)
					{
						foundB = true;
						lastIndex = i;
					}
				}
			}
			
			firstIndex = Utils.LimitNumber(0, len - 1, firstIndex);
			lastIndex = Utils.LimitNumber(0, len - 1, lastIndex);
			
			if (lastIndex <= firstIndex)
			{
				lastIndex = len - 1;
			}
			
//			Utils.trace(firstIndex + "  " + lastIndex);
			
//			firstIndex = 0;
//			lastIndex = 100;
			
			var p0:Point = new Point();
			var p1:Point = new Point();
			var p2:Point = new Point();
			var p3:Point = new Point();
			var p4:Point = new Point();
			var p5:Point = new Point();
			
			var bottom:int = Defs.displayarea_h;
			
			
			g.lineStyle(1, 0xffffff, 1);
			p0 = surfacePointsList0[firstIndex];
			var x:Number = (p0.x - xp) * 0.1;
			var y:Number = (p0.y - yp) * 0.1;
			g.moveTo(x,y);
			for (var index:int = firstIndex; index <= lastIndex; index++)
			{
				var p0:Point = surfacePointsList0[index];
				
				var x:Number = (p0.x - xp) * 0.1;
				var y:Number = (p0.y - yp) * 0.1;
				
				g.lineTo(x,y);
			}
			bd.draw(fillScreenMC);
			
		}

		
		function PreRenderPhysicsLineObject_Surface_MultiPartAAAAA()
		{
			fillScreenMCList = new Vector.<Shape>();
			fillScreenMCListMiniMap = new Vector.<Shape>();
			
			var p0:Point;
			var p1:Point;
			var p2:Point;
			
			
			var numSegs:int = 60;
			
			var num:int = linkedPhysLine.points.length;
			var totalw:int = linkedPhysLine.points[num - 1].x - linkedPhysLine.points[0].x;
			
			numSegs = totalw / 300;
			
			
			for (var seg:int = 0; seg < numSegs; seg++)
			{
				var newpoints:Array = new Array();
				var newpoints1:Array = new Array();
				var newpoints2:Array = new Array();
			
				var aa:int = int(num / numSegs);
				var first:int = int(seg * aa);
				var last:int = first + aa;
				
				
				if (last >= num) last = num;
				
			
				for (var i:int = first; i <= last; i++)
				{
					var p:Point = linkedPhysLine.points[i];
					p0 = p.clone();
					p1 = p0.clone();
					p1.y += Utils.RandBetweenInt(20,60);
					p2 = p0.clone();
					p2.y += 1000;
					newpoints.push(p0);
					newpoints1.push(p1);
					newpoints2.push(p2);				
				}			
				
				
				
				// prebuild the draw itself.

				fillScreenMC = new Shape();
				fillScreenMC.x = 0;
				fillScreenMC.y = 0;

				fillScreenMCMiniMap = new Shape();
				fillScreenMCMiniMap.x = 0;
				fillScreenMCMiniMap.y = 0;
				
				var g:Graphics = fillScreenMC.graphics;
				g.clear();
				
				g.lineStyle(null, null, 0);
				
				g.beginBitmapFill(dobj.GetBitmapData(frame), null, true);
				var p0:Point = newpoints[0];
				g.moveTo(p0.x, p0.y);
				for (var i:int = 1; i < newpoints.length; i++)
				{
					var p0:Point = newpoints[i];
					g.lineTo(p0.x, p0.y);
				}
				for (var i:int = newpoints1.length - 1; i >= 0; i--)
				{
					var p0:Point = newpoints1[i];
					g.lineTo(p0.x, p0.y);
				}
				g.endFill();
				
				g.beginBitmapFill(dobj.GetBitmapData(frame+1), null, true);
				var p0:Point = newpoints1[0];
				g.moveTo(p0.x, p0.y);
				for (var i:int = 1; i < newpoints1.length; i++)
				{
					var p0:Point = newpoints1[i];
					g.lineTo(p0.x, p0.y);
				}
				
				var p0:Point = newpoints2[newpoints2.length - 1];
				g.lineTo(p0.x, p0.y);
				var p0:Point = newpoints2[0];
				g.lineTo(p0.x, p0.y);
				
				/*
				for (var i:int = newpoints2.length - 1; i >= 0; i--)
				{
					var p0:Point = newpoints2[i];
					g.lineTo(p0.x, p0.y);
				}
				*/
				g.endFill();
				
				

				g.lineStyle(4, 0x0, 1);
				g.lineBitmapStyle(dobj1.GetBitmapData(frame),null);
				var p0:Point = newpoints[0];
				g.moveTo(p0.x, p0.y);
				for (var i:int = 1; i < newpoints.length; i++)
				{
					var p0:Point = newpoints[i];
					g.lineTo(p0.x, p0.y);
				}

				fillScreenMCList.push(fillScreenMC);

				var g:Graphics = fillScreenMCMiniMap.graphics;
				g.clear();
				g.lineStyle(7, 0xffffff, 1);
				var p0:Point = newpoints[0];
				g.moveTo(p0.x, p0.y);
				for (var i:int = 1; i < newpoints.length; i++)
				{
					var p0:Point = newpoints[i];
					g.lineTo(p0.x, p0.y);
				}

				fillScreenMCListMiniMap.push(fillScreenMCMiniMap);
				
			}
			
		}
		
		
		function PreRenderPhysicsLineObject_Surface()
		{
			var newpoints:Array = new Array();
			var newpoints1:Array = new Array();
			var newpoints2:Array = new Array();
			var p0:Point;
			var p1:Point;
			var p2:Point;
			
			for each(var p:Point in linkedPhysLine.points)
			{
				p0 = p.clone();
				p1 = p0.clone();
				p1.y += Utils.RandBetweenInt(20,60);
				p2 = p0.clone();
				p2.y += 600;
				newpoints.push(p0);
				newpoints1.push(p1);
				newpoints2.push(p2);				
			}			
			
			
			
			// prebuild the draw itself.
			if (true)
			{
				fillScreenMCMiniMap = new Shape();
				fillScreenMC = new Shape();
				fillScreenMCMiniMap.x = 0;
				fillScreenMCMiniMap.y = 0;
				fillScreenMC.x = 0;
				fillScreenMC.y = 0;

				var g:Graphics = fillScreenMC.graphics;
				g.clear();
				
				g.lineStyle(null, null, 0);
				
				g.beginBitmapFill(dobj.GetBitmapData(frame), null, true);
				var p0:Point = newpoints[0];
				g.moveTo(p0.x, p0.y);
				for (var i:int = 1; i < newpoints.length; i++)
				{
					var p0:Point = newpoints[i];
					g.lineTo(p0.x, p0.y);
				}
				for (var i:int = newpoints1.length - 1; i >= 0; i--)
				{
					var p0:Point = newpoints1[i];
					g.lineTo(p0.x, p0.y);
				}
				g.endFill();
				
				g.beginBitmapFill(dobj.GetBitmapData(frame+1), null, true);
				var p0:Point = newpoints1[0];
				g.moveTo(p0.x, p0.y);
				for (var i:int = 1; i < newpoints1.length; i++)
				{
					var p0:Point = newpoints1[i];
					g.lineTo(p0.x, p0.y);
				}
				for (var i:int = newpoints2.length - 1; i >= 0; i--)
				{
					var p0:Point = newpoints2[i];
					g.lineTo(p0.x, p0.y);
				}
				g.endFill();
				
				

				g.lineStyle(4, 0x0, 1);
				g.lineBitmapStyle(dobj1.GetBitmapData(frame),null);
				var p0:Point = newpoints[0];
				g.moveTo(p0.x, p0.y);
				for (var i:int = 1; i < newpoints.length; i++)
				{
					var p0:Point = newpoints[i];
					g.lineTo(p0.x, p0.y);
				}

				var g:Graphics = fillScreenMCMiniMap.graphics;
				g.clear();
				g.lineStyle(7, 0xffffff, 1);
				var p0:Point = newpoints[0];
				g.moveTo(p0.x, p0.y);
				for (var i:int = 1; i < newpoints.length; i++)
				{
					var p0:Point = newpoints[i];
					g.lineTo(p0.x, p0.y);
				}

			}
			
		}
		
		
		function PreRenderPhysicsLineObject_Background()
		{
			var newpoints:Array = new Array();
			var newpoints1:Array = new Array();
			var newpoints2:Array = new Array();
			var p0:Point;
			var p1:Point;
			var p2:Point;
			
			for each(var p:Point in linkedPhysLine.points)
			{
				p0 = p.clone();
				newpoints.push(p0);
			}			
			
			
			
			// prebuild the draw itself.
			if (true)
			{
				fillScreenMC = new Shape();
				fillScreenMC.x = 0;
				fillScreenMC.y = 0;

				var g:Graphics = fillScreenMC.graphics;
				g.clear();
				
				g.lineStyle(null, null, 0);
				
				g.beginBitmapFill(dobj.GetBitmapData(frame), null, true);
				var p0:Point = newpoints[0];
				g.moveTo(p0.x, p0.y);
				for (var i:int = 1; i < newpoints.length; i++)
				{
					var p0:Point = newpoints[i];
					g.lineTo(p0.x, p0.y);
				}
				g.endFill();
			}
			
		}
		
		
		function RenderPhysicsLineObject_Surface_MiniMap()
		{
		}

		function RenderPhysicsLineObject_Surface_MiniMap_MultiPart()
		{
			
		}
		
		
		function RenderPhysicsLineObject_Surface_MultiPart()
		{
			
			var sx:Number = Math.round(Game.camera.x);
			var sy:Number = Math.round(Game.camera.y);
			
			var xadd:Number = xpos - sx;
			var yadd:Number = ypos - sy;

			var xp:Number;
			var yp:Number;
			xp = xpos - Game.camera.x;
			yp = ypos - Game.camera.y;

			gmat.identity();
			gmat.translate(xp, yp);
			
			for each(fillScreenMC in fillScreenMCList)
			{			
				var r0:Rectangle = fillScreenMC.getBounds(null);
				var r1:Rectangle = fillScreenMC.getRect(null);
//				Utils.trace(r0+"  "+ r1);

				if (r0.x > Game.camera.x + Defs.displayarea_w)
				{
					
				}
				else if (r0.right < Game.camera.x)
				{
					
				}
				else
				{

					bd.draw(fillScreenMC, gmat, null, null, bd.rect, false);				
				}
			}
			
		}
		
		function RenderPhysicsLineObject_Surface()
		{
			
			var sx:Number = Math.round(Game.camera.x);
			var sy:Number = Math.round(Game.camera.y);
			
			var xadd:Number = xpos - sx;
			var yadd:Number = ypos - sy;

			var xp:Number;
			var yp:Number;
			xp = xpos - Game.camera.x;
			yp = ypos - Game.camera.y;

			
			// just render the prebuilt one, with scroll offset.
			if (true)
			{
				gmat.identity();
				gmat.translate(xp, yp);
				bd.draw(fillScreenMC,gmat, null, null, bd.rect, true);				
			}
			
		}

//-------------------------------------------------------------------------------------------

		function RenderGameObjLine_Surface()
		{
			if (PROJECT::useStage3D)
			{
				GameObjPolyRenderer.RenderPhysicsLineObject_Surface_Stage3D(this)
			}
			else
			{
				GameObjPolyRenderer.RenderPhysicsLineObject_Surface_PointsList(this);
			}			
		}
		
		public function InitGameObjLine_Surface()
		{
			clipFunction = ClipFunction_NoClip;
			renderFunction = RenderGameObjLine_Surface;
			
			name = "surface";
			frame = linkedPhysLine.GetCurrentPolyMaterial().fillFrame;
			frame1 = linkedPhysLine.GetCurrentPolyMaterial().fillFrame1;
			frame2 = linkedPhysLine.GetCurrentPolyMaterial().fillFrame2;
			
			// bumpy surface
			dobj3 = GraphicObjects.GetDisplayObjByName("SurfaceTextures");
			frame3 = 0;
			
			if (PROJECT::useStage3D)
			{
				GameObjPolyRenderer.PreRenderPhysicsLineObject_Surface_Stage3D(this);
			}
			else
			{				
				GameObjPolyRenderer.PreRenderPhysicsLineObject_Surface_PointsList(this);
			}
		}

		function RenderGameObjLine_SurfacePoly()
		{
			if (PROJECT::useStage3D)
			{
				GameObjPolyRenderer.RenderPhysicsLineObject_SurfacePoly_Stage3D(this)
			}
			else
			{
				GameObjPolyRenderer.RenderPhysicsLineObject_SurfacePoly_PointsList(this);
			}			
		}
		
		public function InitGameObjLine_SurfacePoly()
		{

			clipFunction = ClipFunction_NoClip;
			renderFunction = RenderGameObjLine_SurfacePoly;
			
			name = "surface";
			frame = linkedPhysLine.GetCurrentPolyMaterial().fillFrame;
			frame1 = linkedPhysLine.GetCurrentPolyMaterial().fillFrame1;
			frame2 = linkedPhysLine.GetCurrentPolyMaterial().fillFrame2;
			
			// bumpy surface
			dobj3 = GraphicObjects.GetDisplayObjByName("SurfaceTextures");
			frame3 = 0;
			
			if (PROJECT::useStage3D)
			{
				GameObjPolyRenderer.PreRenderPhysicsLineObject_SurfacePoly_Stage3D(this);
			}
			else
			{				
				GameObjPolyRenderer.PreRenderPhysicsLineObject_SurfacePoly_PointsList(this);
			}
		}
		
		
		var vertices:Vector.<Number>;
		var indices:Vector.<int>;
		var uvtData:Vector.<Number>;
		var vertices1:Vector.<Number>;
		var indices1:Vector.<int>;
		var uvtData1:Vector.<Number>;
		var vertices2:Vector.<Number>;
		var indices2:Vector.<int>;
		var uvtData2:Vector.<Number>;
		

//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------

		function InitGameObjLine_Background()
		{
			name = "background";
			state = 0;
			renderFunction = RenderPhysicsLineObject_Surface;
			dobj1 = GraphicObjects.GetDisplayObjByName("SurfaceFills");
			PreRenderPhysicsLineObject_Background();
			zpos = 1000;
		}
		
		
		
		
//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				
		

		function InitGameObjLine_Null()
		{
			lineRender_Color0 = 0x000000;
			lineRender_Color1 = 0xff0000;
			lineRender_Color = 0xa0a0a0;
//			lineRender_LineColor = 0xa0a0a0;
			frame = 0;
		}

		
		
		function InitGameObjLine_Sticky()
		{
			canRestartHere = true;
			name = "sticky";
			Utils.print("InitGameObjLine_Sticky");
			state = 0;
			lineRender_Color = 0xff0000;
			lineRender_Color0 = 0x008000;
			lineRender_Color1 = 0x00ff00;
	
			frame = 3;
		}

		
		
		
		function PreRenderPhysicsLineObject_Movable()
		{
			if (PROJECT::useStage3D == false) return;
			
			linkedPhysLine.DoTriangulation();
			
			if (linkedPhysLine.triangleList == null) return;
			
			
		}
		
		
		PROJECT::useStage3D
		{
			
		var pivotPoint:Vector3D;
			function PreRenderPhysicsLineObject_Movable_Stage3D()
			{
				linkedPhysLine.DoTriangulation();
				linkedPhysLine.CalcBoundingRectangle();			
				s3dTriListIndex = s3d.MakeIndieTriangleList(linkedPhysLine.triangleList, linkedPhysLine.uvList);
				
				pivotPoint = new Vector3D(0, 0, 0);
			var p:Point = linkedPhysLine.GetCentreHandle();
			pivotPoint.x = p.x;
			pivotPoint.y = p.y;
			}
			function RenderPhysicsLineObject_Movable_Stage3D()
			{
				var x:Number = Math.round(xpos);
				var y:Number =  Math.round(ypos);
				x = Math.round(Game.camera.x);
				y = Math.round(Game.camera.y);
				
				var cx:int = Game.camera.x;
				var cy:int = Game.camera.y;
				
				if (cx + Defs.displayarea_w < linkedPhysLine.boundingRectangle.left) return;
				if (cy + Defs.displayarea_h < linkedPhysLine.boundingRectangle.top) return;
				if (cx > linkedPhysLine.boundingRectangle.right) return;
				if (cy > linkedPhysLine.boundingRectangle.bottom) return;
				
				m3d.identity();
				m3d.appendRotation(Utils.RadToDeg(dir), Vector3D.Z_AXIS, pivotPoint);
				m3d.appendTranslation( -x, -y, 0);
				var triList:s3dTriList = s3d.triangleLists[s3dTriListIndex];
				s3d.SetCurrentBlendMode(s3d.BLENDMODE_SOLID);
				s3d.RenderTriangleList(m3d, dobj.GetTexture(frame), triList.indices,triList.vertices,triList.vertices_extra);
				s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);
			}
			
			//----------------------------------------------------
			
			function PreRenderPhysicsLineObject_Movable_Stage3D_OwnBuffer()
			{
				linkedPhysLine.DoTriangulation();
				linkedPhysLine.CalcBoundingRectangle();			
				
			var uvscale:Number = 1;	// Vars.GetVarAsNumber("general_uv_scale");
				
			s3dTriListIndex = s3d.MakeIndieTriangleList(linkedPhysLine.triangleList, linkedPhysLine.uvList);
				
				linkedPhysLine.MakeLineTriangleList(3);
			s3dTriListIndex1 = s3d.MakeIndieTriangleList(linkedPhysLine.lineTriangleList, linkedPhysLine.lineUvList);
				
			}
			function RenderPhysicsLineObject_Movable_Stage3D_OwnBuffer_Alpha()
			{

				var camScale:Number = 1;
				var zp:Number = camZ - Game.camera.z;
				if (zp != 0)
				{
					camScale= 1/Game.camera.PerspectiveTransformGetScale(zp);
				}

				
				var x:Number = Math.round(xpos);
				var y:Number =  Math.round(ypos);
				x = Math.round(Game.camera.x);
				y = Math.round(Game.camera.y);
				
				var cx:int = Game.camera.x;
				var cy:int = Game.camera.y;
				
//				if (cx + Defs.displayarea_w < linkedPhysLine.boundingRectangle.left) return;
//				if (cy + Defs.displayarea_h < linkedPhysLine.boundingRectangle.top) return;
//				if (cx > linkedPhysLine.boundingRectangle.right) return;
//				if (cy > linkedPhysLine.boundingRectangle.bottom) return;
				
				var zp:Number = camZ - Game.camera.z;
				var xp:Number = 0;
				var yp:Number = 0;
				
				if (zp != 0)
				{
					Game.camera.PerspectiveTransform(-Defs.displayarea_w2,-Defs.displayarea_h2,zp);
					//sc *= camScale;
					xp = Game.camera.transformX;
					yp = Game.camera.transformY;
				}			
				
				var camScale1:Number = 1 / camScale;


				m3d.identity();
				m3d.appendTranslation( -x, -y, 0);
				
				m3d.identity();
				m3d.appendTranslation((Defs.displayarea_w2*camScale),(Defs.displayarea_h2*camScale),0);
				m3d.appendTranslation( -x, -y, 0);
				m3d.appendScale(camScale1, camScale1, 1);
				m3d.appendTranslation(-(Defs.displayarea_w2*camScale1),-(Defs.displayarea_h2*camScale1),0);
				
				
				var triList:s3dTriList = s3d.triangleLists[s3dTriListIndex];
				var triList1:s3dTriList = s3d.triangleLists[s3dTriListIndex1];
				//s3d.RenderTriangleList(m3d, dobj.GetTexture(frame), triList.indices,triList.vertices,triList.vertices_extra);

				s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);
				s3d.RenderPreUploadedTriangleList1( -x, -y, m3d, dobj.GetTexture(frame), triList);
//				if (frame1 < dobj.GetNumFrames())
//				{
//					s3d.RenderPreUploadedTriangleList1( -x, -y, m3d, dobj.GetTexture(frame1), triList1);
//				}
				s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);
				
			}
			function RenderPhysicsLineObject_Movable_Stage3D_OwnBuffer()
			{


				var x:Number = Math.round(xpos);
				var y:Number =  Math.round(ypos);
				x = Math.round(Game.camera.x);
				y = Math.round(Game.camera.y);
				
				var cx:int = Game.camera.x;
				var cy:int = Game.camera.y;
				
				if (cx + Defs.displayarea_w < linkedPhysLine.boundingRectangle.left) return;
				if (cy + Defs.displayarea_h < linkedPhysLine.boundingRectangle.top) return;
				if (cx > linkedPhysLine.boundingRectangle.right) return;
				if (cy > linkedPhysLine.boundingRectangle.bottom) return;
				
				m3d.identity();
				m3d.appendTranslation( -x, -y, 0);
				var triList:s3dTriList = s3d.triangleLists[s3dTriListIndex];
				var triList1:s3dTriList = s3d.triangleLists[s3dTriListIndex1];
				//s3d.RenderTriangleList(m3d, dobj.GetTexture(frame), triList.indices,triList.vertices,triList.vertices_extra);

				s3d.SetCurrentBlendMode(s3d.BLENDMODE_SOLID);
				s3d.RenderPreUploadedTriangleList1(-x,-y,m3d, dobj.GetTexture(frame), triList);
				s3d.RenderPreUploadedTriangleList1( -x, -y, m3d, dobj.GetTexture(frame1), triList1);
				s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);

			}
			
		}
		
		function RenderPhysicsLineObject_Movable()
		{
			if (PROJECT::useStage3D)
			{
				return;
			}
			
			var x:Number =  Math.round(xpos) - Math.round(Game.camera.x);
			var y:Number =  Math.round(ypos) - Math.round(Game.camera.y);
			
			if (x < -1500) return;
			if (x > Defs.displayarea_w+1500) return;
			if (y < -1500) return;
			if (y > Defs.displayarea_h+1500) return;
			
			
			var g:Graphics = Game.fillScreenMC.graphics;
			g.clear();

			var sx:Number = Math.round(Game.camera.x);
			var sy:Number = Math.round(Game.camera.y);
			
			var z:int = zpos;
			
			
			var p0:Point;
			var p1:Point;
			
			var newpoints:Array = new Array();
			
			gmat.identity();
			gmat.rotate(dir);
			

			
			var sc:Number = 1;	// Game.camera.scale;
			
			var r:Rectangle = new Rectangle(0, 0, 1, 1);
			
			var pts:Array = linkedPhysLine.points;
			if (linkedPhysLine.IsSpline())
			{
				pts = linkedPhysLine.GetCatmullRomPointsList(linkedPhysLine.points, 0, 0);
			}
			
			
			var index:int = 0;
			for each(var p:Point in pts)
			{
				p0 = p.clone();
				p0.x -= linkedPhysLine.centrex;
				p0.y -= linkedPhysLine.centrey;
				p0 = gmat.transformPoint(p0);
				p0.x += xpos;
				p0.y += ypos;
				p0.x -= sx;
				p0.y -= sy;
				p0.x *= sc;
				p0.y *= sc;
				newpoints.push(p0);
				
				if (index == 0)
				{
					r = new Rectangle(p0.x, p0.y, 1, 1);
				}
				else
				{
					if (p0.x < r.left) r.left = p0.x;
					if (p0.x > r.right) r.right = p0.x;
					if (p0.y < r.top) r.top = p0.y;
					if (p0.y > r.bottom) r.bottom = p0.y;
				}
				index++;
				
			}
			
			
			gmat.identity();
			gmat.rotate(dir);
			gmat.translate(xpos, ypos);
			gmat.translate( -sx, -sy);
			
//			g.beginFill(0xff0000, 1);
			
			g.beginBitmapFill(dobj.GetBitmapData(frame), gmat, true);
			
			if (dobj2 == null)
			{
				g.lineStyle(null,null,null);		
			}
			else
			{				
				g.lineStyle(3, 0x404040, 1);			
				
				g.lineBitmapStyle(dobj2.GetBitmapData(frame), gmat, true);				
			}
			
			
			p1 = newpoints[0].clone();
			g.moveTo(p1.x,p1.y);
			for (var i:int = 1; i <newpoints.length; i++)
			{
				p0 = newpoints[i].clone();
				g.lineTo(p0.x,p0.y);
			}	
			g.lineTo(p1.x, p1.y);
			g.endFill();


			
			bd.draw(Game.fillScreenMC, null, null, null, null, false);
			
		}

		
		
		function RenderPhysicsLineObject_Movable1()
		{
			if (PROJECT::useStage3D)
			{
				RenderPhysicsLineObject_Movable_Stage3D();
				return;
			}
			
			var x:Number =  Math.round(xpos) - Math.round(Game.camera.x);
			var y:Number =  Math.round(ypos) - Math.round(Game.camera.y);
			
			var g:Graphics = Game.fillScreenMC.graphics;
			g.clear();

			var sx:Number = Math.round(Game.camera.x);
			var sy:Number = Math.round(Game.camera.y);
			
			var z:int = zpos;
			
			
			var p0:Point;
			var p1:Point;
			
			var newpoints:Array = new Array();
			
			gmat.identity();
			gmat.rotate(dir);
			

			
			var sc:Number = Game.camera.scale;
			
			var r:Rectangle = new Rectangle(0, 0, 1, 1);
			
			var pts:Array = linkedPhysLine.points;
			if (linkedPhysLine.IsSpline())
			{
				pts = linkedPhysLine.GetCatmullRomPointsList(linkedPhysLine.points, 0, 0);
			}
			
			
			var index:int = 0;
			for each(var p:Point in pts)
			{
				p0 = p.clone();
				p0.x -= linkedPhysLine.centrex;
				p0.y -= linkedPhysLine.centrey;
				p0 = gmat.transformPoint(p0);
				p0.x += xpos;
				p0.y += ypos;
				p0.x -= sx;
				p0.y -= sy;
				p0.x *= sc;
				p0.y *= sc;
				newpoints.push(p0);
				
				if (index == 0)
				{
					r = new Rectangle(p0.x, p0.y, 1, 1);
				}
				else
				{
					if (p0.x < r.left) r.left = p0.x;
					if (p0.x > r.right) r.right = p0.x;
					if (p0.y < r.top) r.top = p0.y;
					if (p0.y > r.bottom) r.bottom = p0.y;
				}
				index++;
				
			}
			
			
			gmat.identity();
			gmat.rotate(dir);
			gmat.translate(xpos, ypos);
			gmat.translate( -sx, -sy);
			
//			g.beginFill(0xff0000, 1);
			
			g.beginBitmapFill(dobj.GetBitmapData(frame), gmat, true);
			
			if (dobj2 == null)
			{
				g.lineStyle(null,null,null);		
			}
			else
			{				
				g.lineStyle(3, 0x404040, 1);			
				
				g.lineBitmapStyle(dobj2.GetBitmapData(frame), gmat, true);				
			}
			
			
			p1 = newpoints[0].clone();
			g.moveTo(p1.x,p1.y);
			for (var i:int = 1; i <newpoints.length; i++)
			{
				p0 = newpoints[i].clone();
				g.lineTo(p0.x,p0.y);
			}	
			g.lineTo(p1.x, p1.y);
			g.endFill();


			
			bd.draw(Game.fillScreenMC, null, null, null, null, false);
			
		}

		
		var staticLinePoints:Vector.<Point>;
		var staticLineRectangle:Rectangle;
		function PreRenderPhysicsLineObject_Static()
		{
			if (PROJECT::useStage3D)
			{			
				linkedPhysLine.DoTriangulation();
				return;
			}
			
			staticLinePoints = new Vector.<Point>();
			
			var pts:Array = linkedPhysLine.points;
			if (linkedPhysLine.IsSpline())
			{
				pts = linkedPhysLine.GetCatmullRomPointsList(linkedPhysLine.points, 0, 0);
			}
			
			var p0:Point;
			var index:int = 0;
			for each(var p:Point in pts)
			{
				p0 = p.clone();
				p0.x -= linkedPhysLine.centrex;
				p0.y -= linkedPhysLine.centrey;
//				p0 = gmat.transformPoint(p0);
				p0.x += xpos;
				p0.y += ypos;
//				p0.x -= sx;
//				p0.y -= sy;
//				p0.x *= sc;
//				p0.y *= sc;
				staticLinePoints.push(p0);
				
				if (index == 0)
				{
					staticLineRectangle = new Rectangle(p0.x, p0.y, 1, 1);
				}
				else
				{
					if (p0.x < staticLineRectangle.left) staticLineRectangle.left = p0.x;
					if (p0.x > staticLineRectangle.right) staticLineRectangle.right = p0.x;
					if (p0.y < staticLineRectangle.top) staticLineRectangle.top = p0.y;
					if (p0.y > staticLineRectangle.bottom) staticLineRectangle.bottom = p0.y;
				}
				index++;
				
			}
			
			
		}
		
		function RenderPhysicsLineObject_Static()
		{
			
			
			if (PROJECT::useStage3D)
			{
				return;
			}

			var camScale:Number = 1;
			var zp:Number = camZ - Game.camera.z;
			if (zp != 0)
			{
				camScale= 1/Game.camera.PerspectiveTransformGetScale(zp);
			}
			var camScale1:Number = 1 / camScale;
			
			
			var g:Graphics = Game.fillScreenMC.graphics;
			g.clear();

			var sx:Number = Math.round(Game.camera.x);
			var sy:Number = Math.round(Game.camera.y);
			
			gmat.identity();
			
			gmat.translate(-Game.camera.x+(Defs.displayarea_w2*camScale),-Game.camera.y+(Defs.displayarea_h2*camScale));
			gmat.scale(camScale1,camScale1);
			
			
//			gmat.translate(xpos, ypos);
//			gmat.translate( -sx, -sy);
			
			/*
			g.beginBitmapFill(dobj.GetBitmapData(frame), gmat,true);			
			if (dobj2 == null)
			{
				g.lineStyle(null,null,null);		
			}
			else
			{				
				g.lineStyle(3, 0x404040, 1);			
				
				if (frame > dobj2.GetNumFrames() - 1) frame = 0;
				
				g.lineBitmapStyle(dobj2.GetBitmapData(frame), gmat, true);				
			}
			*/

			//g.lineStyle(3, 0x404040, 1);			
			g.lineStyle(null, 0, 0);	// 3, 0x404040, 1);			
//			g.lineBitmapStyle(dobj.GetBitmapData(frame1), gmat, true);				
			g.beginBitmapFill(dobj.GetBitmapData(frame), gmat,true);			
			
			var pts:Vector.<Point> = staticLinePoints;			
			MoveTo(g,pts[0],false);
			for (var i:int = 1; i <pts.length; i++)
			{
				MoveTo(g,pts[i],true);
			}	
			MoveTo(g,pts[0],true);
			g.endFill();
			bd.draw(Game.fillScreenMC, null, null, null, null, false);			
		}
		
		
		function MoveTo(g:Graphics, p:Point, line:Boolean = false)
		{
			var xp:Number =  Math.round(p.x) - Math.round(Game.camera.x);
			var yp:Number =  Math.round(p.y) - Math.round(Game.camera.y);
			var zp:Number = camZ - Game.camera.z;
		
			if (zp != 0)
			{
				var camScale:Number = Game.camera.PerspectiveTransform(xp,yp,zp);
				//sc *= camScale;
				xp = Game.camera.transformX;
				yp = Game.camera.transformY;
			}			
			
			
			if (line == false)
			{
				g.moveTo(xp, yp);
			}
			else
			{
				g.lineTo(xp, yp);
			}
		}

		
		
		
		function RenderGrass()
		{
			if (GameVars.renderDebugMode == 1) return;
			Grass.RenderAll(bd);
		}
		function UpdateGrass()
		{
			Grass.Update();
		}
		function InitGrass()
		{
			clipFunction = ClipFunction_NoClip;
			updateFunction = UpdateGrass;
			renderFunction = RenderGrass;
			zpos = GameLayers.GetZPosByName("Grass");
		}
		
		
		function InitGameObjLine_Movable()
		{
			InitGameObjLine_Standard();
			name = "movable";
			preRenderFunction = null;
			if (PROJECT::useStage3D)
			{
				PreRenderPhysicsLineObject_Movable_Stage3D();			
				renderFunction = RenderPhysicsLineObject_Movable_Stage3D;
			}
			else
			{
				renderFunction = RenderPhysicsLineObject_Movable;
			}
		}		
		function InitGameObjLine_Standard_KeepActive()
		{
			InitGameObjLine_Standard();
			keepAwakeFunction = KeepAwake_Constant;
		}
		
		function InitGameObjLine_Path()
		{
			RemoveObject();
		}
		
		public function InitGameObjLine_Death()
		{
			InitGameObjLine_Standard();
			collisionType = "death";
//			visible = false;
		}

		public function InitGameObjLine_Water()
		{
			InitGameObjLine_Standard();
		}
		
		public function InitGameObjLine_Death_Invisible()
		{
			InitGameObjLine_Standard();
			collisionType = "death";
			visible = false;
		}
		
		function RenderPhysicsLineObject_Wind()
		{
			if (staticLineRectangle.right < Game.camera.x) return;
			if (staticLineRectangle.left > (Game.camera.x + Defs.displayarea_w)) return;
			if (staticLineRectangle.bottom < Game.camera.y) return;
			if (staticLineRectangle.top > ( Game.camera.y + Defs.displayarea_h)) return;
			
			
			var poly_tex_rotation:Number = linkedPhysLine.objParameters.GetValueNumber("poly_tex_rotation");
			poly_tex_rotation = Utils.DegToRad(poly_tex_rotation);
			var poly_tex_scale:Number = linkedPhysLine.objParameters.GetValueNumber("poly_tex_scale");
			
			var g:Graphics = Game.fillScreenMC.graphics;
			g.clear();

			var sx:Number = Math.round(Game.camera.x);
			var sy:Number = Math.round(Game.camera.y);
			
			gmat.identity();
			gmat.rotate(poly_tex_rotation);
			gmat.translate(xpos1, ypos1);
			gmat.translate(xpos, ypos);
			gmat.translate( -sx, -sy);
			

			g.lineStyle(null,0,0);			
			g.beginBitmapFill(dobj.GetBitmapData(frame), gmat,true);			
			
			var pts:Vector.<Point> = staticLinePoints;			
			g.moveTo(pts[0].x-sx,pts[0].y-sy);
			for (var i:int = 1; i <pts.length; i++)
			{
				g.lineTo(pts[i].x-sx,pts[i].y-sy);
			}	
			g.lineTo(pts[0].x-sx,pts[0].y-sy);
			g.endFill();
			bd.draw(Game.fillScreenMC, null, null, null, null, false);			
		}
		
		function UpdateGameObjLine_Wind()
		{
			var poly_tex_rotation:Number = linkedPhysLine.objParameters.GetValueNumber("poly_tex_rotation");
			poly_tex_rotation = Utils.DegToRad(poly_tex_rotation);
			var p:Point = new Point (10, 0);
			gmat.identity();
			gmat.rotate(poly_tex_rotation);
			p = gmat.transformPoint(p);
			
			xpos1 += p.x;
			ypos1 += p.y;
			xpos1 %= 256;
			ypos1 %= 256;
			
			
		}
		
		
		function OnHit_WindLine(goHitter:GameObj)
		{
			if (goHitter.name != "player" && goHitter.name != "player_wheel" ) return;
			
			var poly_tex_rotation:Number = linkedPhysLine.objParameters.GetValueNumber("poly_tex_rotation");
			poly_tex_rotation = Utils.DegToRad(poly_tex_rotation);
			
			var ang:Number = poly_tex_rotation;
			var dx:Number = 1;
			var dy:Number = 0;
			
			dx = Math.cos(ang) * force_strength;
			dy = Math.sin(ang) * force_strength;
			
			goHitter.ApplyForce(dx, dy);
			
			trace("apply poly wind force " + dx + " " + dy);
			
		}
		
		function InitGameObjLine_Wind()
		{
			InitGameObjLine_Standard();
			collisionType = "wind";
			
			name = "wind";
			timer = Utils.RandBetweenInt(10, 30);
			force_strength = Vars.GetVarAsNumber("windforce");
			state = 0;
			onHitFunction = OnHit_WindLine;
			onHitPersistFunction = OnHit_WindLine;
			
			
			if (PROJECT::useStage3D)
			{
			}
			else
			{
				renderFunction = RenderPhysicsLineObject_Wind;
				PreRenderPhysicsLineObject_Static();
				updateFunction = UpdateGameObjLine_Wind;
			}
			
			
		}
		
		
		function DoNoRender()
		{
			
		}
		
		function InitGameObjLine_Standard_Grass()
		{
			InitGameObjLine_Standard();
		}
		function InitGameObjLine_Standard_Mud()
		{
			InitGameObjLine_Standard();
			preRenderFunction1 = null;
		}
		function InitGameObjLine_Standard_Ice()
		{
			InitGameObjLine_Standard();
			preRenderFunction1 = null;
		}
		function OnHitGameObjLine_Standard_Bouncy(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (goHitter.name != "player") return;
			if (timeSinceBouncedHere > 0) return;
			SFX_OneShot("sfx_hit_bouncy");
			GameVars.IncrementCombo(goHitter);
			timeSinceBouncedHere = 20;
			
		}
		var timeSinceBouncedHere:int;
		function UpdateGameObjLine_Standard_Bouncy()
		{
			if (updateFunction1 != null) updateFunction1();
			if (timeSinceBouncedHere > 0) timeSinceBouncedHere--;
		}
		function InitGameObjLine_Standard_Bouncy()
		{
			InitGameObjLine_Standard();
			onHitFunction = OnHitGameObjLine_Standard_Bouncy;
			timeSinceBouncedHere = 0;
			updateFunction1 = updateFunction;
			updateFunction = UpdateGameObjLine_Standard_Bouncy;
		}
		
		
		function InitObjectBouncy()
		{
			onHitFunction = OnHitGameObjLine_Standard_Bouncy;
			updateFunction = UpdateGameObjLine_Standard_Bouncy;
			updateFunction1 = null;
			timeSinceBouncedHere = 0;
		}
		
		function OnHitWater(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (goHitter.name != "player") return;
			
			goHitter.PlayerInWater();
		}
		
		var waterHighestPoint:Number;
		function InitGameObjLine_Standard_Water()
		{
			InitGameObjLine_Standard();
			preRenderFunction1 = null;
			onHitPersistFunction = OnHitWater;
			onHitFunction = OnHitWater;
			collisionType = "water";
			
			waterHighestPoint = 9999999;
			// calculate water highest point
			for each(var p:Point in linkedPhysLine.points)
			{
				if (p.y < waterHighestPoint)
				{
					waterHighestPoint = p.y;
				}
			}
//			trace(" waterHighestPoint " + waterHighestPoint);


			if (PROJECT::useStage3D)
			{
				renderFunction = RenderPhysicsLineObject_Movable_Stage3D_OwnBuffer_Alpha;
			}
			else
			{
				renderFunction = RenderPhysicsLineObject_Static;
			}

			
		}
		function InitGameObjLine_Standard_Test()
		{
			InitGameObjLine_Standard();
		}
		function InitGameObjLine_Standard()
		{
			
			clipFunction = ClipFunction_NoClip;
			
			collisionType = "normal";
			preRenderFunction = null;	 //RenderPhysicsLineObject_Movable;
			
			
			if (PROJECT::useStage3D)
			{
				//renderFunction = RenderPhysicsLineObject_Movable_Stage3D;
				renderFunction = RenderPhysicsLineObject_Movable_Stage3D_OwnBuffer_Alpha;
			}
			else
			{
				renderFunction = RenderPhysicsLineObject_Static;
			}
			
			if (PROJECT::useStage3D)
			{
				//PreRenderPhysicsLineObject_Movable_Stage3D();
				PreRenderPhysicsLineObject_Movable_Stage3D_OwnBuffer();
			}
			else
			{				
				PreRenderPhysicsLineObject_Static();
			}
			
			
			frame = GameVars.grassFrame;
			
//			dobj1 = GraphicObjects.GetDisplayObjByName("grass_rough");
//			grassName = "grass_rough";
			
			preRenderFunction1 = PreRenderPhysicsLineObject_Movable_GrassSurface;
			name = "poly";
			state = 0;
			
			
			frame = linkedPhysLine.GetCurrentPolyMaterial().fillFrame;
			frame1 = linkedPhysLine.GetCurrentPolyMaterial().fillFrame1;
			frame2 = frame + 2;
			
			xpos1 = 0;
			ypos1 = 0;
		}
		
		
		function InitGameObjLine_Invisible()
		{
			InitGameObjLine_Standard();
			visible = false;
		}
		
		
		function InitGameObjLine_Standard_Old()
		{
			collisionType = "normal";
			preRenderFunction = null;	 //RenderPhysicsLineObject_Movable;
			//renderFunction = RenderPhysicsLineObject_Movable;
			renderFunction = RenderPhysicsLineObject_Static;
			//PreRenderPhysicsLineObject_Movable();
			PreRenderPhysicsLineObject_Static();
			
			frame = GameVars.grassFrame;
			
			dobj1 = GraphicObjects.GetDisplayObjByName("grass_rough");
			grassName = "grass_rough";
			
			preRenderFunction1 = PreRenderPhysicsLineObject_Movable_GrassSurface;
			name = "border";
			state = 0;
			
			dobj2 = GraphicObjects.GetDisplayObjByName("FillEdge");
		}

		function InitGameObjLine_Mud()
		{
			collisionType = "normal";
			preRenderFunction = null;	 //RenderPhysicsLineObject_Movable;
			renderFunction = RenderPhysicsLineObject_Static;
			PreRenderPhysicsLineObject_Static();
			
			dobj2 = GraphicObjects.GetDisplayObjByName("FillSoilEdge");			
			
			frame = GameVars.dirtFrame;

			state = 0;
			
		}
		function InitGameObjLine_Decor()
		{
			InitGameObjLine_Standard();
			return;
			collisionType = "normal";
			preRenderFunction = null;	 //RenderPhysicsLineObject_Movable;
			renderFunction = RenderPhysicsLineObject_Static;
			PreRenderPhysicsLineObject_Static();
			state = 0;
			dobj2 = null;
//			frame = GameVars.dirtFrame;
			clipFunction = ClipFunction_NoClip;
		}
		
		var grassName:String;

		function PreRenderPhysicsLineObject_Movable_GrassSurface()
		{
			var newPoints:Array = linkedPhysLine.points;
			var p0:Point;
			var p1:Point;
			
			for (var i:int = 0; i <newPoints.length-1; i++)
			{
				p0 = newPoints[i].clone();
				p1 = newPoints[i + 1].clone();
				
				Grass.AddLine(p0, p1,grassName);
				
			}	
		}
		
		function InitGameObjLine_UpperSurface()
		{
			renderFunction = RenderPhysicsLineObject_Movable;
			name = "grass";
			state = 0;
		}
		
		function InitGameObjLine_Grassy()
		{
			InitGameObjLine_Wood();
		}
		function InitGameObjLine_Wood()
		{
			name = "grass";
			Utils.print("InitGameObjLine_Wood");
			state = 0;
			frame = 1;
			SetPolysMaterial_Nape("average");
			Utils.GetParams(initParams);
			
			frame= linkedPhysLine.objParameters.GetValueInt("line_background_frame",1);			
			frame--;
			frame = Utils.LimitNumber(0, dobj.GetNumFrames() - 1,frame);
			
			lineRender_Color = 0x2B4314;
			
			
		}
		function InitGameObjLine_Smooth()
		{
			Utils.print("InitGameObjLine_Smooth");
			state = 0;
			frame = 2;
			SetPolysMaterial_Nape("smooth");
		}
		function InitGameObjLine_Bouncy()
		{
			Utils.print("InitGameObjLine_Bouncy");
			state = 0;
			frame = 2;
			SetPolysMaterial_Nape("bouncy");
		}
		function InitGameObjLine_Icy()
		{
			Utils.print("InitGameObjLine_Icy");
			state = 0;
			frame = 3;
			SetPolysMaterial_Nape("smooth");
		}
		

		
		function InitGameObjLine_NonCollision()
		{
			SetBodyCollisionMask(0, 0);	// GetBodyCollisionMask(0)
		}
		
		function InitGameObjLine_ScrollArea()
		{
//			SetBodyCollisionMask(0, 0);	// GetBodyCollisionMask(0)
			visible = false;	
			
			linkedPhysLine.CalcBoundingRectangle();
			Game.boundingRectangle = linkedPhysLine.boundingRectangle.clone();
		}
		
		
		
		
		
		function InitGameObjLine_Switch_Hit(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return false;
			if (goHitter.name == "player" || goHitter.name == "player_wheel")
			{
				state = 1;
				onHitFunction = null;
				return true;
			}
			return false;
		}
		function InitGameObjLine_Switch()
		{
			name = "invisible_switch";
			
			//onHitFunction = SwitchOnceHit;				
			onHitFunction = InitGameObjLine_Switch_Hit;				
			updateFunction = UpdateSwitchOnce;
			
			state = 0;
			visible = false;
		}
		
		
		
//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				
		
		
//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				

		
//---------------------------------------------------------------------------------------------		
//---------------------------------------------------------------------------------------------		
		
		
//---------------------------------------------------------------------------------------------		
//---------------------------------------------------------------------------------------------		
		
		
		function RenderPhysObj_Generic()
		{
			RenderDispObjNormally();
		}

//---------------------------------------------------------------------------------------------		
//---------------------------------------------------------------------------------------------		
//---------------------------------------------------------------------------------------------		


		function RenderBackground()
		{
			if (EngineDebug.mobileTest1) return;

			
//			s3d.SetCurrentBlendMode(s3d.BLENDMODE_SOLID);
//			var w2:int =  Game.backDOF2.sourceRect.width;
//			Game.backDOF2.RenderAt(bd, int(xpos2), 0);
//			Game.backDOF2.RenderAt(bd, int(xpos2)+w2, 0);
//			s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);
			
			xpos = 0;

			var w:int =  Game.backDOF.sourceRect.width;
			Game.backDOF.RenderAt(bd, int(xpos), 0);
			//Game.backDOF.RenderAt(bd, int(xpos)+w, 0);
			s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);
			
		}
		
		function UpdateBackground()
		{
			var w:int = Game.backDOF.sourceRect.width;	// .bitmapData.width;
			
			xpos = Game.camera.x * 0.4;
			
			while (xpos < 0) xpos += w;
			
			xpos = xpos % w;
			xpos = -xpos;

			
			var w2:int = Game.backDOF2.sourceRect.width;	// .bitmapData.width;
			
			xpos2 = Game.camera.x * 0.2;
			
			while (xpos2 < 0) xpos2 += w2;
			
			xpos2 = xpos2 % w2;
			xpos2 = -xpos2;
			
		}
		function InitBackground()
		{
			clipFunction = ClipFunction_NoClip;
			renderFunction = RenderBackground;
			updateFunction = UpdateBackground;
			
//			var level:Level = Levels.GetCurrent();
//			dobj = GraphicObjects.GetDisplayObjByName("backgrounds");
//			dobj = GraphicObjects.GetDisplayObjByName("level");
			
//			frame = (Levels.currentIndex) % dobj.GetNumFrames();
			xpos = ypos = 0;
			xpos2 = ypos2 = 0;
		}


		//----------------------------------------------------------------------------------------------------------------		
		
		
		public function RenderPolyLayer()
		{	
//			Game.polyDOF.RenderAt(bd, 0, 0);
//			bd.copyPixels(Game.polyScreenBD, Defs.screenRect, Defs.pointZero, null, null, true);
		}
		public function UpdatePolyLayer()
		{
		}
		public function InitPolyLayer()
		{
			updateFunction = UpdatePolyLayer;
			renderFunction = RenderPolyLayer;
		}
		
		
//---------------------------------------------------------------------------------------------		
		//--------------------------------------------------------------------------------------

		
		
//----------------------------------------------------------------------------------------------------------------		

		public function OnHitDoorSwitch(goHitter:GameObj)
		{	
			if (goHitter == null) return;
		}		
		function onSwitchedDoorSwitch()
		{
		}
		
		
		
		function TryLinkedDoorSwtiches()
		{
			if (doorSwitch_linkid == 0) return;
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active && (go.name == "doorswitch") && (go.doorSwitch_linkid == doorSwitch_linkid) )
				{
					if (go != this)
					{
						go.OnClickedDoorSwitch_Inner();
					}
				}
			}			
		}
		
		
		function OnClickedDoorSwitch()
		{
			OnClickedDoorSwitch_Inner();
			TryLinkedDoorSwtiches();
		}
			
		function OnClickedDoorSwitch_Inner()
		{
			if (doorSwitch_2Way)
			{
				if (state == 0)
				{
					state = 1;
				}
				else
				{
					state = 0;
				}				
			}
			else
			{
				if (doorSwitch_ccw)
				{
					if (state != 1)
					{
						//var j:b2RevoluteJoint = joints[0];
						//minAng -= doorSwitch_angAdd;
						//maxAng -= doorSwitch_angAdd;
						//j.SetLimits(minAng, maxAng);
					}
					state = 0;					
				}
				else
				{
					if (state != 0)
					{
						//var j:b2RevoluteJoint = joints[0];
						//minAng += doorSwitch_angAdd;
						//maxAng += doorSwitch_angAdd;
						//j.SetLimits(minAng, maxAng);
					}
					state = 1;
				}
			}
			
		}
		
		function UpdateDoorSwitch()
		{
			var b:Body = GetBody(0);
			b.type = BodyType.KINEMATIC;
			
			if (doorSwitch_parentGO != null)
			{
				SetBodyXForm(0, doorSwitch_parentGO.xpos+doorSwitch_parentOffsetX, doorSwitch_parentGO.ypos+doorSwitch_parentOffsetY, 0);
			}
			
			
			var v:Number = doorSwitch_rotvel;
			
			rotVel = 0;
			if (state == 0)
			{
				rotVel = -v;
			}
			else if (state == 1)
			{
				rotVel = v;
			}
			
			
			var a:Number = GetBodyAngle(0);
			if ( (rotVel < 0) && (a <= minAng+origAng) )
			{
				rotVel = 0;
				SetBodyAngle(0,minAng + origAng);
				
			}
			if ( (rotVel > 0) && (a >= maxAng+origAng) )
			{
				rotVel = 0;
				SetBodyAngle(0,maxAng + origAng);
			}
			b.angularVel = rotVel;
			
			if (doorSwitch_parentGO == null)
			{
				b.position.setxy(startx, starty);
			}
			
			
			//Utils.trace("ang " + Utils.RadToDeg(a));

		}
		
		
		function AddJoint_Nape(joint:EdJoint)
		{
			PhysicsBase.AddJoint_Nape(joint);
		}
		
		var minAng:Number;
		var maxAng:Number;
		var origAng:Number;
		var doorSwitch_angAdd:Number;
		var doorSwitch_rotvel:Number;
		var doorSwitch_2Way:Boolean;
		var doorSwitch_ccw:Boolean;
		var doorSwitch_linkid:int;
		var doorSwitch_parentGO:GameObj;
		var doorSwitch_parentOffsetX:Number;
		var doorSwitch_parentOffsetY:Number;
		public function InitDoorSwitch()
		{
			name = "doorswitch";
			
			var s:String = "uidig_";
			for (var i:int = 0; i < 6; i++)
			{
				s += Utils.RandBetweenInt(0, 99);
			}
			id = s;
			
			Utils.GetParams(initParams);
			
			doorSwitch_angAdd = Utils.GetParamNumber("doorswitch_openangle", 0);
			doorSwitch_2Way = Utils.GetParamBool("doorswitch_2way", false);
			doorSwitch_ccw = Utils.GetParamBool("doorswitch_ccw", false);
			doorSwitch_linkid = Utils.GetParamInt("doorswitch_linkid", 0);
			doorSwitch_rotvel = Utils.GetParamInt("doorswitch_rotvel", 6);
			doorSwitch_angAdd = Utils.DegToRad(doorSwitch_angAdd);
			var switch_linkName:String = Utils.GetParamString("doorswitch_link", "");
			
			if (switch_linkName != "")
			{
				doorSwitch_parentGO = GameObjects.GetGameObjById(switch_linkName);
				SetBodyXForm_Immediate(0, doorSwitch_parentGO.xpos, doorSwitch_parentGO.ypos, 0);
				useMultiplePhysicsUpdates = true;

				
				if (doorSwitch_parentGO == null)
				{
					Utils.print("ERROR, can't find " + switch_linkName);
				}
				else
				{
					doorSwitch_parentOffsetX = xpos - doorSwitch_parentGO.xpos;
					doorSwitch_parentOffsetY = ypos - doorSwitch_parentGO.ypos;
				}
			}
			
			updateFunction = UpdateDoorSwitch;
			onHitFunction = OnHitDoorSwitch;
			onClickedFunction = OnClickedDoorSwitch;
			switchFunction = onSwitchedDoorSwitch;
			
			var joint:EdJoint = new EdJoint();

			joint.SetType(EdJoint.Type_Rev);
			joint.obj0Name = "";
			joint.obj1Name = id;
			joint.rev_pos.x = startx;
			joint.rev_pos.y = starty;
			
			joint.objParameters.SetValueBoolean("rev_enablemotor", false);
			joint.objParameters.SetValueNumber("rev_motorrate",1);
			joint.objParameters.SetValueNumber("rev_motorratio",1);
			joint.objParameters.SetValueNumber("rev_motormax",10000);
			
			joint.objParameters.SetValueBoolean("rev_enablelimit",false);
			joint.objParameters.SetValueNumber("rev_lowerangle",0);
			joint.objParameters.SetValueNumber("rev_upperangle",0);
			
//			AddJoint_Nape(joint);
			
			origAng = dir;
			
			minAng = 0;
			maxAng = 0;
			
			if (doorSwitch_ccw)
			{
				minAng -= doorSwitch_angAdd;
			}
			else
			{
				maxAng += doorSwitch_angAdd;
			}
			
			
			state = 0;
			if (doorSwitch_ccw) state = 1;
		}

//----------------------------------------------------------------------------------------------------------------		


//------------------------------------------------------------------------------------------------------------------------		
//------------------------------------------------------------------------------------------------------------------------		

//---------------------------------------------------------------------		

		function OnHit_Wind(goHitter:GameObj)
		{
			if (goHitter.name != "player" && goHitter.name != "player_wheel" ) return;
			
			var ang:Number = GetBodyAngle(0);
			var dx:Number = 1;
			var dy:Number = 0;
			
			dx = Math.cos(ang) * force_strength;
			dy = Math.sin(ang) * force_strength;
			
			goHitter.ApplyForce(dx, dy);
			
//			trace("apply force " + dx + " " + dy);
			
		}
		
		function UpdateWind()
		{
			
			
//			CycleAnimation();
			
			var gp:GameObj = GameVars.playerGO;
			var d2:Number = 1000 * 1000;
			if (Utils.Dist2BetweenPoints(xpos, ypos, gp.xpos, gp.ypos) > d2) return;

			var ang:Number = GetBodyAngle(0);
			ang -= Math.PI / 2;
			
			timer--;
			if (timer <= 0)
			{
				gpoint.x = Utils.RandBetweenInt( -60, 60);
				gpoint.y = Utils.RandBetweenInt( -60, 60);
				gmat.identity();
				gmat.rotate(ang);
				gpoint = gmat.transformPoint(gpoint);
				
				var x:Number = gpoint.x + xpos;
				var y:Number = gpoint.y + ypos;
				
				timer = Utils.RandBetweenInt(8,13);
				var go:GameObj = GameObjects.AddObj(x,y, zpos);
				go.InitWindPart(dir);
			}
		}
		function InitWind()
		{
			name = "wind";
			timer = Utils.RandBetweenInt(10, 30);
			force_strength = Vars.GetVarAsNumber("windforce");
			state = 0;
			onHitFunction = OnHit_Wind;
			onHitPersistFunction = OnHit_Wind;
			updateFunction = UpdateWind;
			if (Game.usedebug == false)
			{			
				visible = false;
			}
			visible = false;
			
		}
		var force_strength:Number;
		var initial_force_strength:Number;


//------------------------------------------------------------------------------------------------------------------------		
//------------------------------------------------------------------------------------------------------------------------		

		function UpdateWindPart()
		{
			xvel *= 1.1;
			yvel *= 1.1;
			xpos += xvel;
			ypos += yvel;
			timer--;
			if (timer <= 0)
			{
				RemoveObject();
			}
			CycleAnimation();
		}
		function InitWindPart(_ang:Number)
		{
			state = 0;
			updateFunction = UpdateWindPart;
			frame = 0;
			dir = _ang;
			timer = timerMax = Utils.RandBetweenInt(8, 13);
			movementVec = new Vec();
			movementVec.Set(_ang, Utils.RandBetweenFloat(1, 2));
			xvel = movementVec.X();
			yvel = movementVec.Y();
			dobj = GraphicObjects.GetDisplayObjByName("fx_wind");
			frameVel = Utils.RandBetweenFloat(0.1, 0.3);
		}

		
		
		public function UpdateSpawner()
		{
			rotVel += 0.09;
			
 			if (state == -1)		// waiting for a click
			{
				state = 0;
			}
			if(state == 0)
			{
				timer--;
				if (timer <= 0)
				{
					state = 1;
				}
			}	
			else if (state == 1)
			{				
				
				var o:Object = new Object();
				o.xpos = xpos;
				o.ypos = ypos;
				o.name = spawner_spawnobjectList[spawner_spawncount%spawner_spawnobjectList.length];
				GameObjects.AddToAddList(Spawner_GenerateObjectsCallback, o);
				
				SFX_OneShot("sfx_portal");
				
				spawner_spawncount++;
				
				timer = spawner_frequency;
				state = 0;
				
				if (spawner_total != 0)	// 0 meaning infinite
				{
					if (spawner_spawncount >= spawner_total)
					{
						state = 2;
						//frame = 1;
					}
				}
			}
			else if (state == 2)
			{
				
			}
		}
		
		function Spawner_GenerateObjectsCallback(o:Object)
		{
			var go:GameObj = PhysicsBase.AddPhysObjAt(o.name, o.xpos, o.ypos, 0, 1, "", "", "");
			movementVec.Set(spawner_angle, spawner_velocity);
			go.SetBodyLinearVelocity(0, movementVec.X(), movementVec.Y());
			if (spawner_object_timeout != 0)
			{
				go.timer = spawner_object_timeout;
			}
		}
		
		
		var spawner_object_timeout:int;
		var spawner_angle:Number;
		var spawner_velocity:Number;
		var spawner_initialdelay:int;
		var spawner_frequency:int;
		var spawner_total:int;
		var spawner_spawncount:int;
		var spawner_frame:int;
		var spawner_visible:Boolean;
		var spawner_spawnobjectList:Array;
		public function OnClickedSpawner()
		{
			//onClickedFunction = null;
			//state = 0;
		}
		
		public function RenderSpawner()
		{
//			dir = rotVel;		// DIR is being set by the physics, so usign rotVel to change the render angle
			RenderDispObjNormally();
//			var dir2:Number = rotVel * 0.3;
//			RenderDispObjAt(xpos, ypos, dobj1, 0, null, dir2);
		}
		public function InitSpawner()
		{
			renderFunction = RenderSpawner;
			
			Utils.GetParams(initParams);			
			spawner_object_timeout = Utils.GetParamNumber("spawner_object_timeout", 0) * Defs.fps;
			
			spawner_angle = Utils.GetParamNumber("spawner_angle", 0)-90;
			spawner_angle = Utils.DegToRad(spawner_angle);
			
			spawner_velocity = Utils.GetParamNumber("spawner_velocity", 1);
			spawner_initialdelay = Utils.GetParamNumber("spawner_initialdelay", 0) * Defs.fps;
			spawner_frequency = Utils.GetParamNumber("spawner_frequency", 3) * Defs.fps;
			spawner_total = Utils.GetParamInt("spawner_totalamount", 10);
			spawner_spawnobjectList = new Array();
			var s:String = Utils.GetParamString("spawner_spawnobject", "");
			spawner_spawnobjectList = s.split("+");
			
			spawner_frame = Utils.GetParamInt("spawner_frame", 1) - 1;
			spawner_visible = Utils.GetParamBool("spawner_visible", true);
			
			visible = spawner_visible;
			
			state = 0;
			timer = spawner_initialdelay;
			spawner_spawncount = 0;
			
			updateFunction = UpdateSpawner;
			
			//onClickedFunction = OnClickedSpawner;
			state = -1;
			dir = 1;
			rotVel = 1;
		}
		
//----------------------------------------------------------------------------------------------------------------		
		
		
		public function RenderScoreText()
		{	
			var xp:Number =  Math.round(xpos) - Math.round(Game.camera.x);
			var yp:Number =  Math.round(ypos) - Math.round(Game.camera.y);
			dobj.origMC.text1.theText.text = textMessage;
			dobj.origMC.text2.theText.text = textMessage1;
			dobj.RenderAtRotScaled_Vector(frame, bd, xp, yp, 1, 0, null, false, xflip);
		}
		public function UpdateScoreText()
		{
			if(state == 0)
			{
				if(PlayAnimation())
				{
					RemoveObject();
				}
			}			
		}
		public function InitScoreText(_message:String,_points:int)
		{
			textMessage = _message;
			textMessage1 = _points.toString() + " PTS";
			updateFunction = UpdateScoreText;
			renderFunction = RenderScoreText;
			dobj = GraphicObjects.GetDisplayObjByName("scoreText");
			frame = 0;
			
		}
		
		
		
		
		//----------------------------------------------------------------------------------------------------------------		
		
		
//---------------------------------------------------------------------------------------------------------------------		
//---------------------------------------------------------------------------------------------------------------------		
		
		public function OnHitBonusPickup(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (goHitter.name == "alien")
			{
				state = 1;
			}
		}
		public function UpdateBonusPickup()
		{
			if (state == 1)
			{
				RemoveObject(RemovePhysObj());
			}
		}
		public function InitBonusPickup()
		{
			updateFunction = UpdateBonusPickup;
			onHitFunction = OnHitBonusPickup;
			state = 0;
		}				

//---------------------------------------------------------------------------------------------------------------------		
//---------------------------------------------------------------------------------------------------------------------		
		
		
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------

		function OnHitSandBlock(hitterGO:GameObj)		
		{
			if (hitterGO == null) return;
			if (state != 0) return;
			if (hitterGO.name == "player" || hitterGO.name == "player_wheel")
			{
				timer++;
				if (timer >= Defs.fps/2)
				{
					state = 1;
				}
			}
		}

		function RenderSandBlock()
		{
			oldxpos = xpos;
			oldypos = ypos;
			if (state == 0 && timer > 5)
			{
				xpos += Utils.RandBetweenFloat( -1, 1);
				ypos += Utils.RandBetweenFloat( -1, 1);
			}
			RenderDispObjNormally();
			xpos = oldxpos;
			ypos = oldypos;
		}
		function UpdateSandBlock()
		{
			if (state == 1)
			{
				if (PlayAnimation())
				{
					RemoveObject(RemovePhysObj);
				}
			}
		}
		function InitSandBlock()
		{
			renderFunction = RenderSandBlock;
			onHitFunction = OnHitSandBlock;
			onHitPersistFunction = OnHitSandBlock;
			updateFunction = UpdateSandBlock;
			frameVel = 0.6;			
			timer = 0;
		}
//---------------------------------------------------------------------------------------------------------------

		function UpdateBreakable()
		{
			if (state == 0)
			{
				
			}
			else if (state == 1)
			{
				var soundName:String = "sfx_smash" + Utils.RandBetweenInt(1, 3);
				SFX_OneShot(soundName);

				RemoveObject(RemovePhysObj());
				
				for each(var marker:EdObjMarker in physobj.markers.markers)
				{
					Particles.Add(xpos, ypos).InitBreakablePieceFromMarker(breakable_baseName,marker,dir);
				}
				
				
			}
		}		

		
		
		function OnHitBreakable(hitterGO:GameObj)		
		{
			if (hitterGO == null) return;
//			if (hitterGO.collisionType == "bubble")
			


			if (hitterGO.name == "player" || hitterGO.name == "car")
			{
				var v1:Vec2 = new Vec2(0,0);
				
				frame = 0;
				frameVel = 1;
				state = 1;
				onHitFunction = null;
				movementVec.SetFromDxDy(v1.x, v1.y);
				movementVec.speed *= 0.1;
				
				var slowDown:Number = Vars.GetVarAsNumber("ninja_hitbreakable_vel_multiplier_"+GameVars.playerCharIndex);
				if (hitterGO.name == "car")
				{
					slowDown = Vars.GetVarAsNumber("car_hitbreakable_vel_multiplier_"+GameVars.playerCharIndex);
				}
				hitterGO.nape_bodies[0].velocity.x *= slowDown;
				hitterGO.nape_bodies[0].velocity.y *= slowDown;
				
				GameVars.IncrementCombo(this);
				GameVars.AddScore(score);

				GameVars.numSmashes++;

			}
			
		}	
		
		

		var breakable_baseName:String;
		function InitBreakable()
		{
			score = GameVars.SCORE_BREAKABLE;
			name = "breakable";
			breakable_baseName = physobj.initFunctionParameters;
			updateFunction =UpdateBreakable;
			onHitFunction = OnHitBreakable;
//			onHitPersistFunction = OnHitBreakable;
			frame = 0;
			health = maxHealth = 1;
			GameVars.numSmashables++;

		}
//---------------------------------------------------------------------------------------------------------------

		function InitBreakable_WoodenCrate()
		{
			var x:Number = -18;
			var y:Number = -16;
			var list:Array = new Array()
			list.push(new BreakablePieceDef( x+7,y+5, "woodenCrate1_part1"));
			list.push(new BreakablePieceDef( x+30,y+4, "woodenCrate1_part2"));
			list.push(new BreakablePieceDef( x+42,y+9, "woodenCrate1_part3"));
			list.push(new BreakablePieceDef( x+5,y+25, "woodenCrate1_part4"));
			list.push(new BreakablePieceDef( x+17,y+15, "woodenCrate1_part5"));
			list.push(new BreakablePieceDef( x+33,y+19, "woodenCrate1_part6"));
			list.push(new BreakablePieceDef( x+19,y+28, "woodenCrate1_part7"));
			list.push(new BreakablePieceDef( x+36,y+30, "woodenCrate1_part8"));
			Init_Breakable_Pieces(list);
		}

		function InitBreakable_Sandcastle()
		{
			var x:Number = -18;
			var y:Number = -16;
			var list:Array = new Array()
			
			for (var i:int = 0; i < 10; i++)
			{
				list.push(new BreakablePieceDef( Utils.RandBetweenFloat(-60,60),Utils.RandBetweenFloat(-75,-20), "sandParticle"));			
			}
			Init_Breakable_Pieces(list);
			
		}
		
		function InitBreakable_WoodenPost()
		{
			var list:Array = new Array()
			list.push(new BreakablePieceDef( 0,-20, "woodPost0_part3"));
			list.push(new BreakablePieceDef( 0,-1, "woodPost0_part2"));
			list.push(new BreakablePieceDef( 0,19, "woodPost0_part1"));
			Init_Breakable_Pieces(list);
		}

		function InitBreakable_Block()
		{
			var list:Array = new Array()
			list.push(new BreakablePieceDef( -20,0, "Block_part1"));
			list.push(new BreakablePieceDef( -7,19, "Block_part2"));
			list.push(new BreakablePieceDef( 18,10, "Block_part3"));
			list.push(new BreakablePieceDef( 9,6, "Block_part4"));
			list.push(new BreakablePieceDef( -6,0, "Block_part5"));
			list.push(new BreakablePieceDef( -17,-18, "Block_part6"));
			list.push(new BreakablePieceDef( 4,-13, "Block_part7"));
			list.push(new BreakablePieceDef( 17,-12, "Block_part8"));
			Init_Breakable_Pieces(list);
		}

//-------------------------------------------------------------------------------------------------------------
		function InitBreakable_Wood()
		{
			var list:Array = new Array()
			list.push(new BreakablePieceDef( -32,0, "Wood_part1"));
			list.push(new BreakablePieceDef( -9,1, "Wood_part2"));
			list.push(new BreakablePieceDef( 8,5, "Wood_part3"));
			list.push(new BreakablePieceDef( 34,4, "Wood_part4"));
			list.push(new BreakablePieceDef( 49,1, "Wood_part5"));
			list.push(new BreakablePieceDef( 21,-2, "Wood_part6"));
			list.push(new BreakablePieceDef( 2,-2, "Wood_part7"));
			list.push(new BreakablePieceDef( -14,-4, "Wood_part8"));
			list.push(new BreakablePieceDef( 2,2, "Wood_part9"));
			list.push(new BreakablePieceDef( 26,3, "Wood_part10"));
			Init_Breakable_Pieces(list);
		}

//-------------------------------------------------------------------------------------------------------------
		function InitBreakable_SwitchCover()
		{
			name = "switch_cover";
			var list:Array = new Array()
			list.push(new BreakablePieceDef( 2,4, "lever_part1"));
			list.push(new BreakablePieceDef( 19,-10, "lever_part2"));
			list.push(new BreakablePieceDef( 12,5, "lever_part3"));
			list.push(new BreakablePieceDef( -8,4, "lever_part4"));
			list.push(new BreakablePieceDef( 18,-8, "lever_part5"));
			list.push(new BreakablePieceDef( -3,-4, "lever_part6"));
			list.push(new BreakablePieceDef( 6,3, "lever_part7"));
			list.push(new BreakablePieceDef( -13,4, "lever_part8"));
			list.push(new BreakablePieceDef( -2,2, "lever_part9"));
			list.push(new BreakablePieceDef( 11,2, "lever_part10"));
			Init_Breakable_Pieces(list);
		}
		
//-------------------------------------------------------------------------------------------------------------
		var breakable_piece_def_list:Array;
		function Init_Breakable_Pieces(_list:Array)
		{
			breakable_piece_def_list = _list;
			updateFunction =Update_Breakable_Pieces;
			onHitFunction = OnHit_Breakable_Pieces;
			frame = 0;
			health = maxHealth = 1;
		}
		function Update_Breakable_Pieces()
		{
			if (state == 0)
			{
				
			}
			else if (state == 1)
			{
				var soundName:String = "sfx_wood_snap" + Utils.RandBetweenInt(1, 4);
				SFX_OneShot(soundName);

				if (break_sfx_name == "")
				{
//					SoundPlayer.Play("sfx_crate");
//					SoundPlayer.PlayRandomBetween("sfx_wood_snap1", "sfx_wood_snap4");
				}
				else
				{
					//SoundPlayer.Play(break_sfx_name);
				}
				RemoveObject(RemovePhysObj());
				GenerateBreakableBits();
			}
		}		
		
		function GenerateBreakableBits()
		{
			for each(var def:BreakablePieceDef in breakable_piece_def_list)
			{
				var r:Number = dir;
				var go:GameObj;
				
				Particles.Add(xpos, ypos).InitBreakablePiece(def, r);
				
				//go = GameObjects.AddObj(xpos, ypos, zpos);
				//go.InitBreakable_Piece(def, r);
				
				
				/*
				// physics version
				
				var m:Matrix = new Matrix();
				m.rotate(dir);
				var p:Point = new Point(def.x, def.y);
				p = m.transformPoint(p);
				var x:Number = xpos + p.x;
				var y:Number = ypos + p.y;
				
				
				var vec:Vec = new Vec();
				vec.rot = Utils.RandCircle();
				vec.speed = Utils.RandBetweenFloat( 1, 2);
				
				vec.Add(movementVec);
				
				go = PhysicsBase.AddPhysObjAt("broken_piece", x, y, Utils.RadToDeg(dir), 1);
				go.PostInitBreakable_Piece(def, r,vec);
				*/
				
			}
			
		}
		
		function OnHit_Breakable_Pieces(hitterGO:GameObj)		
		{
			if (hitterGO == null) return;
//			if (hitterGO.collisionType == "bubble")
			if (hitterGO.name == "player" || hitterGO.name == "player_wheel")
			{
				var aa:InteractionCallback = hitterGO.hitInteractionCallback_Nape
				var bb:Contact = hitterGO.hitContactPoint_Nape;
				
				
				var v0:Vec3 = nape_bodies[0].normalImpulse (hitterGO.nape_bodies[0]);
				
				var v1:Vec2 = new Vec2(v0.x, v0.y);
				
				var l:Number = v1.length;
				
				l /= hitterGO.GetBodyMass(0);
				
				l = hitterGO.GetBodyLinearVelocity(0).length;
				
//				Utils.print("hit speed " + l);
				
				if (l < 1) return;
				
				frame = 0;
				frameVel = 1;
				state = 1;
				onHitFunction = null;
				movementVec.SetFromDxDy(v1.x, v1.y);
				movementVec.speed *= 0.1;
			}
			
		}	
		
//---------------------------------------------------------------------		

		public function RenderBreakable_Piece()
		{
			RenderDispObjNormally();
		}
		public function UpdateBreakable_Piece()
		{			
			dir += rotVel;
			xpos += xvel;
			ypos += yvel;
			yvel += 0.3;
			timer--;
			if (timer <= 0)
			{
				RemoveObject();
			}
			alpha = Utils.ScaleTo(0, 1, 0, timerMax, timer);
		}
		
		public function UpdateBreakable_Piece_Physics()
		{			
			timer--;
			if (timer <= 0)
			{
				RemoveObject(RemovePhysObj);
			}
//			alpha = Utils.ScaleTo(0, 1, 0, timerMax, timer);
		}
		
		public function PostInitBreakable_Piece(def:BreakablePieceDef , rotat:Number,vec:Vec)
		{
			dobj = GraphicObjects.GetDisplayObjByName(def.objname);
			frame = 0;
			
			ApplyImpulse(vec.X(), vec.Y());
			
			timer = timerMax = Utils.RandBetweenInt(100,200);
			
		}
		public function InitBreakable_Piece_Physics()
		{
			updateFunction = UpdateBreakable_Piece_Physics;
			renderFunction = RenderBreakable_Piece;
		}

		public function InitBreakable_Piece(def:BreakablePieceDef ,rotat:Number)
		{
			updateFunction = UpdateBreakable_Piece;
			renderFunction = RenderBreakable_Piece;
			dobj = GraphicObjects.GetDisplayObjByName(def.objname);
			frame = 0;
			
			var m:Matrix = new Matrix();
			m.rotate(rotat);
			var p:Point = new Point(def.x, def.y);
			p = m.transformPoint(p);
			xpos += p.x;
			ypos += p.y;
			
			dir = rotat;
			
			
			
			var vec:Vec = new Vec();
			vec.rot = Utils.RandBetweenFloat( -Math.PI / 2, 0);
//			Utils.RandCircle();
			vec.speed = Utils.RandBetweenFloat( 10,15);
			
			xvel = vec.X();
			yvel = vec.Y();
			rotVel = Utils.RandBetweenFloat(0.1, 0.2);
			if (Utils.RandBetweenInt(0, 1000) < 500) rotVel = -rotVel;
			timer = timerMax = Utils.RandBetweenInt(30,40);
			
		}
		
		

		
		
		//-----------------------------------------------------------------
		
		function OnHitSpringboard(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			state = 1;
			frame = 0;
		}
		function UpdateSpringboard()
		{
			if (state == 1)
			{
				if (PlayAnimation())
				{
					state = 0;
				}
			}
		}
		function InitSpringboard()
		{
			onHitFunction = OnHitSpringboard;				
			updateFunction = UpdateSpringboard;			
		}
		
		
		
		//-----------------------------------------------------------------
		
		
		//-----------------------------------------------------------------
		
		function UpdateCycleAnimation()
		{
			CycleAnimation();
		}
		function InitCycleAnimation()
		{
			updateFunction = UpdateCycleAnimation;			
		}
		
//-----------------------------------------------------------------
//-----------------------------------------------------------------
		
		
		
		
		//-----------------------------------------------------------------
		
//---------------------------------------------------------------------------------------		

		//-----------------------------------------------------------------
		
		var conveyor_speed:Number;
		function OnHitConveyor(goHitter:GameObj)
		{
			if (goHitter == null) return;
		}
		function SwitchedConveyor()
		{
			conveyor_speed = -conveyor_speed;
			var conveyor_speedA:Number = Math.abs(conveyor_speed);
			frameVel = Utils.ScaleTo(0, 2, 0, 200, conveyor_speedA);
			if ( conveyor_speed < 0) frameVel = -frameVel;
			
			var b:Body = nape_bodies[0];
			
			gmat.identity();
			gmat.rotate(dir);
			var p:Point = new Point(conveyor_speed, 0);
			p = gmat.transformPoint(p);
			
			b.surfaceVel = new Vec2(p.x,p.y);
			
		}
		function UpdateConveyor()
		{
			CycleAnimation();
		}
		function InitConveyor()
		{
			Utils.GetParams(initParams);
			
			conveyor_speed = Utils.GetParamNumber("conveyor_speed",50);						
			
			var conveyor_speedA:Number = Math.abs(conveyor_speed);
			frameVel = Utils.ScaleTo(0, 2, 0, 200, conveyor_speedA);
			if ( conveyor_speed < 0) frameVel = -frameVel;
			
			
			switchFunction = SwitchedConveyor;
			
			onHitFunction = OnHitConveyor;				
			updateFunction = UpdateConveyor;	
			var b:Body = nape_bodies[0];
			
			gmat.identity();
			gmat.rotate(dir);
			var p:Point = new Point(conveyor_speed, 0);
			p = gmat.transformPoint(p);
			
			b.surfaceVel = new Vec2(p.x,p.y);
		}

		//-----------------------------------------------------------------
		//-----------------------------------------------------------------
		//-----------------------------------------------------------------
		
		function UpdateGameObjJoint_Trapeze()
		{
			var j0:PivotJoint = jointController_joints[0] as PivotJoint;
			var j_motor:MotorJoint = jointController_joints[1] as MotorJoint;
			j_motor.ratio = 1;
			
			var p1:Vec2 = j0.body1.localPointToWorld(new Vec2(j0.anchor1.x , j0.anchor1.y));
			var p2:Vec2 = j0.body1.localPointToWorld(new Vec2(j0.anchor2.x , j0.anchor2.y));
			var ang:Number = Math.atan2(p2.y - p1.y, p2.x - p1.x);
			
			ang = j0.body2.rotation;
			
			trace(state+"    "+ang);
			
			//var ang:Number = Math.atan2(, j0.anchor2.x - j0.anchor1.x);
			
			var trapeze_maxang:Number = Vars.GetVarAsNumber("trapeze_maxang");
			var trapeze_motorRate:Number = Vars.GetVarAsNumber("trapeze_motorRate");
			var trapeze_maxforce:Number = Vars.GetVarAsNumber("trapeze_maxforce");
			
			
			j_motor.maxForce = trapeze_maxforce;
			if (state == 0)
			{ 
				j_motor.rate = trapeze_motorRate;
				
				if(ang > trapeze_maxang)
				{
					state = 1;
				}
			}
			if (state == 1)
			{
				j_motor.rate = -trapeze_motorRate;
				if(ang < -trapeze_maxang)
				{
					state = 0;
				}
			}
		}
		function InitGameObjJoint_Trapeze(cons:Vector.<Constraint>)
		{
			jointController_joints = new Vector.<Constraint>();
			
			
			for each(var c:Constraint in cons)
			{

				jointController_joints.push(c);
			}
			
			if (jointController_joints.length != 2)
			{
				trace("error InitGameObjJoint_Trapeze not enough constraints");
				return;
			}
			
			var j_motor:MotorJoint = jointController_joints[1] as MotorJoint;
			j_motor.rate = 1000;
			j_motor.ratio = 1;
			
			updateFunction = UpdateGameObjJoint_Trapeze;
			state = 0;
			timer = 0;
		}

		
		
		//-----------------------------------------------------------------
		//-----------------------------------------------------------------
		
		
		function UpdateJoint_RotateConstant()
		{
			var j0:PivotJoint = jointController_joints[0] as PivotJoint;
			
			var body:Body = j0.body2;
			
			j0.body2.angularVel = 0.1;
			
			var da:Number = joint_requiredAngle - body.rotation;
			
			var ts:Number = PhysicsBase.nape_oneOverTimeStep;
			da *= ts;
			
			body.angularVel = da;
			
			joint_requiredAngle += constantRotVel; 
			
			
		}
		
		var constantRotVel:Number;
		var joint_requiredAngle:Number;
		
		function InitJoint_RotateConstant(cons:Vector.<Constraint>)
		{
			joint_requiredAngle = dir;
			constantRotVel = edJoint.objParameters.GetValueNumber("rev_motorrate");
			
			jointController_joints = new Vector.<Constraint>();
			
			
			for each(var c:Constraint in cons)
			{

				jointController_joints.push(c);
			}
			
			
			updateFunction = UpdateJoint_RotateConstant;
			state = 0;
			timer = 0;
		}
		
		//-----------------------------------------------------------------
		//-----------------------------------------------------------------
		
		
		function UpdateGameObjJoint_SwitchedDistance()
		{
			var dj:DistanceJoint = jointController_joints[0] as DistanceJoint;
			
			dj.jointMax += yvel;
			if (dj.jointMax > jointMaxDist) 
			{
				dj.jointMax = jointMaxDist;
			}
			if (dj.jointMax < jointMinDist)
			{
				dj.jointMax = jointMinDist;
			}
			dj.jointMin = dj.jointMax;
		}
		function SwitchGameObjJoint_SwitchedDistance()
		{
			yvel *= -1;
		}
		
		
		

		var jointMinDist:Number;
		var jointMaxDist:Number;
		function InitGameObjJoint_SwitchedDistance1(cons:Vector.<Constraint>)
		{
			InitGameObjJoint_SwitchedDistance(cons);
			jointMinDist = jointMaxDist / 2;

		}
		
		
		function InitGameObjJoint_SwitchedDistance(cons:Vector.<Constraint>)
		{
			yvel = 2;
			jointController_joints = new Vector.<Constraint>();
			for each(var c:Constraint in cons)
			{
				jointController_joints.push(c);
			}
			switchFunction = SwitchGameObjJoint_SwitchedDistance;
			renderFunction = RenderJointRenderer;
			updateFunction = UpdateGameObjJoint_SwitchedDistance;
			
			switchName = Game.GetSwitchJointName(id);
			
			jointMaxDist = 200;

			for each(var c:Constraint in jointController_joints)
			{
				if (c is DistanceJoint)
				{
					var d:DistanceJoint = c as DistanceJoint;
					var p0:Point = new Point(d.anchor1.x, d.anchor1.y);
					var p1:Point = new Point(d.anchor2.x, d.anchor2.y);
					
					gmat.identity();
					gmat.rotate(d.body1.rotation);
					p0 = gmat.transformPoint(p0);
					gmat.identity();
					gmat.rotate(d.body2.rotation);
					p1 = gmat.transformPoint(p1);
					
					p0.x += d.body1.position.x;
					p0.y += d.body1.position.y;
					p1.x += d.body2.position.x;
					p1.y += d.body2.position.y;
					
					jointMaxDist = Utils.DistBetweenPoints(p0.x,p0.y,p1.x,p1.y);
					Utils.print("jointMaxDist " + jointMaxDist);
				}
			}
			
			jointMinDist = jointMaxDist / 4;
			//			visible = false;
		}
		
		function UpdateJoint_RotateSwitch()
		{
			var minAng:Number = 0;
			var maxAng:Number = 0;
			for each(var c:Constraint in jointController_joints)
			{
				if (c is AngleJoint)
				{
					var aj:AngleJoint = c as AngleJoint;
					minAng = aj.jointMin;
					maxAng = aj.jointMax;		

				}
			}
			for each(var c:Constraint in jointController_joints)
			{
				if (c is PivotJoint)
				{
					var pv:PivotJoint = c as PivotJoint;
					
					pv.body2.angularVel = 0;
					if (rotVel < 0)
					{
						if (pv.body2.rotation > minAng)
						{
							pv.body2.angularVel = rotVel;
						}						
					}
					else if (rotVel > 0)
					{
						if (pv.body2.rotation < maxAng)
						{
							pv.body2.angularVel = rotVel;
						}						
					}
				}
			}
			
		}
		function SwitchJoint_RotateSwitch()
		{
			rotVel *= -1;
		}
		function InitJoint_RotateSwitch(cons:Vector.<Constraint>)
		{
			rotVel = 5;
			CopyJointDataToGO(cons);
			switchFunction = SwitchJoint_RotateSwitch;
			updateFunction = UpdateJoint_RotateSwitch;
			visible = false;
			
		}

		function UpdateJoint_RotateSwitch_StopGo()
		{
			dir += rotVel;
			
			var m:Matrix = new Matrix();
			var p:Point = new Point(jointObjBody_xoff, jointObjBody_yoff);
			m.rotate(rotVel);
			p = m.transformPoint(p);
			jointObjBody_xoff = p.x;
			jointObjBody_yoff = p.y;

			var dt:Number = 1 / 60;
			
			jointObjBody.setVelocityFromTarget(new Vec2((xpos + p.x), (ypos + p.y)), dir, dt);
			
		}
		
		function SwitchJoint_RotateSwitch_StopGo()
		{
			switchFlag = (switchFlag == false);
			if (switchFlag == false)
			{
				rotVel = 0.02;
			}
			else
			{
				rotVel = 0;
			}
			
		}
		
		var jointObjBody:Body;
		var jointObjBody_xoff:Number;
		var jointObjBody_yoff:Number;
		function InitJoint_RotateSwitch_StopGo(cons:Vector.<Constraint>)
		{
			name = "poocock2";
			rotVel = 0.02;
			CopyJointDataToGO(cons);
			switchFunction = SwitchJoint_RotateSwitch_StopGo;
			updateFunction = UpdateJoint_RotateSwitch_StopGo;
			visible = false;
			switchFlag = false;
			
			for each(var c:Constraint in jointController_joints)
			{
				if (c is PivotJoint)
				{
					var pv:PivotJoint = c as PivotJoint;
					
					pv.body2.angularVel = rotVel;
					pv.body2.type = BodyType.KINEMATIC;
					jointObjBody = pv.body2;
					dir = jointObjBody.rotation;
					jointObjBody_xoff = jointObjBody.position.x - pv.anchor1.x;
					jointObjBody_yoff = jointObjBody.position.y - pv.anchor1.y;
					
					xpos =  pv.anchor1.x;
					ypos =  pv.anchor1.y;
				}
			}			
			
			for each(var j:Constraint in jointController_joints)
			{
				if (PhysicsBase.GetNapeSpace().constraints.has(j))
				{
					PhysicsBase.GetNapeSpace().constraints.remove(j);
					
					//JointObject_JointRemoved(j);
				}
			}
			
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------		
// ----------------------------------------------------------------------------------------------------------------------		
		
		
		
		function CopyJointDataToGO(cons:Vector.<Constraint>)
		{
			jointController_joints = new Vector.<Constraint>();
			for each(var c:Constraint in cons)
			{
				jointController_joints.push(c);
			}
		}
		function InitJoint_Render(cons:Vector.<Constraint>)
		{
			CopyJointDataToGO(cons);
			renderFunction = RenderJointRenderer;
			
		}
		function JointObject_JointRemoved(j:Constraint)
		{
			for each(var c:Constraint in jointController_joints)
			{
				if (c == j)
				{
					var aaa:int = 0;
					RemoveObject();
				}
			}
		}

		
//------------------------------------------------------------------------------------------------------------			

		public function GameObj_RenderHelpText():void
		{
			var xp:Number =  Math.round(xpos) - Math.round(Game.camera.x);
			var yp:Number =  Math.round(ypos) - Math.round(Game.camera.y);
			if (false)	// normal
			{
				TextRenderer.RenderAt(bd, xp, yp, textMessage, dir, scale, TextRenderer.JUSTIFY_CENTRE, ct);
			}
			else
			{
				// bring it on a char at a time;
				var firstChar:int = 0;
				var lastChar:int = timer;
				TextRenderer.RenderAt(0,bd, xp, yp, textMessage, dir, scale, TextRenderer.JUSTIFY_CENTRE, ct,firstChar,lastChar);
				
//				var offset:Number = 255 - ((timer - int(timer)) * 255);
//				var ct1:ColorTransform = new ColorTransform(1,1,1,1,0,-offset,-offset,0);				
//				firstChar = lastChar;
//				TextRenderer.RenderAt(bd, xp, yp, textMessage, dir, scale, TextRenderer.JUSTIFY_CENTRE, ct1,firstChar,lastChar);
				
			}
		
		}

//------------------------------------------------------------------------------------------------------------			
		
		public function GameObj_UpdateHelpText():void
		{
			if (state == 0)
			{
 				 if (logicLink0.length != 0)
				{ 
					state = 3;
				}
				
				visible = false;
				timer--;
				if (timer <= 0)
				{
					state = 1;
					visible = true;
					timer = 0;
				}
			}
			else if (state == 1)
			{
//				SFX_OneShot("sfx_text_appear");

				timer += 0.2;
				if (timer >= textMessage.length)
				{
					timer = textMessage.length;
				}
				
				visible = true;
				scale = 1;
			}
			else if (state == 3)
			{
				// w8aiting for switch
			}
		}

		public function GameObj_UpdateHelpText_SpringIn():void
		{
			if (state == 0)
			{
 				 if (logicLink0.length != 0)
				{ 
					state = 3;
				}
				
				visible = false;
				timer--;
				if (timer <= 0)
				{
					state = 1;
					visible = true;
					timer = timerMax = Defs.fps * 2;
				}
			}
			else if (state == 1)
			{
				SFX_OneShot("sfx_text_appear");

				PlayAnimation();
				visible = true;
				scale = 0;
				state = 2;
				timer = timerMax = Defs.fps * 2;
			}
			else if (state == 2)
			{
				var f:Number = Utils.ScaleTo(1,0, 0, timerMax, timer);
				f = Ease.Spring_Out(f);
				scale = f * 1;
				if (scale < 0) scale = 0;
				
				timer--;
				if (timer <= 0)
				{
					timer = 0;
				}
			}
			else if (state == 3)
			{
				// w8aiting for switch
			}
		}
		
		
		public function GameObj_RenderHelpText_WithMarker():void
		{
			GameObj_RenderHelpText();
			var xp:Number =  Math.round(xpos) - Math.round(Game.camera.x);
			var yp:Number =  Math.round(ypos) - Math.round(Game.camera.y);
			var dob:DisplayObj = GraphicObjects.GetDisplayObjByName("walkthroughMarker");
			dob.RenderAt(0, bd, xp-25,yp-10);
		}
		
		public function OnSwitch_HelpText():void
		{
			if (state == 3)
			{
				state = 0;
				logicLink0 = new Array();
			}
		}

		public function GameObj_InitHelpTextW_WithMarker():void
		{
			GameObj_InitHelpTextW();
			renderFunction = GameObj_RenderHelpText_WithMarker;
		}
		public function GameObj_InitHelpTextW():void
		{
			updateInWalkthrough = true;
			name = "walkthrough";
			Utils.GetParams(initParams);
			
			textMessage = Utils.GetParamString("helptext_text", "helptxt");
			timer = Utils.GetParamNumber("helptext_initialdelay", 0) * Defs.fps;
			var c:String = Utils.GetParamString("helptext_color");
			ct = Utils.HexStringToColorTransform(c);
			updateFunction = GameObj_UpdateHelpText;
			renderFunction = GameObj_RenderHelpText;
			zpos = -10000;
			frame = 0;
			state = 3;
			scale = 1;
//			visible = true;
			if (Game.doWalkthrough == false)
			{
				RemoveObject();
				visible = false;
			}
		}
		public function GameObj_InitHelpText():void
		{
			name = "text";
			Utils.GetParams(initParams);
			
			textMessage = Utils.GetParamString("helptext_text", "helptxt");
			timer = Utils.GetParamNumber("helptext_initialdelay", 0) * Defs.fps;
			var c:String = Utils.GetParamString("helptext_color");
			ct = Utils.HexStringToColorTransform(c);
			updateFunction = GameObj_UpdateHelpText;
			renderFunction = GameObj_RenderHelpText;
			zpos = -10000;
			frame = 0;
			state = 0;
			
			switchFunction = OnSwitch_HelpText;
			visible = false;
			scale = 0;

			if (Game.doWalkthrough == true)
			{
				RemoveObject();
				visible = false;
			}
			
		}
		
		
		public function GameObj_UpdateHelpObject():void
		{
			if (state == 0)
			{
				visible = false;
				timer--;
				if (timer <= 0)
				{
					state = 1;
					visible = true;
				}
			}
			else if (state == 1)
			{
				//SoundPlayer.Play("sfx_text_appear");
				PlayAnimation();
				visible = true;
				state = 2;
			}
			else if (state == 2)
			{
				PlayAnimation();				
			}
			else if (state == 3)
			{
				// waiting for switch
			}
		}
		
		public function GameObj_InitHelpObject():void
		{
			name = "text";
			Utils.GetParams(initParams);
			
			timer = Utils.GetParamNumber("helptext_initialdelay", 0) * Defs.fps
			updateFunction = GameObj_UpdateHelpObject;
			zpos = -10000;
			frame = 0;
			state = 0;

			switchName = Game.GetSwitchJointName(id);
			
			if (switchName != "")
			{			
				state = 3;
				switchFunction = OnSwitch_HelpText;
			}
			visible = false;
		
		}

		
		
//---------------------------------------------		

		public function GameObj_UpdateHelpObjectAppear():void
		{
			if (state == 0)
			{
				visible = false;
				timer--;
				if (timer <= 0)
				{
					state = 1;
					visible = true;
				}
			}
			else if (state == 1)
			{
				//SoundPlayer.Play("sfx_text_appear");
				CycleAnimation();
				visible = true;
				state = 2;
			}
			else if (state == 2)
			{
				CycleAnimation();				
			}
			else if (state == 3)
			{
				// waiting for switch
			}
		}
		
		public function GameObj_InitHelpObjectAppear():void
		{
			name = "text";
			Utils.GetParams(initParams);
			
			timer = Utils.GetParamNumber("helptext_initialdelay", 0) * Defs.fps
			updateFunction = GameObj_UpdateHelpObjectAppear;
			zpos = -10000;
			frame = 0;
			state = 0;

			switchName = Game.GetSwitchJointName(id);
			
			if (switchName != "")
			{			
				state = 3;
				switchFunction = OnSwitch_HelpText;
			}
			visible = false;
		
		}


//---------------------------------------------		
		public function GameObj_RenderHelpText_Walkthrough():void
		{
			if (Game.doWalkthrough == false) return;
			var xp:Number =  Math.round(xpos) - Math.round(Game.camera.x);
			var yp:Number =  Math.round(ypos) - Math.round(Game.camera.y);
			
			dobj.origMC.helpClip.help.text = textMessage;
			dobj.RenderAtRotScaled_Vector(frame, bd, xp, yp, 1, 0, null, false, xflip);
		
		}

		public function UpdateWalkthroughObject():void
		{
			if (state == 0)
			{
				visible = false;
				timer--;
				if (timer <= 0)
				{
					state = 1;
					visible = true;
					timer = timerMax = Defs.fps * 2;
				}
			}
			else if (state == 1)
			{
			}
			
		}
		public function InitWalkthroughObject():void
		{
			updateInWalkthrough = true;
			name = "walkthrough";
			updateFunction = UpdateWalkthroughObject;
			timer = Utils.GetParamNumber("helptext_initialdelay", 0) * Defs.fps
			//scale = 1;
			state = 0;
			if (Game.doWalkthrough == false)
			{
				RemoveObject();
				active = false;
				visible = false;
			}
		}
		
		
//-----------------------------------------------------------------
		
		
		function RenderRain()
		{
			for (var i:int = 0; i < 20; i++)
			{
				var x:Number = Utils.RandBetweenFloat(0, Defs.displayarea_w);
				var y:Number = Utils.RandBetweenFloat(0, Defs.displayarea_h);
				frame = Utils.RandBetweenInt(0, dobj.GetNumFrames() - 1);
				dobj.RenderAt(frame, bd, x, y);
			}
		}
		function UpdateRain()
		{
		}
		function InitRain()
		{
			renderFunction = RenderRain;
			updateFunction = UpdateRain;			
		}

		//-----------------------------------------------------------------
		
		
		function RenderWidescreen()
		{
			if (PROJECT::useStage3D) return;
			var r:Rectangle = new Rectangle(0, 0, Defs.displayarea_w, 0);
			r.height = ypos;
			bd.fillRect(r, 0xff000000);
			r.height = ypos;
			r.y = Defs.displayarea_h - ypos;
			bd.fillRect(r, 0xff000000);
		}
		function UpdateWidescreen()
		{
			if (state == 0)
			{
				timer++;
				var t:Number = Utils.ScaleTo(0, 1, 0, timerMax, timer);
				t = Ease.Power_In(t, 2);			
				ypos = Utils.ScaleTo(0, 100, 0, 1, t);
				
				if (timer >= timerMax)
				{
					timer = timerMax;
					state = 1;
					timer = Defs.fps * 7;
				}
			}
			else if (state == 1)
			{
				timer--;
				if (timer <= 0)
				{
					timer = timerMax;
					state = 2;
				}
			}
			else if (state == 2)
			{
				timer--;
				var t:Number = Utils.ScaleTo(0, 1, 0, timerMax, timer);
				t = Ease.Power_In(t, 2);			
				ypos = Utils.ScaleTo(0, 100, 0, 1, t);
				if (timer <= 0)
				{
					timer = 0;
					state = 3;
				}
			}			
		}
		function InitWidescreen()
		{
			renderFunction = RenderWidescreen;
			updateFunction = UpdateWidescreen;		
			state = 0;
			timer = 0;
			timerMax = 30;
		}
		
//-----------------------------------------------------------------
//-----------------------------------------------------------------
//-----------------------------------------------------------------
		
		
		
		//-----------------------------------------------------------------

		
		//-----------------------------------------------------------------
		
		function UpdatePlaybackCursor()
		{
		}
		function InitPlaybackCursor()
		{
			updateFunction = UpdatePlaybackCursor;		
			dobj = GraphicObjects.GetDisplayObjByName("Cursor_Walkthrough_Pointer");
			frame = 0;
		}
		
		function UpdatePlaybackClick()
		{
			if (PlayAnimation())
			{
				RemoveObject();
			}
		}
		function InitPlaybackClick()
		{
			updateFunction = UpdatePlaybackClick;		
			dobj = GraphicObjects.GetDisplayObjByName("Walkthrough_click");
			frame = 0;
		}

//-------------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------------		


//-------------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------------		
		
//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------		

		var patrol_x0:Number;
		var patrol_x1:Number;
		
		function RaycastBelow(snap:Boolean):Boolean
		{
			var highestY:Number = 99999;
			
			var r:Ray = new Ray(new Vec2(xpos, ypos - 50), new Vec2(0, 1));
			r.maxDistance = 100;
			if (snap == false)
			{
				r.maxDistance = 50;
			}
				
			var filter:InteractionFilter = new InteractionFilter(1, 1, 0, 0, 0, 0);
				
			var rr:RayResult = PhysicsBase.GetNapeSpace().rayCast(r, false, filter);
			if (rr != null)
			{
				var p:Vec2 = r.at(rr.distance);
				highestY = p.y;
				ypos = highestY;
				return true;
			}
			return false;
		}

		function RaycastGetPosBelow():Number
		{
			var highestY:Number = 0;
			
			var r:Ray = new Ray(new Vec2(xpos, ypos), new Vec2(0, 1));
			r.maxDistance = 1000;
				
			var filter:InteractionFilter = new InteractionFilter(1, 1, 0, 0, 0, 0);
				
			var rr:RayResult = PhysicsBase.GetNapeSpace().rayCast(r, false, filter);
			if (rr != null)
			{
				var p:Vec2 = r.at(rr.distance);
				highestY = p.y;
			}
			else
			{
				return NaN;
			}
			return highestY;
		}
		
		
//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------		

		
//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------		



//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------

		
//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------
		
		function PhysicsUpdateNull(b:Body)
		{
			/*
			if (b.isStatic())
			{
				trace("dodgy static object PhysicsUpdateNull");
				return;
			}
			*/
			b.position.x = xpos;
			b.position.y = ypos;
		}
		
		function PhysicsSetStationary()
		{
			updateFromPhysicsFunction = PhysicsUpdateNull;
		}
		function PhysicsSetMovable()
		{
			updateFromPhysicsFunction = null;
		}
		function PhysicsSetInactive()
		{
			PhysicsBase.GetNapeSpace().bodies.remove(nape_bodies[0]);				
		}
		function PhysicsSetActive()
		{
			PhysicsBase.GetNapeSpace().bodies.add(nape_bodies[0]);				
		}


//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------		

//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------		

		function SwitchedCog()
		{
			if (state == 0)
			{
				state = 1;
			}
			else
			{
				state = 0;
			}
		}
		function UpdateCog()
		{
			if (state == 0)
			{
				dir += 0.1;
				if (dir >= 6) dir = 6;
			}
			else if (state == 1)
			{
				dir -= 0.1;
				if (dir < 0) dir = 0;
			}
		}
		function InitCog()
		{
			updateFunction = UpdateCog;
			switchFunction = SwitchedCog;
			switchFlag = false;
			state = 1;
		}

//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------		

		//-----------------------------------------------------------------
		
		function OnHitFlyingBird(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 1) return;
			if (goHitter.collisionType == "football" || goHitter.collisionType == "beachball")
			{
				if (goHitter.parentObj.colFlag_isPlayer)
				{
					//Stats.Add("Total Birds Hit", 1);
				}
				
				timer = Utils.RandBetweenInt(100,300);
				visible = false;
				SetBodySensorMask( -1, 0);
				state = 0;
				BirdGenerateFeathers();
			}
		}
		
		
		function UpdateFlyingBird()
		{
			if (state == 0)
			{
				timer--;
				if (timer <= 0)
				{
					xpos = Grass.minX;
					xvel = Utils.RandBetweenFloat(6,9)/4;
					xflip = false;
					if (Utils.RandBool())
					{
						xpos = Grass.maxX;
						xvel = -xvel;
						xflip = true;
					}
					state = 1;
					visible = true;
					SetBodySensorMask( -1, 8);
					timer3 = Utils.RandBetweenFloat(0.05,0.1)/4;
					timer2 = Utils.RandBetweenFloat(5,30);
					timer1 = Utils.RandBetweenInt(0, 1000);
				}
			}
			else if (state == 1)
			{
				timer1++;
				ypos = starty + ((Math.sin(timer1 * timer3)) * timer2);
				xpos += xvel;
				CycleAnimation();
				if (xpos > Grass.maxX || xpos < Grass.minX)
				{
					timer = Utils.RandBetweenInt(100, 200);
					visible = false;
					SetBodySensorMask( -1, 0);
					state = 0;
				}
				SetBodyXForm_Immediate(0, xpos, ypos, 0);
			}
		}
		function InitFlyingBird()
		{
			useMultiplePhysicsUpdates = true;
			onHitFunction = OnHitFlyingBird;				
			updateFunction = UpdateFlyingBird;	
			updateFromPhysicsFunction = UpdatePhysicsNull;
			visible = false;
			SetBodySensorMask( -1, 0);
			state = 0;
			timer = Utils.RandBetweenInt(50, 100);	
			timer2 = Utils.RandBetweenFloat(5, 10);
			starty = ypos;
			frameVel = 0.25;
			
		}
		
		//-----------------------------------------------------------------
		
		
		function FootballGenerateSparkle()
		{
			for (var i:int = 0; i < 1; i++)
			{
				var p:Particle = Particles.Add(xpos, ypos);
				p.InitFeather("fx_sparkles_gold", i);
			}
			
		}
		function BirdGenerateFeathers()
		{
			for (var i:int = 0; i < 6; i++)
			{
				var p:Particle = Particles.Add(xpos, ypos);
				p.InitFeather("feathers", i);
			}
		}
				
		function OnHitBird(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (goHitter.collisionType == "football" || goHitter.collisionType == "beachball")
			{
//				if (goHitter.parentObj.colFlag_isPlayer)
//				{
//					Stats.Add("Total Birds Hit", 1);
//				}
				RemoveObject(RemovePhysObj);
				BirdGenerateFeathers();
			}
		}
		function UpdateBird()
		{
			if (state == 0 || state == 1)
			{
				SetBodyXForm_Immediate(0, xpos, ypos, 0);
				PlayAnimationEx();
				var d2:Number = birdWatchDist2;
				timer1++;
				if (timer1 >= 4) timer1 = 0;
				
				
				var ballGO:GameObj = GameVars.footballGO;
				if (ballGO != null)
				{
					if (Utils.Dist2BetweenPoints(xpos, ypos, ballGO.xpos, ballGO.ypos) < d2)
					{
						state = 10;
						dobj = GraphicObjects.GetDisplayObjByName("parrotFly");
						frame = 0;
						yvel = Utils.RandBetweenFloat( -1, -3)/4;
						xvel = 0;
						xacc = Utils.RandBetweenFloat(0.2, 0.4)/16;
						timer = 300*4;
						if (Utils.RandBool())
						{
							SFX_OneShot("sfx_bird_squalk");
						}
						else
						{
							SFX_OneShot("sfx_bird_flyoff");
						}
					}
				}	
				timer--;
				if (timer <= 0)
				{
					state = Utils.RandBetweenInt(0, 1);
					SetAnimRangeSingle("flap" + int(state + 1));
					timer = Utils.RandBetweenInt(10, 50)*4;
				}
			}
			else if (state == 10)
			{
				CycleAnimation();
				ypos += yvel;
				xpos += xvel;
				xvel += xacc;
				yvel -= 0.1/16;
				timer--;
				if (timer <= 0)
				{
					RemoveObject(RemovePhysObj);
				}
				SetBodyXForm_Immediate(0, xpos, ypos, 0);
			}
		}
		function UpdatePhysicsNull(b:Body)
		{
			
		}
		var birdWatchDist2:Number;
		function InitBird()
		{
			useMultiplePhysicsUpdates = true;
			onHitFunction = OnHitBird;				
			updateFunction = UpdateBird;	
			updateFromPhysicsFunction = UpdatePhysicsNull;
			timer = Utils.RandBetweenInt(30, 50);
			state = Utils.RandBetweenInt(0, 1);
			timer1 = 0;
			SetAnimRangeSingle("flap1");
			birdWatchDist2 = Utils.RandBetweenFloat(100,100);
			birdWatchDist2 *= birdWatchDist2;
			frameVel = 0.25;
			
		}

//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------		

		function UpdateSmokePuff()
		{
			yvel = -0.3
			
			ypos += yvel;
			scale -= 0.02;
			if (scale <= 0.1)
			{
				RemoveObject();
			}
		}
		function InitSmokePuff()
		{
			updateFunction = UpdateSmokePuff;
			timer = Defs.fps;			
			dobj = GraphicObjects.GetDisplayObjByName("fx_smoke");
			frame = 0;
		}
		
		
//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------
		
		function UpdateAnimatedWhenMoving()
		{
			CycleAnimation();
			var v:Number = GetBodyLinearVelocity(0).length;
			
			frameVel = Utils.ScaleToPreLimit(0, 2, 0, 100, v);
		}
		function InitAnimatedWhenMoving()
		{
			updateFunction = UpdateAnimatedWhenMoving;
			frameVel = 0;
		}

		
		function UpdateAnimatedWaterBlock()
		{
			var tab:Array = [0, 1, 2, 1];
			frame1 += frameVel;
			if (frame1 >= 4) frame1 -= 4;
			frame = tab[int(frame1)];
		}
		function InitAnimatedWaterBlock()
		{
			updateFunction = UpdateAnimatedWaterBlock;
			frame1 = 0;
			frameVel = 0.2;
		}
		
//-----------------------------------------------------------------------------------------------------		

		function RenderCombinedStaticObj()
		{
			PROJECT::useStage3D
			{

				gmat3d.identity();
				
				var x:Number = -Game.camera.x;
				var y:Number = -Game.camera.y;
				
				var triList:s3dTriList = s3d.triangleLists[s3dTriListIndex];
				s3d.RenderPreUploadedTriangleList1(x,y,gmat3d, dobj.GetTexture(0), triList);
			}
			
		}
		function AddCombinedStaticObj()
		{
			name = "combinedstatic";
			renderFunction = RenderCombinedStaticObj;
			clipFunction = ClipFunction_NoClip;
		}
//-----------------------------------------------------------------------------------------------------		

		function AddDummyBall()
		{
			
		}

		function DoBallLine(x:Number,y:Number,dx:Number, dy:Number, ballGO:GameObj)
		{
			/*
			PhysicsBase.SetCurrentSpace(1);
			var b:Body = new Body();
			
			var body:PhysObj_Body = ballGO.physobj.bodies[0];
			
			for each(var shape:PhysObj_Shape in body.shapes)
			{
				var physMaterial:PhysObj_Material = Game.GetPhysMaterialByName(shape.materialName);
				if (shape.type == PhysObj_Shape.Type_Circle)
				{
					var circle_pos:Vec2 = new Vec2(shape.circle_pos.x * scale, shape.circle_pos.y * scale);
					var nape_circle:Circle = new Circle(shape.circle_radius, circle_pos);
					
					
					nape_circle.material = physMaterial.MakeNapeMaterial();
					var interactionFilter:InteractionFilter = new InteractionFilter(4,0,4,0,4,0);

					nape_circle.filter = interactionFilter;
					
					nape_circle.sensorEnabled = false;
					b.shapes.add(nape_circle);
				}	
			}
			
			b.type = BodyType.DYNAMIC;
			b.angularVel = 0;
			b.velocity.setxy(0, 0);
			b.position.setxy(x, y);
			b.applyImpulse(new Vec2(dx, dy));
			
			PhysicsBase.GetNapeSpace().bodies.add(b);
			
			//Game.positions = new Array();
			for (var i:int = 0; i < 120; i++)
			{
				PhysicsBase.TimeStep();
				var p:Point = new Point(b.position.x, b.position.y);
				
				//Game.position	s.push(p);
			}
			
			
			PhysicsBase.GetNapeSpace().bodies.remove(b);
			PhysicsBase.SetCurrentSpace(0);
			*/
		}
//---------------------------------------------------------------------------------------------------------
		

		var restartPos:Point;
		var rotJoint:MotorJoint;
		var stunts:Stunts;
		
		var currentTorque:Number = 0;
		var currentMaxAngVel:Number = 0;
		var loseBoostSfxTimer:int;
		
		var playerHitBombFlag:int;
		
		var doneDoubleJump:Boolean;
		var bikeDefIndex:int;
		var wheelHitFloorTimer:int
		var extraTopSpeedTimer:Number;
		var extraTopSpeedTimerMax:Number;

		var dobj_chassis:DisplayObj;

		
		public function UpdatePosMarker()
		{
			var go:GameObj = GameVars.playerGO;
			xpos = go.xpos;
			ypos = go.ypos - 80;
			frame = 0;
			frame = GameVars.playerRacePosition;
			
			if (Game.levelState == Game.levelState_Complete)
			{
				frame = GameVars.playerFinalPosition;
			}
			
			if (frame < 0) frame = 0;
			if (frame >= dobj.GetNumFrames()-1) frame = dobj.GetNumFrames() - 2;
			
			if (go.extraTopSpeedTimer > 0)
			{
				
			}
			
			if (go.upsideDownTimer > Defs.fps * 3)
			{
				frame = dobj.GetNumFrames() - 1;
			}
			
		}
		public function RenderPosMarker()
		{
			RenderDispObjNormally();
			
			var go:GameObj = GameVars.playerGO;
			if (go.extraTopSpeedTimer > 0)
			{
				var f:Number = Utils.ScaleTo(0, dobj1.GetNumFrames() - 1, 0, go.extraTopSpeedTimerMax, go.extraTopSpeedTimer);
				RenderDispObjAt(xpos, ypos + 30, dobj1, f);				
			}			
		}
		public function InitPosMarker()
		{
			dobj = GraphicObjects.GetDisplayObjByName("PosMarker");
			dobj1 = GraphicObjects.GetDisplayObjByName("turboTimeBar");
			frame = 0;
			updateFunction = UpdatePosMarker;
			renderFunction = RenderPosMarker;
		}
		
		public function RenderNapeObj()
		{
			RenderDispObjNormally(true,nape_bodies[0].localCOM);
		}
		
		var bodyHittingFloorTimer:int;
		var extraTopSpeed:Number;
		var extraAccel:Number;
		var jumpPressedTimer:int;
		
		public function InitPlayer()
		{
			if (Game.record_player == false)
			{
//				GameVars.playerBikeDefIndex = GameVars.upgradeLevels[GameVars.UPGRADE_CAR];
			}
			else
			{
				GameVars.upgradeLevels[GameVars.UPGRADE_CAR] = GameVars.playerBikeDefIndex;
				GameVars.upgradeLevels[GameVars.UPGRADE_NITRO_TANKS] = 4;
				GameVars.upgradeLevels[GameVars.UPGRADE_NITRO_POWER] = 4;
				GameVars.upgradeLevels[GameVars.UPGRADE_JUMP] = 4;
			}
			InitTestPlayerUpsideDown();
			jumpPressedTimer = 0;
			
			inwater = false;
			extraTopSpeed = 0;
			extraAccel = 0;
			bodyHittingFloorTimer = 0;
			
			GameVars.AddPlayerToList(this);
			hitMineRotForce = 0;
			hitMineTimer = 0;
			extraTopSpeedTimer = 0;
			extraTopSpeedTimerMax = 0;
			
			renderFunction = RenderNapeObj;
			
			name = "player";
			bikeDefIndex = 0;
			bikeJoints = new Array();
			bikeWheels = new Array();
			frameVel = 0;

			scale = 1;
			if (id == "")
			{
				GetUniqueId();
			}
			
			
//			rotJoint = new AngleJoint(PhysicsBase.GetNapeSpace().world, nape_bodies[0], 0, 0);
//			rotJoint.damping = 1;
//			rotJoint.frequency = 1;
			
			stunts = new Stunts();
			stunts.Reset();
			
//			angVel = 0;
			wheelHitFloorTimer = 0;
			onHitPersistFunction= OnHitPlayer;
			onHitFunction = OnHitPlayer;
			updateFunction = UpdatePlayer;
			renderFunction = RenderPlayer;
			GameVars.playerGO = this;
			
			
			InitPlayerBikeDef();
			
//			dobj_chassis = GraphicObjects.GetDisplayObjByName("car"+int(bikeDef.frameIndex)+"_chassis");
			
			playerRecording = new PlayerRecording();
			playerRecording.levelID = Levels.GetCurrent().id;
			playerRecording.bike_id = GameVars.playerBikeDefIndex;

			
			AddRecordAction(PlayerRecordAction.ACTION_NAPEOFFSET, nape_bodyOffset.x, nape_bodyOffset.y, 0);
			
			dobj = GraphicObjects.GetDisplayObjByName("car" + int(bikeDef.frameIndex) + "_body");
			frame = bikeDef.specialStunt;

//			trace("nape_bodyOffset " + nape_bodyOffset);

			GameObjects.AddObj(xpos, ypos, zpos - 100).InitPosMarker();
			
		}
		
		//--------------------------------------------------------
		
		public function OnHitPlayer(goHitter:GameObj)
		{
			if (hitIsSensor == false)
			{
				bodyHittingFloorTimer = 3;
			}
		}
		
		//--------------------------------------------------------
		
		
		function AddRecordAction( _action:int,_x:int,_y:int,_data:int)
		{
			if (Game.record_player == false) return;
			
			playerRecording.AddActionAndUseCurrentPosition(_action,_x,_y,_data);
		}
		
		function AddPlayerRecord()
		{
			if (Game.record_player == false) return;
			if (playerRecording == null) 
			{
				return;
			}
			
			var pri:PlayerRecordingItem = playerRecording.NewItem();
			pri.action = 0;
			
			gmat.identity();
			gmat.rotate(dir);
			var p:Point = new Point(nape_bodyOffset.x, nape_bodyOffset.y);
			p = gmat.transformPoint(p);
			
			
			pri.x = xpos-p.x;
			pri.y = ypos-p.y;
			pri.frame = frame;
			pri.rot = dir;
			pri.wheel0_x = bikeWheels[0].xpos;
			pri.wheel0_y = bikeWheels[0].ypos;
			pri.wheel0_rot = bikeWheels[0].dir;
			pri.wheel1_x = bikeWheels[1].xpos;
			pri.wheel1_y = bikeWheels[1].ypos;			
			pri.wheel1_rot = bikeWheels[1].dir;
		}
		//--------------------------------------------------------

		function UpdatePlayerFromPhysics_Editor(b:Body)
		{
			
		}
		

		public var tilt:Number = 1;
			
		public var inputAngVel:Number = 0;
		
		
		public function PlayerExplode()
		{
			if (state >= 100) return;
			state = 100;			
			Game.levelSuccessFlag = false;		
			
			

			Game.InitLevelState(Game.levelState_Complete);			
		}
		
		public function PlayerCrossedLine()
		{
			if (state == 200) return;
			AddRecordAction(PlayerRecordAction.ACTION_CROSSEDLINE, xpos,ypos, 0);

			GameVars.CalculateFinalPositions();
			GameVars.playerFinalTime = GameVars.raceTimer;
			state = 200;
		}
		
		function GenerateSmokeParticle()
		{
			var go:GameObj = GameObjects.AddObj(xpos, ypos, zpos - 1);
			go.InitSmokeParticle();
		}
		
		function PlayerHitByBullet()
		{
			var bullet_resistance:Number = Vars.GetVarAsNumber("bullet_resistance");
			nape_bodies[0].velocity.x *= bullet_resistance;
			nape_bodies[0].velocity.y *= bullet_resistance;

		}
		
		function PlayerHitByRock()
		{
			var rock_resistance:Number = Vars.GetVarAsNumber("rock_resistance");
			nape_bodies[0].velocity.x *= rock_resistance;
			nape_bodies[0].velocity.y *= rock_resistance;

		}
		
		var hitMineRotForce:Number;
		var hitMineTimer:int;
		function PlayerHitMine()
		{
			if (hitMineTimer > 0) return;
			hitMineTimer = 10;
			var mineforce:Number = Vars.GetVarAsNumber("mineforce");
			var mineangforceStr:String = Vars.GetVarAsString("mineangforce");
			var a:Array = mineangforceStr.split(",");
			var mineangforce:Number = Utils.RandBetweenFloat(a[0], a[1]);
			if (Utils.RandBool()) mineangforce *= -1;

			
			hitMineRotForce = mineangforce;
			
			var p:Point = new Point(0, -mineforce);
			gmat.identity();
			
			gmat.rotate(Utils.RandBetweenFloat(0,0));
			p = gmat.transformPoint(p);
			
			
			nape_bodies[0].velocity.x += p.x;
			nape_bodies[0].velocity.y += p.y;
			
			bikeWheels[0].nape_bodies[0].velocity.x += p.x;
			bikeWheels[0].nape_bodies[0].velocity.y += p.y;
			bikeWheels[1].nape_bodies[0].velocity.x += p.x;
			bikeWheels[1].nape_bodies[0].velocity.y += p.y;
			
			wheelHitFloorTimer = 0;
			
			SFX_OneShot("sfx_jump_master");
			
		}
		
		
		var inwater:Boolean = false;
		function PlayerInWater()
		{
			inwater = true;
		}
		function UpdatePlayerInWater()
		{
			if (inwater)
			{
				var water_resistance:Number = Vars.GetVarAsNumber("water_resistance");
				nape_bodies[0].velocity.x *= water_resistance;
				nape_bodies[0].velocity.y *= water_resistance;
			}
			inwater = false;
		}

		public var decelDown:Boolean = false;
		public var leftDown:Boolean = false;
		public var rightDown:Boolean = false;
		public var jumpPressed:Boolean = false;
		public var accelDown:Boolean = false;
		
		function UpdatePlayer()
		{
			if (bodyHittingFloorTimer > 0) bodyHittingFloorTimer--;
			if (jumpPressedTimer > 0) jumpPressedTimer--;

			if (GameVars.canStart == false)
			{
				return;
			}
			
			if (state == 100) 
			{
				var go:GameObj = GameObjects.AddObj(xpos + Utils.RandBetweenFloat( -50, 50), ypos + Utils.RandBetweenFloat( -50, 50), zpos - 1);
				go.InitExplosion();
				Game.StartShake(1);
//				PhysicsSetStationary();
//				bikeWheels[0].PhysicsSetStationary();
//				bikeWheels[1].PhysicsSetStationary();
				state = 101;
				
				RemovePhysObjJoints();
				
//				frame = 2;	//burned out.
				
				AddPlayerRecord();
				return;
			}
			if (state == 101)
			{
				AddPlayerRecord();
				return;
			}
			
			if (loseBoostSfxTimer > 0) loseBoostSfxTimer--;
			
			if (extraTopSpeedTimer > 0)
			{
				extraTopSpeedTimer -= 1;
			}
			if (hitMineTimer > 0)
			{
				hitMineTimer -= 1;
			}
			
			if (BikeEditor.active) 
			{
				updateFromPhysicsFunction = UpdatePlayerFromPhysics_Editor;
				SetBodyXForm_Immediate(0, xpos, ypos, 0);
				
				return;
			}
			else
			{
				updateFromPhysicsFunction = null;
			}
			
			decelDown = false;
			accelDown = false;
			leftDown = false;
			rightDown = false;
			jumpPressed = false;
			var bellPressed:Boolean = false;
			var boostPressed:Boolean = false;
			
			if (KeyReader.Down(KeyReader.KEY_UP)) accelDown = true;
			if (KeyReader.Down(KeyReader.KEY_DOWN)) decelDown = true;
			if (KeyReader.Down(KeyReader.KEY_LEFT)) leftDown = true;
			if (KeyReader.Down(KeyReader.KEY_RIGHT)) rightDown = true;
			if (KeyReader.Down(KeyReader.KEY_W)) accelDown = true;
			if (KeyReader.Down(KeyReader.KEY_S)) decelDown = true;
			if (KeyReader.Down(KeyReader.KEY_A)) leftDown = true;
			if (KeyReader.Down(KeyReader.KEY_D)) rightDown = true;
			if (KeyReader.Pressed(KeyReader.KEY_X)) jumpPressed = true;
			if (KeyReader.Pressed(KeyReader.KEY_Z)) boostPressed = true;
			if (KeyReader.Pressed(KeyReader.KEY_M)) jumpPressed = true;
			if (KeyReader.Pressed(KeyReader.KEY_N)) boostPressed = true;
		
			
			
			if (Game.usedebug == false)
			{
				if (KeyReader.Pressed(KeyReader.KEY_C)) boostPressed = true;
				if (KeyReader.Pressed(KeyReader.KEY_SPACE)) jumpPressed = true;
			}
			
			
			
			if (PROJECT::isMobile)
			{
				if (MultiTouchHandler.TestAreaPressed(GameVars.touchRect_Jump)) jumpPressed = true;
				if (MultiTouchHandler.TestAreaDown(GameVars.touchRect_Accel)) accelDown = true;
				if (MultiTouchHandler.TestAreaDown(GameVars.touchRect_Nitro)) boostPressed = true;
				//if (MultiTouchHandler.TestAreaDown(GameVars.touchRect_Left)) leftDown = true;
				//if (MultiTouchHandler.TestAreaDown(GameVars.touchRect_Right)) rightDown = true;
			}			
			
			tilt = 0;
			if (Game.usingTilt)
			{
				tilt = -MobileSpecific.accelX;
			}
			
			
			if (PROJECT::isGamePad)
			{
				if (MobileSpecific.pad_isSupported)
				{
					jumpPressed = false;
					accelDown = false;
					boostPressed = false;
					leftDown = false;
					rightDown = false;
					decelDown = false;
					
					var controlX:GameInputControl = MobileSpecific.pad0.getControlAt(OuyaPad.ANALOG0_X);
					
					tilt = controlX.value;
					
					var controlJump:GameInputControl = MobileSpecific.pad0.getControlAt(OuyaPad.O);
					if (controlJump.value > 0.5) jumpPressed = true;
					var controlAccel:GameInputControl = MobileSpecific.pad0.getControlAt(OuyaPad.ANALOGTRIGGER1_PRESSED);
					if (controlAccel.value > 0.5) accelDown = true;
					var controlBoost:GameInputControl = MobileSpecific.pad0.getControlAt(OuyaPad.U);
					if (controlBoost.value > 0.5) boostPressed = true;
					var controlBrake:GameInputControl = MobileSpecific.pad0.getControlAt(OuyaPad.ANALOGTRIGGER0_PRESSED);
					if (controlBrake.value > 0.5) decelDown = true;
				}
			}
			
			
			
			if (state == 200)
			{
				accelDown = false;
				decelDown = true;
				leftDown = false;
				rightDown = false;
				boostPressed = false;
			}
			
			if (boostPressed)
			{
				if (extraTopSpeedTimer == 0)
				{
					if (GameVars.CanUseBoost())
					{
						var boostLevel:int = GameVars.UseBoost();
						PlayerDoSpeedBoost(boostLevel + 1);
						Audio.OneShot("sfx_turboboost");

					}
				}
			}
			

			
			var l:Level = Levels.GetCurrent();
			
			var b:Body = nape_bodies[0];
			b.velocity.y += 0.000001;
		
			UpdatePlayerInWater();
			
			var cd:CharDef = BikeDefs.GetCharByIndex(GameVars.playerCharIndex);
			
			
			var cycloTest_maxyvel:Number = Vars.GetVarAsNumber("cycloTest_maxyvel");
			
//			var cycloTest_jumpVel_a:Number = Vars.GetVarAsNumber("cycloTest_jumpVel_a");
//			var cycloTest_jumpVel_b:Number = Vars.GetVarAsNumber("cycloTest_jumpVel_b");
//			var cycloTest_jumpVel:Number = Utils.ScaleTo(cycloTest_jumpVel_a, cycloTest_jumpVel_b, 0, 100, cd.GetSkillValue(Skills.SKILL_JUMP));

			var grandtruckismo_jumpvel_a:Number = Vars.GetVarAsNumber("grandtruckismo_jumpvel_a");
			var grandtruckismo_jumpvel_b:Number = Vars.GetVarAsNumber("grandtruckismo_jumpvel_b");
			var cycloTest_jumpVel:Number = Utils.ScaleTo(grandtruckismo_jumpvel_a, grandtruckismo_jumpvel_b, 0, 8, GameVars.GetUpgrade(GameVars.UPGRADE_JUMP));
			
			
//			var cycloTest_accel_a:Number = Vars.GetVarAsNumber("cycloTest_accel_a");
//			var cycloTest_accel_b:Number = Vars.GetVarAsNumber("cycloTest_accel_b");
//			var cycloTest_accel:Number = Utils.ScaleTo(cycloTest_accel_a, cycloTest_accel_b, 0, 100, cd.GetSkillValue(Skills.SKILL_ACCEL));

			
			var cycloTest_brake_a:Number = Vars.GetVarAsNumber("cycloTest_brake_a");
			var cycloTest_brake_b:Number = Vars.GetVarAsNumber("cycloTest_brake_b");
			var cycloTest_brake:Number = Utils.ScaleTo(cycloTest_brake_a, cycloTest_brake_b, 0, 100, cd.GetSkillValue(Skills.SKILL_BRAKES));
			
//			var cycloTest_maxvel_a:Number = Vars.GetVarAsNumber("cycloTest_maxvel_a");
//			var cycloTest_maxvel_b:Number = Vars.GetVarAsNumber("cycloTest_maxvel_b");
//			var cycloTest_maxvel:Number = Utils.ScaleTo(cycloTest_maxvel_a, cycloTest_maxvel_b, 0, 100, cd.GetSkillValue(Skills.SKILL_TOPSPEED));

			var cycloTest_maxvel_a:Number = Vars.GetVarAsNumber("grandtruckismo_maxvel_a");
			var cycloTest_maxvel_b:Number = Vars.GetVarAsNumber("grandtruckismo_maxvel_b");
			var cycloTest_maxvel:Number = Utils.ScaleTo(cycloTest_maxvel_a, cycloTest_maxvel_b, 0, 15, GameVars.GetUpgrade(GameVars.UPGRADE_CAR));

			var cycloTest_accel_a:Number = Vars.GetVarAsNumber("grandtruckismo_accel_a");
			var cycloTest_accel_b:Number = Vars.GetVarAsNumber("grandtruckismo_accel_b");
			var cycloTest_accel:Number = Utils.ScaleTo(cycloTest_accel_a, cycloTest_accel_b, 0, 15, GameVars.GetUpgrade(GameVars.UPGRADE_CAR));
			
//			var cycloTest_accel:Number = bikeDef.accel;
//			var cycloTest_maxvel:Number = bikeDef.maxVel;
			
			
//			var cycloTest_maxangvel_a:Number = Vars.GetVarAsNumber("cycloTest_maxangvel_a");
//			var cycloTest_maxangvel_b:Number = Vars.GetVarAsNumber("cycloTest_maxangvel_b");
//			var cycloTest_maxangvel:Number = Utils.ScaleTo(cycloTest_maxangvel_a, cycloTest_maxangvel_b, 0, 100, cd.GetSkillValue(Skills.SKILL_SPIN));

//			var cycloTest_maxangvel_air_a:Number = Vars.GetVarAsNumber("cycloTest_maxangvel_air_a");
//			var cycloTest_maxangvel_air_b:Number = Vars.GetVarAsNumber("cycloTest_maxangvel_air_b");
//			var cycloTest_maxangvel_air:Number = Utils.ScaleTo(cycloTest_maxangvel_air_a, cycloTest_maxangvel_air_b, 0, 100, cd.GetSkillValue(Skills.SKILL_SPIN));
			
			var cycloTest_torque_a:Number = Vars.GetVarAsNumber("cycloTest_torque_a");
			var cycloTest_torque_b:Number = Vars.GetVarAsNumber("cycloTest_torque_b");
			var cycloTest_torque:Number = Utils.ScaleTo(cycloTest_torque_a, cycloTest_torque_b, 0, 100, cd.GetSkillValue(Skills.SKILL_SPIN));
			
			var cycloTest_torque_air_a:Number = Vars.GetVarAsNumber("cycloTest_torque_air_a");
			var cycloTest_torque_air_b:Number = Vars.GetVarAsNumber("cycloTest_torque_air_b");
			var cycloTest_torque_air:Number = Utils.ScaleTo(cycloTest_torque_air_a, cycloTest_torque_air_b, 0, 100, cd.GetSkillValue(Skills.SKILL_SPIN));

			var boost_stat_multiplier_a:Number = Vars.GetVarAsNumber("boost_stat_multiplier_a");
			var boost_stat_multiplier_b:Number = Vars.GetVarAsNumber("boost_stat_multiplier_b");
			var boost_stat_multiplier:Number = Utils.ScaleTo(boost_stat_multiplier_a, boost_stat_multiplier_b, 0, 100, cd.GetSkillValue(Skills.SKILL_NITRO_VEL));
			
			var boostMinAccAdd:Number = Vars.GetVarAsNumber("boostMinAccAdd") * boost_stat_multiplier;
			var boostMaxAccAdd:Number = Vars.GetVarAsNumber("boostMaxAccAdd") * boost_stat_multiplier;
			var boostMinVelAdd:Number = Vars.GetVarAsNumber("boostMinVelAdd") * boost_stat_multiplier;
			var boostMaxVelAdd:Number = Vars.GetVarAsNumber("boostMaxVelAdd") * boost_stat_multiplier;
			var boostMaxMultiplier:int = Vars.GetVarAsInt("boostMaxMultiplier");
			
			var player_pedal_acc:Number = Vars.GetVarAsNumber("player_pedal_acc");
			var player_pedal_maxvel:Number = Vars.GetVarAsNumber("player_pedal_maxvel");
			var player_pedal_decel_acc:Number = Vars.GetVarAsNumber("player_pedal_decel_acc");
			
			cycloTest_jumpVel *= scale;
			cycloTest_accel *= scale;
			cycloTest_brake *= scale;
			cycloTest_torque *= scale;
			cycloTest_torque_air *= scale;
			
			var boostAccAdd:Number = 0;
			var boostVelAdd:Number = 0;
			cycloTest_brake += boostAccAdd;
			cycloTest_accel += boostAccAdd;
			cycloTest_maxvel += boostVelAdd;
			
			var toExtraTopSpeed:Number;
			var toExtraAccel:Number
			
			if (extraTopSpeedTimer != 0)
			{
				var grandtruckismo_nitrospeed_a:Number = Vars.GetVarAsNumber("grandtruckismo_nitrospeed_a");
				var grandtruckismo_nitrospeed_b:Number = Vars.GetVarAsNumber("grandtruckismo_nitrospeed_b");
				toExtraTopSpeed = Utils.ScaleTo(grandtruckismo_nitrospeed_a, grandtruckismo_nitrospeed_b, 0, 8, GameVars.GetUpgrade(GameVars.UPGRADE_NITRO_POWER));

				var grandtruckismo_nitroaccel_a:Number = Vars.GetVarAsNumber("grandtruckismo_nitroaccel_a");
				var grandtruckismo_nitroaccel_a:Number = Vars.GetVarAsNumber("grandtruckismo_nitroaccel_a");
				toExtraAccel = Utils.ScaleTo(grandtruckismo_nitroaccel_a, grandtruckismo_nitroaccel_a, 0, 8, GameVars.GetUpgrade(GameVars.UPGRADE_NITRO_POWER));
				
				//trace("maxvel " + cycloTest_maxvel + "  " + extraTopSpeed+"   ::   "+cycloTest_accel+"  "+extraAccel);
				
			}
			else
			{
				toExtraTopSpeed = 0;
				toExtraAccel = 0;
			}
			
			var extratopspeed_tovel:Number = Vars.GetVarAsNumber("extratopspeed_tovel");
			var extraaccel_tovel:Number = Vars.GetVarAsNumber("extraaccel_tovel");
			
			extraTopSpeed = Utils.MoveNumberAtoB(extraTopSpeed, toExtraTopSpeed, extratopspeed_tovel);
			extraAccel = Utils.MoveNumberAtoB(extraAccel, toExtraAccel, extraaccel_tovel);
			
//			trace(extraTopSpeed + " " + toExtraTopSpeed + " " + extratopspeed_tovel);
//			trace(extraAccel + " " + toExtraAccel + " " + extraaccel_tovel);
			
			
			cycloTest_maxvel += extraTopSpeed;
			cycloTest_accel += extraAccel;			
			
			var maxInputTorque:Number = bikeDef.maxInputTorqueVel;
			var inputTorqueAccel:Number = bikeDef.inputTorqueAccel;

			
/*			if (PROJECT::isMobile)
			{
				if (MultiTouchHandler.TestAreaDown(GameVars.touchRect_Z))
				{
					cycloTest_brake *= 10;
					cycloTest_accel *= 10;
					cycloTest_maxvel *= 10;					
				}
			}
			*/
			

			
			movementVec.Set(dir, cycloTest_accel);
			movementVec1.Set(dir, cycloTest_brake);
			
			
			if (wheelHitFloorTimer == GameVars.wheelHitFloorTimerMax)
			{
				if (accelDown)
				{
					ApplyForce(movementVec.X(), movementVec.Y());
				}
				if (decelDown)
				{
					ApplyForce(-movementVec.X(), -movementVec.Y());
				}
			}
			else
			{
			}
			
			if ( (wheelHitFloorTimer > 0) || (bodyHittingFloorTimer>0 ) )
			{
				if (jumpPressed)
				{
					if (jumpPressedTimer == 0)	//GameVars.numJumpsLeft > 0)
					{
						
						Stats.Add("Total Jumps", 1);
						
						//GameVars.numJumpsLeft--;
						
//						var go:GameObj = GameObjects.AddObj(xpos, ypos+50, zpos - 1);
//						go.InitExplosion();
						
						doneDoubleJump = false;
						var p:Point = new Point(0, -cycloTest_jumpVel);
						
						trace("cycloTest_jumpVel " + cycloTest_jumpVel);
						
						gmat.identity();
						
						//gmat.rotate(dir+Utils.DegToRad(Vars.GetVarAsNumber("cycloTest_jump_angle")));
						gmat.rotate(Utils.DegToRad(Vars.GetVarAsNumber("cycloTest_jump_angle")));
						p = gmat.transformPoint(p);
						
						nape_bodies[0].velocity.x += p.x;
						nape_bodies[0].velocity.y += p.y;
						
						if (bikeWheels.length == 2)
						{
							bikeWheels[0].nape_bodies[0].velocity.x += p.x;
							bikeWheels[0].nape_bodies[0].velocity.y += p.y;
							bikeWheels[1].nape_bodies[0].velocity.x += p.x;
							bikeWheels[1].nape_bodies[0].velocity.y += p.y;
						}
						
						
						//nape_bodies[0].applyImpulse(new Vec2(p.x, p.y));
						//bikeWheels[0].nape_bodies[0].applyImpulse(new Vec2(p.x, p.y));
						//bikeWheels[1].nape_bodies[0].applyImpulse(new Vec2(p.x, p.y));
						
						wheelHitFloorTimer = 0;
						
						
						SFX_OneShot("sfx_jump");
						AddRecordAction(PlayerRecordAction.ACTION_JUMP, 0, 0, 0);
						jumpPressedTimer = 10;
					}
				}
				else
				{
					
				}
			}
			else	// jumping
			{
				var linear_damping:Number =  Vars.GetVarAsNumber("linear_damping");				
				b.velocity.x *= linear_damping;				
			}

			LimitXVelocity_Nape(cycloTest_maxvel);
			
			if (wheelHitFloorTimer > 0) wheelHitFloorTimer--;
			
			
			currentMaxAngVel = bikeDef.maxRotVel;
			var maxInputTorque:Number = bikeDef.maxInputTorqueVel;
			var inputTorqueAccel:Number = bikeDef.inputTorqueAccel;
			
			
			if (Game.usingTilt)
			{
				GameVars.tilt = tilt;
				var istilting:Boolean = false;
				
				var minT:Number = 0.1;
				var maxT:Number = 0.5;
				var minApply:Number = 0.5;
				
				if (tilt >minT)
				{
					tilt = Utils.ScaleToPreLimit(minApply,1,minT,maxT, tilt);					
					istilting = true;
				}
				else if (tilt < -minT)
				{
					istilting = true;
					tilt = -tilt;
					tilt = Utils.ScaleToPreLimit(minApply,1,minT,maxT, tilt);					
					tilt = -tilt;
				}
				else
				{
					tilt = 0;
				}
				GameVars.tilt1 = tilt;
				
				if (istilting)
				{
					inputTorqueAccel = Utils.ScaleTo( -inputTorqueAccel, inputTorqueAccel, -1, 1, tilt);
					currentTorque += inputTorqueAccel;
					if (currentTorque <= - maxInputTorque) currentTorque = -maxInputTorque; 
					if (currentTorque >= maxInputTorque) currentTorque = maxInputTorque ;
				}
				else
				{
					if (currentTorque < 0)
					{
						currentTorque += inputTorqueAccel;
						if (currentTorque >  0) currentTorque = 0;
					}
					else if (currentTorque > 0)
					{
						currentTorque -= inputTorqueAccel;
						if (currentTorque <  0) currentTorque = 0;
					}					
				}
			}
			else
			{
			
				if (leftDown)
				{
					currentTorque -= inputTorqueAccel;
					if (currentTorque <=- maxInputTorque) currentTorque = -maxInputTorque 
				}
				else if (rightDown)
				{
					currentTorque += inputTorqueAccel;
					if (currentTorque >= maxInputTorque) currentTorque = maxInputTorque 
				}
				else
				{
					if (currentTorque < 0)
					{
						currentTorque += inputTorqueAccel;
						if (currentTorque >  0) currentTorque = 0;
					}
					else if (currentTorque > 0)
					{
						currentTorque -= inputTorqueAccel;
						if (currentTorque <  0) currentTorque = 0;
					}
				}
			}
			
			
			b.applyAngularImpulse( currentTorque);
			
			if(true)
			{
				var amt:Number =  Vars.GetVarAsNumber("angvel_slowdown");
				
				b.angularVel *= amt;
				
				/*
				if (b.angularVel > 0)
				{
					b.angularVel -= amt;
					if (b.angularVel < 0) b.angularVel = 0;
				}
				else if (b.angularVel < 0)
				{
					b.angularVel += amt;
					if (b.angularVel > 0) b.angularVel = 0;
				}
				*/
			}
			
			//trace(b.angularVel);

			if (b.angularVel >= currentMaxAngVel) 
			{
				b.angularVel = currentMaxAngVel;
			}
			if ( b.angularVel <= -currentMaxAngVel)  
			{
				b.angularVel = -currentMaxAngVel;
			}
			
			if (hitMineRotForce != 0)
			{
				b.angularVel += hitMineRotForce;
				hitMineRotForce = 0;
			}

//			trace("angvel " + b.angularVel + " / " + currentMaxAngVel+"    torq: "+currentTorque);
			
//--------------			
			
			
			stunts.Update(this);
			stunts.UpdateWheels(this);
			stunts.UpdateCombos(this);
			
			
			
			if (stunts.addRotationTimer > 0)
			{
				stunts.addRotationTimer--;
			}
			
				
			
//			GameVars.goMarker.xpos = xpos;
//			GameVars.goMarker.ypos = ypos;
//			GameVars.goMarker.visible = true;

			
			AddPlayerRecord();
			
			GenerateTurboParticles();
			
			TestPlayerUpsideDown();
			
//			var windSound:Number = Utils.ScaleToPreLimit(0.0,0.3, 0, cycloTest_maxvel, nape_bodies[0].velocity.x);			
//			Audio.SetSoundVolume(GameVars.windSoundName, windSound);
		}
		
		var upsideDownTimer:int;
		function InitTestPlayerUpsideDown()
		{
			upsideDownTimer = 0;
		}
		function TestPlayerUpsideDown()
		{
			if (bodyHittingFloorTimer == 0)
			{
				upsideDownTimer = 0;
				return;
			}
			var d:Number = Utils.NormalizeRot(dir);
			var dd:Number = Utils.RadToDeg(d);
			
			if (dd > 140 && dd < 220)
			{
				upsideDownTimer++;
			}
			else
			{
				upsideDownTimer = 0;
			}
		}
		
		
		function GenerateTurboParticles()
		{
			
			if (extraTopSpeedTimer == 0) return;
			
			Stats.Add("Total Nitro Time", 1);

			
			var p:Point = GameVars.GetNitroPos(GameVars.playerBikeDefIndex);
			
			
			gpoint.x = p.x - nape_bodyOffset.x;
			gpoint.y = p.y - nape_bodyOffset.y;
			gmat.identity();
			gmat.rotate(dir);
			
			gpoint = gmat.transformPoint(gpoint);
			
			Particles.Add(xpos + gpoint.x, ypos + gpoint.y).InitTurboFlame();
		}
		
//-----------------------------------------------------------------------------

		function RenderPlayer()
		{
			bikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			
			
			if (BikeEditor.active)
			{
				dobj = GraphicObjects.GetDisplayObjByName("car" + int(bikeDef.frameIndex)+"_body");
				
				var xp:Number =  Math.round(xpos) - Math.round(Game.camera.x);
				var yp:Number =  Math.round(ypos) - Math.round(Game.camera.y);
				dir = 0;
				
				
				var xp1:Number =  xp + bikeDef.wheel0_x;
				var yp1:Number =  yp + bikeDef.wheel0_y;
				var xp2:Number =  xp + bikeDef.wheel1_x;
				var yp2:Number =  yp + bikeDef.wheel1_y;
				
				var s0:Number = bikeDef.wheel0_scale;
				var s1:Number = bikeDef.wheel1_scale;
				

				var dob:DisplayObj = GraphicObjects.GetDisplayObjByName("car"+int(bikeDef.wheel0_index)+"_wheel");
				
				
				if (bikeDef.wheel0_depth == 0)	dob.RenderAtRotScaled(0, bd, xp1, yp1,s0);
				if (bikeDef.wheel1_depth == 0)	dob.RenderAtRotScaled(0, bd, xp2, yp2,s1);

				
				dobj.RenderAtRotScaled(0,bd, xp, yp, scale, dir);			

				if (bikeDef.wheel0_depth == 1)	dob.RenderAtRotScaled(0, bd, xp1, yp1,s0);
				if (bikeDef.wheel1_depth == 1)	dob.RenderAtRotScaled(0, bd, xp2, yp2,s1);
				
				
				
				
				var g:Graphics = Game.fillScreenMC.graphics;
				g.clear();
				
				gmat.identity();
				gmat.rotate(Utils.DegToRad(bikeDef.susp0_ang));
				var p:Point = new Point(0, -bikeDef.susp0_len);
				p = gmat.transformPoint(p);
				
				g.lineStyle(3, 0xff0000, 1);
				g.moveTo(xp1,yp1);
				g.lineTo(xp1+p.x,yp1+p.y);

				gmat.identity();
				gmat.rotate(Utils.DegToRad(-bikeDef.susp1_ang));
				var p:Point = new Point(0, -bikeDef.susp1_len);
				p = gmat.transformPoint(p);
				
				g.lineStyle(3, 0xff0000, 1);
				g.moveTo(xp2,yp2);
				g.lineTo(xp2+p.x,yp2+p.y);
				
				bd.draw(Game.fillScreenMC);
				
				return;
			}
			
			
			
			
			gpoint.x = 0;
			gpoint.y = 20;
			
			gpoint = Utils.RotatePoint(gpoint, dir);

			
//			gmat.identity();
//			gmat.rotate(dir);
//			gpoint = gmat.transformPoint(gpoint);
			
			gpoint.x -= Game.camera.x;
			gpoint.y -= Game.camera.y;
			gpoint.x += xpos;
			gpoint.y += ypos;
			
			if (bikeWheels.length == 2)
			{
			
			if (PROJECT::useStage3D == false)
			{			
				var g:Graphics = Game.fillScreenMC.graphics;
				g.clear();
				
				g.lineStyle(5, 0x303030, 1);
				g.moveTo(gpoint.x, gpoint.y);
				g.lineTo(bikeWheels[0].xpos - Game.camera.x, bikeWheels[0].ypos - Game.camera.y);
				
				g.moveTo(gpoint.x, gpoint.y);
				g.lineTo(bikeWheels[1].xpos - Game.camera.x, bikeWheels[1].ypos - Game.camera.y);
				
				bd.draw(Game.fillScreenMC);
			}
			
			
//			RenderDispObjAt_WithOffset(xpos, ypos, dobj_chassis, 0, null, dir, scale, true,false,nape_bodyOffset);
			
			bikeWheels[0].bd = bd;
			bikeWheels[1].bd = bd;

			if (bikeDef.wheel0_depth == 0)	bikeWheels[0].RenderPlayerWheel();
			if (bikeDef.wheel1_depth == 0)	bikeWheels[1].RenderPlayerWheel();
			}

			RenderDispObjNormally(true,nape_bodyOffset);
			//RenderDispObjNormally();

			
			if (bikeWheels.length == 2)
			{
				if (bikeDef.wheel0_depth == 1)	bikeWheels[0].RenderPlayerWheel();
				if (bikeDef.wheel1_depth == 1)	bikeWheels[1].RenderPlayerWheel();
			}
			
			

			
			
		}
//-------------------------------

		public var playerRecording:PlayerRecording;

		var bikeJoints:Array;
		var bikeWheels:Array;
		var bikeDef:BikeDef;
		function ExitPlayerBikeDef()
		{
			RemovePhysObjJoints();
		} 
		function InitPlayerBikeDef(noWheelCollision:Boolean= false)
		{
			
			ExitPlayerBikeDef();
			
			bikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			
			
//			RemovePhysObjJoints();
			if (bikeWheels.length != 0)
			{
				for each(var go:GameObj in bikeWheels)
				{
					go.RemoveObject(go.RemovePhysObj);
				}
			}
			bikeWheels = new Array();
			
			var w0:int = bikeDef.wheel0_index;
			var w1:int = bikeDef.wheel0_index;	// both use rear wheel
			
			var go:GameObj;
			var go1:GameObj;
			
			var s0:Number = bikeDef.wheel0_scale*  scale;
			var s1:Number = bikeDef.wheel1_scale * scale;
			
			var wheel0_x:Number = bikeDef.wheel0_x * scale;
			var wheel0_y:Number = bikeDef.wheel0_y * scale;
			var wheel1_x:Number = bikeDef.wheel1_x * scale;
			var wheel1_y:Number = bikeDef.wheel1_y * scale;
			
			var nx:Number = -nape_bodyOffset.x;
			var ny:Number = -nape_bodyOffset.y;
			
			xpos += nx;
			ypos += ny;
			
			go = PhysicsBase.AddPhysObjAt("bikeWheel_"+w0, xpos+wheel0_x, ypos+wheel0_y, 0,s0);
			go1 = PhysicsBase.AddPhysObjAt("bikeWheel_" + w1, xpos + wheel1_x, ypos + wheel1_y, 0, s1);
			go.wheelIndex = 0;
			go1.wheelIndex = 1;
			
			
			
//			go.zpos = GameVars.depth_player_wheel0;
//			if(bikeDef.wheel0_depth != 0) go.zpos = GameVars.depth_player_wheel1;
//			go1.zpos = GameVars.depth_player_wheel0;
//			if(bikeDef.wheel1_depth != 0) go1.zpos = GameVars.depth_player_wheel1;
			
			if (noWheelCollision)
			{
//				go.SetBodyCollisionMask( -1, 0);
//				go1.SetBodyCollisionMask( -1, 0);
			}
			
			
			go.id = PhysEditor.CreateNewUniqueID();
			go1.id = PhysEditor.CreateNewUniqueID();
			
			var j:EdJoint;
			
			j = new EdJoint();
			j.type =  EdJoint.Type_Line;
			j.line_pos0 = new Point(xpos + wheel0_x, ypos + wheel0_y);
			j.line_pos1 = new Point(go.xpos,go.ypos);
			j.obj0Name = id;
			j.obj1Name = go.id;
			j.line_min = 0;
			j.line_max = 10;
			j.line_angDegrees = 180 + bikeDef.susp0_ang;
			PhysicsBase.AddJoint_Nape(j);

			j = new EdJoint();
			j.type =  EdJoint.Type_Line;
			j.line_pos0 = new Point(xpos + wheel1_x, ypos + wheel1_y);
			j.line_pos1 = new Point(go1.xpos,go1.ypos);
			j.obj0Name = id;
			j.obj1Name = go1.id;
			j.line_min = 0;
			j.line_max = 10;
			j.line_angDegrees = 180-bikeDef.susp1_ang;
			PhysicsBase.AddJoint_Nape(j);

			j = new EdJoint();
			j.objParameters.CreateAllFromString("dist_limit=10,dist_soft=true,dist_soft_frequency="+bikeDef.susp0_freq);
			j.type =  EdJoint.Type_Distance;
			j.dist_pos0 = new Point(xpos + wheel0_x, ypos + wheel0_y-30);
			j.dist_pos1 = new Point(go.xpos,go.ypos);
			j.dist_min = 30;
			j.dist_max = 30;
			j.obj0Name = id;
			j.obj1Name = go.id;
			PhysicsBase.AddJoint_Nape(j);
			
			j = new EdJoint();
			j.objParameters.CreateAllFromString("dist_limit=10,dist_soft=true,dist_soft_frequency="+bikeDef.susp1_freq);
			j.type =  EdJoint.Type_Distance;
			j.dist_pos0 = new Point(xpos + wheel1_x, ypos + wheel1_y-30);
			j.dist_pos1 = new Point(go1.xpos,go1.ypos);
			j.dist_min = 30;
			j.dist_max = 30;
			j.obj0Name = id;
			j.obj1Name = go1.id;
			PhysicsBase.AddJoint_Nape(j);

	
//			wheel0WeldConstraint = new MotorJoint(nape_bodies[0], go.nape_bodies[0], 0, 1);
//			wheel1WeldConstraint = new MotorJoint(nape_bodies[0], go1.nape_bodies[0], 0, 1);
//			PhysicsBase.GetNapeSpace().constraints.add(wheel0WeldConstraint);
//			PhysicsBase.GetNapeSpace().constraints.add(wheel1WeldConstraint);
			

			
			var limit:Number = Utils.RandBetweenFloat(0,2);
			
			var aoffset:Point = GameVars.GetAerialPos(GameVars.playerBikeDefIndex);
			
			var ax:Number = xpos + aoffset.x;
			var ay:Number = ypos + aoffset.y;
			var ago0:GameObj = this;
			// add aerial
			for (var i:int = 0; i < 3; i++)
			{
				var ago1:GameObj = PhysicsBase.AddPhysObjAt("aerial_piece", ax, ay, 0, 1);
				ago1.id = PhysEditor.CreateNewUniqueID();
				
				ago1.frame = 0;
				if (i == 2)
				{
					ago1.frame = Utils.RandBetweenInt(1, 3);
				}
				
				
				
				j = new EdJoint();
				j.objParameters.CreateAllFromString("collide_joined=false,rev_enablelimit=true,rev_lowerangle=-" + limit + ",rev_upperangle=" + limit);
				
				j.type =  EdJoint.Type_Rev;
				j.rev_pos.x = ax;
				j.rev_pos.y = ay+9;
				
				j.obj0Name = ago0.id;
				j.obj1Name = ago1.id;
				
				PhysicsBase.AddJoint_Nape(j);
				
				ago0 = ago1;
				
				ay -= 18;
			}
			
			
			xpos -= nx;
			ypos -= ny;
			
			
			
		}

		
		function InitAIBikeDef(bikeID:int)
		{
			bikeDef = BikeDefs.GetByIndex(bikeID);
			
			
			
			bikeWheels = new Array();
			
			var w0:int = bikeDef.wheel0_index;
			var w1:int = bikeDef.wheel0_index;	// both use rear wheel
			
			var go:GameObj;
			var go1:GameObj;
			
			var s0:Number = bikeDef.wheel0_scale*  scale;
			var s1:Number = bikeDef.wheel1_scale * scale;
			
			var wheel0_x:Number = bikeDef.wheel0_x * scale;
			var wheel0_y:Number = bikeDef.wheel0_y * scale;
			var wheel1_x:Number = bikeDef.wheel1_x * scale;
			var wheel1_y:Number = bikeDef.wheel1_y * scale;
			
			nape_bodyOffset = new Vec2(0, 0);
			
			var nx:Number = -nape_bodyOffset.x;
			var ny:Number = -nape_bodyOffset.y;
			
			xpos += nx;
			ypos += ny;
			
			w0 = 1;
			w1 = 1;
			
			go = PhysicsBase.AddPhysObjAt("bikeWheelAI_" + w0, xpos + wheel0_x, ypos + wheel0_y, 0, s0);
			go.InitAIPlayerWheel(this);
			go1 = PhysicsBase.AddPhysObjAt("bikeWheelAI_" + w1, xpos + wheel1_x, ypos + wheel1_y, 0, s1);
			go1.InitAIPlayerWheel(this);
			go.wheelIndex = 0;
			go1.wheelIndex = 1;
			
			go.id = PhysEditor.CreateNewUniqueID();
			go1.id = PhysEditor.CreateNewUniqueID();
			
			nape_bodies[0].disableCCD = true;
			bikeWheels[0].nape_bodies[0].disableCCD = true;
			bikeWheels[1].nape_bodies[0].disableCCD = true;
			
		}
		
		var wheel0WeldConstraint:MotorJoint;
		var wheel1WeldConstraint:MotorJoint;
		
		
		function OnHitPlayerWheelPersist(goHitter:GameObj)
		{
			if (GameVars.playerGO.state >= 100) return;
			if (hitContactPoint_Nape != null)
			{
				if (GameVars.playerGO.decelDown)
				{
					var amt:Number = Utils.ScaleToPreLimit(0, 1, 0, 500, parentObj.GetBodyLinearVelocity(0).length);
					WheelOnSurface_DoSkidParticle(goHitter, hitContactPoint_Nape.position.x, hitContactPoint_Nape.position.y, amt);				
				}
				else
				{
					var amt:Number = Utils.ScaleToPreLimit(0, 1, 0, 500, parentObj.GetBodyLinearVelocity(0).length);
					WheelOnSurface_DoDriveParticle(goHitter, hitContactPoint_Nape.position.x, hitContactPoint_Nape.position.y, amt);					
				}
			}
			
			
			if (goHitter.collisionType == "water")
			{
				WheelInWater(goHitter);
				return;
			}
			
			if (hitIsSensor == false)
			{
				parentObj.wheelHitFloorTimer = GameVars.wheelHitFloorTimerMax;
				if (wheelIndex == 0)
				{
					parentObj.stunts.RearWheelDown(false);
				}
				else
				{
					parentObj.stunts.FrontWheelDown(false);
				}
				/*
				if (wheelIndex == 0) // back only
				{
					if (goHitter.collisionType == "mud")
					{
						var amt:Number = Utils.ScaleTo(0, 1, 0, 1.2, parentObj.frameVel);
						WheelInMud(hitContactPoint_Nape.position.x,hitContactPoint_Nape.position.y,amt);
					}
					if (goHitter.collisionType == "sand")
					{
						var amt:Number = Utils.ScaleTo(0, 1, 0, 1.2, parentObj.frameVel);
						WheelInSand(hitContactPoint_Nape.position.x,hitContactPoint_Nape.position.y,amt);
					}
				}
				*/
			}
			
			
		}
		function OnHitAIPlayerWheel(goHitter:GameObj)
		{
			
		}
		function OnHitPlayerWheel(goHitter:GameObj)
		{
			if (goHitter.collisionType == "death")
			{
			}
			
			
			if (hitContactPoint_Nape != null)
			{
//				trace("land vel "+ parentObj.GetBodyLinearVelocity(0).y);

				var yvel:Number = parentObj.GetBodyLinearVelocity(0).y;
				var miny:Number = 100;
				var maxy:Number = 300;
				if (yvel > 100)
				{
					var amt:Number = Utils.ScaleToPreLimit(0, 1, miny, maxy, parentObj.GetBodyLinearVelocity(0).y);
					WheelOnSurface_DoLandParticle(goHitter, hitContactPoint_Nape.position.x, hitContactPoint_Nape.position.y, amt);				
					
					var a:Array = ["sfx_land1", "sfx_land2", "sfx_land3"];
					Audio.OneShot_Random(a,0,Utils.ScaleTo(0,0.5,0,1,amt));

				}
				
				var shakeMinY:Number = 500;
				var shakeMaxY:Number = 1000;
				if (yvel >= shakeMinY)
				{
					if (Game.shakeTimer == 0)
					{
						var shake:Number = Utils.ScaleToPreLimit(0.1, 0.5, shakeMinY, shakeMaxY, yvel);
						Game.StartShake(shake);
					}
				}
			}
			
			if (hitIsSensor == false)
			{
				parentObj.wheelHitFloorTimer = GameVars.wheelHitFloorTimerMax;
				if (wheelIndex == 0)
				{
					parentObj.stunts.RearWheelDown(true);
				}
				else
				{
					parentObj.stunts.FrontWheelDown(true);
				}
			}
		}
		
		var wheelIndex:int;
		function Wheel_SeparateFromBike()
		{
			onHitFunction = null;
			onHitPersistFunction = null;
			RemovePhysObjJoints();
			state = 1;
			timer = Defs.fps * 10;
			SetBodyCollisionMask(0, 0);
		}
		function UpdatePlayerWheel()
		{
			if (state == 0)
			{
				
			}
			else if (state == 1)
			{
				timer--;
				if (timer <= 0)
				{
					RemoveObject(RemovePhysObj);
				}
			}
		}
		function RenderPlayerWheel()
		{
			if (BikeEditor.active) return;
			if (dobj == null) return;
			var sc:Number = scale;
			
			
			RenderDispObjNormally();
			scale = sc;
			
			
		}
		function InitAIPlayerWheel(_parent:GameObj)
		{
			name = "ai_wheel";
			name = "player_wheel";
			parentObj = _parent;
			wheelIndex = 0;
			onHitFunction = OnHitAIPlayerWheel;
			parentObj.bikeWheels.push(this);
			updateFromPhysicsFunction = UpdatePhysicsNull;
		}
		function InitPlayerWheel()
		{
			name = "player_wheel";
			parentObj = GameVars.playerGO;
			wheelIndex = 0;
//			renderFunction = RenderPlayerWheel;
			onHitFunction = OnHitPlayerWheel;
			onHitPersistFunction = OnHitPlayerWheelPersist;
			updateFunction = UpdatePlayerWheel;
			parentObj.bikeWheels.push(this);
			state = 0;
			visible = false;
			
			if (PROJECT::useStage3D == false)
			{
//				dobj = LevelDobjCache.Add("car1_wheel", GraphicObjects.mod_default, scale, null);
//				scale = 1;

			}
			
			dobj = GraphicObjects.GetDisplayObjByName("car" + int(parentObj.bikeDef.wheel0_index) + "_wheel");
			
		}
		
		
//----------------------------------------------------

		function WheelOnSurface_DoDriveParticle(hitGO:GameObj,_x:Number, _y:Number, amt:Number)
		{
			if (hitGO == null) return;
			if (hitGO.polyMaterial == null) return;
			
			if (amt < 0.2) return;
			
			var surfparam:SurfaceParameter = SurfaceParameters.GetByPolyTypeName(hitGO.polyMaterial.name);
			if (surfparam == null) 
			{
//				trace("hitGO.polyMaterial.name " + hitGO.polyMaterial.name);
				return;
			}
			if (Utils.RandBetweenFloat(0,1) < surfparam.particleFrequency)
			{
				var part:Particle = Particles.Add(_x, _y);
				part.InitSurfaceFX(amt,surfparam.particleName);
			}
		}

//----------------------------------------------------

		function WheelOnSurface_DoSkidParticle(hitGO:GameObj,_x:Number, _y:Number, amt:Number)
		{
			if (hitGO == null) return;
			if (hitGO.polyMaterial == null) return;
			
			if (amt < 0.1) return;
			
			var surfparam:SurfaceParameter = SurfaceParameters.GetByPolyTypeName(hitGO.polyMaterial.name);
			if (surfparam == null) 
			{
//				trace("hitGO.polyMaterial.name " + hitGO.polyMaterial.name);
				return;
			}
			if (Utils.RandBetweenFloat(0,1) < surfparam.skidFrequency)
			{
				var part:Particle = Particles.Add(_x, _y);
				part.InitSurfaceFX(amt,surfparam.particleName);
			}
		}
		
//----------------------------------------------------
		
		function WheelOnSurface_DoLandParticle(hitGO:GameObj,_x:Number, _y:Number, amt:Number)
		{
			if (hitGO == null) return;
			if (hitGO.polyMaterial == null) return;
			
			
			var surfparam:SurfaceParameter = SurfaceParameters.GetByPolyTypeName(hitGO.polyMaterial.name);
			if (surfparam == null) 
			{
//				trace("hitGO.polyMaterial.name " + hitGO.polyMaterial.name);
				return;
			}
			var numToDo:int = Utils.ScaleTo(surfparam.landAmtOfParticles0, surfparam.landAmtOfParticles1, 0, 1, amt);
			for (var i:int = 0; i < numToDo; i++)
			{			
				var part:Particle = Particles.Add(_x, _y);
				part.InitSurfaceFX(amt, surfparam.particleName);
			}
		}
		
//----------------------------------------------------
		
		function WheelInSand(_x:Number, _y:Number, amt:Number)
		{
			if (amt < 0.1) return;
			if (Utils.RandBetweenInt(0, 100) < 30)
			{
				var part:Particle = Particles.Add(_x, _y);
				part.InitSandSplash(amt);
			}
		}
		function WheelInMud(_x:Number,_y:Number,amt:Number)
		{
			if (wheelIndex == 0)
			{
				if (GameVars.numMudTimesAdded == 0)
				{
					GameVars.numMudTimesAdded = 1;
				}
			}
			
			if (amt < 0.1) return;
			if (true)	//Utils.RandBetweenInt(0, 100) < 30)
			{
				var part:Particle = Particles.Add(_x, _y);
				part.InitMudSplash(amt);
			}
		}
		function WheelInWater(goHitter:GameObj)
		{
			if (Utils.RandBetweenInt(0, 100) < 20)
			{
				var part:Particle = Particles.Add(xpos, goHitter.waterHighestPoint);
				part.InitWaterSplash(this);
			}
			GameVars.playerGO.inwater = true;
		}
		
		function AddToBoost(amt:Number)
		{
		}

		function PlayerDoSpeedBoost(timeCount:Number)
		{
			// only one use at a time
			
			// time is not linear increase across levels (1-8)
			
			var grandtruckismo_nitrotime_a:Number = Vars.GetVarAsNumber("grandtruckismo_nitrotime_a");
			var grandtruckismo_nitrotime_vel:Number = Vars.GetVarAsNumber("grandtruckismo_nitrotime_vel");
			var grandtruckismo_nitrotime_acc:Number = Vars.GetVarAsNumber("grandtruckismo_nitrotime_acc");
			
			var t:Number = grandtruckismo_nitrotime_a;
			for (var i:int = 0; i < timeCount-1; i++)
			{
				t += grandtruckismo_nitrotime_vel;
				grandtruckismo_nitrotime_vel += grandtruckismo_nitrotime_acc;
			}
	
			trace("nitro time " + t);
			var nitroTime:Number = t;
			
			extraTopSpeedTimer = int(nitroTime * Defs.fps);
			extraTopSpeedTimerMax = extraTopSpeedTimer;
		}
		

		function InitStartFlag()
		{
			Game.AddGameObjectAt("startline_floorline", xpos, ypos, 0, 1).zpos = 75;;
			Game.AddGameObjectAt("startline_post", xpos+130, ypos-4, 0, 1).zpos = 100
		}
		function InitEndFlag()
		{
			GameVars.endFlagGO = this;
			GameVars.endX = xpos;
			GameVars.endpost_xpos = xpos;
			Game.AddGameObjectAt("endline_floorline", xpos, ypos, 0, 1).zpos = 75;
			Game.AddGameObjectAt("finishline_post", xpos-130, ypos-4, 0, 1).zpos = 100;
		}
		
		
//--------------------------------------------------------------------
		
		public function OnHitPickup_Time(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state == 10) return;
			if (state == 1 && timer1 < Defs.fps/2) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel" )
			{
				RemoveObject(RemovePhysObj);
				GameVars.AddToBombTimer(1);
				Audio.OneShot("sfx_time_pickup");
				state = 10;
			}
		}
		function Pickup_InitExplode()
		{
			nape_bodies[0].velocity.x = GameVars.playerGO.nape_bodies[0].velocity.x;
			nape_bodies[0].velocity.y = GameVars.playerGO.nape_bodies[0].velocity.y;
			
			var dx:Number = Utils.RandBetweenFloat(80,130);
			var dy:Number = Utils.RandBetweenFloat( -100, -150);
			ApplyImpulse(dx, dy);
			state = 1;
			timer = Defs.fps * 5;
			timer1 = 0;
			
		}
		function UpdatePickup_Time()
		{
			if (state == 1)
			{
				timer1++;
			}
			if (xpos < GameVars.playerGO.xpos - 200)
			{
				RemoveObject(RemovePhysObj);
			}
		}
		function InitPickup_Time()
		{
			onHitFunction = OnHitPickup_Time;
			updateFunction = UpdatePickup_Time;
		}

//--------------------------------------------------------------------
		
		public function OnHitPickup_SpeedBoost(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel" )
			{
//				RemoveObject(RemovePhysObj);
//				GameVars.playerGO.PlayerDoSpeedBoost(1);
//				Audio.OneShot("sfx_turboboost");
//				state = 10;
			}
		}
		function UpdatePickup_SpeedBoost()
		{
			if (state == 1)
			{
				timer--;
				if (timer <= 0)
				{
					state = 0;
				}
			}
		}
		function InitPickup_SpeedBoost()
		{
			onHitFunction = OnHitPickup_SpeedBoost;
			updateFunction = UpdatePickup_SpeedBoost;
		}
		
		
//--------------------------------------------------------------------
		
		function InitPlayerMarker(carIndex:int)
		{
			GameVars.startX = xpos;
//			GameVars.playerBikeDefIndex = carIndex;

			bikeDef = BikeDefs.GetByIndex(GameVars.playerBikeDefIndex);
			var go:GameObj = PhysicsBase.AddPhysObjAt("car" + int(bikeDef.frameIndex), xpos, ypos, 0, 1);	
			
			go.zpos = zpos;

			active = false;

			ypos -= 200;
		}
		function InitPlayerMarkerSingle() { InitPlayerMarker(0); }
		
		function InitPlayerMarker0() { InitPlayerMarker(0); }
		function InitPlayerMarker1() { InitPlayerMarker(1); }
		function InitPlayerMarker2() { InitPlayerMarker(2); }
		function InitPlayerMarker3() { InitPlayerMarker(3); }
		function InitPlayerMarker4() { InitPlayerMarker(4); }
		function InitPlayerMarker5() { InitPlayerMarker(5); }
		function InitPlayerMarker6() { InitPlayerMarker(6); }
		function InitPlayerMarker7() { InitPlayerMarker(7); }
		function InitPlayerMarker8() { InitPlayerMarker(8); }

		
//--------------------------------------------------------------------
		public function OnHitPickupChest(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel" )
			{
				for (var i:int = 0; i < 5; i++)
				{
					var go:GameObj = PhysicsBase.AddPhysObjAt("pickup_time_movable", xpos, ypos, 0, 1);
					go.Pickup_InitExplode();
				}
				RemoveObject(RemovePhysObj);
				state = 1;
				Audio.OneShot("sfx_time_pickup_big");

			}
		}

		function InitPickupChest()
		{
 			onHitFunction = OnHitPickupChest;
			state = 0;
		}
//--------------------------------------------------------------------


		function UpdateExplosion()
		{
			scale += 0.01;
			scale1 += 0.012;
			//dir += 0.01;
			//dir1 += 0.012;
			alpha = Utils.ScaleTo(0, 1, 0, timerMax, timer);
			alpha1 = Utils.ScaleTo(0, 0.8, 0, timerMax, timer);
			
			timer--;
			if(timer <= 0)
			{
				timer = 0;
			}
			
			if (timer == 100)
			{
				timer3 = timer3Max = 150;
				state = 1;
			}
			
			if (state == 1)
			{
				for (var i:int = 0; i < 3; i++)
				{
					explo_scales[i] += explo_scaleAdders[i];
					var a:Number = Utils.ScaleTo(0, 1, 0, timer3Max, timer3);
					explo_alphas[i] = a;

				}
				timer3--;
				if (timer3 <= 0)
				{
					RemoveObject();
				}
			}
			
			if (timer == timerMax - 1)
			{
				for (var i:int = 0; i < 10; i++)
				{
					var go:GameObj = GameObjects.AddObj(xpos, ypos, zpos + 10);
					go.InitExplosionFlameParticle();					
				}
				for (var i:int = 0; i < 20; i++)
				{
					var go:GameObj = GameObjects.AddObj(xpos, ypos, zpos + 10);
					
					var doIt:Boolean = false;
					if ((i % 5) == 0) doIt = true;
					
					go.InitExplosionDebris(doIt);
				}
			}
			
			
		}
		function RenderExplosion()
		{			
			s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);
			s3d.SetCurrentShader("alphamul");
			
			ct0.alphaOffset = -255+(alpha*255);
			RenderDispObjAt(xpos, ypos, dobj, frame,ct0,dir,scale);
			ct0.alphaOffset = -255+(alpha1*255);
			RenderDispObjAt(xpos, ypos, dobj1, frame1, ct0, dir1, scale1);
			
			if (state == 1)
			{
				for (var i:int = 0; i < 3; i++)
				{
					ct0.alphaOffset = -255+(explo_alphas[i]*255);
					RenderDispObjAt(xpos+explo_positions[i].x, ypos+explo_positions[i].y, dobj1, 0,ct0,explo_dirs[i],explo_scales[i]);
				}
				
			}
			s3d.SetCurrentShader("normal");
		}
		
		var ct0:ColorTransform;
		var alpha1:Number;
		var explo_scales:Array;
		var explo_scaleAdders:Array;
		var explo_positions:Array;
		var explo_alphas:Array;
		var explo_dirs:Array;
		function InitExplosion()
		{
			ct0 = new ColorTransform();
			
			explo_scales = new Array(0.2, 0.3, 0.4);
			explo_scaleAdders = new Array(0.01,0.01,0.01);
			explo_positions = new Array(
							new Point(Utils.RandBetweenFloat(-20,20),Utils.RandBetweenFloat(-20,20)),
							new Point(Utils.RandBetweenFloat(-20,20),Utils.RandBetweenFloat(-20,20)),
							new Point(Utils.RandBetweenFloat( -20, 20), Utils.RandBetweenFloat( -20, 20)));
			explo_alphas = new Array(1, 1, 1);
			explo_dirs = new Array(
								Utils.RandCircle(),
								Utils.RandCircle(),
								Utils.RandCircle());
			
			updateFunction = UpdateExplosion;
			renderFunction = RenderExplosion;
			dobj = GraphicObjects.GetDisplayObjByName("explosion_rays");
			dobj1 = GraphicObjects.GetDisplayObjByName("explosion_cloud");
			frame = 0;
			frame1 = 0;
			timer = timerMax = Defs.fps * 2;
			timer1 = 0;
			timer2 = 0;
			
			scale = 1;
			scale1 = 1;
			dir = 0;
			dir1 = 0;
			
		}

//------------------		
		
		function UpdateExplosionFlameParticle()
		{
			xpos += movementVec.X();
			ypos += movementVec.Y();
			yvel += 0.1;
			movementVec.speed *= 0.95;
			
			timer--;
			if (timer <= 0 || movementVec.speed <= 2)
			{
				RemoveObject();
			}
		}
		function InitExplosionFlameParticle()
		{
			updateFunction = UpdateExplosionFlameParticle;
			//renderFunction = RenderExplosion;
			dobj = GraphicObjects.GetDisplayObjByName("flameParticle");
			frame = dobj.GetRandomFrame();
			timer = 50;
			var d:Number = Utils.RandCircle();
			movementVec.Set(d, Utils.RandBetweenFloat(5, 10));
			
		}
		

//------------------		
		
		function UpdateExplosionDebris()
		{
			xpos += xvel;
			ypos += yvel;
			yvel += 0.08;
			dir += rotVel;
			
			timer1--;
			if (timer1 <= 0)
			{
				Particles.Add(xpos, ypos).InitTurboFlame();
				timer1 = 0;	// Utils.RandBetweenInt(10, 20);
			}
			
			timer--;
			if (timer <= 0)
			{
				RemoveObject();
			}
		}
		function InitExplosionDebris(doFlame:Boolean)
		{
			updateFunction = UpdateExplosionDebris;
			//renderFunction = RenderExplosion;
			dobj = GraphicObjects.GetDisplayObjByName("debris");
			frame = dobj.GetRandomFrame();
			timer = 1000;
			var d:Number = Utils.DegToRad( Utils.RandBetweenFloat( -45, 45)-90);
			movementVec.Set(d, Utils.RandBetweenFloat(5, 7));
			xvel = movementVec.X();
			yvel = movementVec.Y();
			scale = 2;
			
			dir = Utils.RandCircle();
			rotVel = Utils.RandBetweenFloat( -0.04, 0.04);
			
			timer1 = 999999;
			if (doFlame)
			{
				timer1 = Utils.RandBetweenInt(10, 20);
			}
		}
		
		
//--------------------------------------------------------------------

		function OnHitFlame(goHitter:GameObj)
		{
			if (goHitter == null) return;
		}
		function UpdateFlame()
		{
			timer--;
			if (timer <= 0)
			{
				RemoveObject(RemovePhysObj);
			}
		}
		function InitFlame()
		{
			name = "flame";
			onHitFunction = OnHitFlame;
			updateFunction = UpdateFlame;
			timer = Defs.fps;
		}
		
//--------------------------------------------------------------------

		public function InitFlameThrower()
		{			
			Utils.GetParams(initParams);						
			state = 0;
			updateFunction = UpdateFlameThrower;
			
			timer = Defs.fps * 2;
		}
		
		public function UpdateFlameThrower()
		{
			
			if(state == 0)
			{
				timer--;
				if (timer <= 0)
				{
					state = 1;
					timer = Defs.fps * 2;
					timer1 = 5;
				}
			}	
			else if (state == 1)
			{				
				timer1--;
				if (timer1 <= 0)
				{
					var go:GameObj = PhysicsBase.AddPhysObjAt("Flame", xpos, ypos, 0, 1);
					timer1 = 5;
				}
				
				timer--;
				if (timer <= 0)
				{
					state = 0;
					timer = Defs.fps * 2;
				}
			}
		}
		
//--------------------------------------------------------------------
//--------------------------------------------------------------------
//--------------------------------------------------------------------

		function UpdateBaddieWithGun()
		{
			if (GameVars.playerGO.state >= 100)
			{
				dobj = GraphicObjects.GetDisplayObjByName("BaddieWithGun");
				frame = 0;
				return;
			}
			
			if (type == 0)
			{
				if (state == 0)
				{
					frame = 0;
					if (xpos < GameVars.playerGO.xpos + 800)
					{
						state = 1;
						state1 = 1;
						timer = 0;
					}
				}
				else if (state == 1)
				{
					frame = 0;
					timer--;
					if (timer <= 0)
					{
						frame = 1;
						var go:GameObj = PhysicsBase.AddPhysObjAt("bullet", xpos - 23, ypos -44, 0, 1);	
						Audio.OneShot("sfx_gunshot");
						timer = 3;
						state = 2;
					}
				}
				else if (state == 2)
				{
					frame = 1;
					timer--;
					if (timer <= 0)
					{
						frame = 2;
						timer = Defs.fps * 1;
						state = 1;
					}
				}
				else if (state == 10)
				{
					frame = 3;
					ypos += yvel;
					yvel += 0.5;
					//dead
					timer--;
					if (timer <= 0)
					{
						RemoveObject();
					}
				}
			}
			
			if (type == 1)
			{
				
				if (state == 0)
				{
					frame = 0;
					if (xpos < GameVars.playerGO.xpos + 800)
					{
						state = 1;
						state1 = 1;
						timer = 0;
					}
				}
				else if (state == 1)
				{
//					frame = 0;
					timer--;
					if (timer <= 0)
					{
						frame = 1;
						var go:GameObj = PhysicsBase.AddPhysObjAt("bullet", xpos-23, ypos -44, 0, 1);					
						timer = 3;
						state = 2;
					}
				}
				else if (state == 2)
				{
//					frame = 1;
					timer--;
					if (timer <= 0)
					{
						frame = 2;
						timer = Defs.fps * 1;
						state = 1;
					}
				}
				else if (state == 10)
				{
					frame = 3;
					ypos += yvel;
					yvel += 0.5;
					//dead
					timer--;
					if (timer <= 0)
					{
						RemoveObject();
					}
				}
				
				if (state1 == 1)
				{
					xpos += xvel;
					RaycastBelow(true);
					CycleAnimation();	
					
					SetBodyXForm_Immediate(0, xpos, ypos, 0);
					
					timer1--;
					if (timer1 <= 0)
					{
						type = 0;
						state = 1;
						dobj = GraphicObjects.GetDisplayObjByName("BaddieWithGun");
						frame = 0;
					}
				}
				
					
			}
			if(xpos < GameVars.playerGO.xpos-300) RemoveObject(RemovePhysObj);
			
		}
		
//--------------------------------------------------------------------
		public function OnHitBaddie(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state == 10) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel")
			{
				state = 10;
				timer = Defs.fps * 2;
				yvel = -5;
				Audio.OneShot("sfx_manjump");
				RemovePhysObj();
			}
		}
		
		function InitBaddieWithGun()
		{
			PhysicsSetStationary();
			updateFunction = UpdateBaddieWithGun;
			onHitFunction = OnHitBaddie;
			state = 0;
			state1 = 0;
			type = 0;	//standing still
		}

		function InitBaddieWithGun_Running()
		{
			InitBaddieWithGun();
			type = 1;	//running
			xvel = 5;
			timer1 = Defs.fps * 5;
			frameVel = 0.5;
		}
		
		
//--------------------------------------------------------------------

//-------------------------------------------------

		function RenderBulletHitExplosion()
		{			
			ct.alphaMultiplier = alpha;
			RenderDispObjAt(xpos, ypos, dobj, frame,ct,dir,scale);
			ct.alphaMultiplier = alpha1;
			RenderDispObjAt(xpos, ypos, dobj1, frame, ct, dir, scale);
		}
		function UpdateBulletHitExplosion()
		{
			scale = Utils.ScaleTo(0.01,0.1, timerMax, 0, timer);
			timer--;
			if (timer <= 0)
			{
				RemoveObject();
			}
		}
		function InitBulletHitExplosion()
		{
			updateFunction = UpdateBulletHitExplosion;
			renderFunction = RenderBulletHitExplosion;
			dobj = GraphicObjects.GetDisplayObjByName("explosion_rays");
			dobj1 = GraphicObjects.GetDisplayObjByName("explosion_cloud");
			frame = 0;
			timer = timerMax = Defs.fps / 2;
			
			scale = 0.01;
			dir = 0;
			
		}

//--------------------------------------------------------------------

		function UpdateBullet()
		{
			SetBodyXForm_Immediate(0, xpos, ypos, 0);
			xpos += xvel;
			ypos += yvel;
			timer--;
			if (timer <= 0)
			{
				RemoveObject(RemovePhysObj);
			}
			if(xpos < GameVars.playerGO.xpos-300) RemoveObject(RemovePhysObj);
		}
		
		public function OnHitBullet(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel")
			{
				GameVars.playerGO.PlayerHitByBullet();
				
				GameObjects.AddObj(xpos, ypos, zpos - 1).InitBulletHitExplosion();
				
				RemoveObject(RemovePhysObj);
			}
		}
		
		function InitBullet()
		{
			name = "bullet";
			PhysicsSetStationary();
			updateFunction = UpdateBullet;
			onHitFunction = OnHitBullet;
			state = 0;
			timer = Defs.fps * 2;

			xvel = -5;
			yvel = 0;
			
			
		}

//--------------------------------------------------------------------
//--------------------------------------------------------------------

		function RenderFallingRock()
		{
			oldxpos = xpos;
			oldypos = ypos;
			if (state == 1)
			{
				xpos += Utils.RandBetweenFloat( -2, 2);
				ypos += Utils.RandBetweenFloat( -2, 2);
			}
			RenderDispObjNormally();
			xpos = oldxpos;
			ypos = oldypos;
		}

		function UpdateFallingRock()
		{
			if (state == 0)
			{
				if (xpos <= (Game.camera.x + Defs.displayarea_w)-xpos1)
				{
					PhysicsSetActive();
					PhysicsSetStationary();
					state = 1;
					var rock_timer1:int = Vars.GetVarAsNumber("rock_timer1") * Defs.fps;
					var rock_timer2:int = Vars.GetVarAsNumber("rock_timer2") * Defs.fps;
					timer = Utils.RandBetweenInt(rock_timer1,rock_timer2);
				}
			}
			else if (state == 1)	// about to fall
			{
				timer--;
				if (timer <= 0)
				{
					state = 2;
					timer = Defs.fps * 5;
					PhysicsSetMovable();
					var body:Body = nape_bodies[0];
					body.type = BodyType.DYNAMIC;
				}
			}
			else if (state == 2)
			{
				timer--;
				if (timer <= 0)
				{
					RemoveObject(RemovePhysObj);
				}
			}
			
		}
		
		public function OnHitFallingRock(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 2) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel")
			{
				GameVars.playerGO.PlayerHitByRock();
				state = 3;
				RemoveObject(RemovePhysObj);
			}
			RemoveObject(RemovePhysObj);
			
			for (var i:int = 0; i < 4; i++)
			{
				Particles.Add(xpos, ypos).InitRockDebris();
			}
		}
		
		var rockExtraDistance:Number;
		function InitFallingRock()
		{
			PhysicsSetStationary();
			renderFunction = RenderFallingRock;
			updateFunction = UpdateFallingRock;
			onHitFunction = OnHitFallingRock;
			state = 0;
			PhysicsSetInactive();
			xpos1 = Vars.GetVarAsInt("rock_onscreendist");
		}

//--------------------------------------------------------------------
//--------------------------------------------------------------------

		function RenderStalagtite()
		{
			oldxpos = xpos;
			oldypos = ypos;
			if (state == 1)
			{
				xpos += Utils.RandBetweenFloat( -2, 2);
				ypos += Utils.RandBetweenFloat( -2, 2);
			}
			RenderDispObjNormally();
			xpos = oldxpos;
			ypos = oldypos;
		}

		function UpdateStalagtite()
		{
			if (state == 0)
			{
				if (xpos <= (Game.camera.x + Defs.displayarea_w)-xpos1)
				{
					PhysicsSetActive();
					PhysicsSetStationary();
					state = 1;
					var stalagtite_timer1:int = Vars.GetVarAsNumber("stalagtite_timer1") * Defs.fps;
					var stalagtite_timer2:int = Vars.GetVarAsNumber("stalagtite_timer2") * Defs.fps;
					timer = Utils.RandBetweenInt(stalagtite_timer1,stalagtite_timer2);
				}
			}
			else if (state == 1)	// about to fall
			{
				timer--;
				if (timer <= 0)
				{
					state = 2;
					timer = Defs.fps * 5;
					PhysicsSetMovable();
					var body:Body = nape_bodies[0];
					body.type = BodyType.DYNAMIC;
				}
			}
			else if (state == 2)
			{
				timer--;
				if (timer <= 0)
				{
					RemoveObject(RemovePhysObj);
				}
			}
			
		}
		
		public function OnHitStalagtite(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 2) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel")
			{
				GameVars.playerGO.PlayerHitByRock();
				state = 3;
				RemoveObject(RemovePhysObj);
			}
			RemoveObject(RemovePhysObj);
			
			for (var i:int = 0; i < 4; i++)
			{
				Particles.Add(xpos, ypos).InitStalagtiteDebris();
			}
		}
		
		function InitStalagtite()
		{
			PhysicsSetStationary();
			renderFunction = RenderStalagtite;
			updateFunction = UpdateStalagtite;
			onHitFunction = OnHitStalagtite;
			state = 0;
			PhysicsSetInactive();
			xpos1 = Vars.GetVarAsInt("stalagtite_onscreendist");
		}
		
		
//--------------------------------------------------------------------
//--------------------------------------------------------------------

		public function InitLevelInfo()
		{
			Utils.GetParams(initParams);			
			doorSwitch_angAdd = Utils.GetParamNumber("doorswitch_openangle", 0);
			
			var difficulty:Number = Utils.GetParamNumber("level_difficulty", 1);
			
			var l:Level = Levels.GetCurrent();
			
			
			Game.currentBackground = Utils.GetParamInt("level_background", 1) -1;
			Game.InitBackground();
			
			if (Game.usedebug == false)
			{
				active = false;
				visible = false;
			}
			
		}
		

//--------------------------------------------------------------------
		public function OnHitElectricFence(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel")
			{
				state = 1;
			}
		}
		public function UpdateElectricFence()
		{
			frame = dobj.GetRandomFrame();
		}
		public function InitElectricFence()
		{
			onHitFunction = OnHitElectricFence;
			updateFunction = UpdateElectricFence;
		}

//--------------------------------------------------------------------
		public function RenderSmokeParticle()
		{
			RenderDispObjNormally();
		}
		public function UpdateSmokeParticle()
		{
			xpos += xvel;
			ypos += yvel;
			yvel *= 0.99;
			timer--;
			if (timer <= 0)
			{
				RemoveObject();
			}
		}
		public function InitSmokeParticle()
		{
			renderFunction = RenderSmokeParticle;
			updateFunction = UpdateSmokeParticle;
			clipFunction = ClipFunction_NoClip;
			dobj = GraphicObjects.GetDisplayObjByName("SmokeParticle");
			frame = dobj.GetRandomFrame();
			xvel = Utils.RandBetweenFloat( -1, 1);
			yvel = Utils.RandBetweenFloat( -1, -2);
			timer = Utils.RandBetweenInt(10, 20);

		}

//--------------------------------------------------------------------
		public function RenderPlusSeconds()
		{
			xpos += Game.camera.x;
			ypos += Game.camera.y;
			RenderDispObjNormally();
			xpos -= Game.camera.x;
			ypos -= Game.camera.y;
		}
		public function UpdatePlusSeconds()
		{
			if (state == 0)
			{
				scale -= 0.1;
				if (scale <= 1)
				{
					state = 1;
				}
			}
			else if (state == 1)
			{
				ypos += yvel;
				yvel += yacc;
				timer--;
				if(ypos < -10)
				{
					RemoveObject();
				}				
			}
		}
		public function InitPlusSeconds(_count:int)
		{
			renderFunction = RenderPlusSeconds;
			updateFunction = UpdatePlusSeconds;
			clipFunction = ClipFunction_NoClip;
			dobj = GraphicObjects.GetDisplayObjByName("PlusSeconds");
			state = 0;
			scale = 2;
			yvel = -2;
			yacc = -0.1;
			
			frame = _count - 1;
			if (frame > 2) frame = 2;
			
			dir = Utils.RandBetweenFloat( -0.2, 0.2);
			

		}
		

//--------------------------------------------------------------------
		public function OnHitMine(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel")
			{
				GameVars.playerGO.PlayerHitMine();
				state = 1;
				RemoveObject(RemovePhysObj);
				var go:GameObj = GameObjects.AddObj(xpos, ypos, zpos - 1);
				go.InitMineExplosion();
				Audio.OneShot("sfx_mine");

			}
		}
		public function UpdateMine()
		{
			frame = 0;
		}
		public function InitMine()
		{
			onHitFunction = OnHitMine;
			updateFunction = UpdateMine;
		}
		
//--------------------------------------------------------------------
		public function RenderBrokenHydrant()
		{
			RenderDispObjNormally();
			RenderDispObjAt(xpos+hydrantOffset.x, ypos+hydrantOffset.y, dobj1, frame1,null,dir);
		}
		public function UpdateBrokenHydrant()
		{
			timer--;
			if (timer < 0)
			{
				var go:GameObj = PhysicsBase.AddPhysObjAt("broken_hydrant_physics_water",xpos+hydrantOffset.x,ypos+hydrantOffset.y, 0, 1, "", "", "");
				go.StartBrokenHydrantPhysicsWater(hydrantForce.x,hydrantForce.y);
				timer = timerMax;
			}
			frame1 = dobj1.GetRandomFrame();
		}
		var hydrantOffset:Point;
		var hydrantForce:Point;
		public function InitBrokenHydrant()
		{
			updateFunction = UpdateBrokenHydrant;
			renderFunction = RenderBrokenHydrant;
			timer = 0;
			timerMax =  Vars.GetVarAsNumber("hydrant_delay");
			dobj1 = GraphicObjects.GetDisplayObjByName("hydrant_waterspray");
			frame1 = 0;
			
			xpos1 = 0;
			ypos1 = -27;
			
			gmat.identity();
			gmat.rotate(dir);
			
			hydrantOffset = new Point(xpos1, ypos1);
			hydrantOffset = gmat.transformPoint(hydrantOffset);
			
			hydrantForce = new Point(0, -Vars.GetVarAsNumber("hydrant_force"));
			hydrantForce = gmat.transformPoint(hydrantForce);
		}

		
//-------------		
		
		public function UpdateBrokenHydrantPhysicsWater()
		{
			timer--;
			if (timer < 0)
			{
				RemoveObject(RemovePhysObj);
			}
		}
		public function InitBrokenHydrantPhysicsWater()
		{
			visible = false;
			updateFunction = UpdateBrokenHydrantPhysicsWater;
			timer = Vars.GetVarAsNumber("hydrant_time");
		}
		public function StartBrokenHydrantPhysicsWater(velx:Number,vely:Number)
		{
			ApplyImpulse(velx,vely);
			
		}
		
		
	
//-------------		
		
		public function UpdateHelicopter()
		{
			var go:GameObj = GameVars.playerGO;
			
			if (state == 0)
			{
				timer--;
				if (timer <= 0)
				{
					timer = Utils.RandBetweenInt(50, 100);
					toPosX = Utils.RandBetweenFloat( 100,400);
					toPosY = -200;
				}
				
				

				movementVec1.SetFromDxDy(toPosX - xpos1, toPosY - ypos1);
				movementVec1.speed = 0.1;
				
				movementVec.Add(movementVec1);
				if(movementVec.speed > 5) movementVec.speed = 5;
				
				
				var d:Number = Utils.DistBetweenPoints(xpos1, ypos1, toPosX, toPosY);

				if (d < 10)
				{
					timer = 0;
				}
				
				
				xpos1 += movementVec.X();
	//			ypos1 += movementVec.Y();
				

				var yPosBelow:Number = RaycastGetPosBelow();
				if (yPosBelow != NaN)
				{
					ypos1 = yPosBelow-200;
					
				}
				else
				{
					ypos1 = go.ypos - 200;
				}
				
				
				xpos = go.xpos + xpos1;
				ypos = ypos1;
				
				dir = Utils.ScaleToPreLimit( -0.2, 0.2, -5, 5, movementVec.X());
				
				
				timer1--;
				if (timer1 < 0)
				{
					var go1:GameObj = PhysicsBase.AddPhysObjAt("mine_bomb", xpos, ypos, 0, 1, "", "", "");
					go1.nape_bodies[0].velocity.x = go.nape_bodies[0].velocity.x + Utils.RandBetweenFloat( -1, 1);
					timer1 = timer1Max;
				}
				
				
				if (xpos > heliEndXPos)
				{
					state = 1;
					timer = 200;
				}
				
			}
			else if (state == 1)
			{
				xpos += xvel;
				ypos -= 5;
				timer--;
				if (timer <= 0)
				{
					RemoveObject();
				}
			}
			else if (state == 2)	// waiting state
			{
				if (go.xpos > xpos - 700)
				{
					state = 0;
				}
			}
			
			frame1 = dobj1.GetRandomFrame();
			
		}
		public function RenderHelicopter()
		{
			RenderDispObjNormally();
			RenderDispObjAt(xpos, ypos, dobj1, frame1,null,dir);
		}
		var heliEndXPos:Number
		public function InitHelicopter()
		{
			dobj1 = GraphicObjects.GetDisplayObjByName("heliblades");
			frame1 = 0;
			updateFunction = UpdateHelicopter;
			renderFunction = RenderHelicopter;
			timer = 0;
			
			state = 2;
			timer1 = timer1Max = Defs.fps * 1.5;
			
			heliEndXPos = xpos;
			var l:Level = Levels.GetCurrent();
			for each(var inst:EdObj in l.instances)
			{
				if (inst.typeName == "helicopter_end")
				{
					if (inst.x > xpos)
					{
						heliEndXPos = inst.x;
						break;
					}
				}
			}
			
		}
		
		public function InitHelicopterEnd()
		{
			visible = false;
			active = false;
		}
		
//---------------------------------

		public function OnHitMineBomb(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel")
			{
				GameVars.playerGO.PlayerHitMine();
				state = 1;
				RemoveObject(RemovePhysObj);
				var go:GameObj = GameObjects.AddObj(xpos, ypos, zpos - 1);
				go.InitMineExplosion();
			}
			else
			{
				RemoveObject(RemovePhysObj);				
				var go1:GameObj = PhysicsBase.AddPhysObjAt("mine_bomb_explode", xpos, ypos, 0, 1, "", "", "");
				
				trace("nhit");
				var go:GameObj = GameObjects.AddObj(xpos, ypos, zpos - 1);
				go.InitMineExplosion();
			}
		}
		public function UpdateMineBomb()
		{
			frame = 0;
		}
		public function InitMineBomb()
		{
			onHitFunction = OnHitMineBomb;
			updateFunction = UpdateMineBomb;
		}

		
//-----------------

		public function UpdateMineBombExplode()
		{
			timer--;
			if (timer <= 0)
			{
				RemoveObject(RemovePhysObj);
			}
		}
		public function InitMineBombExplode()
		{
			onHitFunction = OnHitMine;
			updateFunction = UpdateMineBombExplode;
			state = 0;
			visible = false;
			timer = 20;
			
		}
		
		
//-------------------------------------------------

		function RenderMineExplosion()
		{			
			ct.alphaMultiplier = alpha;
			RenderDispObjAt(xpos, ypos, dobj, frame,ct,dir,scale);
			ct.alphaMultiplier = alpha1;
			RenderDispObjAt(xpos, ypos, dobj1, frame, ct, dir, scale);
		}
		function UpdateMineExplosion()
		{
			scale = Utils.ScaleTo(0.1, 2, timerMax, 0, timer);
			timer--;
			if (timer <= 0)
			{
				RemoveObject();
			}
		}
		function InitMineExplosion()
		{
			updateFunction = UpdateMineExplosion;
			renderFunction = RenderMineExplosion;
			dobj = GraphicObjects.GetDisplayObjByName("explosion_rays");
			dobj1 = GraphicObjects.GetDisplayObjByName("explosion_cloud");
			frame = 0;
			timer = timerMax = Defs.fps / 2;
			
			scale = 0.1
			dir = 0;
			
		}

//---------------------------------

		public function OnHitCollidable_RemoveAfterHit(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel")
			{
				state = 1;
				timer = 2;
			}
		}
		public function UpdateCollidable_RemoveAfterHit()
		{
			if (state == 1)
			{
				timer--;
				if (timer <= 0)
				{
					RemoveObject(RemovePhysObj);
					GenerateBreakableBits();
				}
			}
		}
		public function InitCollidable_RemoveAfterHit()
		{
			onHitFunction = OnHitCollidable_RemoveAfterHit;
			updateFunction = UpdateCollidable_RemoveAfterHit;
		}
		
		public function InitCollidable_RemoveAfterHit_Phonebooth()
		{
			InitCollidable_RemoveAfterHit();			
			var list:Array = new Array();			
			list.push(new BreakablePieceDef(22.25,-2.25,"phonebooth_bit8"));
			list.push(new BreakablePieceDef(-12.35,-24.7,"phonebooth_bit7"));
			list.push(new BreakablePieceDef(-15.8,-0.55,"phonebooth_bit6"));
			list.push(new BreakablePieceDef(3.7,-6.85,"phonebooth_bit5"));
			list.push(new BreakablePieceDef(-10.65,20.6,"phonebooth_bit4"));
			list.push(new BreakablePieceDef(15.35,22.15,"phonebooth_bit2"));
			list.push(new BreakablePieceDef(16.75, -28.3, "phonebooth_bit1"));
			breakable_piece_def_list = list;			
		}
		public function InitCollidable_RemoveAfterHit_Barrier()
		{
			InitCollidable_RemoveAfterHit();			
			var list:Array = new Array();			
			list.push(new BreakablePieceDef(-31.35,-2.2,"barrier_bit5"));
			list.push(new BreakablePieceDef(-6.25,-16,"barrier_bit4"));
			list.push(new BreakablePieceDef(-10.35,2.65,"barrier_bit3"));
			list.push(new BreakablePieceDef(17.3,0.7,"barrier_bit2"));
			list.push(new BreakablePieceDef(29.7, -12.05, "barrier_bit1"));
			breakable_piece_def_list = list;			
		}
		public function InitCollidable_RemoveAfterHit_Cone()
		{
			InitCollidable_RemoveAfterHit();			
			var list:Array = new Array();			
			list.push(new BreakablePieceDef(0.4,-11,"cone_bit3"));
			list.push(new BreakablePieceDef(-0.25,-1.85,"cone_bit2"));
			list.push(new BreakablePieceDef(-0.35,7.55,"cone_bit1"));
			breakable_piece_def_list = list;			
		}
		public function InitCollidable_RemoveAfterHit_Postbox()
		{
			InitCollidable_RemoveAfterHit();			
			var list:Array = new Array();			
			list.push(new BreakablePieceDef(-10.4,-8.6,"postbox_bit4"));
			list.push(new BreakablePieceDef(4.75,-10.5,"postbox_bit3"));
			list.push(new BreakablePieceDef(9,9.25,"postbox_bit2"));
			list.push(new BreakablePieceDef(-9.2,11.65,"postbox_bit1"));
			breakable_piece_def_list = list;			
		}
		public function InitCollidable_RemoveAfterHit_Hydrant()
		{
			InitCollidable_RemoveAfterHit();			
			var list:Array = new Array();			
			list.push(new BreakablePieceDef(0.35,18.1,"hydrant_bit2"));
			list.push(new BreakablePieceDef(0.05, -8.55, "hydrant_bit1"));
			breakable_piece_def_list = list;			
		}

		
		
//-------------------------------------------------------

		function UpdateSnowball()
		{
			Update_Breakable_Pieces();

			var go:GameObj = GameVars.playerGO;
			
			if (state == 0)
			{
				if (go.xpos > xpos-1000)
				{
					trace("init snowball");
					state = 10;
					PhysicsSetActive();
				}
			}
			else if (state == 10)		// rolling
			{
				if (xpos < go.xpos - 300 )
				{
					RemoveObject(RemovePhysObj);
				}				
			}
		}
		function InitSnowball()
		{
			var x:Number = -18;
			var y:Number = -16;
			var list:Array = new Array()
			list.push(new BreakablePieceDef( x-18,y-23, "snowball_split1"));
			list.push(new BreakablePieceDef( x+3,y-31, "snowball_split2"));
			list.push(new BreakablePieceDef( x+25,y-21, "snowball_split3"));
			list.push(new BreakablePieceDef( x-27,y-8, "snowball_split4"));
			list.push(new BreakablePieceDef( x-3,y-11, "snowball_split5"));
			list.push(new BreakablePieceDef( x+13,y-5, "snowball_split6"));
			list.push(new BreakablePieceDef( x+31,y-3, "snowball_split7"));
			list.push(new BreakablePieceDef( x-26,y+8, "snowball_split8"));
			list.push(new BreakablePieceDef( x-11,y+5, "snowball_split9"));
			list.push(new BreakablePieceDef( x+7,y+12, "snowball_split10"));
			list.push(new BreakablePieceDef( x+28,y+10, "snowball_split11"));
			list.push(new BreakablePieceDef( x-16,y+23, "snowball_split12"));
			list.push(new BreakablePieceDef( x+1,y+29, "snowball_split13"));
			list.push(new BreakablePieceDef( x+20,y+26, "snowball_split14"));
			Init_Breakable_Pieces(list);
			
			updateFunction = UpdateSnowball;

			PhysicsSetInactive();
			
		}

		
//-------------------------------------------------------

		function UpdateRollingRock()
		{
			var go:GameObj = GameVars.playerGO;
			
			if (state == 0)
			{
				if (go.xpos > xpos-1000)
				{
					trace("init snowball");
					state = 2;
					PhysicsSetActive();
				}
			}
			else if (state == 2)		// rolling
			{
				if (xpos < go.xpos - 300 )
				{
					RemoveObject(RemovePhysObj);
				}				
			}
		}
		
		public function OnHitRollingRock(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 2) return;
			if (goHitter.name == "player" || goHitter.name == "player_wheel" || goHitter.name == "bomb")
			{
				GameVars.playerGO.PlayerHitByRock();
				state = 3;
				RemoveObject(RemovePhysObj);
				for (var i:int = 0; i < 12; i++)
				{
					Particles.Add(xpos, ypos).InitRockDebris(true);
				}
			}
			
		}
		
		function InitRollingRock()
		{
			
			updateFunction = UpdateRollingRock;
			onHitFunction = OnHitRollingRock;

			PhysicsSetInactive();
			
		}
		
//-------------------------------------------------------

		function RenderOutOfTime()
		{
			RenderDispObjNormally(false);
		}
		function UpdateOutOfTime()
		{
			scale += scaleVel;
			if (scale < 1)
			{
				scale = 1;
			}
			
		}
		function InitOutOfTime()
		{
			name = "outoftime";
			clipFunction = ClipFunction_NoClip;
			renderFunction = RenderOutOfTime;
			updateFunction = UpdateOutOfTime;
			scale = 5;
			scaleVel = -0.1;
			xpos = Defs.displayarea_w / 2;
			ypos = Defs.displayarea_h / 4;
			dobj = GraphicObjects.GetDisplayObjByName("OutOfTime");
			frame = 0;
			
			zpos = 0;
			visible = true;
			
		}

//-------------------------------------------------------
//-------------------------------------------------------

		function RenderIngameHelp()
		{
			
		}
		function UpdateIngameHelp()
		{
			if (state == 0)
			{
				if (GameVars.playerGO.xpos >= xpos - 200)
				{
					state = 1;
				}
			}
			else if (state == 1)
			{
				toPosX = Game.camera.x + Defs.displayarea_w2;
				toPosY = Game.camera.y + Defs.displayarea_h2;
				//toPosX = GameVars.playerGO.xpos+200;
				//toPosY = GameVars.playerGO.ypos + 150;
				xpos += (toPosX - xpos) * 0.9;
				ypos += (toPosY - ypos) * 0.9;
				
				if (GameVars.playerGO.xpos >= startx)
				{
					state = 2;
				}
			}
		}
		function InitIngameHelp()
		{
			updateFunction = UpdateIngameHelp;
			state = 0;
			
			Utils.GetParams(initParams);			
			
			startx = xpos + Utils.GetParamNumber("help_distance", 1000);
			zpos = -100;
		}
//-------------------------------------------------------
//-------------------------------------------------------
		function InitLargeItemClip()
		{
			clipFunction = ClipFunction_Big;
		}


//-------------------------------------------------------
		
		var aiFinishedRace:Boolean;
		var wheelRot0:Number;
		var wheelRot1:Number;
		var aiPosition:Number;
		var aiPositionVel:Number;
		var interpolatedPRI:PlayerRecordingItem;
		function InitAIPlayer(pr:PlayerRecording,timeSeconds:Number)
		{
			interpolatedPRI = new PlayerRecordingItem();
			GameVars.AddPlayerToList(this);
			aiFinishedRace = false;
			name = "airacer";
			colFlag_isEnemy = true;
			playerRecording = pr.Clone();
			aiPosition = 0;
			aiPositionVel = 1;
			updateFunction = UpdateAIPlayer;
			renderFunction = RenderAIPlayer;
			
//			trace("InitAIPlayer "+pr.bike_id);
			
			var bodyID:int = pr.bike_id + 1;
			
			bikeDef = BikeDefs.GetByIndex(pr.bike_id);
			
//			InitAIBikeDef(pr.bike_id);
			
			dobj = GraphicObjects.GetDisplayObjByName("car"+bikeDef.frameIndex+"_body");
			dobj1 = GraphicObjects.GetDisplayObjByName("car"+bikeDef.frameIndex+"_wheel");
			dobj2 = GraphicObjects.GetDisplayObjByName("car"+bikeDef.frameIndex+"_wheel");
			frame = bikeDef.specialStunt;

			zpos = GameLayers.GetZPosByName("Player") + 1 + Utils.RandBetweenFloat(0, 1);
			timer = 0;
			updateFromPhysicsFunction = UpdatePhysicsNull;
			
			
			playerRecording.time = playerRecording.list.length;
			
			var timeTicks:Number = timeSeconds * Defs.fps;
			aiPositionVel = playerRecording.time / timeTicks;
			//trace("aiPositionVel " + aiPositionVel);

			
			aiInitialBoostVel = Vars.GetVarAsNumber("ai_intital_boost_max");
			aiInitialBoostTimeMax = Vars.GetVarAsNumber("ai_intital_boost_time") * Defs.fps;
			aiInitialBoostTime = 0;
		}
		
		var aiInitialBoostVel:Number;
		var aiInitialBoostTime:Number;
		var aiInitialBoostTimeMax:Number;
		
	//------------------------------------------------------
		function DoAIAction(act:PlayerRecordAction)
		{
//			trace( "Ai doing action " + act.action +" at pos " + act.pos);
			act.done = true;
			
			if (act.action == PlayerRecordAction.ACTION_CROSSEDLINE)
			{
				trace( "AI crossed line ");
			}
			/*
			if (act.action == PlayerRecordAction.ACTION_HITCAR)
			{
				var go:GameObj = GameObjects.objs[act.data];
				if (go != null)
				{
					if (go.name == "scenerycar")
					{
						go.SceneryCarHitByAI();
					}
				}
			}
			*/
			
		}
		function TestAIAction(pos:int)
		{
			for each(var act:PlayerRecordAction in playerRecording.actions)
			{
				if (act.done == false)
				{
					if (act.pos <= pos)
					{
						DoAIAction(act);
					}
				}
			}
		}
		
		
		function UpdateAIPlayer()
		{
			if ( GameVars.playerGO == null) return;
			
			var rp:int = int(Math.floor(aiPosition));				
			var frac:Number = aiPosition - (Math.floor(aiPosition));				
			rp = int(Math.floor(aiPosition));
			
			var pri:PlayerRecordingItem = playerRecording.GetItem(rp);
			var pri1:PlayerRecordingItem = playerRecording.GetItem(rp + 1);
			
			if (pri == null || pri1 == null) return;
			
			interpolatedPRI.SetInterpolatedItem(pri,pri1,frac);
			
			var olddir:Number = dir;
			oldxpos = xpos;
			oldypos = xpos;
			xpos = interpolatedPRI.x;
			ypos = interpolatedPRI.y;
			dir = interpolatedPRI.rot;
			xpos1 = interpolatedPRI.wheel0_x;
			ypos1 = interpolatedPRI.wheel0_y;
			xpos2 = interpolatedPRI.wheel1_x;
			ypos2 = interpolatedPRI.wheel1_y;
			wheelRot0 = interpolatedPRI.wheel0_rot;
			wheelRot1 = interpolatedPRI.wheel1_rot;

			var dist:Number = Utils.DistBetweenPoints(xpos, ypos, oldxpos, oldypos);
			dist = Utils.LimitNumber(0, 20,dist);
			
			
			
//			if (GameVars.doingStart)
//			{
//				return;
//			}
			if (int(aiPosition) == playerRecording.list.length - 1)
			{
				return;
			}
			
			
			if (GameVars.canStart == false)
			{
				return;
			}
			
			
			var l:Level = Levels.GetCurrent();
			if (GameVars.useAICatchup)
			{
				var minusMaxD:Number = Vars.GetVarAsNumber("uiCatchup_MinusMaxD");
				var maxD:Number =  Vars.GetVarAsNumber("uiCatchup_MaxD");
				var minusMaxS:Number = Vars.GetVarAsNumber("uiCatchup_MinusMaxS");
				var maxS:Number = Vars.GetVarAsNumber("uiCatchup_MaxS");
				var distoffset:Number = Vars.GetVarAsNumber("uiCatchup_DistOffset");
				
				
				var dist:Number = (GameVars.playerGO.xpos+distoffset) - xpos;
				if (dist < -minusMaxD) dist =-minusMaxD;
				if (dist > maxD) dist = maxD;
				
				var speedOffset:Number = Utils.ScaleTo( -minusMaxS, maxS, -minusMaxD, maxD, dist);
				if (speedOffset != 0)
				{
//					trace("AI speedoffset " + speedOffset);
				}
				
				aiPosition += speedOffset;
			}
			
			

			aiInitialBoostTime++;
			if (aiInitialBoostTime >= aiInitialBoostTimeMax)
			{
				aiInitialBoostTime = aiInitialBoostTimeMax;
			}
			var extra:Number = Utils.ScaleTo(aiInitialBoostVel, 0, 0, aiInitialBoostTimeMax, aiInitialBoostTime);
//			trace("ai extra " + extra);


			aiPosition += extra;
			
			
			var skip:Number = 1;
			if (Game.useLocalRuns)
			{
//				skip = GameVars.rundata_skip;
			}
			
			
			
			aiPosition += Number(aiPositionVel/skip);
			

			TestAIAction(aiPosition);


			
			var finished:Boolean = false;
			if (xpos > GameVars.endpost_xpos) 
			{
				finished = true;
			}
			
			if (finished)
			{
				if (aiFinishedRace == false)
				{
					//Game.AddAIFinishedTime();
				}
				aiFinishedRace = true;
			}
			
//			SetBodyXForm(0, xpos, ypos, dir);
//			bikeWheels[0].SetBodyXForm(0, xpos1, ypos1, 0);
//			bikeWheels[1].SetBodyXForm(0, xpos2, ypos2, 0);
			
		}
		
		
		function RenderAIPlayer()
		{
			var xp:Number =  Math.round(xpos) - Math.round(Game.camera.x);
			var yp:Number =  Math.round(ypos) - Math.round(Game.camera.y);
			var xp1:Number =  Math.round(xpos1) - Math.round(Game.camera.x);
			var yp1:Number =  Math.round(ypos1) - Math.round(Game.camera.y);
			var xp2:Number =  Math.round(xpos2) - Math.round(Game.camera.x);
			var yp2:Number =  Math.round(ypos2) - Math.round(Game.camera.y);

				
			
			
			// draw under-truck suspension thingies
			gpoint.x = 0;
			gpoint.y = -20;
			
			gpoint = Utils.RotatePoint(gpoint, dir);
			
//			gmat.identity();
//			gmat.rotate(dir);
//			gpoint = gmat.transformPoint(gpoint);
			
			gpoint.x += xp;
			gpoint.y += yp;
			
			if (PROJECT::useStage3D == false)
			{			
				var g:Graphics = Game.fillScreenMC.graphics;
				g.clear();
				
				g.lineStyle(5, 0x303030, 1);
				g.moveTo(gpoint.x, gpoint.y);
				g.lineTo(xp1,yp1);
				
				g.moveTo(gpoint.x, gpoint.y);
				g.lineTo(xp2,yp2);
				
				bd.draw(Game.fillScreenMC);
			}
			
			RenderDispObjAt(xp, yp, dobj,frame, null, dir, 1, false);
			RenderDispObjAt(xp1, yp1, dobj1, 0, null, wheelRot0, 1, false);
			RenderDispObjAt(xp2, yp2, dobj2, 0, null, wheelRot1, 1, false);
			
				
			if (Game.usedebug)
			{
				var t:String = Utils.CounterToSecondsString(playerRecording.time);
				
				if (Game.useLocalRuns)
				{
					t = Utils.CounterToSecondsString(playerRecording.time*GameVars.rundata_skip);
				}

				
				TextRenderer.RenderAt(0,bd, xp, yp - 50, playerRecording.db_id.toString()+" : "+t);
				
			}
			
			var dob:DisplayObj = GraphicObjects.GetDisplayObjByName("PosName");
			dob.RenderAt(bikeDef.index, bd, xp, yp-80);
			
			
		}
	//------------------------------------------------------
	//------------------------------------------------------
	//------------------------------------------------------
		
		
		function KeepAwake_Pickup()
		{
			if (Math.abs(xpos - GameVars.playerGO.xpos) < 300)
			{
				WakeUpPhysics();
			}
			else
			{
				SleepPhysics();
			}
		}
		
	//------------------------------------------------------
	//------------------------------------------------------
	//------------------------------------------------------
		
		
	//------------------------------------------------------
	//------------------------------------------------------
	//------------------------------------------------------
	
	
		function InitGameObjLine_Standard_Sticky()
		{
			InitGameObjLine_Standard();
			collisionType = "sticky";
			canRestartHere = true;
			
		}
	
//-----------------------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------------------		
		

		public static const NINJASTATE_STATIC:int = 0;
		public static const NINJASTATE_DRAGGING:int = 1;
		public static const NINJASTATE_FLYING:int = 2;
		public static const NINJASTATE_DEAD:int = 3;
		public static const NINJASTATE_EXITING:int = 4;
		public static const NINJASTATE_JUST_HIT:int = 5;
		public static const NINJASTATE_LOOKAROUND:int = 6;
		public static const NINJASTATE_LEVELFAILED:int = 7;
		
		var flyingTimer:int;
		
		function NinjaForceReleaseSticky(b:Body)
		{
			if (b != stickyJointBody) return;
			RemoveStickyJoint();
			state = NINJASTATE_FLYING;
		}

		function RemoveStickyJoint()
		{
			if (stickyJoint != null)
			{
				PhysicsBase.GetNapeSpace().constraints.remove(stickyJoint);
				stickyJoint = null;
			}
		}
		
		var weaponPressed:Boolean = false;
		
		function UpdateNinja()
		{
			if (true)	//Game.usedebug)
			{
				if (KeyReader.Pressed(KeyReader.KEY_N))
				{
					GameVars.playerCharIndex++;
					if (GameVars.playerCharIndex >= 3) GameVars.playerCharIndex = 0;
					AnimDefinitions.ReInit(GameVars.playerCharIndex);
				}
			}
			
			
			if (invulnerableTimer > 0) invulnerableTimer--;
			
			var a:Number = dir;
			
			var mx:Number = MouseControl.x + Game.camera.x;
			var my:Number = MouseControl.y + Game.camera.y;
			var sx:Number = MouseControl.x;
			var sy:Number = MouseControl.y;
			

			var camScale:Number = Game.camera.PerspectiveTransformGetScale(camZ);
			
			
			var buttonDown:Boolean = false;
			
			if (PROJECT::isMobile)
			{
				weaponPressed = false;
//				if (MultiTouchHandler.TestAreaPressed(GameVars.touchRect_Weapon)) weaponPressed = true;

				if (weaponPressed)
				{
					MouseControl.buttonPressed = false;
				}
			}
			else
			{
				weaponPressed = false;
				if (KeyReader.Pressed(KeyReader.KEY_X))
				{
					weaponPressed = true;
				}
			}
			
			weaponPressed = false;
			if ( (Game.levelTimer % 50) == 0)
			{
				weaponPressed = true;
			}
			
			
			
			if (PROJECT::isMobile)
			{
			
				var scalex:Number = ScreenSize.fullScreenScale;
				var scaley:Number =  ScreenSize.fullScreenScale;	
				
				mx = ScreenSize.GetScaledMousePosX(MouseControl.x);
				my = ScreenSize.GetScaledMousePosY(MouseControl.y);
				
				sx = mx;
				sy = my;
				
				mx += Game.camera.x;
				my += Game.camera.y;
			}
			
			if (PROJECT::isGamePad)
			{
				var controlX:GameInputControl = MobileSpecific.pad0.getControlAt(0);
				var controlY:GameInputControl = MobileSpecific.pad0.getControlAt(1);
				
				var sc:Number = 200;
				mx = controlX.value * sc;
				my = controlY.value * sc;

				mx += xpos;
				my += ypos;
				
				var controlJump:GameInputControl = MobileSpecific.pad0.getControlAt(14);
				if (controlJump.value > 0.5) buttonDown = true;
			}

			
			
			if (weaponPressed)
			{
				if (GameVars.currentAmmo != 0)
				{
					if (GameVars.currentWeapon == 1)
					{
						PhysicsBase.AddPhysObjAt("weapon_1", xpos, ypos, 0, 1);
					}
					if (GameVars.currentWeapon == 2)
					{
						PhysicsBase.AddPhysObjAt("weapon_2", xpos, ypos, 0, 1);
					}
					if (GameVars.currentWeapon == 3)
					{
						PhysicsBase.AddPhysObjAt("weapon_3", xpos, ypos, 0, 1);
					}
					
					GameVars.currentAmmo--;
					if (GameVars.currentAmmo <= 0)
					{
						GameVars.currentWeapon = -1;
					}
				}
			}
			
			//Game.RenderBallPath_calcPositions
			
			var dx:Number;
			var dy:Number;

			dx = xpos - mx;	// (mx) - xpos;
			dy = ypos - my;	// (my) - ypos;

			var kick_dist0:Number = Vars.GetVarAsNumber("kick_dist0_"+GameVars.playerCharIndex);
			var kick_dist1:Number = Vars.GetVarAsNumber("kick_dist1_"+GameVars.playerCharIndex);
			var kick_power0:Number = Vars.GetVarAsNumber("kick_power0_"+GameVars.playerCharIndex);
			var kick_power1:Number = Vars.GetVarAsNumber("kick_power1_"+GameVars.playerCharIndex);
			
			var dist:Number = Utils.DistBetweenPoints(0, 0, dx, dy);
			
			ballLaunch_dist = dist;
			var spd:Number = Utils.ScaleToPreLimit(kick_power0,kick_power1, kick_dist0,kick_dist1,dist);
			
			ballLaunch_vec.SetFromDxDy(dx, dy);
			ballLaunch_vec.speed = spd;
			
			
			if (state == NINJASTATE_JUST_HIT)
			{
				animPlayer.Set("player_idle", true);
//				SetAnim("player_a_idle", true, true);			
				
				var r:int = Utils.RandBetweenInt(1, 3);
				SFX_OneShot("sfx_hit_sticky_" + r);

				
				var jb0:Body = nape_bodies[0];
				var jb1:Body = stickyJointBody;
				
				stickyJoint = new WeldJoint(jb0, jb1 ,
						jb0.worldPointToLocal( new Vec2(stickyJointContactPointX,stickyJointContactPointY)),
						jb1.worldPointToLocal(new Vec2(stickyJointContactPointX,stickyJointContactPointY)),jb1.rotation-jb0.rotation);
				PhysicsBase.GetNapeSpace().constraints.add(stickyJoint);
				
				var aa:Number = jb1.rotation - jb0.rotation;
				//trace(aa);
				
				if (canRestartHere)
				{
					sticky_staticX = xpos;
					sticky_staticY = ypos;
					sticky_staticAngle = sticky_stickAngle;
					sticky_staticJointBody = stickyJointBody;
				}
				
				sticky_bodyAngleWhenHit = nape_bodies[0].rotation;
				
				sticky_bodyAngleWhenHitOffset = sticky_stickAngle - sticky_bodyAngleWhenHit;
				
				trace("sticky_bodyAngleWhenHit " + sticky_bodyAngleWhenHit);
				trace("sticky_bodyAngleWhenHitOffset " + sticky_bodyAngleWhenHitOffset);
				
				//stickyJoint = new DistanceJoint(jb0, jb1 ,
				//		jb0.worldPointToLocal( stickyJointContactPoint.position),
				//		jb1.worldPointToLocal(stickyJointContactPoint.position), 0, 0);
				//PhysicsBase.GetNapeSpace().constraints.add(stickyJoint);						

				state = NINJASTATE_STATIC;
				
//				SetBodyAngularVelocity(0, 0);
//				SetBodyLinearVelocity(0, 0, 0);
				
				animPlayer.CycleAnimation();

			}
			if (state == NINJASTATE_STATIC)
			{
				var isClose:Boolean = false;
				if (Utils.DistBetweenPoints(xpos, ypos, mx, my) < 100) isClose = true;
				var down:Boolean = false;
				
				
				if (PROJECT::isGamePad)
				{
					if (buttonDown)
					{
						down = true;
					}
				}
				else
				{				
					if (MouseControl.buttonPressed)		// do the kick
					{
						down = true;
					}
				}
				
				if (animPlayer.CycleAnimation())
				{
					if (Utils.RandBetweenInt(0, 100) < 10)
					{
						animPlayer.Set("player_look", false);
					}
					else
					{
						animPlayer.Set("player_idle", false);
					}
				}
				

				if (down)
				{
					if (isClose)
					{
						state = NINJASTATE_DRAGGING;
						animPlayer.Set("player_charge", false);
					}
					else
					{
						state = NINJASTATE_LOOKAROUND;
						startx = sx;
						starty = sy;
						Game.camera.dragStartX = Game.camera.x;
						Game.camera.dragStartY = Game.camera.y;
						animPlayer.Set("player_look", false);
					}

				}
				
				
			}
			else if (state == NINJASTATE_LOOKAROUND)
			{
				var down:Boolean = false;
				if (PROJECT::isGamePad)
				{
					if (buttonDown) down = true;
				}
				else
				{
					if (MouseControl.buttonPressed) down = true;
				}
				var dx:Number = sx - startx;
				var dy:Number = sy - starty;
				Game.cameraDragZoom = 100;		// just click and hold to zoom out
				
//				 Game.camera.x = Game.camera.dragStartX - dx;
//				 Game.camera.y = Game.camera.dragStartY-  dy;
				//trace(Game.cameraDragZoom );
				
				if (down == false)
				{
					state = NINJASTATE_STATIC;
				}
				
				animPlayer.CycleAnimation();

			}
			else if (state == NINJASTATE_DRAGGING)
			{
				var doFlick:Boolean = false;
				if (PROJECT::isGamePad)
				{
					if (buttonDown == false) doFlick = true;
				}
				else
				{
					if (MouseControl.buttonPressed == false) doFlick = true;
				}
				
				if (doFlick)		// do the kick
				{
					state = NINJASTATE_DRAGGING;
					
					
					var r:int = Utils.RandBetweenInt(1, 3);
					SFX_OneShot("sfx_launch" + r);

					RemoveStickyJoint();
					
					PhysicsSetMovable();
					SetBodyAngularVelocity(0, 0);
					SetBodyLinearVelocity(0, 0, 0);
					ApplyImpulse(ballLaunch_vec.X(), ballLaunch_vec.Y());
					state = NINJASTATE_FLYING;
					flyingTimer = 0;
					
					GameVars.ResetCombo();
					GameVars.numLevelFlicks++;

				}
				animPlayer.CycleAnimation();

				
			}
			else if (state == NINJASTATE_FLYING)
			{
				
				flyingTimer++;
				var lv:Vec2 = GetBodyLinearVelocity(0);
				
				
				if (Math.abs(lv.x) > (Math.abs(lv.y)+30) )
				{
					if (lv.x > 0)
					{
						animPlayer.Set("player_fly_right", false);
					}
					else
					{
						animPlayer.Set("player_fly_left", false);
					}
				}
				else
				{
					if (lv.y < 0)
					{
						animPlayer.Set("player_fly_up", false);
					}
					else
					{
						animPlayer.Set("player_fly_down", false);
					}
					
				}
				animPlayer.CycleAnimation();

				
				if (Game.boundingRectangle.contains(xpos, ypos) ==  false)
				{
					NinjaDead();
				}
				
			}
			else if (state == NINJASTATE_EXITING)
			{
				GameVars.reachedExit = true;
				
				xpos1 += (toPosX - xpos1) * 0.2;
				ypos1 += (toPosY - ypos1) * 0.2;
				xpos = xpos1;
				ypos = ypos1;
				scale -= 0.005;
				if (scale <= 0.1) scale = 0.1;
				animPlayer.CycleAnimation();

			}
			else if (state == NINJASTATE_DEAD)
			{
				RemoveStickyJoint();
//				visible = false;
//				if ( timer & 1) visible = true;
				timer--;
				if (timer <= 0)
				{
					if (GameVars.lives <= 0)
					{
						SFX_OneShot("sfx_player_die");

						Game.levelFailReason = "lives";
						Game.levelSuccessFlag = false;
						Game.InitLevelState(Game.levelState_Complete);
						state = NINJASTATE_LEVELFAILED;
						return;
						
					}
					
					nape_bodies[0].rotation = dir = sticky_staticAngle;
					xpos = sticky_staticX;
					ypos = sticky_staticY;
					stickyJointBody = sticky_staticJointBody;
					
				
					SetBodyXForm_Immediate(0, xpos, ypos, dir);
					state = NINJASTATE_JUST_HIT;
					visible = true;
					timer = 0;
					updateFromPhysicsFunction = null;
					
					SetBodyAngularVelocity(0, 0);
					SetBodyLinearVelocity(0, 0, 0);
					
					SetBodyCollisionMask(0, 15);
					
					invulnerableTimer = Defs.fps * 2;

					
				}
				animPlayer.CycleAnimation();

			}
			else if (state == NINJASTATE_LEVELFAILED)
			{
				animPlayer.CycleAnimation();
			}
			
		}
		
		
		function NinjaDead()
		{
			
			var r:int = Utils.RandBetweenInt(1, 2);
			SFX_OneShot("sfx_ninja_die" + r);
			
			state = NINJASTATE_DEAD;
			animPlayer.Set("player_dead");
			
			SetBodyCollisionMask(0, 0);

//			updateFromPhysicsFunction = UpdatePhysicsNull;
			timer = Defs.fps;
			
			
			GameVars.lives--;
		}
		
		function OnHitNinjaExplosion(force:Vec)
		{
			ApplyImpulse(force.X(), force.Y());
			NinjaDead();
		}
		function OnHitNinjaPersist(goHitter:GameObj)
		{
			if (Game.levelState == Game.levelState_Complete) return;
			if (goHitter == null) return;
			if (state != NINJASTATE_FLYING) return;
			
			if (flyingTimer < 2) return;
			
			
			if (goHitter.collisionType == "sticky")
			{

				if (hitContactPoint_Nape != null)
				{
					var jb0:Body = nape_bodies[0];
					var jb1:Body = goHitter.nape_bodies[0];

					stickyJointBody = jb1;
					state = NINJASTATE_JUST_HIT;
					stickyJointContactPoint = hitContactPoint_Nape;
					
					stickyJointContactPointX = stickyJointContactPoint.position.x;
					stickyJointContactPointY = stickyJointContactPoint.position.y;
					
					sticky_stickAngle = stickyJointContactPoint.arbiter.normal.angle -(Math.PI / 2);
					sticky_stickAngle = Math.atan2(stickyJointContactPointY - ypos, stickyJointContactPointX - xpos) -(Math.PI / 2);
					
					sticky_stickAngleOffset = sticky_stickAngle;
					
					canRestartHere = goHitter.canRestartHere;
				}
			}
			
		}
		function OnHitNinja(goHitter:GameObj)
		{
			if (Game.levelState == Game.levelState_Complete) return;
			if (goHitter == null) return;
			
			

			if (state == NINJASTATE_DEAD)
			{
				return;
			}
			
			
			if (goHitter.collisionType == "death")
			{
				if (invulnerableTimer == 0)
				{
					NinjaDead();
					return;
				}
			}			
			if (goHitter.name == "exit")
			{
				if (goHitter.IsExitOpen())
				{
					SFX_OneShot("sfx_exit_enter");
//					SoundPlayer.Play("sfx_exit_enter");
					state = NINJASTATE_EXITING;
					toPosX = goHitter.xpos;
					toPosY = goHitter.ypos;
					xpos1 = xpos;
					ypos1 = ypos;
					SetBodyCollisionMask(0, 0);
					updateFromPhysicsFunction = UpdatePhysicsNull;
					onHitFunction = null;
					onHitPersistFunction = null;
					animPlayer.Set("player_exit");
					
				}
			}
			
		}
		
		var sticky_bodyAngleWhenHit:Number = 0;
		var sticky_bodyAngleWhenHitOffset:Number = 0;
		var ninjaDisplayAngle:Number = 0;
		var sticky_staticX:Number = 0;
		var sticky_staticY:Number = 0;
		var sticky_staticAngle:Number = 0;
		var sticky_stickAngle:Number = 0;
		var sticky_stickAngleOffset:Number = 0;
		var sticky_staticJointBody:Body;
		var stickyJointContactPointX:Number = 0;
		var stickyJointContactPointY:Number = 0;
		var stickyJointContactPoint:Contact = null;
		var stickyJointBody:Body;
		var stickyJoint:WeldJoint;
		var ballLaunch_vec:Vec;
		var ballLaunch_dist:Number;
		var stuck_renderDir:Number = 0;
		
		function RenderNinja()
		{
			var a:Number = dir;
			var xx:Number = xpos;
			var yy:Number = ypos;
			
			if (state == NINJASTATE_STATIC || state == NINJASTATE_DRAGGING)
			{
				dir = ninjaDisplayAngle;
				
//				trace("sticky_bodyAngleWhenHit " + sticky_bodyAngleWhenHit);
//				trace("sticky_bodyAngleWhenHitOffset " + sticky_bodyAngleWhenHitOffset);
				
				dir = nape_bodies[0].rotation + sticky_bodyAngleWhenHitOffset;
				
				gpoint.x = 0;
				gpoint.y = -10;
				gmat.identity();
				gmat.rotate(dir);
				gpoint = gmat.transformPoint(gpoint);
				xpos += gpoint.x;
				ypos += gpoint.y;
				
			}
			else
			{
				dir = 0;
			}
			
			
			if ((invulnerableTimer % 4) == 0)
			{
				RenderDispObjNormally();
			}
			
			xpos = xx;
			ypos = yy;

			
			
//			var cx:Number = stickyJointContactPointX;
//			var cy:Number = stickyJointContactPointY;			
//			Utils.RenderCircle(bd, cx - Game.camera.x, cy - Game.camera.y, 2, 0xffffffff);
//			Utils.RenderCircle(bd, cx - Game.camera.x, cy - Game.camera.y, 10, 0xffffffff);

		}
		
		var invulnerableTimer:int;

		function InitNinja()
		{
			invulnerableTimer = 0;
			stickyJoint = null;
			GameVars.playerGO = this;
			ballLaunch_vec = new Vec();
			name = "player";
			renderFunction = RenderNinja;
			updateFunction = UpdateNinja;
			onHitFunction = OnHitNinja;
			onHitPersistFunction = OnHitNinjaPersist;
			onHitExplosionFunction = OnHitNinjaExplosion;

			
//			scale = 1;
			state = NINJASTATE_FLYING;
			
			nape_bodies[0].isBullet = true;

			frameVel = 0.2;
			
			
			animPlayer = new AnimPlayer(this);
			animPlayer.Set("player_idle", true);

			
			var go:GameObj = GameObjects.AddObj(xpos, ypos, zpos - 100);
			go.InitNinjaInFront(this);
			
			if (Missions.currentMissionIndex == 0 && Missions.currentMissionLevelIndex == 0)
			{				
				var go:GameObj = GameObjects.AddObj(xpos, ypos, zpos - 200);
				go.InitNinjaHelp(this);
			}
			
		}
		var animPlayer:AnimPlayer;

		
		function RenderNinjaInFront()
		{
				Game.ballpath_doit = true;
			if (parentObj.state == NINJASTATE_DRAGGING)
			{
				var sc:Number = Utils.ScaleToPreLimit(1, 2, 200, 500, parentObj.ballLaunch_vec.speed);
				//var dob:DisplayObj = GraphicObjects.GetDisplayObjByName("ui_cursor_arrow");
				//RenderDispObjAt(xpos, ypos, dob, 0,null,ballLaunch_vec.rot+(Math.PI*0.5),sc);

				Game.ballpath_dx = parentObj.ballLaunch_vec.X();
				Game.ballpath_dy = parentObj.ballLaunch_vec.Y();
				Game.ballpath_mass = parentObj.GetBodyMass(0);
				
				Game.RenderBallPath(bd, xpos, ypos , Game.ballpath_dx, Game.ballpath_dy);
				
				RenderDispObjAt(xpos, ypos, dobj, 0);
				
			}
			Game.ballpath_doit = false;
			
			if (true)	//parentObj.state != NINJASTATE_DRAGGING)
			{
				if (GameVars.exitIsOpen)
				{
					var xx:Number = xpos;
					var yy:Number = ypos-100;
					var dx:Number = GameVars.exitGO.xpos - xx;
					var dy:Number = GameVars.exitGO.ypos - yy;
					if (Utils.DistBetweenPoints(0, 0, dx, dy) > 200)
					{
						if ((Game.levelTimer & 8) == 0)
						{
							movementVec.SetFromDxDy(dx ,dy);
							
							movementVec.speed = 40;
							RenderDispObjAt(xx + movementVec.X(), yy + movementVec.Y(), dobj1,0,null,movementVec.rot+Math.PI/2);
							
							RenderDispObjAt(xx, yy, dobj2, 0);
						}
					}
				}
			}
		
		}
		function UpdateNinjaInFront()
		{
			xpos = parentObj.xpos;
			ypos = parentObj.ypos;
		}
		function InitNinjaInFront(_parent:GameObj)
		{
			parentObj = _parent;
			updateFunction = UpdateNinjaInFront;
			renderFunction = RenderNinjaInFront;
			dobj = GraphicObjects.GetDisplayObjByName("ui_cursor");
			dobj1 = GraphicObjects.GetDisplayObjByName("obj_exit_arrow");
			dobj2 = GraphicObjects.GetDisplayObjByName("obj_exit_arrow_icon");
		}
		
//-----------------------------------------------------------------------------------------------------------------

		function RenderNinjaHelp()
		{
			RenderDispObjNormally();
			
			
			var sc:Number = 1 + (Math.cos(timer * 0.1) * 0.1);
			if (frame1 == 1)
			{
				RenderDispObjAt(xpos, ypos - 90, dobj, frame1, null, 0, sc);
			}
			else
			{
				RenderDispObjAt(xpos-90, ypos + 170, dobj, frame1, null, 0, sc);
			}
		}
		function UpdateNinjaHelp()
		{
			xpos = parentObj.xpos;
			ypos = parentObj.ypos;
			timer++;
			
			if (parentObj.state == NINJASTATE_DRAGGING)
			{
				frame1 = 2;
			}
			if (frame1 == 2)
			{
				if (parentObj.state == NINJASTATE_FLYING)
				{
					RemoveObject();
				}
			}
			
		}
		function InitNinjaHelp(_parent:GameObj)
		{
			parentObj = _parent;
			updateFunction = UpdateNinjaHelp;
			renderFunction = RenderNinjaHelp;
			dobj = GraphicObjects.GetDisplayObjByName("Help1");
			frame1 = 1;
		}


//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
		
		function UpdateEnemyJetpack()
		{
			movementVec.Set(dir-(Math.PI/2), speed);
			speed += 0.3;
			if (speed > 10) speed = 10;
			xpos += movementVec.X();
			ypos += movementVec.Y();
			timer--;
			if (timer <= 0)
			{
				RemoveObject();
			}
			
			timer1++;
			var amt:Number = Utils.ScaleToPreLimit( 0,0.5, 0, 50, timer1);
			dir += Utils.RandBetweenFloat( -amt, amt);
			
			frame = dobj.GetRandomFrame();
			
		}
		function InitEnemyJetpack(_dir:Number)
		{
			updateFunction = UpdateEnemyJetpack;
			dobj = GraphicObjects.GetDisplayObjByName("enemy_jetpack");
			speed = 0;
			dir = _dir;
			frame = 0;
			timer = 200;
			timer1 = 0;
		}

//--------------------------------------------------------------------------------------------

		function RenderEnemy()
		{
			if (dobj1 != null)
			{
				RenderDispObjAt(xpos, ypos, dobj1, dobj1.GetRandomFrame(), null, dir, scale);
			}
			RenderDispObjNormally();
		}
		function InitEnemyEasyFly()
		{
			InitEnemyEasy();
			animPlayer.Set("enemy_a_fly");
			state = 1;
			xpos1 = xpos;
			ypos1 = ypos;
			timer = 0;
			dobj1 = GraphicObjects.GetDisplayObjByName("enemy_jetpack");

		}
		function InitEnemyEasy()
		{
			score = GameVars.SCORE_ENEMY1;
			GameVars.totalEnemies++;
			name = "enemy_easy";
			colFlag_isEnemy = true;
			renderFunction = RenderEnemy;
			updateFunction = UpdateEnemyEasy;
			onHitFunction = OnHitEnemyEasy;
			state = 0;
			timer = Utils.RandBetweenInt(50, 200);
			animPlayer = new AnimPlayer(this);
			animPlayer.Set("enemy_a_idle");
			dobj1 = null;
			onHitExplosionFunction = OnHitEnemyExplosion;

			
		}
		function OnHitEnemyEasy(hitterGO:GameObj)		
		{			
			if (hitterGO == null) return;
			if (state >= 100) return;
			if (hitterGO.collisionType == "death" || hitterGO.name == "player" || hitterGO.name == "playermissile" || hitterGO.name == "car")
			{
				if (state == 1)
				{
					nape_bodies[0].type = BodyType.DYNAMIC;
					nape_bodies[0].velocity = hitterGO.nape_bodies[0].velocity;
					GameObjects.AddObj(xpos, ypos, zpos+1).InitEnemyJetpack(dir);
				}
				GameVars.numEnemiesKilled++;
				if (hitterGO.name == "car") 
				{
					GameVars.numEnemiesKilledByVehicle++;
					score = GameVars.SCORE_ENEMY_VEHICLE;
				}
				if (hitterGO.name == "playermissile") GameVars.numEnemiesShurikenKilled++;
				
				state = 100;
				timer = Defs.fps;
				onHitFunction = null;
				animPlayer.Set("enemy_a_hit");
				SetBodyCollisionMask(0,0);		// remove ninja collision and missile collision
				
				EnemyKilled();
			}			
		}

		function EnemyKilled()
		{
			SFX_OneShot("sfx_hit_enemy");
			Particles.Add(xpos, ypos).InitPow();
			GameVars.IncrementComboAndAddCoins(this);
			GameVars.AddScore(score);
			if (GameVars.comboCounter >= 2)
			{
				GameVars.numEnemiesComboKilled++;
			}
			else
			{
				GameVars.numEnemiesNonComboKilled++;
			}
		}
		
		
		function UpdateEnemyEasy()
		{
			if (state == 0)
			{
				var looped:Boolean = animPlayer.CycleAnimation();
				timer--;
				if (timer <= 0)
				{
					timer = 0;
					if (looped)
					{
						animPlayer.SetRandom("enemy_a_idle", "enemy_a_idle_lookleft", "enemy_a_idle_lookright");
						timer = Utils.RandBetweenInt(50, 200);
					}
				}
			}
			
			if (state == 1)
			{
				// fly
				var looped:Boolean = animPlayer.CycleAnimation();
				timer--;
				if (timer <= 0)
				{
					toPosX = xpos1 + Utils.RandBetweenFloat( -30, 30);
					toPosY = ypos1 + Utils.RandBetweenFloat( -30, 30);
					timer = Utils.RandBetweenInt(30, 70);
				}
				xvel = (toPosX - xpos) * 0.05;
				yvel = (toPosY - ypos) * 0.05;
				xpos += xvel;
				ypos += yvel;
				
				dir = (toPosX - xpos) * 0.01;
				
//				xpos = xpos1 + Utils.RandBetweenFloat( -30, 30);
//				ypos = ypos1 + Utils.RandBetweenFloat( -30, 30);
				SetBodyXFormDynamic(0, xpos, ypos,dir);
			}
			
			
			if (state == 100)
			{
				state = 101;
			}
			if (state == 101)
			{
				animPlayer.PlayAnimation();
				alpha -= 0.01;
				if (alpha <= 0)				
				{
					alpha = 0;
					RemoveObject(RemovePhysObj);
				}
			}
		}

//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				
		

		function InitEnemyHardFly()
		{
			InitEnemyHard();
			animPlayer.Set("enemy_b_fly");
			state = 1;
			xpos1 = xpos;
			ypos1 = ypos;
			timer = 0;
			dobj1 = GraphicObjects.GetDisplayObjByName("enemy_jetpack");

		}

		function UpdateEnemyHard()
		{
			if (state == 0)
			{
				var looped:Boolean = animPlayer.CycleAnimation();
				timer--;
				if (timer <= 0)
				{
					timer = 0;
					if (looped)
					{
						animPlayer.SetRandom("enemy_b_idle", "enemy_b_idle_lookleft", "enemy_b_idle_lookright");
						timer = Utils.RandBetweenInt(50, 200);
					}
				}
			}
			
			if (state == 1)
			{
				// fly
				var looped:Boolean = animPlayer.CycleAnimation();
				timer--;
				if (timer <= 0)
				{
					toPosX = xpos1 + Utils.RandBetweenFloat( -30, 30);
					toPosY = ypos1 + Utils.RandBetweenFloat( -30, 30);
					timer = Utils.RandBetweenInt(30, 70);
				}
				xvel = (toPosX - xpos) * 0.05;
				yvel = (toPosY - ypos) * 0.05;
				xpos += xvel;
				ypos += yvel;
				
				dir = (toPosX - xpos) * 0.01;
				
//				xpos = xpos1 + Utils.RandBetweenFloat( -30, 30);
//				ypos = ypos1 + Utils.RandBetweenFloat( -30, 30);
				SetBodyXFormDynamic(0, xpos, ypos,dir);
			}


			if (state == 100)
			{
				state = 101;
			}
			if (state == 101)
			{
				alpha -= 0.02;
				if (alpha <= 0)				
				{
					alpha = 0;
					RemoveObject(RemovePhysObj);
				}
			}
		}
		
		
		function OnHitEnemyExplosion(force:Vec)
		{
			if (state >= 100) return;
			GameVars.numEnemiesKilled++;
			state = 100;
			timer = Defs.fps;
			onHitFunction = null;
			if(animPlayer.def.name.search("_a_")!=-1) animPlayer.Set("enemy_a_hit");
			if(animPlayer.def.name.search("_b_")!=-1) animPlayer.Set("enemy_b_hit");
			if(animPlayer.def.name.search("_c_")!=-1) animPlayer.Set("enemy_c_hit");
			SetBodyCollisionMask(0,0);		// remove ninja collision and missile collision			
			EnemyKilled();
			
			var v:Vec2 = new Vec2(force.X(), force.Y());
			nape_bodies[0].applyImpulse(v);

			
		}
		function InitEnemyHard()
		{
			score = GameVars.SCORE_ENEMY2;
			GameVars.totalEnemies++;
			name = "enemy_hard";
			colFlag_isEnemy = true;
			renderFunction = RenderEnemy;
			updateFunction = UpdateEnemyHard;
			onHitFunction = OnHitEnemyHard;
			state = 0;
			animPlayer = new AnimPlayer(this);
			animPlayer.Set("enemy_b_idle");
			dobj1 = null;
			onHitExplosionFunction = OnHitEnemyExplosion;
		}

		function OnHitEnemyHard(hitterGO:GameObj)		
		{
			if (hitterGO == null) return;
			
			if (state == 1)
			{
				nape_bodies[0].type = BodyType.DYNAMIC;
				nape_bodies[0].velocity = hitterGO.nape_bodies[0].velocity;
				GameObjects.AddObj(xpos, ypos, zpos + 1).InitEnemyJetpack(dir);
				state = 0;
				animPlayer.Set("enemy_b_idle");			
				dobj1 = null;
			}				
			
			if (hitterGO.collisionType == "death" || hitterGO.name == "playermissile" || hitterGO.name == "car")
			{
				GameVars.numEnemiesKilled++;
				if (hitterGO.name == "car") 
				{
					GameVars.numEnemiesKilledByVehicle++;
					score = GameVars.SCORE_ENEMY_VEHICLE;
				}
				if (hitterGO.name == "playermissile") GameVars.numEnemiesShurikenKilled++;
				state = 100;
				timer = Defs.fps;
				onHitFunction = null;
				animPlayer.Set("enemy_b_hit");
				SetBodyCollisionMask(0,0);		// remove ninja collision and missile collision
				
				EnemyKilled();
			}
		}		

//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				
		
		function UpdateEnemyDeadly()
		{
				var looped:Boolean = animPlayer.CycleAnimation();
				timer--;
				if (timer <= 0)
				{
					timer = 0;
					if (looped)
					{
						animPlayer.SetRandom("enemy_c_idle", "enemy_c_idle_lookleft", "enemy_c_idle_lookright");
						timer = Utils.RandBetweenInt(50, 200);
					}
				}

			
			if (state == 100)
			{
				state = 101;
			}
			if (state == 101)
			{
				alpha -= 0.02;
				if (alpha <= 0)				
				{
					alpha = 0;
					RemoveObject(RemovePhysObj);
				}
			}
		}
		
		
		function InitEnemyDeadly()
		{
			score = GameVars.SCORE_ENEMY3;
			collisionType = "death";
			GameVars.totalEnemies++;
			name = "enemy_deadly";
			colFlag_isEnemy = true;
			updateFunction = UpdateEnemyDeadly;
			onHitFunction = OnHitEnemyDeadly;
			state = 0;
			animPlayer = new AnimPlayer(this);
			animPlayer.Set("enemy_c_idle");
			onHitExplosionFunction = OnHitEnemyExplosion;

		}

		function OnHitEnemyDeadly(hitterGO:GameObj)		
		{
			if (hitterGO == null) return;
			if (hitterGO.collisionType == "death" || hitterGO.name == "playermissile" || hitterGO.name == "car")
			{
				GameVars.numEnemiesKilled++;
				if (hitterGO.name == "car") 
				{
					GameVars.numEnemiesKilledByVehicle++;
					score = GameVars.SCORE_ENEMY_VEHICLE;
				}
				if (hitterGO.name == "playermissile") GameVars.numEnemiesShurikenKilled++;
				state = 100;
				timer = Defs.fps;
				onHitFunction = null;
				animPlayer.Set("enemy_c_hit");
				SetBodyCollisionMask(0,0);		// remove ninja collision and missile collision

				EnemyKilled();
			}
		}		


//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				


//-----------------------------------------------------------------------------------------------------------				
//-----------------------------------------------------------------------------------------------------------				

		
		public function UpdateScoreOverlay():void
		{
			if(PlayAnimation())
			{
				RemoveObject();
			}
		}
		public function InitScoreOverlay(_score:int):void
		{
			textMessage = _score.toString();
			updateFunction = UpdateScoreOverlay;
			frame = 0;
			frameVel = 1;
			dobj = GraphicObjects.GetDisplayObjByName("score_general");		
		}

		var scaleVel:Number;
		var scaleAcc:Number;
		var scaleMax:Number;

//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------

		function InitPhysObj_Sticky_CanRestart()
		{
			collisionType = "sticky";
			canRestartHere = true;
		}
		
		
		function OnHitSticky(goHitter:GameObj)
		{
			if (goHitter == null) return;
		}
		function InitPhysObj_Sticky()
		{
			collisionType = "sticky";
			onHitFunction = OnHitSticky;
		}

		function InitPhysObj_Death()
		{
			collisionType = "death";
		}

		function UpdatePhysObj_Animated_Death()
		{
			CycleAnimation();
		}
		function InitPhysObj_Animated_Death()
		{
			frameVel = 0.5;
			updateFunction = UpdatePhysObj_Animated_Death;
			collisionType = "death";
		}
		
		function InitPhysObj_StickyNinja_SwitchOnce()
		{
			InitSwitch_Once();
			collisionType = "sticky";
		}
		
//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------

		function UpdatePhysObj_Exit()
		{
			
			
			if (frame == 0)
			{
				if(Missions.GetCurrentMissionLevel().TestPass())
				{
					SFX_OneShot("sfx_exit_open");
					GameVars.exitIsOpen = true;
					frame = 1;
				}
				
			}
		}
		
		function IsExitOpen():Boolean
		{
			return (frame == 1);
		}
		function Render_Exit()
		{
			
			dir1 += 0.04;
			timer += 0.03;
			scale1 = 1.2 + (Math.cos(timer) * 0.2);
			RenderDispObjAt(xpos, ypos, dobj2, 0, null, 0, 1);
			RenderDispObjAt(xpos, ypos, dobj1, 0, null, dir1, scale1);

			RenderDispObjNormally();
			
		}
		function InitExit()
		{
			GameVars.exitIsOpen = false;
			
			if (Missions.GetCurrentMissionLevel().IsDoorAlwaysOpen())
			{
				frame = 1;
				GameVars.exitIsOpen = true;
			}

			GameVars.exitGO = this;
			name = "exit";
			renderFunction = Render_Exit;
			onHitFunction = OnHit_Exit;
			updateFunction = UpdatePhysObj_Exit;
			state = 0;
			renderShadowFlag = true;
			
			dobj1 = GraphicObjects.GetDisplayObjByName("obj_exit_anim");
			dobj2 = GraphicObjects.GetDisplayObjByName("obj_exit_back");
			dir1 = 0;
			
		}

		function OnHit_Exit(hitterGO:GameObj)		
		{
			
		}		


//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------

		function SwitchSwitchedBlock()
		{
			RemoveObject(RemovePhysObj);
		}
		function InitSwitchedBlock()
		{
			switchFunction = SwitchSwitchedBlock;
		}

//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------


		function UpdateKite()
		{
			ApplyForce(0, -kite_force);
			LimitVelocity_Nape(kite_max_speed);
		}
		var kite_max_speed:Number;
		var kite_force:Number;
		function InitKite()
		{
			Utils.GetParams(initParams);			
			kite_force = Utils.GetParamNumber("kite_force");			
			kite_max_speed = Vars.GetVarAsNumber("kite_max_speed");
			
			updateFunction = UpdateKite;
		}


//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------

		public function OnHitWeaponPickup(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			if (goHitter.name == "player")
			{
				if (state != 0) return;
				SFX_OneShot("sfx_powerup");
				GameVars.currentWeapon = type;
				GameVars.currentAmmo = 10;
				state = 1;
				timer = Defs.fps * 10;
				onHitFunction = null;
				visible = false;
			}
		}

		function UpdateWeaponPickup()
		{
			CycleAnimation();
			if (state == 1)
			{
				timer--;
				if (timer <= 0)
				{
					visible = true;
					onHitFunction = OnHitWeaponPickup;
					state = 0;
				}
			}
		}
		function InitWeaponPickup()
		{
			type = int(physobj.initFunctionParameters);
 			onHitFunction = OnHitWeaponPickup;
 			updateFunction = UpdateWeaponPickup;
			state = 0;
			frameVel = 0.2;
			starty = ypos;
		}

//-----------------------------------------------------------------------------------------------------------------

		public function OnHitLifePickup(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			if (goHitter.name == "player")
			{
				if (state != 0) return;
				SFX_OneShot("sfx_powerup");
				GameVars.lives++;
				RemoveObject(RemovePhysObj);
			}
		}

		function UpdateLifePickup()
		{
			CycleAnimation();
		}

		function InitLifePickup()
		{
 			onHitFunction = OnHitLifePickup;
 			updateFunction = UpdateLifePickup;
			state = 0;
		}

//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------

		function OnHitWeapon(goHitter:GameObj)
		{
			if (goHitter == null) return;
			
			RemoveObject(RemovePhysObj);
		}
		function RenderWeapon()
		{
			dir = dir1;
			RenderDispObjNormally();
		}
		function UpdateWeapon()
		{
			movementVec.SetFromDxDy(targetObj.xpos - xpos, targetObj.ypos - ypos);
			movementVec.speed = Utils.ScaleTo(0, 12, 0, timerMax, timer);
			timer++;
			
			xpos += movementVec.X();
			ypos += movementVec.Y();
			
			SetBodyXForm_Immediate(0, xpos, ypos, 0);
			
			timer--;
			if (timer <= 0)
			{
				RemoveObject(RemovePhysObj);
			}
			
			dir1 += 0.5;
		}
		function InitWeapon()
		{
			dir1 = Utils.RandCircle();
			name = "playermissile";
			updateFromPhysicsFunction = UpdatePhysicsNull;
			updateFunction = UpdateWeapon;
			onHitFunction = OnHitWeapon;
			renderFunction = RenderWeapon;
			timer = Defs.fps * 2;
			state = 0;
			
			var nearestGO:GameObj = null;
			var nearestD:Number = 99999;
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active && go.colFlag_isEnemy && go.state < 100)
				{
					var d:Number = Utils.DistBetweenPoints(xpos, ypos, go.xpos, go.ypos);
					if (d < nearestD)
					{
						nearestD = d;
						nearestGO = go;
					}
				}
			}
			if (nearestGO == null)
			{
				RemoveObject(RemovePhysObj);
				return;
			}
			
			targetObj = nearestGO;
			
			timer = timerMax = Defs.fps * 2;
			
			SFX_OneShot("sfx_shuriken");
			
		}

				
		
		
		public function OnHitStickyCrumbly(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			if (goHitter.name == "player")
			{
				state = 1;
				frame = 0;
				frameVel = 0.1;
			}
		}
		function UpdateStickyCrumbly()
		{
			if (state == 1)
			{
				if (PlayAnimation())
				{
					// if player is attached to this
					GameVars.playerGO.NinjaForceReleaseSticky(nape_bodies[0]);
					
					RemoveObject(RemovePhysObj);
				}
			}
		}
		function InitStickyCrumbly()
		{
			collisionType = "sticky";
			onHitFunction = OnHitStickyCrumbly;
			updateFunction = UpdateStickyCrumbly;
		}
		
		
//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------

		public function OnHitTreasurePickup(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			if (goHitter.name == "player")
			{
				SFX_OneShot("sfx_treasure");
				GameVars.numTreasureCollected++;
				RemoveObject(RemovePhysObj);
				GameVars.IncrementCombo(this);
				GameVars.AddScore(score);
			}
		}
		function UpdateTreasurePickup()
		{
			CycleAnimation();
		}
		function InitTreasurePickup()
		{
			score = GameVars.SCORE_TREASURE;
			name = "treasure";
			GameVars.totalTreasure++;
			onHitFunction = OnHitTreasurePickup;
			updateFunction = UpdateTreasurePickup;
		}

//-----------------------------------------------------------------------------------------------------------------

		function OnHitCollidableAnimatedBouncy(goHitter:GameObj)
		{
			if (goHitter == null) return;
			if (state != 0) return;
			if (goHitter.name == "player")			
			{
				state = 1;
				scaleVel = Vars.GetVarAsNumber("bouncyanim_initvel");
				scaleAcc = Vars.GetVarAsNumber("bouncyanim_accel");
				GameVars.IncrementCombo(this);
				SFX_OneShot("sfx_hit_bouncy");
			}
		}
		function UpdateCollidableAnimatedBouncy()
		{
			if (state == 1)
			{
				scale += scaleVel;
				scaleVel += scaleAcc;
				if (scale <= 1)
				{
					scale = 1;
					state = 0;
				}				
			}
		}
		function InitCollidableAnimatedBouncy()
		{
			onHitFunction = OnHitCollidableAnimatedBouncy;
			updateFunction = UpdateCollidableAnimatedBouncy;
		}
//-----------------------------------------------------------------------------------------------------------------

		function UpdateSpawnedObject_Death()
		{
			CycleAnimation();
			timer--;
			if (timer <= 0)
			{
				RemoveObject(RemovePhysObj);
			}
		}
		function InitSpawnedObject_Death()
		{
			frameVel = 0.5;
			updateFunction = UpdateSpawnedObject_Death;
			collisionType = "death";
			timer = Defs.fps * 3;
		}

//-----------------------------------------------------------------------------------------------------------------

		function UpdateSpawnedObject_Fireball()
		{
			dir = nape_bodies[0].velocity.angle + (Math.PI * 0.5);
			CycleAnimation();
			timer--;
			if (timer <= 0)
			{
				RemoveObject(RemovePhysObj);
			}
		}
		function InitSpawnedObject_Fireball()
		{
			frameVel = 0.5;
			updateFunction = UpdateSpawnedObject_Fireball;
			collisionType = "death";
			timer = Defs.fps * 3;
		}

//-----------------------------------------------------------------------------------------------------------------

		function UpdateSpawnedObject_Shark()
		{
			dir = nape_bodies[0].velocity.angle + (Math.PI * 0.5);
			CycleAnimation();
			timer--;
			if (timer <= 0)
			{
				RemoveObject(RemovePhysObj);
			}
		}
		function InitSpawnedObject_Shark()
		{
			frameVel = 0.1;
			updateFunction = UpdateSpawnedObject_Shark;
			collisionType = "death";
			timer = Defs.fps * 3;
			
			zpos = GameLayers.GetZPosByName("Water") + 1;
		}

		
		
//-----------------------------------------------------------------------------------------------------------------

		function InitPhysObj_Car()
		{
			name = "car";
			collisionType = "sticky";
		}

//-----------------------------------------------------------------------------------------------------------------

		function SwitchHintPopup()
		{
			if (state ==1) 	// can switch off hints with multiple switches
			{
				state = 2;
				visible = false
				return;
			}
			state = 1;
			visible = true;
			
		}
		function UpdateHintPopup()
		{
			if (state == 0) return;
			
			timer1 += 0.04;
			timer2 += 0.056;
			xpos = startx + (Math.cos(timer1) * 7);
			ypos = starty + (Math.cos(timer2) * 6);
			
			
			timer--;
			if (timer <= 0)
			{
				RemoveObject();
			}
		}

		function InitHintPopup()
		{
			Utils.GetParams(initParams);			
			frame = Utils.GetParamNumber("hintpopup_frame", 1) - 1;
			if (frame < 0) frame = 0;
			
			visible = false;
			state = 0;
			updateFunction = UpdateHintPopup;
			switchFunction = SwitchHintPopup;
			dobj = GraphicObjects.GetDisplayObjByName("ui_separatetexture_hint_popup");
			
			
			var t:Number = Utils.GetParamNumber("hintpopup_timer");
			if (t == 0) t = 9999999;
			timer = Defs.fps * t;
			
			zpos = 1;
			startx = xpos;
			starty = ypos;
			
			timer1 = 0;
			timer2 = 0;
			
		}
//-----------------------------------------------------------------------------------------------------------------

		function RenderBladeDeath()
		{
			var d:Number = dir;
			dir = dir1;
			RenderDispObjNormally();
			dir = d;
		}
		function UpdateBladeDeath()
		{
			dir1 += 0.1;
		}
		function InitBladeDeath()
		{
			collisionType = "death";
			updateFunction = UpdateBladeDeath;
			renderFunction  = RenderBladeDeath;
			dir1 = Utils.RandCircle();
		}

//------------------------------------------------------------------------------------------------------------------

		function UpdateBarrelExplosion()
		{
			CycleAnimation();
			scaleVel += scaleAcc;
			scale += scaleVel;
			if (scale <= 0)
			{
				RemoveObject();
			}
		}
		function InitBarrelExplosion()
		{
			dobj = GraphicObjects.GetDisplayObjByName("fx_explosion");
			updateFunction = UpdateBarrelExplosion;
			frame = 0;
			timer = Defs.fps * 2;
			frameVel = 0.2;
			scaleVel = 0.2;
			scaleAcc = -0.01;
		}

//------------------------------------------------------------------------------------------------------------------


		function OnHitExplosiveBarrel(goHitter:GameObj)
		{
			if (goHitter.name != "player") return;
			timer = Defs.fps;
			state = 1;
			frame1 = 4;
			count = 5;
		}
		function UpdateExplosiveBarrel()
		{
			if (state == 1)
			{
				timer--;
				if (timer <= 0)
				{
					timer = Defs.fps;
					count--;
					frame1 = count-1;
					if (frame1 < 0) frame1 = 0;
					if (count <= 0)
					{
						// explode
						state = 2;
						timer = Defs.fps * 3;
						visible = false;
						
						RemovePhysObj();
						BarrelExplodeObjects();
						
						GameObjects.AddObj(xpos, ypos, zpos - 1).InitBarrelExplosion();
						SFX_OneShot("sfx_explosion");

					}
				}
			}
			else if (state == 2)
			{
				timer--;
				if (timer <= 0)
				{
					// regenerate by deleting this one
					// and adding a new one from the original level data
					Game.InitLevelObject(originalLevelEdObj);
					RemoveObject();
				}
			}
		}

		function BarrelExplodeObjects()
		{
			var barrel_force_min:Number = Vars.GetVarAsNumber("barrel_force_min");
			var barrel_force_max:Number = Vars.GetVarAsNumber("barrel_force_max");
			var barrel_radius_max:Number = Vars.GetVarAsNumber("barrel_radius_max");
			
			for each(var go:GameObj in GameObjects.objs)
			{
				if (go.active && go.onHitExplosionFunction != null)
				{
					var d:Number = Utils.DistBetweenPoints(xpos, ypos, go.xpos, go.ypos);
					if ( d < barrel_radius_max)
					{
						var force:Number = Utils.ScaleTo(barrel_force_max, barrel_force_min, 0, barrel_radius_max, d);
						movementVec.SetFromDxDy(go.xpos - xpos, go.ypos - ypos);
						movementVec.speed = force;
						
						go.onHitExplosionFunction(movementVec);
						 
						
					}
				}
			}
		}

		
		function RenderExplosiveBarrel()
		{
			RenderDispObjNormally();
			if (state == 1)
			{
				RenderDispObjAt(xpos, ypos - 50, dobj1, frame1);
			}
		}
		function InitExplosiveBarrel()
		{
			collisionType = "sticky";
			dobj1 = GraphicObjects.GetDisplayObjByName("obj_timer");
			updateFunction = UpdateExplosiveBarrel;
			renderFunction = RenderExplosiveBarrel;
			onHitFunction = OnHitExplosiveBarrel;
		}

//------------------------------------------------------------------------------------------------------------------

		function OnExplodeSticky_BarrelExplode(force:Vec)
		{
			
			var v:Vec2 = new Vec2(force.X(), force.Y());
			nape_bodies[0].applyImpulse(v);

			for each(var marker:EdObjMarker in physobj.markers.markers)
			{
				Particles.Add(xpos, ypos).InitBreakablePieceFromMarker(breakable_baseName,marker,dir);
			}
			
			RemoveObject(RemovePhysObj);
		}
		
		
		function InitSticky_BarrelExplode()
		{
			breakable_baseName = physobj.initFunctionParameters;			
			InitPhysObj_Sticky();
			onHitExplosionFunction = OnExplodeSticky_BarrelExplode;
		}
//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------

		function RenderChopper()
		{
			RenderDispObjNormally();
			RenderDispObjAt(xpos, ypos, dobj1, frame1,null,dir);
		}
		function UpdateChopper()
		{
			CycleAnimation1();
		}
		function InitChopper()
		{
			renderFunction = RenderChopper;
			updateFunction = UpdateChopper;
			dobj1 = GraphicObjects.GetDisplayObjByName("obj_chopper_blades");
			frame1 = 0;
			frameVel1 = 1;
		}


//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------

		function UpdateFlamingTorch()
		{
			var r:int = Utils.RandBetweenInt(0, 64);
			ct.redOffset = r;
			ct.greenOffset = r;
			ct.blueOffset = r;
		}
		function InitFlamingTorch()
		{
			updateFunction = UpdateFlamingTorch;
		}

//------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------

		var circlepath_radius:Number;
		var circlepath_ang:Number;
		var circlepath_startang:Number;
		var circlepath_angvel:Number;
		var circlepath_centreX:Number;
		var circlepath_centreY:Number;
		public function UpdatePathObjectCircular()
		{
			gmat.identity();
			gmat.rotate(circlepath_ang);
			gpoint.x = 0;
			gpoint.y = circlepath_radius;
			gpoint = gmat.transformPoint(gpoint);
			
			xpos = circlepath_centreX + gpoint.x;
			ypos = circlepath_centreY + gpoint.y;
			
			circlepath_ang += circlepath_angvel;
			
			SetBodyXForm(0, xpos,ypos, dir);			


		}
		public function InitPathObjectCircular()
		{
			
			Utils.GetParams(initParams);
			
			circlepath_radius = Utils.GetParamNumber("circlepath_radius");
			circlepath_startang = Utils.DegToRad(Utils.GetParamNumber("circlepath_startang"));
			circlepath_angvel = Utils.DegToRad(Utils.GetParamNumber("circlepath_angvel"));
			
			circlepath_ang = circlepath_startang;
			
			gmat.identity();
			gmat.rotate(circlepath_startang);
			gpoint.x = 0;
			gpoint.y = -circlepath_radius;
			gpoint = gmat.transformPoint(gpoint);
			
			circlepath_centreX = xpos + gpoint.x;
			circlepath_centreY = ypos + gpoint.y;
			
			updateFunction = UpdatePathObjectCircular;
			visible = false;
			if (Game.usedebug) visible = true;
		}

//-----------------------------------------------------------------------------------------------------------------

		public function UpdatePathObjectPendulum()
		{
			gmat.identity();
			gmat.rotate(circlepath_ang);
			gpoint.x = 0;
			gpoint.y = circlepath_radius;
			gpoint = gmat.transformPoint(gpoint);
			
			xpos = circlepath_centreX + gpoint.x;
			ypos = circlepath_centreY + gpoint.y;
			
			if (lineRotateToPath)
			{
				dir = circlepath_ang;
			}
			
			SetBodyXForm(0, xpos,ypos, dir);			

			
			if (circlepath_ang <  0)
			{
				circlepath_angvel += pendulum_accel;
			}
			if (circlepath_ang >=  0)
			{
				circlepath_angvel -= pendulum_accel;
			}
			
			circlepath_ang += circlepath_angvel;
			if (circlepath_angvel > pendulum_maxvel) circlepath_angvel = pendulum_maxvel;
			if (circlepath_angvel < -pendulum_maxvel) circlepath_angvel = -pendulum_maxvel;

		}

		var pendulum_accel:Number;
		var pendulum_maxvel:Number;
		public function InitPathObjectPendulum()
		{
			
			Utils.GetParams(initParams);
			
			circlepath_radius = Utils.GetParamNumber("circlepath_radius");
			circlepath_startang = Utils.DegToRad(Utils.GetParamNumber("circlepath_startang"));
			pendulum_accel = Utils.DegToRad(Utils.GetParamNumber("pendulum_accel"));
			pendulum_maxvel = Utils.DegToRad(Utils.GetParamNumber("pendulum_maxvel"));
			lineRotateToPath = Utils.GetParamBool("path_rotatetopath",false);
			circlepath_angvel = pendulum_maxvel;
			
			circlepath_ang = circlepath_startang;
			
			gmat.identity();
			gmat.rotate(circlepath_startang);
			gpoint.x = 0;
			gpoint.y = -circlepath_radius;
			gpoint = gmat.transformPoint(gpoint);
			
			circlepath_centreX = xpos + gpoint.x;
			circlepath_centreY = ypos + gpoint.y;
			
			updateFunction = UpdatePathObjectPendulum;
			visible = false;
			if (Game.usedebug) visible = true;
		}

//-----------------------------------------------------------------------------------------------------------------

	
	}
	
	
	
}

