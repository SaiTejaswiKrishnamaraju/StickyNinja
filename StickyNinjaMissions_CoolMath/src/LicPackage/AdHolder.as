package LicPackage
{
	import CPMStar.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.xml.XMLDocument;
	import LicPackage.LicDef;
	/**
	 * ...
	 * @author ...
	 */
	public class AdHolder 
	{
		
		static var items:Vector.<AdItem> = null;
		static var pread_items:Vector.<AdItem> = null;
		
		public static var adIndex:int = 0;
		static var currentAd:MovieClip;
		static var currentPreAd:MovieClip;
		
		static var prequelLink:String = "http://www.turbonuke.com/games.php?game=Cyclomaniacs" +LicDef.referralString;
		
		public function AdHolder() 
		{
			
		}
		
		
		public static function ReloadIngameAds()
		{
			items = new Vector.<AdItem>();
			
			loadIndex = 0;
			adIndex = 0;
			currentAd = null;
			initOnceCompleteCallback = null;
			LoadCustomAdXML();
		}

		
		static var initOnceCompleteCallback:Function;
		public static function InitOnce(_callback:Function)
		{
			if (LicDef.GetCurrentSku().allowOtherGames == false) 
			{
			 DoCompletedCallback();
			}
			
			initOnceCompleteCallback = _callback;
			items = new Vector.<AdItem>();
			pread_items = new Vector.<AdItem>();
			
			adIndex = 0;
			currentAd = null;
			currentPreAd = null;
			
			
			if (LicDef.IsAtKongregate())
			{
				items.push( new AdItem("OtherGames", "othergames", "",""));
				DoCompletedCallback();
			}
			else
			{			
				items.push( new AdItem("OtherGames", "othergames", "",""));
								
				if (LoadCustomAdXML() == false)
				{
					DoCompletedCallback();
				}
			}
		}
		
		public static function IsLoadedPreAdAvailable():Boolean
		{
			if (pread_items.length == 0) return false;
			if (pread_items[0].urlLoaded == false) return false;
			return true;
		}
		
		static function MakeIntersitialItemAndTestAdFilters():AdItem
		{
			var ad:AdItem = new AdItem("Intersitial", "intersitial", "", "")

			if (LicDef.GetCurrentSku().adtype != LicDef.ADTYPE_CPMSTAR)
			{
				ad = new AdItem("OtherGames", "othergames", "", "");
			}
			
			if (LicAds.FilterAdForSites())
			{
				ad = new AdItem("OtherGames", "othergames", "", "");
			}
			return ad;			 
		}
		
		static var urlXMLLoader:URLLoader;
		static var urlLoader:Loader;
		static var loadList:Array;
		static var loadIndex:int;
		
		static function GetAdItemByName(_name:String):AdItem
		{
			for each(var ad:AdItem in items)
			{
				if (ad.name == _name) return ad;
			}
			return null;
		}
		
		static function AddLoadedAdsFromXML(xml:XML)
		{
			
			loadList = new Array();
			var adItem:AdItem;
			
			items = new Vector.<AdItem>();
			
			var num:int = xml.ad.length();
			for(var i:int=0; i<num; i++)
			{
				var x:XML = xml.ad[i];
				var name:String = XmlHelper.GetAttrString(x.@id, "");
				var active:Boolean = true;
				
				
				
				if (name == "OtherGames")
				{
					items.push( new AdItem("OtherGames", "othergames", "",""));
				}
				else if (name == "OtherGames")
				{
					items.push( new AdItem("OtherGamesText", "othergamestext", "",""));
				}
				else if (name == "Intersitial")
				{
					items.push( MakeIntersitialItemAndTestAdFilters() );
				}
				else if (name == "Prequel")
				{
					items.push( new AdItem("Prequel", "prequel", "http://www.kongregate.com/games/LongAnimals/bubble-guinea-pop",""));
				}
				else if (name == "CycloRacers")
				{
					items.push( new AdItem("CycloRacers", "cycloracers", "http://www.turbonuke.com/cyclomaniacsracers.php",""));
				}
				else
				{
					var swfurl:String = XmlHelper.GetAttrString(x.@swfurl,"");
					var clickurl:String = XmlHelper.GetAttrString(x.@clickurl, "");
					var fullscreen:Boolean = XmlHelper.GetAttrBoolean(x.@fullscreen, false);
					
					if (swfurl == "")
					{
					}
					else
					{					
						adItem = new AdItem(name, "othergames", clickurl, swfurl);
						
						adItem.url_mobile_google = XmlHelper.GetAttrString(x.@clickurl_mobile_google, "");
						adItem.url_mobile_ios = XmlHelper.GetAttrString(x.@clickurl_mobile_ios, "");
						adItem.url_mobile_amazon = XmlHelper.GetAttrString(x.@clickurl_mobile_amazon, "");
						adItem.swfurl_mobile_google = XmlHelper.GetAttrString(x.@swfurl_mobile_google, "");
						adItem.swfurl_mobile_ios = XmlHelper.GetAttrString(x.@swfurl_mobile_ios, "");
						adItem.swfurl_mobile_amazon = XmlHelper.GetAttrString(x.@swfurl_mobile_amazon, "");
						adItem.adtype1 = XmlHelper.GetAttrString(x.@adtype1, "");
						adItem.adtype2 = XmlHelper.GetAttrString(x.@adtype2, "");
						
						adItem.url = "";	// overwritten when the swf is loaded
						items.push(adItem);
						loadList.push(adItem);
					}
				}
			}

			var num:int = xml.pread.length();
			for(var i:int=0; i<num; i++)
			{
				var x:XML = xml.pread[i];
				var name:String = XmlHelper.GetAttrString(x.@id, "");
				var active:Boolean = true;
				
				// only handles 'loaded in swf' style
				var swfurl:String = XmlHelper.GetAttrString(x.@swfurl,"");
				var clickurl:String = XmlHelper.GetAttrString(x.@clickurl, "");
				var fullscreen:Boolean = XmlHelper.GetAttrBoolean(x.@fullscreen, false);
				
				if (swfurl == "")
				{
				}
				else
				{					
					adItem = new AdItem(name, "othergames", clickurl, swfurl);
					adItem.fullScreen = fullscreen;
					adItem.url = "";	// overwritten when the swf is loaded
					pread_items.push(adItem);
					loadList.push(adItem);
				}
			}
			
			
			if (loadList != null && loadList.length >= 1)
			{
				LoadNextCustomAd();
			}
			else
			{
				DoCompletedCallback();
			}
		}
		
		public static function LoadCustomAdXML():Boolean
		{
			if (LicDef.IsRemoteAdLoadingAllowed() == false) return false;
			if (LicAds.ShouldTryLoadAdXML() == false) return false;
			
			var url:String = LicDef.AD_URL;
			
			if (PROJECT::isMobile)
			{
				url += "?mobile=1";
			}
			
			var request:URLRequest = new URLRequest(url);
			try
			{
				urlXMLLoader = new URLLoader();
				urlXMLLoader.addEventListener(Event.COMPLETE, LoadCustomAdXMLa_Complete);
				urlXMLLoader.addEventListener(ErrorEvent.ERROR, LoadCustomAdXMLa_Error);
				urlXMLLoader.addEventListener(AsyncErrorEvent.ASYNC_ERROR, CustomAdXML_onError1);
				urlXMLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, CustomAdXML_onError2);
				urlXMLLoader.addEventListener(IOErrorEvent.IO_ERROR, CustomAdXML_onError3);
				urlXMLLoader.load(request);
			}
			catch (e:ErrorEvent)
			{
				trace("caught error " + e);
				return false;
			}
			return true;
		}
		
		private static function LoadCustomAdXMLa_Error(e:Error) 
		{			
			trace("LoadCustomAdXMLa_Error " + e.message);
			DoCompletedCallback();
		}
		
		private static function LoadCustomAdXMLa_Complete(e:Event) 
		{
			//var adXML:XML = e.currentTarget.content as XML;					
//			trace("Loaded Custom Ad XML:" +e.target);	
//			trace("Loaded  " +urlXMLLoader.data);	

			var s:String = urlXMLLoader.data;
			XML.ignoreWhitespace = true;
			
			var xml:XML = null;
			
			try
			{
				xml = new XML(s);
			}
			catch (e:Error)
			{
				trace("XML error: " + e.message);
				xml = null;
			}
			
			if (xml != null)
			{
				AddLoadedAdsFromXML(xml);
			}
			else
			{
				DoCompletedCallback();
			}
			
//			trace(s);
			
			urlXMLLoader.removeEventListener(Event.COMPLETE, LoadCustomAdXMLa_Complete);
			urlXMLLoader.removeEventListener(ErrorEvent.ERROR, LoadCustomAdXMLa_Error);
			urlXMLLoader.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, CustomAdXML_onError1);
			urlXMLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, CustomAdXML_onError2);
			urlXMLLoader.removeEventListener(IOErrorEvent.IO_ERROR, CustomAdXML_onError3);
			urlXMLLoader = null;
		}
		
		static function DoCompletedCallback()
		{
			var fn:Function = initOnceCompleteCallback;
			initOnceCompleteCallback = null;
			if (fn != null)
			{
				fn();
			}
			
//			initOnceCompleteCallback();
		}

		private static function CustomAdXML_onError(e:Error) 
		{			
			trace("ACustom Ad XML Loading Error: " + e.message);
			DoCompletedCallback();
		}
		private static function CustomAdXML_onError1(e:AsyncErrorEvent) 
		{			
			trace("BCustom Ad XML Loading Error: " + e.error.message);
			DoCompletedCallback();
		}
		private static function CustomAdXML_onError2(e:SecurityErrorEvent) 
		{			
			trace("CCustom Ad XML Loading Error: " + e);
			DoCompletedCallback();
		}
		private static function CustomAdXML_onError3(e:IOErrorEvent) 
		{			
			trace("DCustom Ad XML Loading Error: " + e.text);
			DoCompletedCallback();
		}
		
		
		static function IsAdADuplicate(_loadIndex:int):AdItem
		{
			if (_loadIndex == 0) return null;
			var adItem:AdItem = loadList[_loadIndex];
			if (adItem == null) return null;
			
			for (var i:int = 0; i < _loadIndex; i++)
			{
				var adItem1:AdItem = loadList[i];
				if (adItem.CompareSwfUrlWith(adItem1)) return adItem1;
			}
			return null;
		}
		
		public static function LoadNextCustomAd()
		{
			var adItem:AdItem = loadList[loadIndex];
			if (adItem != null)
			{
				if (IsAdADuplicate(loadIndex) != null)
				{
					var adItem1:AdItem = IsAdADuplicate(loadIndex);
					adItem.urlLoaded = true;
					trace("ad is duplicate: " + adItem.swfurl);
					adItem.type = "custom";
					adItem.url = adItem.original_url;
					adItem.loader = adItem1.loader;
					
					loadIndex++;
					if (loadIndex < loadList.length)
					{
						LoadNextCustomAd();
					}
					else
					{
						DoCompletedCallback();
					}
					
				}
				else
				{
					if (adItem.swfurl != "")
					{
//						var loaderContext:LoaderContext = new LoaderContext();
						var loaderContext:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain, null);
						
						if (PROJECT::useStage3D == false)
						{
							Security.allowDomain("*");
							Security.allowInsecureDomain("*");
						}
//						loaderContext.checkPolicyFile = true;
//						loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
						
						adItem.loader = new Loader();
						adItem.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LoadNextCustomAd_Complete);
						adItem.loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, onError)
						adItem.loader.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
						adItem.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
						adItem.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
						var url:String = adItem.swfurl;
						
						if (PROJECT::isMobile)
						{
							url = adItem.swfurl_mobile_google;
							if (PROJECT::isAmazon)
							{
								url = adItem.swfurl_mobile_amazon;
							}
							if (PROJECT::isIOS)
							{
								url = adItem.swfurl_mobile_ios;
							}
						}
						
						adItem.loader.load( new URLRequest(url), loaderContext);	

						trace("loading ad " + url);
						
					}
				}
			}
		}
		private static function LoadNextCustomAd_Complete(e:Event) 
		{
			var adItem:AdItem = loadList[loadIndex];

			adItem.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, LoadNextCustomAd_Complete);
			adItem.loader.contentLoaderInfo.removeEventListener(ErrorEvent.ERROR, onError)
			adItem.loader.contentLoaderInfo.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
			adItem.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			adItem.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			
			adItem.urlLoaded = true;
			trace("ad loaded: " + adItem.swfurl);
			//adItem.customAd = urlLoader.content as MovieClip;				
			

			// This turns it on - it's set up as an 'othergames' type until the swf is loaded.
			adItem.type = "custom";
			adItem.url = adItem.original_url;
			
			loadIndex++;
			if (loadIndex < loadList.length)
			{
				LoadNextCustomAd();
			}
			else
			{
				DoCompletedCallback();
			}
		}
		

		private static function onError(e:IOErrorEvent) 
		{
			DoCompletedCallback();
		}
		
		
		public static function RemoveAd(parent:MovieClip)
		{
			if (currentAd != null)
			{
				var adItem:AdItem = items[adIndex];
				if (adItem.type == "othergames")
				{
					parent.removeChild(currentAd);
				}
				else if (adItem.type == "othergamestext")
				{
					parent.removeChild(currentAd);
				}
				else if (adItem.type == "intersitial")
				{
					RemoveIntersitialMC();
					parent.removeChild(currentAd);
				}
				else if (adItem.type == "custom")
				{
					if (adItem.urlLoaded == false)
					{
						parent.removeChild(currentAd);
					}
					else
					{
						RemoveCustomMC(parent);
					}
				}
				else if (adItem.type == "cycloracers")
				{
					parent.removeChild(currentAd);
				}
				else if (adItem.type == "prequel")
				{
					parent.removeChild(currentAd);
				}
				else if (adItem.type == "blank")
				{
					parent.removeChild(currentAd);
				}
				
				if (adItem.url != "")
				{
					currentAd.removeEventListener(MouseEvent.CLICK, AdClicked);
				}
				
				currentAd = null;
			}
		}
		
		
		static function getVisibleBounds(source:DisplayObject):Rectangle
	   {
		   var matrix:Matrix = new Matrix()
		   matrix.tx = -source.getBounds(null).x;
		   matrix.ty = -source.getBounds(null).y;
	 
		   var data:BitmapData = new BitmapData(source.width, source.height, true, 0x00000000);
		   data.draw(source, matrix);
		   var bounds : Rectangle = data.getColorBoundsRect(0xFFFFFFFF, 0x000000, false);
		   data.dispose();
		   return bounds;
	   }
		
		
		public static function AddAd(parent:MovieClip)
		{
			currentAd = GetAd();
			if (currentAd != null)
			{				
				parent.addChild(currentAd);
			}
		}
		public static function GetAd():MovieClip
		{
			var mc:MovieClip;
			
			if (items.length == 0)	// final failsafe
			{
				items.push( new AdItem("OtherGames", "othergames", "",""));				
			}
			
			adIndex++;
			if (adIndex >= items.length) adIndex = 0;
			
			var adItem:AdItem = items[adIndex];
			
			if (adItem.type == "othergames") 
			{
				if (PROJECT::isMobile)
				{
					mc = new MovieClip();
				}
				else
				{
					mc = OtherGames.GetOtherGamesMC();
				}
			}
			if(adItem.type == "othergamestext") mc = OtherGames.GetOtherGamesMC(4,2);
			if(adItem.type == "intersitial") mc = GetIntersitialMC();
			if(adItem.type == "cycloracers") mc = GetCycloRacersMC();
			if (adItem.type == "prequel")
			{
				mc = GetPrequelMC();
			}
			if(adItem.type == "custom") mc = GetCustomMC();
			if(adItem.type == "blank") mc = GetBlankMC();
			
			if (adItem.url != "")
			{
				mc.addEventListener(MouseEvent.CLICK, AdClicked);
				mc.mouseChildren = false;
				mc.buttonMode = true;
				mc.useHandCursor = true;
			}
			
			return mc;
		}
		
		public static function AdClicked(e:MouseEvent)
		{
			var adItem:AdItem = items[adIndex];
			if (adItem != null)
			{
				var url:String = adItem.url;
				if (PROJECT::isMobile)
				{
					url = adItem.url_mobile_google;
					if (PROJECT::isAmazon)
					{
						url = adItem.url_mobile_amazon;
					}
					if (PROJECT::isIOS)
					{
						url = adItem.url_mobile_ios;
					}
				}
				if (url != "")
				{
					navigateToURL(new URLRequest(url), "_blank");
				}
			}
			
		}

		public static function PreAdClicked(e:MouseEvent)
		{
			var adItem:AdItem = pread_items[0];
			if (adItem != null)
			{
				if (adItem.url != "")
				{
					navigateToURL(new URLRequest(adItem.url), "_blank");
				}
			}
			
		}
		
//------------------------------------------------------------------------------------------------------------------------

		static function GetPrequelMC():MovieClip
		{
			var classRef_PrequelAd:Class = getDefinitionByName("PrequelAd") as Class;
			var mc:MovieClip = new classRef_PrequelAd() as MovieClip;
			return mc;
		}
		static function GetCycloRacersMC():MovieClip
		{
			var mc:MovieClip = new MovieClip();	// ad_banner_cycloracers();
			return mc;
		}
		static function GetBlankMC():MovieClip
		{
			return new MovieClip();
		}
		
		
		
		
		static function RemoveCustomMC(parent:MovieClip)
		{
			parent.removeChild(currentAd);
			
		}
		static function GetCustomMC():MovieClip
		{
			var adItem:AdItem = items[adIndex];
			if (adItem.urlLoaded == false)
			{
				return GetBlankMC();
			}
			
			if (adItem.loader.content is MovieClip)
			{
				var mcInner:MovieClip = adItem.loader.content as MovieClip;
				
				var mc:MovieClip = new MovieClip();
				
				if (PROJECT::isMobile)
				{
					mc.scaleX *= ScreenSize.fullScreenScale;
					mc.scaleY *= ScreenSize.fullScreenScale;
					mc.x += ScreenSize.fullScreenScaleXOffset;
					mc.y += ScreenSize.fullScreenScaleYOffset;
				}
				mc.addChild(mcInner);
				mcInner.play();
				
			}
			if (adItem.loader.content is Bitmap)
			{
				var mc:MovieClip = new MovieClip();
				var b:Bitmap = adItem.loader.content as Bitmap;
				b.smoothing = true;
				mc.addChild(b);
				mc.scaleX = 240 / b.width;
				mc.scaleY = 230 / b.height;
				
				if (PROJECT::isMobile)
				{
					mc.scaleX *= ScreenSize.fullScreenScale;
					mc.scaleY *= ScreenSize.fullScreenScale;
					mc.x += ScreenSize.fullScreenScaleXOffset;
					mc.y += ScreenSize.fullScreenScaleYOffset;
				}
				
			}
			return mc;
		}

		static function GetPreAdItem():AdItem
		{
			if (pread_items == null) return null;
			if (pread_items.length == 0) return null;
			return pread_items[0];
		}
		static function GetPreAdCustomMC(_parentMC:MovieClip = null):MovieClip
		{
			var adItem:AdItem = pread_items[0];
			if (adItem.urlLoaded == false)
			{
				return GetBlankMC();
			}
			
			var mc:MovieClip = adItem.loader.content as MovieClip;
			
			var fullScreen:Boolean = adItem.fullScreen;
			
			if (fullScreen && (_parentMC != null))
			{			
				
				mc.x = -_parentMC.x;
				mc.y = -_parentMC.y;
				
				var yGap:int = 45;
				
				var sw:Number = Defs.displayarea_w;
				var sh:Number = Defs.displayarea_h - (yGap*2);
				
				var adw:Number = 300;
				var adh:Number = 250;
				
				
				var dx:Number = sw / adw;
				var dy:Number = sh / adh;
				
				var r:Rectangle = mc.getBounds(null);

				
				if (dx > dy)
				{
					
					mc.scaleX = dy;
					mc.scaleY = dy;			
					
					mc.x += (sw - (adw * dy)) * 0.5;
					mc.y += yGap;
				}
				else
				{
					mc.scaleX = dx;
					mc.scaleY = dx;			
					//mc.x += (dy * (adw / 2));
					
				}
				

			}
			return mc;			
		}
		
		
		static function RemoveIntersitialMC()
		{
			if(ad != null)
			{	
				currentAd.removeChild(ad);
			}
			ad = null;
		}

		static function GetIntersitialMC():MovieClip
		{
			return GetIntersitialMC_CPMStar();
		}
		
		
		static function GetIntersitialMC_CPMStar():MovieClip
		{
			var clip:MovieClip;
			var id:String;
			var num:int = LicDef.CPMStarIntersitialsSpotIDs.length;
			if (num == 1)
			{
				id = LicDef.CPMStarIntersitialsSpotIDs[0];
			}
			if (num == 2)
			{
				var r:int = RandBetweenInt(0, 1000);
				if (r < 500)
				{
					id = LicDef.CPMStarIntersitialsSpotIDs[0];
				}
				else
				{
					id = LicDef.CPMStarIntersitialsSpotIDs[1];
				}
			}
			
			clip = new MovieClip();
			
			ad = new CPMStar.AdLoader(id);
			clip.addChild(ad);
			ad.x = 0;
			ad.y = 0;
			trace("showing intersitial ");
			return clip;
		}
		
		static var ad:DisplayObject;
		
		public static function RandBetweenInt(r0:int,r1:int):int
		{
			var r:int = Math.random() * ((r1-r0)+1);
			r += r0;
			return r;
		}

		public static function XML_GetAttrString(x:Object,defaultvalue:String = ""):String
		{
			var val:String = defaultvalue;
			if (x != undefined) val = String(x);
			return val;
		}
		public static function XML_GetAttrNumber(x:Object,defaultvalue:Number = 0):Number
		{
			var val:Number = defaultvalue;
			if (x != undefined) 
			{
				var s:String = String(x);
				val = Number(x);
			}
			return val;
		}
		
		public static function XML_GetAttrInt(x:Object, defaultvalue:int = 0):int
		{
			var val:int = defaultvalue;
			if (x != undefined) val = int(x);
			return val;
		}
		public static function XML_GetAttrBoolean(x:Object, defaultvalue:Boolean = false):Boolean
		{
			var val:Boolean = defaultvalue;
			if (x != null && x!=undefined) 
			{
				val = false;
				var s:String = String(x);
				s = s.toLowerCase();
				if (x == "true") val = true;
			}
			return val;
		}
		
		

// dummy functions:
	/*
		static function GetPrequelMC():MovieClip
		{
			return new MovieClip();			
		}
		static function GetCycloRacersMC():MovieClip
		{
			var mc:MovieClip = new MovieClip();
			return mc;
		}
		static function GetBlankMC():MovieClip
		{
			return new MovieClip();
		}
		static function RemoveCustomMC(parent:MovieClip)
		{
		}
		static function GetCustomMC():MovieClip
		{
			return new MovieClip();			
		}
		static function GetPreAdItem():AdItem
		{
			return null;
		}
		static function GetPreAdCustomMC(_parentMC:MovieClip = null):MovieClip
		{
			return new MovieClip();			
		}
		public static function GetAd():MovieClip
		{
			return new MovieClip();			
		}
		public static function RemoveAd(parent:MovieClip)
		{			
		}
		public static function PreAdClicked(e:MouseEvent)
		{			
		}
		public static function IsLoadedPreAdAvailable():Boolean
		{
			return false;
		}
*/
		
	}

}