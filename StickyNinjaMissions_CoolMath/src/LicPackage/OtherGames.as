package LicPackage 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Julian
	 */
	public class OtherGames 
	{
	
		public function OtherGames() 
		{
			
		}
		static var otherGamesList:Array;
		public static var currentPage:String = "";
		
		public static function GetOtherGamesMC(amount:int=4,type:int=0):MovieClip
		{
			

			if (type == 0)
			{
				var classRef_otherGamesMC:Class = getDefinitionByName("otherGamesMC") as Class;
				var mc:MovieClip = new classRef_otherGamesMC() as MovieClip;
			}
			if (type == 1)
			{
				var classRef_otherGamesMC_TitleScreen:Class = getDefinitionByName("otherGamesMC_TitleScreen") as Class;
				mc = new classRef_otherGamesMC_TitleScreen() as MovieClip;
			}
			if (type == 2)	// button list 
			{
				var classRef_otherGamesTextMC:Class = getDefinitionByName("otherGamesTextMC") as Class;
				mc = new classRef_otherGamesTextMC() as MovieClip;
				amount = 4;
			}
			if (type == 3)	// pause screen
			{
				var classRef_otherGamesMC_PauseScreen:Class = getDefinitionByName("otherGamesMC_PauseScreen") as Class;
				mc = new classRef_otherGamesMC_PauseScreen() as MovieClip;
			}
			
			if (LicDef.AreOtherGamesAdsAllowed())
			{
				otherGamesList = OtherGamesData.GetGamesList();
				
				var positions:Array = new Array();
				
				var list:Array = new Array();
				for (var i:int = 0; i < otherGamesList.length; i++)
				{
					if (otherGamesList[i].select == true)
					{
						list.push(i);
					}
				}
				list = ShuffleIntList(list,500);
				
				
				if (type == 2)
				{
					for (var i:int = 0; i < amount; i++)
					{
						var o:Object = otherGamesList[i];
						var ro:Object = otherGamesList[list[i]];
						
						var button:MovieClip = mc.getChildByName("game" + int(i + 1)) as MovieClip;
						button.nameText.text = ro.display;
						button.useHandCursor = true;
						button.buttonMode = true;
						button.linkName = ro.name;
						button.addEventListener(MouseEvent.CLICK, OtherGamesPanel_ClickGameText);
					}
					
				}
				else
				{
					for each(var o:Object in otherGamesList)
					{
						mc[o.button].visible = false;
						positions.push(new Point(mc[o.button].x, mc[o.button].y));
					}
				
					for (var i:int = 0; i < amount; i++)
					{
						var o:Object = otherGamesList[i];
						var ro:Object = otherGamesList[list[i]];
						
						mc[ro.button].visible = true;
						mc[ro.button].x = positions[i].x;
						mc[ro.button].y = positions[i].y;		
						var buttonMC:MovieClip = mc[ro.button];
						LicUI.AddMCButton(buttonMC, OtherGamesPanel_ClickGame,null,OtherGamesPanel_Hover,OtherGamesPanel_Out);
						buttonMC.nameHolder.visible = false;
					}
				}
			
				return mc;
			}
			return null;
		}
		
		static function OtherGamesPanel_Hover(e:MouseEvent)
		{
			var buttonMC:MovieClip = e.currentTarget as MovieClip;
			buttonMC.nameHolder.visible = true;
		}
		static function OtherGamesPanel_Out(e:MouseEvent)
		{
			var buttonMC:MovieClip = e.currentTarget as MovieClip;
			buttonMC.nameHolder.visible = false;
		}
		
		public static function RandBetweenInt(r0:int,r1:int):int
		{
			var r:int = Math.random() * ((r1-r0)+1);
			r += r0;
			return r;
		}
		
		static function ShuffleIntList(a:Array, amount:int = 100):Array
		{
			var len:int = a.length
			for (var i:int = 0; i < amount; i++)
			{
				var p0:int = RandBetweenInt(0, len - 1);
				var p1:int = RandBetweenInt(0, len - 1);
				
				var x:int = a[p0];
				a[p0] = a[p1];
				a[p1] = x;				
			}
			return a;
		}

		
		public static function DoLink(_url:String,_from:String)
		{
			Lic_DoLink(_url, currentPage,_from);
//			navigateToURL(new URLRequest(_url), "_blank");
		}
		
		static function OtherGamesPanel_ClickGameText(e:MouseEvent)
		{
			var name:String = e.currentTarget.linkName;
			OtherGamesData.DoLinkFromName(name);
		}
		
		
		static function OtherGamesPanel_ClickGame(e:MouseEvent)
		{
			
			var name:String = e.currentTarget.name;
			
			var str:String = name.substr(4);
			var id:int = int(str);
			
			var buttonO:Object = null;
			
			for each(var o:Object in otherGamesList)
			{
				if (o.button == name) buttonO = o;
			}
			
			OtherGamesData.DoLinkFromName(buttonO.name);
		}

		public static function Lic_DoLink(linkStr:String,_fromPage:String="unknown_frompage_DoLink",_extra:String="DoLink_Extra_Undefined")
		{
			var s:String = linkStr;
			
			if (LicDef.GetLicensor() == LicDef.LICENSOR_TURBONUKE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE || LicDef.GetLicensor() == LicDef.LICENSOR_KONGREGATE_ONSITE || LicDef.GetLicensor() == LicDef.LICENSOR_PRUMPA )
			{
				var qfound:Boolean = false;
				for (var i:int = 0; i < s.length; i++)
				{
					if (s.charAt(i) == "?") qfound = true;
				}
				if (qfound)
				{
					s += LicDef.referralStringAnd;
				}
				else
				{
					s += LicDef.referralString;
				}
			}
			Tracked_Link(s, _fromPage,_extra);
		}
		public static function Tracked_Link(_url:String, _pageName:String,_extra:String):void
		{
			navigateToURL(new URLRequest(_url), "_blank");
			Tracking.LogLink(_url,_pageName,_extra);			
		}
		
	}

}