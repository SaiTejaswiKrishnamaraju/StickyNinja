package EditorPackage
{
	import EditorPackage.EditParamUI.EditParams;
	import fl.controls.List;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.events.ListEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.system.System;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.*;
	import fl.events.ComponentEvent; 
	import fl.controls.ComboBox;
	import LicPackage.LicDef;
	import UIPackage.UI;
	import UIPackage.UIX;

	
	/**
	 * ...
	 * @author ...
	 */
	public class PhysEditor 
	{
		
		public function PhysEditor() 
		{
		}
		
		
		public static const editMode_Placement:int = 0;		// done
		public static const editMode_Library:int = 1;			// done
		public static const editMode_Commands1:int = 4;
		public static const editMode_Adjust:int = 5;
		public static const editMode_Lines:int = 6;			// done
		public static const editMode_Joints:int = 7;			
		public static const editMode_GridCommands:int = 8;
		public static const editMode_ObjCol:int = 9;			//done
		public static const editMode_Map:int = 10;				// done
		public static const editMode_PickPieceForLink:int = 11;	// done
		public static const editMode_PickLineForLink:int = 12;	// done
		public static const editMode_Multi:int = 13;	// done
		public static const editMode_UI:int = 14;	
		public static const editMode_UILibrary:int = 15;	
		public static const editMode_Markers:int = 16;	
		
		
		public static var currentLevel:int = 0;
		static var updateTimer:int = 0;
		public static var oldEditMode:int = 0;
		public static var editMode:int = 0;
		static var editSubMode:int = 0;
		static var prevEditMode:int = 0;
		public static var scrollX:Number = 0;
		public static var scrollY:Number = 0;
		
		static var renderMiniMap:Boolean = false;
		static var renderObjects:Boolean = true;

		static var screenGridMode_active:Boolean = true;
		static var screenGridMode_w:int = Defs.displayarea_w;
		static var screenGridMode_h:int = Defs.displayarea_h;
		static var gridsnap:int = 10;
		static var gridMode_active:Boolean = false;
		static var gridMode_renderGrid:Boolean = true;
		
		static var objectZSortMode:Boolean = false;
		
		public static var infoTextFormat:TextFormat;
		public static var infoTextFormat_Cursor:TextFormat;
		public static var infoMC:MovieClip;
		public static var screenBD:BitmapData;
		public static var hittestScreenBD:BitmapData;
		public static var screenB:Bitmap;
		public static var editorMC:MovieClip;
		public static var linesScreen:MovieClip;
		
		static var currentPieceList:Array;
		
		
		public static var hoverLineIndex:int;
		public static var hoverPointIndex:int;
		
		public static var zoom:Number;
		public static var linZoom:Number;
		
		static var undoList:Array;
		
		public static var currentModeObject:EditMode_Base = new EditMode_Base();
		public static var editModeObj_Library:EditMode_Library;
		public static var editModeObj_Placement:EditMode_Placement;
		public static var editModeObj_Adjust:EditMode_Adjust;
		public static var editModeObj_Markers:EditMode_Markers;
		public static var editModeObj_Lines:EditMode_Lines;
		public static var editModeObj_Map:EditMode_Map;
		public static var editModeObj_Joints:EditMode_Joints;
		public static var editModeObj_ObjCol:EditMode_ObjCol;
		public static var editModeObj_PickPieceForLink:EditMode_PickPieceForLink;
		public static var editModeObj_PickLineForLink:EditMode_PickLineForLink;
		public static var editModeObj_Multi:EditMode_Multi;
		public static var editModeObj_UI:EditMode_UI;
		public static var editModeObj_UILibrary:EditMode_UILibrary;

		
		public static const LM_FILL:int = 1;
		public static const LM_LINK:int = 2;
		public static const LM_NORMALS:int = 4;
		
		
		
		
		public static function SetEditMode(_mode:int,clearParams:Boolean = true)
		{
			KeyReader.Reset();
			editMode = _mode;
			editSubMode = 0;
			
			if (currentModeObject != null)
			{
				currentModeObject.ExitMode();
			}
			
			currentModeObject = new EditMode_Base();
			if (editMode == editMode_Library) currentModeObject = editModeObj_Library;
			if (editMode == editMode_Placement) currentModeObject = editModeObj_Placement;
			if (editMode == editMode_Adjust) currentModeObject = editModeObj_Adjust;
			if (editMode == editMode_Markers) currentModeObject = editModeObj_Markers;
			if (editMode == editMode_Lines) currentModeObject = editModeObj_Lines;
			if (editMode == editMode_Map) currentModeObject = editModeObj_Map;
			if (editMode == editMode_ObjCol) currentModeObject = editModeObj_ObjCol;
			if (editMode == editMode_Multi) currentModeObject = editModeObj_Multi;
			if (editMode == editMode_UI) currentModeObject = editModeObj_UI;
			if (editMode == editMode_UILibrary) currentModeObject = editModeObj_UILibrary;
			if (editMode == editMode_PickPieceForLink) 
			{
				currentModeObject = editModeObj_PickPieceForLink;
			}
			if (editMode == editMode_PickLineForLink) 
			{
				currentModeObject = editModeObj_PickLineForLink;
			}
			if (editMode == editMode_Joints) currentModeObject = editModeObj_Joints;
			
			if (clearParams)
			{
				EditParams.ClearParameterListBox();
			}
			currentModeObject.EnterMode();
		}
		
		public static function InitEditor(_sx:Number,_sy:Number):void 
		{
			if (firstTime) InitEditorOnce();
			
			Mouse.show();
			PhysicsBase.Init();
			GameObjects.ClearAll();
			updateTimer = 0;
			currentPieceList = new Array();
			
			AddCurrentPiece(0, 0, 0, 0, 0, 0);
			
			currentLevel = Levels.currentIndex;
			
			zoom = linZoom = 1;
			
			MouseControl.SetWheelHandler(EditorWheelHandler);
			
			undoList = new Array();
			
			linesScreen = new MovieClip();
			linesScreen.graphics.clear();
			hoverLineIndex = -1;
			hoverPointIndex = -1;
			
			scrollX = _sx;
			scrollY = _sy;
			
			AddDataGrid(0, 300);
			
			editorMC = new MovieClip();

			if (PROJECT::isFinal == false)
			{
				//var RIGHT_MOUSE_DOWN:String = "rightMouseDown";
				//var RIGHT_MOUSE_UP:String = "rightMouseUp";
			//	editorMC.addEventListener(RIGHT_MOUSE_DOWN, Editor_OnRightMouseDown); 
			//	editorMC.addEventListener(RIGHT_MOUSE_UP, Editor_OnRightMouseUp); 
				editorMC.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, Editor_OnRightMouseDown); 
				editorMC.addEventListener(MouseEvent.RIGHT_MOUSE_UP, Editor_OnRightMouseUp); 
			}
			
			editorMC.addEventListener(MouseEvent.MOUSE_DOWN, Editor_OnMouseDown); 
			editorMC.addEventListener(MouseEvent.MOUSE_UP, Editor_OnMouseUp); 
			editorMC.addEventListener(MouseEvent.MOUSE_MOVE, Editor_OnMouseMove); 			
			editorMC.addEventListener(Event.ENTER_FRAME, OnEnterFrame); 
			
			screenBD = new BitmapData(Defs.displayarea_w, Defs.displayarea_h, false, 0xff2233);
			screenB=new Bitmap(screenBD);			
			
			hittestScreenBD = new BitmapData(Defs.displayarea_w, Defs.displayarea_h, false, 0);
			
			infoMC = new MovieClip();
			ClearInfoMC();
			
			editorMC.addChild(screenB);
			editorMC.addChild(infoMC);

			layersMC = EditorLayers.GetContainer()
			layersMC.scaleX = 0.6;
			layersMC.scaleY = 0.6;
			layersMC.x = Defs.editor_area_w - layersMC.width;
			layersMC.y = 15;
			editorMC.addChild(layersMC);
			
			LicDef.GetStage().addChild(editorMC);
			InitInfoTextFormat();
			
			CursorText_Init();
			CursorText_Hide();
			
			SetEditMode(editMode);
			
		}

		static var layersMC:MovieClip
		
		static var firstTime:Boolean = true;
		public static function InitEditorOnce():void 
		{
			firstTime = false;
			Mouse.show();
			PhysicsBase.Init();
			GameObjects.ClearAll();
			updateTimer = 0;
			currentPieceList = new Array();
			
			AddCurrentPiece(0, 0, 0, 0, 0, 0);
			
			currentLevel = Levels.currentIndex;

			EditorLayers.InitOnce();
			
			MouseControl.SetWheelHandler(EditorWheelHandler);
			
			EdConsole.InitOnce();
			
			editModeObj_Library = new EditMode_Library();
			editModeObj_Library.InitOnce();
			editModeObj_Placement = new EditMode_Placement();
			editModeObj_Placement.InitOnce();
			editModeObj_Adjust = new EditMode_Adjust();
			editModeObj_Adjust.InitOnce();
			editModeObj_Markers = new EditMode_Markers();
			editModeObj_Markers.InitOnce();
			editModeObj_Lines = new EditMode_Lines();
			editModeObj_Lines.InitOnce();
			editModeObj_Map = new EditMode_Map();
			editModeObj_Map.InitOnce();
			editModeObj_Joints = new EditMode_Joints();
			editModeObj_Joints.InitOnce();
			editModeObj_ObjCol = new EditMode_ObjCol();
			editModeObj_ObjCol.InitOnce();
			editModeObj_PickPieceForLink = new EditMode_PickPieceForLink();
			editModeObj_PickPieceForLink.InitOnce();
			editModeObj_PickLineForLink = new EditMode_PickLineForLink();
			editModeObj_PickLineForLink.InitOnce();
			editModeObj_Multi = new EditMode_Multi();
			editModeObj_Multi.InitOnce();
			editModeObj_UI = new EditMode_UI();
			editModeObj_UI.InitOnce();
			editModeObj_UILibrary = new EditMode_UILibrary();
			editModeObj_UILibrary.InitOnce();
			
			

			undoList = new Array();
			
			linesScreen = new MovieClip();
			linesScreen.graphics.clear();
			
			
			hoverLineIndex = -1;
			hoverPointIndex = -1;
			
			scrollX = 0;
			scrollY = 0;
			editMode = editMode_Adjust;
			
		}
		
		
		static function CloseEditor()
		{
			
			if (currentModeObject != null)
			{
				currentModeObject.ExitMode();
				currentModeObject = null;
			}
			
			editorMC.removeEventListener(Event.ENTER_FRAME, OnEnterFrame); 
			editorMC.removeEventListener(MouseEvent.MOUSE_DOWN, Editor_OnMouseDown); 
			editorMC.removeEventListener(MouseEvent.MOUSE_UP, Editor_OnMouseUp); 
			editorMC.removeEventListener(MouseEvent.MOUSE_MOVE, Editor_OnMouseMove); 
			
			
			editorMC.removeChild(screenB);
			editorMC.removeChild(infoMC);
			editorMC.removeChild(layersMC);

			LicDef.GetStage().removeChild(editorMC);
			screenBD = null;
			screenB = null;
			infoMC = null;
			editorMC = null;
		}
		
		
		static function ClearInfoMC()
		{
			var i:int;
			for (i=infoMC.numChildren-1; i>=0; i--) {
				infoMC.removeChildAt(i);
			}			
		}
		
		static function OnEnterFrame(e:Event)
		{
			var g:Graphics = Game.fillScreenMC.graphics;
			g.clear();
			RenderEditor();	
			
		}
		
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
		
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
		

		static function GetInstanceById(id:String):EdObj
		{
			var level_instances:Array = GetCurrentLevelInstances();
			for each(var inst:EdObj in level_instances)
			{
				if (inst.id == id) return inst;
			}
			return null;
		}
		
		public static function GetAnyObjectById(id:String):EditableObjectBase
		{
			var objs:Array = GetAllObjectsList();
			for each(var inst:EditableObjectBase in objs)
			{
				if (inst.id == id) return inst;
			}
			return null;
		}
		public static function GetAnyObjectByPreviousId(id:String):EditableObjectBase
		{
			var objs:Array = GetAllObjectsList();
			for each(var inst:EditableObjectBase in objs)
			{
				if (inst.prev_id == id) return inst;
			}
			return null;
		}
		public static function ClearAllPreviousIDs()
		{
			var objs:Array = GetAllObjectsList();
			for each(var inst:EditableObjectBase in objs)
			{
				inst.prev_id == "";
			}
		}
		
		
		static function Editor_OnRightMouseDown(e:MouseEvent):void
		{
			currentModeObject.OnRightMouseDown(e);
		}
		static function Editor_OnRightMouseUp(e:MouseEvent):void
		{
			currentModeObject.OnRightMouseUp(e);			
		}
		
		static function Editor_OnMouseDown(e:MouseEvent):void
		{
			currentModeObject.OnMouseDown(e);
		}
		static function Editor_OnMouseUp(e:MouseEvent):void
		{
			currentModeObject.OnMouseUp(e);			
		}
		static function Editor_OnMouseMove(e:MouseEvent):void
		{
			currentModeObject.OnMouseMove(e);
		}
		
		
		static function ClearCurrentPieces():void
		{
			currentPieceList = new Array();
		}
		static function AddCurrentPiece(id:int, rot:Number, xoff:Number, yoff:Number,_origX:Number = 0,_origY:Number = 0,_initParams:String="")
		{
			var piece:Object = new Object();
			piece.id = id;
			piece.rot = Number(rot);
			piece.xoff = Number(xoff);
			piece.yoff = Number(yoff);
			piece.origx = Number(_origX);
			piece.origy = Number(_origY);
			piece.scale = 1;
			piece.initParams = _initParams;
			currentPieceList.push(piece);			
		}
		
		static function GetCurrentPieceInitialPos():Point
		{
			if (currentPieceList.length == 0) return new Point(0, 0);
			var piece:Object = currentPieceList[0];
			return new Point(piece.origx, piece.origy);
		}
		
		
		public static function ClearEditorMode():void 
		{
			EditParams.ClearParameterListBox();
			KeyReader.Reset();
		}
		public static function UpdateEditor():void 
		{
			if (isEntering) return;
			
			EdConsole.UpdateOncePerFrame();
			
			updateTimer++;
			var mx:int = MouseControl.x;
			var my:int = MouseControl.y;		
			
			CursorText_SetPos(mx, my);

			
			var physObj:PhysObj;
			var l:Level = GetCurrentLevel();

			Lines_GetCurrentPointUnderCursor(mxs, mys);
			
			if(KeyReader.Pressed(KeyReader.KEY_N) && KeyReader.Down(KeyReader.KEY_CONTROL) && KeyReader.Down(KeyReader.KEY_SHIFT))
			{
				AddNewLevel();
			}
			

			if (KeyReader.Pressed(KeyReader.KEY_1)) EditorLayers.ToggleUIVisibility();
			
			if (KeyReader.Pressed(KeyReader.KEY_G))
			{
				gridMode_active = (gridMode_active == false);
			}

			if (KeyReader.Pressed(KeyReader.KEY_BACKSPACE) && KeyReader.Down(KeyReader.KEY_SHIFT) == false && KeyReader.Down(KeyReader.KEY_CONTROL) == false)
			{
				scrollX = 0;
				scrollY = 0;
				zoom = linZoom = 1;
			}
			
			
			if (KeyReader.Pressed(KeyReader.KEY_F1)) SetEditMode(editMode_Multi);
			if (KeyReader.Pressed(KeyReader.KEY_F2)) 
			{
				if (editMode == editMode_UI)
				{
					SetEditMode(editMode_UILibrary);
				}
				else
				{
					SetEditMode(editMode_Library);
				}
			}
			if (KeyReader.Pressed(KeyReader.KEY_F3)) SetEditMode(editMode_Markers);
			if (KeyReader.Pressed(KeyReader.KEY_F4)) SetEditMode(editMode_UI);
			if (KeyReader.Pressed(KeyReader.KEY_F5)) SetEditMode(editMode_Adjust);
			if (KeyReader.Pressed(KeyReader.KEY_F6)) SetEditMode(editMode_Lines);
			if (KeyReader.Pressed(KeyReader.KEY_F7)) SetEditMode(editMode_Joints);
			

			if (KeyReader.Pressed(KeyReader.KEY_F8)) 
			{
				if (editMode == editMode_Library)
				{
					editModeObj_Library.SaveXML();
					return;
				}
				else if (editMode == editMode_UI)
				{
					UIX.SaveXML();
					return;
				}
				else
				{
				
					ClearEditorMode();
					var sss:String = GetAllLevelsAsXml();
					var fileRef:FileReference;
					fileRef = new FileReference();
					fileRef.save(sss, ExternalData.levelsSaveName);			
				}
				return;
			}
			


			if (KeyReader.Pressed(KeyReader.KEY_F9))
			{
				ClearEditorMode();
				var sss:String = ExportLevelAsXml();
				ExternalData.OutputString(sss);
				
				CloseEditor();
				
				if (Game.gameState == Game.gameState_Play)
				{
					Game.StartLevel();
				}
				else if (Game.gameState == Game.gameState_UI)
				{
					UI.StartTransition(UI.currentScreen.template.name);
					Game.InitLevelState(Game.levelState_LevelStart);
				}
				
				return;

			}
			if (KeyReader.Pressed(KeyReader.KEY_SPACE)) 
			{
				
				ClearEditorMode();
				CloseEditor();
				if (Game.gameState == Game.gameState_Play)
				{
					Game.StartLevel();
				}
				else if (Game.gameState == Game.gameState_UI)
				{
					Game.InitLevelState(Game.levelState_LevelStart);
					UI.StartTransitionImmediate(UI.currentScreen.template.name);
					
				}
				return;
			}
			
			var zadd:Number = 0;
			if (KeyReader.Down(KeyReader.KEY_EQUALS)) 
			{
				zadd = -0.1;
				if (KeyReader.Down(KeyReader.KEY_SHIFT))
				{
					zadd = -1;
				}
				
			}
			if (KeyReader.Down(KeyReader.KEY_MINUS)) 
			{
				zadd = 0.1;
				if (KeyReader.Down(KeyReader.KEY_SHIFT))
				{
					zadd = 1;
				}
			}
			
			if (zadd != 0)
			{
				var z:Number = 1/zoom;
				var n:Number = MouseControl.x;
				var n1:Number = MouseControl.y;
				scrollX += (n * z);
				scrollY += (n1 * z);

				linZoom += zadd;
				linZoom = Utils.LimitNumber(0.1, 1000,linZoom);
				
				
				zoom = 1 / linZoom;
				var z:Number = 1/zoom;
				scrollX -= (n * z);
				scrollY -= (n1 * z);
			}
			
			
			if (editMode == editMode_Commands1)	// commands
			{
			
				if (KeyReader.Pressed(KeyReader.KEY_9)) 
				{
					var sss:String = ExportLevelAsXml();
					ExternalData.OutputString(sss);
					
					CloseEditor();
					Game.StartLevel();
					return;

				}
				if (KeyReader.Pressed(KeyReader.KEY_4)) 
				{
					KeyReader.ClearKey(KeyReader.KEY_4);
					var sss:String = ExportLevelAsXml();
					ExternalData.OutputString(sss);

					SetEditMode(prevEditMode);
					return;
				}
				if (KeyReader.Pressed(KeyReader.KEY_5)) 
				{
					KeyReader.ClearKey(KeyReader.KEY_5);
					ExportAllLevelsAsXml();
					SetEditMode(prevEditMode);
					return;
				}
				
				return;
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_U)) 
			{
				DoUndo();
			}

			
			currentModeObject.Update();
			UpdateScroll();
		}
		
		
		
		
				
		
		
		static function EditorWheelHandler(delta:int)
		{
			if (currentModeObject == null) return;
			currentModeObject.OnMouseWheel(delta);
		}
		

		static function Lines_GetCurrentPointUnderCursor(x:Number, y:Number)
		{
			var l:Level = GetCurrentLevel();
			var lineIndex:int = 0;
			hoverLineIndex = -1;
			hoverPointIndex = -1;
			for each (var line:EdLine in l.lines)
			{
				var pointIndex:int = 0;
				for each(var p:Point in line.points)
				{
					if (Utils.DistBetweenPoints(p.x, p.y, x, y) < 3)
					{
						hoverLineIndex = lineIndex;
						hoverPointIndex = pointIndex;
						return;
					}
					pointIndex++;
				}
				lineIndex++;
			}
		}
		
		static function UpdateScroll()
		{
			if (KeyReader.Down(KeyReader.KEY_SHIFT) == false)
			{
				var dv:Number = 32;
				var xv:Number = 0;
				var yv:Number = 0;
				if (KeyReader.Down(KeyReader.KEY_CONTROL) )
				{
					dv = 4
				}
				
				dv *= 1/zoom;
				
				if (KeyReader.Down(KeyReader.KEY_LEFT)) xv = -dv;
				if (KeyReader.Down(KeyReader.KEY_RIGHT)) xv = dv;
				if (KeyReader.Down(KeyReader.KEY_UP)) yv = -dv;
				if (KeyReader.Down(KeyReader.KEY_DOWN)) yv = dv;
				scrollX += xv;
				scrollY += yv;
			}
		}
		
		
		static var cursorTF:TextField;
		public static function CursorText_Set(s:String)
		{
			cursorTF.text = s;
			cursorTF.setTextFormat(infoTextFormat_Cursor);
		}
		public static function CursorText_Show()
		{
			cursorTF.visible = true;
		}
		public static function CursorText_Hide()
		{
			cursorTF.visible = false;
		}
		public static function CursorText_SetPos(x:int, y:int)
		{
			cursorTF.x = x+10;
			cursorTF.y = y-10;
		}
		public static function CursorText_Init()
		{
			cursorTF = new TextField();
			cursorTF.type = TextFieldType.DYNAMIC;
			cursorTF.x = 300;
			cursorTF.y = 300;
			cursorTF.text = "cursor here";
			cursorTF.background = false;

			infoTextFormat_Cursor.align = TextFormatAlign.LEFT;
			cursorTF.autoSize = TextFieldAutoSize.LEFT;
			
			cursorTF.setTextFormat(infoTextFormat_Cursor);
			cursorTF.antiAliasType = AntiAliasType.ADVANCED;
			cursorTF.name = "cursorTF";
			cursorTF.selectable = false;
			cursorTF.mouseEnabled = false;
			
			editorMC.addChild(cursorTF);
			
		}
		
		static function AddInfoText(fieldName:String,x:int, y:int, s:String,justify:String="left",extra:String=null):int
		{
			tf = new TextField();
			tf.type = TextFieldType.DYNAMIC;
			tf.x = x;
			tf.y = y;
			tf.text = s;
			tf.background = false;

			if (justify == "left")
			{
				infoTextFormat.align = TextFormatAlign.LEFT;
				tf.autoSize = TextFieldAutoSize.LEFT;
			}
			if (justify == "right")
			{
				infoTextFormat.align = TextFormatAlign.RIGHT;
				tf.autoSize = TextFieldAutoSize.RIGHT;
			}
			
			tf.setTextFormat(infoTextFormat);
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.name = fieldName;
			tf.selectable = false;
			tf.mouseEnabled = false;
			
			

			//tf.cacheAsBitmap = true;
			infoMC.addChild(tf);
			return tf.height-6;
		}
		
		static function InitInfoTextFormat()
		{
			infoTextFormat = new TextFormat();
			infoTextFormat.size = 10;
			infoTextFormat.color = 0xffffff;
			infoTextFormat.font = "Arial";
			
			infoTextFormat_Cursor = new TextFormat();
			infoTextFormat_Cursor.size = 10;
			infoTextFormat_Cursor.color = 0xffffff;
			infoTextFormat_Cursor.font = "Arial";
			
			
		}
		static function RenderPanel_Editor()
		{
			ClearInfoMC();
			var x:Number;
			var y:Number;
			var s:String;
			var w:Number;			

			x = Defs.editor_area_w - 100;
			y = Defs.displayarea_h - 20;
			var memused:int = System.totalMemory / 1024;
			
			s = "FPS: " + Utils.DP2(Game.main.fps).toString() + "  Mem: " + memused;
			AddInfoText("fps",x, y, s,"right");
			x = Defs.editor_x + 10;
			s = "Level: " + currentLevel + "   [ " +GetCurrentLevel().id + "  " + GetCurrentLevel().name + " ]";
			AddInfoText("level", x, y, s);

			
			x = Defs.editor_area_w - 150;
			y = 0;
			s = "F1:MultiAdjust | F2:Library | F5:Objects | F6:Lines | F7:Joints | F8:Save | F9:Save&Quit"
			AddInfoText("level", x, y, s,"right");
			
			
			
			s = "Editor: Mode = ";
			if (editMode == editMode_Placement) s += "Placement";
			if (editMode == editMode_Map) s += "Mapper";
			if (editMode == editMode_Library) s += "Library Page " + int(editModeObj_Library.library_page + 1).toString() + " / " + int(editModeObj_Library.GetNumLibraryPages()).toString() + "     " + editModeObj_Library.library_hoverPieceName;
			if (editMode == editMode_ObjCol) s += "Object Collision";
			if (editMode == editMode_Markers) s += "Markers";
			if (editMode == editMode_Adjust) s += "Adjust";
			if (editMode == editMode_Joints) s += "Joints";
			if (editMode == editMode_Lines) s += "Lines";
			if (editMode == editMode_PickPieceForLink) s += "Pick A Piece For Linkage";
			if (editMode == editMode_PickLineForLink) s += "Pick A Line For Linkage";
			if (editMode == editMode_Multi) s += "Multi Adjust";
			if (editMode == editMode_UI) s += "UI";
			if (editMode == editMode_UILibrary) s += "UI Library";
			x = Defs.editor_x+10;
			y = 10;
			y += AddInfoText("a", x, y, s) ;		
			
			y = currentModeObject.RenderHud(x,y);
				
		}
		
		static function CheckIDForUniqueness(_id:String):Boolean
		{
			var match:Boolean = false;
			var l:Level = GetCurrentLevel();
			for each(var line:EdLine in l.lines)
			{
				if (line.id == _id) match = true;
			}
			for each(var poi:EdObj in l.instances)
			{			
				if (poi.id == _id) match = true;
			}	
			if (match)
			{
				Utils.print("ERRRRROOORR: CheckIDForUniqueness");
				return false;
			}
			return true;
		}
		public static function CreateNewUniqueID():String
		{
			var unique:Boolean = false;
			do
			{
				var s:String = "uid_";
				for (var i:int = 0; i < 20; i++)
				{
					s += Utils.RandBetweenInt(0, 9);
				}
				unique = CheckIDForUniqueness(s);
			}while (unique == false);
			
			return s;
		}
		
		public static function GetOrCreateUniqueLineID(l:EdLine):String
		{
			if (l.id == "")
			{
				l.id = CreateNewUniqueID();
			}
			return l.id;
		}
		
		public static function GetOrCreateUniqueObjectID(poi:EdObj):String
		{
			if (poi.id == "")
			{
				poi.id = CreateNewUniqueID();
			}
			return poi.id;
		}
		
		static function CurrentAdjustObject_ParameterPickObjectLink()
		{
			if (editModeObj_Adjust.currentAdjustObject == null) return;
			var po:PhysObj = Game.objectDefs.FindByName(editModeObj_Adjust.currentAdjustObject.typeName);
			var paramName:String = po.instanceParams[editModeObj_Adjust.currentAdjustObjectParam];
			var ob:ObjParam = ObjectParameters.GetObjectParamByName(paramName);
			if (ob == null) return;
			if (ob.type != "objlink") return;
			SetEditMode(editMode_PickPieceForLink);

		}
		static function CurrentAdjustObject_ParameterPickLineLink()
		{
			if (editModeObj_Adjust.currentAdjustObject == null) return;
			var po:PhysObj = Game.objectDefs.FindByName(editModeObj_Adjust.currentAdjustObject.typeName);
			var paramName:String = po.instanceParams[editModeObj_Adjust.currentAdjustObjectParam];
			var ob:ObjParam = ObjectParameters.GetObjectParamByName(paramName);
			if (ob == null) return;
			if (ob.type != "linelink") return;
			SetEditMode(editMode_PickLineForLink);

		}
		
		


		
		static var pickedPieceForLink:EdObj = null;
		public static var isEntering:Boolean = false;
		static var tf:TextField;
		static var AddTextEntry_Callback:Function;
		static function AddTextEntry(xpos:int, ypos:int, title:String,text:String,_cb:Function)
		{
			AddEntryMC();
			
			AddTextEntry_Callback = _cb;
			var f:TextFormat;
			
			f = new TextFormat();
			f.size = 20;
			f.color = 0x0;
			
			tf = new TextField();
			tf.name = "tf";
			tf.type = TextFieldType.INPUT;
			entryMC.addChild(tf);
			tf.x = xpos;
			tf.y = ypos;
			tf.text = text;
			tf.opaqueBackground = true;
			tf.background = true;
			tf.backgroundColor = 0xffffff;
			tf.multiline = false;
			tf.setTextFormat(f);
			tf.setSelection(0, tf.text.length);
			Game.main.stage.focus = tf;
			
			tf.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler,false,0,true);
			
			isEntering = true;
			
		}
		
		static function AddDataGrid(xpos:int, ypos:int)
		{
//			var d:DataGrid = new DataGrid();
//			var dg:DataGrid = new DataGrid();
//			Game.main.addChild(dg);
		}
		
		static var listBox:List = null;
		static var listBoxContainer:MovieClip = null;
		
		
		static function PreventPropogationHandler(e:MouseEvent)
		{
			e.stopImmediatePropagation();
		}
		
		static function ParameterListBox_SetSelectedIndex()
		{
			if (listBoxContainer != null)
			{
				listBox.selectedIndex = editModeObj_Adjust.currentAdjustObjectParam;
			}
		}
		
		
		
		static var entryMC:MovieClip;
		static function RemoveEntryMC()
		{
			if (entryMC != null)
			{
				entryMC.parent.removeChild(entryMC);
				entryMC = null;
			}
		}
		static function AddEntryMC()
		{
			RemoveEntryMC();			
			entryMC = new MovieClip();
			entryMC.x = 0;
			entryMC.y = 0;
			entryMC.graphics.clear();
			entryMC.graphics.beginFill(0xffffff, 0.5);
			entryMC.graphics.drawRect(entryMC.x, entryMC.y,Defs.displayarea_w,Defs.displayarea_h);
			entryMC.graphics.endFill();
			editorMC.addChild(entryMC);
			entryMC.addEventListener(MouseEvent.CLICK, PreventPropogationHandler); 
			entryMC.addEventListener(MouseEvent.MOUSE_DOWN, PreventPropogationHandler); 
			entryMC.addEventListener(MouseEvent.MOUSE_UP, PreventPropogationHandler); 
		}
		
		
		
		static function keyDownHandler(e:KeyboardEvent)		
		{
			
			if (isEntering == false) return;
			var tf:TextField = e.currentTarget as TextField;
			if ( e.charCode ==KeyReader.KEY_ENTER)
			{
				if (AddTextEntry_Callback != null)
				{
					AddTextEntry_Callback(tf.text);
				}
				isEntering = false;
				//ClearClicked();
				
				Game.main.stage.focus = null;
				tf.parent.removeChild(tf);
				tf = null;
				RemoveEntryMC();
				
			}
			if ( e.charCode ==KeyReader.KEY_ESCAPE)
			{
				Utils.print("cancelled");
				isEntering = false;
				//ClearClicked();
				Game.main.stage.focus = null;
				tf.parent.removeChild(tf);
				tf = null;
				RemoveEntryMC();
				
			}
		}
		
		
		
		

		static function RenderEditor()
		{
			
			linesScreen.graphics.clear();
			
			var gfxid:int;
			var numf:int;
			var px:Number;
			var s:String;
			
			var bd:BitmapData = screenBD;

			var mx:int = MouseControl.x;
			var my:int = MouseControl.y;
			
			var gs:Number = gridsnap;	// * zoom;
			
			if (gridMode_active)
			{
				mx = Math.floor(mx);
				my = Math.floor(my);
				mx = int(mx / gs) * int(gs);
				my = int(my / gs) * int(gs);
			}
			
			var sx:Number = scrollX;
			var sy:Number = scrollY;
			if (gridMode_active)
			{
				sx = Math.floor(sx);
				sy = Math.floor(sy);
				sx = int(sx / gs) * int(gs);
				sy = int(sy / gs) * int(gs);
			}
			
			var mxs:int = mx+sx;
			var mys:int = my+sy;			

			
			
			if (editMode == editMode_Commands1)
			{
				bd.fillRect(Defs.screenRect, 0xff7030c0);
				
			}
			if (editMode == editMode_GridCommands)
			{
				bd.fillRect(Defs.screenRect, 0xff7030c0);
				
			}
			
			currentModeObject.Render(bd);
			
			bd.draw(linesScreen);
			
			RenderPanel_Editor();
		}
		
//-------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------		
		
//-------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------		
//-------------------------------------------------------------------------------------------------------		
		
		static function RenderBackground(bd:BitmapData)
		{
			//var dobj:DisplayObj= GraphicObjects.GetDisplayObjByName("background01");
			//gfxid += Game.currentLevel;
			//dobj.RenderAt(0, bd, -scrollX, -scrollY);
			
			var p0:Point = GetMapPos(0,0);
			var w:Number = Defs.displayarea_w * zoom;
			var h:Number = Defs.displayarea_h * zoom;
			
			bd.fillRect(new Rectangle(p0.x,p0.y,w,h), 0);
		}
		
		
		static function Editor_RenderGrid(bd:BitmapData)
		{
			Editor_RenderScreenGrid(bd);
			
			if (gridMode_active == false) return;
			if (gridMode_renderGrid == false) return;
			
			PhysEditor.linesScreen.graphics.clear();
			
			var mx:int = scrollX;
			var my:int = scrollY;
			
			mx = int(mx / gridsnap) * int(gridsnap);
			my = int(my / gridsnap) * int(gridsnap);

			var x0:Number = 0;
			var x1:Number = Defs.displayarea_w;
			var y0:Number = 0;
			var y1:Number = Defs.displayarea_h;

			
			var g:Graphics = linesScreen.graphics;
			g.lineStyle(1, 0xff808080, 2);
			
			var x:int;
			var y:int;
			
			var sx:Number = scrollX;
			var sy:Number = scrollY;
			
			var w:Number = Defs.displayarea_w * 1/zoom;
			var h:Number = Defs.displayarea_h * 1/zoom;
			
			
			for (x = mx; x < mx + w*2; x += gridsnap)
			{
				var p0:Point = GetPos(x - sx, y0);
				var p1:Point = GetPos(x - sx, y1);
				
				g.moveTo(p0.x,y0);
				g.lineTo(p1.x,y1);
			}
			for (y = my; y < my + h*2; y += gridsnap)
			{
				var p0:Point = GetPos(x0,y-sy);
				var p1:Point = GetPos(x1,y-sy);
				g.moveTo(x0,p0.y);
				g.lineTo(x1,p1.y);
			}
			PhysEditor.screenBD.draw(PhysEditor.linesScreen);
			
		}

		static function Editor_RenderScreenGrid(bd:BitmapData)
		{
			if (screenGridMode_active == false) return;
		
			PhysEditor.linesScreen.graphics.clear();
			
			var mx:int = scrollX;
			var my:int = scrollY;
			
//			mx = Math.floor(mxs);
//			my = Math.floor(mys);
			mx = int(mx / screenGridMode_w) * int(screenGridMode_w);
			my = int(my / screenGridMode_h) * int(screenGridMode_h);

			var x0:Number = 0;
			var x1:Number = Defs.displayarea_w;
			var y0:Number = 0;
			var y1:Number = Defs.displayarea_h;

			
			var g:Graphics = linesScreen.graphics;
			g.lineStyle(1, 0xffffffff, 2);
			
			var x:int;
			var y:int;
			
			var sx:Number = scrollX;
			var sy:Number = scrollY;
			
			var w:Number = Defs.displayarea_w * 1/zoom;
			var h:Number = Defs.displayarea_h * 1/zoom;
			
			
			for (x = mx; x < mx + w*2; x += screenGridMode_w)
			{
				var p0:Point = GetPos(x - sx, y0);
				var p1:Point = GetPos(x - sx, y1);
				
				g.moveTo(p0.x,y0);
				g.lineTo(p1.x,y1);
			}
			for (y = my; y < my + h*2; y += screenGridMode_h)
			{
				var p0:Point = GetPos(x0,y-sy);
				var p1:Point = GetPos(x1,y-sy);
				g.moveTo(x0,p0.y);
				g.lineTo(x1,p1.y);
			}
			PhysEditor.screenBD.draw(PhysEditor.linesScreen);
			
		}
		
		static function SnapToObjects(x:Number, y:Number):Point
		{
			var physObj:PhysObj;
			
			if (currentPieceList.length != 1) return null;
			var ob:Object = currentPieceList[0];
			
			physObj = Game.objectDefs.GetByIndex(ob.id);

			if (physObj == null) return null;

			var pi:EdObj = Levels.CreateLevelObjInstanceAt(physObj.name, x+ob.xoff, y+ob.yoff, ob.rot, ob.scale,"");
			Editor_GetNearbyGuidelines(null, x, y, 20);
			

			var bd:BitmapData = screenBD;
			// get nearest guides?
			
			var madnumber:int = 99999999;
			
			var nearestX:Number = madnumber;
			var nearestY:Number = madnumber;
			
			for each(var gl:PhysEd_GuideLine in guideLines)
			{
				if (gl.type == 1)
				{
					if (Math.abs(gl.x0 - x) < nearestX) nearestX = gl.x0;
				}
				else
				{
					if (Math.abs(gl.y0 - y) < nearestY) nearestY = gl.y0;					
				}
			}

			if (nearestX != madnumber && nearestY != madnumber)
			{
				var p:Point = new Point(nearestX, nearestY);
				return p;
			}
			return null;
	
		}
		
		static var guideLines:Array;
		static function Editor_GetNearbyGuidelines(origObject:EdObj, x:Number, y:Number,maxd1:Number = 50)
		{
			var maxd2:Number = 3;
			var body:PhysObj_Body;
			var shape:PhysObj_Shape;
			var p:Point;
			var p1:Point;
			
			var level_instances:Array = GetCurrentLevelInstances();
			var m:Matrix = new Matrix();

			var origPoints:Array = new Array();

			if (origObject != null)
			{
				var origPO:PhysObj = Game.objectDefs.FindByName(origObject.typeName);
				if (origPO != null)
				{
					for each(body in origPO.bodies)
					{
						for each(shape in body.shapes)
						{
							if (shape.type == PhysObj_Shape.Type_Poly)
							{
								for each(p in shape.poly_points)
								{
									m.identity();
									m.rotate(Utils.DegToRad(origObject.rot));
									var pr:Point = new Point(p.x, p.y);
									pr = m.transformPoint(pr);
									
									var pp:Point = new Point(pr.x + origObject.x + body.pos.x, pr.y + origObject.y + body.pos.y);
									origPoints.push(pp);
								}
							}
						}
					}
				}	
			}
			else
			{
				origPoints.push(new Point(x,y));
			}
			
			guideLines = new Array();
			for each(var poi:EdObj in level_instances)
			{
				if (poi != origObject)
				{
					var po:PhysObj = Game.objectDefs.FindByName(poi.typeName);
					if (po != null)
					{
						for each(body in po.bodies)
						{
							for each(shape in body.shapes)
							{
								if (shape.type == PhysObj_Shape.Type_Poly)
								{
									for each(p in shape.poly_points)
									{
										m.identity();
										m.rotate(Utils.DegToRad(poi.rot));
										var pr:Point = new Point(p.x, p.y);
										pr = m.transformPoint(pr);

										var ppp:Point = new Point(pr.x + poi.x + body.pos.x, pr.y + poi.y + body.pos.y);
										for each(p1 in origPoints)
										{
											var dx:Number = Math.abs(ppp.x - p1.x);
											var dy:Number = Math.abs(ppp.y - p1.y);

											var level:Boolean = false;
											if(dy < maxd2 && dx < maxd1)
											{				
												level = false;
												if (Math.floor(ppp.y) == Math.floor(p1.y)) level = true;
												
												var gl:PhysEd_GuideLine = new PhysEd_GuideLine(ppp.x - 100, ppp.x + 100, ppp.y, 0,level);
												guideLines.push(gl);
											}
											if(dx < maxd2 && dy < maxd1)
											{												
												level = false;
												if (Math.floor(ppp.x) == Math.floor(p1.x)) level = true;
												var gl:PhysEd_GuideLine = new PhysEd_GuideLine(ppp.y - 100, ppp.y + 100, ppp.x, 1,level);
												guideLines.push(gl);
											}

										}
									}
								}
							}
						}
					}	
				}
			}
		}
		
		static function Editor_RenderNearbyGuidelines()
		{
			var bd:BitmapData = screenBD;
			for each(var gl:PhysEd_GuideLine in guideLines)
			{
				var col:uint = 0xffff0000;
				if (gl.level) col = 0xff00ffff;
				RenderLine( gl.x0 - scrollX, gl.y0 - scrollY, gl.x1 - scrollX, gl.y1 - scrollY,  col);
			}
		}
		
		
		
		static function Editor_RenderMiniMap()
		{
			if (renderMiniMap == false) return; 
			var scale:Number = 1 / 20;
			var level_instances:Array = GetCurrentLevelInstances();
			var bd:BitmapData = screenBD;
			for each(var poi:EdObj in level_instances)
			{
				var po:PhysObj = Game.objectDefs.FindByName(poi.typeName);
				if (po != null)
				{
//					PhysObj.RenderAt(po, poi.x - scrollX, poi.y - scrollY, poi.rot, bd,linesScreen.graphics,true);	
					PhysObj.RenderAt(po, poi.x-scrollX, (poi.y-scrollY)+(240/scale), poi.rot, poi.scale,bd,linesScreen.graphics,false,null,null,null,poi.isXFlipped);				
				}
			}
			
		}
		static function FillPoly(poly:Array, col:uint, alpha:Number)
		{
			if (poly.length <= 2) return;
			var g:Graphics = linesScreen.graphics;
			g.lineStyle(null, null,null);
			g.beginFill(col, alpha);
			for ( var i:int = 0; i <= poly.length; i++)
			{
				var j:int = i % poly.length;
				var p:Point = poly[j];
				if (i == 0)
				{
					g.moveTo(p.x,p.y);					
				}
				else
				{
					g.lineTo(p.x,p.y);
				}				
			}
			g.endFill();
		}
		
		
		static function FillPolyBitmap(bd:BitmapData,poly:Array)
		{
			
			if (poly.length <= 2) return;
			var g:Graphics = linesScreen.graphics;
			var m:Matrix = new Matrix();
			m.translate( -scrollX, -scrollY);
			m.scale(zoom, zoom);
			g.lineStyle(null, null,null);
			g.beginBitmapFill(bd, m, true, false);
			for ( var i:int = 0; i <= poly.length; i++)
			{
				var j:int = i % poly.length;
				var p:Point = poly[j];
				if (i == 0)
				{
					g.moveTo(p.x,p.y);					
				}
				else
				{
					g.lineTo(p.x,p.y);
				}				
			}
			g.endFill();
		}
		

		static function RenderLine(x0:Number, y0:Number, x1:Number, y1:Number, col:uint, thickness:Number = 1,alpha:Number = 1,normal:Boolean=false,directionArrow:Boolean=false)
		{
			var sx0:Number = 0;
			var sx1:Number = sx0 + Defs.displayarea_w;
			if (x0 >sx1 && x1 > sx1) return;
			if (x0 <sx0 && x1 < sx0) return;
			var sy0:Number = 0;
			var sy1:Number = sy0 + Defs.displayarea_h;
			if (y0 >sy1 && y1 > sy1) return;
			if (y0 <sy0 && y1 < sy0) return;
			
			var g:Graphics = linesScreen.graphics;
			g.lineStyle(thickness, col, alpha);
			g.moveTo(x0, y0);
			g.lineTo(x1, y1);
			
			if (normal)
			{
				var mx:Number = (x0 + x1) * 0.5;
				var my:Number = (y0 + y1) * 0.5;
				var dir:Number = Math.atan2( (y1 - y0), (x1 - x0) ) - (Math.PI * 0.5);
				var mx1:Number = mx + (Math.cos(dir) * 5);
				var my1:Number = my + (Math.sin(dir) * 5);
				g.moveTo(mx, my);
				g.lineTo(mx1, my1);

			}
			if (directionArrow)
			{
				var dir:Number = Math.atan2( (y1 - y0), (x1 - x0) );
				dir += Utils.DegToRad(180);
				var x2:Number = x1 + (Math.cos(dir-Utils.DegToRad(15)) * 20);
				var y2:Number = y1 + (Math.sin(dir-Utils.DegToRad(15)) * 20);
				g.moveTo(x1, y1);
				g.lineTo(x2,y2);
				var x2:Number = x1 + (Math.cos(dir+Utils.DegToRad(15)) * 20);
				var y2:Number = y1 + (Math.sin(dir+Utils.DegToRad(15)) * 20);
				g.moveTo(x1, y1);
				g.lineTo(x2,y2);
			}
			
		}
		static function RenderCircle(x:Number, y:Number, r:Number, col:uint, thickness:Number = 1, alpha:Number = 1)
		{
			var g:Graphics = linesScreen.graphics;
			g.lineStyle(thickness, col, alpha);
			g.drawCircle(x, y, r);			
		}
		
		static function FillCircle(x:Number, y:Number, r:Number, col:uint, thickness:Number = 1, alpha:Number = 1)
		{
			var g:Graphics = linesScreen.graphics;
			g.lineStyle(null,0,0);
			g.beginFill(col, alpha);
			g.drawCircle(x, y, r);			
			g.endFill();
		}
		
		static function RenderRectangle(r:Rectangle, col:uint, thickness:Number = 1,alpha:Number = 1)
		{
			var sx0:Number = 0;
			var sx1:Number = sx0 + Defs.displayarea_w;
			if (r.left >sx1) return;
			if (r.right <sx0) return;
			var sy0:Number = 0;
			var sy1:Number = sy0 + Defs.displayarea_h;
			if (r.top >sy1) return;
			if (r.bottom <sy0) return;

			
			RenderLine(r.left, r.top, r.right, r.top, col,thickness,alpha);
			RenderLine(r.left, r.bottom, r.right, r.bottom, col,thickness,alpha);
			RenderLine(r.left, r.top, r.left, r.bottom,  col,thickness,alpha);
			RenderLine(r.right, r.top, r.right, r.bottom,  col,thickness,alpha);
		}
		
		static function FillRectangle(r:Rectangle, col:uint, thickness:Number = 1,alpha:Number = 1)
		{
			var sx0:Number = 0;
			var sx1:Number = sx0 + Defs.displayarea_w;
			if (r.left >sx1) return;
			if (r.right <sx0) return;
			var sy0:Number = 0;
			var sy1:Number = sy0 + Defs.displayarea_h;
			if (r.top >sy1) return;
			if (r.bottom <sy0) return;

			
			var g:Graphics = linesScreen.graphics;
			g.lineStyle(null,0,0);
			g.beginFill(col, alpha);
			g.moveTo(r.left,r.top);
			g.lineTo(r.right,r.top);
			g.lineTo(r.right,r.bottom);
			g.lineTo(r.left,r.bottom);
			g.endFill();
		}
		
		static function SortInstancesByZ(list:Array):Array
		{
			var poi:EdObj;
			for each(poi in list)
			{
				poi.sortZ = 0;
				var po:PhysObj = Game.objectDefs.FindByName(poi.typeName);

				
				for each(var graphic:PhysObj_Graphic in po.graphics)
				{
					poi.sortZ = 0;
				}
				
			}
			list.sortOn("sortZ", Array.NUMERIC | Array.DESCENDING);
			return list;
		}
		
		
		// select initial obj please
		static function Editor_RenderPickedObjectsHilight():void
		{
			if (renderObjects == false) return;
			var bd:BitmapData = screenBD;
			var pos:Point = GetCurrentPieceInitialPos();
			for each (var ob:Object in currentPieceList)
			{
				var po:PhysObj = Game.objectDefs.GetByIndex(ob.id);
				if (po != null)
				{
					var x:Number = ob.origx;
					var y:Number = ob.origy;
					PhysObj.RenderOutline(po, x-scrollX, y-scrollY, 9, linesScreen.graphics);				
				}
				
			}
		}
		
		public static function Editor_RenderJoints1(bd:BitmapData)
		{
			var jointList:Array = Levels.GetCurrentLevelJoints();
			
			for each(var joint:EdJoint in jointList)
			{
				var doit:Boolean = true;
				if (editModeObj_Joints.selectedJoint == joint)
				{
					if (PhysEditor.updateTimer & 1) doit = false;
				}
				if (doit == true)
				{
					if (joint.type == EdJoint.Type_Rev) RenderRevJoint(bd, joint);
					if (joint.type == EdJoint.Type_Distance) RenderDistanceJoint(bd, joint);
					if (joint.type == EdJoint.Type_Prismatic) RenderPrismaticJoint(bd, joint);
				}
			}
		}

		public static function Editor_RenderJoints(bd:BitmapData)
		{
			PhysEditor.linesScreen.graphics.clear();
			var jointList:Array = Levels.GetCurrentLevelJoints();
			
			for each(var joint:EdJoint in jointList)
			{
				joint.Render();
			}
			PhysEditor.screenBD.draw(PhysEditor.linesScreen);

		}
		
		static function RemoveEverything()
		{
			editModeObj_Joints.RemoveAllJoints();
			PhysEditor.GetCurrentLevel().instances = new Array();
			
			PhysEditor.GetCurrentLevel().lines = new Array();
			editModeObj_Lines.currentLineIndex = -1;
			editModeObj_Lines.currentPointIndex = -1;
			
			
		}
		
		static function RenderRevJoint(bd:BitmapData, joint:EdJoint)
		{

			var zp:Point;
			var zp1:Point;
			
			zp = GetMapPos(joint.rev_pos.x, joint.rev_pos.y);
			
			Utils.RenderCircle(bd, zp.x,zp.y, 10, 0xffffffff);
			if (joint.obj0Name != "")
			{
				var inst:EdObj = PhysEditor.GetInstanceById(joint.obj0Name);
				if (inst != null)
				{
					zp1= GetMapPos(inst.x, inst.y);
					
					Utils.RenderDotLine(bd, zp.x,zp.y,zp1.x,zp1.y, 100, 0xffff0000);
					Utils.RenderCircle(bd, zp1.x,zp1.y, 5*zoom, 0xffffffff);

				}
			}
			if (joint.obj1Name != "")
			{
				var inst:EdObj = PhysEditor.GetInstanceById(joint.obj1Name);
				if (inst != null)
				{
					zp1 = GetMapPos(inst.x, inst.y);
					zp = GetMapPos(joint.rev_pos.x, joint.rev_pos.y);
					
					Utils.RenderDotLine(bd, zp.x, zp.y, zp1.x,zp1.y, 100, 0xffff8000);
					Utils.RenderCircle(bd, zp1.x,zp1.y, 5, 0xffffffff);
				}
			}
		}
		static function RenderPrismaticJoint(bd:BitmapData, joint:EdJoint)
		{
			var sx:Number = scrollX;
			var sy:Number = scrollY;
			var v0:Point = joint.prism_pos.clone();
			var v1:Point = joint.prism_pos1.clone();
			Utils.RenderDotLine(bd, v0.x-sx,v0.y-sy,v1.x-sx,v1.y-sy, 100, 0xffffffff);
		}
		static function RenderDistanceJoint(bd:BitmapData, joint:EdJoint)
		{
			var zp:Point;
			var zp1:Point;
			
			zp = GetMapPos(joint.dist_pos0.x, joint.dist_pos0.y);
			zp1 = GetMapPos(joint.dist_pos1.x, joint.dist_pos1.y);
			
			
			Utils.RenderDotLine(bd, zp.x,zp.y, zp1.x,zp1.y, 100, 0xff00ffff);
			Utils.RenderCircle(bd, zp.x,zp.y, 5, 0xff00cccc);
			Utils.RenderCircle(bd, zp1.x,zp1.y, 5, 0xff00cccc);
		}
			
		
		
		public static function RenderSortedEdObjs()
		{
			var sortList:Array = new Array();
			var l:Level = GetCurrentLevel();
			var level_instances:Array = GetCurrentLevelInstances();
			
			for each(var poi:EdObj in level_instances)
			{
				poi.SetSortPosFromGameLayer();
				sortList.push(poi);
			}
			var i:int = 0;
			for each(var line:EdLine in l.lines)
			{
				line.SetSortPosFromGameLayer();
				sortList.push(line);
				line.index = i;
				i++;
			}
			
			sortList.sortOn("sort_zpos",Array.NUMERIC|Array.DESCENDING);

			for each(var base:EditableObjectBase in sortList)
			{
				if (base is EdObj)
				{
					poi = base as EdObj;
					poi.Render();
				}
				if ( base is EdLine)
				{
					line = base as EdLine;
					line.RenderInner();					
				}
			}			
		}
		
		
		static function Editor_RenderObjects()
		{
			if (renderObjects == false) return;
			var level_instances:Array = GetCurrentLevelInstances();
			
			if (objectZSortMode)
			{
				level_instances = SortInstancesByZ(level_instances);
			}
			
			
			var bd:BitmapData = screenBD;
			for each(var poi:EdObj in level_instances)
			{
				poi.Render();
			}
		}
		
		
		public static function ExportAllLevelsAsXml()
		{
			var sss:String = "";
			var i:int;
			var cl:int = currentLevel;
			for (i = 0; i < Levels.list.length; i++)
			{
				currentLevel = i;
				sss += ExportLevelAsXml();
				sss += "\n\n";
			}
			currentLevel = cl;
			ExternalData.OutputString(sss);

		}
		
		public static function GetAllLevelsAsXml():String
		{
			var sss:String = "";
			var i:int;
			var cl:int = currentLevel;
			
			sss += "<data>";
			sss += "\n\n";
			
			for (i = 0; i < Levels.list.length; i++)
			{
				currentLevel = i;
				sss += ExportLevelAsXml();
				sss += "\n\n";
			}
			
			sss += "</data>";
			
			currentLevel = cl;
			return sss;

		}
		
		public static function GetAllTemplatesAsXml():String
		{
			var sss:String = "";
			var i:int;
			
			sss += "<data>";
			sss += "\n\n";
			
			for (i = 0; i < Levels.templates.length; i++)
			{
				sss += ExportTemplateAsXML(Levels.templates[i]);
				sss += "\n\n";
			}
			
			sss += "</data>";
			
			return sss;

		}
		
		
		
		public static function UndoTakeSnapshot()
		{
			var l:Level = GetCurrentLevel();
			
			var undo:Object = new Object();
			var lines:Array = new Array();
			var objs:Array = new Array();
			var joints:Array = new Array();
			
			for each(var line:EdLine in l.lines)
			{
				var newline:EdLine = line.Clone();				
				lines.push(newline);
			}			
			undo.lines = lines;
			
			
			var level_instances:Array = GetCurrentLevelInstances();
			for each(var poi:EdObj in level_instances)
			{			
				var newpoi:EdObj = poi.Clone();
				objs.push(newpoi);				
			}
			undo.objects = objs;
			
			for each(var joint:EdJoint in l.joints)
			{
				var newjoint:EdJoint = joint.Clone();				
				joints.push(newjoint);
			}			
			undo.joints = joints;
			
			
			editModeObj_UI.ToUndo(undo);
			
			undoList.push(undo);
			
		}
		
		public static function DoUndo()
		{
			var l:Level = GetCurrentLevel();
			
			if (undoList.length == 0) return;
			
			var undo:Object = undoList.pop();
			
			var joints:Array = undo.joints;
			var lines:Array = undo.lines;
			var objects:Array = undo.objects;
			
			l.lines = new Array();
			
			for each(var line:EdLine in lines)
			{
				var newline:EdLine = line.Clone();				
				l.lines.push(newline);
			}
			
			if (objects.length != 0)
			{
				var level_instances:Array = new Array();
				for each(var poi:EdObj in objects)
				{			
					var newpoi:EdObj = poi.Clone();
					level_instances.push(newpoi);				
				}				
				Levels.list[currentLevel].instances = level_instances;
			}
			
			l.joints = new Array();
			for each(var joint:EdJoint in joints)
			{
				var newjoint:EdJoint = joint.Clone();				
				l.joints.push(newjoint);
			}			
			
			editModeObj_Multi.AfterUndo();
			editModeObj_Lines.currentLineIndex = -1;
			editModeObj_Lines.currentPointIndex = -1;
			
			editModeObj_UI.FromUndo(undo);
			editModeObj_UI.AfterUndo();

		}
		
		
		
		public static function ExportLevelAsXml():String
		{
			var l:Level = GetCurrentLevel();
			return ExportLevelAsXmlInner(l);
		}

		public static function ExportLevelAsXmlInner(l:Level):String
		{
			
			var s:String = "";
			var ss:String = "";
			
			s = '<level id="' + l.id+'"';
			s += ' name="' + l.name+ '"';
			s += ' displayname="' + l.displayName+ '"';
			s += ' category="' + l.category.toString() + '"';
			s += ' desc="' + l.description + '"';
			s += ' bg="' + l.bgFrame + '"';
			s += ' >';
			ss += s + "\n";
			//Utils.print(s);

			
			s = Levels.GetGameSpecificLevelDataXML(currentLevel);			
			ss += s + "\n";
			//Utils.print(s);
			
			
			for each(var frameID:int in l.helpscreenFrames)
			{
				s = '\t<helpscreen frame="' + frameID + '" />';
				ss += s + "\n";
				//Utils.print(s);
			}
			
			var level_instances:Array = GetCurrentLevelInstances();
			
			for each(var libfilter:String in editModeObj_Library.libraryFilters)
			{
				var active:Boolean = false;
				for each(var poi:EdObj in level_instances)
				{
					var po:PhysObj = Game.objectDefs.FindByName(poi.typeName);
					if (po != null && po.libraryClass == libfilter) active = true;
				}
				if (active)
				{
					s = '\t<objgroup name="' + libfilter + '">';
					ss += s + "\n";
					//Utils.print(s);
					for each(var poi:EdObj in level_instances)
					{
						var po:PhysObj = Game.objectDefs.FindByName(poi.typeName);
						
						
						if (po != null && po.libraryClass == libfilter)
						{
							var paramString:String = poi.GetParameterListForExport();
							
							s = '\t\t<obj id="'+poi.id+'" type="' + poi.typeName + '" x="' + poi.x + '" y="' + poi.y + '" rot="' + poi.rot + '" scale="' + poi.scale + '" xflip="' + poi.isXFlipped +'" params="' + paramString +'" />';
							ss += s + "\n";
							//Utils.print(s);
						}
					}
					s = '\t</objgroup>';
					ss += s + "\n";
					//Utils.print(s);
				}
				
			}
			
			s = '\t<joints>';
			ss += s + "\n";
			//Utils.print(s);
			for each(var joint:EdJoint in l.joints)
			{
				s = joint.GetExportXMLString();
				
				ss += s + "\n";
				Utils.print(s);
				
			}
			s = '\t</joints>';
			ss += s + "\n";
			//Utils.print(s);

			var i:int;
			var j:int;
			
			
			var point:Point;
			
			for each(var line:EdLine in l.lines)
			{
				
				var paramString:String = line.GetParameterListForExport();
				
				s = '<line type="' + line.type + '" id="' + line.id +'"';
				s += ' params="' + paramString + '"' + ' >'
				ss += s + "\n";
				//Utils.print(s);

				var i:int;
				var j:int;
				
				var points:Array = line.points;
				
				var numPoints:int = points.length;
				var numPerLine:int = 10;
				var numGroups:int = numPoints / numPerLine;
				var numRemainder:int = numPoints % numPerLine;
				var count:int = 0;
				
				
				for (i = 0; i < numGroups; i++)
				{
					var s1:String = '<points a="';
					for (j = 0; j < numPerLine; j++)
					{
						point = points[count++];
						s1 += point.x + "," + point.y;
						if (j != numPerLine-1) s1 += ", ";
					}
					s1 += '" />';
					s = s1;
					ss += s + "\n";
					//Utils.print(s);
				}
				if (numRemainder != 0)
				{
					var s1:String = '<points a="';
					for (j = 0; j < numRemainder; j++)
					{
						point = points[count++];
						s1 += point.x + "," + point.y;
						if (j != numRemainder-1) s1 += ", ";
					}
					s1 += '" />';
					s = s1;
					ss += s + "\n";
					//Utils.print(s);
					
				}
				
				s = '</line>';
				ss += s + "\n";
				//Utils.print(s);

			}
			
			
			
			s = '<map';
			s += ' minx="' + l.mapMinX + '"';
			s += ' maxx="' + l.mapMaxX + '"';
			s += ' miny="' + l.mapMinY + '"';
			s += ' maxy="' + l.mapMaxY + '"';
			s += ' cellw="' + l.mapCellW + '"';
			s += ' cellh="' + l.mapCellH + '"';
			s += ' >';
			ss += s + "\n";
			//Utils.print(s);
			
			var len:int = l.map.length;
			var start:int = 0;
			var doneit:Boolean = false;
			numPerLine = 600;
			
			do
			{
				if (len >= numPerLine)
				{
					s = '<mapdata a="'; 
					for (i = start; i < start + numPerLine; i++)
					{
						s += l.map[i].toString();
					}
					s += '"/>';
					ss += s + "\n";
					start += numPerLine;
					len -= numPerLine;
				}
				else
				{
					s = '<mapdata a="'; 
					for (i = start; i < start + len; i++)
					{
						s += l.map[i].toString();
					}
					s += '"/>';
					ss += s + "\n";
					doneit = true;
				}
			}while (doneit == false);
			
			s = '</map>';
			ss += s + "\n";
			//Utils.print(s);
			
			
			s = '</level>';
			ss += s + "\n";
			//Utils.print(s);

			return ss;
		}

		
		public static function ExportTemplateAsXML(l:LayoutTemplate):String
		{
			
			var s:String = "";
			var ss:String = "";
			
			s = '<template id="' + l.id+'"';
			s += ' >';
			ss += s + "\n";
			//Utils.print(s);

			var level_instances:Array = l.instances;
			
			for each(var libfilter:String in editModeObj_Library.libraryFilters)
			{
				var active:Boolean = false;
				for each(var poi:EdObj in level_instances)
				{
					var po:PhysObj = Game.objectDefs.FindByName(poi.typeName);
					if (po != null && po.libraryClass == libfilter) active = true;
				}
				if (active)
				{
					s = '\t<objgroup name="' + libfilter + '">';
					ss += s + "\n";
					//Utils.print(s);
					for each(var poi:EdObj in level_instances)
					{
						var po:PhysObj = Game.objectDefs.FindByName(poi.typeName);
						
						
						if (po != null && po.libraryClass == libfilter)
						{
							var paramString:String = poi.GetParameterListForExport();
							
							s = '\t\t<obj id="'+poi.id+'" type="' + poi.typeName + '" x="' + poi.x + '" y="' + poi.y + '" rot="' + poi.rot + '" scale="' + poi.scale + '" xflip="' + poi.isXFlipped +'" params="' + paramString +'" />';
							ss += s + "\n";
							//Utils.print(s);
						}
					}
					s = '\t</objgroup>';
					ss += s + "\n";
					//Utils.print(s);
				}
				
			}
			
			s = '\t<joints>';
			ss += s + "\n";
			//Utils.print(s);
			for each(var joint:EdJoint in l.joints)
			{
				s = joint.GetExportXMLString();
				
				ss += s + "\n";
				Utils.print(s);
				
			}
			s = '\t</joints>';
			ss += s + "\n";
			//Utils.print(s);

			var i:int;
			var j:int;
			
			
			var point:Point;
			
			for each(var line:EdLine in l.lines)
			{
				
				var paramString:String = line.GetParameterListForExport();
				
				s = '<line type="' + line.type + '" id="' + line.id +'"';
				s += ' params="' + paramString + '"' + ' >'
				ss += s + "\n";
				//Utils.print(s);

				var i:int;
				var j:int;
				
				var points:Array = line.points;
				
				var numPoints:int = points.length;
				var numPerLine:int = 10;
				var numGroups:int = numPoints / numPerLine;
				var numRemainder:int = numPoints % numPerLine;
				var count:int = 0;
				
				
				for (i = 0; i < numGroups; i++)
				{
					var s1:String = '<points a="';
					for (j = 0; j < numPerLine; j++)
					{
						point = points[count++];
						s1 += point.x + "," + point.y;
						if (j != numPerLine-1) s1 += ", ";
					}
					s1 += '" />';
					s = s1;
					ss += s + "\n";
					//Utils.print(s);
				}
				if (numRemainder != 0)
				{
					var s1:String = '<points a="';
					for (j = 0; j < numRemainder; j++)
					{
						point = points[count++];
						s1 += point.x + "," + point.y;
						if (j != numRemainder-1) s1 += ", ";
					}
					s1 += '" />';
					s = s1;
					ss += s + "\n";
					//Utils.print(s);
					
				}
				
				s = '</line>';
				ss += s + "\n";
				//Utils.print(s);

			}
			
			
			
			s = '</template>';
			ss += s + "\n";
			//Utils.print(s);

			return ss;
		}
		
		
		public static function GetAllObjectsList():Array
		{
			var a0:Array = GetCurrentLevel().joints;
			var a1:Array = GetCurrentLevel().lines;
			var a2:Array = GetCurrentLevel().instances;
			var a:Array = a0.concat(a1);
			a = a.concat(a2);
			return a;
		}
		
		
		public static function DragBoxAnyObject(r:Rectangle):Array
		{
			var obj:EditableObjectBase = null;
			
			var a0:Array = editModeObj_Joints.HitTestRectangle(r);
			var a1:Array = editModeObj_Lines.HitTestRectangle(r);
			var a2:Array = ObjectsHitTestRectangle(r);
			
			var a:Array = a0.concat(a1);
			a = a.concat(a2);
			
			return a;
			
		}
	
		static function ObjectsHitTestRectangle(r:Rectangle):Array
		{
			var a:Array = new Array();
			var level_instances:Array = GetCurrentLevelInstances();
			for each (var obj:EdObj in level_instances)
			{
				if (obj.HitTestRectangle(r)) 
				{
					a.push(obj);
				}
			}
			return a;
		}
		
		public static function HitTestAnyObjectNoJoints(x:Number, y:Number,screenX:Number,screenY:Number):EditableObjectBase
		{
			var obj:EditableObjectBase = null;
			obj = HitTestPhysObjGraphics(screenX, screenY) as EditableObjectBase;
			if (obj == null) obj = HitTestLineArea(x, y) as EditableObjectBase;
			return obj;
		}
		
		public static function HitTestAnyObject(x:Number, y:Number,screenX:Number,screenY:Number):EditableObjectBase
		{
			var obj:EditableObjectBase = null;
			obj = HitTestJoint(x, y) as EditableObjectBase;
			if (obj == null) obj = HitTestPhysObjGraphics(screenX, screenY) as EditableObjectBase;
			if (obj == null) obj = HitTestLineArea(x, y) as EditableObjectBase;
			return obj;
		}
		
		public static function HitTestJoint(x:Number, y:Number):EdJoint
		{
			var j:EdJoint = editModeObj_Joints.GetJointAtPosition(x, y);
			return j;
		}
		
		public static function HitTestLineArea(x:Number, y:Number):EdLine
		{
			editModeObj_Lines.Lines_SelectLineByArea(x, y);
			if (editModeObj_Lines.currentLineIndex != -1)
			{
				var level:Level = GetCurrentLevel();
				return level.lines[editModeObj_Lines.currentLineIndex];
			}
			return null;
		}
		
		
		public static function HitTestLinePoints(x:Number, y:Number):EdLine
		{
			editModeObj_Lines.Lines_SelectLineByPoint(x, y);
			if (editModeObj_Lines.currentLineIndex != -1)
			{
				var level:Level = GetCurrentLevel();
				return level.lines[editModeObj_Lines.currentLineIndex];
			}
			return null;
		}
		public static function HitTestPhysObjGraphics(x:Number, y:Number,onlyPhysObjs:Boolean = false):EdObj
		{
			var level_instances:Array = GetCurrentLevelInstances();
			
			var i:int;
			for (i = level_instances.length - 1; i >= 0; i--)
			{
				var poi:EdObj = level_instances[i];

				
				var po:PhysObj = Game.objectDefs.FindByName(poi.typeName);
				if (po != null)
				{

					var doit:Boolean = true;
					if (onlyPhysObjs) 
					{	
						doit = false;
						if (po.hasPhysics) doit = true;
					}
					
					
					if (EditorLayers.IsLocked(poi.GetCurrentLayer()))
					{
						doit = false;
					}
					
					if(doit)
					{
						var bd:BitmapData = hittestScreenBD;
						bd.fillRect(Defs.screenRect, 0);	
					
						var p:Point = GetMapPos(poi.x, poi.y);
						
						PhysObj.RenderAt(po, p.x,p.y, poi.rot, poi.scale*zoom,bd,null,false,null,null,null,poi.isXFlipped);
						
						var col:uint = bd.getPixel(x, y);
						if (col != 0)
						{
							return poi;
						}				
					}
				}
			}
			return null;
		}
		

		
		static function GetCurrentLevelLines():Array
		{
			return Levels.list[currentLevel].lines;
		}
		static function GetCurrentLevelJoints():Array
		{
			return Levels.list[currentLevel].joints;
		}
		static function GetCurrentLevelInstances():Array
		{
			return Levels.list[currentLevel].instances;
		}
		static function SetCurrentLevelInstances(instances:Array):void
		{
			Levels.list[currentLevel].instances = instances;
		}
		static function GetCurrentLevel():Level
		{
			return Levels.GetLevel(currentLevel);
		}
		
		public static function DeleteObject(obj:EditableObjectBase)
		{
			if (obj.classType == "obj") RemoveFromLevelInstances(obj as EdObj);
			if (obj.classType == "line") DeleteLine(obj as EdLine);
			if (obj.classType == "joint") DeleteJoint(obj as EdJoint);
			
		}
		
		public static function DeleteLine(obj:EdLine)
		{
			var lineList:Array = GetCurrentLevelLines();			
			if (lineList.indexOf(obj) != -1)
			{
				lineList.splice(lineList.indexOf(obj), 1);
			}						
		}
		public static function DeleteJoint(obj:EdJoint)
		{
			var jointList:Array = GetCurrentLevelJoints();			
			if (jointList.indexOf(obj) != -1)
			{
				jointList.splice(jointList.indexOf(obj), 1);
			}			
		}
		public static function RemoveFromLevelInstances(poi:EdObj)
		{
			var level_instances:Array = GetCurrentLevelInstances();
			var list1:Array = new Array();
			for each(var p:EdObj in level_instances)
			{
				if (p == poi)
				{
					
				}
				else
				{
					list1.push(p);
				}
			}
			level_instances = list1;
			Levels.list[currentLevel].instances = level_instances;
		}

		public static function RemoveByTypeNameFromLevelInstances(name:String)
		{
			var level_instances:Array = GetCurrentLevelInstances();
			var list1:Array = new Array();
			for each(var p:EdObj in level_instances)
			{
				if (p.typeName == name)
				{
					trace("removing " + name+" from level "+currentLevel);
				}
				else
				{
					list1.push(p);
				}
			}
			level_instances = list1;
			Levels.list[currentLevel].instances = level_instances;
		}
		
		static function Editor_RenderLineToCursor()
		{
			linesScreen.graphics.clear();
			if (editModeObj_Lines.addlineActive == false) return;
			if (editModeObj_Lines.subMode != "addpoint") return;
			var l:Level = GetCurrentLevel();
			if (editModeObj_Lines.currentLineIndex == -1) return;
			var line:EdLine = l.lines[editModeObj_Lines.currentLineIndex];

			if (line.primitiveType == EdLine.PRIMITIVE_LINE)
			{			
				GetMousePositions();
				
				var i:int = line.points.length - 1;
				var p0:Point = GetMapPos(line.points[i].x,line.points[i].y);
				var p1:Point = GetMapPos(mxs,mys);
				var bd:BitmapData = screenBD;
				RenderLine(p1.x, p1.y, p0.x, p0.y, 0xff00ffff);
			}
			screenBD.draw(linesScreen);
		}
		
		
		static function GetMapPosRect(r:Rectangle):Rectangle
		{
			var r1:Rectangle = r.clone();
			var p:Point;
			p = GetMapPos(r.x, r.y);
			r1.x = p.x;
			r1.y = p.y;
			p = GetPos(r.width, r.height);
			r1.width = p.x;
			r1.height = p.y;
			return r1;
		}
		static function GetMapPosPoints(a:Array):Array
		{
			var b:Array = new Array();
			for each(var p:Point in a)
			{
				var p1:Point = GetMapPos(p.x, p.y);
				b.push(p1);
			}
			return b;
		}
		public static function GetMapPos(x:int, y:int):Point
		{
			return GetMapPosPoint( new Point(x,y));
		}
		public static function GetMapPosPoint(p:Point):Point
		{
			return new Point( (p.x - PhysEditor.scrollX) * zoom, (p.y - PhysEditor.scrollY) * zoom);
		}
		public static function GetPos(x:int, y:int):Point
		{
			var p:Point = new Point( (x) * zoom, (y) * zoom);
			return p;
		}
		
		static var mx:int;
		static var my:int;
		static var sx:Number;
		static var sy:Number;
		static var mxs:int;
		static var mys:int;
		static var mxs_nogrid:int;
		static var mys_nogrid:int;
		
		static function GetMousePositions()
		{
			GetMousePositionsXY(MouseControl.x, MouseControl.y);
		}
		
		static function GetMousePositionsXY(x:Number,y:Number)
		{
			mx = x;
			my = y;

			var gs:Number = gridsnap;	// / zoom;
			
			mxs_nogrid = (mx * (1/PhysEditor.zoom)) + PhysEditor.scrollX;;
			mys_nogrid = (my * (1/PhysEditor.zoom)) + PhysEditor.scrollY;;
			
			if (PhysEditor.gridMode_active)
			{
				gs = gridsnap / zoom;
				mx = Math.round(mx);
				my = Math.round(my);
				mx = int(mx / gs) * int(gs);
				my = int(my / gs) * int(gs);
			}
			else
			{
				mx = Math.round(mx);
				my = Math.round(my);
			}
			
			sx = scrollX;
			sy = scrollY;
			if (gridMode_active)
			{
				gs = gridsnap;
				if (false)	// this works (disregarding scroll)
				{
				
					sx = 0;	// Math.round(sx);
					sy = 0;	// Math.round(sy);
					
					var mxa:Number = Math.round(MouseControl.x);
					var mya:Number = Math.round(MouseControl.y);
					
					mxs = (mxa * (1 / zoom));
					mys = (mya * (1 / zoom));
					
					mxs = int(mxs / gs) * int(gs);
					mys = int(mys / gs) * int(gs);
				}
				else
				{
						// works for 
					sx = Math.round(sx);
					sy = Math.round(sy);
					
					var mxa:Number = Math.round(MouseControl.x);
					var mya:Number = Math.round(MouseControl.y);
					
					mxs = (mxa * (1 / zoom)) +sx;
					mys = (mya * (1 / zoom)) +sy;
					
					mxs = int(mxs / gs) * int(gs);
					mys = int(mys / gs) * int(gs);
					
				}
				
			}
			else
			{
				sx = Math.round(sx);
				sy = Math.round(sy);
				
				mxs = (mx * (1/zoom)) + sx;
				mys = (my * (1 / zoom)) + sy;
				
			}
			
			
		}
		
		
		static function Editor_RenderLines1(_useCursor:Boolean = false)
		{
			var l:Level = GetCurrentLevel();
			var i:int = 0;
			for each(var line:EdLine in l.lines)
			{
				line.index = i;
				line.RenderInner();
				i++;
			}
			
		}
		
		/*
		static function Editor_RenderLines(_useCursor:Boolean = false)
		{
			if (editModeObj_Lines.addlineActive == false) _useCursor = false;
			if (editModeObj_Lines.subMode != "addpoint") _useCursor = false;
			
			
			
			var p0:Point = new Point();
			var p1:Point = new Point();
			var r:Rectangle = new Rectangle();
			
			var l:Level = GetCurrentLevel();
			var bd:BitmapData = screenBD;
			var lineIndex:int = 0;
			for each(var line:EdLine in l.lines)
			{
				var layer:int = 0;
				if (line.objParameters.GetParam("editor_layer") != "")
				{
					layer = line.objParameters.GetValueInt("editor_layer")-1;
				}
				
				if (IsLayerVisible(layer) == true)
				{
				
					var points:Array = line.points;
					if (lineIndex == editModeObj_Lines.currentLineIndex && _useCursor && line.primitiveType==EdLine.PRIMITIVE_LINE) 
					{
						GetMousePositions();
						points = new Array();
						for each(var p0:Point in line.points)
						{
							points.push(p0.clone());
						}
						points.push(new Point(mxs, mys));
					}
					var points1:Array = new Array;
					for each(var p:Point in points)
					{
						var zp:Point = GetMapPos( p.x, p.y);
						points1.push(zp);
					}
					points = points1;
					
					var lineMode:int = GetLineTypeMode(line.type);
					var doNormals:Boolean = false;
					if ( (lineMode & LM_LINK) != 0) doNormals = true;
					var col:uint = GetLineTypeColor(line.type);
					var thickness:int = 1;
					if (lineIndex == editModeObj_Lines.currentLineIndex) 
					{
	//					col = 0xffffffff;
						thickness = 2;
					}
					if (points.length >= 2)
					{
						var i:int;
						for (i = 0; i < points.length - 1; i++)
						{
							p0 = points[i];
							p1 = points[i + 1];
							RenderLine(p0.x,p0.y, p1.x,p1.y,col,thickness,1,doNormals);
						}
						if ( (lineMode & LM_LINK) != 0)
						{
							p0 = points[points.length-1];
							p1 = points[0];
							RenderLine(p0.x,p0.y, p1.x,p1.y,col,thickness,1,doNormals);
						}
					}
					if ( (lineMode & LM_FILL) != 0)
					{
						FillPoly(points, col, 0.1);
					}
					
					if (line.primitiveType == EdLine.PRIMITIVE_LINE)
					{
						for (i = 0; i < points.length; i++)
						{
							col = 0xffff0000;
							if (lineIndex == editModeObj_Lines.currentLineIndex && editModeObj_Lines.currentPointIndex == i) col = 0xffffff00;
							var off1:int = 2;
							var off2:int = 4;
							if (lineIndex == hoverLineIndex && hoverPointIndex == i)
							{
								off1 = 3;
								off2 = 6;
							}
							r.x = points[i].x - off1;
							r.y = points[i].y - off1;
							r.width = off2;
							r.height = off2;
							
							RenderRectangle(r, col);
						}					
					}
					
					if (line.primitiveType == EdLine.PRIMITIVE_RECTANGLE)
					{
						for (i = 0; i <= 2; i+=2)
						{
							col = 0xffff0000;
							if (lineIndex == editModeObj_Lines.currentLineIndex && editModeObj_Lines.currentPointIndex == i) col = 0xffffff00;
							var off1:int = 2;
							var off2:int = 4;
							if (lineIndex == hoverLineIndex && hoverPointIndex == i)
							{
								off1 = 3;
								off2 = 6;
							}
							r.x = points[i].x - off1;
							r.y = points[i].y - off1;
							r.width = off2;
							r.height = off2;
							
							RenderRectangle(r, col);
						}
						
					}
				}
				lineIndex++;
			}			
		}
		*/
		
		static function HighlightLinePoly(line:EdLine)
		{
			if (line == null) return;
			
			var points:Array = GetMapPosPoints(line.points);
			
			FillPoly(points, 0xffffff, 0.5);
		}

		static function AddNewLevel()
		{
			EdModalDialog.Start("Add new level (at end)?", "", AddNewLevel_Result);
		}
		static function AddNewLevel_Result(result:EdModalDialogResult)
		{
			if (result.yes == false) return;
			trace("NEW LEVEL!");
			var l:Level = new Level();
			l.fullyLoaded = true;
			Levels.list.push(l );
			currentLevel = Levels.list.length - 1;
			Levels.currentIndex = currentLevel;
		}
		
		
	}
	
}



