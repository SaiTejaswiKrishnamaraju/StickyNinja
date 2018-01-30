package LicPackage 
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import flash.display.Stage;
	/**
	 * ...
	 * @author 
	 */
	public class Tracking 
	{
		static var doDebug:Boolean = false;
		
		public function Tracking() 
		{
			
		}
		
		public static var tracker:AnalyticsTracker;

		
		public static function IsActive():Boolean
		{
			if (LicDef.GetLicensor() == LicDef.LICENSOR_MOBILE) return true;
			if (LicDef.GetLicensor() == LicDef.LICENSOR_TURBONUKE) return true;
			if (LicDef.GetLicensor() == LicDef.LICENSOR_PRUMPA) return true;
			if (LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE) return true;
			if (LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE) return true;
			return false;
		}
		
		
		public static function InitOnce(_stage:Stage)
		{
			if (IsActive() == false) return;
			tracker = new GATracker(_stage, "UA-6083322-13", "AS3", doDebug);
			tracker.trackEvent("seed", Game.seed);
		}
		
		public static function Event(category:String, action:String, label:String=null, value:Number=NaN)
		{
			if (IsActive() == false) return;
			if (tracker == null) return;
			tracker.trackEvent(category, action, label, value);		
		}
		public static function LogLink(_url:String,_fromPage:String,_name1:String)	// _fromPage:String="undefined",_name1:String="undefined1")
		{
			if (IsActive() == false) return;
			if (tracker == null) return;
//			trace("tracking " + _url + " / " + _fromPage+ " / "+_name1);
			tracker.trackEvent("link", _fromPage, _name1);		
		}
		public static function LogView()
		{
			if (IsActive() == false) return;
			if (tracker == null) return;
			//tracker.trackPageview("/view");
		}
		public static function LogPage(pageName:String)
		{
			if (IsActive() == false) return;
			if (tracker == null) return;
//			trace("page " + pageName);
			tracker.trackPageview("/" + pageName);
		}
		
		
		
	}

}