<?php

function DB_ConnectUser()
{

	$server= "www.turbonuke.com";     // Address of 1&1 database server
	$user= "db_genericruns";                   // db-username
	$password= "db_genericruns";              // db-Password
	$database= "db_genericruns";             // name of database
	$table= "tbl_runs";                // Name of table, you can select that 
	MYSQL_CONNECT($server, $user, $password) or die ( "<H3>Server unreachable</H3>");
	MYSQL_SELECT_DB($database) or die ( "<H3>Database non existent</H3>");
}

function DB_ConnectAdmin()
{

	$server= "www.turbonuke.com";     // Address of 1&1 database server
	$user= "db_genericruns";                   // db-username
	$password= "db_genericruns";              // db-Password
	$database= "db_genericruns";             // name of database
	$table= "tbl_runs";                // Name of table, you can select that 
	MYSQL_CONNECT($server, $user, $password) or die ( "<H3>Server unreachable</H3>");
	MYSQL_SELECT_DB($database) or die ( "<H3>Database non existent</H3>");
}


function DB_Disconnect()
{
	// Close SQL-connection 
	MYSQL_CLOSE();
}


	$func = $_GET["func"];
	if($func == "DeleteByID") DeleteByID();
	if($func == "GetRaceDataByID") GetRaceDataByID();
	if($func == "GetRaceDataByIDs") GetRaceDataByIDs();
	if($func == "GetAllRaceData") GetAllRaceData();
	if($func == "GetRunByID") GetRunByID();
	if($func == "GetCamRecByID") GetCamRecByID();
	if($func == "GetCamRecDataByLatest") GetCamRecDataByLatest();
	if($func == "GetLatestID") GetLatestID();
	if($func == "GetIdsByTrack") GetIdsByTrack();
	if($func == "GetRaceDataByTrack") GetRaceDataByTrack();
	if($func == "GetRaceDataByTrack_MinMaxTimes") GetRaceDataByTrack_MinMaxTimes();
	if($func == "GetRaceDataByTrack_BestTimes") GetRaceDataByTrack_BestTimes();
	if($func == "GetRaceDataByTrack_UserIDList") GetRaceDataByTrack_UserIDList();
	if($func == "GetIdsByTrackTimed") GetIdsByTrackTimed();
	if($func == "GetRaceDataByTrack_Random") GetRaceDataByTrack_Random();
	if($func == "GetRaceDataByTrack_BikeList") GetRaceDataByTrack_BikeList();



function GetRaceDataByTrack()
{
	DB_ConnectUser();
	$level_id = 0;
	$level_id = $_GET["levelid"];
	$version = 0;
	$version = $_GET["version"];

	$result = mysql_query("SELECT id,player_name,time,bike_id,bell_id,level_id,user_id FROM tbl_runs WHERE level_id='$level_id' AND version='$version' ORDER BY RAND() LIMIT 5");

	echo("levels=");
	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  $player_name =  $row['player_name'];
	  $time =  $row['time'];
	  $bike_id =  $row['bike_id'];
	  $bell_id =  $row['bell_id'];
	  $level_id =  $row['level_id'];
	  $user_id =  $row['user_id'];

		echo($id);
		echo(",");
		echo($player_name);
		echo(",");
		echo($time);
		echo(",");
		echo($bike_id);
		echo(",");
		echo($bell_id);
		echo(",");
		echo($level_id);
		echo(",");
		echo($user_id);
		echo(",");

	}
	DB_Disconnect();

}

function DeleteByID()
{
	DB_ConnectUser();
	$race_id = 0;
	$race_id = $_GET["raceid"];
	$version = 0;

	$result = mysql_query("DELETE FROM tbl_runs WHERE id='$race_id'");

	DB_Disconnect();
}

function GetRaceDataByID()
{
	DB_ConnectUser();
	$race_id = 0;
	$race_id = $_GET["raceid"];
	$version = 0;
	$version = $_GET["version"];

	$result = mysql_query("SELECT id,player_name,time,bike_id,bell_id,level_id,user_id FROM tbl_runs WHERE id='$race_id' AND version='$version'");

	echo("levels=");
	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  $player_name =  $row['player_name'];
	  $time =  $row['time'];
	  $bike_id =  $row['bike_id'];
	  $bell_id =  $row['bell_id'];
	  $level_id =  $row['level_id'];
	  $user_id =  $row['user_id'];

		echo($id);
		echo(",");
		echo($player_name);
		echo(",");
		echo($time);
		echo(",");
		echo($bike_id);
		echo(",");
		echo($bell_id);
		echo(",");
		echo($level_id);
		echo(",");
		echo($user_id);
		echo(",");

	}
	DB_Disconnect();

}



function GetAllRaceData()
{
	DB_ConnectUser();
	$version = 0;
	$game_name = "";
	$version = $_GET["version"];
	$game_name = $_GET["game_name"];

	$idarray = array();
	$idarray=split("_",$race_ids);
	
	$numids = count($idarray);

		
	$sql = "SELECT id,player_name,time,bike_id,bell_id,char_id,level_id_str FROM tbl_runs WHERE game_name = '$game_name'";

	$result = mysql_query($sql);

	echo("levels=");
	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  $player_name =  $row['player_name'];
	  $time =  $row['time'];
	  $bike_id =  $row['bike_id'];
	  $bell_id =  $row['bell_id'];
	  $char_id =  $row['char_id'];
	  $level_id_str =  $row['level_id_str'];

		echo($id);
		echo(",");
		echo($player_name);
		echo(",");
		echo($time);
		echo(",");
		echo($bike_id);
		echo(",");
		echo($bell_id);
		echo(",");
		echo($char_id);
		echo(",");
		echo($level_id_str);
		echo(",");

	}
	DB_Disconnect();

}




function GetRaceDataByIDs()
{
	DB_ConnectUser();
	$race_ids = 0;
	$race_ids = $_GET["raceids"];
	$version = 0;
	$version = $_GET["version"];

	$idarray = array();
	$idarray=split("_",$race_ids);
	
	$numids = count($idarray);

		
	$sql = "SELECT id,player_name,time,bike_id,bell_id,level_id,user_id FROM tbl_runs WHERE version='$version' 
		AND (";

		for($i=0; $i<$numids; $i++)
		{
			$sql = $sql."id='".$idarray[$i]."'";
			if($i != $numids-1)
			{
				$sql = $sql." OR ";
			}
			else
			{
				$sql = $sql.")";
			}

		}



	$result = mysql_query($sql);

	echo("levels=");
	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  $player_name =  $row['player_name'];
	  $time =  $row['time'];
	  $bike_id =  $row['bike_id'];
	  $bell_id =  $row['bell_id'];
	  $level_id =  $row['level_id'];
	  $user_id =  $row['user_id'];

		echo($id);
		echo(",");
		echo($player_name);
		echo(",");
		echo($time);
		echo(",");
		echo($bike_id);
		echo(",");
		echo($bell_id);
		echo(",");
		echo($level_id);
		echo(",");
		echo($user_id);
		echo(",");

	}
	DB_Disconnect();

}



function GetRaceDataByTrack_BikeList()
{
	DB_ConnectUser();
	$level_id = 0;
	$level_id = $_GET["levelid"];
	$version = 0;
	$version = $_GET["version"];

	$bikes="";
	$bikes = $_GET["bikes"];

	

	$bikearray = array();
	$bikearray = str_split($bikes,2);
	$numbikes = count($bikearray);

		
	$sql = "SELECT id,player_name,time,bike_id,bell_id,level_id,user_id FROM tbl_runs WHERE level_id='$level_id' AND version='$version' 
		AND (";

		for($i=0; $i<$numbikes; $i++)
		{
			$sql = $sql."bike_id='".$bikearray[$i]."'";
			if($i != $numbikes-1)
			{
				$sql = $sql." OR ";
			}
			else
			{
				$sql = $sql.")";
			}

		}

		$sql = $sql." ORDER BY RAND() LIMIT 5";

//	echo($sql);

	$result = mysql_query($sql);

	echo("levels=");
	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  $player_name =  $row['player_name'];
	  $time =  $row['time'];
	  $bike_id =  $row['bike_id'];
	  $bell_id =  $row['bell_id'];
	  $level_id =  $row['level_id'];
	  $user_id =  $row['user_id'];

		echo($id);
		echo(",");
		echo($player_name);
		echo(",");
		echo($time);
		echo(",");
		echo($bike_id);
		echo(",");
		echo($bell_id);
		echo(",");
		echo($level_id);
		echo(",");
		echo($user_id);
		echo(",");

	}
	DB_Disconnect();

}


function GetRaceDataByTrack_Random()
{
	DB_ConnectUser();
	$level_id_str = 0;
	$level_id_str = $_GET["levelidstr"];
	$version = 0;
	$version = $_GET["version"];

	$result = mysql_query("SELECT player_name,id,time,bike_id,bell_id,level_id_str,user_id FROM tbl_runs WHERE level_id_str='$level_id_str' AND version='$version' ORDER BY RAND() LIMIT 50");

	echo("levels=");
	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  $player_name =  $row['player_name'];
	  $time =  $row['time'];
	  $bike_id =  $row['bike_id'];
	  $bell_id =  $row['bell_id'];
	  $level_id_str =  $row['level_id_str'];
	  $user_id =  $row['user_id'];

		echo($id);
		echo(",");
		echo($player_name);
		echo(",");
		echo($time);
		echo(",");
		echo($bike_id);
		echo(",");
		echo($bell_id);
		echo(",");
		echo($level_id_str);
		echo(",");
		echo($user_id);
		echo(",");

	}
	DB_Disconnect();

}


function GetRaceDataByTrack_UserIDList()
{
	DB_ConnectUser();
	$level_id = 0;
	$level_id = $_GET["levelid"];
	$user_id_list = "11_5_14";
	$user_id_list = $_GET["user_id_list"];
	$version = 0;
	$version = $_GET["version"];

	if($user_id_list==null)
	{
		echo("levels=");
		DB_Disconnect();
		return;
	}
	if($user_id_list == "")
	{
		echo("levels=");
		DB_Disconnect();
		return;
	}

	$user_ids = array();
	$user_ids=split("_",$user_id_list);
	
	$num_user_ids = count($user_ids);
	
	if($num_user_ids <= 0)
	{
		echo("levels=");
		DB_Disconnect();
		return;
	}


	$sql = "SELECT player_name,id,time,bike_id,bell_id,level_id,user_id FROM tbl_runs WHERE level_id='$level_id' AND version='$version' AND (";

	for($i=0; $i<$num_user_ids; $i++)
	{
		$sql = $sql."user_id='".$user_ids[$i]."'";
		if($i != $num_user_ids-1)
		{
			$sql = $sql." OR ";
		}
		else
		{
			$sql = $sql.")";
		}
	}

	$result = mysql_query($sql);

	echo("levels=");
	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  $player_name =  $row['player_name'];
	  $time =  $row['time'];
	  $bike_id =  $row['bike_id'];
	  $bell_id =  $row['bell_id'];
	  $level_id =  $row['level_id'];
	  $user_id =  $row['user_id'];

		echo($id);
		echo(",");
		echo($player_name);
		echo(",");
		echo($time);
		echo(",");
		echo($bike_id);
		echo(",");
		echo($bell_id);
		echo(",");
		echo($level_id);
		echo(",");
		echo($user_id);
		echo(",");

	}
	DB_Disconnect();

}


function GetRaceDataByTrack_BestTimes()
{
	DB_ConnectUser();
	$level_id = 0;
	$level_id = $_GET["levelid"];
	$version = 0;
	$version = $_GET["version"];

	$result = mysql_query("SELECT id,player_name,time,bike_id,bell_id,level_id,user_id FROM tbl_runs WHERE level_id='$level_id' AND version='$version' ORDER BY time LIMIT 5");

	echo("levels=");
	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  $player_name =  $row['player_name'];
	  $time =  $row['time'];
	  $bike_id =  $row['bike_id'];
	  $bell_id =  $row['bell_id'];
	  $level_id =  $row['level_id'];
	  $user_id =  $row['user_id'];

		echo($id);
		echo(",");
		echo($player_name);
		echo(",");
		echo($time);
		echo(",");
		echo($bike_id);
		echo(",");
		echo($bell_id);
		echo(",");
		echo($level_id);
		echo(",");
		echo($user_id);
		echo(",");

	}
	DB_Disconnect();

}



function GetRaceDataByTrack_MinMaxTimes()
{
	DB_ConnectUser();
	$level_id = 0;
	$level_id = $_GET["levelid"];
	$version = 0;
	$version = $_GET["version"];
	$mintime = 0;
	$mintime = $_GET["mintime"];
	$maxtime = 1000*33;
	$maxtime = $_GET["maxtime"];

	$result = mysql_query("SELECT id,player_name,time,bike_id,bell_id,level_id,user_id FROM tbl_runs WHERE level_id='$level_id' AND version='$version' AND time>='$mintime' AND time<='$maxtime' ORDER BY RAND() LIMIT 5");

	echo("levels=");
	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  $player_name =  $row['player_name'];
	  $time =  $row['time'];
	  $bike_id =  $row['bike_id'];
	  $bell_id =  $row['bell_id'];
	  $level_id =  $row['level_id'];
	  $user_id =  $row['user_id'];

		echo($id);
		echo(",");
		echo($player_name);
		echo(",");
		echo($time);
		echo(",");
		echo($bike_id);
		echo(",");
		echo($bell_id);
		echo(",");
		echo($level_id);
		echo(",");
		echo($user_id);
		echo(",");

	}
	DB_Disconnect();

}



function GetIdsByTrack()
{
	DB_ConnectUser();
	$level_id = 0;
	$level_id = $_GET["levelid"];
	$version = 0;
	$version = $_GET["version"];

	$result = mysql_query("SELECT id FROM tbl_runs WHERE level_id='$level_id' AND version='$version' ORDER BY RAND() LIMIT 5");

	$ids = array();

	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  array_push($ids,$id);
	}
	DB_Disconnect();

	$length=count($ids);

	$i = 0;
	$str = "";

	for($i=0; $i<$length; $i++)
	{
		$str = $str.$ids[$i];
		if($i != $length-1)
		{
			$str = $str.",";
		}
	}

	echo("ids=".$str);
}


function GetIdsByTrackTimed()
{
	DB_ConnectUser();
	$level_id = 0;
	$level_id = $_GET["levelid"];
	$version = 0;
	$version = $_GET["version"];
	$mintime = 0;
	$mintime = $_GET["mintime"];
	$maxtime = 1000*33;
	$maxtime = $_GET["maxtime"];

	$result = mysql_query("SELECT id FROM tbl_runs WHERE level_id='$level_id' AND version='$version' AND time>='$mintime' AND time<='$maxtime' ORDER BY RAND() LIMIT 5");

	$ids = array();

	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  array_push($ids,$id);
	}
	DB_Disconnect();

	$length=count($ids);

	$i = 0;
	$str = "";

	for($i=0; $i<$length; $i++)
	{
		$str = $str.$ids[$i];
		if($i != $length-1)
		{
			$str = $str.",";
		}
	}

	echo("ids=".$str);
}


function GetIdsByTrackBikeList()
{
	DB_ConnectUser();
	$level_id = 0;
	$level_id = $_GET["levelid"];
	$version = 0;
	$version = $_GET["version"];
	$bikes="";
	$bikes = $_GET["bikes"];

	

	$bikearray = array();
	$bikearray = str_split($bikes,2);
	$numbikes = count($bikearray);

		
	$sql = "SELECT id FROM tbl_runs WHERE level_id='$level_id' AND version='$version' 
		AND (";

		for($i=0; $i<$numbikes; $i++)
		{
			$sql = $sql."bike_id='".$bikearray[$i]."'";
			if($i != $numbikes-1)
			{
				$sql = $sql." OR ";
			}
			else
			{
				$sql = $sql.")";
			}

		}

		$sql = $sql." ORDER BY RAND() LIMIT 5";

//	echo($sql);

	$result = mysql_query($sql);

	$ids = array();

	while($row = mysql_fetch_array($result))
	{
	  $id =  $row['id'];
	  array_push($ids,$id);
	}
	DB_Disconnect();

	$length=count($ids);

	$i = 0;
	$str = "";

	for($i=0; $i<$length; $i++)
	{
		$str = $str.$ids[$i];
		if($i != $length-1)
		{
			$str = $str.",";
		}
	}

	echo("ids=".$str);
}




function GetLatestID()
{
	DB_ConnectUser();
	$result = mysql_query("SELECT id FROM tbl_runs");

	$highestID = 0;
	while($row = mysql_fetch_array($result))
  {
	  $id =  $row['id'];
	  if($id > $highestID)
	  {
		  $highestID = $id;
	  }
  }
	DB_Disconnect();


	echo("id=".$highestID);
}



function GetRunByID()
{

	$player_name = "harry";
	$time = 100;
	$bike_id = 1;
	$level_id_str = "";
	$user_id = 0;
	$data = "undefined";

	DB_ConnectUser();

	$runid=0;
	$runid = $_GET["runid"];

	$result = mysql_query("SELECT * FROM tbl_runs WHERE id='$runid'");

	while($row = mysql_fetch_array($result))
	  {
		  $id =  $row['id'];
		  $player_name =  $row['player_name'];
		  $time =  $row['time'];
		  $bike_id =  $row['bike_id'];
		  $bell_id =  $row['bell_id'];
		  $char_id =  $row['char_id'];
		  $level_id_str =  $row['level_id_str'];
		  $data =  $row['data'];
	  }
	DB_Disconnect();


	echo("player_name=".$player_name);
	echo("&");
	echo("time=".$time);
	echo("&");
	echo("bike_id=".$bike_id);
	echo("&");
	echo("bell_id=".$bell_id);
	echo("&");
	echo("char_id=".$char_id);
	echo("&");
	echo("level_id_str=".$level_id_str);
	echo("&");
	echo("id=".$id);
	echo("&");
	echo("data=".$data);

}

function GetCamRecByID()
{

	$name = "harry";
	$user_id = 0;
	$level_id = 0;
	$run_ids = 0;
	$data = "undefined";

	DB_ConnectUser();

	$camrecid=0;
	$camrecid = $_GET["camrecid"];

	$result = mysql_query("SELECT * FROM tbl_camrec WHERE id='$camrecid'");

	while($row = mysql_fetch_array($result))
	  {
		  $id =  $row['id'];
		  $name =  $row['name'];
		  $user_id =  $row['user_id'];
		  $level_id =  $row['level_id'];
		  $run_ids =  $row['run_ids'];
		  $data =  $row['data'];
	  }
	DB_Disconnect();


	echo("id=".$id);
	echo("&");
	echo("name=".$name);
	echo("&");
	echo("user_id=".$user_id);
	echo("&");
	echo("level_id=".$level_id);
	echo("&");
	echo("run_ids=".$run_ids);
	echo("&");
	echo("data=".$data);

}


function GetCamRecDataByLatest()
{

	$name = "harry";
	$user_id = 0;
	$level_id = 0;
	$run_ids = 0;
	$data = "undefined";

	$first=0;
	$first = $_GET["first"];
	$amount=0;
	$amount = $_GET["amount"];


	DB_ConnectUser();

	$result = mysql_query("SELECT * FROM tbl_camrec ORDER BY creation_datetime LIMIT $first,$amount");

	echo("camrecs=");

	while($row = mysql_fetch_array($result))
	  {
		  $id =  $row['id'];
		  $name =  $row['name'];
		  $user_id =  $row['user_id'];
		  $level_id =  $row['level_id'];
		  $run_ids =  $row['run_ids'];
		  $creation_datetime =  $row['creation_datetime'];
		  $user_name =  $row['user_name'];
		  echo($id.",");
		  echo($name.",");
		  echo($user_id.",");
		  echo($level_id.",");
		  echo($run_ids.",");
		  echo($creation_datetime.",");
		  echo($user_name.",");
	  }
	DB_Disconnect();

}

?>