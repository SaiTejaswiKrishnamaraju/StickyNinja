package LicPackage
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;
	import CPMStar.*;
	import UIPackage.UI;
	/**
	 * ...
	 * @author Julian
	 */
	public class LicAds
	{
		
		import mochi.as3.*;

		public static var intro:MovieClip;		
		public static var cx:int;
		public static var cy:int;		
		static var oldFrameRate:int = 0;
		
		
		public static function GetLicensor():int
		{
			return LicDef.GetLicensor();
		}

		public static function GetSku(skuID:int):LicSku
		{
			return LicDef.GetSku(skuID);
		}
		
		public static function GetCurrentSku():LicSku
		{
			return LicDef.GetSku(LicDef.GetLicensor());
		}
		
		
		
		public static function IsAtGames1():Boolean
		{
			var domain:String = LicDef.GetDomain();
			if (domain == "games1.com") return true;
			return false;
		}
		public static function IsAtNotDoppler():Boolean
		{
			var domain:String = LicDef.GetDomain();
			if (domain == "notdoppler.com") return true;
			return false;
		}
		
		public static function ShouldTryLoadAdXML():Boolean
		{
			var domain:String = LicDef.GetDomain();
			if (domain == "kongregate.com") return false;
			if (domain == "3366.com") return false;
			if (domain == "3366img.com") return false;
			if (domain == "7k7k.com") return false;
			if (domain == "4399.com") return false;
			if (domain == "qq.com") return false;
			if (domain == "kaisergames.de") return false;
			if (domain == "gamezhero.com") return false;
			return true;
			
		}
		public static function FilterAdForSites():Boolean
		{
			var domain:String = LicDef.GetDomain();
			
			if (domain == "armmorgames.com") return true;
			if (domain == "kongregate.com") return true;
			if (domain == "agame.com") return true;
			if (domain == "armorgames.com") return true;
			if (domain == "flashgamelicense.com") return true;
			if (domain == "gamesheep.com") return true;
			if (domain == "ejocuri.ro") return true;
			if (domain == "ejocurigratis.ro") return true;
			if (domain == "jaludo.com") return true;
			if (domain == "gamezhero.com") return true;
			if (domain == "flashgames247.com") return true;
			if (domain == "gamemazing.com") return true;
			if (domain == "parkinggames.com") return true;

			
			if (IsAtKiba()) return true;
			if (IsAtGames1()) return true;
			return false;
		}
		
		static var showAdFinishedCallback:Function;
		public static function ShowAd(_showAdFinishedCallback:Function)
		{
			
			if (GetCurrentSku().skipPreloader)
			{
				_showAdFinishedCallback();
				return;
			}
			
			oldFrameRate = 0;
			intro = null;
			cx = Defs.displayarea_w / 2;
			cy = Defs.displayarea_h / 2;
			
			
			showAdFinishedCallback = _showAdFinishedCallback;
			var adtype:int = GetCurrentSku().adtype;
			
			if (AdHolder.IsLoadedPreAdAvailable() && adtype != LicDef.ADTYPE_NONE)
			{
				ShowTurboNukeAd();
				
			}
			else
			{
			
				if (adtype == LicDef.ADTYPE_NONE) ShowNoAd();
				else if (adtype == LicDef.ADTYPE_MOCHI_VC) ShowNoAd();
				else if (adtype == LicDef.ADTYPE_MOCHI)
				{
					ShowMochiAd_Preload();
				}
				else if (adtype == LicDef.ADTYPE_CPMSTAR)
				{
					if (FilterAdForSites() == false)
					{
						ShowCPMStarAd();
					}
					else
					{
						ShowNoAd();
					}
				}
				else if (adtype == LicDef.ADTYPE_EPICGAMEADS)
				{
					if (FilterAdForSites() == false)
					{
						ShowEpicGameAd();
					}
					else
					{
						ShowNoAd();
					}
				}
			}
		}
		
		
		
		static function CPMStarLoadingEventCallback(event:Event):void
		{
			var bytestotal = LicDef.GetStage().stage.loaderInfo.bytesTotal;
			var bytesloaded = LicDef.GetStage().stage.loaderInfo.bytesLoaded;
			
			var val:Number = 1 / bytestotal * bytesloaded;
			RenderLoaderBar(val);
			if (bytesloaded >= bytestotal) {
				LicDef.GetStage().removeEventListener(Event.ENTER_FRAME, CPMStarLoadingEventCallback);
				cpmStarLoaderCounter++;
				CPMStarCompleteCallback();
			}
		}
		
		static function CPMStarCompleteCallback():void
		{
			if(cpmStarLoaderCounter >= 2)
			{
				if(intro.loaderBar != null) intro.loaderBar.visible = false;
				intro.buttonSkipCPMStarAd.visible = true;
				
				if (LicDef.GetCurrentSku().skipPreloaderContinueButton)
				{
					buttonSkipCPMStarAdPressed(null);
				}
			}
		}		
		
		
		static function CPMStarTimerCallback(e:TimerEvent):void
		{
			cpmStarLoadTimer++;
			if (cpmStarLoadTimer >= LicDef.CPMStarFixedTime)
			{			
				cpmStarLoaderCounter++;
				cpmStarTimer.stop();
				CPMStarCompleteCallback();
			}
			else
			{
				cpmStarTimer.start();
			}
		}
		private static var cpmStarLoadTimer:int;
		private static var cpmStarLoaderCounter:int;
		private static var cpmStarTimer:Timer
		private static var ad:DisplayObject = null;
		
		// takes a value from 0 - 1
		static function RenderLoaderBar(val:Number):void
		{
			if (intro == null) return;
			if (intro.loaderBar != null)
			{
//				intro.loaderBar.loadBar.scaleX = val;
				var newVal:int = ScaleTo(1, intro.loaderBar.totalFrames, 0, 1, val);
				intro.loaderBar.gotoAndStop(newVal);
			}
		}
		public static function ScaleTo(f0:Number, f1:Number,o0:Number,o1:Number,val:Number):Number
		{
			var od:Number = o1 - o0;
			var fd:Number = f1 - f0;
			
			var d:Number = 1.0 / od * (val-o0);
			d = (fd * d) + f0;
			
			return d;			
		}
		
		public static function RandBetweenInt(r0:int,r1:int):int
		{
			var r:int = Math.random() * ((r1-r0)+1);
			r += r0;
			return r;
		}

		//
		
		static function AddIntroScreenAndSetUpButtons()
		{
			intro = new preloader();
			intro.x = 0;	// cx;
			intro.y = 0;	// cy;
			ScreenSize.ScaleMovieClip(intro);


			LicDef.GetStage().addChild(intro);
			
			MainLogoButton(intro.mainLogo);
			
			
			LicUI.AddAnimatedMCButton(intro.buttonSkipCPMStarAd, buttonSkipCPMStarAdPressed);
			AuthorButton(intro.turboBtn);
			intro.buttonSkipCPMStarAd.visible = false;
			
		}
		
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
		static function AuthorLinkPressed(e:MouseEvent):void
		{
			if (LicDef.authorLinks.length == 0) return;
			
			var r:int = RandBetweenInt(0, LicDef.authorLinks.length - 1);
			r = LimitNumber(0, LicDef.authorLinks.length - 1, r);
			DoLink(LicDef.authorLinks[r]);
			
		}
		public static function LimitNumber(f0:Number, f1:Number,n:Number):Number
		{
			if (n < f0) n = f0;
			if (n > f1) n = f1;			
			return n;			
		}
		
		
		public static function ShowTurboNukeAd():void
		{
			AddIntroScreenAndSetUpButtons();
			
			var adItem:AdItem = AdHolder.GetPreAdItem();
			if (adItem != null)
			{
				ad = AdHolder.GetPreAdCustomMC(intro.adBox);
				intro.adBox.addChild(ad);
			
				if (adItem.url != "")
				{
					intro.adBox.addEventListener(MouseEvent.CLICK, AdHolder.PreAdClicked);
					intro.adBox.buttonMode = true;
					intro.adBox.useHandCursor = true;
				}
			}

			cpmStarLoaderCounter = 0;
			LicDef.GetStage().addEventListener(Event.ENTER_FRAME, CPMStarLoadingEventCallback);
			cpmStarTimer = new Timer(1000);
			cpmStarTimer.addEventListener(TimerEvent.TIMER,CPMStarTimerCallback);
			cpmStarTimer.start();
			
		}
		
//------------------------------------------------------------------------------------		
//------------------------------------------------------------------------------------		
//------------------------------------------------------------------------------------		
//------------------------------------------------------------------------------------		
//------------------------------------------------------------------------------------		
		

/*
var myEpicGameAdsPublisherCode:String="3run02qoxt";
var myEpicGameAdsGameID:String="1";
//--> Optional ad settings
var myEpicGameAdsBgSolid:int=0; // 1 = enabled (show the ad background filled with color), 0 = disabled
var myEpicGameAdsBgColor:uint=0x000000; // background hex RGB color if background is solid
var myEpicGameAdsFadeIn:int=1; // 1 = enabled, 2 = disabled (no fade in)
var myEpicGameAdsFadeFrames:int=24; // how many frames in fadeIn default 24
//-->DO NOT EDIT BELOW THIS LINE

//--> ad display object positioning vars
var epicXPos:int=0;
var epicYPos:int=0;
//--> fixed relative to upper left of image bounds
setRegPoint(this,epicXPos,epicYPos);
var sEpicRefURL:String=loaderInfo.loaderURL;
var oEpicUserInfo:Object={publisherCode:myEpicGameAdsPublisherCode,gameId:myEpicGameAdsGameID,refURL:sEpicRefURL,bgSolid:myEpicGameAdsBgSolid,bgColor:myEpicGameAdsBgColor,fadeIN:myEpicGameAdsFadeIn,fadeFrames:myEpicGameAdsFadeFrames};
var oEpicContent:Object;
var oEpicDisplay:DisplayObject;
var epicGameAds:Loader; // holds reference to loader, used to unload ad later

Security.allowDomain("http://www.epicgameads.com","http://epicgameads.com");
//--> sandbox security notice
  if(Security.sandboxType != "remote")
  {
  trace("Notice:Running EpicGameAds InGameAd in local security sandbox (domain)");
  trace("Ads may not be visible when in local sandbox");
  trace("Publish the SWF and run it in a REMOTE security sandbox (from a internet URL)");
  }

//-->@remove all children
var i:int = this.numChildren;
while( i -- )
{
    this.removeChildAt( i );
}
//--> init EpicGameAds ad
epicInit();

//--> EpicGameAds as3 Functions
function epicInit():void
{
var swfUrl:String="http://www.epicgameads.com/epicgameads-as3-v2.swf";
var request:URLRequest=new URLRequest(swfUrl);
var loader:Loader=new Loader();
//--> save reference to loader
epicGameAds=loader;
loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onEpicConIOError);
loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, epicLoadProgress,false,0,true);
loader.contentLoaderInfo.addEventListener(Event.COMPLETE, epicLoadComplete,false,0,true);
loader.load(request);
oEpicDisplay=this.addChild(loader);
}

function unloadEpicGameAds()
{
//--> unload the ingame ad
epicGameAds.unloadAndStop();
}

function onEpicConIOError(e:IOErrorEvent)
{
trace(e.text);
}

function epicLoadProgress(e:ProgressEvent):void
{
var percentLoaded:Number=e.bytesLoaded/e.bytesTotal;
percentLoaded=Math.round(percentLoaded*100);
}

function epicLoadComplete(e:Event):void
{
oEpicDisplay.x=epicXPos;
oEpicDisplay.y=epicYPos;
oEpicContent=Object(e.target.content);
//--> External call to connect function
oEpicContent.adServerConnect(oEpicUserInfo);
}

function setRegPoint(obj:DisplayObjectContainer, newX:Number, newY:Number):void {
	//get the bounds of the object and the location
	//of the current registration point in relation
	//to the upper left corner of the graphical content
	//note: this is a PSEUDO currentRegX and currentRegY, as the
	//registration point of a display object is ALWAYS (0, 0):
	var bounds:Rectangle = obj.getBounds(obj.parent);
	var currentRegX:Number = obj.x - bounds.left;
	var currentRegY:Number = obj.y - bounds.top;

	var xOffset:Number = newX - currentRegX;
	var yOffset:Number = newY - currentRegY;
	//shift the object to its new location--
	//this will put it back in the same position
	//where it started (that is, VISUALLY anyway):
	obj.x += xOffset;
	obj.y += yOffset;

	//shift all the children the same amount,
	//but in the opposite direction
	for(var i:int = 0; i < obj.numChildren; i++) {
		obj.getChildAt(i).x -= xOffset;
		obj.getChildAt(i).y -= yOffset;
	}
}
stop();
//--> end as3 movieclip symbol ad placeholder code
*/

		static var myEpicGameAdsPublisherCode:String="3run02qoxt";
		static var myEpicGameAdsGameID:String="1";
		//--> Optional ad settings
		static var myEpicGameAdsBgSolid:int=0; // 1 = enabled (show the ad background filled with color), 0 = disabled
		static var myEpicGameAdsBgColor:uint=0x000000; // background hex RGB color if background is solid
		static var myEpicGameAdsFadeIn:int=1; // 1 = enabled, 2 = disabled (no fade in)
		static var myEpicGameAdsFadeFrames:int=24; // how many frames in fadeIn default 24
		static var epicGameAds:Loader; // holds reference to loader, used to unload ad later
		static var oEpicContent:Object;
		static var oEpicDisplay:DisplayObject;
		static var oEpicUserInfo:Object;
		
		public static function ShowEpicGameAd():void
		{
			AddIntroScreenAndSetUpButtons();
			
			var sEpicRefURL:String=LicDef.GetStage().stage.loaderInfo.loaderURL;
			oEpicUserInfo={publisherCode:myEpicGameAdsPublisherCode,gameId:myEpicGameAdsGameID,refURL:sEpicRefURL,bgSolid:myEpicGameAdsBgSolid,bgColor:myEpicGameAdsBgColor,fadeIN:myEpicGameAdsFadeIn,fadeFrames:myEpicGameAdsFadeFrames};

			Security.allowDomain("http://www.epicgameads.com","http://epicgameads.com");
			//--> sandbox security notice
		  if(Security.sandboxType != "remote")
		  {
			  trace("Notice:Running EpicGameAds InGameAd in local security sandbox (domain)");
			  trace("Ads may not be visible when in local sandbox");
			  trace("Publish the SWF and run it in a REMOTE security sandbox (from a internet URL)");
		  }
			
			var swfUrl:String="http://www.epicgameads.com/epicgameads-as3-v2.swf";
			var request:URLRequest=new URLRequest(swfUrl);
			var loader:Loader=new Loader();
			//--> save reference to loader
			epicGameAds=loader;
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onEpicConIOError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, epicLoadProgress,false,0,true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, epicLoadComplete,false,0,true);
			loader.load(request);
			
			oEpicDisplay=intro.adBox.addChild(loader);

			cpmStarLoaderCounter = 0;
			LicDef.GetStage().addEventListener(Event.ENTER_FRAME, CPMStarLoadingEventCallback);
//			cpmStarTimer = new Timer(1000);
			cpmStarTimer.addEventListener(TimerEvent.TIMER,CPMStarTimerCallback);
			cpmStarTimer.start();
			
		}
		
		static function unloadEpicGameAds()
		{
		//--> unload the ingame ad
			epicGameAds.unloadAndStop();
		}

		static function onEpicConIOError(e:IOErrorEvent)
		{
			trace(e.text);
		}

		static function epicLoadProgress(e:ProgressEvent):void
		{
			var percentLoaded:Number=e.bytesLoaded/e.bytesTotal;
			percentLoaded=Math.round(percentLoaded*100);
		}

		static function epicLoadComplete(e:Event):void
		{
			oEpicDisplay.x = 0;	// epicXPos;
			oEpicDisplay.y = 0;	// epicYPos;
			oEpicContent=Object(e.target.content);
		//--> External call to connect function
			oEpicContent.adServerConnect(oEpicUserInfo);
		}
		
		
//-----------------------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------------------		
//-----------------------------------------------------------------------------------------------------------------		
		
		public static function ShowCPMStarAd():void
		{
			AddIntroScreenAndSetUpButtons();
			
			var id:String;
			var num:int = LicDef.CPMStarContentSpotIDs.length;
			if (num == 1)
			{
				id = LicDef.CPMStarContentSpotIDs[0];
			}
			if (num == 2)
			{
				var r:int = RandBetweenInt(0, 1000);
				if (r < 500)
				{
					id = LicDef.CPMStarContentSpotIDs[0];
				}
				else
				{
					id = LicDef.CPMStarContentSpotIDs[1];
				}
			}
//			trace("CPMStar ID " + id);
			ad = new CPMStar.AdLoader(id);
			intro.adBox.addChild(ad);
	

			cpmStarLoadTimer = 0;
			cpmStarLoaderCounter = 0;
			LicDef.GetStage().addEventListener(Event.ENTER_FRAME, CPMStarLoadingEventCallback);
			cpmStarTimer = new Timer(1000);
			cpmStarTimer.addEventListener(TimerEvent.TIMER,CPMStarTimerCallback);
			cpmStarTimer.start();
		}
		
		
		public static function ShowMochiAd_Preload()		// but preload the game please
		{
			LicDef.GetStage().stop();

			AddIntroScreenAndSetUpButtons();
			
			cpmStarLoadTimer = 0;
			cpmStarLoaderCounter = 1;

			ShowMochiAd();
		}
		
		
		static function ShowMochiAd_Preload_LoadingEventCallback(event:Event) 
		{
			var bytestotal = LicDef.GetStage().stage.loaderInfo.bytesTotal;
			var bytesloaded = LicDef.GetStage().stage.loaderInfo.bytesLoaded;
			
			var val:Number = 1 / bytestotal * bytesloaded;
			RenderLoaderBar(val);
			if (bytesloaded >= bytestotal) 
			{
				LicDef.GetStage().removeEventListener(Event.ENTER_FRAME, ShowMochiAd_Preload_LoadingEventCallback);
				LicDef.GetStage().play();
				if (showAdFinishedCallback != null) showAdFinishedCallback();
			}
		}

		public static function ShowMochiAd()
		{
			MochiAd.showPreGameAd( { clip:LicDef.GetStage(), id:LicDef.MochiAdID, res:LicDef.MochiAdRes, ad_finished:MochiAdFinished } );			
		}
		
		public static function MochiAdFinished()
		{
			LicDef.GetStage().removeChild(intro);
			intro = null;
			if (showAdFinishedCallback != null) showAdFinishedCallback();
			LicDef.GetStage().play();
		}
		
		
		public static function ShowNoAd():void		// but preload the game please
		{

			AddIntroScreenAndSetUpButtons();


			intro.adBox.visible = false;
			
			cpmStarLoadTimer = 0;
			cpmStarLoaderCounter = 1;
			LicDef.GetStage().addEventListener(Event.ENTER_FRAME, CPMStarLoadingEventCallback);
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
					trace("Lic: MainLogo Error. Null child found. (not a button?)");
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
					trace("Lic: MainLogo Error. Null child found. (not a button?)");
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
							logo.addEventListener(MouseEvent.CLICK, ClickedLinkURL, false, 0, true);							
						}
					}
					else
					{
						logo.useHandCursor = false;
					}
				}
				else
				{
					trace("Lic: MainLogo Error. Can't find logo: "+sku.mainLogoName);
				}
			}
		}
		
		static function ClickedLinkURL(e:MouseEvent)
		{
			var sku:LicSku = GetCurrentSku();
			DoLink(sku.linkURL);
		}
		static function ClickedMainLogoURL(e:MouseEvent)
		{
			var sku:LicSku = GetCurrentSku();
			DoLink(sku.mainLogoLinkURL);
		}
		
		public static function DoLink(linkStr:String)
		{
			Tracking.LogLink(linkStr, "preloader","mainlogo");
			var s:String = linkStr + LicDef.referralString;
			navigateToURL(new URLRequest(s), "_blank");
		}
		
		public static function Link_TurboNuke(e:MouseEvent,buttonString:String="intro")
		{
			navigateToURL(new URLRequest("http://www.turbonuke.com?gamereferral=" + LicDef.referralName), "_blank");
		}
		
		
		public static function AddButton(btn:SimpleButton,clickCallback:Function)
		{			
			if (btn == null)
			{
				trace("add button button = null");				
			}
			if (clickCallback == null)
			{
				trace("add button clickCallback = null");				
			}
			btn.addEventListener(MouseEvent.CLICK, clickCallback, false, 0, true);	
		}
		
		static function buttonSkipCPMStarAdPressed(e:MouseEvent):void		
		{
			if(ad != null)
			{
				intro.adBox.removeChild(ad);
			}
			
			if (showAdFinishedCallback != null)
			{
				showAdFinishedCallback();
			}
		}
		
		public static function RemovePreloaderStuff()
		{
			if (intro != null)
			{
				LicDef.GetStage().removeChild(intro);
				Utils.RemoveMovieClipEntirely(intro);
				intro = null;
			}			
		}
		
		public static function IsAtKiba():Boolean
		{
			var domain:String = LicDef.GetDomain();
			if (domain == "kaisergames.de") return true;
			return false;
		}
		
		
		
	}

}