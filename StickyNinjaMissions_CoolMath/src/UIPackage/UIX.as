package UIPackage 
{
	import AudioPackage.Audio;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.net.FileReference;
	import flash.utils.Dictionary;
	import LicPackage.Lic;
	/**
	 * ...
	 * @author 
	 */
	public class UIX 
	{
		[Embed(source = "../../bin/UIXLayout.xml", mimeType = "application/octet-stream")] 
        private static var class_embedded_XML:Class; 
		
		public function UIX() 
		{
			
		}
		
		static var linkMuteSFXAndMusic:Boolean = true;
		static var componentsDictionary:Dictionary;
		static var components:Vector.<UIX_Component>;
		public static var pageDefs:Vector.<UIX_PageDef>;

		// globals
		static var transitionDelayMultiplier:Number;
		
		
		public static function GetComponents():Vector.<UIX_Component>
		{
			return components;
		}
		public static function GetNumPageDefs():int
		{
			return pageDefs.length;
		}
		public static function GetPageDefByIndex(index:int):UIX_PageDef
		{
			return pageDefs[index];
		}
		public static function GetPageIndexByName(name:String):int
		{			
			var index:int = 0;
			for each(var page:UIX_PageDef in pageDefs)
			{
				if (page.name == name) return index;
				index++;
			}
			return 0;
		}
		public static function GetComponentByName(name:String):UIX_Component
		{
			return componentsDictionary[name];
//			for each(var component:UIX_Component in components)
//			{
//				if (component.name == name) return component;
//			}
//			return null;
		}
		
		public static function InitOnce()
		{
			InitParameters();
			
			componentsDictionary = new Dictionary();
			components = new Vector.<UIX_Component>();
			pageDefs = new Vector.<UIX_PageDef>();
			
			var comp:UIX_Component;
			
			XML.ignoreWhitespace = true;
            var xml:XML = new XML(new class_embedded_XML()) as XML; 
			
			LoadGlobals(xml);
			
			var x:XML;
			var num:int = xml.component.length();
			for (var i:int = 0; i < num; i++)
			{
				x = xml.component[i];
				comp = new UIX_Component();
				comp.FromXML(x);
				components.push(comp);
				componentsDictionary[comp.name] = comp;
			}

			
			var num:int = xml.page.length();
			for (var i:int = 0; i < num; i++)
			{
				x = xml.page[i];
				var page:UIX_PageDef = new UIX_PageDef();
				page.FromXML(x);
				pageDefs.push(page);
			}
			
			// set all instance component defs from component names
			
			for each(comp in components)
			{
				for each (var inst:UIX_Instance in comp.instances)
				{
					inst.SetComponentFromName();
				}
			}
			for each(page in pageDefs)
			{
				for each (var inst:UIX_Instance in page.instances)
				{
					inst.SetComponentFromName();
				}
				
			}
			
//			CreateDisplayObjs();
			
//			var pageInst:UIX_PageInstance = new UIX_PageInstance();
//			pageInst.CreateFromPageDef(pageDefs[0]);
		}
		
		
		public static function LoadGlobals(xml:XML)
		{
			var x:XML = xml.globals[0];
			transitionDelayMultiplier = XmlHelper.GetAttrNumber(x.@transitionDelayMultiplier, 1);
			
		}
		
		static function SaveGlobals():String
		{
			var s:String = "";
			s += "\n";
			s += '<globals transitionDelayMultiplier="' + transitionDelayMultiplier + '" ';
			s += '/>';
			s += "\n";
			s += "\n";
			return s;
		}
		
		
		public static function SaveXML()
		{
			var sss:String = "";
			sss += "<data>\n";
			
			sss += SaveGlobals();
			
			for each(var page:UIX_PageDef in pageDefs)
			{
				sss += page.ToXML();
				sss += "\n";
			}
			
			sss += "\n";
			for each(var comp:UIX_Component in components)
			{
				sss += comp.ToXML();
				sss += "\n";
			}
			
			sss += "</data>\n";
			trace(sss);
			
			var fileRef:FileReference;
			fileRef = new FileReference();
			fileRef.save(sss,"UIXLayout.xml");			
		}
		
		
		public static function GetPreparingList():Array
		{
			var preparingList:Array;
			preparingList = new Array();
			for each(var comp:UIX_Component in components)
			{
				if (comp.mcName != "")
				{
					
					preparingList.push(comp);
				}
			}
			return preparingList;
		}
		
		static function CreateDisplayObjs()
		{
			for each(var comp:UIX_Component in components)
			{
				if (comp.mcName != "")
				{
					comp.dobj = GraphicObjects.GetDisplayObjByName(comp.mcName);
				}
			}
		}
		static function InitParameters()
		{
			ObjectParameters.AddParamString("uix_instancename", "");
			ObjectParameters.AddParamString("uix_text", "");
			ObjectParameters.AddParamNumber("uix_textscale",1,false,false,0,0,0);
			ObjectParameters.AddParam("uix_textalign","list", "centre","centre,left,right");
			ObjectParameters.AddParamNumber("uix_x", 0,false,false,0,0,0);
			ObjectParameters.AddParamNumber("uix_y", 0,false,false,0,0,0);
			ObjectParameters.AddParamNumber("uix_z", 0,false,false,0,0,0);
			ObjectParameters.AddParamNumber("uix_scale_x", 0,false,false,0,0,0);
			ObjectParameters.AddParamNumber("uix_scale_y", 0,false,false,0,0,0);
			ObjectParameters.AddParamNumber("uix_rot", 0,false,false,0,0,0);
			ObjectParameters.AddParamNumber("uix_alpha", 1,true,true,0,1,0.05);
			ObjectParameters.AddParamColor("uix_color", "255.255.255");
			ObjectParameters.AddParam("uix_editorlayer", "editorlayer", "0","0");
			ObjectParameters.AddParamNumber("uix_transon_delay", 0,false,false,0,0,0);
			ObjectParameters.AddParam("uix_transon_type", "list", "none","none,inplace,top,right,bottom,left");
			ObjectParameters.AddParam("uix_transon_func", "list", "InitAppear", "InitAppear,InitTeletype");
			
			
			
		}

//------------------------------------------------------------------------------------------------------

		static var screenBD:BitmapData;
		static var screenB:Bitmap;
		public static function StopPage(mc:MovieClip,pageInst:UIX_PageInstance)
		{
			pageInst.Stop();
			if (PROJECT::useStage3D==false)
			{
//				trace("removed child " + mc.name+" "+screenB);
				try
				{
					mc.removeChild(screenB);
				}
				catch (e:Error)
				{
					trace(e.message);
				}
				
				screenBD.dispose();
				screenB.bitmapData = null;
			}
			screenBD = null;
			screenB = null;
		}
		public static function StopPage_Overlay()
		{
			pageInst.StopMouseHandlers();
		}
		
//-------------------------------------------------------

		public static function StartPage(mc:MovieClip,pageName:String)
		{
			
			if (PROJECT::useStage3D)
			{
				s3d.SetVisible(true);
			}
			
			if (PROJECT::useStage3D==false)
			{
				screenBD = new BitmapData(Defs.displayarea_w, Defs.displayarea_h, false, 0);
				screenB = new Bitmap(screenBD);
				mc.addChild(screenB);
//				trace("added child " + mc.name+" "+screenB);
			}
			
			var pageInst:UIX_PageInstance = new UIX_PageInstance();
			var pageDef:UIX_PageDef = GetPageDefByName(pageName);
			pageInst.CreateFromPageDef(pageDef);
			pageInst.Start(screenBD);
			pageInst.InitAutoTypes();
			

			return pageInst;
			
		}

		public static var pageInst:UIX_PageInstance;
		public static function StartPage_Overlay(pageName:String)
		{
			pageInst = new UIX_PageInstance();
			var pageDef:UIX_PageDef = GetPageDefByName(pageName);
			pageInst.CreateFromPageDef(pageDef);
			pageInst.calculateFlag = true;
			pageInst.StartMouseHandlers();
			pageInst.InitAutoTypes();
			pageInst.gameObjects.Start();
			return pageInst;
			
		}
		
		
		public static function GetPageDefByName(name:String)
		{
			for each(var pd:UIX_PageDef in pageDefs)
			{
				if (pd.name == name)
				{
					return pd;
				}
			}
			return null;
		}

//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------

		static var hardwareBackButtonInstance:UIX_Instance;
		public static function SetHardwareBackButton(btn:UIX_Instance)
		{
			hardwareBackButtonInstance = btn;
		}

		public static function SetButtonCanPress(btn:UIX_Instance, canPress:Boolean)
		{
			btn.button_canPress = canPress;
		}
		public static function AddAnimatedButton(btn:UIX_Instance,clickCallback:Function,text:String = null,reorderWhenOver:Boolean = false,_hoverCallback = null,_outCallback:Function = null)
		{			
			if (btn == null)
			{
				trace("AddAnimatedButton button = null");	
				return;
			}
			if (text != null && text != "")
			{
				btn.SetText(text);
			}
			btn.button_user_clickCallback = clickCallback;
			btn.button_user_hoverCallback = _hoverCallback;
			btn.button_user_outCallback = _outCallback;
			btn.mouseEnabled = true;
			btn.button_canPress = true;
			btn.button_useTick = false;
		}
		
		
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------

		public static function SetupAnimatedSFXMuteButton(btn:UIX_Instance)
		{
			btn.Child("toggleIcon").visible = false;
			if (Audio.IsMuteSFX()) btn.Child("toggleIcon").visible = true;
		}
		
		public static function AddAnimatedSFXMuteButton(btn:UIX_Instance,text:String = null)
		{			
			if (btn == null) return;
			SetupAnimatedSFXMuteButton(btn);
			AddAnimatedButton(btn, AnimatedSFXMuteButton_Click, text, false, null, null);			
		}
		public static function AnimatedSFXMuteButton_Click(inst:UIX_Instance)
		{
			Audio.ToggleMuteSFX();
			if (linkMuteSFXAndMusic)
			{
				Audio.ToggleMuteMusic();
			}
			SetupAnimatedSFXMuteButton(inst);
		}

//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------

		public static function GetTickButtonState(btn:UIX_Instance):Boolean
		{
			return btn.button_tickState;
		}
		public static function SetTickButtonState(btn:UIX_Instance,_tickState:Boolean)
		{
			btn.button_tickState = _tickState;
			btn.Child("tick").visible = _tickState;
		}
		public static function AddTickButton(btn:UIX_Instance,clickCallback:Function,text:String = null,reorderWhenOver:Boolean = false,_hoverCallback = null,_outCallback:Function = null,_tickState:Boolean = false)
		{
			AddAnimatedButton(btn, clickCallback, text, reorderWhenOver, _hoverCallback, _outCallback);			
			btn.button_useTick = true;
			btn.button_tickState = _tickState;
			btn.Child("tick").visible = _tickState;
		}

//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------

		public static function AddInfoButton(inst:UIX_Instance, text1:String="",text2:String="",text3:String="")
		{
			inst.mouseEnabled = true;
			inst.button_canPress = true;
			
			inst.Child("popup").visible = false;
			inst.Child("text1").visible = false;
			inst.Child("text2").visible = false;
			inst.Child("text3").visible = false;
			
			inst.Child("text1").SetText(text1);
			inst.Child("text2").SetText(text2);
			inst.Child("text3").SetText(text3);
			
			inst.button_user_hoverCallback = InfoButton_Over;
			inst.button_user_outCallback = InfoButton_Out;
			
		}
		public static function InfoButton_Over(inst:UIX_Instance)
		{
			inst.Child("popup").visible = true;
			inst.Child("text1").visible = true;
			inst.Child("text2").visible = true;
			inst.Child("text3").visible = true;
		}
		public static function InfoButton_Out(inst:UIX_Instance)
		{
			inst.Child("popup").visible = false;
			inst.Child("text1").visible = false;
			inst.Child("text2").visible = false;
			inst.Child("text3").visible = false;
		}


//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
		
		public static function SetupAnimatedMusicMuteButton(btn:UIX_Instance)
		{
			btn.Child("toggleIcon").visible = false;
			if (Audio.IsMuteMusic()) btn.Child("toggleIcon").visible = true;
		}		
		public static function AddAnimatedMusicMuteButton(btn:UIX_Instance,text:String = null)
		{			
			SetupAnimatedMusicMuteButton(btn);
			AddAnimatedButton(btn, AnimatedMusicMuteButton_Click, text, false, null, null);			
		}
		public static function AnimatedMusicMuteButton_Click(inst:UIX_Instance)
		{
			Audio.ToggleMuteMusic();
			SetupAnimatedMusicMuteButton(inst);
		}

//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------

		public static function StartTransitionOut(_toScreen:String,_completeFunction:Function=null,_returnScreenName:String="")
		{
			UI.currentScreen.pageInst.StartTransitionOut();
			
		}
		public static function StartTransitionIn()
		{
			if (UI.currentScreen == null) return;
			if (UI.currentScreen.pageInst == null) return;
			UI.currentScreen.pageInst.StartTransitionIn();
			
		}

//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------

		static var genericInst:UIX_Instance;
		public static function UpdateGeneric()
		{
			if (genericInst == null) return;
//			Game.CalculateScore();
			genericInst.Child("textScore").SetText(GameVars.currentScore.toString());			
			
//			Lic.UIX_SponsorLogoTurbonuke(genericInst.Child("turbonuke"),"generic");
		}
		public static function AddGeneric(inst:UIX_Instance)
		{
			genericInst = inst;
			if (inst == null) return;
			
			AddAnimatedSFXMuteButton(genericInst.Child("buttonMuteSFX"));
			
			UpdateGeneric();
			
			
		}
		
	}

}