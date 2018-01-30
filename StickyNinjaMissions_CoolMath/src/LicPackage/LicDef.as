package LicPackage
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Julian
	 */
	public class LicDef 
	{
		
		public static const LICENSOR_DEVELOPMENT:int = 0;
		public static const LICENSOR_NOBRANDING:int = 1;
		public static const LICENSOR_LONGANIMALS:int = 2;
		public static const LICENSOR_LONGANIMALS_SITELOCKED:int = 3;
		public static const LICENSOR_ROBOTJAM:int = 4;
		public static const LICENSOR_TURBONUKE:int = 5;
		public static const LICENSOR_KONGREGATE:int = 6;
		public static const LICENSOR_KONGREGATE_ONSITE:int = 7;
		public static const LICENSOR_ANDKON:int = 8;
		public static const LICENSOR_ARMORGAMES:int = 9;
		public static const LICENSOR_ARMORGAMES_VIRAL:int = 10;
		public static const LICENSOR_MOUSEBREAKER:int = 11;
		public static const LICENSOR_ADDICTINGGAMES:int = 12;
		public static const LICENSOR_COOLIFIED:int = 13;
		public static const LICENSOR_YEPI:int = 14;
		public static const LICENSOR_PANDAZONE:int = 15;
		public static const LICENSOR_MOBILE:int = 16;
		public static const LICENSOR_KIZI:int = 17;
		public static const LICENSOR_OUYA:int = 18;
		public static const LICENSOR_ADDICTINGGAMES_TURBONUKE:int = 19;
		public static const LICENSOR_PRUMPA:int = 20;
		public static const LICENSOR_KIZ10:int = 21;
		public static const LICENSOR_COOLMATH:int = 22;
				
		public static const ADTYPE_NONE:int = 0;
		public static const ADTYPE_MOCHI:int = 1;
		public static const ADTYPE_MOCHI_VC:int = 2;
		public static const ADTYPE_CPMSTAR:int = 3;
		public static const ADTYPE_EPICGAMEADS:int = 4;

		public static var MochiAdID:String = "c8c77dd8a072e231";
		public static var MochiAdRes:String = "800x512";
		
		// Change this line to change the primary sponosor
//		public static var primary_sponsor:int = LICENSOR_KONGREGATE;
//		public static var primary_sponsor:int = LICENSOR_TURBONUKE;
//		public static var primary_sponsor:int = LICENSOR_PRUMPA;
		public static var primary_sponsor:int = LICENSOR_COOLMATH;
		
		// Change this line to change the current licensor
//		public static var licensor:int = LICENSOR_TURBONUKE;
//		public static var licensor:int = LICENSOR_PRUMPA;
//		public static var licensor:int = LICENSOR_ADDICTINGGAMES_TURBONUKE;
//		public static var licensor:int = LICENSOR_DEVELOPMENT;
//		public static var licensor:int = LICENSOR_KONGREGATE;
//		public static var licensor:int = LICENSOR_KONGREGATE_ONSITE;
//		public static var licensor:int = LICENSOR_MOUSEBREAKER;
//		public static var licensor:int = LICENSOR_ARMORGAMES;
//		public static var licensor:int = LICENSOR_ANDKON;
//		public static var licensor:int = LICENSOR_COOLIFIED;
//		public static var licensor:int = LICENSOR_YEPI;
//		public static var licensor:int = LICENSOR_ADDICTINGGAMES;
//		public static var licensor:int = LICENSOR_PANDAZONE;
//		public static var licensor:int = LICENSOR_KIZ10;
//		public static var licensor:int = LICENSOR_KIZI;
		public static var licensor:int = LICENSOR_COOLMATH;

		if (PROJECT::useStage3D)
		{
			licensor = LICENSOR_MOBILE;
			primary_sponsor = LICENSOR_MOBILE;
			
			if (PROJECT::isGamePad)
			{
				licensor = LICENSOR_OUYA;
				primary_sponsor = LICENSOR_OUYA;
			}
		}
		
		static var AD_URL:String = "http://www.turboadserver.com/Ads_StickyNinjaMissions.php";
		
		public static var armorHighScore_devKey:String = "57e6ffa35f343197fbd276da0a94ccbb";
		public static var armorHighScore_gameKey:String = "basketballs-level-pack";
		
		public static var mouseBreaker_hiscore_url:String = "http://www.mousebreaker.com/games/supercarparking/highscores_supercarparking.php";
		
		public static var newgrounds_id0:String = "21399:JE19X8KX";
		public static var newgrounds_id1:String = "cZ5A6UCtOgci9gls5AFEw2b3RbqbY2lw";
			

	
		public static var referralName:String = "stickyninjamissions";
		public static var referralString:String = "?haref=stickyninjamissions&src=spon&cm=stickyninjamissions";
		public static var referralStringAnd:String = "&haref=stickyninjamissions&src=spon&cm=stickyninjamissions";
		
		
		public static var authorLinks:Array = new Array();
		authorLinks.push("http://www.turbonuke.com");

		public static var CPMStarContentSpotIDs:Array = new Array();
		public static var CPMStarIntersitialsSpotIDs:Array = new Array();
		CPMStarContentSpotIDs.push(String("12026Q8F72DDD9"));		// LongAnimals (correct for StickyNinjaMissions)
		CPMStarContentSpotIDs.push(String("12028QCCB32869"));		// Asute (correct for StickyNinjaMissions)
		public static var CPMStarFixedTime:int = 6;
		
		public static var localTest:Boolean = true;
		public static var testAddictingGames:Boolean = false;
		
		public static var domain:String;
		public static var stg:MovieClip;
		public static var kongregateEmbedFlag:Boolean = true;
		
		public function LicDef() 
		{
			
		}

		public static function GetCurrentSku():LicSku
		{
			return GetSku(licensor);
		}
		
		public static function GetSku(skuID:int):LicSku
		{
			for each(var sku:LicSku in skus)
			{
				if (sku.id == skuID) return sku;
			}
			trace("GetSku invalid SKU: "+skuID);
			return null;
		}
		
		static function IsOnCorrectSite():Boolean
		{
			if (PROJECT::useStage3D)
			{
				return true;
			}
			if (localTest == true) return true;
			var sku:LicSku = GetSku(licensor);
			if (sku.sitelocks.length == 0) return true;
			for each(var s:String in sku.sitelocks)
			{
				if (s == domain) return true;
			}
			return false;			
		}
		
		public static function GetLicensor():int
		{
			return licensor;
		}
		
		public static function InitFromPreloader(_stg:MovieClip)
		{
			InitSkus();
			stg = _stg;
			domain = GetDomain();
			kongregateEmbedFlag = stg.stage.loaderInfo.parameters.kongregate;		

			SkuModify();
			
		}
		
		
		public static function GetStage():MovieClip
		{
			return stg;
		}
		public static function GetDomain():String
		{
			var url:String = stg.loaderInfo.url;//this is the magic _url successor			
			var urlStart:Number = url.indexOf("://")+3;
			var urlEnd:Number = url.indexOf("/", urlStart);
			var dom:String = url.substring(urlStart, urlEnd);
			var LastDot:Number = dom.lastIndexOf(".")-1;
			var domEnd:Number = dom.lastIndexOf(".", LastDot)+1;
			dom = dom.substring(domEnd, dom.length);
			return dom;
		}

		public static function IsAtAddictingGames():Boolean
		{
			if (testAddictingGames) domain = "addictinggames.com";
			return (domain == "addictinggames.com");
		}
		
		static function SkuModify():void
		{
			if (LicDef.localTest == true) return;

			if (licensor == LICENSOR_KONGREGATE && IsAtKongregate())
			{
				licensor = LICENSOR_KONGREGATE_ONSITE;
			}
			
			if (IsAtAddictingGames())
			{
				licensor = LICENSOR_ADDICTINGGAMES_TURBONUKE;
			}
			
			if (IsOnCorrectSite() == false)
			{
				licensor = primary_sponsor;
			}

			
			if (PROJECT::useStage3D == false)
			{
				if (GetCurrentSku().realSiteLock)
				{
					if (GetDomain() != "kongregate.com" && GetDomain() != "turbonuke.com")
					{
						do { } while (1);
					}
				}
			}
			

		}
		
		public static function AreOtherGamesAdsAllowed():Boolean
		{
//			if (PROJECT::useStage3D)
//			{
//				return false;
//			}
			if (IsAtKiba()) return false;
			return GetCurrentSku().allowOtherGames;
		}
		
		public static function IsRemoteAdLoadingAllowed():Boolean
		{
			return GetCurrentSku().allowRemoteAdLoading;
		}
		
		public static function IsAtKongregate():Boolean
		{
			if (domain == "kongregate.com" && kongregateEmbedFlag) return true;
			return false;
		}
		
		public static function IsAtKiba():Boolean
		{
			return LicAds.IsAtKiba();
		}
		
		
		static var skus:Array;
		
		public static function InitSkus():void
		{
			skus = new Array();
			var sku:LicSku;
		
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_KIZ10, "Kiz10");
			sku.introName = "Intro_Kiz10";
			sku.introFPS = 30;
			sku.mainLogoName = "kiz10";
			sku.linkURL = "http://kiz10.com";
			sku.AddSiteLock("kiz10.com");
			sku.AddSiteLock("turbonuke.com");
			sku.allowAuthorLink = true;
			sku.allowRemoteAdLoading = false; 
			sku.mobileGamesLinkURL_Amazon = "";
			sku.mobileGamesLinkURL_Android = "";
			sku.mobileGamesLinkURL_iOS = "";
			sku.showDisclaimer = false;
			skus.push(sku);
			
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_DEVELOPMENT, "Development");
			sku.AddSiteLock("longanimalsgames.com");
			sku.AddSiteLock("flashgamelicense.com");
			sku.AddSiteLock("turbonuke.com");
			sku.AddSiteLock("");
			
//			sku.adtype = ADTYPE_CPMSTAR;
//			sku.allowIntersitialAd = true;

			sku.allowOtherGames = true;
			sku.showMoreGamesButton = true;
//			sku.allowRemoteAdLoading = true;
			sku.skipPreloaderContinueButton = true;
			skus.push(sku);
			
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_ADDICTINGGAMES_TURBONUKE, "Addicting Games And Turbonuke");
			sku.AddSiteLock("addictinggames.com");
			sku.allowOtherGames = true;
			sku.showMoreGamesButton = true;
			sku.allowRemoteAdLoading = true;
			sku.skipPreloaderContinueButton = true;
			sku.skipPreloader = true;
			sku.facebookLinkURL = "http://www.facebook.com/TurbonukeGames";			
			sku.twitterLinkURL = "https://twitter.com/turbonuke";			
			sku.linkURL = "http://www.turbonuke.com";
			sku.mainLogoName = "turbonuke";
			sku.downloadLinkURL = "http://www.turbonuke.com/addgame.php";
			sku.mobileGamesLinkURL_Android = "https://play.google.com/store/apps/details?id=air.com.turbonuke.grandtruckismo&hl=en";
			sku.mobileGamesLinkURL_iOS = "https://itunes.apple.com/us/app/grand-truckismo/id725299285?ls=1";
			sku.mobileGamesLinkURL_Amazon = "http://www.amazon.co.uk/TurboNuke-Ltd-Grand-Truckismo/dp/B00FXSWOTY";
			
			sku.introFPS = 24;
			sku.introName = "Intro_AddictingGames";
			sku.secondaryIntroName = "Intro_TurboNuke";
			sku.secondaryIntroLinkURL = "http://www.addictinggames.com";
			sku.skipPreloader = false;
			skus.push(sku);
			
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_PANDAZONE, "PandaZone");
			sku.AddSiteLock("longanimalsgames.com");
			sku.AddSiteLock("pandazone.com");
			sku.showMoreGamesButton = false;
			sku.mainLogoName = "pandazone";
			sku.linkURL = "http://www.pandazone.com";
			sku.allowAuthorLink = false;
			skus.push(sku);

//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_KIZI, "Kizi Sitelock");
			sku.AddSiteLock("kizi.com");
			sku.skipPreloaderContinueButton = true;
			sku.allowAuthorLink = false;
			sku.showDisclaimer = false;
			
			skus.push(sku);

//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_COOLMATH, "Coolmath Sitelock");
			sku.AddSiteLock("coolmath-games.com");
			sku.AddSiteLock("longanimals.com");
			sku.AddSiteLock("longanimalsgames.com");
			sku.skipPreloaderContinueButton = true;
			sku.allowAuthorLink = false;
			sku.showDisclaimer = false;
			sku.allowOtherGames = false;
			sku.allowRemoteAdLoading = false;
			
			skus.push(sku);
			
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_MOBILE, "Mobile");
			
			// mobile.
			sku.allowOtherGames = false;
			sku.showMoreGamesButton = true;
			sku.allowRemoteAdLoading = false;
			sku.skipPreloaderContinueButton = true;
			sku.skipPreloader = false;
			
			sku.facebookLinkURL = "http://www.facebook.com/TurbonukeGames";			
			sku.twitterLinkURL = "https://twitter.com/turbonuke";			
			sku.linkURL = "http://www.turbonuke.com";
			sku.mainLogoName = "turbonuke";
			sku.downloadLinkURL = "http://www.turbonuke.com/addgame.php";
			sku.showDisclaimer = false;
			
			sku.allowOtherGames = true;
			sku.allowRemoteAdLoading = true;
			
			if (Game.isWildTangent)
			{
				sku.allowOtherGames = false;
				sku.allowRemoteAdLoading = false;
				sku.downloadLinkURL = "";
				sku.facebookLinkURL = "";			
				sku.twitterLinkURL = "";			
				sku.linkURL = "";
			}
			
			skus.push(sku);

//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_OUYA, "Ouya");
			
			// mobile.
			sku.allowOtherGames = false;
			sku.showMoreGamesButton = false;
			sku.allowRemoteAdLoading = false;
			sku.skipPreloaderContinueButton = true;
			sku.skipPreloader = false;
			
			sku.facebookLinkURL = "";	// http://www.facebook.com/TurbonukeGames";			
			sku.twitterLinkURL = "";	// https://twitter.com/turbonuke";			
			sku.linkURL = "";
			sku.mainLogoName = "turbonuke";
			sku.downloadLinkURL = "";
			sku.showDisclaimer = false;
			
			skus.push(sku);
			
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_TURBONUKE, "TurboNUKE");
			
			// mobile.
			sku.allowOtherGames = true;
			sku.showMoreGamesButton = true;
			sku.allowRemoteAdLoading = true;
			sku.skipPreloaderContinueButton = true;
			sku.skipPreloader = true;
			sku.facebookLinkURL = "http://www.facebook.com/TurbonukeGames";			
			sku.twitterLinkURL = "https://twitter.com/turbonuke";			
			sku.linkURL = "http://www.turbonuke.com";
			sku.mainLogoName = "turbonuke";
			sku.downloadLinkURL = "http://www.turbonuke.com/addgame.php";
			sku.mobileGamesLinkURL_Android = "https://play.google.com/store/apps/details?id=air.com.turbonuke.grandtruckismo&hl=en";
			sku.mobileGamesLinkURL_iOS = "https://itunes.apple.com/us/app/grand-truckismo/id725299285?ls=1";
			sku.mobileGamesLinkURL_Amazon = "http://www.amazon.co.uk/TurboNuke-Ltd-Grand-Truckismo/dp/B00FXSWOTY";
			
			if (false)	//Game.usedebug == false)
			{
				sku.introName = "Intro_TurboNuke";
				sku.adtype = ADTYPE_CPMSTAR;
				//sku.adtype = ADTYPE_MOCHI;
				sku.skipPreloaderContinueButton = false;
				sku.skipPreloader = false;
			}

			/*
//			sku.AddSiteLock("turbonuke.com");
			sku.mainLogoName = "turbonuke";
			sku.prequelLinkURL = "http://www.turbonuke.com/games.php?game=basketballs";
//			sku.adtype = ADTYPE_NONE;
//			sku.adtype = ADTYPE_CPMSTAR;
//			sku.adtype = ADTYPE_MOCHI;

			sku.downloadLinkURL = "http://www.turbonuke.com/addgame.php";

			sku.allowRemoteAdLoading = true;			
			
			sku.allowOtherGames = true;
			sku.allowAuthorLink = false;
			
			sku.walkthroughURL = "http://www.turbonuke.com/walkthrough.php?game=soccerballs2levelpack";
			sku.prequelLinkURL = "http://www.turbonuke.com/games.php?game=Cyclomaniacs";
			sku.prequel2LinkURL = "http://www.turbonuke.com/games.php?game=cyclomaniacs2";
			
			
			sku.skipPreloaderContinueButton = true;
			*/
			skus.push(sku);
			
//------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_PRUMPA, "Prumpa");
			
			// mobile.
			sku.allowOtherGames = true;
			sku.showMoreGamesButton = true;
			sku.allowRemoteAdLoading = true;
			sku.skipPreloaderContinueButton = true;
			sku.skipPreloader = true;
			sku.facebookLinkURL = "http://www.facebook.com/PrumpaGames";			
			sku.twitterLinkURL = "https://twitter.com/PrumpaGames";			
			sku.linkURL = "http://www.prumpa.com";
			sku.mainLogoName = "prumpa";
			sku.downloadLinkURL = "http://www.turbonuke.com/addgame.php";
			sku.mobileGamesLinkURL_Android = "https://play.google.com/store/apps/details?id=air.com.turbonuke.grandtruckismo&hl=en";
			sku.mobileGamesLinkURL_iOS = "https://itunes.apple.com/us/app/grand-truckismo/id725299285?ls=1";
			sku.mobileGamesLinkURL_Amazon = "http://www.amazon.co.uk/TurboNuke-Ltd-Grand-Truckismo/dp/B00FXSWOTY";
			
			if (false)	//Game.usedebug == false)
			{
				sku.introName = "Intro_Prumpa";
				sku.adtype = ADTYPE_CPMSTAR;
				//sku.adtype = ADTYPE_MOCHI;
				sku.skipPreloaderContinueButton = false;
				sku.skipPreloader = false;
			}

			skus.push(sku);
			
//------------------------------------------------------------------------------------------------------------------------
			
			sku = new LicSku(LICENSOR_KONGREGATE, "Kongregate");

//			sku.AddSiteLock("kongregate.com");
			sku.introName = "Intro_Kongregate";
			sku.mainLogoName = "kongregate";
			sku.linkURL = "http://www.kongregate.com";
			sku.prequelLinkURL = "http://www.turbonuke.com/games.php?game=basketballs";
//			sku.adtype = ADTYPE_NONE;
			sku.adtype = ADTYPE_CPMSTAR;

			sku.downloadLinkURL = "http://www.kongregate.com/games_for_your_site";
			sku.facebookLinkURL = "http://www.facebook.com/Kongregate";			

			sku.allowRemoteAdLoading = true;	
			sku.skipPreloaderContinueButton = false;
			
			sku.allowOtherGames = true;
			sku.allowAuthorLink = false;
			
			sku.walkthroughURL = "http://www.turbonuke.com/Cyclomaniacs-Epic-Walkthrough.php";
			sku.prequelLinkURL = "http://www.turbonuke.com/games.php?game=Cyclomaniacs";
			sku.prequel2LinkURL = "http://www.turbonuke.com/games.php?game=cyclomaniacs2";
			
			
			if (true)	//Game.usedebug)
			{
				sku.adtype = ADTYPE_NONE;
				sku.introName = "";
			}
			
			skus.push(sku);
			
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_KONGREGATE_ONSITE, "Kongregate OnSite");
			
//			sku.AddSiteLock("turbonuke.com");
			sku.introName = "Intro_Kongregate";
			sku.mainLogoName = "kongregate";
			sku.linkURL = "http://www.kongregate.com";
			sku.prequelLinkURL = "http://www.turbonuke.com/games.php?game=basketballs";
			sku.adtype = ADTYPE_NONE;
//			sku.adtype = ADTYPE_CPMSTAR;

			sku.downloadLinkURL = "http://www.kongregate.com/games_for_your_site";
			sku.facebookLinkURL = "http://www.facebook.com/Kongregate";			

			sku.allowRemoteAdLoading = true;			
			
			sku.allowOtherGames = true;
			sku.allowAuthorLink = false;
			
			sku.walkthroughURL = "http://www.turbonuke.com/Cyclomaniacs-Epic-Walkthrough.php";
			sku.prequelLinkURL = "http://www.turbonuke.com/games.php?game=Cyclomaniacs";
			sku.prequel2LinkURL = "http://www.turbonuke.com/games.php?game=cyclomaniacs2";
			
			sku.realSiteLock = false;
			sku.skipPreloaderContinueButton = true;
			
			skus.push(sku);
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_ANDKON, "Andkon");
			sku.AddSiteLock("andkon.com");
			sku.introName = "Intro_Andkon";
			sku.mainLogoName = "andkon";
			sku.linkURL = "http://www.andkon.com/arcade/";
			sku.walkthroughURL = "walkthrough.html";
			sku.allowAuthorLink = false;
			sku.allowRemoteAdLoading = false;
			sku.allowOtherGames = false;
			sku.allowIntersitialAd = false;
			skus.push(sku);
			
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_ARMORGAMES, "Armor Games");
			sku.AddSiteLock("armorgames.com");
			sku.AddSiteLock("longanimalsgames.com");
			sku.introName = "Intro_ArmorGames";
			sku.adtype = ADTYPE_NONE;
			sku.mainLogoName = "armorGames";
			sku.linkURL = "http://armor.ag/MoreGames";
			sku.facebookLinkURL = "http://plus.google.com/u/0/104425856972539712808/posts";
//			sku.prequelLinkURL = "http://armorgames.com/play/12442/formularacer";
			sku.allowAuthorLink = true;
			sku.skipPreloaderContinueButton = true;
			skus.push(sku);
			
//------------------------------------------------------------------------------------------------------------------------

			sku = new LicSku(LICENSOR_YEPI, "Yepi");
			sku.AddSiteLock("twizl.com");
			sku.AddSiteLock("yepi.com");
			sku.AddSiteLock("bgames.com");
			sku.AddSiteLock("fishflashgames.com");
			sku.mainLogoName = "yepi";
			sku.introName = "Intro_Yepi";
			sku.adtype = ADTYPE_NONE;
			sku.allowAuthorLink = false;
			skus.push(sku);


//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_COOLIFIED, "Coolified");
			sku.AddSiteLock("coolifiedgames.com");
			sku.AddSiteLock("longanimalsgames.com");
			sku.introName = "Intro_Coolified";
			sku.adtype = ADTYPE_NONE;
			sku.allowAuthorLink = false;
			skus.push(sku);
			
//------------------------------------------------------------------------------------------------------------------------
			
			sku = new LicSku(LICENSOR_NOBRANDING, "No branding");
			skus.push(sku);
//------------------------------------------------------------------------------------------------------------------------
			// Intro, main logo, no links, no ads
			sku = new LicSku(LICENSOR_MOUSEBREAKER, "MouseBreaker");
			sku.AddSiteLock("mousebreaker.com");
			sku.mainLogoName = "mousebreaker";
			sku.showMoreGamesButton = false;
			sku.introName = "Intro_MouseBreaker";
			sku.allowAuthorLink = false;
//			sku.walkthroughURL = "http://www.mousebreaker.com/games/basketballslevelpackwalkthrough/playgame";
//			sku.walkthroughURL = "http://www.mousebreaker.com/games/redcardrampage2walkthrough/playgame";
//			sku.prequelLinkURL = "http://www.mousebreaker.com/games/redcardrampage";
			
			sku.introFPS = 30;
			
			skus.push(sku);
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_ADDICTINGGAMES, "Addicting Games");
			sku.introName = "Intro_AddictingGames";
			sku.mainLogoName = "addictingGames";
			sku.linkURL = "http://www.addictinggames.com";
			sku.AddSiteLock("addictinggames.com");
			skus.push(sku);
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_LONGANIMALS, "LongAnimals");
			sku.adtype = ADTYPE_CPMSTAR;
			sku.mainLogoName = "longAnimals";
			sku.linkURL = "http://www.longanimalsgames.com";
			skus.push(sku);
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_LONGANIMALS_SITELOCKED, "LongAnimalsSitelocked");
			sku.AddSiteLock("longanimalsgames.com");
			sku.AddSiteLock("longanimals.com");
//			sku.adtype = ADTYPE_CPMSTAR;
			sku.mainLogoName = "longAnimals";
			sku.linkURL = "http://www.longanimalsgames.com";
			skus.push(sku);
//------------------------------------------------------------------------------------------------------------------------
			sku = new LicSku(LICENSOR_ROBOTJAM, "RobotJam");
			sku.AddSiteLock("robotjam.com");
			sku.AddSiteLock("robotjamgames.com");
			sku.introName = "Intro_RobotJam";
			sku.scaleIntroToStage = true;
			sku.mainLogoName = "robotJam";
			sku.linkURL = "http://www.robotjamgames.com";
			sku.adtype = ADTYPE_CPMSTAR;
			skus.push(sku);
//------------------------------------------------------------------------------------------------------------------------
		}
		
		
	}

}