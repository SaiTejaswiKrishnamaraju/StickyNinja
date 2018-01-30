package EditorPackage 
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import UIPackage.UIX;
	import UIPackage.UIX_Component;
	import UIPackage.UIX_Instance;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class EditMode_UILibrary extends EditMode_Base
	{
		
		public function EditMode_UILibrary() 
		{
			
		}
		
		public override function EnterMode():void
		{
			PhysEditor.CursorText_Show();
			PhysEditor.CursorText_Set("");			
			InitLibraryFilter();
		}
		public override function InitOnce():void
		{
			InitLibraryFilter();
		}
		
		
		public override function OnMouseDown(e:MouseEvent):void
		{
			PhysEditor.SetEditMode(PhysEditor.editMode_UI)
			Library_PickPiece();
			
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
			
			
			var numPerPage:int = boxNumW * boxNumH;

			var min:int = library_page * numPerPage;
			var max:int = min + (numPerPage-1);
			
			
			x = pickerRectangle.left;
			y = pickerRectangle.top;
			var num:int = Game.objectDefs.GetNum();
			var index:int = 0;
			var xp:int = 0;
			var yp:int = 0;
			
			for each (var comp:UIX_Component in libraryPieces)				
			{
				if (index >= min && index <= max)
				{
					var maxDestRect:Rectangle = new Rectangle(x + 8, y + 8, boxSizeW - 16, boxSizeH - 16);
//					PhysObj.RenderAt(po, x + (boxSizeW / 2), y + (boxSizeH / 2), 0, 1,bd,PhysEditor.linesScreen.graphics,true,null,maxDestRect);


					var inst:UIX_Instance = new UIX_Instance();
					inst.componentName = comp.name;
					inst.SetComponentFromName();
					inst.RenderInRectangle(bd,maxDestRect);
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
		public override function RenderHud(x:int,y:int):int
		{
			var s:String;
			s = "1: Filter [" + libraryFilter + "] " + int(libraryFilterIndex + 1) + "/" + libraryFilters.length;
			y += PhysEditor.AddInfoText("a", x, y, s);
			s = "2: Scale "+int(librarySizeIndex + 1) + "/" + numLibrarySizes;
			y += PhysEditor.AddInfoText("a", x, y, s);
			
			var savedy:int;
			
			var numPerPage:int = boxNumW * boxNumH;

			var min:int = library_page * numPerPage;
			var max:int = min + (numPerPage-1);
			
			
			x = pickerRectangle.left;
			y = pickerRectangle.top;
			var num:int = Game.objectDefs.GetNum();
			var index:int = 0;
			var xp:int = 0;
			var yp:int = 0;
			
			for each (var comp:UIX_Component in libraryPieces)				
			{
				if (index >= min && index <= max)
				{
					//PhysObj.RenderAt(po, x + (boxSizeW / 2), y + (boxSizeH / 2), 0, 1,bd,PhysEditor.linesScreen.graphics,true,new Rectangle(x+8,y+8,boxSizeW-16,boxSizeH-16));
					s = comp.name;
					PhysEditor.AddInfoText("a", x+8, y+boxSizeH- 16, s);
//					GraphicObjects.RenderStringAt(bd, GraphicObjects.gfx_font1, x +8, y +boxSizeH- 16, s,null,-2);
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
			
			
			return savedy;
		}		
		
		
		var pickerRectangle:Rectangle = new Rectangle(0, 0, Defs.displayarea_w, Defs.displayarea_h);
		var boxNumW:Number = 5;
		var boxNumH:Number = 4;
		var boxSizeW:Number = Defs.displayarea_w/boxNumW;
		var boxSizeH:Number = Defs.displayarea_h/boxNumH;
		
		var library_page:int = 0;
		function Library_PickPiece()
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
			
			
			var comp:UIX_Component = libraryPieces[pos];
			
			
//			PhysEditor.ClearCurrentPieces();
//			PhysEditor.AddCurrentPiece(Game.objectDefs.FindIndexByName(po.name), 0, 0, 0);
			
			PhysEditor.editModeObj_UI.CreatePlacementInstanceFromLibraryComponent(comp);
			PhysEditor.editModeObj_UI.SetSubMode("place");
			
			
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
			
			
			var comp:UIX_Component = libraryPieces[pos];
			if (comp != null)
			{
				library_hoverPieceName = comp.name
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
			
			for each(var comp:UIX_Component in UIX.GetComponents())
			{
				libraryPieces.push(comp);
			}
		}
		
		function CountLibraryPieces():int
		{
			var count:int = 0;
			for each(var comp:UIX_Component in UIX.GetComponents())
			{
				count++;
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
		
	}

}