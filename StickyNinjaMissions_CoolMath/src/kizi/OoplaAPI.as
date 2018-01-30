package kizi 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class KiziAPI
	{		
		public static const apiVersion:Number = 0.131;
		public static var ApiSwfUrl:String = "http://kizi.com/api/ooplaAPI.swf";
		public static var ApiGateway:String;
		public static var api:Object;
		public static var gameState:KiziGameState;
		public static var  vault:KiziVault
		private static var apiLoader:Loader;
		private static var loaderTimeout:Timer;
		private static var authtoken:String;
		private static var gid:String;
		private static var _stage:DisplayObjectContainer;
		private static var loaderInfo:LoaderInfo;

		/**
		 * Manually sets the API context to a specific game/user. Useful while developing a game.
		 * @param	gameID - A unique game id as provided to you by Kizi
		 * @param	userID - Your development mode user, as provided to you by Kizi
		 */
		public static function setContext(gameID:String, userAuthToken:String):void
		{
			authtoken = userAuthToken;
			gid = gameID;
		}
		
		public static function connect(stage:Stage, loaderInfo_:LoaderInfo, logLevel:int=0):void
		{
			Security.allowDomain("*");
            Security.allowInsecureDomain("*");
			
			loaderInfo = loaderInfo_;
			
			// override api swf url from the loader  (if provided)
			if (loaderInfo.parameters.apiSwfUrl != undefined)
				ApiSwfUrl = loaderInfo.parameters.apiSwfUrl;
						
			api = null;
			_stage = stage;			
			gameState = new KiziGameState();
			vault = new KiziVault();
			KiziLogger.logLevel = logLevel;	

			
			if (loaderInfo.url != null && loaderInfo.url.slice(0, 4) == "file")
			{
				KiziLogger.debug("Running in development mode, adding a cache busting string to the API swf");
				KiziAPI.ApiSwfUrl += "?" + Math.random();
			}
			
			KiziLogger.debug("API client version:", apiVersion);
			KiziLogger.debug("API load started from", ApiSwfUrl);
			
			var request:URLRequest = new URLRequest(ApiSwfUrl);
			apiLoader = new Loader();
			apiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			apiLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			apiLoader.load(request);
			
			loaderTimeout = new Timer(20000, 1);
			loaderTimeout.addEventListener(TimerEvent.TIMER, loadTimedOut);
			loaderTimeout.start();
		}	
		
		static private function loadTimedOut(e:TimerEvent):void 
		{
			KiziLogger.error("API loading has timed out");
			apiLoader.close();
		}
		
		static private function loadComplete(e:Event):void 
		{
			loaderTimeout.stop();
			KiziLogger.debug("API swf loaded succesfully");
			api = e.target.content;
			KiziLogger.debug("API initialiation started, loader info " + loaderInfo.url);
			api.init(_stage, loaderInfo, KiziLogger.logLevel, apiVersion, authtoken, gid, ApiGateway,loaderInfo.url);
		}
		
	    public static function get apiLoaded():Boolean
		{
			return (api != null && api.apiReady)
		}
		
		public static function get showingOverlay():Boolean
		{
			return (api != null && api.showingOverlay)
		}
		
		private static function errorHandler(e:Event):void 
		{
			KiziLogger.error("Error caught:", e);
		}
		
		public static function getCoinIcon():MovieClip
		{
			if (KiziAPI.apiLoaded)
				return KiziAPI.api.getCoinIcon();
			else
				return new MovieClip();
		}
		
		public static function showGetCoinsDialog():void 
		{
			if (KiziAPI.apiLoaded)
				KiziAPI.api.showGetCoinsDialog();
		}
		
		public static function reloadPage():void
		{
			if (KiziAPI.apiLoaded)
				KiziAPI.api.reloadPage();
		}
	}
}