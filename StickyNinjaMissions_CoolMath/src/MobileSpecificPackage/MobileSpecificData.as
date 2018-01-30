package MobileSpecificPackage 
{
	/**
	 * ...
	 * @author 
	 */
	
	 
	 // in C:\Users\Julian\AppData\Local\FlashDevelop\Apps\flexairsdk\4.6.0+4.0.0\bin\adt.bat
	 // in C:\Users\Julian\AppData\Local\FlashDevelop\Apps\flexairsdk\4.6.0+14.0.0\bin\adt.bat
	 //use: set _JAVA_OPTIONS=-Xms512m -Xmx512m -XX:MaxPermSize=512m
	 
	 
	public class MobileSpecificData 
	{

	public static var useAccelerometer:Boolean = true;
	
	//ratebox
	public static var RATEBOX_USETESTMODE:Boolean = false;
	public static var RATEBOX_TITLE:String = "Please rate Sticky Ninja Missions";
	public static var RATEBOX_TEXT:String = "If you're enjoying this, please give us 5 stars.";
	// ratebox end
	
	// ADMOB -------
	public static const ADMOB_PUBLISHER_ID_ANDROID_INTERSITIAL:String="ca-app-pub-5422913931615809/3583223398";	// INTERSITIAL correct for Dirt Bike Racing
	public static const ADMOB_PUBLISHER_ID_IOS_INTERSITIAL:String="ca-app-pub-5422913931615809/5293628992";	// INTERSITIAL correct for Dirt Bike Racing
	public static const ADMOB_PUBLISHER_ID_ANDROID:String="ca-app-pub-5422913931615809/2106490196";	// correct for Dirt Bike Racing
	public static const ADMOB_PUBLISHER_ID_IOS:String="ca-app-pub-5422913931615809/3816895793";	// correct for Dirt Bike Racing
	// admob end ---

	// PLAYHAVEN
	public static const PLAYHAVEN_IOS_PUBLISHER_TOKEN:String="52da0a292aea428a947396436182a662";		// correct for  DriveTown Taxi
	public static const PLAYHAVEN_IOS_PUBLISHER_SECRET:String="e24136ad6b4743b78b1f9c16c7966dba";		// correct for  DriveTown Taxi
	public static const PLAYHAVEN_ANDROID_PUBLISHER_TOKEN:String="7ed9f9e833e74499b6757795856f9726";	// correct for DriveTown Taxi
	public static const PLAYHAVEN_ANDROID_PUBLISHER_SECRET:String="76ded8fdbf954ce9b2b9797020064fad";	// correct for DriveTown Taxi
	// playhaven end
	
	
	public static const HEYZAP_PUBLISHER_ID:String="ddb7447ca578f56e50fe76fe01de3e6d";		// correct for LongAnimals games
//	public static const HEYZAP_PUBLISHER_ID:String="7ed32cbaa407f1e93bff908e65ab120f";		// correct for TurboNuke Games
	
	// APPSPONSOR
	public static const APPSPONSOR_ID_IOS:String="6BlymI7p2tkyx5dujJkdRw";		// correct for  Roller Rider
	public static const APPSPONSOR_ID_ANDROID:String="cVF3ltRqIZTFqSkrsrkUpQ";		// correct for StickyNinjaMissions
	public static const APPSPONSOR_ID_ANDROID_REWARD:String="vNehlvWeDosytEQzhNiJLQ";		// correct for StickyNinjaMissions

	// REVMOB
	public static const REVMOB_ID_IOS:String="---";		// correct for  
	public static const REVMOB_ID_ANDROID:String="53d694d3605407710804e11a";		// correct for MuscleCarParking

	// ADBUDDIZ
	public static const ADBUDDIZ_ID_IOS:String="---";		// correct for  
	public static const ADBUDDIZ_ID_ANDROID:String="f0679c15-4600-4453-9ae0-16c3adb65bb9";		// correct for StickyNinjaMissions
	
	// CHARTBOOST
	
	// These have to ve duplicated in the application_mobile.xml, for Android anyway
	public static const CHARTBOOST_ANDROID_APP_ID:String="53872cd889b0bb74411f07ec";	// correct for DirtBikeRacing
	public static const CHARTBOOST_ANDROID_APP_SIGNATURE:String="76ded8fdbf954ce9b2b9797020064fad";	// correct for DirtBikeRacing
	public static const CHARTBOOST_AMAZON_APP_ID:String="538736921873da028c6500f6";	// correct for DirtBikeRacing
	public static const CHARTBOOST_AMAZON_APP_SIGNATURE:String="6bb6b6cd97887863141174d25b3ab122c273bfe6";	// correct for DirtBikeRacing
	public static const CHARTBOOST_IOS_APP_ID:String="5387391a89b0bb7476913bdf";	// correct for DirtBikeRacing
	public static const CHARTBOOST_IOS_APP_SIGNATURE:String="6e5fe60271adc6c2854d3df7e647eff4b8b37e3a";	// correct for DirtBikeRacing
	
	public static const ANDROID_APP_ID:String = "524070457093";		// Correct for DirtBikeRacing
//	public static const ANDROID_PLAY:String = "A7:B9:8E:A6:46:35:D8:57:98:71:07:BB:59:4D:8E:1A:33:ED:C0:62";
	public static const ANDROID_LICENSE_KEY:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkrvWLBh9QggR9rJuhYdOrxxCEdFqxF13XbjK+3At58RN7OhvOy2c9X6Jv3NTqs086/uiZ+1bNZntvwA2SHNMooM4f6Roj+5GAS14c53pePFi+Tf9UHNHMFOE5U5pXmsTPjR/JqXXGMIZcByxZFaM35YRym03vfitjEjXJrPpcBLSwU10DQ1hG+1ZWUy6/BGSKHQD386QFXFOvuDkaSvGtze7bgxpb16HUJkRr1Y51rl6nHvkEzI3dASNYUcoLKae9UtuIE6WPzHj/4xM3cU9sSXi8JRIMWAAA6D4GlOVj+Soz8hoWFc4FkYP3V722SFLzuuP3t2c/ay8GR0FW64GPwIDAQAB";
	
//	public static const APPLE_ID:String="725299285";
	public static const FACEBOOK_APP_ID:String = "562266573893295";
	public static const FACEBOOK_APP_SECRET:String = "4071cd5e6571dfaada7e5008ac6fd586";
	
//	public static const EASYPUSH_AIRSHIP_KEY:String="gswqP0AhSkWGJg7CDaOckg";
//	public static const EASYPUSH_AIRSHIP_SECRET:String="kppXEO3RTza2_H9X4ISQfA";
//	public static const EASYPUSH_GCM_NUMBER:String="914088797152";
		
	
		
//define('FACEBOOK_APP_ID', '134042883303010');			// longanimals
//define('FACEBOOK_SECRET', 'd73522d7968981d8df3c6dff8ba2b19a');
//define('FACEBOOK_APP_ID', '142894202403665');		// local test
//define('FACEBOOK_SECRET', 'a614197dfb9339cbc2c35e7d2acdcd95');
		
		public function MobileSpecificData() 
		{
			
		}
		
	}

}