package LicPackage 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Julian
	 */
	public class AdItem 
	{
		public var name:String;
		public var type:String;
		public var url:String;
		public var url_mobile_google:String;
		public var url_mobile_ios:String;
		public var url_mobile_amazon:String;
		public var original_url:String;
		public var swfurl:String;
		public var swfurl_mobile_google:String;
		public var swfurl_mobile_ios:String;
		public var swfurl_mobile_amazon:String;
		public var adtype1:String;
		public var adtype2:String;
		public var active:Boolean;
		public var customAd:MovieClip;
		public var urlLoaded:Boolean;
		public var loader:Loader;
		public var fullScreen:Boolean;
		
		function CompareSwfUrlWith(adItem:AdItem):Boolean
		{
			if (swfurl != adItem.swfurl) return false;
			return true;
		}
		
		public function AdItem(_name:String,_type:String,_url:String,_swfurl:String) 
		{
			name = _name;
			type = _type;
			url = _url;
			original_url = url;
			swfurl = _swfurl;
			active = true;
			customAd = null;
			urlLoaded = false;
			loader = null;
			fullScreen = false;
			
			adtype1 = "";
			adtype2 = "";
			swfurl_mobile_google = "";
			swfurl_mobile_ios = "";
			swfurl_mobile_amazon = "";
			url_mobile_google = "";
			url_mobile_ios = "";
			url_mobile_amazon = "";
		}
		
		
		
	}

}