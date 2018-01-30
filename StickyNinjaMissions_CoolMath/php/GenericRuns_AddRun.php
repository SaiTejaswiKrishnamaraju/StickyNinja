<?php
//include_once ("../include/session.php");
//include_once ("../include/pageChunks.php");


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



	
//	$myFile = "AddRun.txt";
//	$fh = fopen($myFile, 'w');
//	fwrite($fh, $timeStamp);
//	fclose($fh);


	$errorReason= "";
	
	
	$player_name = $_POST["player_name"];
	$game_name = $_POST["game_name"];
	$time = $_POST["time"];
	$bike_id = $_POST["bike_id"];
	$bell_id = $_POST["bell_id"];
	$char_id = $_POST["char_id"];
	$level_id_str = $_POST["level_id_str"];
	$data = $_POST["data"];
	$version = $_POST["version"];
	$timeStamp = $_POST["timeStamp"];
	$hash = $_POST["hash"];

	$hashStr = "";
	$hashStr .= $player_name;
	$hashStr .= $game_name;
	$hashStr .= $time;
	$hashStr .= $bike_id;
	$hashStr .= $bell_id;
	$hashStr .= $char_id;
	$hashStr .= $level_id_str;
	$hashStr .= $data;
	$hashStr .= $version;
	$hashStr .= $timeStamp;
	$hashStr .= GetHashKey();
	$hash1 = md5($hashStr);



//	$req_user_info = $database->getUserInfoByID($user_id);
	
//	if($database->isUserIDLoggedIn() == 0) errorReason = "logged in error";

// sanity check posting:

	if($hash1 != $hash) $errorReason = "hash error";


	if($version != GetLatestVersion()) $errorReason = "version error";

//	if($player_name == "") $errorReason = "name error 1";
//	if(strlen($player_name) > 20) $errorReason = "name error 2";
//	if($time < GetMinRaceTime()) $errorReason = "time error 1";
//	if($time > GetMaxRaceTime()) $errorReason = "time error 2";
//	if($bike_id < 0) $errorReason = "bike error 1";
//	if($bike_id > GetMaxBikeID()) $errorReason = "bike error 2";

	$creation_datetime = date( 'Y-m-d H:i:s');

	$level_id = 99999;

	if($errorReason != "")
	{
		echo("lastid=0&error=$errorReason");
	}
	else
	{

		DB_ConnectUser();
	
		$query = "INSERT INTO tbl_runs (player_name, game_name, time, bike_id, bell_id, char_id, level_id_str, data,version,creation_datetime) 
								VALUES ('$player_name','$game_name','$time','$bike_id','$bell_id','$char_id','$level_id_str','$data','$version','$creation_datetime')";
	
		if (!mysql_query($query))
		{
			echo('error=' . mysql_error());
		}
		else
		{
			$last_id = mysql_insert_id();
			echo("error=$errorReason&lastid=$last_id");
		}
		
		
		DB_Disconnect();

	}	



function GetLatestVersion()
{
	return 1;
}
function GetMaxRaceTime()
{
	return 90*30;
}

function GetMinRaceTime()
{
	return 20*30;
}
function GetMaxBikeID()
{
	return 100;
}
function GetMaxBellID()
{
	return 10;
}
function GetMaxLevelID()
{
	return 24;
}

	
function GetHashKey()
{
	return "ahfuhea8347an38akjh3kuha8";
}

	
?>