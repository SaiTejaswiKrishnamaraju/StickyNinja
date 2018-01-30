package  
{
	/**
	 * ...
	 * @author 
	 */
	public class BikeDefs 
	{
		public static var list:Vector.<BikeDef>;
		public static var charList:Vector.<CharDef>;
		public static var bellList:Vector.<BellDef>;
		
		
		public function BikeDefs() 
		{
		}
		
		public static function InitOnce()
		{
			ResetEverything();
		}
		
		public static function ResetEverything()
		{
			bellList = new Vector.<BellDef>();
			
			bellList.push (new BellDef("bell_1", "Bell 1", "sfx_bell_1"));
			bellList.push (new BellDef("bell_2", "Bell 2", "sfx_bell_2"));
			bellList.push (new BellDef("bell_3", "Bell 3", "sfx_bell_3"));
			bellList.push (new BellDef("bell_4", "Bell 4", "sfx_bell_4"));
			bellList.push (new BellDef("bell_5", "Bell 5", "sfx_bell_5"));
			bellList.push (new BellDef("bell_6", "Bell 6", "sfx_bell_6"));
			bellList.push (new BellDef("bell_7", "Bell 7", "sfx_bell_7"));
			bellList.push (new BellDef("bell_8", "Bell 8", "sfx_bell_8"));
			bellList.push (new BellDef("bell_9", "Bell 9", "sfx_bell_9"));
			bellList.push (new BellDef("bell_10", "Bell 10", "sfx_bell_10"));
			
			for (var i:int = 0; i < bellList.length; i++)
			{
				bellList[i].index = i;
			}
			
			charList = new Vector.<CharDef>();
			list = new Vector.<BikeDef>();
			var cd:CharDef;
			var bd:BikeDef;
			
			for (var i:int = 0; i < 31; i++)
			{
				cd = new CharDef();
				cd.index = i;
				cd.name = "char" + i;	
				charList.push(cd);
			}			
			
			var x:XML = ExternalData.VehiclesXML;
			var numV:int = x.bikedef.length();
			
			for (var i:int = 0; i < numV; i++)
			{
				bd = new BikeDef();
				bd.InitFromXML(x.bikedef[i]);
				bd.name = "bike_" + i;	
				bd.index = i;
				list.push(bd);
			}
			
// ----- PASTE IN HERE ------

			charList[0].Setup("robotjam","robo","RobotJAM",1,38,2,38,38,35,15,"No Cyclomaniacs game would be complete without a robotjam, it saves time on coming up with something original. And here he is again.");
			charList[1].Setup("cycloking","cycloking","Cyclo King",1,15,37,24,4,3,20,"Cycloking has left the building to compete in yet another ridiculously large cycling stunt game. Thank you very much.");
			charList[2].Setup("reaper","reaper","Reaper",1,20,15,26,40,14,15,"Mr reaper, or grimm to his friends, part time bank manager, part time cyclist and US PGB golf winner 1689.");
			charList[3].Setup("guinea_pop","guineaPop","Guinea Pop",1,29,24,28,18,25,10,"Powered by bubblegum and samba, guinea's main quest in life is to find a new papa.");
			charList[4].Setup("phenonix","phenonix","Phenonix",1,27,8,33,10,12,4,"Pheonix Penguin, or as he's called THe emperor, leader of the galactic Empire... erm  often has palpitations at the start of a race.");
			charList[5].Setup("ricky_roll","rickyRoll","Ricky Roll",1,0,2,15,23,34,3,"Richard Roll, He knows all the rules of cycling, and hes gotta make you understand them but you is too blind to see, fool. ");
			charList[6].Setup("princess_jennifer","princessJennifer","Princess Jen",1,7,3,25,23,20,28,"Rescued from The clutches of Longanimals and robotJAm in cyclo 2, yes she's back, and we don't have anything interesting to say about her.");
			charList[7].Setup("longanimals","longanimals","LongAnimals",1,37,24,13,23,16,13,"LongAnimals is the meanest coding stoat/weasel/ferret in the galaxy. So powerful he can even delete a recycle bin.");
			charList[8].Setup("barry_zooka","barryZooka","Barry Zooka",1,28,0,11,2,12,19,"Barry while not zooking zombies has set the world record for cycling, on a bike with no chain.");
			charList[9].Setup("the_big_g","theBigG","The Big G",1,26,39,28,31,4,10,"The big G's back, and I have run out of things to say. Except he is so talented he can hop on 1 leg.");
			charList[10].Setup("bob_bullet","bobBullet","Bob Bullet",0,58,40,59,39,39,50,"Cockney Bob Bullet, while he's not in the dog and duck is so hard he can pull a wheelie on a unicycle.");
			charList[11].Setup("chaz_van_stone","chaz","Chaz Van Stone",0,41,68,55,61,63,64,"Chaz, the world's hardest man, when he pedals the earth spins not his wheels.");
			charList[12].Setup("idaho","idaho","Russ Idaho",0,65,56,45,34,64,45,"Dr Russ Idaho, archeryologist, likes to Tango in New York and presently in Big trouble over some THINg or other.");
			charList[13].Setup("captain_crow","captCrow","Captain Crow",0,44,55,57,42,39,57,"Capt Crow would be great at cycling if it wasn't for her bike being in 8 peices. She won a silver at the world championships in her long johns. ");
			charList[14].Setup("donald","donald","Donald",0,32,52,37,61,32,62,"The Donald as he likes to be called is the grand daddy of cycloing, a rider who definitely deserves respect, although don't refuse his offer of a bike service.");
			charList[15].Setup("tommy_pistol","tommyPistol","Tommy Pistol",0,41,44,69,48,47,47,"He wears a fedora to cycle in, but when relaxing he's often seen with his friend Al's cap on.");
			charList[16].Setup("sarge","sarge","Sarge",0,32,49,32,45,30,66,"Listen up Maggots, the Sarge is one mean walrus of a rider, the marine corps finest rider. SIR YES SIR. ");
			charList[17].Setup("private","private","Private",0,69,36,47,32,37,38,"Private likes to be on parade. He'll keep on cycling for his country. He doesn't know he's haddock fodder.");
			charList[18].Setup("dave_5000","dave5000","DVE 5000",0,52,56,67,31,36,70,"DVE is the latest generation of super bike computers, hates human error in his programming and is most unhelpful but is definitely on a mission to win.");
			charList[19].Setup("captain_clunk","captKlunk","Capt Klunk",0,53,35,52,57,38,58,"Captain Klunk a bold cyclist on a mission to seek out new tracks. He can often be seen cycling in bare chested cycling races while kissing green ladies.");
			charList[20].Setup("harry_fang","werewolf","Harry Fang",0,63,82,94,86,87,62,"Harry a fangtastic cyclist trains mainly in london and out on the moors, he likes nothing better than a nice pint in the Lamb Kebab Inn .");
			charList[21].Setup("the_girls","twins","The Girls",2,70,72,62,70,85,72,"The tandem cyclings were worlds winter cycling champions and even beat the horse Red RUM in a race they were that fast, they are very dull girls though.");
			charList[22].Setup("lady_jane","ladyJane","Lady Jane",0,95,81,100,96,75,71,"The lady actually loves cycling, and shows great pride in her riding. likes to make a drama of every race and like being beaten by no one, period.");
			charList[23].Setup("mutton","mutton","Mr. Mutton",0,81,69,77,99,92,94,"Mr Mutton, the rider from the future, take great pride in his kit which is in a sense tweed, very sensible.");
			charList[24].Setup("sister","sister","Sister",0,80,89,100,67,64,94,"THe Hills are alive with the sound of her pedalling, she is the greatest cyclist in the world bar nun.");
			charList[25].Setup("rod_hot","rodHot","Rod Hot",0,67,90,81,94,77,90,"Rod, disco dancing champion, is often in a cycling fever on a saturday night, only his greased lightening reactions help him stay alive.");
			charList[26].Setup("sherrif","sheriff","Sheriff",0,66,92,76,68,62,65,"The sheriff sure showed some grit to win his first seven races in Magnificent style it's true. His saddle literally blazed over the finish line in Oklahoma.");
			charList[27].Setup("el_guapo","elGuapo","El Guapo",0,89,91,85,77,60,71,"He has a plethora of cycling talents, both good and bad, he also likes to drift high on the desert plains.");
			charList[28].Setup("trojan","trojan","Timmy Trojan",0,60,87,94,88,66,74,"I am trojan, he says every time he wins, Timmy a true dark horse. Hec he even likes a Tor on his bike around paris.");
			charList[29].Setup("cleo","cleo","Cleo Patra",0,84,62,69,87,87,78,"Cleo has a lovely milky white asp, and she will show it to you for payment of only 7 needles");
			charList[30].Setup("haddock","haddock","The Haddock",1,38,2,38,38,35,15,"description");
			
//			list[0].Setup("1","1",1,0,160,1410,30,702,5,-44,16,1,1,1,46,18,1,0,1,0,26.25,7,5,26.25,0,5);
//			list[1].Setup("2","2",2,3,360,2080,28,545,4,-35,16,2,0,1,40,15,2,0,1,0,26.25,2,5.25,25.5,0,5.5);
//			list[2].Setup("3","3",3,1,340,2230,27,555,4,-42,18,3,0,1,51,18,3,0,1,0,29,1,5.25,28.25,1,5.5);
//			list[3].Setup("4","4",4,1,250,1490,28,395,4,-39,20,4,0,1,45,21,4,0,1,0,25.25,-1,5,23.5,1,5.5);
//			list[4].Setup("5","5",5,1,405,2045,30,585,4,-37,22,5,0,1,45,22,5,0,1,0,31.5,3,4.6,28.25,0,4.5);
//			list[5].Setup("6","6",6,1,300,1000,26,573,5,-48,19,6,0,1,47,20,5,0,1,0,26,2,5,27.25,1,5.25);
//			list[6].Setup("7","7",7,1,115,2585,30,451,3.34,-48,16,7,0,1,51,16,6,0,1,0,22.75,-1,5,25.5,3,4.75);
//			list[7].Setup("8","8",8,1,140,675,30,657,6,-43,19,8,0,1,53,17,8,0,1,0,26.5,0,5.5,25.25,1,5.5);
			
/// PASTE ENDS HERE
			
			if (false)	// initial set up
			{
				for (var i:int = 0; i < 3; i++ )
				{
					for (var j:int = 0; j < 10; j++)
					{
						cd = charList[(i * 10) + j];
						
						var base:int = 0;	// Utils.ScaleTo(10, 90, 0, 29, i);
						if (i == 0) base = 20;
						if (i == 1) base = 50;
						if (i == 2) base = 80;
						var offset:int = 20;
						
						cd.skills[0] = base + Utils.RandBetweenInt( -offset, offset);
						cd.skills[1] = base + Utils.RandBetweenInt( -offset, offset);
						cd.skills[2] = base + Utils.RandBetweenInt( -offset, offset);
						cd.skills[3] = base + Utils.RandBetweenInt( -offset, offset);
						cd.skills[4] = base + Utils.RandBetweenInt( -offset, offset);
						cd.skills[5] = base + Utils.RandBetweenInt( -offset, offset);
					}			
				}
			}
			if (false)	// set up stunt types
			{
				var a:Array = new Array();
				var b:int = 1;
				for (var i:int = 0; i < 60; i++)
				{
					a.push(b);
					b++;
					if (b > Stunts.STUNT_MAX)
					{
						b = 1;
					}
				}
				a = Utils.ShuffleIntList(a, 5000);
				a[0] = Stunts.STUNT_NONE;
				
				for (var i:int = 0; i < 60; i++)
				{
					list[i].specialStunt = a[i];
				}
			}
			
			if (false)	// generate some random task order
			{
				trace("-----------------------------------------------------------------------------");
				for (var i:int = 0; i < 10; i++)
				{
					var a:Array = new Array();
					a.push("back_rolls=1");
					a.push("total_back_rolls=1");
					a.push("front_rolls=1");
					a.push("total_front_rolls=1");
					a.push("air_time=10");
					a.push("total_air_time=10");
					a.push("perfect_landings=1");
					a.push("total_perfect_landings=1");
					a.push("front_wheelie=1");
					a.push("total_front_wheelie=1");
					a.push("back_wheelie=1");
					a.push("total_back_wheelie=1");
					a.push("upside_down=10");
					a.push("total_upside_down=10");
					a.push("highest_boost=10");
					a.push("full_boost_time=10");
					a.push("pickups=100");
					a.push("dont_crash");
					a.push("total_stunts=10");
					a.push("total_jumps=10");
					a.push("highest_point=100");
					a = Utils.RandomiseArray(a, 10000);
					for each(var s:String in a)
					{
						trace(s);
					}
				}
				trace("-----------------------------------------------------------------------------");
				
			}


		}
		
		public static function GetByIndex(index:int):BikeDef
		{
			return list[index];
		}
		public static function GetCharByIndex(index:int):CharDef
		{
			return charList[index];
		}
		public static function GetBellByIndex(index:int):BellDef
		{
			if (index < 0) index = 0;
			return bellList[index];
		}
		public static function GetCharByName(name:String):CharDef
		{
			for each(var charDef:CharDef in charList)
			{
				if (charDef.name == name) return charDef;
			}
			return null;
		}
		
		
	}

}
