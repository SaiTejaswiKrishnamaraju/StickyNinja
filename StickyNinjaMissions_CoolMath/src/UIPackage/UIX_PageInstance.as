package UIPackage 
{
	import EditorPackage.EditorLayers;
	import EditorPackage.PhysEditor;
	import fl.controls.List;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.system.System;
	import flash.ui.GameInputControl;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import LicPackage.Lic;
	import LicPackage.LicDef;
	import MobileSpecificPackage.MobileSpecific;
	import TextPackage.TextRenderer;
	/**
	 * ...
	 * @author 
	 */
	public class UIX_PageInstance 
	{
		public var pageInstance:UIX_Instance;
		public var pageName:String;
		var isInputtingText:Boolean;
		var inputText:UIX_InputText;
		
		public var gameObjects:UIX_GameObjects;
		
		var preUpdateFunction:Function;
		var dragInititialPressX:int;
		var dragInititialPressY:int;
		var dragMode:int;
		var dragTimer:int;
		
		var dragMoveStartX:Number;
		var dragMoveX:Number;
		var dragMoveVelocityX:Number;
		var dragMoveInstance:UIX_Instance = null;
		
		var currentTimer:Number = 0;
		
		public function UIX_PageInstance() 
		{
			preUpdateFunction = null;
			gameObjects = new UIX_GameObjects();
		}
		
		public function Child(instName:String):UIX_Instance
		{
			var inst:UIX_Instance;
			
			if (instName.indexOf(".") != -1)
			{
				var a:Array = instName.split(".");
				if (a.length != 2) return null;
				
				inst = pageInstance.Child(a[0]);
				if (inst == null) return null;
				
				inst = inst.Child(a[1]);
				return inst;
			}
			
			inst = pageInstance.Child(instName);
			return inst;
		}
		
		public function GetZSortedInstances():Array
		{
			return pageInstance.GetZSortedInstances();
		}
		
		function ExportGameObjectsMoveOn()
		{
			var s:String;
			
			var a:Array = new Array();
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
				if (inst.GetInstanceName() != null && inst.GetInstanceName() != "")
				{
					a.push(inst);
				}
			}
			
			a = a.sortOn("x");
			a = a.sortOn("y");
			a = a.sortOn("z",Array.DESCENDING|Array.NUMERIC);
			
			s = "\t\t\tvar go:UIX_GameObj;";
			s += "\n";
			var i:int = 0;
			for each(var inst:UIX_Instance in a)
			{
				s += '\t\t\tgo = pageInst.gameObjects.AddInstance(pageInst.Child("' + inst.GetInstanceName() + '"));';
				s += "\n";
				s += "\t\t\tgo.InitAppear(UIX_GameObj.EDGE_BOTTOM, "+i+");";
				s += "\n";
				i++;
			}
			trace(s);
			System.setClipboard(s);

		}
		
		var tabPos:int;
		function TracePage()
		{
			tabPos = 0;
			trace("HIERARCHY:");
			TracePageInner(pageInstance);
			trace(":END");
		}
		function TracePageInner(inst:UIX_Instance)
		{
			var tab:String = GetTabStr();
			trace(tab + inst.componentName + "  [x:" + inst.x + "  y:" + inst.y + "  r:" + inst.rot + "]   [" + inst.currentMatrix.position.x + ", " + inst.currentMatrix.position.y + "]");
			tabPos++;
			for each(var childInst:UIX_Instance in inst.childInstances)
			{
				TracePageInner(childInst);
			}
			tabPos--;
		}
		function GetTabStr():String
		{
			var s:String = "";
			for (var i:int = 0; i < tabPos; i++)
			{
				s += "-";
			}
			return s;
		}
		
		public function CreateFromPageDef(def:UIX_PageDef)
		{
			pageInstance = new UIX_Instance();
			pageName = def.name;
			
			var instances:Vector.<UIX_Instance> = def.GetInstances();
			instances = instances.sort(SortChildCompareFunc);
			
			for each(var inst:UIX_Instance in instances)
			{
				var i1:UIX_Instance = inst.Clone();
				i1.pageDefInstance = inst;
				i1.parentInst = pageInstance;
				pageInstance.AddChildInst(i1);	// childInstances.push(i1);
				
				CreateFromPageDef_Inner(i1);
			}	
//			TracePage();
		}

		public function CreateFromComponentDef(componentDef:UIX_Component)
		{
			pageInstance = new UIX_Instance();
			pageInstance.component = componentDef;
			
			var instances:Vector.<UIX_Instance> = componentDef.GetInstances();
			instances = instances.sort(SortChildCompareFunc);
			
			for each(var inst:UIX_Instance in instances)
			{
				var i1:UIX_Instance = inst.Clone();
				i1.pageDefInstance = inst;
				i1.parentInst = pageInstance;
				pageInstance.AddChildInst(i1);	// childInstances.push(i1);
				
				CreateFromPageDef_Inner(i1);
			}	
//			TracePage();
		}
		
		// if there are any component subinstances, add them to the list.
		
		function CreateFromPageDef_Inner(inst:UIX_Instance)
		{
			var comp:UIX_Component = UIX.GetComponentByName(inst.componentName);
			
			SortChildInstances(inst);
			
			for each(var inst1:UIX_Instance in comp.instances)
			{
				var newInst:UIX_Instance = inst1.Clone();
				newInst.parentInst = inst;
				inst.AddChildInst(newInst);	// childInstances.push(newInst);
				CreateFromPageDef_Inner(newInst);
				
			}
		}
		
		function SortChildInstances(inst:UIX_Instance)
		{
			inst.childInstances = inst.childInstances.sort(SortChildCompareFunc);
		}
		function SortChildCompareFunc(x:UIX_Instance, y:UIX_Instance):Number
		{
			if (x.z > y.z) return -1;
			if (x.z < y.z) return 1;
			return 0;
		}
		
		
		function CalculateBounds()
		{
			pageInstance.currentMatrix = new Matrix3D();
			CalculateBoundsInner(pageInstance);
		}
		function CalculateBoundsInner(parentInst:UIX_Instance)
		{
			parentInst.boundingRectangle = parentInst.ownBoundingRectangle.clone();
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				parentInst.boundingRectangle = parentInst.boundingRectangle.union(inst.ownBoundingRectangle);

				CalculateBoundsInner(inst);
			}			
		}
		
		
		function CalculateMatrices()
		{
			pageInstance.currentMatrix = new Matrix3D();
			CalculateMatricesInner(pageInstance);
		}
		function CalculateMatricesInner(parentInst:UIX_Instance)
		{
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				inst.currentMatrix = inst.CalcMatrix(parentInst.currentMatrix);
				CalculateMatricesInner(inst);
			}			
		}

		// assumes that matrices have been calculated
		function CalculateBoundingRectangles()
		{
			pageInstance.currentMatrix = new Matrix3D();
			CalculateBoundingRectanglesInner(pageInstance);
		}
		function CalculateBoundingRectanglesInner(parentInst:UIX_Instance)
		{
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				inst.ownBoundingRectangle = inst.GetBoundsRect(parentInst.currentMatrix);
				inst.boundingRectangle = inst.ownBoundingRectangle.clone();
				CalculateBoundingRectanglesInner(inst);
			}			
		}
		
		function PassDownValues()
		{
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
				inst.render_alpha = inst.alpha;
				inst.render_colorMultiply.x = inst.colorMultiply.x;
				inst.render_colorMultiply.y = inst.colorMultiply.y;
				inst.render_colorMultiply.z = inst.colorMultiply.z;
				
				PassDownValuesInner(inst);
			}
		}
		function PassDownValuesInner(parentInst:UIX_Instance)
		{
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				inst.render_alpha = inst.alpha * parentInst.render_alpha;
				inst.render_colorMultiply.x = inst.colorMultiply.x * parentInst.render_colorMultiply.x;
				inst.render_colorMultiply.y = inst.colorMultiply.y * parentInst.render_colorMultiply.y;
				inst.render_colorMultiply.z = inst.colorMultiply.z * parentInst.render_colorMultiply.z;

				PassDownValuesInner(inst);
			}			
		}
		
		
		public var renderBD:BitmapData;
		var calculateFlag:Boolean = true;
		
		
		var r:Number = 0;
		var r1:Number = 0;
		
		public function RenderWithoutReset()
		{
			
			if (calculateFlag)
			{
				CalculateMatrices();
				PassDownValues();
//				CalculateBounds();
				calculateFlag = true;
			}
			
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
				UpdateAllInstances_Inner(inst);
			}
			
			RenderInner(pageInstance);			
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
				UpdateAllInstancesPostRender_Inner(inst);
			}
		}
		
		public function Render()
		{
			EngineDebug.StartTimer("renderui");
			if (PROJECT::useStage3D)
			{
				s3d.StartRender();

				s3d.SetCurrentBlendMode(s3d.BLENDMODE_ALPHA);
				s3d.SetCurrentShader("alphamul");
				
			}
			else
			{
				renderBD.fillRect(renderBD.rect, 0x0);
			}
			
			
			if (calculateFlag)
			{
				CalculateMatrices();
				PassDownValues();
//				CalculateBounds();
				calculateFlag = true;
			}
			RenderInner(pageInstance);

			
			if (Game.usedebug)
			{
				if (KeyReader.Pressed(KeyReader.KEY_H))
				{
					TracePage();
				}
			}
			
//			Game.RenderPanel(renderBD);
			
			var s:String;
			var x:Number = 20;
			var y:Number = 100;
			
//			s = "mouse " + int(mouseX) + " " + int(mouseY)+"      "+int(mouseStageX)+" "+int(mouseStageY);
//			TextRenderer.RenderAt(renderBD, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
//			y += 20;
//			s = "rect " + lastBoundingRectangle;
//			TextRenderer.RenderAt(renderBD, x, y, s,0,1,TextRenderer.JUSTIFY_LEFT);
//			y += 20;
			
			
			if (PROJECT::useStage3D)
			{
				s3d.EndRender();
			}
			EngineDebug.EndTimer("renderui");
			
		}
		
		public function UpdateEditor()
		{
			CalculateMatrices();
			CalculateBoundingRectangles();
			PassDownValues();
			CalculateBounds();			
		}
		public function RenderEditor(_bd:BitmapData)
		{
			renderBD = _bd;
			CalculateMatrices();
			CalculateBoundingRectangles();
			PassDownValues();
			CalculateBounds();
			

			if (KeyReader.Pressed(KeyReader.KEY_H))
			{
				TracePage();
			}
			if (KeyReader.Pressed(KeyReader.KEY_G))
			{
				ExportGameObjectsMoveOn();
			}
			
			RenderInner_Editor(pageInstance);
		}
		
		
		function RenderInner(parentInst:UIX_Instance)
		{
			if (parentInst.visible == true)
			{
				parentInst.RenderSingleUsingMatrix(renderBD);
				
				//if (parentInst.mouseEnabled && parentInst.button_isHovered)
				//{
				//	parentInst.RenderBoundingRect(renderBD);
				//}
				for each(var inst:UIX_Instance in parentInst.childInstances)
				{
					RenderInner(inst);
				}						
			}
		}

		function RenderInner_Editor(parentInst:UIX_Instance)
		{
			if (parentInst.visible == true)
			{
				var vis:Boolean = true;
				if (EditorLayers.IsVisible(parentInst.editorLayer-1) == false) vis = false;

				
				if (vis)
				{
					parentInst.RenderSingleUsingMatrix(renderBD, -PhysEditor.scrollX, -PhysEditor.scrollY);
				}
				if (parentInst.editor_selected)
				{
					parentInst.component.RenderCollision(renderBD, parentInst.currentMatrix,-PhysEditor.scrollX+1,-PhysEditor.scrollY+1);
					parentInst.component.RenderCollision(renderBD, parentInst.currentMatrix,-PhysEditor.scrollX+2,-PhysEditor.scrollY+2);
				}
				if (parentInst.component != null)
				{
					parentInst.component.RenderCollision(renderBD, parentInst.currentMatrix,-PhysEditor.scrollX,-PhysEditor.scrollY);
				}
				for each(var inst:UIX_Instance in parentInst.childInstances)
				{
					RenderInner_Editor(inst);
				}						
			}
		}
		
//----------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------

		var lastBoundingRectangle:Rectangle = new Rectangle(0, 0, 1, 1);
		function ButtonsHandleClick()
		{
			ButtonsHandleClickInner(pageInstance);
		}
		function ButtonsHandleClickInner(parentInst:UIX_Instance)
		{
			if (parentInst.mouseEnabled && parentInst.visible && parentInst.button_canPress)
			{
				lastBoundingRectangle = parentInst.boundingRectangle.clone();
				
				if (parentInst.component.type == UIX_Component.TYPE_DRAGBOX)
				{
					
					if (parentInst.HitTestUsingMatrix(mouseX, mouseY))
					{
						if (parentInst.dragBox_dragActive)
						{
							dragMode = 1;		// dragging but not moved yet
							dragTimer = 0;
							Utils.print("dragmode 1");
							dragMoveInstance = parentInst;
							dragInititialPressX = mouseX;
							dragInititialPressY = mouseY;
						}
					}

				}
				
				//if (dragMode == 0 || (dragMode == 1 && dragTimer > 10) )
				//{
				//	if (parentInst.HitTestUsingMatrix(mouseX, mouseY))
				//	{
				//		parentInst.MouseClick();
				//	}
				//}
			}
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				ButtonsHandleClickInner(inst);
			}		
		}
//----------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------

		var releasePressedInstances:Array;
		function ButtonsHandleRelease()
		{
			releasePressedInstances = new Array();
			ButtonsHandleReleaseInner(pageInstance);
			
			if (releasePressedInstances.length == 0) return;
			releasePressedInstances = releasePressedInstances.sortOn("z");
			
						
//			for each(var inst:UIX_Instance in releasePressedInstances)
//			{
//				trace(inst.GetInstanceName()+" : "+inst.z)				
//			}
			
			var inst:UIX_Instance = releasePressedInstances[0]; // top of list
			if (inst.component.type == UIX_Component.TYPE_INPUTTEXT)
			{
				StartInput(inst)
			}
			else
			{
				StopInput();
				inst.MouseClick();
			}
		}
		function ButtonsHandleReleaseInner(parentInst:UIX_Instance)
		{
			if (parentInst.mouseEnabled && parentInst.visible && parentInst.button_canPress)
			{
				lastBoundingRectangle = parentInst.boundingRectangle.clone();
				
				if (dragMode == 0 || dragMode == 1)
				{
					if (parentInst.HitTestUsingMatrix(mouseX, mouseY))
					{
						releasePressedInstances.push(parentInst);
					}
				}
			}
			
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				ButtonsHandleReleaseInner(inst);
			}		
		}

//----------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------

		function ButtonsHandleMove()
		{
			ButtonsHandleHoverInner(pageInstance);
		}
		function ButtonsHandleHoverInner(parentInst:UIX_Instance)
		{
			var hasJustMovedOver:Boolean = false;
			var hasJustMovedOut:Boolean = false;
			if (parentInst.mouseEnabled && parentInst.button_canPress)
			{
				if (parentInst.component.type == UIX_Component.TYPE_DRAGBOX)
				{
					if (parentInst.dragBox_dragActive)
					{
						if (dragMode != 0)	// started to drag
						{
							var dist:Number = Math.abs(dragInititialPressX - mouseX);
							if (dist > 5)
							{
								dragMode = 2; // has moved
							}
						}
						if (dragMode == 2)
						{
							DragItemsHorizontal(parentInst, dragMoveX);							
						}
					}
				}

				if (PROJECT::useStage3D == false)
				{

					
					if (parentInst.button_isHovered)
					{
						if (parentInst.HitTestUsingMatrix(mouseX, mouseY) == false)
						{
							parentInst.MouseOut();
							hasJustMovedOut = true;
						}					
					}
					else
					{
						if (parentInst.HitTestUsingMatrix(mouseX, mouseY))
						{
							parentInst.MouseOver();
							hasJustMovedOver = true;
						}
					}
				}
			}
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				ButtonsHandleHoverInner(inst);
			}		
			
			if (hasJustMovedOver)
			{
//				Mouse.cursor = MouseCursor.BUTTON;
			}
			if (hasJustMovedOut)
			{
//				Mouse.cursor = MouseCursor.ARROW;
			}
			
		}
//----------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------
		

		var transitionFlag:Boolean = false;
		var transitionDir:int = -1;
		var transitionTimer:Number;
		var transitionVel:Number;
		
		function StartTransitionOut()
		{
			
			transitionFlag = true;
			transitionDir = -1;
			transitionTimer = 0;
			transitionVel = 0.1;
			
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
				inst.transition_startx = inst.x;
				inst.transition_endx = inst.x-Defs.displayarea_w;
				inst.transition_startalpha = inst.alpha;
				inst.transition_endalpha = 0;
			}
			
		}
		function StartTransitionIn()
		{
			
			transitionFlag = true;
			transitionDir = 1;
			transitionTimer = 0;
			transitionVel = 0.1;
			
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
				inst.transition_startx = inst.x+Defs.displayarea_w;
				inst.transition_endx = inst.x;
				inst.transition_startalpha = 0;
				inst.transition_endalpha = inst.alpha;
			}
			
		}
		
		
		function UpdateTransition():Boolean
		{
			if (transitionFlag == false) return false;
			var done:Boolean = false;
			
			transitionTimer += transitionVel;
			if (transitionTimer >= 1) 
			{
				transitionTimer = 1;
				done = true;
			}
			
			var t:Number = transitionTimer;
			t = Ease.Power_InOut(t, 2);
			
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
//				inst.x = Utils.ScaleTo(inst.transition_startx, inst.transition_endx, 0, 1, t);
				//if (PROJECT::useStage3D)
				//{
					inst.alpha = Utils.ScaleTo(inst.transition_startalpha, inst.transition_endalpha, 0, 1, t);
				//}
			}
			if (done)
			{
				transitionFlag = false;
			}
			
			return done;
		}

		var cursorPos:int;
		function StartInput(_inst:UIX_Instance)
		{
			isInputtingText = true;
			_inst.SetText("");
			inputText = new UIX_InputText(this,_inst);
		}
		function StopInput()
		{
			isInputtingText = false;
			inputText = null;
		}
		9
		function UpdateTextInput()
		{
			if (isInputtingText == false) return;
			inputText.Update();
		}
		
		public function Update()
		{
			currentTimer++;
			if (preUpdateFunction != null)
			{
				preUpdateFunction();
			}
			gameObjects.Update();
			
			if (isInputtingText)
			{
				UpdateTextInput();
			}
			
			
			var transitionDone:Boolean = UpdateTransition();
			
			if (dragMode != 0)
			{
				dragTimer++;
			}
			else
			{
				if (Math.abs(dragMoveVelocityX) > 1)
				{
					DragItemsHorizontal(dragMoveInstance, dragMoveVelocityX);
					dragMoveVelocityX *= 0.75;
				}
				
			}
			
//			UpdateDragBoxes();
			
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
				UpdateAllInstances_Inner(inst);
			}
			Render();
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
				UpdateAllInstancesPostRender_Inner(inst);
			}
			
			if (transitionDone)
			{
				if (transitionDir == -1)	// out
				{
					// signal to tell that the new one can come in now.
					UI.StartTransitionIn();
				}
			}
			DPadUpdate();
		}

		
		public function OnEnterFrame(e:Event)
		{
			Update();
		}
		
		function UpdateAllInstances_Inner(parentInst:UIX_Instance)
		{
			parentInst.UpdateButton();
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				UpdateAllInstances_Inner(inst);
			}			
		}
		function UpdateAllInstancesPostRender_Inner(parentInst:UIX_Instance)
		{
			parentInst.UpdateButtonPostRender();
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				UpdateAllInstancesPostRender_Inner(inst);
			}			
		}
		
		
		public function StartEditor(_bd:BitmapData)
		{
			renderBD = _bd;
			calculateFlag = true;
		}
		
		
		public function InitAutoTypes()
		{
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
				if (inst.component.autoType == "coffee")
				{
					Lic.UIX_CoffeeButton(inst, pageName);
				}
				if (inst.component.autoType == "moregames")
				{
					Lic.UIX_MoreGamesButton(inst, pageName);
				}
				if (inst.component.autoType == "sponsorlogo")
				{
					Lic.UIX_SponsorLogo(inst,pageName);
				}
				if (inst.component.autoType == "facebook")
				{
					Lic.UIX_FacebookButton(inst,pageName);
				}
				if (inst.component.autoType == "twitter")
				{
					Lic.UIX_TwitterButton(inst,pageName);
				}
				if (inst.component.autoType == "y8")
				{
					Lic.UIX_Y8Logo(inst);
				}
				if (inst.component.autoType == "download")
				{
					Lic.UIX_DownloadForYourSiteButton(inst,pageName);
				}
				if (inst.component.autoType == "mobilegames_ios")
				{
					Lic.UIX_MobileGamesButton_iOS(inst,pageName);
				}
				if (inst.component.autoType == "mobilegames_android")
				{
					Lic.UIX_MobileGamesButton_Android(inst,pageName);
				}
				if (inst.component.autoType == "mobilegames_amazon")
				{
					Lic.UIX_MobileGamesButton_Amazon(inst,pageName);
				}
				if (inst.component.autoType == "mobilegames_all")
				{
					Lic.UIX_MobileGamesButton_All(inst,pageName);
				}
				if (inst.component.autoType == "disclaimer")
				{
					inst.visible = LicDef.GetCurrentSku().showDisclaimer;					
				}
				if (inst.component.autoType == "highscore")
				{
					Lic.UIX_HighscoreButton(inst);
				}
				if (inst.component.autoType == "submitscore")
				{
 					Lic.UIX_SubmitScoreButton(inst);
				}
				
				
			}
			
		}

		public function StartMouseHandlers()
		{
			var stage:Stage = LicDef.GetStage().stage;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, MouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseClickHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, MouseUpHandler);						
		}
		public function StopMouseHandlers()
		{
			var stage:Stage = LicDef.GetStage().stage;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, MouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, MouseClickHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, MouseUpHandler);			
		}

		public function Start(_bd:BitmapData)
		{
			currentTimer = 0;
			renderBD = _bd;
			Game.main.stage.addEventListener(Event.ENTER_FRAME, OnEnterFrame);		
			StartMouseHandlers();
			calculateFlag = true;
			dragMode = 0;
			dragTimer = 0;
			dragMoveStartX = 0;
			dragMoveVelocityX = 0;
			dragMoveX = 0;
			preUpdateFunction = null;
			gameObjects.Start();
			
			InitDpadControls();
			if (PROJECT::isMobile)
			{
				MobileSpecific.SetBackCB(backButtonPressed);
			}

		}
		function backButtonPressed()
		{
			if (UIX.hardwareBackButtonInstance != null)
			{
				UIX.hardwareBackButtonInstance.MouseClick();
			}
		}		
		
		public function Stop()
		{
			Game.main.stage.removeEventListener(Event.ENTER_FRAME, OnEnterFrame);	
			StopMouseHandlers();
		}
		
		var buttonPressed:Boolean = false;
		var buttonReleased:Boolean = false;
		public var mouseX:Number = 0;
		public var mouseY:Number = 0;
		public var mouseStageX:Number = 0;
		public var mouseStageY:Number = 0;
		

		function StoreMousePos(event:MouseEvent)
		{
			mouseStageX = event.stageX;
			mouseStageY = event.stageY;
			if (PROJECT::useStage3D)
			{
				mouseX = ScreenSize.GetScaledMousePosX(mouseStageX);
				mouseY = ScreenSize.GetScaledMousePosY(mouseStageY);
			}
			else
			{
				mouseX = mouseStageX;
				mouseY = mouseStageY;
			}
		}
			
		function MouseMoveHandler(event:MouseEvent):void 
		{		

			dragMoveX = event.stageX - dragMoveStartX;
			dragMoveStartX = event.stageX;
			
			StoreMousePos(event);
			ButtonsHandleMove();
		}
		function MouseClickHandler(event:MouseEvent):void 
		{
			dragMoveStartX = event.stageX;
			StoreMousePos(event);
			
			buttonPressed = true;
			buttonReleased = false;
			ButtonsHandleClick();			
		}
		function MouseUpHandler(event:MouseEvent):void 
		{
//			dragMoveX = event.stageX - dragMoveStartX;
//			dragMoveStartX = event.stageX;
			
			Utils.print("up " + dragMoveX);
			
			StoreMousePos(event);
			buttonPressed = false;
			buttonReleased = true;
			
			ButtonsHandleRelease();
			
			if (dragMode != 0)	// started to drag
			{
				dragMoveVelocityX = dragMoveX;
				Utils.print("released "+dragMoveVelocityX);
				dragMode = 0;
				dragTimer = 0;
			}
			
		}

		public function AddDynamicInstanceFromXML(x:XML,instName:String=null):UIX_Instance
		{
			var inst:UIX_Instance = new UIX_Instance();
			inst.FromXML(x);
			inst.SetComponentFromName();
			if (instName != null)
			{
				inst.SetInstanceName(instName);
			}

			var i1:UIX_Instance = inst.Clone();
			i1.pageDefInstance = inst;
			i1.parentInst = pageInstance;
			pageInstance.AddChildInst(i1);	// childInstances.push(i1);
			CreateFromPageDef_Inner(i1);
			
			return inst;
		}

		//-----------------------------------------------------------------------------------
		var dragBoxList:Array;
		function GetDragBoxList()
		{
			dragBoxList = new Array();
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
				GetAllDragBoxesInner(inst);
			}
			if (dragBoxList.length != 0)
			{
			}
		}
		function GetAllDragBoxesInner(parentInst:UIX_Instance)
		{
			if (parentInst.component.type == UIX_Component.TYPE_DRAGBOX)
			{
				dragBoxList.push(parentInst);
			}
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				GetAllDragBoxesInner(inst);
			}			

		}
		function FlickDragHorizontal(inst:UIX_Instance,vel:Number, additive:Boolean)
		{
			dragMoveInstance = inst;
			dragMode = 0;
			dragTimer = 0;
			if (additive)
			{
				dragMoveVelocityX += vel;			
			}
			else
			{
				dragMoveVelocityX = vel;							
			}
		}
		
		function SetDragBoxPosHorizontal(inst:UIX_Instance, pos:Number)
		{
			var oldDragPosX:Number = inst.dragBox_x;
			DragItemsHorizontal(inst, inst.dragBox_x - pos);
			
		}

		function DragItemsHorizontal(inst:UIX_Instance, dx:Number)
		{
			var oldDragPosX:Number = inst.dragBox_x;
			
			inst.dragBox_x -= dx;
			if (inst.dragBox_x <= inst.dragBox_minX)
			{
				inst.dragBox_x = inst.dragBox_minX;
			}
			if (inst.dragBox_x >= inst.dragBox_maxX)
			{
				inst.dragBox_x = inst.dragBox_maxX;
			}
			
			var distToMove:Number = inst.dragBox_x - oldDragPosX;
			
//			Utils.print("dragbox x " + inst.dragBox_x + "   " + distToMove);
			
			if (inst.dragBox_CB != null)
			{
				inst.dragBox_CB(distToMove, 0);
			}

			inst.matrixIsCached = false;

		}
		
//--------------------------------------------------------------------------------------------------------------		
//--------------------------------------------------------------------------------------------------------------		
//--------------------------------------------------------------------------------------------------------------		
		
		var dPadControls:Vector.<UIX_DpadControl>;
		var dPadCurrent:String;
		var dpadPrevious:String;

		public function InitDpadControls()
		{
			dPadControls = new Vector.<UIX_DpadControl>();
			
			var pageDef:UIX_PageDef = UIX.GetPageDefByName(pageName);
			for each(var ctrl:UIX_DpadControl in pageDef.dPadControls)
			{
				dPadControls.push(ctrl.Clone());
			}
			
			dPadCurrent = "";
			dpadPrevious = "";
			if (dPadControls.length != 0)
			{
				dPadCurrent = dPadControls[0].from;
			}
		}
		public function SetDpadControls(from:String, up:String, right:String, down:String, left:String)
		{
			var currentCtrl:UIX_DpadControl = GetDPadControl(from);
			if (currentCtrl != null)
			{
				RemoveDpadControl(currentCtrl);
			}
			dPadControls.push(new UIX_DpadControl(from, up, right, down, left)); 
		}
		public function SetDpadHoverCallback(selection:String,cb:Function)
		{
			var control:UIX_DpadControl = GetDPadControl(selection);
			if (control == null)
			{
				Utils.traceerror("ERROR: SetDpadHoverCallback, control doesn't exist: " + selection);
				return;
			}
			control.hoverCallback = cb;
		}
		public function SetDpadSelection(selection:String)
		{
			dPadCurrent = selection;
		}
		
		public function RemoveDpadControl(ctrl:UIX_DpadControl)
		{
			dPadControls = dPadControls.splice(dPadControls.indexOf(ctrl), 1);
		}
		public function GetDPadControl(name:String):UIX_DpadControl 
		{
			for each(var control:UIX_DpadControl in dPadControls)
			{
				if (control.from == name)
				{
					return control;
				}
			}
			return null;
		}
		
		
		
		public function DPadUpdate()
		{
			if (PROJECT::isGamePad == false) return;

			SetActiveDpadLinkIfNotAvailable();
			
			ClearAllHoverFlags();
			var inst:UIX_Instance = Child(dPadCurrent);
			if (inst != null)
			{
				inst.button_isHovered = true;
				var current:UIX_DpadControl = GetDPadControl(dPadCurrent);
				if (current != null)
				{
					if (current.hoverCallback != null)
					{
						current.hoverCallback(inst);
					}
				}
			}
			
			
			var pressedU:Boolean = false;
			var pressedR:Boolean = false;
			var pressedD:Boolean = false;
			var pressedL:Boolean = false;
			var pressedClick:Boolean = false;
			
			if (KeyReader.Pressed(KeyReader.KEY_UP)) pressedU = true;
			if (KeyReader.Pressed(KeyReader.KEY_RIGHT)) pressedR = true;
			if (KeyReader.Pressed(KeyReader.KEY_DOWN)) pressedD = true;
			if (KeyReader.Pressed(KeyReader.KEY_LEFT)) pressedL = true;
			if (KeyReader.Pressed(KeyReader.KEY_ENTER)) pressedClick = true;
			
			
			var current:UIX_DpadControl = GetDPadControl(dPadCurrent);
			
			if (current != null)
			{
//				trace(current.from);
				
				var next:String = "";
				if (pressedU) next = DPadGetNext(current,0);
				if (pressedR) next = DPadGetNext(current,1);
				if (pressedD) next = DPadGetNext(current,2);
				if (pressedL) next = DPadGetNext(current,3);
				
				
				if (next != "")
				{
					dpadPrevious = dPadCurrent;
					dPadCurrent = next;
				}
			}
			
			if (inst != null)
			{
				if (inst.button_canPress)
				{
					if (pressedClick)
					{
						var inst:UIX_Instance = Child(dPadCurrent);
						if (inst != null)
						{
							inst.MouseClick();
						}
					}
				}
			}
		}
		
		public function SetActiveDpadLinkIfNotAvailable()
		{
			var getNew:Boolean = false;
			var current:UIX_DpadControl = GetDPadControl(dPadCurrent);
			var inst:UIX_Instance = Child(current.from);
			if (inst == null)
			{
				getNew = true;
			}
			else if (inst.visible == false)
			{
				getNew = true;
			}
			if (getNew == false) return;
			
			var current:UIX_DpadControl = GetDPadControl(dPadCurrent);
			for (var i:int = 0; i < 4; i++)
			{
				var next:String = DPadGetNext(current, i);
				if (next != "")
				{
					dPadCurrent = next;
					return;
				}
			}
			
		}
		function DPadGetNext(current:UIX_DpadControl,direction:int):String
		{
			var next:String = current.GetByIndex(direction);
			
			// SPECIAL CASE
			if (next == "dpad_previous")
			{
				trace("dpad special case: dpad_previous");
				next = dpadPrevious;
				return next;
			}

			
			var inst:UIX_Instance = Child(next);
			if (inst != null)
			{
				if (inst.visible)
				{
					return next;
				}
			}
			return "";
		}
		
		
		function ClearAllHoverFlags()
		{
			ClearAllHoverFlagsInner(pageInstance);
		}
		function ClearAllHoverFlagsInner(inst:UIX_Instance)
		{
			inst.button_isHovered = false;
			for each(var childInst:UIX_Instance in inst.childInstances)
			{
				ClearAllHoverFlagsInner(childInst);
			}
		}
		
//---------------------------------------------------------------------------		
		
		public function InitTimelines()
		{
			var go:UIX_GameObj;
			
			
			for each(var inst:UIX_Instance in pageInstance.childInstances)
			{
				if (inst.transonType != "none")
				{
					go = gameObjects.AddInstance(inst);
					if (go != null)
					{
						if (inst.transonFunc != "")
						{
							go[inst.transonFunc](inst.transonType, inst.transonDelay * UIX.transitionDelayMultiplier);
						}
					}				
				}				
			}
		}

		public function InitTimelinesOld()
		{
			var go:UIX_GameObj;
			var pageDef:UIX_PageDef = UIX.GetPageDefByName(pageName);
			for each(var tl:UIX_TimeLine in pageDef.timeLines)
			{
				go = gameObjects.AddInstance(Child(tl.instanceName));
				if (go != null)
				{
					for each(var pos:UIX_TimeLinePos in tl.positions)
					{
						go[pos.functionName](pos.functionData, pos.timeSeconds);
					}
				}				
			}			
		}
		
//---------------------------------------------------------------------------		
		
	}

}