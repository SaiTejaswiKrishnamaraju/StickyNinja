package LicPackage
{
	import AchievementPackage.Leaderboards;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import CPMStar.*;
	import MobileSpecificPackage.MobileSpecific;
	import mx.core.MovieClipLoaderAsset;
	import UIPackage.UI;
	import mochi.as3.*;
	import UIPackage.UIScreenInstance;
	import UIPackage.UIX;
	import UIPackage.UIX_Instance;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Lic 
	{
		
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
		public function Lic() 
		{
			
		}
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------

		public static var intro:MovieClip;		


		public static function Tracked_Link(_url:String, _pageName:String,_extra:String):void
		{
			navigateToURL(new URLRequest(_url), "_blank");
			Tracking.LogLink(_url,_pageName,_extra);			
		}



		static function AuthorLinkPressed(e:MouseEvent):void
		{
			if (LicDef.authorLinks.length == 0) return;
			
			var r:int = Utils.RandBetweenInt(0, LicDef.authorLinks.length - 1);
			r = Utils.LimitNumber(0, LicDef.authorLinks.length - 1, r);
			DoLink(LicDef.authorLinks[r],"authorlink");
			
		}


		public static function GetLicensor():int
		{
			return LicDef.licensor;
		}
		

		public static function InitFromMain():void
		{
			InitHighscores();
		}
		
		
		public static function GetCurrentSku():LicSku
		{
			return LicDef.GetSku(LicDef.GetLicensor());
		}
		
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
		
		static var showSecondaryIntroCallback:Function;
		static var showIntroCallback:Function;
		public static function ShowIntro(_showIntroCallback:Function):void
		{
			//SoundMixer.soundTransform = new SoundTransform(0);
			//SoundMixer.soundTransform = new SoundTransform(1);
			
			showIntroCallback = _showIntroCallback;
			if (GetCurrentSku().secondaryIntroName != "")
			{
				showSecondaryIntroCallback = showIntroCallback;
				showIntroCallback = ShowSecondaryIntro;
			}
			
			if (LicDef.IsOnCorrectSite() == false)
			{
				ShowSitelockedScreen();
				return;
			}

			if (GetCurrentSku().introName != "")
			{
				AddIntro(GetCurrentSku().introName,GetCurrentSku().introFPS);		
			}
			else
			{
				showIntroCallback();
			}
		}

		public static function ShowSecondaryIntro():void
		{
			if (GetCurrentSku().secondaryIntroName != "")
			{			
				AddSecondaryIntro(GetCurrentSku().secondaryIntroName);
			}
			else
			{
				showIntroCallback();
			}
		}
		
		
//------------------------------------------------------------------------------------------------------------------------


		static var oldFrameRate:int;
		static function AddIntro(mcName:String,_framerate:int=0)
		{
			var sku:LicSku = GetCurrentSku();
			
			var classRef:Class = getDefinitionByName(mcName) as Class;
			var mc:MovieClip = new classRef() as MovieClip

			
			oldFrameRate = LicDef.GetStage().stage.frameRate;
			if (_framerate != 0)
			{
				LicDef.GetStage().stage.frameRate = _framerate;
			}
			
			
			intro = mc;
			LicDef.GetStage().addChild(intro);
			intro.x = Defs.displayarea_w / 2;
			intro.y = Defs.displayarea_h / 2;
			
			intro.useHandCursor = true;
			intro.buttonMode = true;


			intro.addEventListener(Event.ENTER_FRAME, AddIntro_EnterFrame, false, 0, true);
			
			if (sku.linkURL != "")
			{
				intro.addEventListener(MouseEvent.CLICK, ClickedLinkURL, false, 0, true);
			}
			
			if (sku.scaleIntroToStage)
			{
				if (Defs.displayarea_w < 640)
				{
					intro.scaleX = intro.scaleY = (640/intro.width);
				}
			}
			
			intro.gotoAndPlay(1);
		}
		
		static function ClickedSimpleButtonLinkURL(e:MouseEvent)
		{
			var sku:LicSku = GetCurrentSku();
			DoLink(sku.linkURL,"title","mainlogo");			
		}
		static function ClickedLinkURL(e:MouseEvent)
		{
			var mc:MovieClip = e.currentTarget as MovieClip
			var sku:LicSku = GetCurrentSku();
			DoLink(sku.linkURL,mc.fromPage);
		}
		static function ClickedMainLogoURL(e:MouseEvent)
		{
			var mc:MovieClip = e.currentTarget as MovieClip
			var sku:LicSku = GetCurrentSku();
			DoLink(sku.mainLogoLinkURL,mc.fromPage);
		}
		
		static function AddIntro_EnterFrame(e:Event)
		{
			if (intro == null) return;
			if (intro.totalFrames == intro.currentFrame)
			{
				LicDef.GetStage().stage.frameRate = oldFrameRate;

				var sku:LicSku = GetCurrentSku();
				if (sku.linkURL != "")
				{
					intro.removeEventListener(MouseEvent.CLICK, ClickedLinkURL);
				}
				intro.stop();
				intro.removeEventListener(Event.ENTER_FRAME, AddIntro_EnterFrame);
				LicDef.GetStage().removeChild(intro);
				intro = null;
				if (showIntroCallback != null)
				{
					showIntroCallback();
				}
			}
		}
		
//------------------------------------------------------------------------------------------------------------------------
		static function AddSecondaryIntro(mcName:String)
		{
			var sku:LicSku = GetCurrentSku();
			
			var classRef:Class = getDefinitionByName(mcName) as Class;
			intro = new classRef() as MovieClip

//			oldFrameRate = LicDef.GetStage().stage.frameRate;
//			LicDef.GetStage().stage.frameRate = 30;
			
			LicDef.GetStage().addChild(intro);
			intro.x = Defs.displayarea_w / 2;
			intro.y = Defs.displayarea_h / 2;
			
			intro.useHandCursor = true;
			intro.buttonMode = true;
			intro.mouseEnabled = true;
			
			intro.addEventListener(Event.ENTER_FRAME, AddSecondaryIntro_EnterFrame, false, 0, true);
			
			if (sku.secondaryIntroLinkURL != "")
			{
				intro.addEventListener(MouseEvent.CLICK, SecondaryIntro_Clicked, false, 0, true);
			}			
			intro.gotoAndPlay(1);
		}
		
		static function SecondaryIntro_Clicked(e:MouseEvent)
		{
			var sku:LicSku = GetCurrentSku();
			DoLink(sku.secondaryIntroLinkURL,"secondaryintro");
		}
		
		public static function DoLink(linkStr:String,_fromPage:String="unknown_frompage_DoLink",_extra:String="DoLink_Extra_Undefined")
		{
			var s:String = linkStr;
			
			if (LicDef.GetLicensor() == LicDef.LICENSOR_TURBONUKE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
			{
				var qfound:Boolean = false;
				for (var i:int = 0; i < s.length; i++)
				{
					if (s.charAt(i) == "?") qfound = true;
				}
				if (qfound)
				{
					s += LicDef.referralStringAnd;
				}
				else
				{
					s += LicDef.referralString;
				}
			}
			Tracked_Link(s, _fromPage,_extra);
		}
		
		public static function DoLinkKongExtra(linkStr:String,_fromPage:String="unknown_page_DoLinkKongExtra",_extra:String="")
		{
			Tracking.LogLink(linkStr, _fromPage,_extra);
			
			var s:String = linkStr;
			
			if (LicDef.GetLicensor() == LicDef.LICENSOR_TURBONUKE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
			{
				s += LicDef.referralString;
			}
			
			if (_extra != "")
			{
				s += _extra;
			}
			
			navigateToURL(new URLRequest(s), "_blank");
		}
		
		static function AddSecondaryIntro_EnterFrame(e:Event)
		{
			if (intro.totalFrames == intro.currentFrame)
			{
				var sku:LicSku = GetCurrentSku();
				if (sku.secondaryIntroLinkURL != "")
				{
					intro.removeEventListener(MouseEvent.CLICK, SecondaryIntro_Clicked);
				}
				intro.stop();
				intro.removeEventListener(Event.ENTER_FRAME, AddSecondaryIntro_EnterFrame);
				LicDef.GetStage().removeChild(intro);
				intro = null;
				if (showSecondaryIntroCallback != null)
				{
					showSecondaryIntroCallback();
				}
			}
		}


//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------

		static function ShowSitelockedScreen()
		{
			intro = new MovieClip();	// SitelockedScreen();
			intro.x = 0;
			intro.y = 0;
			LicDef.GetStage().addChild(intro);
			intro.addEventListener(MouseEvent.CLICK, SitelockScreen_Clicked);
		}
		static function SitelockScreen_Clicked(e:MouseEvent)
		{
		}
		
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
		
		
		public static function Link_Walkthrough(e:MouseEvent,buttonString:String="intro")
		{
		}
		
		
		public static function Link_TurboNukeRegister(e:MouseEvent,buttonString:String="intro")
		{
			navigateToURL(new URLRequest("http://www.turbonuke.com/login.php"), "_self");
		}
		public static function Link_TurboNuke(e:MouseEvent,buttonString:String="intro")
		{
			navigateToURL(new URLRequest("http://www.turbonuke.com?gamereferral=" + LicDef.referralName), "_blank");
		}
		
		
		
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------

		
//------------------------------------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------------------------------------------------


		public static function AuthorButton(mc:SimpleButton):void
		{
			if (mc == null) return;
			var sku:LicSku = GetCurrentSku();
			if (sku.allowAuthorLink == false)
			{
				mc.visible = false;
				return;
			}
			mc.addEventListener(MouseEvent.CLICK, AuthorLinkPressed, false, 0, true);
		}
		
		
		public static function PlayWithScoresButton(btn:SimpleButton)
		{
			if (btn == null) return;
			var sku:LicSku = GetCurrentSku();
			btn.visible = false;
			
			if (PROJECT::useStage3D)
			{
				return;
			}
			
			if (LicDef.GetDomain() == "notdoppler.com") return;
			if (LicDef.GetDomain() == "kaisergames.de") return;
			if (sku.playWithScoresURL == null) return;
			if (sku.playWithScoresURL == "") return;
			
			btn.visible = true;
			UI.AddButton(btn, PlayWithScoresButton_Clicked);
		}
		public static function PlayWithScoresButton_Clicked(e:MouseEvent)
		{
			var sku:LicSku = GetCurrentSku();
			DoLink(sku.playWithScoresURL, "play_with_scores");
		}
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------
		
		public static function HasPrequelButton():Boolean
		{
			var sku:LicSku = GetCurrentSku();
			return sku.prequelLinkURL != "";
		}	
		
		public static function AnimatedMCPrequelButton(mc:MovieClip)
		{
			if (mc == null) return;
			mc.visible = false;
			if (HasPrequelButton() == false) return;
			mc.visible = true;
			
			UI.AddAnimatedMCButton(mc, ClickedAnimatedMCPrequelButton);
			
		}
		static function ClickedAnimatedMCPrequelButton(e:MouseEvent)
		{
			var sku:LicSku = GetCurrentSku();
			if (sku.prequelLinkURL != "")
			{
				DoLink(sku.prequelLinkURL,"prequel");
			}
		}
		public static function BarebonesMCPrequelButton(mc:MovieClip)
		{
			if (mc == null) return;
			mc.visible = false;
			if (HasPrequelButton() == false) return;
			mc.visible = true;
			
			UI.AddBarebonesMCButton(mc, ClickedAnimatedMCPrequelButton);
			
		}


//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------

		public static function HasFacebookButton():Boolean
		{

			var sku:LicSku = GetCurrentSku();
			return sku.facebookLinkURL != "";
		}	
//-----------------------------------------------------------------------------------------------------

		public static function HasTwitterButton():Boolean
		{
			var sku:LicSku = GetCurrentSku();
			return sku.twitterLinkURL != "";
		}	
//-----------------------------------------------------------------------------------------------------

		public static function HasMobileGamesButton_iOS():Boolean
		{
			var sku:LicSku = GetCurrentSku();
			return sku.mobileGamesLinkURL_iOS != "";
		}	
//-----------------------------------------------------------------------------------------------------

		public static function HasMobileGamesButton_Android():Boolean
		{
			var sku:LicSku = GetCurrentSku();
			return sku.mobileGamesLinkURL_Android != "";
		}	
//-----------------------------------------------------------------------------------------------------
		public static function HasMobileGamesButton_Amazon():Boolean
		{
			var sku:LicSku = GetCurrentSku();
			return sku.mobileGamesLinkURL_Amazon != "";
		}	
		
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------
		public static function AnimatedMCFacebookButton(mc:MovieClip,_fromPage:String)
		{
			if (mc == null) return;
			mc.fromPage = _fromPage;
			mc.visible = false;
			if (HasFacebookButton() == false) return;
			mc.visible = true;
			
			UI.AddAnimatedMCButton(mc, ClickedAnimatedMCFacebookButton);
			
		}
		static function ClickedAnimatedMCFacebookButton(e:MouseEvent)
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var sku:LicSku = GetCurrentSku();
			if (sku.facebookLinkURL != "")
			{
				Tracked_Link(sku.facebookLinkURL,mc.fromPage,"facebook");
			}
		}

//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------

		public static function UIX_FacebookButton(inst:UIX_Instance,_fromPage:String)
		{
			if (inst == null) return;
			inst.userData.fromPage = _fromPage;
			inst.visible = false;
			if (HasFacebookButton() == false) return;

			inst.visible = true;
			
			UIX.AddAnimatedButton(inst, UIX_FacebookButtonClicked);
			
		}
		static function UIX_FacebookButtonClicked(inst:UIX_Instance)
		{
//			if (PROJECT::isMobile)
//			{
//				MobileSpecific.Facebook();				
//				return;
//			}
			
			var sku:LicSku = GetCurrentSku();
			if (sku.facebookLinkURL != "")
			{
				Tracked_Link(sku.facebookLinkURL,inst.userData.fromPage,"facebook");
			}
		}		

//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------


		public static function UIX_MobileGamesButton_iOS(inst:UIX_Instance,_fromPage:String)
		{
			if (inst == null) return;
			inst.userData.fromPage = _fromPage;
			inst.visible = false;
			if (HasMobileGamesButton_iOS() == false) return;

			inst.visible = true;
			
			UIX.AddAnimatedButton(inst, UIX_MobileGamesButtonClicked_iOS);
			
		}
		static function UIX_MobileGamesButtonClicked_iOS(inst:UIX_Instance)
		{
			var sku:LicSku = GetCurrentSku();
			if (sku.mobileGamesLinkURL_iOS != "")
			{
				Tracked_Link(sku.mobileGamesLinkURL_iOS,inst.userData.fromPage,"mobilegames");
			}
		}		

//-----------------------------------------------------------------------------------------------------

		public static function UIX_MobileGamesButton_Android(inst:UIX_Instance,_fromPage:String)
		{
			if (inst == null) return;
			inst.userData.fromPage = _fromPage;
			inst.visible = false;
			if (HasMobileGamesButton_Android() == false) return;

			inst.visible = true;
			
			UIX.AddAnimatedButton(inst, UIX_MobileGamesButtonClicked_Android);
			
		}
		static function UIX_MobileGamesButtonClicked_Android(inst:UIX_Instance)
		{
			var sku:LicSku = GetCurrentSku();
			if (sku.mobileGamesLinkURL_Android != "")
			{
				Tracked_Link(sku.mobileGamesLinkURL_Android,inst.userData.fromPage,"mobilegames");
			}
		}		
		
//-----------------------------------------------------------------------------------------------------

		public static function UIX_MobileGamesButton_Amazon(inst:UIX_Instance,_fromPage:String)
		{
			if (inst == null) return;
			inst.userData.fromPage = _fromPage;
			inst.visible = false;
			if (HasMobileGamesButton_Amazon() == false) return;

			inst.visible = true;
			
			UIX.AddAnimatedButton(inst, UIX_MobileGamesButtonClicked_Amazon);
			
		}
		static function UIX_MobileGamesButtonClicked_Amazon(inst:UIX_Instance)
		{
			var sku:LicSku = GetCurrentSku();
			if (sku.mobileGamesLinkURL_Amazon != "")
			{
				Tracked_Link(sku.mobileGamesLinkURL_Amazon,inst.userData.fromPage,"mobilegames");
			}
		}		
		
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------

		public static function UIX_MobileGamesButton_All(inst:UIX_Instance, _fromPage:String)
		{
			if (inst == null) return;
			inst.userData.fromPage = _fromPage;
			inst.visible = false;
			if (PROJECT::useStage3D)
			{
				return;
			}
			inst.visible = true;	
			inst.userData.currentScreenName = UI.currentScreenName;
			UIX.AddAnimatedButton(inst, UIX_MobileGamesButtonClicked_All);
			
		}
		static function UIX_MobileGamesButtonClicked_All(inst:UIX_Instance)
		{
			DoLink("http://www.turbonuke.com/mobile.php", "mobile");
			//UI.nextScreenName = inst.userData.currentScreenName;
			//UI.StartTransition("purchase");
			
		}

//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------
		public static function UIX_TwitterButton(inst:UIX_Instance,_fromPage:String)
		{
			if (inst == null) return;
			inst.userData.fromPage = _fromPage;
			inst.visible = false;
			if (HasTwitterButton() == false) return;

			inst.visible = true;
			
			UIX.AddAnimatedButton(inst, UIX_TwitterButtonClicked);
			
		}
		static function UIX_TwitterButtonClicked(inst:UIX_Instance)
		{
			var sku:LicSku = GetCurrentSku();
			if (sku.twitterLinkURL != "")
			{
				Tracked_Link(sku.twitterLinkURL,inst.userData.fromPage,"twitter");
			}
		}		
		
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------

		public static function Y8LogoButtonClicked(e:MouseEvent)
		{
			navigateToURL(new URLRequest("http://www.y8.com"), "_blank");
		}
		public static function Y8LogoButton(b:SimpleButton)
		{
			if (b == null) return;
			b.visible = false;
			if (LicDef.GetDomain() == "y8.com")
			{
				b.visible = true;
				UI.AddButton(b, Y8LogoButtonClicked);
			}
		}
		
//-----------------------------------------------------------------------------------------------------
		public static function UIX_Y8LogoClicked(inst:UIX_Instance)
		{
			navigateToURL(new URLRequest("http://www.y8.com"), "_blank");
		}
		public static function UIX_Y8Logo(inst:UIX_Instance)
		{
			if (inst == null) return;
			inst.visible = false;
			if (LicDef.GetDomain() == "y8.com")
			{
				inst.visible = true;
				UIX.AddAnimatedButton(inst, UIX_Y8LogoClicked);
			}
		}


//-----------------------------------------------------------------------------------------------------

		public static function HasDownloadForYourSiteButton():Boolean
		{
			if (LicDef.IsAtKiba()) return false;
			var sku:LicSku = GetCurrentSku();
			return sku.downloadLinkURL != "";
		}	
		
		public static function AnimatedMCDownloadForYourSiteButton(mc:MovieClip,_fromPage:String)
		{
			if (mc == null) return;
			mc.visible = false;
			mc.fromPage = _fromPage;
			if (HasDownloadForYourSiteButton() == false) return;
			mc.visible = true;
			
			UI.AddAnimatedMCButton(mc, ClickedAnimatedMCDownloadForYourSiteButton);
			
		}
		static function ClickedAnimatedMCDownloadForYourSiteButton(e:MouseEvent)
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var sku:LicSku = GetCurrentSku();
			if (sku.downloadLinkURL != "")
			{
				DoLink(sku.downloadLinkURL,mc.fromPage,"download");
			}
		}

//-----------------------------------------------------------------------------------------------------

		public static function UIX_DownloadForYourSiteButton(inst:UIX_Instance,_fromPage:String)
		{
			if (inst == null) return;
			inst.visible = false;
			inst.userData.fromPage = _fromPage;
			if (HasDownloadForYourSiteButton() == false) return;
			inst.visible = true;
			
			UIX.AddAnimatedButton(inst, UIX_DownloadForYourSiteButtonClicked,"DOWNLOAD");
			
		}
		static function UIX_DownloadForYourSiteButtonClicked(inst:UIX_Instance)
		{
			var sku:LicSku = GetCurrentSku();
			if (sku.downloadLinkURL != "")
			{
				DoLink(sku.downloadLinkURL,inst.userData.fromPage,"download");
			}
		}


//-----------------------------------------------------------------------------------------------------




//-----------------------------------------------------------------------------------------------------
		
		static function HasMoreGamesButton():Boolean
		{
			if (LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE) return false;

			if (Game.isWildTangent) return false;
			
			var sku:LicSku = GetCurrentSku();
			return sku.showMoreGamesButton;
			
			
		}
		
		
		static var moreGamesText:Array = new Array(
				"More Games",
				"Play Games",
				"Free Games",
				"Other Games",
				"Great Games",
				"Sport Games",
				"Racing Games",
				"Driving Games",
				"Car Games",
				"Our Games",
				"Turbo Games",
				"Puzzle Games",
				"Action Games",
				"Shooting Games"
				);
				

		static var moreGamesTextLinks:Array = new Array(
				"",
				"",
				"",
				"",
				"",
				"/sports-racing-games",		// sport
				"/sports-racing-games",
				"/sports-racing-games",
				"/sports-racing-games",
				"/games/TurboNuke",
				"/games/TurboNuke",
				"/puzzle-games",
				"/action-games",
				"/shooter-games"
				);
		
		static function GetMoreGamesTextLinks():Array
		{
			var sku:LicSku = GetCurrentSku();
			var a:Array = new Array();
			for each(var s:String in moreGamesTextLinks)
			{
				var ss:String = sku.linkURL + s;
				a.push(ss);
			}
			return a;
		}
				
		
		public static function ResetAnimatedMCMoreGamesButton(btn:MovieClip):void
		{
			if (btn == null) return;
			if (HasMoreGamesButton() == false) 
			{
				btn.visible = false;
				return;
			}
			var sku:LicSku = GetCurrentSku();
			if (sku.linkURL == "")
			{
				btn.visible = false;
				return;
			}
			btn.moreGamesOverrideIndex = Utils.RandBetweenInt(0, moreGamesText.length - 1);
			btn.buttonName.text = moreGamesText[btn.moreGamesOverrideIndex];
			
		}
		public static function AnimatedMCMoreGamesButton(btn:MovieClip,_fromPage:String):void
		{
			if (btn == null) return;
			if (HasMoreGamesButton() == false) 
			{
				btn.visible = false;
				return;
			}
			var sku:LicSku = GetCurrentSku();
			if (sku.linkURL == "")
			{
				btn.visible = false;
				return;
			}
			
			btn.fromPage = _fromPage;
			
			if (LicDef.GetLicensor() == LicDef.LICENSOR_TURBONUKE)	// || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
			{
				btn.moreGamesOverrideIndex = Utils.RandBetweenInt(0, moreGamesText.length - 1);
				btn.buttonName.text = moreGamesText[btn.moreGamesOverrideIndex];
				UI.AddAnimatedMCButton(btn, MoreGamesButtonMCPressed);
			}
			else if (LicDef.GetLicensor() == LicDef.LICENSOR_ANDKON)
			{
				btn.buttonName.text = "ANDKON";
				UI.AddAnimatedMCButton(btn, MoreGamesButtonMCPressedSimple);
			}
			else
			{
				UI.AddAnimatedMCButton(btn, MoreGamesButtonMCPressedSimple);
			}
		}

//-------------------------------------------------------------------------------------------

		public static function UIX_SequelButton(btn:UIX_Instance,_fromPage:String):void
		{
			if (btn == null) return;
			btn.visible = false;
			btn.userData.fromPage = _fromPage;
			if (PROJECT::isAmazon)
			{
				btn.visible = true;
				UIX.AddAnimatedButton(btn, UIX_SequelButtonPressed);

			}
		}
		static function UIX_SequelButtonPressed(inst:UIX_Instance):void
		{
			if (PROJECT::isAmazon)
			{
				//DoLink("http://www.turbonuke.com", inst.userData.fromPage);
				DoLink("http://www.amazon.com/gp/mas/dl/android?asin=B00HW1M5EE", inst.userData.fromPage);
				//DoLink("amzn://apps/android?asin=B00HW1M5EE", inst.userData.fromPage);
			}
		}
		
		
//-------------------------------------------------------------------------------------------

		public static function UIX_CoffeeButton(btn:UIX_Instance, _fromPage:String):void
		{
			btn.visible = false;
			
			// remove coffee for RollerRider initial release
			return;
			
			if (PROJECT::isMobile == false) return;
			
			if (PROJECT::isAmazon)
			{
				if (PROJECT::isAmazonIAB == false) return;
			}
			
			if (Game.ad_free_unlocked) return;
			
			btn.visible = true;
			UIX.AddAnimatedButton(btn, UIX_CoffeeButtonPressed);
		}
		public static function UIX_CoffeeButtonPressed(inst:UIX_Instance)
		{
 			UI.StartTransition("coffeescreen",null,UI.currentScreenName);	
		}

//-------------------------------------------------------------------------------------------

		public static function UIX_MoreGamesButton(btn:UIX_Instance,_fromPage:String):void
		{
			if (btn == null) return;
			if (HasMoreGamesButton() == false) 
			{
				btn.visible = false;
				return;
			}
			var sku:LicSku = GetCurrentSku();
			if (sku.linkURL == "")
			{
				btn.visible = false;
				return;
			}
			
			btn.userData.fromPage = _fromPage;

			
			if (PROJECT::isAmazon)
			{
				UIX.AddAnimatedButton(btn, UIX_MoreGamesButtonMCPressedAmazon);
				return;
			}
			

			if (PROJECT::isPlayHaven)
			{
				UIX.AddAnimatedButton(btn, UIX_MoreGamesButtonMCPressedPlayHaven);
				return;
			}
			
			
			if (LicDef.IsAtKiba())
			{
				UIX.AddAnimatedButton(btn, UIX_MoreGamesButtonMCPressedSimple);
				return;
			}
			
			if (LicDef.GetLicensor() == LicDef.LICENSOR_TURBONUKE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
			{
				btn.userData.moreGamesOverrideIndex = Utils.RandBetweenInt(0, moreGamesText.length - 1);
//				btn.buttonName.text = moreGamesText[btn.moreGamesOverrideIndex];
				//UI.AddAnimatedMCButton(btn, MoreGamesButtonMCPressed);
				UIX.AddAnimatedButton(btn, UIX_MoreGamesButtonMCPressedComplex, moreGamesText[btn.userData.moreGamesOverrideIndex]);
				
				// set up the correct frame corresponding to the list. Gotta make all the frames in the UI
				btn.frame = btn.userData.moreGamesOverrideIndex;
			}
			else
			{
				UIX.AddAnimatedButton(btn, UIX_MoreGamesButtonMCPressedSimple);
			}
		}

//-------------------------------------------------------------------------------------------
		static function UIX_MoreGamesButtonMCPressedComplex(inst:UIX_Instance):void
		{
			if (inst.userData.moreGamesOverrideIndex == -1)
			{				
				UIX_MoreGamesButtonMCPressedSimple(inst);
			}
			else
			{
				if (inst.userData.moreGamesOverrideIndex < 0 || inst.userData.moreGamesOverrideIndex >= moreGamesTextLinks.length)
				{
					UIX_MoreGamesButtonMCPressedSimple(inst);
				}
				else
				{
					var str:String = GetMoreGamesTextLinks()[inst.userData.moreGamesOverrideIndex];
					if (str == "")
					{
						var s:String = moreGamesText[inst.userData.moreGamesOverrideIndex];
						DoLink(str, inst.userData.fromPage,s);
					}
					else
					{
						var s:String = moreGamesText[inst.userData.moreGamesOverrideIndex];
						DoLink(str, inst.userData.fromPage, s);
					}
				}
			}
			
		}
		static function UIX_MoreGamesButtonMCPressedAmazon(inst:UIX_Instance):void
		{
			if (PROJECT::isAmazon)
			{
//				navigateToURL(new URLRequest("amzn://apps/android?asin=B00HVEDCOY&showAll=1"), "_blank");
				navigateToURL(new URLRequest("http://www.amazon.com/gp/mas/dl/android?asin=B00HVEDCOY&showAll=1"), "_blank");
			}			
		}
		static function UIX_MoreGamesButtonMCPressedPlayHaven(inst:UIX_Instance):void
		{
			if (PROJECT::isPlayHaven)
			{
				MobileSpecific.PlayHaven_showMoreGames();
			}
		}
		static function UIX_MoreGamesButtonMCPressedSimple(inst:UIX_Instance):void
		{
			var sku:LicSku = LicDef.GetCurrentSku();
			if (sku.linkURL != "")
			{
				DoLink(sku.linkURL,"more_games_simple");
			}
		}

//-------------------------------------------------------------------------------------------
		
		static function MoreGamesButtonMCPressedSimple(e:MouseEvent):void
		{
			var sku:LicSku = LicDef.GetCurrentSku();
			if (sku.linkURL != "")
			{
				DoLink(sku.linkURL,"more_games_simple");
			}
		}
		static function MoreGamesButtonMCPressed(e:MouseEvent):void
		{
			var btn:MovieClip = e.currentTarget as MovieClip;
			var fromPage:String = btn.fromPage;
			
			if (btn.moreGamesOverrideIndex == -1)
			{				
				ClickedLinkURL(e);
			}
			else
			{
				if (btn.moreGamesOverrideIndex < 0 || btn.moreGamesOverrideIndex >= moreGamesTextLinks.length)
				{
					ClickedLinkURL(e);
				}
				else
				{
					var str:String = moreGamesTextLinks[btn.moreGamesOverrideIndex];
					if (str == "")
					{
						var s:String = moreGamesText[btn.moreGamesOverrideIndex];
//						s = "&from="+s.replace(" ", "_");
						DoLink(str, fromPage,s);
						//DoLinkKongExtra(str,fromPage,s);
					}
					else
					{
						var s:String = moreGamesText[btn.moreGamesOverrideIndex];
						//s = "&from=" + s.replace(" ", "_");
						DoLink(str, fromPage, s);
						//DoLinkKongExtra(str,fromPage,s);
					}
				}
			}
		}
		
		public static function MCMoreGamesButton(btn:MovieClip,_from:String,noChange:Boolean = false):void
		{
			if (btn == null) return;
			if (HasMoreGamesButton() == false) 
			{
				btn.visible = false;
				return;
			}
			var sku:LicSku = GetCurrentSku();
			if (sku.linkURL == "")
			{
				btn.visible = false;
				return;
			}
			btn.moreGamesOverrideIndex = -1;
			if (noChange == false)
			{
				btn.moreGamesOverrideIndex = Utils.RandBetweenInt(0, moreGamesText.length - 1);
				btn.buttonName.text = moreGamesText[btn.moreGamesOverrideIndex];
			}
			
			if (btn.buttonName != null)
			{
				btn.buttonName.mouseEnabled = false;
			}
			
			UI.AddMCButton(btn, MoreGamesButtonMCPressed);
		}
		
		
		public static function MoreGamesButton(btn:SimpleButton,_from:String):void
		{
			if (btn == null) return;
			if (HasMoreGamesButton() == false) 
			{
				btn.visible = false;
				return;
			}
			var sku:LicSku = GetCurrentSku();
			if (sku.linkURL == "")
			{
				btn.visible = false;
				return;
			}
			
			var mc:MovieClip = new MovieClip();
			btn.parent.addChild(mc);
			mc.x = btn.x;
			mc.y = btn.y;
			btn.parent.removeChild(btn);
			mc.addChild(btn);
			btn.x = 0;
			btn.y = 0;
			
			
			
			if (LicDef.GetLicensor() == LicDef.LICENSOR_ANDKON)
			{
				var classRef:Class = getDefinitionByName("buttonMoreGamesAndkon") as Class;
				var mc1:SimpleButton = new classRef() as SimpleButton;
				//var mc1:SimpleButton = new buttonMoreGamesAndkon();
				btn.parent.addChild(mc1);
				mc1.x = btn.x;
				mc1.y = btn.y;
				mc1.scaleX = btn.scaleX;
				mc1.scaleY = btn.scaleY;
				btn.parent.removeChild(btn);
				btn = mc1;
			}
			mc.moreGamesOverrideIndex = -1;
			mc.addEventListener(MouseEvent.CLICK, MoreGamesButtonMCPressed, false, 0, true);
			mc._from = _from;
		}
		
		
		
		
		
		static function RemoveMainLogoButton(mc:MovieClip):void
		{
			if (mc == null) return;
			var sku:LicSku = GetCurrentSku();
			var logo:SimpleButton;
			var num:int = mc.numChildren;
			for (var i:int = 0; i < num; i++)
			{
				logo = mc.getChildAt(i) as SimpleButton;
				if (logo != null)
				{
					logo.visible = false;
				}
				else
				{
					Utils.print("Lic: MainLogo Error. Null child found. (not a button?)");
				}
			}
		}
		
		public static function MainLogoButton(mc:MovieClip):void
		{
			if (mc == null) return;
			var sku:LicSku = GetCurrentSku();
			var logo:SimpleButton;
			var num:int = mc.numChildren;
			for (var i:int = 0; i < num; i++)
			{
				logo = mc.getChildAt(i) as SimpleButton;
				if (logo != null)
				{
					logo.visible = false;
				}
				else
				{
					Utils.print("Lic: MainLogo Error. Null child found. (not a button?)");
				}
			}
			if (sku.mainLogoName != "")
			{
				logo = mc.getChildByName(sku.mainLogoName) as SimpleButton;
				if (logo != null)
				{
					logo.visible = true;
					if (sku.linkURL != "")
					{
						if (sku.mainLogoLinkURL != "")
						{							
							logo.addEventListener(MouseEvent.CLICK, ClickedMainLogoURL, false, 0, true);							
						}
						else
						{
							logo.addEventListener(MouseEvent.CLICK, ClickedSimpleButtonLinkURL, false, 0, true);							
						}
					}
					else
					{
						logo.useHandCursor = false;
					}
				}
				else
				{
					Utils.print("Lic: MainLogo Error. Can't find logo: "+sku.mainLogoName);
				}
			}
		}

		
		
//-------------------------------------------------------------------------------------------------------

		public static function UIX_SponsorLogoTurbonuke(inst:UIX_Instance, _fromPage:String):void
		{
			if (inst == null) 
			{
				return;
			}
			inst.visible = false;
			if (
				LicDef.GetLicensor() == LicDef.LICENSOR_ADDICTINGGAMES_TURBONUKE ||
				LicDef.GetLicensor() == LicDef.LICENSOR_TURBONUKE )
				{
					inst.visible = true;
					UIX.AddAnimatedButton(inst, UIX_SponsorLogoClicked_TurboNuke);	
					
				}
			
		}
		public static function UIX_SponsorLogo(parentInst:UIX_Instance,_fromPage:String):void
		{
			if (parentInst == null) 
			{
				return;
			}
			parentInst.visible = true;
			var sku:LicSku = GetCurrentSku();
			for each(var inst:UIX_Instance in parentInst.childInstances)
			{
				inst.visible = false;
				if (inst.GetInstanceName() == sku.mainLogoName)
				{
					inst.visible = true;
					inst.userData.fromPage = _fromPage;
					
					if (sku.mainLogoLinkURL != "")
					{							
						UIX.AddAnimatedButton(inst, UIX_SponsorLogoClicked_linkURL);
					}
					else
					{
						UIX.AddAnimatedButton(inst, UIX_SponsorLogoClicked);						
					}
				}
			}
			parentInst.Child("addictinggames").visible = false;
			if (LicDef.GetLicensor() == LicDef.LICENSOR_ADDICTINGGAMES_TURBONUKE)
			{
				parentInst.Child("addictinggames").visible = true;	
				UIX.AddAnimatedButton(parentInst.Child("addictinggames"), UIX_ButtonAddictingGamesPressed);	
			}
		}
		static function UIX_ButtonAddictingGamesPressed(inst:UIX_Instance)
		{
			DoLink("http://www.addictinggames.com");
		}
		
		static function UIX_SponsorLogoClicked_TurboNuke(inst:UIX_Instance)
		{
			var sku:LicSku = GetCurrentSku();
			DoLink("http://www.turbonuke.com","title","mainlogo");			
		}
		static function UIX_SponsorLogoClicked(inst:UIX_Instance)
		{
			var sku:LicSku = GetCurrentSku();
			DoLink(sku.linkURL,"title","mainlogo");			
		}
		static function UIX_SponsorLogoClicked_linkURL(inst:UIX_Instance)
		{
			var sku:LicSku = GetCurrentSku();
			DoLink(sku.mainLogoLinkURL,inst.userData.fromPage);
		}


//-------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------

		public static function UIX_WalkthroughButton(inst:UIX_Instance):void
		{
			if (inst == null) return;
			inst.visible = false;
			var sku:LicSku = GetCurrentSku();
			if (sku.walkthroughURL == "") return;
			
			UIX.AddAnimatedButton(inst, UIX_WalkthroughButtonPressed,"walkthrough");
			inst.visible = true;
		}
		
		static function UIX_WalkthroughButtonPressed(inst:UIX_Instance):void
		{
			var sku:LicSku = GetCurrentSku();
			DoLink(sku.walkthroughURL);
		}

//-------------------------------------------------------------------------------------------------------

/*
		static var facebookString:String;
		static function FacebookButton(mc:SimpleButton,str:String=""):void
		{
			if (mc == null) return;
			mc.visible = false;
			facebookString = str;
			mc.addEventListener(MouseEvent.CLICK, FacebookButtonPressed, false, 0, true);
		}
		public static function FacebookButtonPressed(e:MouseEvent)
		{
			var s:String = "http://www.facebook.com/sharer.php?u='http://www.turbonuke.com&referral=soccerballs'&t=Great game of CycloManiacs Racers";
			navigateToURL(new URLRequest(s), "_blank");
		}
		*/

//-------------------------------------------------------------------------------------------------------


		public static function AnimatedMCWalkthroughButton(mc:MovieClip):void
		{
			if (mc == null) return;
			mc.visible = false;
			var sku:LicSku = GetCurrentSku();
			if (sku.walkthroughURL == "") return;
			
			UI.AddAnimatedMCButton(mc, WalkthroughButtonPressed,"walkthrough");
			mc.visible = true;
		}


		public static function WalkthroughButton(mc:SimpleButton):void
		{
			if (mc == null) return;
			mc.visible = false;
			var sku:LicSku = GetCurrentSku();
			if (sku.walkthroughURL == "") return;
			mc.visible = true;
			mc.addEventListener(MouseEvent.CLICK, WalkthroughButtonPressed, false, 0, true);			
		}
		
		static function WalkthroughButtonPressed(e:MouseEvent):void
		{
			var sku:LicSku = GetCurrentSku();
			DoLink(sku.walkthroughURL,"walkthrough");
		}
		


//-------------------------------------------------------------------------------------------------------

/*
		static var twitterString:String;
		static function TwitterButton(mc:SimpleButton,str:String=""):void
		{
			if (mc == null) return;
			mc.visible = false;
			var sku:LicSku = GetCurrentSku();
			if (sku.twitterFunction == null) return;
			twitterString = str;
			mc.visible = true;
			mc.addEventListener(MouseEvent.CLICK, sku.twitterFunction, false, 0, true);
		}
		public static function TwitterButtonPressed(e:MouseEvent)
		{
			TwitterPost();
		}
		
		static var tinyLoader:URLLoader;
		static function TwitterPost():void
		{
			tinyLoader = new URLLoader();
			tinyLoader.dataFormat = URLLoaderDataFormat.TEXT;

			tinyLoader.addEventListener(Event.COMPLETE,TwitterPost_gotTinyURL);
			tinyLoader.load(new URLRequest('http://tinyurl.com/api-create.php?url=http://www.turbonuke.com&referral=twitter' ));
		}


		static function TwitterPost_gotTinyURL(event:Event):void
		{
			var reqString:String =  'http://twitter.com/home?status=Look out for Turbo Nuke' +  encodeURIComponent(tinyLoader.data);
			navigateToURL(new URLRequest(reqString), "_blank");
		}
		*/
		

//-------------------------------------------------------------------------------------------------------
// High scores
//-------------------------------------------------------------------------------------------------------

		static var highScore_inst:UIX_Instance;

		public static function UIX_SubmitScoreButton(inst:UIX_Instance):void
		{
			highScore_inst = inst;
			inst.visible = false;
			submitScoreName = GameVars.playerName;
			getHighScoreFunction = RetrieveHighScore;
			submitScoreCallback = null;
			
			if (LicDef.GetLicensor() == LicDef.LICENSOR_MOUSEBREAKER)
			{
				inst.visible = true;

				UIX.AddAnimatedButton(inst.Child("buttonSubmit"), UIX_buttonSubmitPressed_Mousebreaker);		
				inst.Child("inputtext").SetText(submitScoreName);
				inst.Child("inputtext").mouseEnabled = true;
				inst.Child("inputtext").button_canPress = true;
				
			}			
		}
		static function UIX_buttonSubmitPressed_Mousebreaker(inst:UIX_Instance)
		{
			highScore_inst.visible = false;
			
			var name:String = highScore_inst.Child("inputtext").GetText();
			GameVars.playerName = name;
			var sc:int = RetrieveHighScore(0);
			SubmitScore_MouseBreaker(sc, name,SubmitScore_Complete_Callback);
		}

		static function RetrieveHighScore(mode:int)
		{
			Game.CalculateScore();
			return GameVars.currentScore;
		}

		static var submitScoreName:String = "Your Name";
		static var submitScoreCallback:Function;
		static var getHighScoreFunction:Function;
		static var highScore_Textfield:TextField;
		static var highScore_Button:MovieClip;
		
		public static function SubmitScoreButton(wholeClip:MovieClip,b:MovieClip,textField:TextField,_cb:Function = null):void
		{
			wholeClip.visible = false;
			getHighScoreFunction = RetrieveHighScore;
			highScore_Textfield = textField;
			highScore_Button = b;
			
			submitScoreCallback = _cb;
			highScore_Button.visible = false;
			highScore_Textfield.visible = false;
			
			submitScoreName = GameVars.playerName;

			if (LicDef.GetLicensor() == LicDef.LICENSOR_MOUSEBREAKER)
			{
				wholeClip.visible = true;
				// text input box and submit score button
				highScore_Button.visible = true;
				highScore_Textfield.visible = true;
				highScore_Textfield.text = submitScoreName;
				UI.AddAnimatedMCButton(highScore_Button, SubmitScore_Clicked_Callback);
			}
			//if (GetLicensor() == LicDef.LICENSOR_ARMORGAMES)
			//{
			//	highScore_Button.visible = false;
			//	highScore_Textfield.visible = false;
			//}
			
		}
		static function SubmitScore_Clicked_Callback(e:MouseEvent)
		{
			highScore_Button.visible = false;
			highScore_Textfield.visible = false;
			
			var sc:int = RetrieveHighScore(0);
			submitScoreName = highScore_Textfield.text;
			if (GetLicensor() == LicDef.LICENSOR_MOUSEBREAKER)
			{
				SubmitScore_MouseBreaker(sc, highScore_Textfield.text,SubmitScore_Complete_Callback);
			}
			if (GetLicensor() == LicDef.LICENSOR_ARMORGAMES)
			{
				SubmitScore_ArmorGames(sc, SubmitScore_Complete_Callback);
			}
		}
		static function SubmitScore_Complete_Callback(e:MouseEvent)
		{
			if (submitScoreCallback != null)
			{
				submitScoreCallback();
			}
		}
		

		static function ScoreSubmitted()
		{
			//submitScoreName = titleMC.buttonSubmitScoreName.text;
		}
		
		
		public static function InitHighscores()
		{
			if (LicDef.IsAtKongregate())	//GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE)
			{
				InitHighScores_Kongregate();
			}
		}
		
		static function InitHighScores_ArmorGames():void
		{
				//Developer Key : 57e6ffa35f343197fbd276da0a94ccbb
				//Game Key : rescue-on-cocoa-farm


			// URL to the AGI swf
			var agi_url:String = "http://agi.armorgames.com/assets/agi/AGI.swf";
			Security.allowDomain(agi_url);
			Security.allowInsecureDomain(agi_url);

			// Developer key and game key
			

			// Load the AGI
			var urlRequest:URLRequest = new URLRequest ( agi_url );
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener ( Event.COMPLETE, InitHighScores_ArmorGames_LoadComplete );
			loader.load ( urlRequest );

// Used for the AGI reference

// Called when AGI swf finishes loading


		}
		
		static var agi:*
		static function InitHighScores_ArmorGames_LoadComplete ( e:Event ):void
		{
		  // Save the AGI reference
			agi = e.currentTarget.content; 
		 // Must be added to the stage
			LicDef.GetStage().addChild( agi );

		  // Initialization using your developer key and game key
			agi.init( LicDef.armorHighScore_devKey, LicDef.armorHighScore_gameKey );
		}	
		
		static var highscore_callback:Function;
		static function SubmitScore_ArmorGames(score:int,_cb:Function=null)
		{
			highscore_callback = _cb;
			LicDef.GetStage().addChild(agi);
			agi.initAGUI( { onClose:SubmitHighscore_ArmorGames_CloseHandler } );

			// Show the list of highscores from the server on screen.
//			agi.showScoreboardList();

			// Show the submit score page on screen.
			/* Parameters:
				score - The score the player achieved
				playerName - Name of the player. (optional)
				scoreType - Type of score you are submitting (Ex: "easy", "medium", "hard") (optional)
			*/
			agi.showScoreboardSubmit( score );

		}
		static function ViewScore_ArmorGames(_cb:Function=null)
		{
			highscore_callback = _cb;
			LicDef.GetStage().addChild(agi);
			agi.initAGUI( { onClose:SubmitHighscore_ArmorGames_CloseHandler } );

			// Show the list of highscores from the server on screen.
			agi.showScoreboardList();
		}
		static function SubmitHighscore_ArmorGames_CloseHandler():void
		{
		   // Resume game
		   LicDef.GetStage().removeChild(agi);
		   if (highscore_callback != null)
		   {
			   highscore_callback(null);
		   }
		}		
		
//-------------------------------------------------------------------------------------------------

		static var kong_isLoaded:Boolean = false;
		static function InitHighScores_Kongregate()
		{
			var mochiLoader:Object = LicDef.GetStage().stage.loaderInfo.loader;
			var paramObj:Object = LoaderInfo(LicDef.GetStage().stage.loaderInfo).parameters;

			// The API path. The debug version ("shadow" API) will load if testing locally. 
			var api_url:String = paramObj.api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";

			// Load the API
			
			kong_isLoaded = false;
			
			var request:URLRequest = new URLRequest ( api_url );
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener ( Event.COMPLETE, kong_loadComplete );
			loader.load ( request );
			LicDef.GetStage().stage.addChild ( loader );

		}
		
		// Kongregate API reference
		static var kongregate:*

		/**
		* Called when API swf finishes loading
		*/
		static function kong_loadComplete  ( event:Event ):void
		{
			// Save Kongregate API reference
			kongregate = event.target.content;

			// Connect
			kongregate.services.connect();

			// Debug our services
			trace ( "\n" + kongregate.services );
			trace ( "\n" + kongregate.user );
			trace ( "\n" + kongregate.scores );
			trace ( "\n" + kongregate.stats );
			kong_isLoaded = true;
		}
		
//		public static function SubmitScore(score:Number, type:String)
//		{
//			if (isLoaded == false) return;
//			trace("Kong Score: " + type + "  " + score);
//			if (LicDef.IsAtKongregate() == false) return;
//			kongregate.scores.submit(score, type);
//		}

		public static function Kongregate_IsGuest():Boolean
		{
			if (LicDef.IsAtKongregate() == false) return true;
			if (kong_isLoaded == false) return true;
			return kongregate.stats.isGuest();
		}
		public static function Kongregate_GetUserName(def:String = "UserName"):String
		{
			if (LicDef.IsAtKongregate() == false) return def;
			if (kong_isLoaded == false) return def;
			return kongregate.services.getUsername();
		}
		public static function Kongregate_SubmitStat(value:Number, type:String)
		{
			if (LicDef.IsAtKongregate() == false) return;
			if (kong_isLoaded == false) return;
			Utils.print("Kong Stat: " + type + "  " + value);
			kongregate.stats.submit(type,value);
		}
		


//---------------------------------------------------------------------------------------------------


// ------------------------------------------ MouseBreaker highscore stuff ------------------------------------

		
		private static var callback:Function;
		public static function SubmitScore_MouseBreaker(score:int,name:String,_cb:Function = null):void
		{
			callback = _cb;
			Utils.print("calling SubmitScore_MouseBreaker with score "+score+" and name: "+name);
			
			
			  var url:String=LicDef.mouseBreaker_hiscore_url+"?" + int(Math.random() * 100000);
			  var reqURL:URLRequest=new URLRequest(url);
			  var variables:URLVariables = new URLVariables();

			  variables.score = score;
			  variables.username = name;

			  reqURL.data = variables;

			  reqURL.method=URLRequestMethod.POST;
			  var loader:URLLoader=new URLLoader(reqURL);
			  loader.addEventListener(Event.COMPLETE,SubmitScore_MouseBreaker_Complete);
			  loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			  
		}
		
		static function SubmitScore_MouseBreaker_Complete(e:Event)
		{
			callback(null);
		}
		
//-------------------------------------------------------------------------------------------------

		
		static var highscoreButtonInst:UIX_Instance = null;
		public static function UIX_HighscoreButton(inst:UIX_Instance)
		{
			highscoreButtonInst = inst;
			inst.visible = false;
			inst.SetText("");
			Leaderboards.GetTopScore(UIX_HighscoreButtonCB);			
		}
		static function UIX_HighscoreButtonCB(o:Object)
		{
			if (highscoreButtonInst == null) return;
			highscoreButtonInst.visible = false;
			if (o == null) return;
			if (o.length < 1) return;
			highscoreButtonInst.visible = true;
			var score:int = o[0].Score.score;
			highscoreButtonInst.Child("textScore").SetText(score.toString());
			
			UIX.AddAnimatedButton(highscoreButtonInst, UIX_HighscoreButtonClicked);
		}
		public static function UIX_HighscoreButtonClicked(inst:UIX_Instance)
		{
			UI.StartTransition("highscores");
		}

	}
	
	
//-------------------------------------------------------------------------------------------------



	
}