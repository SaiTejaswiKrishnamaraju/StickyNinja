

// MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkrvWLBh9QggR9rJuhYdOrxxCEdFqxF13XbjK+3At58RN7OhvOy2c9X6Jv3NTqs086/uiZ+1bNZntvwA2SHNMooM4f6Roj+5GAS14c53pePFi+Tf9UHNHMFOE5U5pXmsTPjR/JqXXGMIZcByxZFaM35YRym03vfitjEjXJrPpcBLSwU10DQ1hG+1ZWUy6/BGSKHQD386QFXFOvuDkaSvGtze7bgxpb16HUJkRr1Y51rl6nHvkEzI3dASNYUcoLKae9UtuIE6WPzHj/4xM3cU9sSXi8JRIMWAAA6D4GlOVj+Soz8hoWFc4FkYP3V722SFLzuuP3t2c/ay8GR0FW64GPwIDAQAB

package MobileSpecificPackage
{
	import AchievementPackage.Leaderboards;
	import AudioPackage.Audio;
	import LicPackage.AdMediatorType;
	
	
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.ui.GameInput;
	import flash.ui.GameInputDevice;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import LicPackage.AdHolder;
//	import NativeDevice.NativeDeviceInfo;
//	import NativeDevice.NativeDeviceInfoEvent;
//	import NativeDevice.NativeDeviceProperties;
//	import NativeDevice.NativeDevicePropertiesData;


	if (PROJECT::isAdBuddiz)
	{
	import com.purplebrain.adbuddiz.sdk.nativeExtensions.AdBuddiz;
	import com.purplebrain.adbuddiz.sdk.nativeExtensions.AdBuddizEvent;
		
	}

	if (PROJECT::isAndroidIAB)
	{
	import com.milkmangames.nativeextensions.android.AndroidIAB;
	import com.milkmangames.nativeextensions.android.events.AndroidBillingEvent;
	import com.milkmangames.nativeextensions.android.AndroidPurchase;
	import com.milkmangames.nativeextensions.android.events.AndroidBillingErrorEvent;
	}

	if (PROJECT::isRevMob)
	{
		import com.revmob.airextension.events.RevMobAdsEvent;
		import com.revmob.airextension.RevMob;
	}
	
	
	if (PROJECT::isChartboost)
	{
		import com.chartboost.plugin.air.Chartboost;
		import com.chartboost.plugin.air.ChartboostEvent;
	}

	if (PROJECT::isHeyzap)
	{
	import com.heyzap.sdk.ads.VideoAd;
	import com.heyzap.sdk.ads.HeyzapAds;
	import com.heyzap.sdk.ads.InterstitialAd;
	import com.heyzap.sdk.HeyzapEvent;
	import com.heyzap.sdk.ads.IncentivizedAd;
	}

	if (PROJECT::isAppSponsor)
	{
		import com.appsponsor.nativeExtensions.appsponsorsdk.AppSponsorEvent;
		import com.appsponsor.nativeExtensions.appsponsorsdk.AppSponsor;
	}
	
	if (PROJECT::isAppleGameCenter)
	{
		import com.milkmangames.nativeextensions.ios.GameCenter;
		import com.milkmangames.nativeextensions.ios.*;
		import com.milkmangames.nativeextensions.ios.events.*;
		import com.milkmangames.nativeextensions.ios.events.GameCenterEvent;
		import com.milkmangames.nativeextensions.ios.events.GameCenterErrorEvent;
	}

	if (PROJECT::isMobile)
	{
		import com.milkmangames.nativeextensions.GoViral;
		import com.milkmangames.nativeextensions.GoViral.*;
		import com.milkmangames.nativeextensions.events.GVFacebookEvent;
		import com.milkmangames.nativeextensions.events.GVTwitterEvent;
		import com.milkmangames.nativeextensions.events.GVShareEvent;
		import com.milkmangames.nativeextensions.events.*;
	}


	if (PROJECT::isPlayHaven)
	{
		import com.playhaven.events.PlayHavenEvent;
		import com.playhaven.PHPurchase;
		import com.playhaven.PlayHaven;
		import com.playhaven.ui.NotificationBadge;
	}


	if (PROJECT::useStage3D)
	{
		import flash.desktop.NativeApplication;
	}
	if (PROJECT::isGamePad)
	{
	import com.gaslightgames.nativeExtensions.AIROUYAIAPANE.AIROUYAIAPANE;
	import com.gaslightgames.nativeExtensions.AIROUYAIAPANE.AIROUYAIAPANEEvent;
	import com.gaslightgames.nativeExtensions.AIROUYAIAPANE.Gamer;
	import com.gaslightgames.nativeExtensions.AIROUYAIAPANE.Product;
	import com.gaslightgames.nativeExtensions.AIROUYAIAPANE.Purchase;
	import com.gaslightgames.nativeExtensions.AIROUYAIAPANE.Receipt;
		
	}
	if (PROJECT::isMobile)
	{
		if (PROJECT::isAppleIAB)
		{
			import com.milkmangames.nativeextensions.ios.events.StoreKitErrorEvent;
			import com.milkmangames.nativeextensions.ios.StoreKitProduct;
			import com.milkmangames.nativeextensions.ios.events.StoreKitEvent;
			import com.milkmangames.nativeextensions.ios.StoreKit;
			import com.milkmangames.nativeextensions.ios.StoreKit.isSupported;			
		}
		
		if (PROJECT::isAmazonIAB)
		{
			import com.amazon.nativeextensions.android.AmazonPurchaseReceipt;
			import com.amazon.nativeextensions.android.events.AmazonPurchaseEvent;
			import com.amazon.nativeextensions.android.AmazonPurchase;
			import com.amazon.nativeextensions.android.AmazonPurchase.isSupported;
		}
		
		if (PROJECT::isGooglePlay)
		{
//			import com.milkmangames.nativeextensions.android.AndroidPurchase;
//			import com.milkmangames.nativeextensions.android.AndroidIAB;
//			import com.milkmangames.nativeextensions.android.AndroidIAB.isSupported;
//			import com.milkmangames.nativeextensions.android.AndroidIAB.androidIAB;
//			import com.milkmangames.nativeextensions.android.events.AndroidBillingEvent;
//			import com.milkmangames.nativeextensions.android.events.AndroidBillingErrorEvent;
		}

// GOOGLE GAMES
		if (PROJECT::isGooglePlay)
		{
			import com.milkmangames.nativeextensions.events.GoogleGamesEvent;
			import com.milkmangames.nativeextensions.GoogleGames;
			import com.milkmangames.nativeextensions.GoogleGames.isSupported;
			import com.milkmangames.nativeextensions.GoogleGames.games;
		}
		
		import flash.events.AccelerometerEvent;
		import flash.sensors.Accelerometer;
		
// EASY PUSH		
//		import com.milkmangames.nativeextensions.EasyPush;
//		import com.milkmangames.nativeextensions.EasyPush.isSupported;
//		import com.milkmangames.nativeextensions.EasyPush.areNotificationsAvailable;

// RATE BOX
		import com.milkmangames.nativeextensions.RateBox;
		import com.milkmangames.nativeextensions.RateBox.isSupported;
		
// ADMOB		
		if (PROJECT::isAdMob)
		{
			import com.milkmangames.nativeextensions.AdMob;
			import com.milkmangames.nativeextensions.events.AdMobErrorEvent;
			import com.milkmangames.nativeextensions.events.AdMobEvent;
			import com.milkmangames.nativeextensions.AdMobAdType;
			import com.milkmangames.nativeextensions.AdMobAlignment;
		}

// GENERAL
		import com.milkmangames.nativeextensions.*;
		import com.milkmangames.nativeextensions.events.*;
		
		
	}
	public class MobileSpecific 
	{

		public function MobileSpecific() 
		{
			
		}

		static var useRewardAd:Boolean = true;

		
		
/*

	static var isDesktop:Boolean = true;
	if (PROJECT::isMobile)
	{
		isDesktop = false;
	}
 


		
		if (PROJECT::isMobile)
		{
			static var vibrate:Vibration;
		}
		public static function InitVibration()
		{
			if (isDesktop) return;
			if (PROJECT::isMobile)
			{
				vibrate = new Vibration();
			}
		}
		public static function Vibrate(timeSeconds:Number)
		{
			return;
			if (isDesktop) return;

			if (PROJECT::isMobile)
			{
				if (Vibration.isSupported)
				{
					vibrate.vibrate(timeSeconds * 1000);
				}
			}
		}

		static var goViralActive:Boolean = false;
		public static function Facebook()
		{
			if (goViralActive == false) return;
		if (PROJECT::isMobile)
		{
						
						
			GoViral.goViral.showTweetSheet("Playing SoccerBalls on Android!");

		}
			
		}
		
		
		*/
		
		
		
		static var AdMobClosedCB:Function;

		
		public static function HideAd()
		{
			
			if (PROJECT::isPaid)
			{
				return;
			}			
			if (Game.ad_free_unlocked) return;
			if (PROJECT::isAdMob)
			{
				try
				{
					AdMob.destroyAd();
				}
				catch(e:Error)
				{					
				}
			}
		}
		public static function ForceHideAd()
		{
			if (PROJECT::isAdMob)
			{
				try
				{
					AdMob.destroyAd();
				}
				catch(e:Error)
				{					
				}
			}
		}
			
		
		if (PROJECT::isChartboost)
		{
			
			private static var chartboost:Chartboost;
			
			static function ChartBoost_ShowIntersitial()
			{
				if (chartboost.hasCachedInterstitial())
				{
					chartboost.showInterstitial();
				}
			}
			static function InitChartBoost()
			{

			chartboost = Chartboost.getInstance();

				chartboost.addEventListener(ChartboostEvent.INTERSTITIAL_CACHED, Chartboost_EventReceived);
				chartboost.addEventListener(ChartboostEvent.INTERSTITIAL_CLICKED, Chartboost_EventReceived);
				chartboost.addEventListener(ChartboostEvent.INTERSTITIAL_CLOSED, Chartboost_EventReceived);
				chartboost.addEventListener(ChartboostEvent.INTERSTITIAL_DISMISSED	, Chartboost_EventReceived);
				chartboost.addEventListener(ChartboostEvent.INTERSTITIAL_FAILED, Chartboost_EventReceived);
				chartboost.addEventListener(ChartboostEvent.INTERSTITIAL_SHOWED, Chartboost_EventReceived);

				if (Chartboost.isAndroid()) 
				{
					if (PROJECT::isAmazon)
					{
						chartboost.init(MobileSpecificData.CHARTBOOST_AMAZON_APP_ID, MobileSpecificData.CHARTBOOST_AMAZON_APP_SIGNATURE);
					}
					else
					{
						chartboost.init(MobileSpecificData.CHARTBOOST_ANDROID_APP_ID, MobileSpecificData.CHARTBOOST_ANDROID_APP_SIGNATURE);
					}
					
				} 
				else if (Chartboost.isIOS()) 
				{
					chartboost.init(MobileSpecificData.CHARTBOOST_IOS_APP_ID, MobileSpecificData.CHARTBOOST_IOS_APP_SIGNATURE);
					
				}			
				
				chartboost.cacheInterstitial();
			}
			
			public static function Chartboost_EventReceived(event:ChartboostEvent)
			{
				var a:int = 0;
			}
		}
		
		if (PROJECT::isAppSponsor)
		{
			static var appSponsorAd:AppSponsor;
			static var appSponsorRewardAd:AppSponsor;
			public static function AppSponsor_ShowIntersitial()
			{
				if (appSponsorAd.isReady()) 
				{
					appSponsorAd.presentAd();
				}
			}
			public static function ReloadAppSponsor()
			{
				if (PROJECT::isIOS)
				{
					appSponsorAd = new AppSponsor(MobileSpecificData.APPSPONSOR_ID_IOS);
				}
				else
				{
					appSponsorAd = new AppSponsor(MobileSpecificData.APPSPONSOR_ID_ANDROID);
				}
				
				/*
				//an ad will show up 
				appSponsorAd.addEventListener( AppSponsorEvent.AD_WILLAPPEAR, AppSponsor_eventReceived ); 
				//an ad will disappear 
				appSponsorAd.addEventListener( AppSponsorEvent.AD_WILLDISAPPEAR, AppSponsor_eventReceived ); 
				//an ad is ready to display 
				appSponsorAd.addEventListener( AppSponsorEvent.AD_CACHED, AppSponsor_eventReceived ); 
				//an ad is failed to load
				appSponsorAd.addEventListener( AppSponsorEvent.LOAD_FAILED, AppSponsor_eventReceived ); 
				//ad rewarded ad finishes 
				appSponsorAd.addEventListener( AppSponsorEvent.AD_REWARD_END, AppSponsor_eventReceived );
				//ad rewarded ad finishes 
				appSponsorAd.addEventListener( AppSponsorEvent.AD_CLOSED, AppSponsor_eventReceived );
				*/
				
				
				appSponsorAd.load();
				
				if (useRewardAd)
				{
					appSponsorRewardAd = new AppSponsor(MobileSpecificData.APPSPONSOR_ID_ANDROID_REWARD, "", true);
					
					appSponsorRewardAd.addEventListener( AppSponsorEvent.AD_WILLAPPEAR, AppSponsorRewardAd_eventReceived ); 
					appSponsorRewardAd.addEventListener( AppSponsorEvent.AD_WILLDISAPPEAR, AppSponsorRewardAd_eventReceived ); 
					appSponsorRewardAd.addEventListener( AppSponsorEvent.AD_CACHED, AppSponsorRewardAd_eventReceived ); 
					appSponsorRewardAd.addEventListener( AppSponsorEvent.LOAD_FAILED, AppSponsorRewardAd_eventReceived ); 
					appSponsorRewardAd.addEventListener( AppSponsorEvent.AD_REWARD_END, AppSponsorRewardAd_eventReceived );
					appSponsorRewardAd.addEventListener( AppSponsorEvent.AD_CLOSED, AppSponsorRewardAd_eventReceived );
					
					appSponsorRewardAd.load();
				}
			}
			
			public static function AppSponsor_IsIncentivizedReady()
			{
				return appSponsorRewardAd.isReady();
			}
			public static function AppSponsor_ShowIncentivized(_cb:Function)
			{
				incentivizedCB = _cb;
				appSponsorRewardAd.presentAd();
			}
			
			public static function InitAppSponsor()
			{
				AddActivateEvent(ReloadAppSponsor);
				
				
				ReloadAppSponsor();

			}		
			
			private static function AppSponsor_eventReceived( event : AppSponsorEvent ) : void 
			{
			  trace( "AppSponsor " + event.type);
			}			
			private static function AppSponsorRewardAd_eventReceived( event : AppSponsorEvent ) : void 
			{
			  trace( "AppSponsorRewardAd " + event.type);
			  if (event.type == AppSponsorEvent.AD_REWARD_END)
			  {
				  trace("  " + appSponsorRewardAd.rewardedAdStatus());
				  IncentivizedAd_Respond(2,appSponsorRewardAd.rewardedAdStatus());
			  }
			  
			}			
		}
		


		if (PROJECT::isRevMob)
		{
			static var revmob:RevMob;
			
			static function ReloadRevMob()
			{
				if (PROJECT::isIOS)
				{
					revmob = new RevMob(MobileSpecificData.REVMOB_ID_IOS);
				}
				else
				{
					revmob = new RevMob(MobileSpecificData.REVMOB_ID_ANDROID);
				}
				
				revmob.addEventListener( RevMobAdsEvent.AD_CLICKED, onRevmobAdsEvent );
				revmob.addEventListener( RevMobAdsEvent.AD_DISMISS, onRevmobAdsEvent );
				revmob.addEventListener( RevMobAdsEvent.AD_DISPLAYED, onRevmobAdsEvent );
				revmob.addEventListener( RevMobAdsEvent.AD_NOT_RECEIVED, onRevmobAdsEvent );
				revmob.addEventListener( RevMobAdsEvent.AD_RECEIVED, onRevmobAdsEvent );
				
				revmob.createFullscreen();
			}
			
			public static function InitRevMob()
			{
				AddActivateEvent(ReloadRevMob);
				ReloadRevMob();
				
				
			}		
			
			public static function RevMob_ShowIntersitial()
			{
				revmob.showFullscreen();
			}
			
			private static function onRevmobAdsEvent( event : RevMobAdsEvent ) : void 
			{
			  trace( "Revmob " + event.type);
			}			
		}
//----------------------------------------------------------------------------------		
		
		if (PROJECT::isAdBuddiz)
		{
			static function ReloadAdBuddiz()
			{
			}
		
			public static function AdBuddiz_ShowIntersitial()
			{
				 AdBuddiz.showAd();
			}
			
			
			static function InitAdBuddiz()
			{
				AdBuddiz.addEventListener
				AdBuddiz.setAndroidPublisherKey(MobileSpecificData.ADBUDDIZ_ID_ANDROID);
				//AdBuddiz.setIOSPublisherKey("TEST_PUBLISHER_KEY_IOS");
				AdBuddiz.cacheAds();	
	   
				AdBuddiz.addEventListener(AdBuddizEvent.didCacheAd, AdBuddiz_EventReceived);
				AdBuddiz.addEventListener(AdBuddizEvent.didClick, AdBuddiz_EventReceived);
				AdBuddiz.addEventListener(AdBuddizEvent.didFailToShowAd, AdBuddiz_EventReceived);
				AdBuddiz.addEventListener(AdBuddizEvent.didHideAd, AdBuddiz_EventReceived);
				AdBuddiz.addEventListener(AdBuddizEvent.didShowAd, AdBuddiz_EventReceived);
			}
			
			static function AdBuddiz_EventReceived(e:AdBuddizEvent)
			{
				trace("ADBUDDIZ "+e.type);
				
			}
		}
		
		if (PROJECT::isAdMob)
		{
			
			static function InitAdMob()
			{
				AdMobClosedCB = null;
				if (Game.ad_free_unlocked) return;
				trace("init admob");
				if (!AdMob.isSupported)
				{
					trace("AdMob is not supported on this platform.");
					return;
				}
				
				trace("initializing AdMob...");		
				
				
				// for the AdMob for Android AND iOS Extension:
				 AdMob.init(MobileSpecificData.ADMOB_PUBLISHER_ID_ANDROID,MobileSpecificData.ADMOB_PUBLISHER_ID_IOS);
				
				trace("AdMob Initialized! "+MobileSpecificData.ADMOB_PUBLISHER_ID_ANDROID+" / "+MobileSpecificData.ADMOB_PUBLISHER_ID_IOS);
				
				AdMob.addEventListener(AdMobErrorEvent.FAILED_TO_RECEIVE_AD,onFailedReceiveAd);
				AdMob.addEventListener(AdMobEvent.RECEIVED_AD,onReceiveAd);
				AdMob.addEventListener(AdMobEvent.SCREEN_PRESENTED,onScreenPresented);
				AdMob.addEventListener(AdMobEvent.SCREEN_DISMISSED,onScreenDismissed);
				AdMob.addEventListener(AdMobEvent.LEAVE_APPLICATION,onLeaveApplication);
				
				AdMob.loadInterstitial(MobileSpecificData.ADMOB_PUBLISHER_ID_ANDROID_INTERSITIAL,false, MobileSpecificData.ADMOB_PUBLISHER_ID_IOS_INTERSITIAL);
			}
			
			static function onFailedReceiveAd(e:AdMobErrorEvent):void
			{
				trace("ERROR receiving ad, reason: '" + e.text + "'");
				if (e.isInterstitial)
				{
					if (AdMobClosedCB != null)
					{
						AdMobClosedCB();
					}
				}
				
			}
			
			static function onReceiveAd(e:AdMobEvent):void
			{
				trace("Received ad.  Dimensions:"+e.dimensions);
			}
			
			static function onScreenPresented(e:AdMobEvent):void
			{
				trace("Screen Presented.");
			}
			
			static function onScreenDismissed(e:AdMobEvent):void
			{
				trace("Screen Dismissed.");
				if (e.isInterstitial)
				{
					if (AdMobClosedCB != null)
					{
						AdMobClosedCB();
					}
				}
			}
			
			static function onLeaveApplication(e:AdMobEvent):void
			{
				trace("Leave Application.");
			}
		
		}
		

		if (PROJECT::isPlayHaven)
		{
			
			
			static function InitPlayHaven()
			{
				
				if (!PlayHaven.isSupported())
				{
					PlayHaven_log("PlayHaven is not supported on this platform (not android or ios!)");
					return;
				}
				
				
// new api				PlayHaven.create(MobileSpecificData.PLAYHAVEN_IOS_PUBLISHER_TOKEN,MobileSpecificData.PLAYHAVEN_IOS_PUBLISHER_SECRET,"",MobileSpecificData.PLAYHAVEN_ANDROID_PUBLISHER_TOKEN,MobileSpecificData.PLAYHAVEN_ANDROID_PUBLISHER_SECRET);
				PlayHaven.create(MobileSpecificData.PLAYHAVEN_IOS_PUBLISHER_TOKEN,MobileSpecificData.PLAYHAVEN_IOS_PUBLISHER_SECRET,MobileSpecificData.PLAYHAVEN_ANDROID_PUBLISHER_TOKEN,MobileSpecificData.PLAYHAVEN_ANDROID_PUBLISHER_SECRET);
				// listeners for content windows 
				PlayHaven.playhaven.addEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISMISSED,PlayHaven_onContentDismissed);
				PlayHaven.playhaven.addEventListener(PlayHavenEvent.CONTENT_OVERLAY_DISPLAYED,PlayHaven_onContentDisplayed);
				PlayHaven.playhaven.addEventListener(PlayHavenEvent.CONTENT_OVERLAY_FAILED,PlayHaven_onContentFailed);

				// listener for rewards
				PlayHaven.playhaven.addEventListener(PlayHavenEvent.REWARD_UNLOCKED,PlayHaven_onReward);
				
				// listeners for in-app Virtual Good Promotions
				PlayHaven.playhaven.addEventListener(PlayHavenEvent.VGP_PURCHASE_REPORTED,PlayHaven_onVgpReported);
				PlayHaven.playhaven.addEventListener(PlayHavenEvent.VGP_PURCHASE_REQUESTED,PlayHaven_onVgpRequested);
				PlayHaven.playhaven.addEventListener(PlayHavenEvent.VGP_PURCHASE_REPORT_FAILED,PlayHaven_onVgpReportFailed);

				PlayHaven_log("PlayHaven Initialized!");
				
				PlayHaven_log("sending game open...");
				PlayHaven.playhaven.reportGameOpen();
				PlayHaven_log("->Reported game open.");
				
				PlayHaven.playhaven.preloadContentRequest("moregames");
				PlayHaven.playhaven.preloadContentRequest("intersitial");
				PlayHaven.playhaven.preloadContentRequest("gamestart");
			
//				PlayHaven_showGameStart();
			}
			
			static function PlayHaven_log(s:String)
			{
				trace(s);
			}
			
			public static function PlayHaven_showIntersitial():void
			{
				PlayHaven_log("Showing test01 placement");
				PlayHaven.playhaven.sendContentRequest("intersitial",true);
				PlayHaven_log("send test01 request.");
			}

			public static function PlayHaven_showGameStart():void
			{
				PlayHaven_log("Showing test02 placement");
				PlayHaven.playhaven.sendContentRequest("gamestart",true);
				PlayHaven_log("send test01 request.");
			}
			
			/** Show More Games */
			public static function PlayHaven_showMoreGames():void
			{
				PlayHaven_log("Starting more games placement..");
				PlayHaven.playhaven.sendContentRequest("moregames",true);
				PlayHaven_log("requested more games placement.");
			}
			
			/** Set Opt Out Status YES */
			public static function PlayHaven_setOptOutYes():void
			{
				PlayHaven.playhaven.setOptOutStatus(true);
				PlayHaven_log("Set optout=true");
			}
			
			/** Set Opt out Status NO */
			public static function PlayHaven_setOptOutNo():void
			{
				PlayHaven.playhaven.setOptOutStatus(false);
				PlayHaven_log("set optout=false");
			}
			
			private static var badge:NotificationBadge;
			
			/** Show Notification Badge */
			public static function PlayHaven_showBadge():void
			{
				PlayHaven_log("Showing badge...");
				
				if (badge!=null)
				{
					log("Already have a badge.");
					return;
				}
				
				badge=PlayHaven.playhaven.createNotificationBadge("more_games");
				
				// setting this makes the badge render on the screen, even if the value is 0.
				// this can be useful during testing for proper alignment, etc.
				badge.testMode=true;
				
				var badgeX:Number=btnMoreGames.parent.x+btnMoreGames.x+btnMoreGames.width;
				var badgeY:Number=btnMoreGames.parent.y+btnMoreGames.y;
				

				badgeX-=10;
				badge.x=badgeX;
				badge.y=badgeY;
				
				stage.addChild(badge);
				
				PlayHaven_log("badge created, added to stage.");
			}
			
			/** Remove Badge */
			public static function PlayHaven_removeBadge():void
			{
				PlayHaven_log("Removing badge...");
				badge.parent.removeChild(badge);
				badge=null;
				PlayHaven_log("Badge removed.");
			}
			
			/** Refresh Badge */
			public static function PlayHaven_refreshBadge():void
			{
				PlayHaven_log("Refreshing badge...");
				if (badge==null)
				{
					log("No badge to refresh.");
					return;
				}
				badge.refresh();
				PlayHaven_log("Badge refreshed.");
			}
			
			/** Preload Content */
			public static function PlayHaven_preloadContent():void
			{
				PlayHaven_log("preloading...");
				PlayHaven.playhaven.preloadContentRequest("more_games");
				PlayHaven_log("request preload.");
			}
			
			//
			// Events
			//	

			/** On Content Failed */
			private static function PlayHaven_onContentFailed(e:PlayHavenEvent):void
			{
				PlayHaven_log("ContentFailed:"+e.placementId+"="+e.errorMessage);
			}
			
			/** On Content Dismissed */
			private static function PlayHaven_onContentDismissed(e:PlayHavenEvent):void
			{
				PlayHaven_log("Content dismissed: "+e.placementId+" for "+e.contentDismissalReason);
			}
			
			/** Content Displayed */
			private static function PlayHaven_onContentDisplayed(e:PlayHavenEvent):void
			{
				PlayHaven_log("Content displayed:"+e.placementId);
			}
			
			/** On Reward */
			private static function PlayHaven_onReward(e:PlayHavenEvent):void
			{
				PlayHaven_log("Reward "+e.rewardName+","+e.rewardQuantity+","+e.rewardReceipt);
			}
			
			/** VGP Purchase Requested */
			private static function PlayHaven_onVgpRequested(e:PlayHavenEvent):void
			{
				PlayHaven_log("purchase requested:"+e.purchase.receipt+"/"+e.purchase.productId);
				
				/**
				 * At this point, you should use your In-App Purchase third party native extension to start a
				 * transaction.  When the transaction finishes, you call PlayHaven.playhaven.reportPurcaseResolution,
				 * with the purchase object and one of the PHPurchaseResolution constants: BUY, ERROR, or CANCEL.
				 * 
				 * The code below automatically calls the 'BUY' resolution as an example to test the implementation,
				 * but you'll need to add your own callback from your in-app purchase extension.  For more information,
				 * see the documentation ('index.html' in the /docs folder of the extension zip.)
				 */
				
				var purchase:PHPurchase=e.purchase;
				
				var closePurchase:Function=function():void
				{
					PlayHaven_log("Close purchase...");
					PlayHaven.playhaven.reportVGPPurchaseResolution(purchase,PHPurchaseResolution.BUY);
					PlayHaven_log("did report close.");
				}
				PlayHaven_log("set timeout purchase callback...");
				setTimeout(closePurchase,5000);
				
			}
			
			/** VGP Purchase Reported */
			private static function PlayHaven_onVgpReported(e:PlayHavenEvent):void
			{
				PlayHaven_log("purchase reported:"+e.purchase);
			}
			
			/** VGP Purchase Report Failed */
			private static function PlayHaven_onVgpReportFailed(e:PlayHavenEvent):void
			{
				PlayHaven_log("purchase report failed:"+e.errorMessage);
			}
		}

//--------------------------------			

		
		
		
		if (PROJECT::isMobile)
		{
			static function InitGoViral()
			{
				trace("init goviral");
				goViralActive = false;
				if (GoViral.isSupported() == false) return;
				GoViral.create();
				goViralActive = true;
				
				// initialize facebook.		
				// this is to make sure you remembered to put in your app ID !
				if (MobileSpecificData.FACEBOOK_APP_ID=="YOUR_FACEBOOK_APP_ID")
				{
					Utils.print("You forgot to put in Facebook ID!");
				}
				else
				{
					Utils.print("Init facebook...");
					GoViral.goViral.initFacebook(MobileSpecificData.FACEBOOK_APP_ID,"");
					Utils.print("init fb done.");
				}
			
				// twitter events
				GoViral.goViral.addEventListener(GVTwitterEvent.TW_DIALOG_CANCELED,onTwitterEvent);
				GoViral.goViral.addEventListener(GVTwitterEvent.TW_DIALOG_FAILED,onTwitterEvent);
				GoViral.goViral.addEventListener(GVTwitterEvent.TW_DIALOG_FINISHED, onTwitterEvent);
				
				// facebook events
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_CANCELED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FAILED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FINISHED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_IN, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_OUT, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_CANCELED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_FAILED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_FAILED, onFacebookEvent);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookEvent);
				
			}
				
		
		
			static var facebookAfterLoginFunction:Function = null;
			static var facebookAfterLoginData:Object = null;
		
		
			private static function onFacebookEvent(e:GVFacebookEvent):void
			{
				if (e.type == GVFacebookEvent.FB_LOGGED_IN)
				{
					if (facebookAfterLoginFunction != null)
					{
						var a:Function = facebookAfterLoginFunction;
						facebookAfterLoginFunction = null;
						a(facebookAfterLoginData);
					}
				}
			}

			private static function onTwitterEvent(e:GVTwitterEvent):void
			{
				switch(e.type)
				{
					case GVTwitterEvent.TW_DIALOG_CANCELED:
						Utils.print("Twitter canceled.");
						break;
					case GVTwitterEvent.TW_DIALOG_FAILED:
						Utils.print("Twitter failed: "+e.errorMessage);
						break;
					case GVTwitterEvent.TW_DIALOG_FINISHED:
						Utils.print("Twitter finished.");
						break;
				}
			}
		}
		
		
		private static function handleExiting(e:Event):void 
		{
			
			if (PROJECT::isGamePad)
			{
				AudioPackage.Audio.StopAllMusic();
				AudioPackage.Audio.StopAllSFX();			
				NativeApplication.nativeApplication.exit();				
			}
		}
		private static function handleDeactivate(e:Event):void 
		{
			Game.main.pauseMainLoop = true;
			s3d.pauseRender= true;
			AudioPackage.Audio.PauseEverything();
			if (PROJECT::isMobile)
			{
//				NativeApplication.nativeApplication.exit();
			}
			
			
		}		
		
		static var onActivateEvents:Array;
		
		private static function handleActivate(e:Event):void 
		{
			Game.main.pauseMainLoop = false;
			s3d.pauseRender= false;
			 AudioPackage.Audio.UnPauseEverything();
			 if (PROJECT::isMobile)
			 {
				 if (PROJECT::isGamePad == false)
				 {
					CallActivateEvents();
					AdHolder.ReloadIngameAds();
					
				 }
			 }
		}		
		
		
		public static function Vibrate(amt:Number) { }

		public static function InitInternalEvents()
		{
			onActivateEvents = new Array();
		}
		
		static function CallActivateEvents()
		{
			for each(var f:Function in onActivateEvents)
			{
				f();
			}
		}
		static function AddActivateEvent(f:Function)
		{
			onActivateEvents.push(f);
		}
		
		
		public static function SetBackCB(cb:Function)
		{
			backButtonCB = cb;
		}
		static var backButtonCB:Function = null;
		static function NativeBackButtonPressed(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.BACK) 
			{
				e.preventDefault();
				if (backButtonCB != null)
				{
					backButtonCB();
				}
			}				
		}
		
		public static function Init()
		{
			InitInternalEvents();
				
			if (PROJECT::isMobile)
			{
				
				NativeApplication.nativeApplication.addEventListener( KeyboardEvent.KEY_DOWN, NativeBackButtonPressed );
				
//				InitEasyPush();

				if (PROJECT::isGamePad)
				{
					InitOuya();			
					InitActivateDeactivate();
					return;
				}


				InitAccelerometer();
	
			
				if (PROJECT::isAndroid)
				{
					
					InitRateBox();
					
					if (PROJECT::isAndroidIAB)
					{
						InitAndroidIAB();
					}

					if (PROJECT::isAppSponsor)
					{
						InitAppSponsor();
					}

					if (PROJECT::isRevMob)
					{
						InitRevMob();
					}
					
					if (PROJECT::isAdMob)
					{
						InitAdMob();
					}
					
					if (PROJECT::isChartboost)
					{
						InitChartBoost();
					}

					if (PROJECT::isHeyzap)
					{
						InitHeyzap();
					}
					
					if (PROJECT::isAdBuddiz)
					{
						InitAdBuddiz();
					}
					
					if (PROJECT::isAmazonIAB)				
					{
						InitAmazonPurchase();
					}
					if (PROJECT::isAmazon)				
					{
						//InitAmazonPurchase();
						//InitGoViral();

//						InitAdMob();
//						InitRateBox();

					}
					
					if (PROJECT::isGooglePlay)				
					{
						InitGoViral();
						InitGoogleGames();

//						InitRateBox();
						
//						trace("InitAndroidIAB");
					}
				}
				
				if (PROJECT::isIOS)
				{
					InitGoViral();
				}
				if (PROJECT::isAppleIAB)
				{
					InitStoreKit();					
				}
				if (PROJECT::isAppleGameCenter)
				{
					InitGameCenter();
				}
				
//				InitFGLADvocate();

				if (PROJECT::isPlayHaven)
				{
					InitPlayHaven();
				}
				
				
				if (PROJECT::isIOS)
				{
					InitRateBox();
				}
				
				InitActivateDeactivate();
//				InitVibration();
			}
		}
		
		static function InitActivateDeactivate()
		{
			if (PROJECT::useStage3D)
			{
				NativeApplication.nativeApplication.addEventListener(Event.EXITING, handleExiting);
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
			}
			
		}
			
		
		if (PROJECT::isMobile)
		{
		static var sensor:Accelerometer;
		private static function InitAccelerometer()
		{
			if (MobileSpecificData.useAccelerometer == false) return;
			accelX = accelY = accelZ = 0;
			sensor = new Accelerometer();
			if (sensor.muted == false)
			{
				trace("accelerometer enabled");
				
				sensor.setRequestedUpdateInterval(100);					
				
				sensor.addEventListener(AccelerometerEvent.UPDATE, handleAccelerometer);
			}
		}
		
		
		private static function handleAccelerometer(e:AccelerometerEvent):void 
		{
			accelX = e.accelerationX;
			accelY = e.accelerationY;
			accelZ = e.accelerationZ;
		}
		}

		public static var accelX:Number;
		public static var accelY:Number;
		public static var accelZ:Number;

//-----------------------------------------
//----- RATEBOX STUFF STARTS HERE
//-----------------------------------------


		if (PROJECT::isMobile)
		{
			
			public static function RateBoxIncrementEvent()
			{
				RateBox.rateBox.incrementEventCount();
			}
			
			static function RateBoxOnActivate()
			{
//				RateBox.rateBox.onLaunch();
			}
			public static function InitRateBox()
			{
				if (RateBox.isSupported())
				{
					RateBox.create("", MobileSpecificData.RATEBOX_TITLE, MobileSpecificData.RATEBOX_TEXT,
							"Rate Now", "Not now", "Don't ask again",
							0, 1, 0);
							
					AddActivateEvent(RateBoxOnActivate);
				}
				else
				{
					trace("InitRateBox NOT supported");
					
				}
				
				// REMEMBER TO REMOVE THIS!
				if (MobileSpecificData.RATEBOX_USETESTMODE)
				{
					RateBox.rateBox.useTestMode();
				}
				
			}
		}
		else
		{
			
			public static function RateBoxIncrementEvent()
			{
			}
		}

		

//-----------------------------------------
//----- EASYPUSH STUFF STARTS HERE
//-----------------------------------------
		
		if (PROJECT::isMobile)
		{
			public static function InitEasyPush()
			{
				trace("init easy push");
				if (EasyPush.isSupported() && EasyPush.areNotificationsAvailable())
				{
					trace("init easy push 2");
					EasyPush.initAirship(EASYPUSH_AIRSHIP_KEY,EASYPUSH_AIRSHIP_SECRET,EASYPUSH_GCM_NUMBER,true,true,true);
				}
				else 
				{
					trace("Push is not supported or is turned off...");
					return;
				}
			}
		}
	
		
		public static var IAP_MakePurchase_CB:Function;

		public static function IAP_RestorePurchases()
		{
			if (PROJECT::isAppleIAB)
			{
				StoreKit_RestoreTransactions();
			}
		}
		
		public static function IAP_MakePurchase(_name_Google:String,_name_Amazon:String,_name_IOS:String,_cb:Function=null)
		{
			IAP_MakePurchase_CB = _cb;
			if (PROJECT::isAndroid)
			{
				if (PROJECT::isAmazonIAB)				
				{
					AmazonPurchase_MakePurchase(_name_Amazon);
				}
				if(PROJECT::isAndroidIAB)
				{
					AndroidIAB_MakePurchase(_name_Google);
				}
			}
			if (PROJECT::isAppleIAB)
			{
				StoreKit_MakePurchase(_name_IOS);
			}
		}
		
		// Called from ALL versions of purchases with the name of the purchased item
		
		static function IAP_PurchaseSuccessful(_name:String)
		{
			trace("purchase successful " + _name);
			
			
			if (true)	//purchase.itemId == "ad_free")
			{
				Game.full_version_unlocked = true;
				Game.ad_free_unlocked = true;
			}
			
			if (IAP_MakePurchase_CB != null)
			{
				IAP_MakePurchase_CB();
			}
			
		}
		
//-----------------------------------------
//----- ANDROID IAB STUFF STARTS HERE
//-----------------------------------------
		
		if (PROJECT::isAndroidIAB)
		{
			public static function InitAndroidIAB()
			{
				trace("InitAndroidIAB");
				if (AndroidIAB.isSupported())
				{
					AndroidIAB.create();
					trace("InitAndroidIAB is supported");
					
					AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_READY,AndroidIAB_onReady);
					AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_NOT_SUPPORTED, AndroidIAB_onUnsupported);
					AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.PURCHASE_SUCCEEDED, AndroidIAB_onPurchaseSuccess);
					AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.PURCHASE_FAILED, AndroidIAB_onPurchaseFailed);
					AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.INVENTORY_LOADED, AndroidIAB_onInventoryLoaded);
					AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.LOAD_INVENTORY_FAILED,AndroidIAB_onInventoryFailed);
					// start the service
					AndroidIAB.androidIAB.startBillingService(MobileSpecificData.ANDROID_LICENSE_KEY);
					
				}
				else 
				{
					trace("InitAndroidIAB is not supported or is turned off...");
					return;
				}
			}
			// listeners for billing service startup
			private static function AndroidIAB_onReady(e:AndroidBillingEvent):void
			{
				trace("AndroidIAB_onReady: service now ready- you can now make purchases.");
				AndroidIAB_LoadInventory();
			}
			private static function AndroidIAB_onUnsupported(e:AndroidBillingEvent):void
			{
				trace("AndroidIAB_onUnsupported: sorry, in app billing won't work on this phone!");
			}		
			
			static function AndroidIAB_LoadInventory()
			{
				AndroidIAB.androidIAB.loadPlayerInventory();
				
				
			}
			// listen for inventory events
			
			static function AndroidIAB_onInventoryLoaded(e:AndroidBillingEvent):void
			{
				trace("Listing android inventory items: "+e.purchases.length);
				for each(var purchase:AndroidPurchase in e.purchases)
				{
					
					IAP_PurchaseSuccessful( purchase.itemId);
					
					// this is where you'd update the state of your app to reflect ownership of the item
				}
			}
			static function AndroidIAB_onInventoryFailed(e:AndroidBillingEvent):void
			{
				trace("AndroidIAB_onInventoryFailed: Something went wrong loading inventory: "+e.text);
			}			
			
			public static function AndroidIAB_MakePurchase(_name:String)
			{
				trace("AndroidIAB_MakePurchase reached");
				AndroidIAB.androidIAB.purchaseItem(_name);
				//AndroidIAB.androidIAB.testPurchaseItemSuccess();
				
			}
			static function AndroidIAB_onPurchaseSuccess(e:AndroidBillingEvent):void
			{
				var purchase:AndroidPurchase=e.purchases[0];
				trace("onPurchaseSuccess: you purchased the item "+purchase.itemId);
				AndroidIAB.androidIAB.loadPlayerInventory();
			}
			static function AndroidIAB_onPurchaseFailed(e:AndroidBillingErrorEvent):void
			{
				trace("onPurchaseFailed: Something went wrong with the purchase of "+e.itemId+": "+e.text);
			}
		}

		if (PROJECT::isMobile)
		{
			if (PROJECT::isAmazonIAB)
			{
			public static function InitAmazonPurchase()
			{
				trace("InitAmazonPurchase");
				if (AmazonPurchase.isSupported())
				{
					AmazonPurchase.create();
					trace("InitAmazonPurchase is supported");
					
//					AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.ITEM_DATA_LOADED,onDataLoaded);
//					AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.ITEM_DATA_FAILED,onDataFailed);
					// item purchase listeners
					AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASE_ALREADY_ENTITLED,AmazonPurchase_onAlreadyEntitled);
					AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASE_FAILED,AmazonPurchase_onPurchaseFailed);
					AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASE_SKU_INVALID,AmazonPurchase_onInvalidSku);
					AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASE_SUCCEEDED,AmazonPurchase_onPurchaseSuccess);
					// purchase update listeners
					AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASES_UPDATE_FAILED,AmazonPurchase_onUpdateFailed);
					AmazonPurchase.amazonPurchase.addEventListener(AmazonPurchaseEvent.PURCHASES_UPDATED, AmazonPurchase_onPurchasesUpdate);
				}
				else
				{
					trace("InitAmazonPurchase is NOT supported");
				}
			}
			private static function AmazonPurchase_onUpdateFailed(e:AmazonPurchaseEvent):void
			{
				trace("AmazonPurchase_onUpdateFailed");
			}
			private static function AmazonPurchase_onPurchasesUpdate(e:AmazonPurchaseEvent):void
			{
				trace("AmazonPurchase_onPurchasesUpdate");
				for each(var receipt:AmazonPurchaseReceipt in e.receipts)
				{
					trace("you previously bought a " + receipt.sku + " / " + receipt.type);
					IAP_PurchaseSuccessful( receipt.type);
					// update your internal state for the items here.
				}
			}
			
			private static function AmazonPurchase_onAlreadyEntitled(e:AmazonPurchaseEvent):void
			{
				trace("AmazonPurchase_onAlreadyEntitled");
			}
			private static function AmazonPurchase_onPurchaseFailed(e:AmazonPurchaseEvent):void
			{
				trace("AmazonPurchase_onPurchaseFailed");
			}
			private static function AmazonPurchase_onInvalidSku(e:AmazonPurchaseEvent):void
			{
				trace("AmazonPurchase_onInvalidSku");
			}
			private static function AmazonPurchase_onPurchaseSuccess(e:AmazonPurchaseEvent):void
			{
				trace("AmazonPurchase_onPurchaseSuccess");
			}

			
			public static function AmazonPurchase_MakePurchase(_name:String)
			{
				trace("AmazonPurchase_MakePurchase");
				AmazonPurchase.amazonPurchase.purchaseItem(_name);				
			}
			}
			
		}
		
//--------------------------------------------------------------------------------------------------		
//--------------------------------------------------------------------------------------------------		
//--------------------------------------------------------------------------------------------------

		if (PROJECT::isAppleGameCenter)
		{
			public static function InitGameCenter()
			{
				if(GameCenter.isSupported())
				{
				GameCenter.create();
				}
				else
				{
					trace("this device is not running iOS.");
				return;
				}
				if(!GameCenter.gameCenter.isGameCenterAvailable())
				{
				trace("GameCenter is not enabled on this device.");
				return;
				}				
				GameCenter.gameCenter.addEventListener(GameCenterEvent.AUTH_SUCCEEDED,GameCenter_onAuthSucceeded);
				GameCenter.gameCenter.addEventListener(GameCenterErrorEvent.AUTH_FAILED, GameCenter_onAuthFailed);
				
				GameCenter.gameCenter.addEventListener(GameCenterEvent.LEADERBOARD_VIEW_OPENED,GameCenter_onViewOpened);
				GameCenter.gameCenter.addEventListener(GameCenterEvent.LEADERBOARD_VIEW_CLOSED,GameCenter_onViewClosed);
				
//				GameCenter.gameCenter.addEventListener(GameCenterEvent.ACHIEVEMENT_VIEW_OPENED,GameCenter_onViewOpened);
//				GameCenter.gameCenter.addEventListener(GameCenterEvent.ACHIEVEMENT_VIEW_CLOSED, GameCenter_onViewClosed);
				
				GameCenter.gameCenter.addEventListener(GameCenterEvent.ACHIEVEMENT_REPORT_SUCCEEDED,GameCenter_onAchievementReported);
				GameCenter.gameCenter.addEventListener(GameCenterErrorEvent.ACHIEVEMENT_REPORT_FAILED, GameCenter_onAchievementFailed);				
				
				GameCenter.gameCenter.addEventListener(GameCenterEvent.ACHIEVEMENT_RESET_SUCCEEDED,GameCenter_onAchievementReset);
				GameCenter.gameCenter.addEventListener(GameCenterErrorEvent.ACHIEVEMENT_RESET_FAILED,GameCenter_onAchievementResetFailed);				
				
				GameCenter.gameCenter.addEventListener(GameCenterEvent.SCORE_REPORT_SUCCEEDED,GameCenter_onScoreReported);
				GameCenter.gameCenter.addEventListener(GameCenterErrorEvent.SCORE_REPORT_FAILED,GameCenter_onScoreFailed);

				if(GameCenter.gameCenter.areBannersAvailable())
				{
					GameCenter.gameCenter.showAchievementBanners(true);
				}
				
				GameCenter.gameCenter.authenticateLocalUser();
				
				
			}

			public static function GameCenter_UnlockAchievement(id:String):void
			{
				GameCenter.gameCenter.reportAchievement(id,100.0);
			}
			
			public static function GameCenter_SubmitScore(id:String,score:int):void
			{
				GameCenter.gameCenter.reportScoreForCategory(score, id);
			}
				
			public static function GameCenter_ShowLeaderboard(id:String)
			{
				GameCenter.gameCenter.showLeaderboardForCategory(id);
			}
			
			static function GameCenter_onAuthSucceeded(e:GameCenterEvent):void
			{
			trace("game center logged in.");
			}
			static function GameCenter_onAuthFailed(e:GameCenterErrorEvent):void
			{
			trace("game center login failed.");
			}			
			
			static function GameCenter_onViewOpened(e:GameCenterEvent):void
			{
			// view opened- you might want to stop sounds or pause here.
			}
			static function GameCenter_onViewClosed(e:GameCenterEvent):void
			{
			// view closed – you might want to restore sounds, unapause, etc. here.
			}			
			
			static function GameCenter_onScoreReported(e:GameCenterEvent):void
			{
				trace("score submitted!");
				GameCenter_ShowLeaderboard(e.category);
			}
			static function GameCenter_onScoreFailed(e:GameCenterErrorEvent):void
			{
				trace("an error occurred reporting score.");
			}			
			static function GameCenter_onAchievementReported(e:GameCenterEvent):void
			{
			trace("achievement reported!");
			// if you're using your own achievement banners, display them here.
			}
			static function GameCenter_onAchievementFailed(e:GameCenterEvent):void
			{
			trace("error reporting achievement.");
			}			
			
			static function GameCenter_onAchievementReset(e:GameCenterEvent):void
			{
			trace("achievements were reset.");
			}
			static function GameCenter_onAchievementResetFailed(e:GameCenterErrorEvent):void
			{
			trace("achievement reset has failed.");
			}		
			}

//-----------------------------------------
//----- GOOGLE GAMES STUFF STARTS HERE
//-----------------------------------------
	
		static var googleGamesActive:Boolean = false;
		if (PROJECT::isGooglePlay)
		{
			public static function InitGoogleGames()
			{
				trace("init google games");
				
				if (GoogleGames.isSupported())
				{
					GoogleGames.create(GoogleGames_LogCallback);
					GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED,GoogleGames_onSignedIn);
					GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_FAILED, GoogleGames_onSignInFailed);
					GoogleGames.games.addEventListener(GoogleGamesEvent.SUBMIT_SCORE_SUCCEEDED,GoogleGames_onSubmitted);
					GoogleGames.games.addEventListener(GoogleGamesEvent.SUBMIT_SCORE_FAILED,GoogleGames_onScoreFailed);
					GoogleGames.games.addEventListener(GoogleGamesEvent.UNLOCK_ACHIEVEMENT_FAILED,GoogleGames_onAchievementFail);
					GoogleGames.games.addEventListener(GoogleGamesEvent.UNLOCK_ACHIEVEMENT_SUCCEEDED,GoogleGames_onAchievementSuccess);
					googleGamesActive = true;
					GoogleGames_SignIn();
				}		
				else
				{
					trace("init google games: NOT SUPPORTED");
				}
			}
			
			static function GoogleGames_LogCallback(cbString:String)
			{
				trace(cbString);
			}
			
			static function GoogleGames_onAchievementFail(e:GoogleGamesEvent):void
			{
				trace("GoogleGames_onAchievementFail");
			}
			static function GoogleGames_onAchievementSuccess(e:GoogleGamesEvent):void
			{
				trace("GoogleGames_onAchievementSuccess");
			}
			static function GoogleGames_onSignedIn(e:GoogleGamesEvent):void
			{
			trace("GoogleGames_onSignedIn: player signed in – ready to use google games services!");
			}
			static function GoogleGames_onSignInFailed(e:GoogleGamesEvent):void
			{
			trace("GoogleGames_onSignInFailed: something went wrong signing in.");
			
			}			
			static function GoogleGames_onSubmitted(e:GoogleGamesEvent):void
			{
			trace("GoogleGames_onSubmitted: the score " + e.score+" submitted to leaderboard " + e.leaderboardId);
				GoogleGames_ShowLeaderboard(e.leaderboardId);
			}
			static function GoogleGames_onScoreFailed(e:GoogleGamesEvent):void
			{
			trace("GoogleGames_onScoreFailed: something went wrong: "+e.failureReason);
			}			
			
			public static function GoogleGames_SignIn():void
			{
				if (googleGamesActive == false) return;
				GoogleGames.games.signIn();
			}
			public static function GoogleGames_ShowLeaderboard(id:String):void
			{
				if (googleGamesActive == false) return;
				GoogleGames.games.showLeaderboard(id);
			}

			static var GoogleGames_SubmitScore_LastTableID:String;
			public static function GoogleGames_SubmitScore(id:String,score:int):void
			{
				if (googleGamesActive == false) return;
				GoogleGames.games.submitScore(id, score);
			}

			public static function GoogleGames_UnlockAchievement(id:String):void
			{
				if (googleGamesActive == false) return;
				GoogleGames.games.unlockAchievement(id);
			}
			public static function GoogleGames_ShowAchievements():void
			{
				if (googleGamesActive == false) return;
				GoogleGames.games.showAchievements();
			}
			
		}

		if (PROJECT::isAppleIAB)
		{
			static function InitStoreKit()
			{
				trace("InitStoreKit");
				if(StoreKit.isSupported())
				{
					StoreKit.create();
					
					if(!StoreKit.storeKit.isStoreKitAvailable())
					{
						trace("this device has purchases disabled.");
						return;
					}			
					StoreKit_Setup();
				}
				else 
				{
					trace("StoreKit only works on iOS!");
					return;
				}
			}
			
			static function StoreKit_Setup()
			{
				trace("StoreKit_Setup");
				var productIdList:Vector.<String>=new Vector.<String>();
				productIdList.push("com.turbonuke.grandtruckismo.ad_free");

				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_SUCCEEDED, StoreKit_onPurchaseSuccess);
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_CANCELLED, StoreKit_onPurchaseCancel);				
				StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PURCHASE_FAILED, StoreKit_onPurchaseFailed);				
				StoreKit.storeKit.addEventListener(StoreKitEvent.TRANSACTIONS_RESTORED,StoreKit_onTransactionsRestoreComplete);
				StoreKit.storeKit.addEventListener(StoreKitErrorEvent.TRANSACTION_RESTORE_FAILED,StoreKit_onRestoreFailed);				
				
				StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PRODUCT_DETAILS_FAILED,StoreKit_onProductsFailed);
				StoreKit.storeKit.addEventListener(StoreKitEvent.PRODUCT_DETAILS_LOADED,StoreKit_onProducts);
				StoreKit.storeKit.loadProductDetails(productIdList);
			}
			static function StoreKit_onProducts(e:StoreKitEvent):void
			{
				for each(var product:StoreKitProduct in e.validProducts)
				{
					trace("ID: "+product.productId);
					trace("Title: "+product.title);
					trace("Description: "+product.description);
					trace("String Price: "+product.localizedPrice);
					trace("Price: "+product.price);
				}
				trace("Loaded "+e.validProducts.length+" Products.");
				if (e.invalidProductIds.length>0)
				{
					trace("[ERR]: invalid product ids:"+e.invalidProductIds.join(","));
				}
			}			
			static function StoreKit_onProductsFailed(e:StoreKitErrorEvent):void
			{
				trace("error loading products: "+e.text);
			}

			static function StoreKit_onPurchaseFailed(e:StoreKitErrorEvent):void
			{
				trace("StoreKit_onPurchaseFailed "+e.productId);
			}
			
			
			static function StoreKit_onRestoreFailed(e:StoreKitErrorEvent):void
			{
				trace("StoreKit_onRestoreFailed "+e.productId);				
			}
			static function StoreKit_onTransactionsRestoreComplete(e:StoreKitEvent):void
			{
				trace("StoreKit_onTransactionsRestoreComplete "+e.productId);
			}
			
			static function StoreKit_onPurchaseCancel(e:StoreKitEvent):void
			{
				trace("StoreKit_onPurchaseCancel "+e.productId);
			}
			static function StoreKit_onPurchaseSuccess(e:StoreKitEvent):void
			{
				trace("StoreKit_onPurchaseSuccess " + e.productId);
				
				IAP_PurchaseSuccessful(e.productId);
				
			// your app is now responsible for 'giving' the user whatever they bought!
			}
			
			static function StoreKit_RestoreTransactions()
			{
				trace("StoreKit_RestoreTransactions");
				StoreKit.storeKit.restoreTransactions();
			}
			static function StoreKit_MakePurchase(_name:String)
			{
				trace("StoreKit_MakePurchase "+_name);
				StoreKit.storeKit.purchaseProduct("com.turbonuke.grandtruckismo."+_name);
			}
			
		}

		if (PROJECT::isIOS)
		{
			public static const IPHONE_IPHONE_1G:String = "iPhone1,1"; // first gen is 1,1
			public static const IPHONE_IPHONE_3G:String = "iPhone1"; // second gen is 1,2
			public static const IPHONE_IPHONE_3GS:String = "iPhone2"; // third gen is 2,1
			public static const IPHONE_IPHONE_4:String = "iPhone3"; // normal:3,1 verizon:3,3
			public static const IPHONE_IPHONE_4S:String = "iPhone4"; // 4S is 4,1
			public static const IPHONE_IPHONE_5PLUS:String = "iPhone";
			public static const IPHONE_TOUCH_1G:String = "iPod1,1";
			public static const IPHONE_TOUCH_2G:String = "iPod2,1";
			public static const IPHONE_TOUCH_3G:String = "iPod3,1";
			public static const IPHONE_TOUCH_4G:String = "iPod4,1";
			public static const IPHONE_TOUCH_5PLUS:String = "iPod";
			public static const IPHONE_IPAD_1:String = "iPad1"; // iPad1 is 1,1
			public static const IPHONE_IPAD_2:String = "iPad2"; // wifi:2,1 gsm:2,2 cdma:2,3
			public static const IPHONE_IPAD_3:String = "iPad3"; // (guessing)
			public static const IPHONE_IPAD_4PLUS:String = "iPad";
			public static const IPHONE_UNKNOWN:String = "unknown";
					
			private static const IOS_DEVICES:Array = [IPHONE_IPHONE_1G, IPHONE_IPHONE_3G, IPHONE_IPHONE_3GS,
				IPHONE_IPHONE_4, IPHONE_IPHONE_4S, IPHONE_IPHONE_5PLUS, IPHONE_IPAD_1, IPHONE_IPAD_2, IPHONE_IPAD_3, IPHONE_IPAD_4PLUS,
				IPHONE_TOUCH_1G, IPHONE_TOUCH_2G, IPHONE_TOUCH_3G, IPHONE_TOUCH_4G, IPHONE_TOUCH_5PLUS];
					
			
			// Detect IOS device:
			public static function IOS_getDevice():String 
			{
				var info:Array = Capabilities.os.split(" ");
				if (info[0] + " " + info[1] != "iPhone OS") 
				{
					return IPHONE_UNKNOWN;
				}

				// ordered from specific (iPhone1,1) to general (iPhone)
				for each (var device:String in IOS_DEVICES) {	
					if (info[3].indexOf(device) != -1) {
						return device;
					}
				}
				return IPHONE_UNKNOWN;
			}
			
			public static function IOS_ShouldUse30fps():Boolean
			{
			return false;
				
				var device:String = IOS_getDevice();
				if (device == IPHONE_IPHONE_1G) return true;
				if (device == IPHONE_IPHONE_3G) return true;
				if (device == IPHONE_IPHONE_3GS) return true;
				if (device == IPHONE_IPHONE_4) return true;
				
				if (device == IPHONE_TOUCH_1G) return true;
				if (device == IPHONE_TOUCH_2G) return true;
				if (device == IPHONE_TOUCH_3G) return true;
				if (device == IPHONE_TOUCH_4G) return true;
				
				return false;
			}
		}
		
		
		if (PROJECT::isGamePad)
		{
			public static var ouyaIap:AIROUYAIAPANE;

			static var gameInput:GameInput;
			public static var pad0:GameInputDevice;
			public static var pad_DeviceAddedCount:int;
			public static var pad_NumDevices:int;
			public static var pad_isSupported:Boolean;
			
			
			public static function InitOuyaGamePad()
			{
				pad_isSupported = GameInput.isSupported;
				
				if (GameInput.isSupported)
				{
					pad_NumDevices = GameInput.numDevices;
					
					pad_DeviceAddedCount = 0;
					gameInput = new GameInput();
					gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, pad_DeviceAdded);
					gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, pad_DeviceRemoved);
					

//					var sampleVec:Vector.<String> = new Vector.<String>();
//					sampleVec[0] = pad0.id;
//					pad0.sampleInterval = 10;					
//					pad0.startCachingSamples(5, sampleVec);
				}
				
			}
				
			private static function pad_DeviceRemoved(e:GameInputEvent)
			{
				pad_DeviceAddedCount--;
			}
			private static function pad_DeviceAdded(e:GameInputEvent)
			{				
				pad0 = e.device;
				pad0.enabled = true;
				pad_DeviceAddedCount++;
			}
			static function InitOuya()
			{
				var urlRequest:URLRequest = new URLRequest( "key.der" );	// Needs to be in your bin directory!
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener( Event.COMPLETE, Ouya_onKeyLoad );
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.load( urlRequest );
				
				
				NativeApplication.nativeApplication.addEventListener( KeyboardEvent.KEY_DOWN, OUYABackButtonPressed );
			}
			static function OUYABackButtonPressed(e:KeyboardEvent):void 
			{
				if (e.keyCode == Keyboard.BACK) 
				{
					e.preventDefault();
				}				
			}
			
			public static var Ouya_PurchaseCallback:Function = null;
			
			private static function Ouya_onKeyLoad( event:Event ):void
			{
				trace("Ouya_onKeyLoad");
				( event.target as URLLoader ).removeEventListener( Event.COMPLETE, Ouya_onKeyLoad );
				
				// Get the Key data - as a ByteArray so we can pass it to the ANE
				var key:ByteArray = ( event.target as URLLoader ).data as ByteArray;
				key.endian = Endian.LITTLE_ENDIAN;
				
				// Simple way to read the values and make sure your key matches.
				Ouya_checkKey( key );
				
				ouyaIap = AIROUYAIAPANE.getInstance( "60602b09-196a-4e94-a69c-bf5514d731ad", key, true );
				ouyaIap.addEventListener( AIROUYAIAPANEEvent.PRODUCT, Ouya_onProduct );
				ouyaIap.addEventListener( AIROUYAIAPANEEvent.PURCHASE, Ouya_onPurchase );
				ouyaIap.addEventListener( AIROUYAIAPANEEvent.RECEIPT, Ouya_onReceipt );
				ouyaIap.addEventListener( AIROUYAIAPANEEvent.GAMER, Ouya_onGamer );
				ouyaIap.addEventListener( AIROUYAIAPANEEvent.FAILURE, Ouya_onFail );

				// get the products purchased
				MobileSpecific.ouyaIap.getProductReceipts();
				
			}
			
			private static function Ouya_onFail( iapEvent:AIROUYAIAPANEEvent ):void
			{
				trace("Ouya_onFail");
			}
			private static function Ouya_onProduct( iapEvent:AIROUYAIAPANEEvent ):void
			{
				trace("Ouya_onProduct");
				var product:Product = iapEvent.data as Product;
				if( null != product )
				{
					trace( "Product Received: " + product.identifier + ", " + product.name + ", " + product.price);
					
					ouyaIap.makeProductPurchase( product );
				}
			}
			
			private static function Ouya_onPurchase( iapEvent:AIROUYAIAPANEEvent ):void
			{
				var purchase:Purchase = iapEvent.data as Purchase;
				trace("Ouya_onPurchase");
				if( null != purchase )
				{
					trace( "Purchase Made: " + purchase.identifier + ", " + purchase.name + ", " + purchase.price);
					
					ouyaIap.getProductReceipts();									// This call only works on ENTITLEMENTS!  Make sure you've bought one first to see a receipt.
					if (Ouya_PurchaseCallback != null)
					{
						Ouya_PurchaseCallback();
					}
				}
			}
			
			private static function Ouya_onReceipt( iapEvent:AIROUYAIAPANEEvent ):void
			{
				trace( "Ouya_onReceipt: " + iapEvent.status );
				
				var receipt:Receipt = iapEvent.data as Receipt;
				if( null != receipt )
				{
					trace( "Receipt Received: " + receipt.identifier + ", " + receipt.price + ", " + receipt.generatedDate + ", " + receipt.purchasedDate);
					Game.full_version_unlocked = true;
				}
			}
			
			private static function Ouya_onGamer( iapEvent:AIROUYAIAPANEEvent ):void
			{
				trace("Ouya_onGamer");
				var gamer:Gamer = iapEvent.data as Gamer;
				
				if( null != gamer )
				{
					trace("Gamer UUID Received: " + gamer.udid);
				}
			}
			
			
			private static function Ouya_checkKey( key:ByteArray ):void
			{
				trace("Ouya_checkKey");
				key.position = 0;
				var keyStr:String = "";
				while( key.bytesAvailable )
				{
					var byte:uint = key.readUnsignedByte();
					keyStr += byte.toString(16).substr(-2);
				}
				trace( "Key: " + keyStr );
			}
		}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
		
		if (PROJECT::isMobile)
		{
			
			static function FacebookLoginTest(_func:Function,_data:Object)
			{
				if (!GoViral.goViral.isFacebookAuthenticated())
				{
					GoViral.goViral.authenticateWithFacebook("basic_info");
					facebookAfterLoginFunction = _func;
					facebookAfterLoginData = _data;
				}
			}
			
			public static function CreateFacebookFeedObject(name:String, caption:String, message:String, description:String, linkUrl:String = null, imageUrl:String = null, extraParams:Object = null) : Object
			{
				var data:Object = new Object();
				data.name = name;
				data.caption = caption;
				data.message = message;
				data.description = description;
				data.linkUrl = linkUrl;
				data.imageUrl = imageUrl;
				return data;
				
			}
			
		/**
		 * Displays a native Facebook Wall Post / Feed Post Dialog.
		 * 
		 *   On dismissal, a GVFacebookEvent will be dispatched with the result, of the type GVFacebookEvent.FB_DIALOG_FINISHED if the Dialog finished, GVFacebookEvent.FB_DIALOG_CANCELED if the dialog was cancelled, or GVFacebookEvent.FB_DIALOG_FAILED if the dialog failed.
		 * @param	name	the name of the post
		 * @param	caption	caption for the post
		 * @param	message	the message body of the post
		 * @param	description	description of the post
		 * @param	linkUrl	Optional.  Link URL for post to point at
		 * @param	imageUrl	Optional.  Image URL for post to display
		 * @param	extraParams	Optional.  Key/value pairs of any additional parameters to pass up to Facebook.
		 */
		
			public static function FacebookFeed(_data:Object)
			{
				if (goViralActive == false) return;
		
				FacebookLoginTest(FacebookFeed,_data);
				
				GoViral.goViral.showFacebookFeedDialog(_data.name, _data.caption, _data.message, _data.description, _data.linkUrl, _data.imageUrl, _data.extraParams);
			}
			
			public static function PostTwitter(s:String)
			{
				if (goViralActive == false) return;
				
				if (PROJECT::isMobile)
				{
					if (GoViral.goViral.isTweetSheetAvailable())
					{
						GoViral.goViral.showTweetSheet(s);
					}
				}
				
			}
		}
		
// HEYZAP HERE
		public static var incentivizedCB:Function = null;

		if (PROJECT::isHeyzap)
		{
			public static function Heyzap_ShowIncentivized(_cb:Function)
			{
				incentivizedCB = _cb;
				IncentivizedAd.getInstance().show();

			}
			public static function Heyzap_IsIncentivizedAvailable():Boolean
			{
				return IncentivizedAd.getInstance().isAvailable();
			}
			public static function Heyzap_ShowIntersitial()
			{
				if (InterstitialAd.getInstance().isAvailable())
				{
					InterstitialAd.getInstance().show();
				}
			}
			public static function InitHeyzap()
			{
				HeyzapAds.getInstance().start(MobileSpecificData.HEYZAP_PUBLISHER_ID,HeyzapAds.FLAG_DISABLE_AUTOMATIC_FETCH);

				InterstitialAd.getInstance().addEventListener(HeyzapEvent.DID_SHOW, HeyzapEventCB);
				InterstitialAd.getInstance().addEventListener(HeyzapEvent.DID_CLICK, HeyzapEventCB);
				InterstitialAd.getInstance().addEventListener(HeyzapEvent.DID_HIDE, HeyzapEventCB);
				InterstitialAd.getInstance().addEventListener(HeyzapEvent.DID_FAIL, HeyzapEventCB);
				InterstitialAd.getInstance().addEventListener(HeyzapEvent.IS_AVAILABLE, HeyzapEventCB);
				InterstitialAd.getInstance().addEventListener(HeyzapEvent.FETCH_FAILED, HeyzapEventCB);
				InterstitialAd.getInstance().addEventListener(HeyzapEvent.IS_INCOMPLETE, HeyzapEventCB);
				InterstitialAd.getInstance().addEventListener(HeyzapEvent.IS_COMPLETED, HeyzapEventCB);
				
				
				InterstitialAd.getInstance().fetch();
				
				/*
				VideoAd.getInstance().addEventListener(HeyzapEvent.DID_SHOW, HeyzapVideoAdEventCB);
				VideoAd.getInstance().addEventListener(HeyzapEvent.DID_CLICK, HeyzapVideoAdEventCB);
				VideoAd.getInstance().addEventListener(HeyzapEvent.DID_HIDE, HeyzapVideoAdEventCB);
				VideoAd.getInstance().addEventListener(HeyzapEvent.DID_FAIL, HeyzapVideoAdEventCB);
				VideoAd.getInstance().addEventListener(HeyzapEvent.IS_AVAILABLE, HeyzapVideoAdEventCB);
				VideoAd.getInstance().addEventListener(HeyzapEvent.FETCH_FAILED, HeyzapVideoAdEventCB);
				VideoAd.getInstance().addEventListener(HeyzapEvent.IS_INCOMPLETE, HeyzapVideoAdEventCB);
				VideoAd.getInstance().addEventListener(HeyzapEvent.IS_COMPLETED, HeyzapVideoAdEventCB);
				
				
				InterstitialAd.getInstance().fetch();
				
				IncentivizedAd.getInstance().fetch();
				IncentivizedAd.getInstance().addEventListener(HeyzapEvent.DID_SHOW, HeyzapIncentivzedCallback);
				IncentivizedAd.getInstance().addEventListener(HeyzapEvent.DID_CLICK, HeyzapIncentivzedCallback);
				IncentivizedAd.getInstance().addEventListener(HeyzapEvent.DID_HIDE, HeyzapIncentivzedCallback);
				IncentivizedAd.getInstance().addEventListener(HeyzapEvent.DID_FAIL, HeyzapIncentivzedCallback);
				IncentivizedAd.getInstance().addEventListener(HeyzapEvent.IS_AVAILABLE, HeyzapIncentivzedCallback);
				IncentivizedAd.getInstance().addEventListener(HeyzapEvent.FETCH_FAILED, HeyzapIncentivzedCallback);
				IncentivizedAd.getInstance().addEventListener(HeyzapEvent.IS_INCOMPLETE, HeyzapIncentivzedCallback);
				IncentivizedAd.getInstance().addEventListener(HeyzapEvent.IS_COMPLETED, HeyzapIncentivzedCallback);
			*/
			}
			static function HeyzapIncentivzedCallback(e:HeyzapEvent)
			{
				trace(e.type);
				
				var result:int = 0;
				
				if (e.type == HeyzapEvent.DID_FAIL) result = 1;
				if (e.type == HeyzapEvent.DID_HIDE) result = 1;
				if (e.type == HeyzapEvent.DID_SHOW) result = 2;
				if (e.type == HeyzapEvent.IS_INCOMPLETE) result = 1;
				if (e.type == HeyzapEvent.IS_COMPLETED) result = 2;
				if (e.type == HeyzapEvent.DID_CLICK) result = 2;
				
				
				if (result != 0)
				{
					IncentivizedAd.getInstance().fetch();
				}
				
				if (incentivizedCB != null)
				{
					IncentivizedAd_Respond(result,e.type);
				}
				
			}
			static function HeyzapVideoAdEventCB(e:HeyzapEvent)
			{
				
				trace(e.type);
				
				if (e.type == HeyzapEvent.DID_FAIL) VideoAd.getInstance().fetch();
				if (e.type == HeyzapEvent.DID_HIDE) VideoAd.getInstance().fetch();
				if (e.type == HeyzapEvent.DID_SHOW) VideoAd.getInstance().fetch();
				if (e.type == HeyzapEvent.IS_INCOMPLETE) VideoAd.getInstance().fetch();
				if (e.type == HeyzapEvent.IS_COMPLETED) VideoAd.getInstance().fetch();
				if (e.type == HeyzapEvent.DID_CLICK) VideoAd.getInstance().fetch();
			}
			static function HeyzapEventCB(e:HeyzapEvent)
			{
				trace(e.type);
				
				if (e.type == HeyzapEvent.DID_FAIL) InterstitialAd.getInstance().fetch();
				if (e.type == HeyzapEvent.DID_HIDE) InterstitialAd.getInstance().fetch();
				if (e.type == HeyzapEvent.DID_SHOW) InterstitialAd.getInstance().fetch();
				if (e.type == HeyzapEvent.IS_INCOMPLETE) InterstitialAd.getInstance().fetch();
				if (e.type == HeyzapEvent.IS_COMPLETED) InterstitialAd.getInstance().fetch();
				if (e.type == HeyzapEvent.DID_CLICK) InterstitialAd.getInstance().fetch();
				
			}
		}
		
		// 1 is fail, 2 is success
		if (PROJECT::useStage3D)
		{
			static function IncentivizedAd_Respond(result:int,s:String)
			{
				if (incentivizedCB == null) return;
				var aa:Function = incentivizedCB;
				incentivizedCB = null;
				if (result == 1)
				{
					
				aa(false,s);
				}
				if (result == 2)
				{
				aa(true,s);
				}
			}
		}

	}

}