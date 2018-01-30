package EditorPackage 
{
	import EditorPackage.EditParamUI.EditParams;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditMode_Library extends EditMode_Base
	{
		
		public var selectedObjects:Vector.<PhysObj>;
		var selectedParameters:ObjParameters;
		var isTemplateMode:Boolean;
		
		
		public function EditMode_Library() 
		{
			
		}
		
		public override function EnterMode():void
		{
			PhysEditor.CursorText_Show();
			PhysEditor.CursorText_Set("");			
		}
		public override function InitOnce():void
		{
			InitLibraryFilter();
			ClearSelected();
			isTemplateMode = false;
		}
		
		
		public override function OnMouseDown(e:MouseEvent):void
		{
			Library_PickPiece();			
		}
		
		public override function OnRightMouseDown(e:MouseEvent):void
		{
			super.OnRightMouseDown(e);
			Library_PickPieceMulti();
		}
		
		
		
		public override function OnMouseUp(e:MouseEvent):void
		{
			
		}
		public override function OnMouseMove(e:MouseEvent):void
		{
			Library_GetHoverPieceName();
			
		}
		public override function OnMouseWheel(delta:int):void
		{
			if (delta > 0) 
			{
				library_page++;
				if (library_page >= GetNumLibraryPages()) library_page = 0;	
			}
			if (delta < 0) 
			{
				library_page--;
				if (library_page < 0) library_page = GetNumLibraryPages() - 1;
			}
			
		}
		public override function Update():void
		{
			
			if (KeyReader.Pressed(KeyReader.KEY_T))
			{	
				isTemplateMode = (isTemplateMode == false);
			}

			if (KeyReader.Pressed(KeyReader.KEY_DELETE))
			{	
				DeleteSelected();
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_C))
			{				
				ClearSelected();
			}
			if (KeyReader.Pressed(KeyReader.KEY_ESCAPE))
			{				
				if (selectedObjects.length != 0)
				{
					PhysEditor.SetEditMode(PhysEditor.editMode_Adjust)
					PhysEditor.editModeObj_Adjust.SetSubMode("place");
					PhysEditor.editModeObj_Adjust.ClearPlacementObjectsList();
					for each(var o:PhysObj in selectedObjects)
					{
						PhysEditor.editModeObj_Adjust.AddPlacementObjectToList(new EdPlacementObj(o.name));
					}
					PhysEditor.editModeObj_Adjust.PickRandomPlacementObject();					
				}
				
				
			}
			if (KeyReader.Pressed(KeyReader.KEY_DOWN))
			{				
				library_page++;
				if (library_page >= GetNumLibraryPages()) library_page = 0;	
			}
			if (KeyReader.Pressed(KeyReader.KEY_UP))
			{
				library_page--;
				if (library_page < 0) library_page = GetNumLibraryPages() - 1;
			}
			
			if (KeyReader.Pressed(KeyReader.KEY_1))
			{
				NextLibraryFilter();
			}
			if (KeyReader.Pressed(KeyReader.KEY_2))
			{
				NextLibrarySize();
			}
			
		}
		public override function Render(bd:BitmapData):void
		{
			super.Render(bd);
			
			var s:String;
			bd.fillRect(Defs.screenRect, 0xff6040c0);
			var x:int = 0;
			var y:int = 0;
			for (x = pickerRectangle.x; x <= pickerRectangle.right; x+=boxSizeW)
			{
				PhysEditor.RenderLine(x, pickerRectangle.y, x, pickerRectangle.bottom,0xff40c040)
			}
			for (x = pickerRectangle.y; x <= pickerRectangle.bottom; x+=boxSizeH)
			{
				PhysEditor.RenderLine(pickerRectangle.x, x, pickerRectangle.right, x, 0xff40c040);
			}
			
			if (isTemplateMode == false)
			{
				RenderObjects(bd);
			}
			else
			{
				RenderTemplates(bd);
			}
			
		}
		
		function RenderObjects(bd:BitmapData)
		{
			var s:String;
			var x:int = 0;
			var y:int = 0;
			
			var numPerPage:int = boxNumW * boxNumH;

			var min:int = library_page * numPerPage;
			var max:int = min + (numPerPage-1);
			
			
			x = pickerRectangle.left;
			y = pickerRectangle.top;
			var index:int = 0;
			var xp:int = 0;
			var yp:int = 0;
			
			for each (var po:PhysObj in libraryPieces)				
			{
				if (index >= min && index <= max)
				{
					var maxDestRect:Rectangle = new Rectangle(x + 8, y + 8, boxSizeW - 16, boxSizeH - 16);
					PhysObj.RenderAt(po, x + (boxSizeW / 2), y + (boxSizeH / 2), 0, 1, bd, PhysEditor.linesScreen.graphics, true, null, maxDestRect);

					if (po.markers.Count() != 0)
					{
						for (var markerIndex:int = 0; markerIndex < po.markers.Count(); markerIndex++)
						{							
							PhysObj.RenderMarkerAt(po, x + (boxSizeW / 2), y + (boxSizeH / 2), 0, 1, bd, PhysEditor.linesScreen.graphics, null, maxDestRect,false, markerIndex);
						}
					}
					
					x += boxSizeW;
					xp++;
					if (xp >= boxNumW) 
					{
						x = 0;
						y += boxSizeH;
						xp = 0;
					}

					
					if(IsInSelectedList(po))
					{
						PhysEditor.RenderRectangle(maxDestRect, 0xff0000, 4, 1);
						
					}
					
				}
				index++;
			}
			
		}
		
		function RenderTemplates(bd:BitmapData)
		{
			var s:String;
			var x:int = 0;
			var y:int = 0;
			
			var numPerPage:int = boxNumW * boxNumH;

			var min:int = library_page * numPerPage;
			var max:int = min + (numPerPage-1);
			
			
			x = pickerRectangle.left;
			y = pickerRectangle.top;
			var index:int = 0;
			var xp:int = 0;
			var yp:int = 0;
			
			for each (var template:LayoutTemplate in Levels.templates)				
			{
				if (index >= min && index <= max)
				{
					/*
					var maxDestRect:Rectangle = new Rectangle(x + 8, y + 8, boxSizeW - 16, boxSizeH - 16);
					PhysObj.RenderAt(po, x + (boxSizeW / 2), y + (boxSizeH / 2), 0, 1,bd,PhysEditor.linesScreen.graphics,true,null,maxDestRect);
					x += boxSizeW;
					xp++;
					if (xp >= boxNumW) 
					{
						x = 0;
						y += boxSizeH;
						xp = 0;
					}
					*/
				}
				index++;
			}
			
		}

		
		public override function RenderHud(x:int,y:int):int
		{
			var s:String;
			s = "1: Filter [" + libraryFilter + "] " + int(libraryFilterIndex + 1) + "/" + libraryFilters.length;
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "2: Scale "+int(librarySizeIndex + 1) + "/" + numLibrarySizes;
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "C: Clear multi select";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "DEL: Delete selected objects";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "RMB: toggle multi selection";
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "ESC: Back to Adjust if multi selected";
			y += PhysEditor.AddInfoText("a", x, y, s);
			
			var savedy:int;
			
			
			var numPerPage:int = boxNumW * boxNumH;

			var min:int = library_page * numPerPage;
			var max:int = min + (numPerPage-1);
			
			x = pickerRectangle.left;
			y = pickerRectangle.top;
			
			var index:int = 0;
			var xp:int = 0;
			var yp:int = 0;
			
				
			if (isTemplateMode == false)
			{
				for each (var po:PhysObj in libraryPieces)				
				{
					if (index >= min && index <= max)
					{
						s = po.name;
						PhysEditor.AddInfoText("a", x+8, y+boxSizeH- 16, s);
						x += boxSizeW;
						xp++;
						if (xp >= boxNumW) 
						{
							x = 0;
							y += boxSizeH;
							xp = 0;
						}
					}
					index++;
				}
			}
			else
			{
				for each (var template:LayoutTemplate in Levels.templates)				
				{
					if (index >= min && index <= max)
					{
						s = template.id;
						PhysEditor.AddInfoText("a", x+8, y+boxSizeH- 16, s);
						x += boxSizeW;
						xp++;
						if (xp >= boxNumW) 
						{
							x = 0;
							y += boxSizeH;
							xp = 0;
						}
					}
					index++;
				}
				
			}
			
			

			
			return savedy;
		}		
		
		
		var pickerRectangle:Rectangle = new Rectangle(0, 0, Defs.displayarea_w, Defs.displayarea_h);
		var boxNumW:Number = 5;
		var boxNumH:Number = 4;
		var boxSizeW:Number = Defs.displayarea_w/boxNumW;
		var boxSizeH:Number = Defs.displayarea_h/boxNumH;
		
		var library_page:int = 0;
		
		function GetPieceAtMouse():PhysObj
		{
			var mx:int = MouseControl.x;
			var my:int = MouseControl.y;
			mx -= pickerRectangle.left;
			my -= pickerRectangle.top;
			var x:int = mx / boxSizeW;
			var y:int = my / boxSizeH;
			var pos:int = x + (y * boxNumW);
			
			
			var numPerPage:int = boxNumW * boxNumH;

			pos += library_page * numPerPage;
			
			var num:int = libraryPieces.length - 1;
			if (pos > num) pos = num;
			
			
			var po:PhysObj = libraryPieces[pos];
			return po;
		}

		function GetTemplateAtMouse():LayoutTemplate
		{
			var mx:int = MouseControl.x;
			var my:int = MouseControl.y;
			mx -= pickerRectangle.left;
			my -= pickerRectangle.top;
			var x:int = mx / boxSizeW;
			var y:int = my / boxSizeH;
			var pos:int = x + (y * boxNumW);
			
			
			var numPerPage:int = boxNumW * boxNumH;

			pos += library_page * numPerPage;
			
			var num:int = Levels.templates.length - 1;
			if (pos > num) pos = num;
			
			
			var template:LayoutTemplate = Levels.templates[pos];
			return template;
		}
		
		
		function Library_PickPiece()
		{
			
			if (isTemplateMode == false)
			{
				PhysEditor.SetEditMode(PhysEditor.editMode_Adjust)
				var po:PhysObj = GetPieceAtMouse();

				PhysEditor.editModeObj_Adjust.PickSinglePlacementObject( new EdPlacementObj(po.name));
				PhysEditor.editModeObj_Adjust.SetSubMode("place");
			}
			else
			{
				PhysEditor.SetEditMode(PhysEditor.editMode_Multi)
				var template:LayoutTemplate = GetTemplateAtMouse();
				PhysEditor.editModeObj_Multi.AddTemplate(template);
			}
			
			
		}

		function Library_PickPieceMulti()
		{
			if (isTemplateMode ) return;	// not yet
			var po:PhysObj = GetPieceAtMouse();
			
			ToggleSelected(po);
		}
		

		public var library_hoverPieceName:String = "";
		function Library_GetHoverPieceName()
		{
			library_hoverPieceName = "";
			var mx:int = MouseControl.x;
			var my:int = MouseControl.y;
			mx -= pickerRectangle.left;
			my -= pickerRectangle.top;
			var x:int = mx / boxSizeW;
			var y:int = my / boxSizeH;
			var pos:int = x + (y * boxNumW);
			
			
			var numPerPage:int = boxNumW * boxNumH;

			pos += library_page * numPerPage;
			
			var num:int = libraryPieces.length - 1;
			if (pos > num) pos = num;
			
			
			var po:PhysObj = libraryPieces[pos];
			if (po != null)
			{
				library_hoverPieceName = po.name;
			}
		}
		
		var libraryFilter:String = "";
		var libraryFilterIndex:int = 0;
		public var libraryFilters:Array;
		var librarySizeIndex:int;
		var numLibrarySizes:int;
		var librarySizes:Array;
		
		function DoesLibraryFilterListContain(filter:String):Boolean
		{
			for each(var s:String in libraryFilters)
			{
				if (s == filter) return true;
			}
			return false;
		}
		function InitLibraryFilter()
		{
			pickerRectangle = new Rectangle(0, 60, Defs.displayarea_w, Defs.displayarea_h - 80);
			
			libraryFilterIndex = -1;
			libraryFilter = "";
			libraryFilters = new Array();
			libraryFilters.push("");
			librarySizeIndex = -1;
			
			librarySizes = new Array();
			librarySizes.push(new Point(4, 3),new Point(5, 4), new Point(7, 5), new Point(9, 7),new Point(12, 10));
			numLibrarySizes = librarySizes.length;
			
			
			for each(var po:PhysObj in Game.objectDefs.list)
			{				
				if (po.displayInLibrary)
				{					
					if (DoesLibraryFilterListContain(po.libraryClass) == false)
					{
						libraryFilters.push(po.libraryClass);
					}
				}
			}
			
			for each(var ss:String in libraryFilters)
			{
				Utils.print("filter: " + ss);
			}
			
			NextLibraryFilter();
			NextLibrarySize();
			
		}
		
		function TestLibraryFilter(filter:String):Boolean
		{
			if (libraryFilter == "") return true;
			if (libraryFilter == filter) return true;
			return false;
		}
		
		function NextLibrarySize()
		{
			librarySizeIndex++;
			if (librarySizeIndex >= numLibrarySizes)
			{
				librarySizeIndex = 0;
			}
			var p:Point = librarySizes[librarySizeIndex];
			
			boxNumW = p.x;
			boxNumH = p.y;
			boxSizeW = pickerRectangle.width / boxNumW;
			boxSizeH = pickerRectangle.height/boxNumH;

			if (library_page > GetNumLibraryPages())
			{			
				library_page = GetNumLibraryPages() - 1;
			}

			
			GetLibraryPieces();
			
		}
		function NextLibraryFilter()
		{
			libraryFilterIndex++;
			if (libraryFilterIndex >= libraryFilters.length)
			{
				libraryFilterIndex = 0;
			}
			libraryFilter = libraryFilters[libraryFilterIndex];
			library_page = 0;
			GetLibraryPieces();
			
		}
		
		
		var libraryPieces:Array;
		function GetLibraryPieces()
		{
			libraryPieces = new Array();
			for each(var po:PhysObj in Game.objectDefs.list)
			{
				if (po.displayInLibrary && TestLibraryFilter(po.libraryClass) ) 
				{
					libraryPieces.push(po);
				}
			}
		}
		
		function CountLibraryPieces():int
		{
			var count:int = 0;
			for each(var po:PhysObj in Game.objectDefs.list)
			{
				if (po.displayInLibrary && TestLibraryFilter(po.libraryClass) ) 
				{
					count++;
				}
			}
			return count;
		}
		
		function GetNumLibraryPages():int
		{
			var numPerPage:int = boxNumW * boxNumH;
			
			var num:int = CountLibraryPieces();
			
			var p:int = num / numPerPage;
			var pr:int = num % numPerPage;
			if (pr != 0) p++;
			return p;
			
		}

//---------------------------------------------------------------

		public function ParameterChanged(op:ObjParameter)
		{
			Utils.print("param changed " + op.name + "  " + op.value);
			
			for (var i:int = 0; i < selectedObjects.length; i++)
			{
				var params:ObjParameters = selectedObjects[i].objParameters;
				
				if (params.Exists(op.name))
				{
					params.SetParam(op.name, op.value)
					op.multipleValues = false;
				}
			}
			EditParams.AddParameterListBox(selectedParameters,ParameterChanged);
		}
		
		function SetSelectedParameters()
		{
			if (selectedObjects.length == 0)
			{
				EditParams.ClearParameterListBox();
			}
			else
			{
				
				selectedParameters = new ObjParameters();
				
				for (var i:int = 0; i < selectedObjects.length; i++)
				{
					var params:ObjParameters = selectedObjects[i].objParameters.Clone();
					selectedParameters.AddMultiParameters(params);
				}
				
				EditParams.AddParameterListBox(selectedParameters,ParameterChanged);
			}
		}
		
		function ClearSelected()
		{
			selectedObjects = new Vector.<PhysObj>();
			EditParams.ClearParameterListBox();
		}
		
		function DeleteSelected()
		{
			for each(var o:PhysObj in selectedObjects)
			{
				var index:int = Game.objectDefs.list.indexOf(o);
				if (index != -1)
				{
					Game.objectDefs.list.splice(index, 1);
				}
				trace("deleting " + index);
			}
			GetLibraryPieces();

			EdModalDialog.Start("Remove instances in ALL levels?", "",DeleteDialogResult);
			

		}
		
		function DeleteDialogResult(result:EdModalDialogResult)
		{
			if (result.yes == false) return;
			
			var oldCurrentLevel:int = Levels.currentIndex;
			var oldCurrentLevel1:int = PhysEditor.currentLevel;
			
			for (var lindex:int = 0; lindex < Levels.list.length; lindex++)
			{
				Levels.currentIndex = lindex;
				PhysEditor.currentLevel = lindex;
				
				for each(var o:PhysObj in selectedObjects)
				{
					PhysEditor.RemoveByTypeNameFromLevelInstances(o.name);
				}				
			}
			
			Levels.currentIndex = oldCurrentLevel;
			PhysEditor.currentLevel = oldCurrentLevel1;
			
		}
		
		function AddToSelected(obj:PhysObj,updateParameters:Boolean=true)
		{
			if (obj == null) return;
			var a:int = selectedObjects.indexOf(obj);
			if (a == -1)
			{			
				selectedObjects.push(obj);
			}
			if (updateParameters)
			{
				SetSelectedParameters();
			}
		}
		function RemoveFromSelected(obj:PhysObj)
		{
			if (obj == null) return;
			var a:int = selectedObjects.indexOf(obj);
			if (a != -1)
			{			
				selectedObjects.splice(a, 1);
			}
			SetSelectedParameters();
		}
		function IsInSelectedList(obj:PhysObj):Boolean
		{
			if (obj == null) return false;
			var a:int = selectedObjects.indexOf(obj);
			return (a != -1);			
		}
		
		function ToggleSelected(obj:PhysObj)
		{
			if (obj == null) return;
			if (IsInSelectedList(obj))
			{
				RemoveFromSelected(obj);
			}
			else
			{
				AddToSelected(obj);
			}
		}

//----------------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------------		
		function SaveXML()
		{
			if (isTemplateMode == false)
			{
				Game.objectDefs.SaveXML();			
			}
			else
			{
				PhysEditor.ClearEditorMode();
				
				var sss:String = PhysEditor.GetAllTemplatesAsXml();
				var fileRef:FileReference;
				fileRef = new FileReference();
				fileRef.save(sss, ExternalData.templatesSaveName);			
			}
		}
		
	}

}