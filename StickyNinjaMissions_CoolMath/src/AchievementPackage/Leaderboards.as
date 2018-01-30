package AchievementPackage
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import MobileSpecificPackage.MobileSpecific;
	/**
	 * ...
	 * @author 
	 */
	public class Leaderboards 
	{
		
		static var SCOREOID_API_KEY:String = "e00473a0ba1168b5993e5b8a1292759abb8408c5";
		static var SCOREOID_GAME_ID:String = "0107549712";	// grand truckismo
		
		
		public function Leaderboards() 
		{
			
		}
		
		
		public static function SubmitScore(score:int, name:String)
		{
			//PostScore_SCOREOID(score, name);
			
//			MobileSpecific.GooglePlaySubmitScore(score, name);
			
		}

		static var GetTopScores_CB:Function = null;
		public static function GetTopScores(cb:Function)
		{
			GetTopScores_CB = cb;
			GetTopScores_SCOREOID();
		}
		
		static var GetTopScore_CB:Function = null;
		public static function GetTopScore(cb:Function)
		{
			GetTopScore_CB = cb;
			GetTopScore_SCOREOID();
		}
		
		
		static function PostScore_SCOREOID(score:int, name:String)
		{
			trace("PostScore_SCOREOID " + score + " " + name);
			var url:String="https://www.scoreoid.com/api/createScore";
            var request:URLRequest=new URLRequest(url);
            var requestVars:URLVariables = new URLVariables();
            request.data=requestVars;
            requestVars.api_key = SCOREOID_API_KEY;
            requestVars.game_id = SCOREOID_GAME_ID;
            requestVars.response="JSON";
            requestVars.username = name;
            requestVars.score=score;
            request.method=URLRequestMethod.POST;
            var urlLoader:URLLoader = new URLLoader();
            urlLoader = new URLLoader();
            urlLoader.dataFormat=URLLoaderDataFormat.TEXT;
            urlLoader.addEventListener(Event.COMPLETE, ScorePosted_SCOREOID);
            urlLoader.load(request);
		}
		
		static function ScorePosted_SCOREOID(event:Event):void 
		{
			trace("ScorePosted_SCOREOID");
			var response:XML = new XML(event.target.data);
			trace(response);
			GetTopScores(null);
		}
		
		
		static function GetTopScores_SCOREOID()
		{
			trace("GetTopScores_SCOREOID");
			 var url:String="https://www.scoreoid.com/api/getBestScores";
            var request:URLRequest=new URLRequest(url);
            var requestVars:URLVariables = new URLVariables();
            request.data=requestVars;
            requestVars.api_key = SCOREOID_API_KEY;
            requestVars.game_id = SCOREOID_GAME_ID;
            requestVars.response="JSON";
            requestVars.order_by="score";
            requestVars.order="desc";
            requestVars.limit="20";
            request.method=URLRequestMethod.POST;
            var urlLoader:URLLoader = new URLLoader();
            urlLoader = new URLLoader();
            urlLoader.dataFormat=URLLoaderDataFormat.TEXT;
            urlLoader.addEventListener(Event.COMPLETE, GetTopScoresCB_SCOREOID);
            urlLoader.load(request);
		}
		
		static function GetTopScoresCB_SCOREOID(event:Event):void 
		{
			trace("GetTopScoresCB_SCOREOID");
			var o:Object = JSON.parse(event.target.data);
			trace(o);
			if (GetTopScores_CB != null)
			{
				GetTopScores_CB(o);
			}
		}

		
		static function GetTopScore_SCOREOID()
		{
			trace("GetTopScores_SCOREOID");
			 var url:String="https://www.scoreoid.com/api/getBestScores";
            var request:URLRequest=new URLRequest(url);
            var requestVars:URLVariables = new URLVariables();
            request.data=requestVars;
            requestVars.api_key = SCOREOID_API_KEY;
            requestVars.game_id = SCOREOID_GAME_ID;
            requestVars.response="JSON";
            requestVars.order_by="score";
            requestVars.order="desc";
            requestVars.limit="1";
            request.method=URLRequestMethod.POST;
            var urlLoader:URLLoader = new URLLoader();
            urlLoader = new URLLoader();
            urlLoader.dataFormat=URLLoaderDataFormat.TEXT;
            urlLoader.addEventListener(Event.COMPLETE, GetTopScoreCB_SCOREOID);
            urlLoader.load(request);
		}
		
		static function GetTopScoreCB_SCOREOID(event:Event):void 
		{
			trace("GetTopScoreCB_SCOREOID");
			var o:Object = JSON.parse(event.target.data);
			trace(o);
			
			if (GetTopScore_CB != null)
			{
				GetTopScore_CB(o);
			}
		}
		
	}

}