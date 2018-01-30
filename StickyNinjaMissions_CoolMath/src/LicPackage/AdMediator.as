package LicPackage 
{
	import MobileSpecificPackage.MobileSpecific;
	/**
	 * ...
	 * @author ...
	 */
	public class AdMediator 
	{
		
		public function AdMediator() 
		{
			
		}
		
		public static var availableList:Vector.<int>;
		static var initialSkip:int;
		static var totalCount:int;
		static var totalServed:int;
		
		static var orderList:Vector.<int>;
		
		public static function InitOnce()
		{
			availableList = new Vector.<int>();
			orderList = new Vector.<int>();
			
			availableList.push(AdMediatorType.NONE);
			
			if (PROJECT::isAndroid)
			{
				if (PROJECT::isHeyzap)
				{
					availableList.push(AdMediatorType.HEYZAP);
				}
				if (PROJECT::isPlayHaven)
				{
					availableList.push(AdMediatorType.PLAYHAVEN);
				}
				if (PROJECT::isAppSponsor)
				{
					availableList.push(AdMediatorType.APPSPONSOR);
				}
				if (PROJECT::isRevMob)
				{
					availableList.push(AdMediatorType.REVMOB);
				}
				if (PROJECT::isAdBuddiz)
				{
					availableList.push(AdMediatorType.ADBUDDIZ);
				}
			}
			
			if (PROJECT::isAmazon)
			{
				
			}
			
			
			
			var adOrderList:Array = new Array();
			if (PROJECT::isHeyzap)
			{
				adOrderList.push(AdMediatorType.HEYZAP);
			}
			if (PROJECT::isAdBuddiz)
			{
				adOrderList.push(AdMediatorType.ADBUDDIZ);
			}
			if (PROJECT::isAppSponsor)
			{
				adOrderList.push(AdMediatorType.APPSPONSOR);
			}
			if (PROJECT::isRevMob)
			{
				adOrderList.push(AdMediatorType.REVMOB);
			}

			if (Game.isWildTangent)
			{
			}
			
			
			
			if (adOrderList.length == 0) return;

//			adOrderList = Utils.ShuffleIntList(adOrderList);

			for each(var type:int in adOrderList)
			{
				
				if (type == AdMediatorType.HEYZAP)
				{
					orderList.push(AdMediatorType.NONE);
					orderList.push(AdMediatorType.HEYZAP);
				}
				if (type == AdMediatorType.ADBUDDIZ)
				{
//					orderList.push(AdMediatorType.NONE);
//					orderList.push(AdMediatorType.NONE);
					orderList.push(AdMediatorType.ADBUDDIZ);
				}
				if (type == AdMediatorType.APPSPONSOR)
				{
//					orderList.push(AdMediatorType.NONE);
//					orderList.push(AdMediatorType.NONE);
					orderList.push(AdMediatorType.APPSPONSOR);
				}
				if (type == AdMediatorType.REVMOB)
				{
//					orderList.push(AdMediatorType.NONE);
//					orderList.push(AdMediatorType.NONE);
					orderList.push(AdMediatorType.REVMOB);
				}
			}
			
			if (orderList.length == 0) return;
			
			initialSkip = 0;
			
			totalCount = 0;
			totalServed = 0;
			
		}
		
		public static function ShuffleOrder(a:Vector.<int>, amount:int = 100):Vector.<int>
		{
			var len:int = a.length;
			for (var i:int = 0; i < amount; i++)
			{
				var p0:int = Utils.RandBetweenInt(0, len - 1);
				var p1:int = Utils.RandBetweenInt(0, len - 1);
				
				var x:int = a[p0];
				a[p0] = a[p1];
				a[p1] = x;				
			}
			return a;
		}
		
		
		public static function TestRewardAdAvailable():Boolean
		{
			if (PROJECT::useStage3D == false)
			{
				return true;
			}
			
			if (PROJECT::isAppSponsor)
			{
				return MobileSpecific.AppSponsor_IsIncentivizedReady();
			}
			
//			if (PROJECT::isHeyzap)
//			{
//				return MobileSpecific.Heyzap_IsIncentivizedAvailable();
//			}
			
			return false;
			
		}
		public static function ShowRewardAd(_cb:Function)
		{
			if (PROJECT::useStage3D == false)
			{
				_cb(true);
			}
			
//			if (PROJECT::isHeyzap)
//			{
//				MobileSpecific.Heyzap_ShowIncentivized(_cb);
//			}
			
			if (PROJECT::isAppSponsor)
			{
				if (MobileSpecific.AppSponsor_IsIncentivizedReady())
				{
					MobileSpecific.AppSponsor_ShowIncentivized(_cb);					
				}
				else
				{
					_cb(false);
				}
			}
			
			
			
		}
		public static function Update():Boolean
		{
			var doit:Boolean = false;
			
			if (orderList.length == 0) return false;
			
			if (totalCount < initialSkip)
			{
				totalCount++;
				trace("AdMediator INITIAL SKIPPED.  Count=" + totalCount);
				return false;
			}
			
			var i:int = totalCount - initialSkip;
			if (i < 0) i = 0;
			i %= orderList.length;
			
			var adType:int = orderList[i];
			totalCount++;
			
			if (adType != AdMediatorType.NONE)
			{
				totalServed++;
				
				if (adType == AdMediatorType.ADBUDDIZ)
				{
					if (PROJECT::isAdBuddiz)
					{
						MobileSpecific.AdBuddiz_ShowIntersitial();
						trace("AdMediator PLAYED AdBuddiz.  Count=" + totalCount);
					}
				}
				
				if (adType == AdMediatorType.PLAYHAVEN)
				{
					if (PROJECT::isPlayHaven)
					{
						MobileSpecific.PlayHaven_showIntersitial();
						trace("AdMediator PLAYED PLAYHAVEN.  Count=" + totalCount);
					}
				}
				
				if (adType == AdMediatorType.HEYZAP)
				{
					if (PROJECT::isHeyzap)
					{
						MobileSpecific.Heyzap_ShowIntersitial();
						trace("AdMediator PLAYED HEYZAP.  Count=" + totalCount);
					}
				}
				if (adType == AdMediatorType.APPSPONSOR)
				{
					if (PROJECT::isAppSponsor)
					{
						MobileSpecific.AppSponsor_ShowIntersitial();
						trace("AdMediator PLAYED APPSPONSOR.  Count=" + totalCount);
					}
				}
				if (adType == AdMediatorType.REVMOB)
				{
					if (PROJECT::isRevMob)
					{
						MobileSpecific.RevMob_ShowIntersitial();
						trace("AdMediator PLAYED REVMOB.  Count=" + totalCount);
					}
				}
				return true;

			}
			else
			{
				trace("AdMediator SKIPPED.  Count=" + totalCount);
				return false;
			}
		}
		
		
	}

}