package UIPackage 
{
	import com.adobe.images.PNGEncoder;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import LicPackage.Lic;
	import LicPackage.LicAds;
	import LicPackage.LicDef;
	import LicPackage.OtherGames;
	/**
	 * ...
	 * @author LongAnimals
	 */
	public class UI_Walkthrough extends UIScreenInstance
	{
		
		public function UI_Walkthrough() 
		{
			
		}

		public override function ExitScreen()
		{
			/*
			if (adMC != null)
			{
				titleMC.removeChild(adMC);
				adMC = null;
			}
			*/
			
			UI.RemoveAllButtons();
			//UI.RemoveGeneric();
			
			
		}
		
		var page:int;
		
		var adMC:MovieClip;
		
		public override function InitScreen()
		{
			
			UI.StartAddButtons();
			
			titleMC = new MovieClip();	// screen_walkthroughMain();
			titleMC.gotoAndStop(1);
			
			Lic.MainLogoButton(titleMC.mainLogo);				
			Lic.AuthorButton(titleMC.turboBtn);
			
			UI.AddAnimatedMCButton(titleMC.prevPage, PrevPageClicked);
			UI.AddAnimatedMCButton(titleMC.nextPage, NextPageClicked);

			numPages = 4;
			
			InitPage();
			PopulatePage();
			
			
			return;
			/*
			adMC = null;
			if (LicDef.GetCurrentSku().showOtherGamesPanel)
			{
				adMC = OtherGames.GetOtherGamesMC(4, 1);
				adMC.x = 400;
				adMC.y = 365;
				adMC.scaleX = 0.6;
				adMC.scaleY = 0.6;
				titleMC.addChild(adMC);
			}
			*/
			
			
			page = 0;
			
			var spaceX:int = 8;
			var spaceY:int = 12;

			var numx:int = 10;
			var numy:int = 5;
			
			for (var y:int = 0; y < numy; y++)
			{
				for (var x:int = 0; x < numx; x++)
				{
					var i:int = x + (y * numx);
					if (i < Levels.list.length)
					{

						var w:WalkthroughScreen = Walkthrough.walkthroughScreens[i];
						
						
						var classRef:Class = getDefinitionByName("WalkthroughScreenshots") as Class;
						var mc:MovieClip = new classRef() as MovieClip;						
						mc.gotoAndStop(i + 1);
						
//						var mc:MovieClip = new MovieClip();
						mc.screenIndex = i;
						mc.x = 10 + (x * (w.thumbW+ spaceX));
						mc.y = 120 + (y * (w.thumbH + spaceY));
						titleMC.addChild(mc);
						
//						mc.addChild(w.thumbB);
						
						mc.useHandCursor = true;
						mc.buttonMode = true;
						
						mc.addEventListener(MouseEvent.CLICK, ScreenClicked, false, 0, true);
						mc.addEventListener(MouseEvent.MOUSE_OVER, ScreenOver, false, 0, true);
					}
					
				}
			}
			
			//SaveScreenshots();
		}
		
		
		var numPages:int;
		var numPerPage:int = 9;
		
		function InitPage()
		{
			icons = new Array();
			
			var ox:int = 145;
			var x:int = ox;
			var y:int =90;
			for (var i:int = 0; i < numPerPage; i++)
			{
				//var mc:levelIcon = new levelIcon();
				var mc:MovieClip = new MovieClip();
				titleMC.addChild(mc);
				mc.x = x;
				mc.y = y;
				mc.scaleX = 1.6;
				mc.scaleY = 1.6;
				UI.AddAnimatedMCButton(mc, levelPressed,null,false,levelHovered);

				x += 150;
				if (x > Defs.displayarea_w - 200)
				{
					x = ox;
					y += 130;
				}
				icons.push(mc);
			}


		}
		
		var selectedLevel:int;
		var icons:Array;
		
		function PopulatePage()
		{
			titleMC.prevPage.visible = true;
			titleMC.nextPage.visible = true;
			if(GameVars.currentWalkthroughPage == 0) titleMC.prevPage.visible = false;
			if(GameVars.currentWalkthroughPage == numPages-1) titleMC.nextPage.visible = false;
			
			
			var l0:int = GameVars.currentWalkthroughPage * numPerPage;
			var l1:int = l0 + (numPerPage-1);
			
			var mc:MovieClip;
			
			var index:int = 0 ;
			for (var i:int = l0; i <=l1; i++)
			{
				mc = icons[index];
				mc.visible = false;
				if (i < Levels.list.length)
				{
					mc.visible = true;
					var l:Level = Levels.GetLevel(i);
					mc.levelID = i;
					mc.levelNumber.text = int(i + 1).toString();
					
					if (Game.usedebug)
					{
						mc.textLevelCreator.text = l.creator;
					}
					else
					{
						mc.textLevelCreator.text = "";
					}
						
					
					mc.canPress = false;
					
					mc.coins.gotoAndStop(1);
					mc.gold.gotoAndStop(1);
					mc.gold.visible = false;
					mc.greystar.visible = false;
					mc.cup.visible = false;
					if (l.hasTrophy) mc.cup.visible = true;
					mc.cup.gotoAndStop(l.trophyIndex);

					mc.coinpercent.text = l.totalCoins;
					
					if (l.available)
					{
						mc.canPress = true;
//						mc.innerLevelClip.gotoAndStop(1);
						mc.levelNumber.visible = true;
					}
					else
					{
//						mc.innerLevelClip.gotoAndStop(2);
						mc.levelNumber.visible = true;
					}


					mc.gold.visible = false;
					if (l.rating > 0)
					{
						mc.gold.visible = true;
					}
					
					/*
					if (l.newlyAvailable)
					{
						mc.newIcon.visible = true;
						mc.newIcon.play();						
					}
					else
					{
						mc.newIcon.visible = false;
						mc.newIcon.stop();			
					}
					*/

					index++;
				}				
			}			
		}
		
		function PrevPageClicked(e:MouseEvent)
		{
			GameVars.currentWalkthroughPage--;
			if (GameVars.currentWalkthroughPage < 0) GameVars.currentWalkthroughPage = numPages - 1;
			PopulatePage();
		}
		function NextPageClicked(e:MouseEvent)
		{
			GameVars.currentWalkthroughPage++;
			if (GameVars.currentWalkthroughPage >= numPages) GameVars.currentWalkthroughPage = 0;
			PopulatePage();			
		}
		
		
		var currentScreenshot:int;
		function SaveScreenshots()
		{
			currentScreenshot = 0;
			SaveScreenshot();
		}
			
		function SaveScreenshot()
		{
			var w:WalkthroughScreen = Walkthrough.walkthroughScreens[currentScreenshot];
			
			var fr:FileReference = new FileReference();
			fr.addEventListener(Event.COMPLETE, SaveScreenshots_CB);
			
			var name:String = "screenshot_level_" + (currentScreenshot + 1)+".png";

			// pngs
			var ba:ByteArray = PNGEncoder.encode(w.thumbBD);
			fr.save(ba, name);
			
			Utils.print("saved level screenshot " + name);
			
			
		}
		
		function SaveScreenshots_CB(e:Event)
		{
			currentScreenshot++;
			if (currentScreenshot <50)
			{
				SaveScreenshot();
			}
		}
		
		
		function ScreenOver(e:MouseEvent)
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			Levels.currentIndex = mc.screenIndex;
			titleMC.textLevelName.text = Levels.GetCurrent().name;
		}
		function ScreenClicked(e:MouseEvent)
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			Levels.currentIndex = mc.screenIndex;
			UI.StartTransition("walkthrough_screen");
		}
		
		var adHolder:MovieClip;

		function levelHovered(e:MouseEvent)
		{
			var levelID:int = e.currentTarget.levelID;
			selectedLevel = levelID;
			var l:Level = Levels.GetLevel(selectedLevel);
			titleMC.textLevelName.text = l.name;			
		}
		function levelPressed(e:MouseEvent)
		{		
			var mc:MovieClip = e.currentTarget as MovieClip;
			Levels.currentIndex = mc.levelID;
			UI.StartTransition("walkthrough_screen");
		}
		
	}

}