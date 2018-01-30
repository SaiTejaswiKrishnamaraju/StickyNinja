package LicPackage 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class LicSku 
	{
		public var secondaryIntroFunction:Function;
		public var introFunction:Function;
		public var id:int;
		public var name:String;
		public var sitelocks:Array;
		public var blackList:Array;
		public var adtype:int;
		public var mainLogoName:String;
		public var mainLogoLinkURL:String;
		public var facebookLinkURL:String;
		public var mobileGamesLinkURL_Amazon:String;
		public var mobileGamesLinkURL_Android:String;
		public var mobileGamesLinkURL_iOS:String;
		public var twitterLinkURL:String;
		public var prequelLinkURL:String;
		public var prequel2LinkURL:String;
		public var scaleIntroToStage:Boolean;
		public var allowAuthorLink:Boolean;
		public var showMoreGamesButton:Boolean;
		public var initFunction:Function;
		public var allowIntersitialAd:Boolean;
		public var introName:String;
		public var introFPS:int;
		public var secondaryIntroName:String;
		public var secondaryIntroLinkURL:String;
		public var linkURL:String;
		public var walkthroughURL:String;
		public var playWithScoresURL:String;
		public var allowRemoteAdLoading:Boolean;
		public var allowOtherGames:Boolean;
		public var skipPreloaderContinueButton:Boolean;
		public var skipPreloader:Boolean;
		public var realSiteLock:Boolean;
		public var showDisclaimer:Boolean;
		public var downloadLinkURL:String;
		
		
		public function LicSku(_id:int,_name:String) 
		{
			id = _id;
			name = _name;
			introFunction = null;
			secondaryIntroFunction = null;
			sitelocks = new Array();
			blackList = new Array();
			adtype = 0;
			mainLogoName = "";
			facebookLinkURL = "";
			mobileGamesLinkURL_Amazon = "";
			mobileGamesLinkURL_Android = "";
			mobileGamesLinkURL_iOS = "";
			twitterLinkURL = "";
			prequelLinkURL = "";
			prequel2LinkURL = "";
			scaleIntroToStage = false;
			allowAuthorLink = true;
			showMoreGamesButton = true;
			initFunction = null;
			allowIntersitialAd = false;
			introName = "";
			secondaryIntroName = "";
			secondaryIntroLinkURL = "";
			linkURL = "";
			walkthroughURL = "";
			playWithScoresURL = "";
			mainLogoLinkURL = "";
			allowRemoteAdLoading = true;
			allowOtherGames = false;
			introFPS = Defs.fps;
			skipPreloaderContinueButton = false;
			skipPreloader = false;
			realSiteLock = false;
			downloadLinkURL = "";
			showDisclaimer = true;
		}
		
		public function AddSiteLock(s:String,fullDomain:Boolean = false):void
		{
			sitelocks.push(s);
		}
		public function AddBlackList(s:String,fullDomain:Boolean = false):void
		{
			blackList.push(s);
		}
		
	}
	
}