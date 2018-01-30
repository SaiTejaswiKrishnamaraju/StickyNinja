package LicPackage 
{
	/**
	 * ...
	 * @author 
	 */
	public class OtherGamesData 
	{
		
		public function OtherGamesData() 
		{
			
		}

		
		public static function GetGamesList():Array
		{
			var otherGamesList:Array = new Array();
			otherGamesList.push( {button:"game1", name:"DriftRunners2", display:"Drift Runners 2",select:true} );
			otherGamesList.push( {button:"game2", name:"CoasterRacer", display:"Coaster Racer", select:true} );
			otherGamesList.push( {button:"game3", name:"DriftRunners1", display:"Drift Runners" ,select:false} );
			otherGamesList.push( { button:"game4", name:"NeonRace", display:"Neon Race" ,select:true} );
			
			otherGamesList.push( {button:"game5", name:"GunExpress", display:"Gun Express" ,select:true} );
			otherGamesList.push( {button:"game6", name:"HeatRush", display:"Heat Rush" ,select:true} );
			otherGamesList.push( {button:"game7", name:"CycloManiacs", display:"Cyclomaniacs" ,select:false} );
			otherGamesList.push( {button:"game8", name:"SoccerBalls", display:"Soccer Balls" ,select:false} );
			otherGamesList.push( {button:"game9", name:"Zombooka2", display:"Flaming Zombooka 2" ,select:false} );
			otherGamesList.push( {button:"game10", name:"Zombooka", display:"Flaming Zombooka" ,select:false} );
			
			otherGamesList.push( {button:"game11", name:"CycloManiacs2", display:"Cyclomaniacs 2" ,select:true} );
			otherGamesList.push( {button:"game12", name:"CoasterRacer2", display:"Coaster Racer 2" ,select:true} );
			otherGamesList.push( {button:"game13", name:"FormulaRacer", display:"Formula Racer" ,select:true} );
			otherGamesList.push( {button:"game14", name:"Zomgies2", display:"Zomgies 2" ,select:false} );
			otherGamesList.push( {button:"game15", name:"GrandPrixGo", display:"Grand Prix Go" ,select:true} );
			otherGamesList.push( {button:"game16", name:"BasketBalls", display:"Basket Balls" ,select:true} );
			otherGamesList.push( {button:"game17", name:"NinjaAcademy", display:"Sticky Ninja Academy" ,select:false} );
			otherGamesList.push( {button:"game18", name:"FlamingZombooka3", display:"Flaming Zombooka 3" ,select:false} );
			otherGamesList.push( {button:"game19", name:"Offroaders", display:"Offroaders" ,select:true} );
			otherGamesList.push( {button:"game20", name:"HotRod", display:"Rod Hots Hot Rods" ,select:true} );
			otherGamesList.push( {button:"game21", name:"NeonRace2", display:"Neon Race 2" ,select:true} );
			otherGamesList.push( {button:"game22", name:"BasketBallsLevelPack", display:"BasketBalls Lev Pack" ,select:true} );
			otherGamesList.push( {button:"game23", name:"FormulaRacer2012", display:"Formula Racer 2012" ,select:false} );
			otherGamesList.push( {button:"game24", name:"TokyoGuineaPop", display:"Tokyo Guinea Pop" ,select:false} );
			otherGamesList.push( {button:"game25", name:"TurboGolf", display:"Turbo Golf" ,select:false} );
			otherGamesList.push( {button:"game26", name:"DriftRunners3D", display:"Drift Runners 3D" ,select:true} );
			otherGamesList.push( {button:"game27", name:"V8MuscleCars", display:"V8 Muscle Cars" ,select:true} );
			otherGamesList.push( {button:"game28", name:"AmericanRacing", display:"American Racing" ,select:true} );
			otherGamesList.push( { button:"game29", name:"StreetRace", display:"Street Race" , select:true } );
			otherGamesList.push( { button:"game30", name:"CycloManiacsEpic", display:"CycloManiacs Epic" , select:false } );
			otherGamesList.push( { button:"game31", name:"SuperRally", display:"Super Rally" , select:true } );
			otherGamesList.push( { button:"game32", name:"CoasterRacer3", display:"CoasterRacer3" , select:true } );
			otherGamesList.push( { button:"game33", name:"SoccerBalls2LevelPack", display:"SoccerBalls 2LP" , select:true } );
			otherGamesList.push( { button:"game34", name:"HighwayOfTheDead", display:"Dead Highway" , select:true } );
			otherGamesList.push( { button:"game35", name:"TurboRally", display:"Turbo Rally" , select:true } );
			otherGamesList.push( { button:"game36", name:"AmericanRacing2", display:"American Racing 2" , select:true } );
			otherGamesList.push( { button:"game37", name:"HeatRushUSA", display:"Heat Rush USA" , select:true } );
			otherGamesList.push( { button:"game38", name:"Offroaders2", display:"Offroaders2" , select:true } );
			otherGamesList.push( { button:"game39", name:"GPGo2", display:"GPGo 2" , select:true } );
			otherGamesList.push( { button:"game40", name:"StreetRaceNitro", display:"StreetRace Nitro" , select:true } );
			otherGamesList.push( { button:"game41", name:"BlastDriver", display:"Blast Driver" , select:true } );
			otherGamesList.push( { button:"game42", name:"SuperCars", display:"Super Cars" , select:true } );
			otherGamesList.push( { button:"game43", name:"SuperBikes", display:"Super Bikes" , select:true } );
			otherGamesList.push( { button:"game44", name:"GrandTruckismo", display:"Grand Truckismo" , select:true } );
			
			return otherGamesList;
		}

		static function DoLinkFromName(name:String)
		{
			 //TURBONUKE
			 
			 /*
			if(name == "CycloManiacs") DoLink("http://www.turbonuke.com/games.php?game=Cyclomaniacs" ,"CycloManiacs");
			if(name == "Zombooka") DoLink("http://www.turbonuke.com/games.php?game=FlamingZombooka" ,"Zombooka");
			if(name == "SoccerBalls") DoLink("http://www.turbonuke.com/games.php?game=SoccerBalls" ,"SoccerBalls");
			if(name == "Zombooka2") DoLink("http://www.turbonuke.com/games.php?game=FlamingZombooka2" ,"Zombooka2");
			if(name == "CoasterRacer") DoLink("http://www.turbonuke.com/games.php?game=Coasterracer" ,"CoasterRacer");
			if(name == "SkiManiacs") DoLink("http://www.turbonuke.com/games.php?game=SkiManiacs" ,"SkiManiacs");
			if(name == "Toxers") DoLink("http://www.turbonuke.com/games.php?game=Toxers" ,"Toxers");
			if(name == "HarryQuantum") DoLink("http://www.turbonuke.com/games.php?game=HarryQuantum" ,"HarryQuantum");
			if(name == "DriftRunners1") DoLink("http://www.turbonuke.com/games.php?game=driftrunners","DriftRunners1");
			if(name == "DriftRunners2") DoLink("http://www.turbonuke.com/games.php?game=driftrunners2","DriftRunners2");
			if(name == "NeonRace") DoLink("http://www.turbonuke.com/games.php?game=neonrace" ,"NeonRace");
			if(name == "GunExpress") DoLink("http://www.turbonuke.com/games.php?game=GunExpress" ,"GunExpress");
			if(name == "HeatRush") DoLink("http://www.turbonuke.com/games.php?game=heatrush","HeatRush");
			
			if(name == "CycloManiacs2") DoLink("http://www.turbonuke.com/games.php?game=cyclomaniacs2" ,"CycloManiacs2");
			if(name == "CoasterRacer2") DoLink("http://www.turbonuke.com/games.php?game=CoasterRacer2" ,"CoasterRacer2");
			if(name == "FormulaRacer") DoLink("http://www.turbonuke.com/games.php?game=FormulaRacer" ,"FormulaRacer");
			if(name == "Zomgies2") DoLink("http://www.turbonuke.com/games.php?game=zomgies2" ,"Zomgies2");
			if(name == "CorporationInc") DoLink("http://www.kongregate.com/games/ArmorGames/corporation-inc","CorporationInc");
			if(name == "SovietGiraffe") DoLink("http://www.kongregate.com/games/ArmorGames/soviet-rocket-giraffe-go-go-go","SovietGiraffe");
			if(name == "EleQuest") DoLink("http://www.kongregate.com/games/ArmorGames/elephant-quest","EleQuest");
			if(name == "SushiCat2") DoLink("http://www.kongregate.com/games/ArmorGames/sushi-cat-2","SushiCat2");
			if(name == "GrandPrixGo") DoLink("http://www.turbonuke.com/games.php?game=GrandPrixGo" ,"GrandPrixGo");
			if(name == "SpacePunkRacer") DoLink("http://www.turbonuke.com/games.php?game=spacepunkracer" ,"SpacePunkRacer");
			if(name == "BasketBalls") DoLink("http://www.turbonuke.com/games.php?game=basketballs" ,"BasketBalls");
			if(name == "NinjaAcademy") DoLink("http://www.turbonuke.com/games.php?game=stickyninjaacademy" ,"NinjaAcademy");
			if(name == "FlamingZombooka3") DoLink("http://www.turbonuke.com/games.php?game=flamingzombooka3" ,"FlamingZombooka3");
			if(name == "Offroaders") DoLink("http://www.turbonuke.com/games.php?game=offroaders" ,"Offroaders");
			if(name == "HotRod") DoLink("http://www.turbonuke.com/games.php?game=HotRod" ,"HotRod");
			if(name == "NeonRace2") DoLink("http://www.turbonuke.com/games.php?game=neonrace2" ,"NeonRace2");
			if(name == "HarryQuantum2") DoLink("http://www.turbonuke.com/games.php?game=harryquantum2" ,"HarryQuantum2");
			if(name == "BasketBallsLevelPack") DoLink("http://www.turbonuke.com/games.php?game=basketballslevelpack" ,"BasketBallsLevelPack");
			if(name == "FormulaRacer2012") DoLink("http://www.turbonuke.com/games.php?game=formularacer2012" ,"FormulaRacer2012");
			if(name == "TokyoGuineaPop") DoLink("http://www.turbonuke.com/games.php?game=tokyoguineapop" ,"TokyoGuineaPop");
			if(name == "TurboGolf") DoLink("http://www.turbonuke.com/games.php?game=turbogolf" ,"TurboGolf");
			if(name == "DriftRunners3D") DoLink("http://www.turbonuke.com/games.php?game=driftrunners3d" ,"DriftRunners3D");
			if(name == "V8MuscleCars") DoLink("http://www.turbonuke.com/games.php?game=v8musclecars" ,"V8MuscleCars");
			if(name == "AmericanRacing") DoLink("http://www.turbonuke.com/games.php?game=americanracing" ,"AmericanRacing");
			if(name == "StreetRace") DoLink("http://www.turbonuke.com/games.php?game=streetrace" ,"StreetRace");
			
			if(name == "CycloManiacsEpic") DoLink("http://www.turbonuke.com/games.php?game=cyclomaniacsepic" ,"CycloManiacsEpic");
			if(name == "SuperRally") DoLink("http://www.turbonuke.com/games.php?game=superrallychallenge" ,"SuperRally");
			if(name == "CoasterRacer3") DoLink("http://www.turbonuke.com/games.php?game=coasterracer3" ,"CoasterRacer3");
			if(name == "SoccerBalls2LevelPack") DoLink("http://www.turbonuke.com/games.php?game=soccerballs2levelpack" ,"SoccerBalls2LevelPack");
			if(name == "HighwayOfTheDead") DoLink("http://www.turbonuke.com/games.php?game=highwayofthedead" ,"HighwayOfTheDead");
			if(name == "TurboRally") DoLink("http://www.turbonuke.com/games.php?game=turborally" ,"TurboRally");
			if(name == "AmericanRacing2") DoLink("http://www.turbonuke.com/games.php?game=americanracing2" ,"AmericanRacing2");
			if(name == "HeatRushUSA") DoLink("http://www.turbonuke.com/games.php?game=heatrushusa" ,"AmericanRacing2");
			if(name == "Offroaders2") DoLink("http://www.turbonuke.com/games.php?game=offroaders2" ,"Offroaders2");
			if(name == "GPGo2") DoLink("http://www.turbonuke.com/games.php?game=grandprixgo2" ,"GPGo2");
			if(name == "StreetRaceNitro") DoLink("http://www.turbonuke.com/games.php?game=streetrace2nitro" ,"StreetRace2Nitro");
			if(name == "BlastDriver") DoLink("http://www.turbonuke.com/games.php?game=blastdriver" ,"BlastDriver");
			if(name == "SuperCars") DoLink("http://www.turbonuke.com/games.php?game=supercarroadtrip" ,"SuperCars");
			if(name == "SuperBikes") DoLink("http://www.turbonuke.com/games.php?game=superbikestrackstars" ,"SuperBikes");
			if(name == "GrandTruckismo") DoLink("http://www.turbonuke.com/games.php?game=grandtruckismo" ,"GrandTruckismo");
*/
			
			// KONGREGATE
			if(name == "CycloManiacs") DoLink("http://www.kongregate.com/games/LongAnimals/cyclomaniacs" + LicDef.referralString,"othergames");
			if(name == "Zombooka") DoLink("http://www.kongregate.com/games/robotJAM/flaming-zombooka" + LicDef.referralString,"othergames");
			if(name == "SoccerBalls") DoLink("http://www.kongregate.com/games/turboNuke/soccer-balls" + LicDef.referralString,"othergames");
			if(name == "Zombooka2") DoLink("http://www.kongregate.com/games/turboNuke/flaming-zombooka-2" + LicDef.referralString,"othergames");
			if(name == "CoasterRacer") DoLink("http://www.kongregate.com/games/LongAnimals/coaster-racer" + LicDef.referralString,"othergames");
			if(name == "SkiManiacs") DoLink("http://www.kongregate.com/games/LongAnimals/ski-maniacs" + LicDef.referralString,"othergames");
			if(name == "Toxers") DoLink("http://www.kongregate.com/games/Rob_Almighty/toxers" + LicDef.referralString,"othergames");
			if(name == "HarryQuantum") DoLink("http://www.kongregate.com/games/LongAnimals/harry-quantum-tv-go-home" + LicDef.referralString,"othergames");
			if(name == "DriftRunners1") DoLink("http://www.kongregate.com/games/LongAnimals/drift-runners" + LicDef.referralString,"othergames");
			if(name == "DriftRunners2") DoLink("http://www.kongregate.com/games/LongAnimals/drift-runners-2" + LicDef.referralString,"othergames");
			if(name == "NeonRace") DoLink("http://www.kongregate.com/games/LongAnimals/neon-race" + LicDef.referralString,"othergames");
			if(name == "GunExpress") DoLink("http://www.kongregate.com/games/LongAnimals/gun-express" + LicDef.referralString,"othergames");
			if(name == "HeatRush") DoLink("http://www.kongregate.com/games/LongAnimals/heat-rush" + LicDef.referralString,"othergames");
			
			if(name == "CycloManiacs2") DoLink("http://www.kongregate.com/games/TurboNuke/cyclomaniacs-2" + LicDef.referralString,"othergames");
			if(name == "CoasterRacer2") DoLink("http://www.kongregate.com/games/LongAnimals/coaster-racer-2" + LicDef.referralString,"othergames");
			if(name == "FormulaRacer") DoLink("http://www.kongregate.com/games/TurboNuke/formula-racer" + LicDef.referralString,"othergames");
			if(name == "Zomgies2") DoLink("http://www.kongregate.com/games/LongAnimals/zomgies-2" + LicDef.referralString,"othergames");
			if(name == "CorporationInc") DoLink("http://www.kongregate.com/games/ArmorGames/corporation-inc" + LicDef.referralString,"othergames");
			if(name == "SovietGiraffe") DoLink("http://www.kongregate.com/games/ArmorGames/soviet-rocket-giraffe-go-go-go" + LicDef.referralString,"othergames");
			if(name == "EleQuest") DoLink("http://www.kongregate.com/games/ArmorGames/elephant-quest" + LicDef.referralString,"othergames");
			if(name == "SushiCat2") DoLink("http://www.kongregate.com/games/ArmorGames/sushi-cat-2" + LicDef.referralString,"othergames");
			if(name == "GrandPrixGo") DoLink("http://www.kongregate.com/games/TurboNuke/grand-prix-go" + LicDef.referralString,"othergames");
			if(name == "SpacePunkRacer") DoLink("http://www.kongregate.com/games/LongAnimals/space-punk-racer" + LicDef.referralString,"othergames");
			if(name == "BasketBalls") DoLink("http://www.kongregate.com/games/TurboNuke/basketballs" + LicDef.referralString,"othergames");
			if(name == "NinjaAcademy") DoLink("http://www.kongregate.com/games/LongAnimals/sticky-ninja-academy" + LicDef.referralString,"othergames");
			if(name == "FlamingZombooka3") DoLink("http://www.kongregate.com/games/TurboNuke/flaming-zombooka-3-carnival" + LicDef.referralString,"othergames");
			if(name == "Offroaders") DoLink("http://www.kongregate.com/games/TurboNuke/offroaders" + LicDef.referralString,"othergames");
			if(name == "HotRod") DoLink("http://www.kongregate.com/games/TurboNuke/rod-hots-hot-rod-racing" + LicDef.referralString,"othergames");
			if(name == "NeonRace2") DoLink("http://www.kongregate.com/games/LongAnimals/neon-race-2" + LicDef.referralString,"othergames");
			if(name == "HarryQuantum2") DoLink("http://www.kongregate.com/games/TurboNuke/harry-quantum-2" + LicDef.referralString,"othergames");
			if(name == "BasketBallsLevelPack") DoLink("http://www.kongregate.com/games/TurboNuke/basketballs-level-pack" + LicDef.referralString,"othergames");
			if(name == "FormulaRacer2012") DoLink("http://www.kongregate.com/games/TurboNuke/formula-racer-2012" + LicDef.referralString,"othergames");
			if(name == "TokyoGuineaPop") DoLink("http://www.kongregate.com/games/LongAnimals/tokyo-guinea-pop" + LicDef.referralString,"othergames");
			if(name == "TurboGolf") DoLink("http://www.kongregate.com/games/TurboNuke/turbo-golf" + LicDef.referralString,"othergames");
			if(name == "DriftRunners3D") DoLink("http://www.kongregate.com/games/LongAnimals/drift-runners-3d" + LicDef.referralString,"othergames");
			if(name == "MuscleCars") DoLink("http://www.kongregate.com/games/TurboNuke/v8-muscle-cars" + LicDef.referralString,"othergames");
			if(name == "AmericanRacing") DoLink("http://www.kongregate.com/games/TurboNuke/american-racing" + LicDef.referralString,"othergames");
			if(name == "SoccerBalls2") DoLink("http://www.kongregate.com/games/TurboNuke/soccer-balls-2" + LicDef.referralString,"othergames");
			
			if(name == "CycloManiacsEpic") DoLink("http://www.kongregate.com/games/turbonuke/cyclomaniacs-epic" ,"CycloManiacsEpic");
			if(name == "SuperRally") DoLink("http://www.kongregate.com/games/turboNuke/super-rally-challenge" ,"SuperRally");
			if(name == "CoasterRacer3") DoLink("http://www.kongregate.com/games/LongAnimals/coaster-racer-3" ,"CoasterRacer3");
			if(name == "SoccerBalls2LevelPack") DoLink("http://www.kongregate.com/games/turboNuke/soccer-balls-2-level-pack" ,"SoccerBalls2LevelPack");
			if(name == "HighwayOfTheDead") DoLink("http://www.kongregate.com/games/fightclub69/highway-of-the-dead" ,"HighwayOfTheDead");
			if(name == "TurboRally") DoLink("http://www.kongregate.com/games/turboNuke/turbo-rally" ,"TurboRally");
			if (name == "AmericanRacing2") DoLink("http://www.kongregate.com/games/turbonuke/american-racing-2" , "AmericanRacing2");
			
			if(name == "HeatRushUSA") DoLink("http://www.kongregate.com/games/LongAnimals/heat-rush-usa" ,"HeatRushUSA");
			if(name == "Offroaders2") DoLink("http://www.kongregate.com/games/turbonuke/offroaders-2" ,"Offroaders2");
			if(name == "GPGo2") DoLink("http://www.kongregate.com/games/turbonuke/grand-prix-go-2" ,"GPGo2");
			if(name == "StreetRaceNitro") DoLink("http://www.kongregate.com/games/fightclub69/street-race-2-nitro" ,"StreetRace2Nitro");
			if(name == "BlastDriver") DoLink("http://www.kongregate.com/games/turbonuke/blast-driver" ,"BlastDriver");
			if(name == "SuperCars") DoLink("http://www.kongregate.com/games/turboNuke/super-car-road-trip" ,"SuperCars");
			if(name == "SuperBikes") DoLink("http://www.kongregate.com/games/turboNuke/superbikes-track-stars" ,"SuperBikes");
			if(name == "GrandTruckismo") DoLink("http://www.kongregate.com/games/turboNuke/grand-truckismo" ,"GrandTruckismo");
			
		}
		
		static function DoLink(_url:String,_from:String)
		{
			OtherGames.DoLink(_url, _from);
		}
		
		
	}

}