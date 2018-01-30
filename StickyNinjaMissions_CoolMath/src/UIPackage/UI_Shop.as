package UIPackage 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class UI_Shop extends UIScreenInstance
	{
		
		public function UI_Shop() 
		{
			
		}
		
		public override function ExitScreen()
		{
			UIX.StopPage(titleMC,pageInst);
		}
		
		public override function InitScreen()
		{
			titleMC = new MovieClip();
			uix_pageName = "page_upgrades";
			pageInst = UIX.StartPage(titleMC, uix_pageName);
			
			UIX.AddAnimatedButton(pageInst.Child("btn_back"), UIX_buttonBackPressed);			
			UIX.AddAnimatedButton(pageInst.Child("buttonNext"), UIX_buttonNextPressed);			
			
//			GameVars.cash = 10000000;
			
/*
			AddUpgradeBar(1);
			AddUpgradeBar(2);
			AddUpgradeBar(3);
			
			var button:UIX_Instance = pageInst.Child("upgradeButton0");
			button.userData.buttonID = 0;
			UIX.AddAnimatedButton(button, upgradePressed);
			
			UpdateUpgrades();
			*/
		}
		
		
		
		function UpdateUpgrades()
		{
			for (var num:int = 1; num <= 3; num++)
			{
				var bar:UIX_Instance = pageInst.Child("upgradeBar" + num);
				var cost:UIX_Instance = pageInst.Child("cost" + num);
				
				var level:int = GameVars.upgradeLevels[num];
				for (var i:int = 0; i < 8; i++)
				{
					var blob:UIX_Instance = bar.Child("blob" + i);
					blob.frame = i + 1;
					
					if (i >= level) 
					{
						blob.frame = 0;
					}
					blob.gameObj.frame = blob.frame;
				}
				
				cost.SetText("$" + GameVars.GetUpgradePrice(num));
				if (level == 8)
				{
					cost.SetText("");
				}
			}
			
			
			var cost0:UIX_Instance = pageInst.Child("cost0");
			cost0.SetText("$" + GameVars.GetUpgradePrice(0));
			
//			pageInst.Child("currentCar").frame = GameVars.upgradeLevels[0];
			
			pageInst.Child("carUpgrades").visible = false;
			pageInst.Child("cost0").visible = false;
			pageInst.Child("nextCar").visible = false;
			pageInst.Child("upgradeButton0").visible = false;
			if (GameVars.upgradeLevels[0] != 15)
			{
				pageInst.Child("nextCar").frame = GameVars.upgradeLevels[0] + 1;
				pageInst.Child("nextCar").visible = true;
				pageInst.Child("upgradeButton0").visible = true;
				pageInst.Child("cost0").visible = true;
				
				pageInst.Child("carUpgrades").visible = true;
			}
			
			
			
			for (var i:int = 0; i < 4; i++)
			{
				if (GameVars.cash < GameVars.GetUpgradePrice(i))
				{
					pageInst.Child("upgradeButton"+i).button_canPress = false;
					pageInst.Child("upgradeButton"+i).blackout = true;
				}
				if (GameVars.GetUpgrade(i) >= GameVars.GetUpgradeMax(i))
				{
					pageInst.Child("upgradeButton"+i).button_canPress = false;
					pageInst.Child("upgradeButton"+i).blackout = true;
				}
			}

			
			pageInst.Child("cashBox.textCash").SetText(GameVars.cash.toString());
			
		}
		
		
		
		function AddUpgradeBar(num:int)
		{
			var button:UIX_Instance = pageInst.Child("upgradeButton" + num);
			var bar:UIX_Instance = pageInst.Child("upgradeBar" + num);
			var cost:UIX_Instance = pageInst.Child("cost" + num);
			
//			pageInst.gameObjects.AddInstance(pageInst.Child("buttonGooglePlay.free")).InitScaleWobble();
			
			for (var i:int = 0; i < 8; i++)
			{
				var blob:UIX_Instance = bar.Child("blob" + i);
				blob.gameObj = pageInst.gameObjects.AddInstance(blob);
			}
			
			
			button.userData.buttonID = num;
			UIX.AddAnimatedButton(button, upgradePressed);
		}
		
		function upgradePressed(inst:UIX_Instance)
		{
			var num:int = inst.userData.buttonID;
			trace("pressed " + num);
			
			if (num == 0)	// cars
			{
				if (GameVars.cash >= GameVars.GetUpgradePrice(num))
				{
					GameVars.cash -= GameVars.GetUpgradePrice(num);
					GameVars.upgradeLevels[num]++;
					
					GameVars.playerBikeDefIndex = GameVars.upgradeLevels[GameVars.UPGRADE_CAR];
					
//					if (GameVars.upgradeLevels[num] >= 16) GameVars.upgradeLevels[num] = 0;
				}
				
			}
			else
			{
				if (GameVars.cash >= GameVars.GetUpgradePrice(num))
				{
					GameVars.cash -= GameVars.GetUpgradePrice(num);
					GameVars.upgradeLevels[num]++;

					var bar:UIX_Instance = pageInst.Child("upgradeBar" + num);
					
					var l:int = GameVars.upgradeLevels[num]-1;
					var blob:UIX_Instance = bar.Child("blob" + l);
					if (blob != null)
					{
						blob.gameObj.InitTrophyAppear(0);
					}
				}
			}
			UpdateUpgrades();
		}
		
		function UIX_buttonBackPressed(inst:UIX_Instance)
		{
			SaveData.Save();			
			UI.StartTransition("title");
		}
		function UIX_buttonNextPressed(inst:UIX_Instance)
		{
			SaveData.Save();			
			UI.StartTransition("title");
//			UI.StartTransition("matchselect");
		}
		
//_-----------------------------------------------------------------------------------------------------		
//_-----------------------------------------------------------------------------------------------------		
		
		
		
		
		
		
		
	}


}