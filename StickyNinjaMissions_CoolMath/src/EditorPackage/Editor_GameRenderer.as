package EditorPackage 
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import TextPackage.TextRenderer;
	/**
	 * ...
	 * @author Julian
	 */
	public class Editor_GameRenderer 
	{
		
		public function Editor_GameRenderer() 
		{
			
		}
		
		
		function RenderPathObjectCircular(po:PhysObj, poi:EdObj)
		{
			var bd:BitmapData = PhysEditor.screenBD;
			var p:Point = PhysEditor.GetMapPos(poi.x, poi.y);
			PhysObj.RenderAt(po, p.x, p.y, poi.rot, poi.scale * PhysEditor.zoom, bd, PhysEditor.linesScreen.graphics, true);	
		
			Utils.GetParams(poi.initFunctionParams);
			
			var circlepath_radius:Number = poi.objParameters.GetValueNumber("circlepath_radius");
			var circlepath_startang:Number = Utils.DegToRad( poi.objParameters.GetValueNumber("circlepath_startang"));
			var circlepath_angvel:Number = Utils.DegToRad( poi.objParameters.GetValueNumber("circlepath_angvel"));
			
			var gmat:Matrix = new Matrix();
			var gpoint:Point = new Point();
			
			gmat.identity();
			gmat.rotate(circlepath_startang);
			gpoint.x = 0;
			gpoint.y = -circlepath_radius;
			gpoint = gmat.transformPoint(gpoint);
			
			var x1:Number = p.x + gpoint.x;
			var y1:Number = p.y + gpoint.y;
			
			Utils.RenderDotLine(bd, p.x, p.y, x1, y1, 100, 0xffffffff);
			Utils.RenderCircle(bd, x1, y1, 5, 0xffff0000);
			
		}

		function RenderPathObjectPendulum(po:PhysObj, poi:EdObj)
		{
			var bd:BitmapData = PhysEditor.screenBD;
			var p:Point = PhysEditor.GetMapPos(poi.x, poi.y);
			PhysObj.RenderAt(po, p.x, p.y, poi.rot, poi.scale * PhysEditor.zoom, bd, PhysEditor.linesScreen.graphics, true);	
		
			Utils.GetParams(poi.initFunctionParams);
			
			var circlepath_radius:Number = poi.objParameters.GetValueNumber("circlepath_radius");
			var circlepath_startang:Number = Utils.DegToRad( poi.objParameters.GetValueNumber("circlepath_startang"));
			
			var gmat:Matrix = new Matrix();
			var gpoint:Point = new Point();
			
			gmat.identity();
			gmat.rotate(circlepath_startang);
			gpoint.x = 0;
			gpoint.y = -circlepath_radius;
			gpoint = gmat.transformPoint(gpoint);
			
			var x1:Number = p.x + gpoint.x;
			var y1:Number = p.y + gpoint.y;
			
			Utils.RenderDotLine(bd, p.x, p.y, x1, y1, 100, 0xffffffff);
			Utils.RenderCircle(bd, x1, y1, 5, 0xffff0000);
			
		}
		
		function RenderHelpText(po:PhysObj, poi:EdObj)
		{
			var bd:BitmapData = PhysEditor.screenBD;
			var p:Point = PhysEditor.GetMapPos(poi.x, poi.y);
			PhysObj.RenderAt(po, p.x, p.y, poi.rot, poi.scale * PhysEditor.zoom, bd, PhysEditor.linesScreen.graphics, true);	

			var s:String = poi.objParameters.GetValueString("helptext_text", "helptxt");
			var c:String = poi.objParameters.GetValueString("helptext_color");
			var ct:ColorTransform = Utils.HexStringToColorTransform(c);
			
			
			TextRenderer.RenderAt(0,bd, p.x, p.y, s, Utils.DegToRad(poi.rot), poi.scale,TextRenderer.JUSTIFY_CENTRE,ct);
			
		}

		function RenderHelpTextWithMarker(po:PhysObj, poi:EdObj)
		{
			var bd:BitmapData = PhysEditor.screenBD;
			var p:Point = PhysEditor.GetMapPos(poi.x, poi.y);
			PhysObj.RenderAt(po, p.x, p.y, poi.rot, poi.scale * PhysEditor.zoom, bd, PhysEditor.linesScreen.graphics, true);	

			var s:String = poi.objParameters.GetValueString("helptext_text", "helptxt");
			var c:String = poi.objParameters.GetValueString("helptext_color");
			var ct:ColorTransform = Utils.HexStringToColorTransform(c);
			
			
			TextRenderer.RenderAt(0,bd, p.x, p.y, s, Utils.DegToRad(poi.rot), poi.scale,TextRenderer.JUSTIFY_CENTRE,ct);
			
			var dobj:DisplayObj = GraphicObjects.GetDisplayObjByName("walkthroughMarker");
			dobj.RenderAt(0, bd, p.x-25, p.y-10);
			
		}
		
	}

}