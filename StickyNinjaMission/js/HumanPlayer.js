function HumanPlayer(x, y, game) {
	this.game = game;
	gameGlobal = game;
	thisObj = this;
	StickyNinjaGlobals.humanyPlayerClass = this;
	this.x = x;
	this.y = y;
	this.appliedForce = false;
	this.humanPlayer;
	this.launchVelocity;
	this.trajectoryGraphics;
	this.objArray = new Array();
	this.showExitArrowFlag = 0;

	this.ranOutOfTime = false;
	this.playerkilledOnce = 0;
	trapdoorobject = 0;
	bounceBackVelocity = {};
	this.attachToTrapDoor="top";

	playerStickedToSubwaycar=0;
	playerStickedToSubwaycarObject ="";

	playerStickedToCar = 0;
	switchon = false;
	playerkilledinwaterFire = 0;	
	playerkilledother = 0;
	playerStickedToLog = 0;
	playerStickedToLog1 = 0;
	playerStickedToDoorLog = 0;
	playerStickedwheelTyre = 0;
	playerStickedSkateboard = 0;
	playerStickedboat = 0;
	playerStickedToWheel = 0;
	playerhitshurikenPlayer = 0;
	tetsubishi = [];
	shurikenPlayerObj = "";
	tetsubishiObj = "";
	yellowWalltween = 0;
	this.wheelTyreObject = "";
	this.skateboardObject = "";
	this.boatObject = "";
	prevX = 0;
	prevY = 0;
	prevAngle = 0;
	prevBodyAngle = 0;
	this.rightX = "bottom";
	this.yellowTouchPos = "";
	playerRotated = false;

	this.carTouch = "top";
	this.doorTouch = "";
	exitDoorWidth = 0;
	exitDoorHeight = 0;
	dirOfExitDoor = 1;

	exitDoorrotate = '';

	//For trap door
	trapDoorIndex = "";


	//Below one is to push player when fallen in fire/water
	pushPlayerOnce = false;

	playerAnimated = 0;

	// Below variable is to enable jumping only when mouse clicked on player
	activatePlayerObject = false;

	//Below two to bring back player to previous position when its killed
	originX = 0;
	originY = 0;
 
	jumpPos = 0;

	//Below for player right/left jump animation
	kickX = 0;
	kickY = 0;
	kickDirection = 0;
	threshold = 0;

	mouseUpStatus = true;
	targetX = 0;
	flag = 0;
	direction = 0;

	jumps = 0;
	prevJump = -1;
	counter = 0;
	score = 0;
	hitCountNo = 0;
	// Below one is for exploding effect
	explodeAnimationKeyName = "woodslice";
	this.cday = getDay();
	this.clevel = getLevel();

	fixed = 0;
	targetY = 0;
	groundContacted = false;


	//Activate score counting
	scoreCounting = false;
	targetScore = 0;

	//Activate enemy killing
	enemiesKilled = 0;
	activateEnemiesKilling = false;

	//Activate combo
	activateCombo = false;
	comboRights = false;

	//Activate stop killing of enemies
	enemiesKilled = 0;
	activateStopKillingEnemies = false;
	levelFailedEnemyKilled = false;

	//Activate treasury capturing
	treasuriesCaptured = 0;
	activateTreasuriesCapturing = false;
	
	//Activate smash count capturing
	smashedObjectsCaptured = 0;
	activateSmashObjectsCapturing = false;

	//Activate timer
	timer = 0;
	activateTimer = false;
	levelFailedTimer = false;
	seconds = 60;
	levelTimer = 30;
	timer1 = 0;
	// Activate multiple conditions
	mutipleConditionsToCompleteLevel = false;

	// This counter is used when multiple conditions to complete level
	numOfConditionsToCompleteLevel = 0;
	counterToCompleteLevel = 0;

	StickyNinjaGlobals.levelCompleted = 0;
	StickyNinjaGlobals.gameCompleted = 0;
	StickyNinjaGlobals.triggerExitDoor = 0;
	lives = 0;
	playerKilled = 0;

	//For showing guide image only once
	//D1 L1
	this.guide1Shown = false;
	this.guide2Shown = false;
	this.redcircleShown = false;

	//D1 L2
	this.guide3Shown = false;

	//D1 L3
	this.guide4Shown = false;
	this.guide5Shown = false;

	//D1 L5
	this.guide6Shown = false;
	//D2 L2
	this.guide7Shown = false;

};

//inheritsFrom(AchBird.prototype,GameObject.prototype);

HumanPlayer.prototype = {

	preload: function () {
		//console.log("TEST PRELOAD HUMAN PLAYER");
		//this.game.load.image('humanPlayer', "/player_a_base.png");

	},

	getSprite: function () {
		return this.humanPlayer;
	},

	create: function () {
		//console.log("TEST CREATE HUMAN PLAYER");

		// Below method of globals js to reset shown key to false
		resetCloudImages();

		this.levelCompletedFlag = 0;
		this.mouseUp = false;
		this.mouseX = 0;
		this.mouseY = 0;
		this.mouseClickOnPlayerObject = false;
		this.game.input.mouse.capture = true;

		//audio
		this.game.sfxExitEnter = this.game.add.audio('sfxExitEnter');
		this.game.sfxExitOpen = this.game.add.audio('sfxExitOpen');
		this.game.sfxHitEnemy = this.game.add.audio('sfxHitEnemy');
		this.game.sfxSmash1 = this.game.add.audio('sfxSmash1');
		this.game.sfxSmash2 = this.game.add.audio('sfxSmash2');
		this.game.sfxSmash3 = this.game.add.audio('sfxSmash3');
		this.game.sfxHitSticky = this.game.add.audio('sfxHitSticky');
		this.game.sfxLaunch = this.game.add.audio('sfxLaunch');
		this.game.gamePlayMusic = this.game.add.audio('gamePlayMusic');
		this.game.sfxTreasure = this.game.add.audio('sfxTreasure');
		this.game.sfxSwitch = this.game.add.audio('sfxSwitch');
		this.game.sfxHitBouncy = this.game.add.audio('sfxHitBouncy');
		this.game.sfxPlayerDie1 = this.game.add.audio('sfxPlayerDie1');
		this.game.sfxPlayerDie2 = this.game.add.audio('sfxPlayerDie2');
		this.game.sfxSmashWood1 = this.game.add.audio('sfxSmashWood1');
		this.game.sfxSmashWood2 = this.game.add.audio('sfxSmashWood2');
		this.game.sfxPlayerDie = this.game.add.audio('sfxPlayerDie');

	
	
		//Get level completion details from globals js
		var levelCompletionArray = StickyNinjaGlobals.levelCompletionConditions[this.cday][this.clevel];

		// Activate multiple conditions to complete the level
		if (levelCompletionArray.length > 1) {
			mutipleConditionsToCompleteLevel = true;
		}

		//console.log("mutipleConditionsToCompleteLevel:-->",mutipleConditionsToCompleteLevel);

		// Activate level completion 
		for (var index = 0; index < levelCompletionArray.length; index++) {
			if (levelCompletionArray[index].indexOf("treasuries") >= 0) {
				activateTreasuriesCapturing = true;
				numOfConditionsToCompleteLevel++;
			}
			if (levelCompletionArray[index].indexOf("smashall") >= 0) {
				activateSmashObjectsCapturing = true;
				numOfConditionsToCompleteLevel++;
			}
			if (levelCompletionArray[index].indexOf("enemies") >= 0) {
				activateEnemiesKilling = true;
				numOfConditionsToCompleteLevel++;
			}
			if (levelCompletionArray[index].indexOf("combo") >= 0) {
				activateCombo = true;
				activateEnemiesKilling = true;
				numOfConditionsToCompleteLevel++;
			}
			if (levelCompletionArray[index].indexOf("timer") >= 0) {
				activateTimer = true;				
				levelTimer = parseInt((levelCompletionArray[index].split(","))[1]);
				timer1 = 0;
				if(levelCompletionArray.length==2){
					mutipleConditionsToCompleteLevel = false;
				}
				numOfConditionsToCompleteLevel++;
			}
			if (levelCompletionArray[index].indexOf("dontkill") >= 0) {
				activateStopKillingEnemies = true;
				numOfConditionsToCompleteLevel++;
				StickyNinjaGlobals.triggerExitDoor = 1;
			}
			if (levelCompletionArray[index].indexOf("score") >= 0) {
				scoreCounting = true;
				targetScore = parseInt((levelCompletionArray[index].split(","))[1]);
				numOfConditionsToCompleteLevel++;
			}

		}

		this.launchVelocity = new Phaser.Point(0, 0);
		//this.humanPlayer = this.game.add.sprite(this.x, this.y, "playerBase");
		//this.humanPlayer = this.game.add.sprite(this.x, this.y,  "player_fly_right");
		this.humanPlayer = this.game.add.sprite(this.x, this.y, "playerFlyDown");
		this.humanPlayer.smoothed = false;
		this.humanPlayer.anchor.set(0.5);

		/* this.humanPlayer.animations.add('playerAnimations',[0,1,2,3,4,5,6,7,8]);
		this.humanPlayer.animations.play('playerAnimations',2,true); */



		//Player right jump animation
		//this.playerFlyRight = this.game.add.sprite(this.humanPlayer.body.x, this.humanPlayer.body.y,  "player_fly_right");
		//this.playerFlyRight.anchor.set(0.5);   
		this.humanPlayer.animations.add('playerIdle', [0, 1, 2, 3], 30, false);
		playerChargeAnim = this.humanPlayer.animations.add('playerCharge', [0, 1, 2, 3], 80, false);
		this.humanPlayer.animations.add('playerFlyRight', [0, 1, 2, 3], 30, false);
		this.humanPlayer.animations.add('playerFlyLeft', [0, 1, 2, 3], 30, false);
		exitAnim = this.humanPlayer.animations.add('playerExitAnim', [0, 1, 2, 3], 80, true);
		this.humanPlayer.animations.add('playerFlyUp', [0, 1, 2, 3], 80, false);
		this.humanPlayer.animations.add('playerFlyDown', [0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25], 80, false);
		this.humanPlayer.animations.add('playerLookUp', [0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25], 80, false);
		killAnim = this.humanPlayer.animations.add('playerKill', [0, 1, 2, 3], 80, false);
		this.humanPlayer.animations.add('playerKillFire', [0], 80, false);



		this.humanPlayer.animations.play('playerFlyDown', 4, true);

		//this.playerFlyRightAnim.killOnComplete = true;


		this.forceMult = 5;
		this.trajectoryGraphics = this.game.add.graphics(0, 0);

		this.game.physics.box2d.enable(this.humanPlayer);
	
		

    
		//this.humanPlayer.body.clearFixtures();
		//this.humanPlayer.body.loadPolygon('physicsData', "player", this.humanPlayer);

		/*if (this.cday == 3 && this.clevel == 4) {
			this.humanPlayer.body.setCircle(20, 3, 0);
		} else {
			this.humanPlayer.body.setCircle(30, 0, 0);
		}*/
		//this.humanPlayer.body.setCircle(22, 4, 13);
			this.humanPlayer.body.setCircle(30, 0, 0);
		this.humanPlayer.body.mass = 1;
		this.humanPlayer.body.friction = 40;
		this.humanPlayer.body.gravityScale = 1;
		this.humanPlayer.body.linearDamping = 0;
		this.humanPlayer.body.damping = 0;

		//Exit Arrow Image
	

		this.objExitArrow = this.game.add.sprite(this.humanPlayer.body.x, this.humanPlayer.body.y, 'objExitArrow');
		this.objExitArrow.scale.x = 1;
		this.objExitArrow.scale.y = 1;
		this.objExitArrow.visible = false;

		this.objExitArrowIcon = this.game.add.sprite(this.humanPlayer.body.x, this.humanPlayer.body.y - 50, 'objExitArrowIcon');
		this.objExitArrowIcon.scale.x = 1;
		this.objExitArrowIcon.scale.y = 1;
		this.objExitArrowIcon.visible = false;

		/*this.enemy_tickmark = this.game.add.sprite(this.objExitArrowIcon.x + (this.objExitArrowIcon.width / 2), this.objExitArrowIcon.y + 20,  'enemy_tickmark');
		this.enemy_tickmark.scale.x = 1;
		this.enemy_tickmark.scale.y = 1;
		this.enemy_tickmark.visible = false;*/

		//var circle = this.game.physics.box2d.createCircle(this.humanPlayer.body.x, this.humanPlayer.body.y, 10);
		//this.game.physics.box2d.revoluteJoint(this.humanPlayer, circle);

		//var circle = this.game.physics.box2d.createCircle(this.humanPlayer.body.x, this.humanPlayer.body.y, 10);

		//Following objects are for player sticking in specific angle
		this.playerRight = this.humanPlayer.body.addCircle(10, 27, 0);

		this.playerLeft = this.humanPlayer.body.addCircle(10, -27, 0);
		//this.playerBottom = this.humanPlayer.body.addCircle(10, 0, 20);
		//this.playerTop = this.humanPlayer.body.addCircle(10, 0, -30);
		//this.playerTop = this.humanPlayer.body.addRectangle(20,20,0, -30);
		//this.playerBottom = this.humanPlayer.body.addRectangle(20,20,0, 30);

		this.playerTop = this.humanPlayer.body.addRectangle(20, 20, 0, -27);
		this.playerBottom = this.humanPlayer.body.addRectangle(20, 20, 0, 25);


		for (var f = this.humanPlayer.body.data.GetFixtureList(); f; f = f.GetNext()) {
			var filter = f.GetFilterData();
			filter.groupIndex = -1;
		}


		this.playerRight.SetSensor(true);
		this.playerLeft.SetSensor(true);
		this.playerBottom.SetSensor(true);
		this.playerTop.SetSensor(true);



		this.humanPlayer.body.setFixtureContactCallback(this.playerRight, this.rightCallback, this);
		this.humanPlayer.body.setFixtureContactCallback(this.playerLeft, this.leftCallback, this);
		this.humanPlayer.body.setFixtureContactCallback(this.playerBottom, this.bottomCallback, this);
		this.humanPlayer.body.setFixtureContactCallback(this.playerTop, this.topCallback, this);

		/*if(StickyNinjaGlobals.carrightObj && StickyNinjaGlobals.car){		
			console.log(StickyNinjaGlobals.car);
			StickyNinjaGlobals.car.setFixtureContactCallback(StickyNinjaGlobals.carrightObj, this.carRight, this);
			StickyNinjaGlobals.car.setFixtureContactCallback(StickyNinjaGlobals.carleftObj, this.carLeft, this);
			StickyNinjaGlobals.car.setFixtureContactCallback(StickyNinjaGlobals.cartopObj, this.carTop, this);
			StickyNinjaGlobals.car.setFixtureContactCallback(StickyNinjaGlobals.cartopLeftObj, this.cartopLeft, this);

			StickyNinjaGlobals.car.setFixtureContactCallback(StickyNinjaGlobals.cartopRightObj, this.cartopRight, this);

			StickyNinjaGlobals.car.setFixtureContactCallback(StickyNinjaGlobals.carbackTop, this.carbackTop, this);
			StickyNinjaGlobals.car.setFixtureContactCallback(StickyNinjaGlobals.carfrontTop, this.carfrontTop, this);
			
		}*/

		if (StickyNinjaGlobals.trapdoorshape1) {
			this.humanPlayer.body.setFixtureContactCallback(StickyNinjaGlobals.trapdoorshape1, this.trapdoorshape1, this);
			this.humanPlayer.body.setFixtureContactCallback(StickyNinjaGlobals.trapdoorshape2, this.trapdoorshape2, this);
			this.humanPlayer.body.setFixtureContactCallback(StickyNinjaGlobals.trapdoorshape3, this.trapdoorshape3, this);

		}

		// For positions of target messages like Defeat All Enemies

		var guide1;
		if (StickyNinjaGlobals.targetMessagePositions[this.cday]) {
			if (StickyNinjaGlobals.targetMessagePositions[this.cday][this.clevel]) {
				var x1 = this.humanPlayer.body.x + StickyNinjaGlobals.targetMessagePositions[this.cday][this.clevel].x;
				var y1 = this.humanPlayer.body.y + StickyNinjaGlobals.targetMessagePositions[this.cday][this.clevel].y;
				var key = StickyNinjaGlobals.targetMessagePositions[this.cday][this.clevel].key;
				guide1 = this.game.add.sprite(x1 - 25, y1 - 10, key);
				guide1.scale.x = 1;
				guide1.scale.y = 1;

				var tweenguide = this.game.add.tween(guide1).to({ x: x1 - 25, y: y1 - 10 }, 5000, Phaser.Easing.InOut, true);
				tweenguide.onComplete.add(function () {
					console.log("sdsd");
					guide1.scale.x = 0;
					guide1.scale.y = 0;
				}, this);
			}
		}


		var x = this.humanPlayer.body.x;
		var y = this.humanPlayer.body.y;
		this.redcircle = this.game.add.sprite(x, y, 'redcircle');
		this.redcircle.scale.x = 1;
		this.redcircle.scale.y = 1;

		this.clickandhold = this.game.add.sprite(x, y, 'clickandhold');
		this.clickandhold.scale.x = 1.2;
		this.clickandhold.scale.y = 1.2;
		this.clickandhold.anchor.set(0.5);

		var clicktween = this.game.add.tween(this.clickandhold.scale).to({ x: 1, y: 1 }, 500, Phaser.Easing.InOut, true);
		clicktween.onComplete.add(function () {
			var clicktween1 = this.game.add.tween(this.clickandhold.scale).to({ x: 1.2, y: 1.2 }, 500, Phaser.Easing.InOut, true);
			clicktween1.onComplete.add(function () {
				clicktween.start();
			}, this);
		}, this);
		this.dragandrelease = this.game.add.sprite(x, y, 'dragandrelease');
		this.dragandrelease.scale.x = 1;
		this.dragandrelease.scale.y = 1;
		this.dragandrelease.anchor.set(0.5);
		var dragandreleaseween = this.game.add.tween(this.dragandrelease.scale).to({ x: 0.8, y: 0.8 }, 300, Phaser.Easing.InOut, true);
		dragandreleaseween.onComplete.add(function () {
			var dragandreleasetween1 = this.game.add.tween(this.dragandrelease.scale).to({ x: 1, y: 1 }, 300, Phaser.Easing.InOut, true);
			dragandreleasetween1.onComplete.add(function () {
				dragandreleaseween.start();
			}, this);
		}, this);
		if (this.cday == 1 && this.clevel == 1) {
			this.redcircle.visible = true;
			this.clickandhold.visible = true;
			this.dragandrelease.visible = false;
		} else {
			this.redcircle.visible = false;
			this.clickandhold.visible = false;
			this.dragandrelease.visible = false;
		}

		this.circleselected = this.game.add.sprite(-200, -200, 'circleselected');
		this.circleselected.scale.x = 1;
		this.circleselected.scale.y = 1;
		this.circleselected.visible = false;

		this.fixedBall = this.game.add.sprite(-200, -200, 'fixedBall');
		this.fixedBall.visible = false;
		this.fixedBallTweening = false;


		this.cameraMovement = true;
		//console.log("SUCCESSFULLY CREATED HUMAN PLAYER");
		//this.game.input.addMoveCallback(this.chargePlayer, this);


		this.game.input.onDown.add(this.chargePlayer, this);

		this.humanPlayer.body.setCategoryContactCallback(2, this.hitobject, this);
		this.game.destroyCrateWoodtime = 0;
		this.humanPlayer.body.setCategoryContactCallback(3, this.destroyCrateWoodObject, this);
		this.game.destroyEnemyObjecttime = 0;
		this.humanPlayer.body.setCategoryContactCallback(4, this.destroyEnemyObject, this);
		this.humanPlayer.body.setCategoryContactCallback(5, this.exitDoor);
		this.game.captureDiamondtime = 0;
		this.humanPlayer.body.setCategoryContactCallback(6, this.captureDiamond, this);
		this.game.killPlayertime = 0;
		this.humanPlayer.body.setCategoryContactCallback(7, this.killPlayer, this);
		this.humanPlayer.body.setCategoryContactCallback(8, this.yellowWall, this);
		this.humanPlayer.body.setCategoryContactCallback(9, this.objLifebuoy);
		this.humanPlayer.body.setCategoryContactCallback(10, this.skating, this);
		this.game.destroyEnemyinFire = 0;
		this.humanPlayer.body.setCategoryContactCallback(11, this.killPlayerInFire, this);
		this.humanPlayer.body.setCategoryContactCallback(12, this.stairs);
		this.humanPlayer.body.setCategoryContactCallback(14, this.changeSwitch);
		this.humanPlayer.body.setCategoryContactCallback(15, this.sliding);
		this.humanPlayer.body.setCategoryContactCallback(17, this.mushrooms, this);
		this.humanPlayer.body.setCategoryContactCallback(16, this.stickToCar, this);
		this.humanPlayer.body.setCategoryContactCallback(18, this.trapdoor, this);
		//this.humanPlayer.body.setCategoryContactCallback(16, this.stickToCar); 
		//this.humanPlayer.body.setCategoryContactCallback(20, this.intractingObject,this); 
		this.humanPlayer.body.setCategoryContactCallback(22, this.destroyEnemyObject2, this);
		this.humanPlayer.body.setCategoryContactCallback(23, this.attachtoLog, this);
		this.humanPlayer.body.setCategoryContactCallback(24, this.attachtoWheel, this);
		this.humanPlayer.body.setCategoryContactCallback(25, this.attachtodoorLog, this);
		this.humanPlayer.body.setCategoryContactCallback(26, this.wheelTyre, this);
		this.humanPlayer.body.setCategoryContactCallback(27, this.shurikenPlayer, this);
		this.humanPlayer.body.setCategoryContactCallback(28, this.boatMovement, this);
		this.humanPlayer.body.setCategoryContactCallback(29, this.changeSwitch1);
    this.humanPlayer.body.setCategoryContactCallback(30, this.subwaycar,this);

		if (StickyNinjaGlobals.skateBoard)
			StickyNinjaGlobals.skateBoard.body.setCategoryContactCallback(4, this.destroyEnemyObject, this);


		if (StickyNinjaGlobals.enemieslist) {
			for (var e in StickyNinjaGlobals.enemieslist) {
				StickyNinjaGlobals.enemieslist[e].body.setCategoryContactCallback(11, this.killPlayerInFire, this);
			}
		}
		if (StickyNinjaGlobals.enemieslist1) {
			for (var e in StickyNinjaGlobals.enemieslist1) {
				StickyNinjaGlobals.enemieslist1[e].body.setCategoryContactCallback(11, this.killPlayerInFire, this);
			}
		}
		if (StickyNinjaGlobals.objBallSpiky) {
			StickyNinjaGlobals.objBallSpiky.body.setCategoryContactCallback(22, this.destroyEnemyObject2, this);
		}
		//var day=getDay();
		//var level=getLevel()-1;
		//enemykilledText.setText(enemiesKilled+"/"+StickyNinjaGlobals.enemiesToBeKilled[day][level]);

		if (StickyNinjaGlobals.car) {
			if ((this.cday == 1 && this.clevel == 2) || (this.cday == 2 && this.clevel == 2) || (this.cday == 3 && this.clevel == 1) || (this.cday == 3 && this.clevel == 3)) {
				StickyNinjaGlobals.car.setCategoryContactCallback(3, this.destroyCrateWoodObject, this);
				StickyNinjaGlobals.car.setCategoryContactCallback(4, this.destroyEnemyObject, this);
				StickyNinjaGlobals.car.setCategoryContactCallback(22, this.destroyEnemyObject2, this);
				//.setCategoryContactCallback(7, this.killPlayer,this); 
				var PTM = 50;
				var frequency = 3.5;
				var damping = 0.5;
				var motorTorque = 2;
				var rideHeight = 0.5;

				//this.carLeftWheel = this.game.physics.box2d.wheelJoint(StickyNinjaGlobals.car, StickyNinjaGlobals.wheels[0], -1.10 * PTM, rideHeight * PTM, 0, 0, 0, 1, frequency); // rear
				//this.carRightWheel = this.game.physics.box2d.wheelJoint(StickyNinjaGlobals.car, StickyNinjaGlobals.wheels[1], 1.12 * PTM, rideHeight * PTM, 0, 0, 0, 1, frequency); // front

				this.carLeftWheel = this.game.physics.box2d.wheelJoint(StickyNinjaGlobals.car, StickyNinjaGlobals.wheels[0], -1.1 * PTM, rideHeight * PTM, 0, 0, 0, 1, frequency, damping, 0, motorTorque, true); // rear
				this.carRightWheel = this.game.physics.box2d.wheelJoint(StickyNinjaGlobals.car, StickyNinjaGlobals.wheels[1], 1.13 * PTM, rideHeight * PTM, 0, 0, 0, 1, frequency, damping, 0, motorTorque, true); // front

				//this.game.physics.box2d.wheelJoint(StickyNinjaGlobals.car, StickyNinjaGlobals.wheels[0], -55, 24, 0,0, 0.5, 0.5); 
				//this.game.physics.box2d.wheelJoint(StickyNinjaGlobals.car, StickyNinjaGlobals.wheels[1], 55, 24, 0,0, 0.5, 0.5); 
			}

		}
		gameGlobal.menusMusic.stop();
		if (StickyNinjaGlobals.soundOn) {
			if (!gameGlobal.gamePlayMusic.isPlaying) {
				this.game.gamePlayMusic.loopFull();
				this.game.gamePlayMusic.volume = 0.4;
			}
		}

		StickyNinjaGlobals.garbageToCollect.push(this.humanPlayer.body);

	},

	changePlayerLocation: function (x, y) {
		this.humanPlayer.body.x = x;
		this.humanPlayer.body.y = y;
	},

	sliding: function (body1, body2, fixture1, fixture2, begin) {
		body1.friction = 10;
		/*body1.sprite.loadTexture('playerBase', 0);
	    body1.sprite.animations.stop(null, true);
		flag = 0;
		groundContacted=true;
		fixed=1;*/
	},
	attachtoWheel: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			return false;
		}
		body1.sprite.loadTexture('playerLookUp', 0, false);
		body1.sprite.animations.play('playerLookUp', 4, true);
		if (playerStickedToWheel == 0) {
			playerStickedToWheel = 1;
			StickyNinjaGlobals.waterWheel = body2;
		}
	},
	stickToCar: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			//this.trapdoorobject=0;
		}

		body1.sprite.loadTexture('playerLookUp', 0, false);
		body1.sprite.animations.play('playerLookUp', 4, true);
		if (playerStickedToCar == 0) {
			//gameGlobal.physics.box2d.weldJoint(body1.sprite, body2.sprite);
			body2.static = false;
			playerStickedToCar = 1;
			//console.log("playerStickedToCar");	
			if (this.cday == 2 || switchon) {
				body1.velocity.x = 50;
				body2.velocity.x = 50;

				//	console.log(body2);
				//console.log("playerStickedToCar :::::::");
			}
		}
	},
	attachtoLog: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			return false;
		}

		if (StickyNinjaGlobals.soundOn) {
			//gameGlobal.sfxHitSticky.play();
		}
		body1.sprite.loadTexture('playerLookUp', 0, false);
		body1.sprite.animations.play('playerLookUp', 4, true);
		//fixed = 1;
		if (playerStickedToLog == 0) {
			playerStickedToLog = 1;
			//body1.angle = 0;
			//body1.angle = -90;
			//body1.sprite.angle = 0;
			body1.sprite.angle = -90;
			body1.velocity.x = 100;
			body1.applyForce(35, 0);

			//console.log("playerStickedToLog");	    
		}

	},

	attachtodoorLog: function (body1, body2, fixture1, fixture2, begin) {
		//console.log(body2);

		if (!begin) {
			return false;
		}

		if (StickyNinjaGlobals.soundOn) {
			//gameGlobal.sfxHitSticky.play();
		}
		body1.sprite.loadTexture('playerLookUp', 0, false);
		body1.sprite.animations.play('playerLookUp', 4, true);		
		this.game.world.bringToTop(body2.sprite); 
		this.game.world.bringToTop(StickyNinjaGlobals.gameMenu);
		this.game.world.bringToTop(StickyNinjaGlobals.gameMenuPopupGroup);
		//fixed = 1;
		if (playerStickedToDoorLog == 0 && playerStickedToLog1 == 0) {
			playerStickedToDoorLog = 1;
			body1.velocity.x = 100;
			body1.applyForce(135, 0);
			StickyNinjaGlobals.doorLog = body2;
			console.log("playerStickedToLog");
		}
	},

	wheelTyre: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			return false;
		}

		if (StickyNinjaGlobals.soundOn) {
			//gameGlobal.sfxHitSticky.play();
		}
		body1.sprite.loadTexture('playerLookUp', 0, false);
		body1.sprite.animations.play('playerLookUp', 4, true);
		//fixed = 1;
		if (playerStickedwheelTyre == 0) {
			playerStickedwheelTyre = 1;
			body1.velocity.x = 100;
			body1.applyForce(35, 0);
			this.wheelTyreObject = body2;
			console.log("playerStickedwheelTyre");
		}

	},
	shurikenPlayer: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			return false;
		}
		shurikenPlayerObj = body2;
		body2.sensor = true;
		body2.sprite.visible = false;
		if (playerhitshurikenPlayer == 0) {
			playerhitshurikenPlayer = 1;
		} else {
			setTimeout(function () {
				if (body2.sprite)
					body2.sprite.visible = true;
			}, 5000);
		}
		if (StickyNinjaGlobals.shurikenEnemies.length == 0 && StickyNinjaGlobals.OthershurikenEnemies.length > 0) {
			var m = 0;

			while (m < 9) {
				var spr = thisObj.game.add.sprite(thisObj.humanPlayer.body.x - 5, thisObj.humanPlayer.body.y - 10, "tetsubishi");
				spr.anchor.setTo(0.5, 0.5);

				var temptween = gameGlobal.add.tween(spr).to({ x: StickyNinjaGlobals.OthershurikenEnemies[0].body.x, y: StickyNinjaGlobals.OthershurikenEnemies[0].body.y }, 400, Phaser.Easing.InOut, true);
				temptween.onComplete.add(function () {
					spr.destroy();
				}, this);
				m++;
			}

		}

	},
	rightCallback: function (body1, body2, fixture1, fixture2, begin) {

		if (!body2) {
			return false;
		}
		else if (body2.type && (body2.type == 'breakableobject' || body2.type == 'enemy' || body2.type == 'treasureobject')) {
			return false;
		}
		if (body2.nature && (body2.nature.indexOf('obj_exit') !== -1 || body2.nature.indexOf('obj_switch') !== -1 || body2.nature.indexOf('obj_lifebuoy') !== -1 || body2.nature.indexOf('obj_fixed_joint') !== -1 || body2.nature.indexOf('obj_shuriken_player1') !== -1 || body2.nature.indexOf('obj_trapdoor') !== -1)) {
			return false;
		}
		if (body2.sprite && (body2.sprite.key.indexOf('obj_exit') !== -1 || body2.sprite.key == 'chainLink')) {
			return false;
		}
		if (body1.sprite && body1.sprite.key == 'playerExitAnim') {
			return false;
		}
		if (body2.yellowWall) {
			this.yellowTouchPos = 'right';
			return false;
		}
		//	console.log()
		if (body2.nature && body2.nature === 'obj_log_100x10') {
			this.attachToTrapDoor = 'right';			
		}
		if (this.playerDoorLogjoint && (body2.nature && body2.nature !== 'obj_log_100x10')) {			
			return false;
		}
		if (this.carPlayerjoint && playerStickedToCar == 2) {
			return false;
		}
		if (this.playerSkateboardjoint && playerStickedSkateboard == 2) {
			return false;
		}
		console.log("right call back");
		if (body2.nature && (body2.nature.indexOf('fire') == -1 && body2.nature.indexOf('water_block') == -1 && body2.nature.indexOf('obj_track_long') == -1)) {
			//console.log(body2);
				originX = body1.x;
				originY = body1.y;
			}
		if (!this.circleselected.visible) {
			/*var woodslice = ["woodslice1","woodslice2", "woodslice3", "woodslice4","woodslice5","woodslice6"];
			if(body2.sprite){
 if(body2.sprite.key){
					if(body2.sprite.key.indexOf("obj_pathline")<0 && body2.sprite.key.indexOf("wood")<0 && body2.sprite.key.indexOf("arcade")<0 && body2.sprite.key.indexOf("glass")<0){
							this.rightX="right";
					}
	 }
			}else{              
					this.rightX="right";
			}*/


			if (body2.sprite) {
				if (body2.sprite.key && (body2.sprite.key.indexOf("obj_platform_metal") !== -1 || body2.sprite.key.indexOf("obj_platform_metal_x4") !== -1 || body2.sprite.key.indexOf("obj_floor_wood") !== -1 || body2.sprite.key.indexOf("obj_platform_stone") !== -1 || body2.sprite.key.indexOf("obj_floor_wood_long") !== -1)) {
					fixed = 1;
					body1.sprite.loadTexture('playerLookUp', 0, false);
					body1.sprite.animations.play('playerLookUp', 4, true);
				}
			}
			this.rightX = "right";
		}

		//this.humanPlayer.angle=90;
	},

	leftCallback: function (body1, body2, fixture1, fixture2, begin) {

		if (!body2) {
			return false;
		}
		else if (body2.type && (body2.type == 'breakableobject' || body2.type == 'enemy' || body2.type == 'treasureobject')) {
			return false;
		}
		if (body2.nature && (body2.nature.indexOf('obj_exit') !== -1 || body2.nature.indexOf('obj_switch') !== -1 || body2.nature.indexOf('obj_lifebuoy') !== -1 || body2.nature.indexOf('obj_fixed_joint') !== -1 || body2.nature.indexOf('obj_shuriken_player1') !== -1 || body2.nature.indexOf('obj_trapdoor') !== -1)) {
			return false;
		}
		if (body1.sprite && body1.sprite.key == 'playerExitAnim') {
			return false;
		}
		if (body2.sprite && (body2.sprite.key.indexOf('obj_exit') !== -1 || body2.sprite.key == 'chainLink')) {
			return false;
		}
		if (body2.yellowWall) {
			this.yellowTouchPos = 'left';

			var bounceBak = Math.abs(bounceBackVelocity.x);
			if (bounceBak < 40) {
				bounceBak = 40;
			}
			body1.velocity.x = 3 * bounceBak;
			if (body1.velocity.x === 0) {
				body1.velocity.x = 120;
			}
			return false;
		}
		if (body2.nature && body2.nature === 'obj_log_100x10') {
			this.attachToTrapDoor = 'left';			
		}
		if (this.playerDoorLogjoint && (body2.nature && body2.nature !== 'obj_log_100x10')) {			
			return false;
		}

		if (this.carPlayerjoint && playerStickedToCar == 2) {
			return false;
		}
		if (this.playerSkateboardjoint && playerStickedSkateboard == 2) {
			return false;
		}
		console.log("left call back");
		if (body2.nature && (body2.nature.indexOf('fire') == -1 && body2.nature.indexOf('water_block') == -1 && body2.nature.indexOf('obj_track_long') == -1)) {
			//console.log(body2);
			originX = body1.x;
			originY = body1.y;
		}
		if (!this.circleselected.visible) {

			/*var woodslice = ["woodslice1","woodslice2", "woodslice3", "woodslice4","woodslice5","woodslice6"];
			if(body2.sprite){       
 if(body2.sprite.key){
				  
					if(body2.sprite.key.indexOf("obj_pathline")<0 && body2.sprite.key.indexOf("wood")<0 && body2.sprite.key.indexOf("arcade")<0 && body2.sprite.key.indexOf("glass")<0){
							console.log(body2.sprite);
							this.rightX="left";
							}
	 }
			}else{
					this.rightX="left";
			}*/
			if (body2.sprite) {
				if (body2.sprite.key && (body2.sprite.key.indexOf("obj_platform_metal") !== -1 || body2.sprite.key.indexOf("obj_platform_metal_x4") !== -1 || body2.sprite.key.indexOf("obj_floor_wood") !== -1 || body2.sprite.key.indexOf("obj_platform_stone") !== -1 || body2.sprite.key.indexOf("obj_floor_wood_long") !== -1)) {
					fixed = 1;
					body1.sprite.loadTexture('playerLookUp', 0, false);
					body1.sprite.animations.play('playerLookUp', 4, true);
				}
			}
			this.rightX = "left";
		}

		//this.humanPlayer.angle=90;
	},

	topCallback: function (body1, body2, fixture1, fixture2, begin) {
		//console.log("topCallback:");
		if (!body2) {
			return false;
		}

		else if (body2.type && (body2.type == 'breakableobject' || body2.type == 'enemy'|| body2.type == 'treasureobject')) {
			return false;
		}

		if (body2.nature && (body2.nature.indexOf('obj_exit') !== -1 || body2.nature.indexOf('obj_switch') !== -1 || body2.nature.indexOf('obj_shuriken_player1') !== -1)) {
			return false;
		}
		if (body1.sprite && body1.sprite.key == 'playerExitAnim') {
			return false;
		}
		if (body2.sprite && (body2.sprite.key.indexOf('obj_exit') !== -1 || body2.sprite.key == 'chainLink')) {
			return false;
		}
		if (body2.yellowWall) {
			this.yellowTouchPos = 'top';
			return false;
		}
		console.log("topCallback:");
		
		if (body2.nature && body2.nature === 'obj_log_100x10') {
			this.attachToTrapDoor = 'top';			
		}

		if (this.playerDoorLogjoint && (body2.nature && body2.nature !== 'obj_log_100x10')) {			
			return false;
		}

		if (this.carPlayerjoint && playerStickedToCar == 2) {
			return false;
		}
		if (this.playerSkateboardjoint && playerStickedSkateboard == 2) {
			return false;
		}
		console.log("top call back");
		if (body2.nature && (body2.nature.indexOf('fire_block') == -1 && body2.nature.indexOf('water_block') == -1 && body2.nature.indexOf('obj_track_long') == -1)) {
			//console.log(body2);
			originX = body1.x;
			originY = body1.y;
		}
		if (!this.circleselected.visible) {
			/*  var woodslice = ["woodslice1","woodslice2", "woodslice3", "woodslice4","woodslice5","woodslice6"];
				if(body2.sprite){
	 if(body2.sprite.key){
						if(body2.sprite.key.indexOf("obj_pathline")<0 && body2.sprite.key.indexOf("wood")<0 && body2.sprite.key.indexOf("arcade")<0 && body2.sprite.key.indexOf("glass")<0){
								this.rightX="top";    
						}
		 }
				}else{
						this.rightX="top";
				}*/
			if (body2.sprite) {
				if (body2.sprite.key && (body2.sprite.key.indexOf("obj_platform_metal") !== -1 || body2.sprite.key.indexOf("obj_platform_metal_x4") !== -1 || body2.sprite.key.indexOf("obj_floor_wood") !== -1 || body2.sprite.key.indexOf("obj_platform_stone") !== -1 || body2.sprite.key.indexOf("obj_floor_wood_long") !== -1)) {
					fixed = 1;
					body1.sprite.loadTexture('playerLookUp', 0, false);
					body1.sprite.animations.play('playerLookUp', 4, true);
				}
			}
			this.rightX = "top";

		}
		console.log("topCallback: " + this.rightX);

		//this.humanPlayer.angle=90;
	},

	bottomCallback: function (body1, body2, fixture1, fixture2, begin) {

		if (!body2) {
			return false;
		}
		else if (body2.type && (body2.type == 'breakableobject' || body2.type == 'enemy'|| body2.type == 'treasureobject')) {
			return false;
		}

		if (body2.nature && (body2.nature.indexOf('obj_exit') !== -1 || body2.nature.indexOf('obj_switch') !== -1 || body2.nature.indexOf('obj_shuriken_player1') !== -1 || body2.nature.indexOf('obj_trapdoor') !== -1)) {
			return false;
		}
		if (body1.sprite && body1.sprite.key == 'playerExitAnim') {
			return false;
		}
		if (body2.sprite && (body2.sprite.key.indexOf('obj_exit') !== -1 || body2.sprite.key == 'chainLink')) {
			return false;
		}
		if (body2.yellowWall) {
			this.yellowTouchPos = 'top';
			return false;
		}
		if (body2.nature && body2.nature === 'obj_log_100x10') {
			this.attachToTrapDoor = 'bottom';			
		}
		if (this.playerDoorLogjoint && (body2.nature && body2.nature !== 'obj_log_100x10')) {			
			return false;
		}

		if (this.carPlayerjoint && playerStickedToCar == 2) {
			return false;
		}
		if (this.playerSkateboardjoint && playerStickedSkateboard == 2) {
			return false;
		}
		console.log("bottom call back");

		if (body2.nature && (body2.nature.indexOf('fire') == -1 && body2.nature.indexOf('water_block') == -1 && body2.nature.indexOf('obj_track_long') == -1)) {
			//console.log(body2);
			originX = body1.x;
			originY = body1.y;
		}

		//console.log("bottomCallback:");
		if (!this.circleselected.visible) {
			/*  var woodslice = ["woodslice1","woodslice2", "woodslice3", "woodslice4","woodslice5","woodslice6"];
				if(body2.sprite){
	 if(body2.sprite.key){
						if(body2.sprite.key.indexOf("obj_pathline")<0 && body2.sprite.key.indexOf("wood")<0 && body2.sprite.key.indexOf("arcade")<0 && body2.sprite.key.indexOf("glass")<0){
								this.rightX="bottom";
						}
		 }
				}else{
						this.rightX="bottom";
				}*/
			if (body2.sprite) {
				if (body2.sprite.key && (body2.sprite.key.indexOf("obj_platform_metal") !== -1 || body2.sprite.key.indexOf("obj_platform_metal_x4") !== -1 || body2.sprite.key.indexOf("obj_floor_wood") !== -1 || body2.sprite.key.indexOf("obj_platform_stone") !== -1 || body2.sprite.key.indexOf("obj_floor_wood_long") !== -1)) {
					fixed = 1;

					body1.sprite.loadTexture('playerLookUp', 0, false);
					body1.sprite.animations.play('playerLookUp', 4, true);
				}
			}
			this.rightX = "bottom";
		}


		//this.humanPlayer.angle=90;
	},
  /*carRight : function(body1, body2, fixture1, fixture2, begin){
		if(!begin){
			return false;
		}
 	if((body2.sprite && body2.sprite.key.indexOf('player')==-1) || body2.sprite==null || body2.nature){
			return false;
		}
		this.carTouch = 'right';
		console.log('carRight');
		console.log(body2);
	},
	carLeft : function(body1, body2, fixture1, fixture2, begin){
		if(!begin){
			return false;
		}
		if((body2.sprite && body2.sprite.key.indexOf('player')==-1) || body2.sprite==null || body2.nature){
			return false;
		}
		this.carTouch = 'left';
		console.log('carLeft');
		console.log(body2);
	},
	carTop : function(body1, body2, fixture1, fixture2, begin){
		if(!begin){
			return false;
		}
		if((body2.sprite && body2.sprite.key.indexOf('player')==-1) || body2.sprite==null || body2.nature){
			return false;
		}
		this.carTouch = 'top';
		console.log('cartop');
		console.log(body2);
	},
	cartopLeft : function(body1, body2, fixture1, fixture2, begin){
		if(!begin){
			return false;
		}
		if((body2.sprite && body2.sprite.key.indexOf('player')==-1) || body2.sprite==null || body2.nature){
			return false;
		}
		this.carTouch = 'topleft';
		console.log('topleft');
		console.log(body2);
	},
	cartopRight: function(body1, body2, fixture1, fixture2, begin){
		if(!begin){
			return false;
		}
		if((body2.sprite && body2.sprite.key.indexOf('player')==-1) || body2.sprite==null || body2.nature){
			return false;
		}
		this.carTouch = 'topright';
		console.log('topright');
		console.log(body2);
	},

	carbackTop : function(body1, body2, fixture1, fixture2, begin){
		if(!begin){
			return false;
		}
		if((body2.sprite && body2.sprite.key.indexOf('player')==-1) || body2.sprite==null || body2.nature){
			return false;
		}
		this.carTouch = 'backtop';
		console.log('backtop');
		console.log(body2);
	},
	carfrontTop : function(body1, body2, fixture1, fixture2, begin){
		if(!begin){
			return false;
		}
		if((body2.sprite && body2.sprite.key.indexOf('player')==-1) || body2.sprite==null || body2.nature){
			return false;
		}
		this.carTouch = 'fronttop';
		console.log('backtop');
		console.log(body2);
	},*/

	trapdoorshape1: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			return false;
		}
		this.doorTouch = "first";

	},
	trapdoorshape2: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			return false;
		}
		this.doorTouch = "second";
	},
	trapdoorshape3: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			return false;
		}
		this.doorTouch = "top";
	},

	changeSwitch: function (body1, body2, fixture1, fixture2, begin) {
		if (StickyNinjaGlobals.soundOn) {
			gameGlobal.sfxSwitch.play();
		}
		var cdayval = getDay();
		var clevelVal = getLevel();
		//console.log(switchNo);

		if (body2.sprite)
			body2.sprite.visible = false;
		StickyNinjaGlobals.switchOn.visible = true;
		if (cdayval == 1) {
			if (StickyNinjaGlobals.doors.length > 0) {
				for (var index = 0; index < StickyNinjaGlobals.doors.length; index++) {
					if (StickyNinjaGlobals.doors[index].sprite)
						StickyNinjaGlobals.doors[index].sprite.visible = false;
					StickyNinjaGlobals.doors[index].destroy();
				}
			}

		}
		if (cdayval == 2) {
			//console.log(StickyNinjaGlobals.doors1);
			if (StickyNinjaGlobals.doors1.length > 0) {
				for (var index = 0; index < StickyNinjaGlobals.doors1.length; index++) {
					if (StickyNinjaGlobals.doors1[index].sprite)
						StickyNinjaGlobals.doors1[index].sprite.visible = false;
					StickyNinjaGlobals.doors1[index].destroy();
				}
			}
		}
		if (cdayval == 3) {
			//console.log(StickyNinjaGlobals.doors1);
			if (StickyNinjaGlobals.doors2.length > 0) {
				for (var index = 0; index < StickyNinjaGlobals.doors2.length; index++) {
					if (StickyNinjaGlobals.doors2[index].sprite)
						StickyNinjaGlobals.doors2[index].sprite.visible = false;
					StickyNinjaGlobals.doors2[index].destroy();
				}
			}

			if (StickyNinjaGlobals.doors3.length > 0) {
				for (var index = 0; index < StickyNinjaGlobals.doors3.length; index++) {
					if (StickyNinjaGlobals.doors3[index].sprite)
						StickyNinjaGlobals.doors3[index].sprite.visible = false;
					StickyNinjaGlobals.doors3[index].destroy();
				}
			}
		}

		if (begin) {
			switchon = true;
		}

		if ((cdayval == 2 && clevelVal == 2) || (cdayval == 3 && clevelVal == 1)) {
			for (var m in StickyNinjaGlobals.chainObjects2) {
				//console.log(StickyNinjaGlobals.chainObjects2[m]);
				StickyNinjaGlobals.chainObjects2[m].body.static = false;
				StickyNinjaGlobals.chainObjects2[m].body.velocity.x = 150;
				//StickyNinjaGlobals.chainObjects2[m].body.mass =50*m;
			}
			//game.physics.box2d.revoluteJoint(this.lastObj, sprite, 0, 25, 0, -10);
		}

		StickyNinjaGlobals.doors = [];
		body2.destroy();
	},

	changeSwitch1: function (body1, body2, fixture1, fixture2, begin) {
		if (StickyNinjaGlobals.soundOn) {
			gameGlobal.sfxSwitch.play();
		}
		var cdayval = getDay();
		var clevelVal = getLevel();
		//console.log(switchNo);

		if (body2.sprite)
			body2.sprite.visible = false;
		StickyNinjaGlobals.switchOn1.visible = true;

		if (cdayval == 3) {
			//console.log(StickyNinjaGlobals.doors1);

			if (StickyNinjaGlobals.doors4.length > 0) {
				for (var index = 0; index < StickyNinjaGlobals.doors4.length; index++) {
					if (StickyNinjaGlobals.doors4[index].sprite)
						StickyNinjaGlobals.doors4[index].sprite.visible = false;
					StickyNinjaGlobals.doors4[index].destroy();
				}
			}
		}

		if (begin) {
			switchon = true;
		}

		StickyNinjaGlobals.doors4 = [];
		body2.destroy();
	},
  subwaycar : function(body1, body2, fixture1, fixture2, begin){
		if (!begin) {
			return false;
		}

		if (StickyNinjaGlobals.soundOn) {
			//gameGlobal.sfxHitSticky.play();
		}
		body1.sprite.loadTexture('playerLookUp', 0, false);
		body1.sprite.animations.play('playerLookUp', 4, true);
		this.game.world.moveDown(body1.sprite);
		playerStickedToSubwaycarObject = body2;
		//fixed = 1;
		if (playerStickedToSubwaycar == 0) {
			playerStickedToSubwaycar = 1;

		}

	},
	stairs: function (body1, body2, fixture1, fixture2, begin) {
		if (!groundContacted) {
			flag = 0;
			//console.log("GROUND CONTACTED:",groundContacted);
			groundContacted = true;
			fixed = 1;
		}
		body1.sprite.loadTexture('playerLookUp', 0, false);
		body1.sprite.animations.play('playerLookUp', 4, true);
		flag = 0;
		//console.log("GROUND CONTACTED:",groundContacted);
		groundContacted = true;
		fixed = 1;
	},
	mushrooms: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			return;
		}
		comboRights = true;
		var cdayval = getDay();
		var clevelVal = getLevel();
		/*if ((cdayval == 3 && clevelVal == 5)) {
			this.humanPlayer.body.velocity.y = -1.5 * this.humanPlayer.body.velocity.y;
			this.humanPlayer.body.velocity.x = 3 * this.humanPlayer.body.velocity.x;
		} if ((cdayval == 3 && clevelVal == 2 || cdayval == 2 && clevelVal == 1)) {
			this.humanPlayer.body.velocity.y = -1 * this.humanPlayer.body.velocity.y;
			this.humanPlayer.body.velocity.x = 1 * this.humanPlayer.body.velocity.x;
		} else {
			this.humanPlayer.body.velocity.x = -1 * ((this.humanPlayer.body.velocity.x - this.humanPlayer.body.velocity.x) + 10);
			this.humanPlayer.body.velocity.y = -1 * this.humanPlayer.body.velocity.y;
		}*/

		if (StickyNinjaGlobals.soundOn) {
			gameGlobal.sfxHitBouncy.play();
		}

		hitCountNo = hitCountNo + 1;

		if (hitCountNo > 8) {
			//this.humanPlayer.body.velocity.x = 3 * this.humanPlayer.body.velocity.x;
		}

		//X1 image to display when player hit yellow walls
		var score1 = gameGlobal.add.sprite(body1.x, body1.y, 'score' + hitCountNo);
		score1.scale.x = 0.5;
		score1.scale.y = 0.5;


		//var tweenguide2 = gameGlobal.add.tween(score1).to({ x: body1.x + 50, y: body1.y }, 1000, Phaser.Easing.InOut, true);
		var tweenguide2 = gameGlobal.add.tween(score1.scale).to({ x: 1.5, y: 1.5 }, 1500, Phaser.Easing.InOut, true);
		tweenguide2.onComplete.add(function () {
			score1.scale.x = 0;
			score1.scale.y = 0;
		}, this);
	},

	killPlayerInFire: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			//body1.angle=0;
			playerKilled = 0;
			return;
		}
		this.game.world.moveDown(body1.sprite);
		playerkilledinwaterFire = 1;
		playerkilledother = 0;

		if (body1.nature && body1.nature == 'enemy_b_idle') {

			if (this.game.destroyEnemyinFire !== this.game.time.now) {
				this.game.destroyEnemyinFire = this.game.time.now;
			} else {
				return false;
			}

			hitCountNo = hitCountNo + 1;
			console.log(StickyNinjaGlobals.OthershurikenEnemies);
			for (var i = 0; i < StickyNinjaGlobals.OthershurikenEnemies.length; i++) {
				if (body1.id === StickyNinjaGlobals.OthershurikenEnemies[i].body.id) {
					StickyNinjaGlobals.OthershurikenEnemies.splice(i, 1);

				}
			}
			//X1 image to display when player hit yellow walls
			var score1 = gameGlobal.add.sprite(body1.x, body1.y, 'score' + hitCountNo);
			score1.scale.x = 0.5;
			score1.scale.y = 0.5;


			//var tweenguide2 = gameGlobal.add.tween(score1).to({ x: body1.x + 50, y: body1.y }, 1000, Phaser.Easing.InOut, true);
			var tweenguide2 = gameGlobal.add.tween(score1.scale).to({ x: 1.5, y: 1.5 }, 1500, Phaser.Easing.InOut, true);
			tweenguide2.onComplete.add(function () {
				score1.scale.x = 0;
				score1.scale.y = 0;
			}, this);
			//console.log("22222222222222222 : "+ hitCountNo);
			score = score + (hitCountNo * 50);
			//console.log("22222222222222222 score: "+ score);
			//score = score + 30;
			goldCountText.setText(score);
			if (typeof scoreText !== 'undefined') {
				scoreText.setText(score + " / 2000");
			}
			enemiesKilled++;
			var day = getDay();
			var level = getLevel() - 1;
			enemykilledText.setText(enemiesKilled + "/" + StickyNinjaGlobals.enemiesToBeKilled[day][level]);

			this.fixedBall.x = body2.x;
			this.fixedBall.y = body2.y;
			this.fixedBall.scale.x = 1;
			this.fixedBall.scale.y = 1;
			this.fixedBall.visible = true;
			this.fixedBallTweening = true;


			if (body1.sprite) {
				body1.sprite.animations.play("hit");
			}
			//if(body2.angle > 2 || body2.angle < 0) {
			if (StickyNinjaGlobals.soundOn) {
				gameGlobal.sfxHitEnemy.play();
			}

			var day = getDay();
			var level = getLevel() - 1;
			//console.log("ENEMIES TO BE KILLED:-->",StickyNinjaGlobals.enemiesToBeKilled[day][level]);
			//console.log("ENEMIES KILLED:-->", enemiesKilled);

			if (activateEnemiesKilling && !mutipleConditionsToCompleteLevel) {
				if (enemiesKilled == StickyNinjaGlobals.enemiesToBeKilled[day][level]) {
					StickyNinjaGlobals.levelCompleted = 1;
					StickyNinjaGlobals.triggerExitDoor = 1;
				}
			} else if (activateEnemiesKilling && mutipleConditionsToCompleteLevel) {
				if (enemiesKilled == StickyNinjaGlobals.enemiesToBeKilled[day][level]) {
					counterToCompleteLevel++;
				}
			}

			body1.destroy();


		}
		if (body1.nature && body1.nature == 'enemy_c_idle') {

			if (this.game.destroyEnemyinFire !== this.game.time.now) {
				this.game.destroyEnemyinFire = this.game.time.now;
			} else {
				return false;
			}

			hitCountNo = hitCountNo + 1;
			console.log(StickyNinjaGlobals.OthershurikenEnemies);
			for (var i = 0; i < StickyNinjaGlobals.OthershurikenEnemies.length; i++) {
				if (body1.id === StickyNinjaGlobals.OthershurikenEnemies[i].body.id) {
					StickyNinjaGlobals.OthershurikenEnemies.splice(i, 1);

				}
			}
			//X1 image to display when player hit yellow walls
			var score1 = gameGlobal.add.sprite(body1.x, body1.y, 'score' + hitCountNo);
			score1.scale.x = 0.5;
			score1.scale.y = 0.5;


			//var tweenguide2 = gameGlobal.add.tween(score1).to({ x: body1.x + 50, y: body1.y }, 1000, Phaser.Easing.InOut, true);
			var tweenguide2 = gameGlobal.add.tween(score1.scale).to({ x: 1.5, y: 1.5 }, 1500, Phaser.Easing.InOut, true);
			tweenguide2.onComplete.add(function () {
				score1.scale.x = 0;
				score1.scale.y = 0;
			}, this);
			//console.log("22222222222222222 : "+ hitCountNo);
			score = score + (hitCountNo * 50);
			//console.log("22222222222222222 score: "+ score);
			//score = score + 30;
			goldCountText.setText(score);
			if (typeof scoreText !== 'undefined') {
				scoreText.setText(score + " / 2000");
			}
			enemiesKilled++;
			var day = getDay();
			var level = getLevel() - 1;
			enemykilledText.setText(enemiesKilled + "/" + StickyNinjaGlobals.enemiesToBeKilled[day][level]);

			this.fixedBall.x = body2.x;
			this.fixedBall.y = body2.y;
			this.fixedBall.scale.x = 1;
			this.fixedBall.scale.y = 1;
			this.fixedBall.visible = true;
			this.fixedBallTweening = true;


			if (body1.sprite) {
				body1.sprite.animations.play("hit");
			}
			//if(body2.angle > 2 || body2.angle < 0) {
			if (StickyNinjaGlobals.soundOn) {
				gameGlobal.sfxHitEnemy.play();
			}

			var day = getDay();
			var level = getLevel() - 1;
			//console.log("ENEMIES TO BE KILLED:-->",StickyNinjaGlobals.enemiesToBeKilled[day][level]);
			//console.log("ENEMIES KILLED:-->", enemiesKilled);

			if (activateEnemiesKilling && !mutipleConditionsToCompleteLevel) {
				if (enemiesKilled == StickyNinjaGlobals.enemiesToBeKilled[day][level]) {
					StickyNinjaGlobals.levelCompleted = 1;
					StickyNinjaGlobals.triggerExitDoor = 1;
				}
			} else if (activateEnemiesKilling && mutipleConditionsToCompleteLevel) {
				if (enemiesKilled == StickyNinjaGlobals.enemiesToBeKilled[day][level]) {
					counterToCompleteLevel++;
				}
			}

			body1.destroy();


		} else {


			body1.sensor = true;
			body1.velocity.y = 700;
			this.game.world.bringToTop(body2.sprite);
			this.game.world.bringToTop(StickyNinjaGlobals.gameMenu);
			this.game.world.bringToTop(StickyNinjaGlobals.gameMenuPopupGroup);
			fixed = 1;
			if (playerKilled == 0) {
				playerKilled = 1;
				lives++;
				if (StickyNinjaGlobals.playerLifes - lives < 0) {
					heartValueCountText.setText(0);
				} else {
					heartValueCountText.setText(StickyNinjaGlobals.playerLifes - lives);
				}

				pushPlayerOnce = true;
			}

			if (lives == StickyNinjaGlobals.playerLifes) {
				if (body1.sprite) {
					//body1.sprite.visible = false;
				}
			}
		}
	},

	skating: function (body1, body2, fixture1, fixture2, begin) {

		if (!begin) {
			//this.trapdoorobject=0;
			return;
		}

		body1.sprite.loadTexture('playerLookUp', 0, false);
		body1.sprite.animations.play('playerLookUp', 4, true);
		if (playerStickedSkateboard == 0) {
			//gameGlobal.physics.box2d.weldJoint(body1.sprite, body2.sprite);
			//body2.static = false;
			console.log("skating");
			playerStickedSkateboard = 1;
			this.skateboardObject = body2;
			body1.velocity.x = -0;
			body1.velocity.y = -0;
			flag = 0;
			if(body2.x > jumpPos){
				body2.velocity.x = 250;
        body1.velocity.x = 250;
			}else{
				body2.velocity.x = -250;
        body1.velocity.x = -250;
			}
					
			this.game.world.bringToTop(body2.sprite);
			this.game.world.bringToTop(StickyNinjaGlobals.gameMenu);
			this.game.world.bringToTop(StickyNinjaGlobals.gameMenuPopupGroup);

		}

		//groundContacted = true;
		//fixed=1;
		//console.log("Player Skating--END");
	},


	boatMovement : function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			console.log(body1);
			//this.trapdoorobject=0;
			return;
		}


		body1.sprite.loadTexture('playerLookUp', 0, false);
		body1.sprite.animations.play('playerLookUp', 4, true);
		if (playerStickedboat == 0) {
			//gameGlobal.physics.box2d.weldJoint(body1.sprite, body2.sprite);
			//body2.static = false;
			console.log("boat");
			playerStickedboat = 1;
			this.boatObject = body2;
			body1.velocity.x = -0;
			body1.velocity.y = -0;
			flag = 0;
			body2.velocity.x = 150;
			body1.velocity.x = 150;
			this.game.world.bringToTop(body2.sprite);
			this.game.world.bringToTop(StickyNinjaGlobals.gameMenu);
			this.game.world.bringToTop(StickyNinjaGlobals.gameMenuPopupGroup);

		}
	},
	killPlayer: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			//body1.angle=0;
			playerKilled = 0;
			return false;
		}
		playerkilledother = 1;
		playerkilledinwaterFire = 0;
		if (this.game.killPlayertime !== this.game.time.now) {
			this.game.killPlayertime = this.game.time.now;
		} else {
			return false;
		}
		if (this.playerkilledOnce == 1) {
			return false;
		}

		if (playerKilled == 0) {
			playerKilled = 1;
			lives++;
			if (StickyNinjaGlobals.playerLifes - lives < 0) {
				heartValueCountText.setText(0);
			} else {
				heartValueCountText.setText(StickyNinjaGlobals.playerLifes - lives);
			}

			if(body2.nature && body2.nature =='obj_ball_spiky'){
				body1.sensor = true;
			}

			pushPlayerOnce = true;
			console.log(pushPlayerOnce + "pushPlayerOnce");
			this.killedBYobjspikebar = 0;
			if (body2.nature && body2.nature == 'obj_spikebar') {
				this.killedBYobjspikebar = 1;
			}
			//console.log(body2);
			//console.log("Player Killed:-->", lives);
			//console.log("Player Killed:-->", body1.x, body1.y, originX, originY);
			//body1.x = originX;
			//body1.y = originY;
			//body1.sprite.angle = prevAngle;	
			//	body1.sprite.loadTexture('playerBase', 0);
			//body1.sprite.animations.stop(null, true);

		}

		if (lives == StickyNinjaGlobals.playerLifes) {

			//	window.StickyNinjaMission.state.menu.openResultScreen("levelFailedLife");
		}
	},

	captureDiamond: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			return false;
		}
		comboRights = true;
		if (this.game.captureDiamondtime !== this.game.time.now) {
			this.game.captureDiamondtime = this.game.time.now;
		} else {
			return false;
		}
		var day = getDay();
		var level = getLevel();
		hitCountNo = hitCountNo + 1;

		//X1 image to display when player hit yellow walls
		var score1 = gameGlobal.add.sprite(body1.x, body1.y, 'score' + hitCountNo);
		score1.scale.x = 0.5;
		score1.scale.y = 0.5;


		//var tweenguide2 = gameGlobal.add.tween(score1).to({ x: body1.x + 50, y: body1.y }, 1000, Phaser.Easing.InOut, true);
		var tweenguide2 = gameGlobal.add.tween(score1.scale).to({ x: 1.5, y: 1.5 }, 1500, Phaser.Easing.InOut, true);
		tweenguide2.onComplete.add(function () {
			score1.scale.x = 0;
			score1.scale.y = 0;
		}, this);
		score = score + (hitCountNo * 100);
		//score = score + 100;
		goldCountText.setText(score);
		if (typeof scoreText !== 'undefined') {
			scoreText.setText(score + " / 2000");
		}
		if (StickyNinjaGlobals.soundOn) {
			gameGlobal.sfxTreasure.play();
		}
		if (activateTreasuriesCapturing) {
			treasuriesCaptured++;
		}
		if (body2.sprite) {
			body2.sprite.visible = false;
		}
		console.log(StickyNinjaGlobals.treasury["" + day + "," + level]);
		if (activateTreasuriesCapturing && !mutipleConditionsToCompleteLevel) {
			if (treasuriesCaptured == StickyNinjaGlobals.treasury["" + day + "," + level]) {
				StickyNinjaGlobals.levelCompleted = 1;
				StickyNinjaGlobals.triggerExitDoor = 1;
			}
		} else if (activateTreasuriesCapturing && mutipleConditionsToCompleteLevel) {
			if (treasuriesCaptured == StickyNinjaGlobals.treasury["" + day + "," + level]) {
				counterToCompleteLevel++;
			}
		}

		body2.destroy();
		flag = 0;
		groundContacted = true;
		//fixed=1;

		if (typeof treasuriesText !== 'undefined') {
			treasuriesText.setText(treasuriesCaptured + "/" + StickyNinjaGlobals.treasury["" + day + "," + level]);
		}
	},

	exitDoor: function (body1, body2, fixture1, fixture2, begin) {
		//console.log("EXIT DOOR TOUCHED:",StickyNinjaGlobals.triggerExitDoor);
		//console.log("EXIT DOOR TOUCHED1:",body1);

		if (StickyNinjaGlobals.triggerExitDoor == 1) {
			//console.log("EXIT DOOR TOUCHED1:", body1.x, body1.y);
			exitDoorWidth = 0;
			exitDoorHeight = 0;
			exitDoorWidth = body2.x;
			exitDoorHeight = body2.y;
			if (body1.x < body2.x) {
				dirOfExitDoor = 1;
			} else {
				dirOfExitDoor = -1;
			}

			StickyNinjaGlobals.triggerExitDoor = 2;
		}

	},

	destroyCrateWoodObject: function (body1, body2, fixture1, fixture2, begin) {
		body1.damping = 0;
		//console.log(body2.sprite.key);
		comboRights = true;
		if (!begin) {
			if (prevJump == -1) {
				prevJump = jumps;
				counter = 1;
			} else if (prevJump == jumps) {
				counter++;
			} else {
				prevJump = jumps;
				counter = 1;
			}


			if (this.game.destroyCrateWoodtime !== body2.id) {
				this.game.destroyCrateWoodtime = body2.id;
			} else {
				return false;
			}


			hitCountNo = hitCountNo + 1;

			var slices = new Array();
			var dir = -1;
			/*if (StickyNinjaGlobals.objectsToDestroy.length>0) {
				for (var index=0;index<StickyNinjaGlobals.objectsToDestroy.length;index++) {
					if(StickyNinjaGlobals.objectsToDestroy[index].sprite) {
						StickyNinjaGlobals.objectsToDestroy[index].sprite.destroy();
						StickyNinjaGlobals.objectsToDestroy[index].destroy();
					}
				}
			}
			StickyNinjaGlobals.objectsToDestroy=[];*/
			for (var index = 0; index < 6; index++) {
				var name = "woodslice";
				if (explodeAnimationKeyName.indexOf("wood") >= 0) {
					name = "woodslice";
					if (StickyNinjaGlobals.soundOn) {
						var smashVal = Math.floor((Math.random() * 3) + 1);
						if (smashVal == 1) {
							gameGlobal.sfxSmashWood1.play();
						}
						else if (smashVal == 2) {
							gameGlobal.sfxSmashWood2.play();
						}
						else {
							gameGlobal.sfxSmashWood1.play();
						}
					}
				} else if (explodeAnimationKeyName.indexOf("arcade") >= 0) {
					name = "arcadeslice";
					if (StickyNinjaGlobals.soundOn) {
						var smashVal = Math.floor((Math.random() * 3) + 1);
						if (smashVal == 1) {
							gameGlobal.sfxSmash1.play();
						}
						else if (smashVal == 2) {
							gameGlobal.sfxSmash2.play();
						}
						else if (smashVal == 3) {
							gameGlobal.sfxSmash3.play();
						}
					}
				} else if (explodeAnimationKeyName.indexOf("glass") >= 0) {
					name = "glassslice";
					if (StickyNinjaGlobals.soundOn) {
						var smashVal = Math.floor((Math.random() * 3) + 1);
						if (smashVal == 1) {
							gameGlobal.sfxSmash1.play();
						}
						else if (smashVal == 2) {
							gameGlobal.sfxSmash2.play();
						}
						else if (smashVal == 3) {
							gameGlobal.sfxSmash3.play();
						}
					}
				} else {
					if (StickyNinjaGlobals.soundOn) {
						var smashVal = Math.floor((Math.random() * 3) + 1);
						if (smashVal == 1) {
							gameGlobal.sfxSmashWood1.play();
						}
						else if (smashVal == 2) {
							gameGlobal.sfxSmashWood2.play();
						}
						else {
							gameGlobal.sfxSmashWood1.play();
						}
					}
				}
				var slice = gameGlobal.add.sprite(body1.x, body1.y + (index * 3), name + (index + 1));
				slice.scale.x = 0.6;
				slice.scale.y = 0.6;
				slices.push(slice);

				gameGlobal.physics.box2d.enable(slices[index]);

				/*var f = slices[index].body.data.GetFixtureList();
				var filter = f.GetFilterData();
				 filter.groupIndex = -1;*/

				for (var f = slices[index].body.data.GetFixtureList(); f; f = f.GetNext()) {
					var filter = f.GetFilterData();
					filter.groupIndex = -1;
				}


				slices[index].body.mass = 0.1;
				slices[index].body.sensor = true;
				slices[index].body.gravityScale = 0.5;
				StickyNinjaGlobals.objectsToDestroy.push(slices[index].body);
				var force = 10;

				//if (index%2==0) 
				{
					//force=30+dir*(index*10);
					dir *= -1;
				}
				force = (force + index * 5) * dir;
				slices[index].body.applyForce(force, index);
				slices[index].body.angularVelocity = (dir + index * 2) * 50;
			}

			//X1 image to display when player hit yellow walls
			var score1 = gameGlobal.add.sprite(body1.x, body1.y, 'score' + hitCountNo);
			score1.scale.x = 0.5;
			score1.scale.y = 0.5;


			//var tweenguide2 = gameGlobal.add.tween(score1).to({ x: body1.x + 50, y: body1.y }, 1000, Phaser.Easing.InOut, true);
			var tweenguide2 = gameGlobal.add.tween(score1.scale).to({ x: 1.5, y: 1.5 }, 1500, Phaser.Easing.InOut, true);
			tweenguide2.onComplete.add(function () {
				score1.scale.x = 0;
				score1.scale.y = 0;
			}, this);

			score = score + (hitCountNo * 5);
			goldCountText.setText(score);
			if (typeof scoreText !== 'undefined') {
				scoreText.setText(score + " / 2000");
			}
			if (activateSmashObjectsCapturing) {
				smashedObjectsCaptured++;
			}
			
			

			var currentDay = getDay();
			var currentLevel = getLevel();
			if (((currentDay == 2 && currentLevel == 2) || (currentDay == 3 && currentLevel == 1)) && body2.nature && body2.nature == 'obj_plank_fixed') {
				//body1.velocity.x = 150;
				//	body1.applyForce(30,0);
				if (playerStickedToLog1 == 0) {
					playerStickedToLog1 = 1;
				}
				setTimeout(function () {
					for (var key in StickyNinjaGlobals.chainObjects) {
						StickyNinjaGlobals.chainObjects[key].body.static = false;
						StickyNinjaGlobals.chainObjects[key].body.velocity.x = 200;
						StickyNinjaGlobals.chainObjects[key].body.mass = 50 * key;
					}
				}, 300);


			}
			//console.log("SCORE:-->", score);
			var day = getDay();
			var level = getLevel();
			console.log(StickyNinjaGlobals.smashall["" + day + "," + level]);
			if (activateSmashObjectsCapturing && !mutipleConditionsToCompleteLevel) {
				console.log(StickyNinjaGlobals.smashall["" + day + "," + level]);
				if (smashedObjectsCaptured == StickyNinjaGlobals.smashall["" + day + "," + level]) {
					console.log("sdsadDDsssssssssssssssss");
					
					StickyNinjaGlobals.levelCompleted = 1;
					StickyNinjaGlobals.triggerExitDoor = 1;
				}
			} else if (activateSmashObjectsCapturing && mutipleConditionsToCompleteLevel) {
				console.log("tttttttttttttttttttttttttttt");
				if (smashedObjectsCaptured == StickyNinjaGlobals.smashall["" + day + "," + level]) {
					counterToCompleteLevel++;
					console.log(StickyNinjaGlobals.smashall["" + day + "," + level]);
				}
				console.log(StickyNinjaGlobals.smashall["" + day + "," + level]);
			}
			if (typeof smashesText !== 'undefined') {
				smashesText.setText(smashedObjectsCaptured + " / 11");
			}
			if (typeof scoreText !== 'undefined') {
				scoreText.setText(score + " / 2000");
			}

		}

		if (body2.sprite) {
			body2.sprite.visible = false;
			explodeAnimationKeyName = body2.sprite.key;
		}
		body2.destroy();
		flag = 0;
		groundContacted = true;
		//fixed=1;


	},

	destroyEnemyObject: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			return false;
		}
		//console.log(body1);
		if (body1.nature && body1.nature == 'obj_skateboard') {
			body1.velocity.x = -80;
		}
		if (this.game.destroyEnemyObjecttime !== this.game.time.now) {
			this.game.destroyEnemyObjecttime = this.game.time.now;
		} else {
			return false;
		}
		if (activateCombo == true) {
			if (comboRights == false) {
				//return false;
				//Mamallan make changes here
				/* if (StickyNinjaGlobals.soundOn) {
					gameGlobal.sfxPlayerDie.play();
				} */
				//window.StickyNinjaMission.state.menu.openResultScreen("levelFailedLife");
				window.setTimeout(StickyNinjaMission.state.menu.openResultScreen("levelFailedLife"), 2000);

			}
		}


		for (var i = 0; i < StickyNinjaGlobals.OthershurikenEnemies.length; i++) {
			if (body2.id === StickyNinjaGlobals.OthershurikenEnemies[i].body.id) {
				StickyNinjaGlobals.OthershurikenEnemies.splice(i, 1);

			}
		} console.log(StickyNinjaGlobals.OthershurikenEnemies);

		hitCountNo = hitCountNo + 1;

		//X1 image to display when player hit yellow walls
		var score1 = gameGlobal.add.sprite(body1.x, body1.y, 'score' + hitCountNo);
		score1.scale.x = 0.5;
		score1.scale.y = 0.5;


		//var tweenguide2 = gameGlobal.add.tween(score1).to({ x: body1.x + 50, y: body1.y }, 1000, Phaser.Easing.InOut, true);
		var tweenguide2 = gameGlobal.add.tween(score1.scale).to({ x: 1.5, y: 1.5 }, 1500, Phaser.Easing.InOut, true);
		tweenguide2.onComplete.add(function () {
			score1.scale.x = 0;
			score1.scale.y = 0;
		}, this);
		var multiplyNo = 30;
		if (body1.nature && (body1.nature == 'obj_skateboard' || body1.nature == 'obj_car_b')) {
			multiplyNo = 100;
		}
		score = score + (hitCountNo * multiplyNo);
		//score = score + 30;
		goldCountText.setText(score);
		if (typeof scoreText !== 'undefined') {
			scoreText.setText(score + " / 2000");
		}
		enemiesKilled++;
		var day = getDay();
		var level = getLevel() - 1;
		enemykilledText.setText(enemiesKilled + "/" + StickyNinjaGlobals.enemiesToBeKilled[day][level]);
		if (comboText)
			comboText.setText(enemiesKilled + "/" + StickyNinjaGlobals.enemiesToBeKilled[day][level]);


		this.fixedBall.x = body2.x;
		this.fixedBall.y = body2.y;
		this.fixedBall.scale.x = 1;
		this.fixedBall.scale.y = 1;
		this.fixedBall.visible = true;
		this.fixedBallTweening = true;

		if (body2.sprite) {
			body2.sprite.animations.play("hit");
		}
		//if(body2.angle > 2 || body2.angle < 0) {
		if (StickyNinjaGlobals.soundOn) {
			gameGlobal.sfxHitEnemy.play();
		}

		var day = getDay();
		var level = getLevel() - 1;
		//console.log("ENEMIES TO BE KILLED:-->",StickyNinjaGlobals.enemiesToBeKilled[day][level]);
		//console.log("ENEMIES KILLED:-->", enemiesKilled);

		if (activateEnemiesKilling && !mutipleConditionsToCompleteLevel) {
			if (enemiesKilled == StickyNinjaGlobals.enemiesToBeKilled[day][level]) {
				StickyNinjaGlobals.levelCompleted = 1;
				StickyNinjaGlobals.triggerExitDoor = 1;
			}
		} else if (activateEnemiesKilling && mutipleConditionsToCompleteLevel) {
			if (enemiesKilled == StickyNinjaGlobals.enemiesToBeKilled[day][level]) {
				counterToCompleteLevel++;
			}
		}

		body2.destroy();

		//}
		flag = 0;
		groundContacted = true;
		//fixed=1;

	},
	destroyEnemyObject2: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			//body1.angle=0;
			playerKilled = 0;
			return false;
		}
		//console.log("destroyEnemyObject2");
		//console.log(body1.sprite.key);
		//this.trapdoorobject = 0;
		if (body1.sprite && body1.sprite.key.indexOf('player') !== -1) {      

			if (this.playerkilledOnce == 1) {
				return false;
			}

			if (playerKilled == 0) {
				playerKilled = 1;
				lives++;
				if (StickyNinjaGlobals.playerLifes - lives < 0) {
					heartValueCountText.setText(0);
				} else {
					heartValueCountText.setText(StickyNinjaGlobals.playerLifes - lives);
				}
				pushPlayerOnce = true;
				this.killedBYobjspikebar = 0;
				//console.log("body2.nature: "+body2.nature);
				if (body2.nature && body2.nature == 'enemy_c_idle') {
					this.killedBYobjspikebar = 1;
				}
			}

		} else {
			if (this.game.destroyEnemyObjecttime !== this.game.time.now) {
				this.game.destroyEnemyObjecttime = this.game.time.now;
			} else {
				return false;
			}



			for (var i = 0; i < StickyNinjaGlobals.OthershurikenEnemies.length; i++) {
				if (body2.id === StickyNinjaGlobals.OthershurikenEnemies[i].body.id) {
					StickyNinjaGlobals.OthershurikenEnemies.splice(i, 1);

				}
			} console.log(StickyNinjaGlobals.OthershurikenEnemies);

			hitCountNo = hitCountNo + 1;

			//X1 image to display when player hit yellow walls
			var score1 = gameGlobal.add.sprite(body1.x, body1.y, 'score' + hitCountNo);
			score1.scale.x = 0.5;
			score1.scale.y = 0.5;


			//var tweenguide2 = gameGlobal.add.tween(score1).to({ x: body1.x + 50, y: body1.y }, 1000, Phaser.Easing.InOut, true);
			var tweenguide2 = gameGlobal.add.tween(score1.scale).to({ x: 1.5, y: 1.5 }, 1500, Phaser.Easing.InOut, true);
			tweenguide2.onComplete.add(function () {
				score1.scale.x = 0;
				score1.scale.y = 0;
			}, this);
			//console.log("22222222222222222 : "+ hitCountNo);
			score = score + (hitCountNo * 100);
			//console.log("22222222222222222 score: "+ score);
			//score = score + 30;
			goldCountText.setText(score);
			if (typeof scoreText !== 'undefined') {
				scoreText.setText(score + " / 2000");
			}
			enemiesKilled++;
			var day = getDay();
			var level = getLevel() - 1;
			enemykilledText.setText(enemiesKilled + "/" + StickyNinjaGlobals.enemiesToBeKilled[day][level]);

			this.fixedBall.x = body2.x;
			this.fixedBall.y = body2.y;
			this.fixedBall.scale.x = 1;
			this.fixedBall.scale.y = 1;
			this.fixedBall.visible = true;
			this.fixedBallTweening = true;

			if (body2.sprite) {
				body2.sprite.animations.play("hit");
			}
			//if(body2.angle > 2 || body2.angle < 0) {
			if (StickyNinjaGlobals.soundOn) {
				gameGlobal.sfxHitEnemy.play();
			}

			var day = getDay();
			var level = getLevel() - 1;
			//console.log("ENEMIES TO BE KILLED:-->",StickyNinjaGlobals.enemiesToBeKilled[day][level]);
			//console.log("ENEMIES KILLED:-->", enemiesKilled);

			if (activateEnemiesKilling && !mutipleConditionsToCompleteLevel) {
				if (enemiesKilled == StickyNinjaGlobals.enemiesToBeKilled[day][level]) {
					StickyNinjaGlobals.levelCompleted = 1;
					StickyNinjaGlobals.triggerExitDoor = 1;
				}
			} else if (activateEnemiesKilling && mutipleConditionsToCompleteLevel) {
				if (enemiesKilled == StickyNinjaGlobals.enemiesToBeKilled[day][level]) {
					counterToCompleteLevel++;
				}
			}

			body2.destroy();

			//}
			flag = 0;
			groundContacted = true;
		}

	},
	intractingObject: function (body1, body2, fixture1, fixture2, begin) {

		if (!groundContacted) {
			flag = 0;
			//console.log("GROUND CONTACTED:",groundContacted);
			groundContacted = true;
			fixed = 1;

		}
		if (StickyNinjaGlobals.soundOn) {
			gameGlobal.sfxHitSticky.play();
		}
		body1.sprite.loadTexture('playerBase', 0);
		body1.sprite.animations.stop(null, true);

		//body1.sprite.loadTexture('playerLookUp', 0);
		//body1.sprite.animations.play('playerLookUp');

		if (kickDirection == 1) {
			body1.angle = -90;
		}

		flag = 0;
		groundContacted = true;
		fixed = 1;

		//console.log("intractingObject");
		var day = getDay();
		var level = getLevel();

		if (day === 1 && level == 1 && body2.sprite) {

			if (body2.sprite.key.indexOf('obj_platform_metal') > 0) {

				if (body2.sprite.rotation == 0) {
					this.rightX = "top";
				} else {
					this.rightX = "left";
				}
			}
			if (body2.sprite.key.indexOf('obj_floor_wood') > 0) {
				this.rightX = "bottom";
			}

		}
		else if (day === 1 && level == 4 && body2.sprite) {
			if (body2.sprite.key.indexOf('obj_floor_wood_long') > 0) {
				this.rightX = "top";
			}
			if (body2.sprite.key.indexOf('obj_floor_wood') > 0) {
				this.rightX = "bottom";
			}

		} else {

			if (body2.sprite) {
				this.rightX = "bottom";
			}

		}
	},
	trapdoor: function (body1, body2, fixture1, fixture2, begin) {
		if (!begin) {
			return false;
		}

		if (StickyNinjaGlobals.soundOn) {
			//gameGlobal.sfxHitSticky.play();
		}
		body1.sprite.loadTexture('playerLookUp', 0, false);
		body1.sprite.animations.play('playerLookUp', 4, true);
		//	flag = 0;
		trapDoorIndex = body2.indexNum;
		//fixed = 1;
		console.log(trapdoorobject);
		if (trapdoorobject == 0) {
			trapdoorobject = 1;
		}
	},

	hitobject: function (body1, body2, fixture1, fixture2, begin) {
		body1.linearDamping = 0;
		if (body2.nature && body2.nature === 'obj_fixed_joint') {
			return;
		}
			originX = body1.x;
			originY = body1.y;
		//console.log(body2);
		//Below is for player to stick to car
		playerStickedToCar = false;
		comboRights = false;

		//this.trapdoorobject = 0;
		if (!groundContacted) {
			flag = 0;
			//console.log("GROUND CONTACTED:",groundContacted);
			groundContacted = true;
			fixed = 1;
		}
		if (StickyNinjaGlobals.soundOn) {
			gameGlobal.sfxHitSticky.play();
		}

		//body1.sprite.visible = false;
		body1.sprite.loadTexture('playerLookUp', 0, false);
		body1.sprite.animations.play('playerLookUp', 4, true);
		//body1.sprite.loadTexture('playerLookUp', 0);
		//body1.sprite.animations.play('playerLookUp');

		if (kickDirection == 1) {
			body1.angle = -90;
		}

		flag = 0;
		groundContacted = true;
		fixed = 1;
		/*this.humanPlayer.body.static = true;
		this.humanPlayer.body.velocity.x = -0;
		this.humanPlayer.body.velocity.y = -0;*/
	},

	hitobject1: function (body1, body2, fixture1, fixture2, begin) {
		//this.trapdoorobject = 0;
		//body1.linearDamping = 20; 
	},

	yellowWall: function (body1, body2, fixture1, fixture2, begin) {
		if (begin && yellowWalltween == 0) {
			body2.yellowWall = 1;
			var tempVelX = body1.velocity.x;
			var tempVelY = body1.velocity.y;
			comboRights = true;
			hitCountNo = hitCountNo + 1;

			//X1 image to display when player hit yellow walls
			var score1 = gameGlobal.add.sprite(body1.x, body1.y, 'score' + hitCountNo);
			score1.scale.x = 0.5;
			score1.scale.y = 0.5;



			//var tweenguide2 = gameGlobal.add.tween(score1).to({ x: body1.x + 50, y: body1.y }, 1000, Phaser.Easing.InOut, true);
			//if (yellowWalltween == 0) {
			yellowWalltween = 1;
			var tweenguide2 = gameGlobal.add.tween(score1.scale).to({ x: 1.5, y: 1.5 }, 700, Phaser.Easing.InOut, true);
			tweenguide2.onComplete.add(function () {
				score1.scale.x = 0;
				score1.scale.y = 0;
				yellowWalltween = 0;
				//console.log("yellowWalltween : " + yellowWalltween);
			}, this);
			//	}
			if ((this.cday == 2 && this.clevel == 4) || (this.cday == 3 && this.clevel == 5)) {
				console.log("tessssssss");
				if (body1.velocity.x > 100) {
					body1.velocity.x = 100;
					console.log(body1.velocity.x);
				}
				return false;
				
			}

			//body1.velocity.x =  body1.velocity.x + (dir * 5);
			//body1.velocity.y = tempVelY * 0.64;
			var bounceBak = Math.abs(bounceBackVelocity.x);
			if (bounceBak < 30) {
				bounceBak = 30;
			}
			body1.velocity.x = -3.5 * bounceBak;
			//body1.velocity.x = -5 * bounceBackVelocity.x;
			//body1.velocity.y = -1 * bounceBackVelocity.y;
			if (StickyNinjaGlobals.soundOn) {
				gameGlobal.sfxHitBouncy.play();
			}

			//body1.sprite.loadTexture('playerBase', 0);
			//body1.sprite.animations.stop(null, true);

			/*if (this.cday == 2 && this.clevel == 4) {
				console.log("inside body1.sprite : " + body1.sprite.key);
				if (body1.sprite.key == 'playerFlyRight') {
					this.humanPlayer.loadTexture('playerFlyRight', 0, false);
					this.humanPlayer.animations.play('playerFlyRight', 4, true);
					body1.velocity.x = 150;
				} else {

					this.humanPlayer.loadTexture('playerFlyLeft', 0, false);
					this.humanPlayer.animations.play('playerFlyLeft', 4, true);
					body1.velocity.x = -150;
				}
			}*/

			console.log("body1.velocity.x  : " + body1.velocity.x);
			if (body1.velocity.x > 0 && ((this.cday != 2 && this.clevel != 4) || (this.cday != 3 && this.clevel != 5))) {

				this.humanPlayer.loadTexture('playerFlyRight', 0, false);
				this.humanPlayer.animations.play('playerFlyRight', 4, true);
				body1.velocity.x = 100;
			} else if (body1.velocity.x < 0 && ((this.cday != 2 && this.clevel != 4) || (this.cday != 3 && this.clevel != 5))) {
				console.log("this.cday  : " + this.cday);
				console.log("this.clevel : " + this.clevel);

				this.humanPlayer.loadTexture('playerFlyDown', 0, false);
				this.humanPlayer.animations.play('playerFlyDown', 4, true);
				if (this.yellowTouchPos == 'left') {
					this.humanPlayer.loadTexture('playerFlyRight', 0, false);
					this.humanPlayer.animations.play('playerFlyRight', 4, true);
					body1.velocity.x = 200;
				} else {
					body1.velocity.x = -200;
					this.humanPlayer.loadTexture('playerFlyLeft', 0, false);
					this.humanPlayer.animations.play('playerFlyLeft', 4, true);
				}

			}

			//console.log("Yellow Wall",begin,"angle");
		}
	},

	objLifebuoy: function (body1, body2, fixture1, fixture2, begin) {
		//console.log("RUBBER TUBE");
		body2.applyForce(3.0, 0.0);
	},

	dragMouse: function (e) {
		//console.log("MOUSE DRAGGING");
	},

	firePlayer: function (e) {
		hitCountNo = 0;
		this.game.tweens.removeFrom(this.humanPlayer);
		this.humanPlayer.alpha = 1;
		jumpPos = this.humanPlayer.body.x;
		// Below two commented lines are for camera zooming
		//gameGlobal.camera.scale.x=gameGlobal.camera.scale.x+0.005;
		//gameGlobal.camera.scale.y=gameGlobal.camera.scale.y+0.005;
		this.humanPlayer.body.setFixtureContactCallback(this.playerLeft, this.leftCallback1, this);
		this.humanPlayer.body.setFixtureContactCallback(this.playerRight, this.leftCallback1, this);
		this.humanPlayer.body.setFixtureContactCallback(this.playerBottom, this.leftCallback1, this);
		this.humanPlayer.body.setFixtureContactCallback(this.playerTop, this.leftCallback1, this);

		var PlayerBody = this.humanPlayer.body;
		this.game.time.events.add(450, function () {
			PlayerBody.setFixtureContactCallback(this.playerLeft, this.leftCallback, this);
			this.humanPlayer.body.setFixtureContactCallback(this.playerRight, this.rightCallback, this);
			this.humanPlayer.body.setFixtureContactCallback(this.playerBottom, this.bottomCallback, this);
			this.humanPlayer.body.setFixtureContactCallback(this.playerTop, this.topCallback, this);

		}, this);


		this.humanPlayer.body.static = false;
		mouseUpStatus = true;
		//this.game.world.scale.set(1);
		this.circleselected.visible = false;
		if ((fixed == 1 || (this.humanPlayer.body.static == true) || this.carPlayerjoint || this.trapdoorobjectjoint || this.playerLogjoint || this.playerWheeljoint || this.playerTirejoint || this.playerSubwaycarjoint || this.playerDoorLogjoint || this.playerSkateboardjoint) && activatePlayerObject) {
			//console.log("MOUSE UP -- firePlayer");
			if (this.trapdoorobjectjoint) {
				this.game.physics.box2d.world.DestroyJoint(this.trapdoorobjectjoint);
				setTimeout(function () {
					//		console.log("setTimeoutsetTimeoutsetTimeoutsetTimeout");
					trapdoorobject = 0;
				}, 100);
			}
			if (this.carPlayerjoint) {
				var dj = gameGlobal.physics.box2d.world.DestroyJoint(this.carPlayerjoint);
				setTimeout(function () {
					playerStickedToCar = 0;
				}, 100);
			}
			if (this.playerLogjoint) {
				gameGlobal.physics.box2d.world.DestroyJoint(this.playerLogjoint);
				setTimeout(function () {
					playerStickedToLog = 0;
					playerStickedToLog1 = 0;
				}, 300);

			}
			if (this.playerDoorLogjoint) {
				gameGlobal.physics.box2d.world.DestroyJoint(this.playerDoorLogjoint);
				setTimeout(function () {
					playerStickedToDoorLog = 0;
				}, 100);

			}
			if (this.playerWheeljoint) {

				gameGlobal.physics.box2d.world.DestroyJoint(this.playerWheeljoint);
				setTimeout(function () {
					playerStickedToWheel = 0;
				}, 300);

			}
			if (this.playerTirejoint) {
				gameGlobal.physics.box2d.world.DestroyJoint(this.playerTirejoint);
				setTimeout(function () {
					playerStickedwheelTyre = 0;
				}, 100);

			}
			if (this.playerSkateboardjoint) {				
				gameGlobal.physics.box2d.world.DestroyJoint(this.playerSkateboardjoint);
				setTimeout(function () {
					playerStickedSkateboard = 0;
				}, 100);
			}
      if (this.playerStickedboatjoint) {
				gameGlobal.physics.box2d.world.DestroyJoint(this.playerStickedboatjoint);
				setTimeout(function () {
					playerStickedboat = 0;
				}, 100);
			}
      if (this.playerSubwaycarjoint) {
				gameGlobal.physics.box2d.world.DestroyJoint(this.playerSubwaycarjoint);
				setTimeout(function () {
					playerStickedToSubwaycar = 0;
				}, 100);
			}
			
			
			//trapdoorobject = 0;
			//console.log(this.trapdoorobjectjoint);
			//console.log("trapdoorobject: : "+trapdoorobject);
			fixed = 0;
			this.humanPlayer.body.static = false
			//originX = this.humanPlayer.body.x;
			//originY = this.humanPlayer.body.y;
			prevAngle = this.humanPlayer.angle;
			prevBodyAngle = this.humanPlayer.body.angle;

			if (!this.redcircleShown && this.cday == 1 && this.clevel == 1) {
				this.redcircleShown = true;
				this.redcircle.visible = false;
				this.clickandhold.visible = false;
				this.dragandrelease.visible = false;
			}
			if (StickyNinjaGlobals.soundOn) {
				gameGlobal.sfxLaunch.play();
				gameGlobal.sfxLaunch.volume = 0.5;
			}
			var bPlayer = this.humanPlayer.body;
			that = this;

			var vcityY = Math.abs(this.launchVelocity.y);
			var delay = 0;
			if (Math.abs(this.launchVelocity.y) < 60) {
				delay = 1;
			} else {
				if (Math.abs(this.launchVelocity.y) > 500) {
					delay = 500;
				} else {
					if (Math.abs(this.launchVelocity.y) < 300) {
						delay = 300;
					} else {
						delay = Math.abs(this.launchVelocity.y);
					}
				}
			}

			setTimeout(function () {

				bPlayer.setCategoryContactCallback(2, that.hitobject, this);
			}, delay);

			this.launchBall();
			activatePlayerObject = false;

			this.humanPlayer.loadTexture('playerFlyUp', 0, false);
			this.humanPlayer.animations.play('playerFlyUp', 4, true);
			//console.log(this.humanPlayer.key);
			jumps++;
			jumpCountText.setText(jumps);
		}
	},
	leftCallback1: function (body1, body2, fixture1, fixture2, begin) {
		//console.log("leftCallback1");

	},
	chargePlayer: function (e) {
		//console.log("MOUSE DOWN:Player:-->",this.humanPlayer.body.x,this.humanPlayer.body.y,":POINTER:->",e.x,e.y);
		//playerRotated=false;
		//this.humanPlayer.loadTexture('playerLookUp', 0, false);
		//this.humanPlayer.animations.play('playerLookUp', 4, true);		
		if(this.humanPlayer.key!=='playerLookUp'){
			return;
		}
	
		var x = this.game.input.activePointer.positionDown.x + this.game.camera.x;
		var y = this.game.input.activePointer.positionDown.y + this.game.camera.y;
		//console.log("MOUSE DOWN:Player:-->",this.humanPlayer.body.x,this.humanPlayer.body.y,":POINTER:->",x,y);
		var bodyArray = Body.GetBodyAtPointXY(this.game, x, y, false);
		if (bodyArray) {
			var bodyA = bodyArray[0];
			if (bodyA) {
				if (bodyA.sprite) {
					//console.log("MOUSE DOWN:-->", bodyA.sprite.key);
					if (bodyA.sprite.key != "playerLookUp") {
						activatePlayerObject = false;
						//console.log("in if");
						//return;
					} else {
						activatePlayerObject = true;
						//console.log("in else ");
					}
				} else {
					activatePlayerObject = false;
					//return;
				}
			} else {
				activatePlayerObject = false;
				//return;
			}
		} else {
			activatePlayerObject = false;
			//return;
		}

		if (!activatePlayerObject) {
			//console.log("ACTIVATED:", activatePlayerObject);
			/*this.humanPlayer.animations.stop(null, true);*/
			//this.humanPlayer.loadTexture('playerLookUp', 0, fase);
			//this.humanPlayer.animations.play('playerLookUp');
			this.humanPlayer.loadTexture('playerLookUp', 0, false);
			this.humanPlayer.animations.play('playerLookUp', 4, true);
			//this.game.world.scale.set(0.8);
			return;
		}

		this.humanPlayer.body.setCategoryContactCallback(2, this.hitobject1, this);
		mouseUpStatus = false;
		this.game.input.onDown.remove(this.chargePlayer);
		this.game.input.onUp.add(this.firePlayer, this);
		if ((flag == 0 && groundContacted) || (this.humanPlayer.body.static == true) || this.carPlayerjoint !== undefined || this.playerSkateboardjoint !== undefined || this.playerStickedboatjoint!== undefined) {
			if (!this.redcircle.visible) {
				this.circleselected.visible = true;
				this.circleselected.x = this.humanPlayer.body.x - 40;
				this.circleselected.y = this.humanPlayer.body.y - 40;
			}
			//this.humanPlayer.body.angle=0;
			//flag = 1;
			//var x = this.game.input.activePointer.positionDown.x + this.game.camera.x;
			// var y = this.game.input.activePointer.positionDown.y + this.game.camera.y;
			//this.chargeBall(x, y);
			this.game.input.addMoveCallback(this.chargeBall, this);

			//fixed = 1;
		}
	},

	chargeBall: function (pointer, x, y, down) {
		if (StickyNinjaGlobals.menuOn) {
			return false;
		}
		if (this.humanPlayer.key !== 'playerLookUp') {
			return false;
		}
		var x = x + this.game.camera.x;
		var y = y + this.game.camera.y;

		if (!this.redcircleShown && this.cday == 1 && this.clevel == 1) {
			this.dragandrelease.visible = true;
		}
		if (this.game.input.activePointer.isUp) {
			return;
		}
		if (activatePlayerObject) {
			//if (flag == 1) {
			/*if(!playerChargeAnim.isPlaying) {
			 this.humanPlayer.loadTexture('playerCharge', 0);
			 this.humanPlayer.animations.play('playerCharge', 15, true);
			}*/
			//this.humanPlayer.loadTexture('playerCharge', 0, false);
			//this.humanPlayer.animations.play('playerCharge', 4, true);
			this.trajectoryGraphics.clear();
			this.trajectoryGraphics.lineStyle(3, 0x00ff00);
			this.trajectoryGraphics.moveTo(this.humanPlayer.x, this.humanPlayer.y);



			this.launchVelocity.x = this.humanPlayer.body.x - x;
			this.launchVelocity.y = this.humanPlayer.body.y - y;

			//console.log("LAUNCH VELOCITY:-->", this.launchVelocity.x, this.launchVelocity.y);

			//Below two if's are to limit the charge of the player
			if (Math.abs(this.launchVelocity.x) > 100) {
				if (this.launchVelocity.x > 0) {
					this.launchVelocity.x = 100;
				}
				if (this.launchVelocity.x < 0) {
					this.launchVelocity.x = -100;
				}
			}

			if (Math.abs(this.launchVelocity.y) > 130) {
				if (this.launchVelocity.y > 0) {
					this.launchVelocity.y = 130;
				}
				if (this.launchVelocity.y < 0) {
					this.launchVelocity.y = -130;
				}
			}

			// Above two if's are to limit the charge of the player

			//console.log("LAUNCH VELOCITY:-->", this.launchVelocity.x, this.launchVelocity.y);

			if (this.launchVelocity.y < 0) {
				direction = 1;
			} else {
				direction = -1;
			}

			if (this.objArray && this.objArray.length > 0) {
				for (var j = 0; j < this.objArray.length; j += 6) {
					this.objArray[j].destroy();
				}
			}

			bounceBackVelocity = {};
			bounceBackVelocity.y = this.launchVelocity.y;
			bounceBackVelocity.x = this.launchVelocity.x;

			this.trajectoryGraphics.lineStyle(0, 0x00ff00);
			this.launchVelocity.multiply(this.forceMult, this.forceMult);
			for (var i = 0; i < 72; i += 6) {
				var trajectoryPoint = this.getTrajectoryPoint(this.humanPlayer.body.x, this.humanPlayer.body.y, this.launchVelocity.x, this.launchVelocity.y, i);
				this.trajectoryGraphics.moveTo(trajectoryPoint.x - 3, trajectoryPoint.y - 3);
				this.trajectoryGraphics.lineTo(trajectoryPoint.x + 3, trajectoryPoint.y + 3);
				this.trajectoryGraphics.moveTo(trajectoryPoint.x - 3, trajectoryPoint.y + 3);
				this.trajectoryGraphics.lineTo(trajectoryPoint.x + 3, trajectoryPoint.y - 3);

				this.objArray[i] = this.game.add.sprite(trajectoryPoint.x - 3, trajectoryPoint.y - 3, 'obj_pathline');
				this.objArray[i].spriteSno = i;
				this.game.physics.box2d.enable(this.objArray[i]);
				this.objArray[i].body.clearFixtures();
				if (i == 0) {
					this.objArray[i].body.setRectangle(this.objArray[i].width, this.objArray[i].height);
				} else {
					this.objArray[i].body.setRectangle(this.objArray[i].width, 64);
				}
				var f = this.objArray[i].body.data.GetFixtureList();
				var filter = f.GetFilterData();
				filter.groupIndex = -1;

				this.objArray[i].body.gravityScale = 0;
				this.objArray[i].body.sensor = true;
				this.objArray[i].objectArry = this.objArray;
				this.objArray[i].frame = 0;

				this.objArray[i].body.setCategoryContactCallback(2, this.starHits, this.objArray[i]);
				this.objArray[i].body.setCategoryContactCallback(7, this.starHits, this.objArray[i]);
				this.objArray[i].body.setCategoryContactCallback(8, this.starHits, this.objArray[i]);
				this.objArray[i].body.setCategoryContactCallback(11, this.starHits, this.objArray[i]);
				this.objArray[i].body.setCategoryContactCallback(13, this.starHits, this.objArray[i]);

				if (i == 12) {
					targetY = trajectoryPoint.y;
				}
				// Below is for determining player left/right kick animation
				kickX = trajectoryPoint.x;
				kickY = trajectoryPoint.x;
			}
			threshold = Math.abs(this.humanPlayer.body.x);
			if (this.humanPlayer.body.x < kickX) {
				kickDirection = 1;
			} else {
				kickDirection = -1
			}

			flag = 2;
			//}
		}
	},

	starHits: function (body1, body2, fixture1, fixture2, begin) {
		if (this.spriteSno <= 30) {
			if (this.objectArry && this.objectArry.length > 0) {
				for (var j = this.spriteSno; j < 72; j += 6) {
					if (this.objectArry[j]) {
						this.objectArry[j].frame = 1;
					}
				}
			}

		}

	},

	launchBall: function () {
		this.trajectoryGraphics.clear();

		//setting this to false to make sticking angle proper
		playerRotated = false;

		if (this.objArray.length > 0) {
			for (var j = 0; j < this.objArray.length; j += 6) {
				this.objArray[j].destroy();
			}
		}
		//console.log(this.humanPlayer.body);
		this.humanPlayer.body.angle = 0;
		this.humanPlayer.body.damping = 0;
		this.humanPlayer.body.restitution = 0;
		this.humanPlayer.body.friction = 0;
		//this.humanPlayer.body.gravityScale = 0
		this.humanPlayer.body.linearDamping = 0
		this.humanPlayer.body.velocity.x = this.launchVelocity.x;
		this.humanPlayer.body.velocity.y = this.launchVelocity.y;
	},

	// function to calculate the trajectory point taken from http://phaser.io/examples/v2/box2d/projected-trajectory
	getTrajectoryPoint: function (startX, startY, velocityX, velocityY, n) {
		var t = 1 / 60;
		var stepVelocityX = t * this.game.physics.box2d.pxm(-velocityX);
		var stepVelocityY = t * this.game.physics.box2d.pxm(-velocityY);
		var stepGravityX = t * t * this.game.physics.box2d.pxm(-this.game.physics.box2d.gravity.x);
		var stepGravityY = t * t * this.game.physics.box2d.pxm(-this.game.physics.box2d.gravity.y);
		startX = this.game.physics.box2d.pxm(-startX);
		startY = this.game.physics.box2d.pxm(-startY);
		var tpx = startX + n * stepVelocityX + 0.5 * (n * n + n) * stepGravityX;
		var tpy = startY + n * stepVelocityY + 0.5 * (n * n + n) * stepGravityY;
		tpx = this.game.physics.box2d.mpx(-tpx);
		tpy = this.game.physics.box2d.mpx(-tpy);
		return {
			x: tpx,
			y: tpy
		};
	},


	// Below function is for player blinking animation when fall in fire/water
	startPlayerKillingAnimation: function () {
		//this.humanPlayer.body.sensor=true;
		this.playerkilledOnce = 1;
		//this.humanPlayer.body.sensor = true;
		this.humanPlayer.body.velocity.x = 100;
		this.humanPlayer.body.velocity.y = 100;
		if (StickyNinjaGlobals.soundOn) {
			var playerDie = Math.floor((Math.random() * 3) + 1);
			if (playerDie == 1) {
				gameGlobal.sfxPlayerDie1.play();
			}
			else if (playerDie == 2) {
				gameGlobal.sfxPlayerDie2.play();
			} else {
				gameGlobal.sfxPlayerDie1.play();
			}
		}
		var animationTimer = 1000;
		var animationTimer1 = 500;
		this.humanPlayer.loadTexture('playerKill', 0);
		playerAnimated = 1;
		this.humanPlayer.animations.play('playerKill', 4, false);
		//console.log("startPlayerKillingAnimation: 000");
		if (this.killedBYobjspikebar == 1) {
			if (lives >= StickyNinjaGlobals.playerLifes) {
				/* if (StickyNinjaGlobals.soundOn) {
					gameGlobal.sfxPlayerDie.play();
				} */
				//window.StickyNinjaMission.state.menu.openResultScreen("levelFailedLife");
				window.setTimeout(StickyNinjaMission.state.menu.openResultScreen("levelFailedLife"), 1000);
			}
		}
		this.humanPlayer.animations.currentAnim.onComplete.add(function () {
			var timer = 100000;
			this.humanPlayer.alpha = 0;
			var tween1 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer, Phaser.Easing.Linear.None, true);

			tween1.onComplete.add(function () {
				this.humanPlayer.alpha = 0;
				var tween2 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer, Phaser.Easing.Linear.None, true);
				tween2.onComplete.add(function () {
					this.humanPlayer.alpha = 0;
					var tween3 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer, Phaser.Easing.Linear.None, true);
					tween3.onComplete.add(function () {
						this.humanPlayer.body.sensor = false;
						if (lives >= StickyNinjaGlobals.playerLifes) {
							// if (StickyNinjaGlobals.soundOn) {
							//	gameGlobal.sfxPlayerDie.play();
							//} 
							//gameGlobal.sfxPlayerDie.onStop.addOnce(function() { window.setTimeout(StickyNinjaMission.state.menu.openResultScreen("levelFailedLife"), 2000);});
							window.StickyNinjaMission.state.menu.openResultScreen("levelFailedLife");
							//window.setTimeout(StickyNinjaMission.state.menu.openResultScreen("levelFailedLife"), 2000); 
						}
						this.humanPlayer.body.x = originX;
						this.humanPlayer.body.y = originY;
						this.humanPlayer.angle = prevAngle;
						this.humanPlayer.body.angle = prevBodyAngle;
						//this.humanPlayer.loadTexture('playerBase', 0);
						//this.humanPlayer.animations.stop(null, true);
						this.humanPlayer.loadTexture('playerLookUp', 0, false);
						this.humanPlayer.animations.play('playerLookUp', 4, true);
						this.playerkilledOnce = 0;
						this.humanPlayer.alpha = 0;

						var tween4 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
						tween4.onComplete.add(function () {
							this.humanPlayer.alpha = 0;
							var tween5 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
							tween5.onComplete.add(function () {
								this.humanPlayer.alpha = 0;
								var tween6 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
								tween6.onComplete.add(function () {
									this.humanPlayer.alpha = 0;
									var tween7 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
									tween7.onComplete.add(function () {
										this.humanPlayer.alpha = 0;
										var tween8 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
										tween8.onComplete.add(function () {
											this.humanPlayer.alpha = 0;
											var tween9 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
											tween9.onComplete.add(function () {
												this.humanPlayer.alpha = 0;
												var tween10 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
												tween10.onComplete.add(function () {
													this.humanPlayer.alpha = 0;
													var tween11 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
													tween11.onComplete.add(function () {
														this.humanPlayer.alpha = 0;
														var tween12 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
														tween12.onComplete.add(function () {
															this.humanPlayer.alpha = 0;
															var tween13 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
															tween13.onComplete.add(function () {
																this.humanPlayer.alpha = 0;
																var tween14 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
																tween14.onComplete.add(function () {
																	this.humanPlayer.alpha = 0;
																	var tween15 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
																	tween15.onComplete.add(function () {

																	}, this);
																}, this);
															}, this);
														}, this);
													}, this);
												}, this);
											}, this);
										}, this);
									}, this);
								}, this);
							}, this);
						}, this);
					}, this);
				}, this);
			}, this);

			while (timer > 0) {
				timer--;

			}

			if (timer <= 0) {

			}
		}, this);
	},
	// Below function is for player blinking animation when fall in fire/water
	startPlayerKillingAnimationWaterFire: function () {
		//this.humanPlayer.body.sensor=true;
		this.playerkilledOnce = 1;
		//this.humanPlayer.body.sensor = true;
		this.humanPlayer.body.velocity.x = 100;

		this.humanPlayer.body.sensor = true;
		if (StickyNinjaGlobals.soundOn) {
			var playerDie = Math.floor((Math.random() * 3) + 1);
			if (playerDie == 1) {
				gameGlobal.sfxPlayerDie1.play();
			}
			else if (playerDie == 2) {
				gameGlobal.sfxPlayerDie2.play();
			} else {
				gameGlobal.sfxPlayerDie1.play();
			}
		}
		var animationTimer = 1000;
		var animationTimer1 = 500;


		this.humanPlayer.loadTexture('playerKillFire', 0);
		playerAnimated = 1;
		this.humanPlayer.animations.play('playerKillFire', 10, false);

		//console.log("startPlayerKillingAnimation: 000");
		if (this.killedBYobjspikebar == 1) {
			if (lives >= StickyNinjaGlobals.playerLifes) {
				 if (StickyNinjaGlobals.soundOn) {
					gameGlobal.sfxPlayerDie.play();
				} 
				//window.StickyNinjaMission.state.menu.openResultScreen("levelFailedLife");
				window.setTimeout(StickyNinjaMission.state.menu.openResultScreen("levelFailedLife"), 1000);
			}
		}
		this.humanPlayer.animations.currentAnim.onComplete.add(function () {
			//this.game.time.events.add(100, function(){
			var timer = 100000;
			this.humanPlayer.alpha = 0;
			var xvalue = 0;
			if (originX < this.humanPlayer.body.x) {
				if (lives >= StickyNinjaGlobals.playerLifes) {
					xvalue = this.humanPlayer.body.x + 550;
					if (StickyNinjaGlobals.soundOn) {
						gameGlobal.sfxPlayerDie.play();
					}
				} else {
					xvalue = this.humanPlayer.body.x + 350;
				}

			} else {
				if (lives >= StickyNinjaGlobals.playerLifes) {
					xvalue = this.humanPlayer.body.x - 550;
					if (StickyNinjaGlobals.soundOn) {
						gameGlobal.sfxPlayerDie.play();
					}
				} else {
					xvalue = this.humanPlayer.body.x - 350;
				}

			}
			var yvalue = this.humanPlayer.body.y + 20;

			var tween1 = gameGlobal.add.tween(this.humanPlayer.body).to({ y: yvalue, x: xvalue }, 2000, Phaser.Easing.Linear.None, true);

			tween1.onComplete.add(function () {
				this.humanPlayer.alpha = 0;
				this.humanPlayer.body.sensor = false;
				if (lives >= StickyNinjaGlobals.playerLifes) {
					
					window.StickyNinjaMission.state.menu.openResultScreen("levelFailedLife");
					//window.setTimeout(StickyNinjaMission.state.menu.openResultScreen("levelFailedLife"), 2000);
				}
				this.humanPlayer.body.x = originX;
				this.humanPlayer.body.y = originY;
				this.humanPlayer.angle = prevAngle;
				this.humanPlayer.body.angle = prevBodyAngle;
				this.humanPlayer.loadTexture('playerLookUp', 0, false);
				this.humanPlayer.animations.play('playerLookUp', 4, true);
				this.playerkilledOnce = 0;
				this.humanPlayer.alpha = 0;

				var tween4 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
				tween4.onComplete.add(function () {
					this.humanPlayer.alpha = 0;
					var tween5 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
					tween5.onComplete.add(function () {
						this.humanPlayer.alpha = 0;
						var tween6 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
						tween6.onComplete.add(function () {
							this.humanPlayer.alpha = 0;
							var tween7 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
							tween7.onComplete.add(function () {
								this.humanPlayer.alpha = 0;
								var tween8 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
								tween8.onComplete.add(function () {
									this.humanPlayer.alpha = 0;
									var tween9 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
									tween9.onComplete.add(function () {
										this.humanPlayer.alpha = 0;
										var tween10 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
										tween10.onComplete.add(function () {
											this.humanPlayer.alpha = 0;
											var tween11 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
											tween11.onComplete.add(function () {
												this.humanPlayer.alpha = 0;
												var tween12 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
												tween12.onComplete.add(function () {
													this.humanPlayer.alpha = 0;
													var tween13 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
													tween13.onComplete.add(function () {
														this.humanPlayer.alpha = 0;
														var tween14 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
														tween14.onComplete.add(function () {
															this.humanPlayer.alpha = 0;
															var tween15 = gameGlobal.add.tween(this.humanPlayer).to({ alpha: 1 }, animationTimer1, Phaser.Easing.Linear.None, true);
															tween15.onComplete.add(function () {

															}, this);
														}, this);
													}, this);
												}, this);
											}, this);
										}, this);
									}, this);
								}, this);
							}, this);
						}, this);
					}, this);
				}, this);
			}, this);
		}, this);

		while (timer > 0) {
			timer--;

		}

		if (timer <= 0) {

		}
	},
	showCloudImage: function (key) {
		if ((this.cday == 1 && this.clevel == 3) || (this.cday == 2 && this.clevel == 3) || (this.cday == 4 && this.clevel == 5)) {
			var x1 = this.humanPlayer.body.x + 162;
			var y1 = this.humanPlayer.body.y - 160;
		}else if ((this.cday == 2 && this.clevel == 2) || (this.cday == 3 && this.clevel == 1) || (this.cday == 5 && this.clevel == 4)) {
			var x1 = this.humanPlayer.body.x + 182;
			var y1 = this.humanPlayer.body.y - 150;
		}else if ((this.cday == 1 && this.clevel == 2) || (this.cday == 3 && this.clevel == 3)){
			var x1 = this.humanPlayer.body.x + 10;
			var y1 = this.humanPlayer.body.y - 90;
		}else{
			var x1 = this.humanPlayer.body.x + 162;
			var y1 = this.humanPlayer.body.y - 230;
		}
		var guide1 = this.game.add.sprite(x1, y1, key);
		if (StickyNinjaGlobals.soundOn) {
			gameGlobal.sfxSwitch.play();
		}
		guide1.scale.x = 1;
		guide1.scale.y = 1;

		var bounce = this.game.add.tween(guide1);
		bounce.to({ x: x1 - 10, y: y1 - 10 }, 3000, Phaser.Easing.Bounce.In);
		bounce.onComplete.add(function () {
			var bounce1 = this.game.add.tween(guide1);
			bounce1.to({ x: x1 + 10, y: y1 + 10 }, 3000, Phaser.Easing.Bounce.In);
			bounce1.onComplete.add(function () {
				guide1.scale.x = 0;
				guide1.scale.y = 0;
			}, this);
			bounce1.start();
		}, this);
		bounce.start();
		this.game.world.bringToTop(StickyNinjaGlobals.gameMenu);
		this.game.world.bringToTop(StickyNinjaGlobals.gameMenuPopupGroup);
	},


	update: function () {
		if (!playerRotated) {
			this.humanPlayer.angle = 0;
			this.humanPlayer.body.angle = 0;
		}
		if (this.sp2) {
			this.sp2.angle += 2;
		}
		if (this.carPlayerjoint !== undefined) {
			//console.log("inside");
			if (this.humanPlayer.key == 'playerFlyLeft' || this.humanPlayer.key == 'playerFlyRight' || this.humanPlayer.key == 'playerFlyUp') {
				gameGlobal.physics.box2d.world.DestroyJoint(this.carPlayerjoint);
			}
		}
		//when car and player contacted
		if (playerStickedToCar === 1) {
			StickyNinjaGlobals.car.static = false;
			StickyNinjaGlobals.car.mass = 10;
			fixed = 0;
			this.humanPlayer.body.static = false;
			//this.humanPlayer.loadTexture('playerBase', 0);
			this.humanPlayer.loadTexture('playerLookUp', 0, false);
			this.humanPlayer.animations.play('playerLookUp', 4, true);
			playerStickedToCar = 2;
			this.carLeftWheel.EnableMotor(false);
			this.carRightWheel.EnableMotor(false);
			var ax = -15;
			var ay = -73;
			var bx = 0;
			var by = 0;
			this.carPlayerjoint = gameGlobal.physics.box2d.revoluteJoint(StickyNinjaGlobals.car, this.humanPlayer, ax, ay, bx, by);
		}

		if (this.carPlayerjoint && playerStickedToCar == 2) {
			this.humanPlayer.angle = 0;
			this.humanPlayer.body.angle = StickyNinjaGlobals.car.angle;
		}

		//when car and player contacted
		if (playerStickedSkateboard === 1) {
			console.log("playerStickedSkateboard");

			this.humanPlayer.body.static = false;
			this.humanPlayer.loadTexture('playerLookUp', 0, false);
			this.humanPlayer.animations.play('playerLookUp', 4, true);
			playerStickedSkateboard = 2;
			console.log(this.skateboardObject);
			//this.playerSkateboardjoint = gameGlobal.physics.box2d.revoluteJoint(this.skateboardObject, this.humanPlayer, 0, -5, 2, 32);

			this.playerSkateboardjoint = stn.createWeldJoint(this.skateboardObject,this.humanPlayer);
		}
		
		if (this.playerSkateboardjoint !== undefined && playerStickedSkateboard !== 0 && this.skateboardObject.sprite) {
			this.humanPlayer.angle = this.skateboardObject.sprite.angle;
			this.humanPlayer.body.angle = this.skateboardObject.angle;
		 if(this.humanPlayer.key!=='playerLookUp'){
				this.humanPlayer.loadTexture('playerLookUp', 0, false);
				this.humanPlayer.animations.play('playerLookUp', 4, true);
			}
		}
	 
		
			//when boat and player contacted
			if (playerStickedboat === 1) {
				console.log("playerStickedboat");
	
				this.humanPlayer.body.static = false;
				this.humanPlayer.loadTexture('playerLookUp', 0, false);
				this.humanPlayer.animations.play('playerLookUp', 4, true);
				playerStickedboat = 2;
				console.log(this.skateboardObject);
				this.playerStickedboatjoint = gameGlobal.physics.box2d.revoluteJoint(this.boatObject, this.humanPlayer, 0,-10, 2, 35);
	
			}
			if (this.playerStickedboatjoint !== undefined && playerStickedboat !== 0 && this.boatObject.sprite) {
				this.humanPlayer.angle = this.boatObject.sprite.angle;
				this.humanPlayer.body.angle = this.boatObject.angle;
			}


		//For trap door to fall when player contacted
		if (trapdoorobject == 1) {
			StickyNinjaGlobals.trapdoor[trapDoorIndex].static = false;
			StickyNinjaGlobals.trapdoor[trapDoorIndex].mass = 10;
			if (trapDoorIndex == 0)
				StickyNinjaGlobals.trapdoor[trapDoorIndex].applyForce(-10, 0);
			else if (trapDoorIndex == 1) {
				//console.log("LAST ONE");
				this.humanPlayer.body.velocity.x = 200;
				this.humanPlayer.body.velocity.y = 200;
				StickyNinjaGlobals.trapdoor[trapDoorIndex].applyForce(150, 0);
			}
			//StickyNinjaGlobals.trapdoor.velocity.x = -100;
			fixed = 0;
			this.humanPlayer.body.static = false;
			this.humanPlayer.loadTexture('playerLookUp', 0, false);
			this.humanPlayer.animations.play('playerLookUp', 4, true);
			//this.humanPlayer.body.mass=0.1;
			trapdoorobject = 2;
			var ax = -10;
			var ay = 41;
			if (this.doorTouch == 'first') {
				ax = -50;
				ay = 41;
			}
			else if (this.doorTouch == 'second') {
				ax = -20;
				ay = 41;
			}
			else if (this.doorTouch == 'top') {
				ax = -20;
				ay = -55;
			}
			if (trapDoorIndex == 1) {
				ax = 0;
				ay = 41;
			}
			this.trapdoorobjectjoint = gameGlobal.physics.box2d.revoluteJoint(StickyNinjaGlobals.trapdoor[trapDoorIndex], this.humanPlayer, ax, ay);
		}

		if (this.trapdoorobjectjoint && trapdoorobject !== 0) {
			console.log('this.humanPlayer.key : ' + this.humanPlayer.key);
			this.humanPlayer.body.static = false;
   		if(this.humanPlayer.key!=='playerLookUp'){
				gameGlobal.physics.box2d.world.DestroyJoint(this.trapdoorobjectjoint);
				setTimeout(function () {					
					trapdoorobject = 0;
				}, 100);
			 }
			

			//this.humanPlayer.loadTexture('playerLookUp', 0, false);
			//this.humanPlayer.animations.play('playerLookUp', 4, true);	
			if (this.doorTouch !== 'top')
				this.humanPlayer.body.angle = StickyNinjaGlobals.trapdoor[trapDoorIndex].angle + 180;
			else
				this.humanPlayer.body.angle = StickyNinjaGlobals.trapdoor[trapDoorIndex].angle;
		}
		//when Log and player contacted
		if (playerStickedToLog === 1 && playerStickedToLog1 !== 2) {
			if (StickyNinjaGlobals.Logd2l2.body.static === true)
				fixed = 0;
			this.humanPlayer.body.static = false;
			this.humanPlayer.loadTexture('playerLookUp', 0, false);
			this.humanPlayer.animations.play('playerLookUp', 4, true);

			StickyNinjaGlobals.Logd2l2.body.mass = 10;
			this.playerLogjoint = gameGlobal.physics.box2d.revoluteJoint(StickyNinjaGlobals.Logd2l2, this.humanPlayer, -35, -45);
			playerStickedToLog = 2;

		}

		if (playerStickedToLog1 == 1) {
			if (StickyNinjaGlobals.Logd2l2.body.static === true)
				fixed = 0;
			this.humanPlayer.body.static = false;
			this.humanPlayer.loadTexture('playerLookUp', 0, false);
			this.humanPlayer.animations.play('playerLookUp', 4, true);

			StickyNinjaGlobals.Logd2l2.body.mass = 10;
			//this.humanPlayer.body.velocity.x = 100;
			//StickyNinjaGlobals.Logd2l2.body.velocity.x = 50;				
			this.playerLogjoint = gameGlobal.physics.box2d.revoluteJoint(StickyNinjaGlobals.Logd2l2, this.humanPlayer, -65, 0, 0, 20);
			playerStickedToLog1 = 2;

		}

		if(playerStickedToSubwaycar==1){
			console.log("playerStickedToSubwaycar");
			playerStickedToSubwaycar = 2;
			
			//this.humanPlayer.body.x = playerStickedToSubwaycarObject.x;
			// var pointA = new  box2d.b2Vec2();
			// var pointB = new  box2d.b2Vec2();
			
			// playerStickedToSubwaycarObject.toLocalPoint(pointA,new box2d.b2Vec2(this.humanPlayer.x,this.humanPlayer.y));
			// this.humanPlayer.body.toLocalPoint(pointB, new box2d.b2Vec2(this.humanPlayer.x,this.humanPlayer.y));

			// this.playerSubwaycarjoint = gameGlobal.physics.box2d.weldJoint(playerStickedToSubwaycarObject.sprite,this.humanPlayer,pointA.x, pointA.y,pointB.x,pointB.y); 
			

			this.playerSubwaycarjoint= stn.createWeldJoint(playerStickedToSubwaycarObject,this.humanPlayer);


		}

		// When wheel and player conacted
		/*if (playerStickedToWheel === 1) {
			this.humanPlayer.body.static = false;
			
			this.playerDoorLogjoint = gameGlobal.physics.box2d.revoluteJoint(StickyNinjaGlobals.waterWheel , this.humanPlayer,-60,-70);
			playerStickedToWheel = 2;
		}*/


		if (playerStickedToDoorLog === 1) {
			//console.log("playerStickedToDoorLogplayerStickedToDoorLogplayerStickedToDoorLog");

			this.humanPlayer.body.static = false;
			this.humanPlayer.loadTexture('playerLookUp', 0, false);
			this.humanPlayer.animations.play('playerLookUp', 4, true);
			playerStickedToDoorLog = 2;
			this.humanPlayer.body.angle = 0;
			
			this.humanPlayer.body.angle = StickyNinjaGlobals.doorLog.angle;
			this.humanPlayer.angle = StickyNinjaGlobals.doorLog.sprite.angle;
			// this.humanPlayer.angle = -90;
			//StickyNinjaGlobals.Logd2l2.body.mass=50; 


			this.playerDoorLogjoint = stn.createRevoluteJoint(StickyNinjaGlobals.doorLog,this.humanPlayer);
		}
		
		if (this.playerDoorLogjoint !== undefined && playerStickedToDoorLog !== 0) {	
		
			if (this.attachToTrapDoor=== 'top'){
				this.humanPlayer.body.angle = StickyNinjaGlobals.doorLog.angle + 180;	
			}else if(this.attachToTrapDoor=== 'bottom'){
				this.humanPlayer.body.angle = StickyNinjaGlobals.doorLog.angle + 180;	
			}			
		else
			this.humanPlayer.body.angle = StickyNinjaGlobals.doorLog.angle;

		}

		if (playerStickedToWheel === 1) {
			console.log("playerStickedToWheelplayerStickedToWheelplayerStickedToWheelplayerStickedToWheel");
			//this.humanPlayer.body.static = false;
			this.humanPlayer.loadTexture('playerLookUp', 0, false);
			this.humanPlayer.animations.play('playerLookUp', 4, true);
			playerStickedToWheel = 2;
			this.playerWheeljoint = gameGlobal.physics.box2d.revoluteJoint(StickyNinjaGlobals.waterWheel, this.humanPlayer, -60, -70);
		}

		if (playerStickedwheelTyre === 1) {
			//console.log("playerS/tickedToDoorLogplayerStickedToDoorLogplayerStickedToDoorLog");

			this.humanPlayer.body.static = false;
			this.humanPlayer.loadTexture('playerLookUp', 0, false);
			this.humanPlayer.animations.play('playerLookUp', 4, true);
			playerStickedwheelTyre = 2;
			this.playerTirejoint = gameGlobal.physics.box2d.revoluteJoint(this.wheelTyreObject, this.humanPlayer, 5, 42, 0, 10);
		}

		if (this.playerTirejoint !== undefined && playerStickedwheelTyre !== 0) {
			this.humanPlayer.angle = this.wheelTyreObject.sprite.angle + 90;
			this.humanPlayer.body.angle = this.wheelTyreObject.angle + 180;
		}

		if (this.playerLogjoint !== undefined && playerStickedToLog1 !== 0) {
			console.log("playerStickedToLog111111: " + playerStickedToLog);
			this.humanPlayer.body.angle = 0;
			this.humanPlayer.body.static = false;
			if(this.humanPlayer.key!=='playerLookUp'){
				this.humanPlayer.loadTexture('playerLookUp', 0, false);
				this.humanPlayer.animations.play('playerLookUp', 4, true);
			}
			this.humanPlayer.body.angle = StickyNinjaGlobals.Logd2l2.body.angle + 270;
			
		}

		if (this.playerLogjoint !== undefined && playerStickedToLog !== 0) {
			//console.log("playerStickedToLog: "+playerStickedToLog);
			this.humanPlayer.body.angle = 0;
			this.humanPlayer.body.static = false;
			if(this.humanPlayer.key!=='playerLookUp'){
				this.humanPlayer.loadTexture('playerLookUp', 0, false);
				this.humanPlayer.animations.play('playerLookUp', 4, true);
			}
			this.humanPlayer.body.angle = StickyNinjaGlobals.Logd2l2.body.angle;
		}
		if (playerhitshurikenPlayer === 1) {
			//console.log('this.humanPlayer.key: ' + this.humanPlayer.key);
			if (this.humanPlayer.key === 'playerLookUp') {
				playerhitshurikenPlayer = 2;
				if (StickyNinjaGlobals.shurikenEnemies.length > 0) {
					for (var i in StickyNinjaGlobals.shurikenEnemies) {
						tetsubishi[i] = this.game.add.sprite(this.humanPlayer.body.x - 5, this.humanPlayer.body.y - 10, "tetsubishi");
						tetsubishi[i].visible = false;
						tetsubishi[i].anchor.setTo(0.5, 0.5);

					}
				}
			}

			var tetsubishiObj = tetsubishi;

			if (tetsubishiObj[0]) {
				tetsubishiObj[0].visible = true;
				gameGlobal.time.events.loop(0, function () {
					tetsubishiObj[0].angle += 10;
				}, this);
				var st = gameGlobal.add.tween(tetsubishiObj[0]).to({ x: StickyNinjaGlobals.shurikenEnemies[0].body.x, y: StickyNinjaGlobals.shurikenEnemies[0].body.y }, 400, Phaser.Easing.InOut, true);
				st.onComplete.add(function () {
					gameGlobal.physics.box2d.enable(tetsubishiObj[0]);

					thisObj.game.destroyEnemyObjecttime = 0;
					tetsubishiObj[0].body.setCategoryContactCallback(4, thisObj.destroyEnemyObject, thisObj);
					tetsubishiObj[0].body.setCategoryContactCallback(22, thisObj.destroyEnemyObject, thisObj);
					tetsubishiObj[0].destroy();
					tetsubishiObj[1].visible = true;
					gameGlobal.time.events.loop(0, function () {
						tetsubishiObj[1].angle += 10;
					}, this);

					var st1 = gameGlobal.add.tween(tetsubishiObj[1]).to({ x: StickyNinjaGlobals.shurikenEnemies[1].body.x, y: StickyNinjaGlobals.shurikenEnemies[1].body.y }, 400, Phaser.Easing.InOut, true);
					st1.onComplete.add(function () {
						gameGlobal.physics.box2d.enable(tetsubishiObj[1]);
						thisObj.game.destroyEnemyObjecttime = 0;
						tetsubishiObj[1].body.setCategoryContactCallback(4, thisObj.destroyEnemyObject, thisObj);
						tetsubishiObj[1].body.setCategoryContactCallback(22, thisObj.destroyEnemyObject, thisObj);
						tetsubishiObj[1].destroy();
						tetsubishiObj[2].visible = true;
						gameGlobal.time.events.loop(0, function () {
							tetsubishiObj[2].angle += 10;
						}, this);

						var st2 = gameGlobal.add.tween(tetsubishiObj[2]).to({ x: StickyNinjaGlobals.shurikenEnemies[2].body.x, y: StickyNinjaGlobals.shurikenEnemies[2].body.y }, 400, Phaser.Easing.InOut, true);
						st2.onComplete.add(function () {
							gameGlobal.physics.box2d.enable(tetsubishiObj[2]);
							thisObj.game.destroyEnemyObjecttime = 0;
							tetsubishiObj[2].body.setCategoryContactCallback(4, thisObj.destroyEnemyObject, thisObj);
							tetsubishiObj[2].body.setCategoryContactCallback(22, thisObj.destroyEnemyObject, thisObj);
							tetsubishiObj[2].destroy();
							tetsubishiObj[3].visible = true;

							gameGlobal.time.events.loop(0, function () {
								tetsubishiObj[3].angle += 10;
							}, this);

							var st3 = gameGlobal.add.tween(tetsubishiObj[3]).to({ x: StickyNinjaGlobals.shurikenEnemies[3].body.x, y: StickyNinjaGlobals.shurikenEnemies[3].body.y }, 400, Phaser.Easing.InOut, true);
							st3.onComplete.add(function () {
								gameGlobal.physics.box2d.enable(tetsubishiObj[3]);
								thisObj.game.destroyEnemyObjecttime = 0;
								tetsubishiObj[3].body.setCategoryContactCallback(4, thisObj.destroyEnemyObject, thisObj);
								tetsubishiObj[3].body.setCategoryContactCallback(22, thisObj.destroyEnemyObject, thisObj);
								tetsubishiObj[3].destroy();
								tetsubishiObj[4].visible = true;
								gameGlobal.time.events.loop(0, function () {
									tetsubishiObj[4].angle += 10;
								}, this);

								var st4 = gameGlobal.add.tween(tetsubishiObj[4]).to({ x: StickyNinjaGlobals.shurikenEnemies[4].body.x, y: StickyNinjaGlobals.shurikenEnemies[4].body.y }, 400, Phaser.Easing.InOut, true);
								st4.onComplete.add(function () {
									gameGlobal.physics.box2d.enable(tetsubishiObj[4]);
									thisObj.game.destroyEnemyObjecttime = 0;
									tetsubishiObj[4].body.setCategoryContactCallback(4, thisObj.destroyEnemyObject, thisObj);
									tetsubishiObj[4].body.setCategoryContactCallback(22, thisObj.destroyEnemyObject, thisObj);
									tetsubishiObj[4].destroy();
									tetsubishiObj[5].visible = true;
									gameGlobal.time.events.loop(0, function () {
										tetsubishiObj[5].angle += 10;
									}, this);

									var st5 = gameGlobal.add.tween(tetsubishiObj[5]).to({ x: StickyNinjaGlobals.shurikenEnemies[5].body.x, y: StickyNinjaGlobals.shurikenEnemies[5].body.y }, 400, Phaser.Easing.InOut, true);
									st5.onComplete.add(function () {
										gameGlobal.physics.box2d.enable(tetsubishiObj[5]);
										thisObj.game.destroyEnemyObjecttime = 0;
										tetsubishiObj[5].body.setCategoryContactCallback(4, thisObj.destroyEnemyObject, thisObj);
										tetsubishiObj[5].destroy();

										shurikenPlayerObj.sprite.visible = true;
										StickyNinjaGlobals.shurikenEnemies = [];

									});

								});

							});


						});


					});


				});

			}
			//}

		}

		if (this.fixedBallTweening) {
			var x = this.fixedBall.x;
			var y = this.fixedBall.y;

			var bodyArray = Body.GetBodyAtPointXY(gameGlobal, x, y, false);
			if (bodyArray) {
				var bodyA = bodyArray[0];
				if (bodyA) {
					if (bodyA.sprite) {
						if (bodyA.sprite.key == "playerLookUp" || bodyA.sprite.key == "playerFlyRight" || bodyA.sprite.key == "playerFlyLeft") {
							tweenFixedBall.stop();
							this.fixedBall.visible = false;
							this.fixedBallTweening = false;
						} else {
							tweenFixedBall = gameGlobal.add.tween(this.fixedBall).to({ x: this.humanPlayer.body.x, y: this.humanPlayer.body.y }, 100, Phaser.Easing.InOut, true);
						}
					} else {
						tweenFixedBall = gameGlobal.add.tween(this.fixedBall).to({ x: this.humanPlayer.body.x, y: this.humanPlayer.body.y }, 100, Phaser.Easing.InOut, true);
					}
				} else {
					tweenFixedBall = gameGlobal.add.tween(this.fixedBall).to({ x: this.humanPlayer.body.x, y: this.humanPlayer.body.y }, 100, Phaser.Easing.InOut, true);
				}
			} else {
				tweenFixedBall = gameGlobal.add.tween(this.fixedBall).to({ x: this.humanPlayer.body.x, y: this.humanPlayer.body.y }, 100, Phaser.Easing.InOut, true);
			}
		}


		if (this.cday == 1 && this.clevel == 5) {
			if (this.humanPlayer.body.x >= 2310 && this.humanPlayer.body.y < 726) {
				StickyNinjaGlobals.objBallSpiky.body.static = false;
			}
		}
		this.game.camera.focusOnXY(this.humanPlayer.body.x, this.humanPlayer.body.y);
		//console.log(this.game.camera.width, this.game.camera.height);
		//console.log(StickyNinjaGlobals.fireball.y);
		/*if(StickyNinjaGlobals.fireball) {
			//StickyNinjaGlobals.fireball.applyForce(0, -100);
			if(StickyNinjaGlobals.fireball.y < StickyNinjaGlobals.fireball.originalY){
				StickyNinjaGlobals.fireball.applyForce(0.0,-200);
			}
		}*/

		if (pushPlayerOnce) {
			pushPlayerOnce = false;
			if (playerkilledinwaterFire == 1) {
				this.startPlayerKillingAnimationWaterFire(this);
			}
			else {
				this.startPlayerKillingAnimation(this);
			}
		}
		if (playerAnimated == 1) {
			if (this.humanPlayer.key === 'playerLookUp') {
				this.playerkilledOnce = 0;
				if (lives >= StickyNinjaGlobals.playerLifes) {
					/* if (StickyNinjaGlobals.soundOn) {
						gameGlobal.sfxPlayerDie.play();
					} 
					//window.StickyNinjaMission.state.menu.openResultScreen("levelFailedLife"); */
					window.setTimeout(StickyNinjaMission.state.menu.openResultScreen("levelFailedLife"), 2000);
				}
			}
		}

		if (Math.abs(this.humanPlayer.body.x - threshold) > 20 && threshold > 0) {
			threshold = 0;
			if (kickDirection == 1) {
				this.humanPlayer.loadTexture('playerFlyRight', 0, false);
				this.humanPlayer.animations.play('playerFlyRight', 4, true);


				//this.humanPlayer.animations.stop();
				//this.humanPlayer.loadTexture('playerCharge', 0);
				//this.humanPlayer.animations.play('playerCharge');
			} else if (kickDirection == -1) {
				this.humanPlayer.loadTexture('playerFlyLeft', 0, false);
				this.humanPlayer.animations.play('playerFlyLeft', 4, true);
			}
		}
		if (!this.redcircleShown && this.cday == 1 && this.clevel == 1) {
			this.redcircle.x = this.humanPlayer.body.x - 100;
			this.redcircle.y = this.humanPlayer.body.y - 105;
			this.clickandhold.x = this.humanPlayer.body.x;
			this.clickandhold.y = this.humanPlayer.body.y - 95;
			this.dragandrelease.x = this.humanPlayer.body.x - 80;
			this.dragandrelease.y = this.humanPlayer.body.y + 150;
		}

		if (!this.redcircle.visible) {
			this.circleselected.x = this.humanPlayer.body.x - 40;
			this.circleselected.y = this.humanPlayer.body.y - 40;
		}

		if (activateTimer) {
			//if (seconds && timer) {
			count1 = levelTimer;
			timer1 = 0;
			StickyNinjaGlobals.triggerExitDoor = 1;
		
			timerText.setText(timer1 + " / "+levelTimer);		
			this.myTimer = this.game.time.events.loop(1000,function () {
				count1--;
				timer1++;		
				timerText.setText(timer1 + " / "+levelTimer);			
				if (count1 == 0) {
					clearInterval(this.myTimer);
					if (StickyNinjaGlobals.triggerExitDoor != 3) {
						timer1 = 0;
						StickyNinjaGlobals.triggerExitDoor = 0;
						StickyNinjaGlobals.levelCompleted = 0;
						this.ranOutOfTime = true;
						levelFailedTimer = true;
						//window.StickyNinjaMission.state.menu.openResultScreen("levelFailedTimer");
						window.setTimeout(StickyNinjaMission.state.menu.openResultScreen("levelFailedTimer"), 1000);
					}
				}
			});
			activateTimer = false;

			/*if (timer > 0) {
						seconds = seconds - 1;
						if (seconds == 0) {
									seconds = 60;
									timer = timer - 1;
									timer1 = timer1 + 1;
									//console.log("TIMER:-->",timer);
						}
						if (typeof timerText !== 'undefined') {
							 timerText.setText(timer1 + " /35");
						}
						if (!mutipleConditionsToCompleteLevel && StickyNinjaGlobals.triggerExitDoor != 3)
									StickyNinjaGlobals.triggerExitDoor = 1;
						//StickyNinjaGlobals.levelCompleted = 1;
			} else if (!this.ranOutOfTime && StickyNinjaGlobals.triggerExitDoor != 3) {
						timer1 = 0;
						StickyNinjaGlobals.triggerExitDoor = 0;
						StickyNinjaGlobals.levelCompleted = 0;
						this.ranOutOfTime = true;
						levelFailedTimer = true;
						window.StickyNinjaMission.state.menu.openResultScreen("levelFailedTimer");
			}*/
			//}
		}
		if(this.humanPlayer.key==='playerExitAnim'){			
		  if(this.myTimer)
			this.game.time.events.remove(this.myTimer);
		}


		if (activateStopKillingEnemies) {
			if (enemiesKilled > 0 && !levelFailedEnemyKilled) {
				StickyNinjaGlobals.levelCompleted = 0;
				StickyNinjaGlobals.triggerExitDoor = 0;
				levelFailedEnemyKilled = true;
				window.StickyNinjaMission.state.menu.openResultScreen("levelFailedEnemyKilled");
			}
		}

		if (mutipleConditionsToCompleteLevel && activateTimer) {
			if (counterToCompleteLevel == numOfConditionsToCompleteLevel - 1 && timer > 0) {
				if (StickyNinjaGlobals.levelCompleted != 2) {
					StickyNinjaGlobals.levelCompleted = 1;
				}
				//console.log("LEVEL COMPLETED");
			}
		}

		if (scoreCounting) {
			//console.log("score:",score,":TargetScore:", targetScore);
		}

		if (scoreCounting && score >= targetScore) {
			if (StickyNinjaGlobals.levelCompleted != 2) {
				StickyNinjaGlobals.levelCompleted = 1;
			}
		}

		if (mutipleConditionsToCompleteLevel && counterToCompleteLevel == numOfConditionsToCompleteLevel) {
			if (StickyNinjaGlobals.levelCompleted != 2) {
				StickyNinjaGlobals.levelCompleted = 1;
			}
			//console.log("LEVEL COMPLETED");
			//StickyNinjaGlobals.triggerExitDoor=1;
		}

		// For positions of cloud messages 
		if (StickyNinjaGlobals.cloudImages["" + this.cday + "," + this.clevel]) {
			var obj = StickyNinjaGlobals.cloudImages["" + this.cday + "," + this.clevel];

			for (var cloudIndex = 0; cloudIndex < obj.length; cloudIndex++) {
				var obj1 = obj[cloudIndex];
				var x, y;
				if (obj1.hasOwnProperty('x') && obj1.hasOwnProperty('y')) {
					x = obj1.x;
					y = obj1.y;
					if (obj1.shown == false) {
						if (obj1.hasOwnProperty('yinverse')) {
							if (this.humanPlayer.body.x > x && this.humanPlayer.body.y < y) {
								StickyNinjaGlobals.cloudImages["" + this.cday + "," + this.clevel][cloudIndex].shown = true;
								this.showCloudImage(obj1.key);
							}
						} else if (this.humanPlayer.body.x > x && this.humanPlayer.body.y > y) {
							StickyNinjaGlobals.cloudImages["" + this.cday + "," + this.clevel][cloudIndex].shown = true;
							this.showCloudImage(obj1.key);
						}
					}
				} else if (obj1.hasOwnProperty('x')) {
					x = obj1.x;
					if (obj1.shown == false) {
						if (this.humanPlayer.body.x > x) {
							StickyNinjaGlobals.cloudImages["" + this.cday + "," + this.clevel][cloudIndex].shown = true;
							this.showCloudImage(obj1.key);
						}
					}
				} else if (obj1.hasOwnProperty('y')) {
					y = obj1.y;
					if (obj1.shown == false) {
						if (this.humanPlayer.body.y > y) {
							StickyNinjaGlobals.cloudImages["" + this.cday + "," + this.clevel][cloudIndex].shown = true;
							this.showCloudImage(obj1.key);
						}
					}
				}


			}
		}
		// Above for positioning of cloud messages 

		if (direction == 1 && this.humanPlayer.body.y <= targetY) {
			groundContacted = false;
		}
		if (direction == -1 && this.humanPlayer.body.y >= targetY) {
			groundContacted = false;
		}
		if (fixed == 1) {
			this.humanPlayer.body.static = true;
			if (!playerRotated) {
				playerRotated = true;
				if (this.rightX == "right") {
					//console.log("TURN RIGHT");
					this.humanPlayer.body.angle = 0;
					this.humanPlayer.body.angle = -90;
					this.humanPlayer.angle = 0;
					this.humanPlayer.angle = -90;
				} else if (this.rightX == "left") {
					//console.log("TURN left");
					this.humanPlayer.body.angle = 0;
					this.humanPlayer.body.angle = 90;
					this.humanPlayer.angle = 0;
					this.humanPlayer.angle = 90;
				} else if (this.rightX == "top") {
					//console.log("TURN top");
					this.humanPlayer.body.angle = 0;
					this.humanPlayer.body.angle = 180;
					this.humanPlayer.angle = 0;
					this.humanPlayer.angle = 180;
				} else if (this.rightX == "bottom") {
					//console.log("TURN bottom");
					this.humanPlayer.body.angle = 0;
					this.humanPlayer.angle = 0;
				}
			}
		} else {
			this.humanPlayer.body.static = false;
		}

		if (this.cday == 2 && this.clevel == 5 && this.showExitArrowFlag == 0) {
			this.showExitArrowFlag = 1;
			this.showExitArrow(this);
			exitDoorrotate = StickyNinjaGlobals.exitdoorAnim;

		}
		if (this.cday == 3 && this.clevel == 1 && this.showExitArrowFlag == 0) {
			this.showExitArrowFlag = 1;
			this.showExitArrow(this);
			exitDoorrotate = StickyNinjaGlobals.exitdoorAnim;
			if (StickyNinjaGlobals.exitdoor)
				StickyNinjaGlobals.exitdoor.visible = false;

			StickyNinjaGlobals.exitdoorOpen.visible = true;
		}
		if (exitDoorrotate !== "") {
			//console.log("ed");
			exitDoorrotate.angle += 2;
		}
		if (StickyNinjaGlobals.levelCompleted == 1) {

			if (StickyNinjaGlobals.exitdoor)
				StickyNinjaGlobals.exitdoor.visible = false;

			StickyNinjaGlobals.exitdoorOpen.visible = true;

			var sp1 = StickyNinjaGlobals.exitdoorOpen;
			this.sp2 = StickyNinjaGlobals.exitdoorAnim;
			var sp3 = StickyNinjaGlobals.exitdoorBack;
			//console.log(this);
			this.game.physics.box2d.enable(sp1);
			//this.game.physics.box2d.enable(sp2);
			this.game.physics.box2d.enable(sp3);


			sp1.body.sensor = true;
			//sp2.body.sensor = true;
			sp3.body.sensor = true;

			sp1.body.static = true;
			//sp2.body.static = true;
			sp3.body.static = true;
			this.sp2.angle += 2;
			sp1.body.setCollisionCategory(5);
			//sp2.body.setCollisionCategory(5);
			sp3.body.setCollisionCategory(5);
			//console.log(sp1);
			StickyNinjaGlobals.levelCompleted = 2;
			StickyNinjaGlobals.triggerExitDoor = 1;

			this.showExitArrow(this);


			StickyNinjaGlobals.tickmark.visible = true;

			if (StickyNinjaGlobals.soundOn) {
				this.game.sfxExitOpen.play();
			}

			if (StickyNinjaGlobals.exitdoor.sprite && this.cday < 2) {
				//	StickyNinjaGlobals.exitdoor.sprite.destroy();
				StickyNinjaGlobals.exitdoor.destroy();
			}
			//console.log("LEVEL COMPLETED:StickyNinjaGlobals.triggerExitDoor:", StickyNinjaGlobals.triggerExitDoor);
		}
		if (StickyNinjaGlobals.triggerExitDoor == 1) {
			if (this.objExitArrowIcon) {
				this.objExitArrowIcon.x = this.humanPlayer.body.x - 20;
				this.objExitArrowIcon.y = this.humanPlayer.body.y - 120;

				this.objExitArrow.x = this.objExitArrowIcon.x + (this.objExitArrowIcon.width * 2) - 55;
				this.objExitArrow.y = this.objExitArrowIcon.y +35;

				//this.game.physics.box2d.enable(this.objExitArrow);
				//this.objExitArrow.body.static=true;
				this.objExitArrow.anchor.setTo(0.5, 0.5);
				this.objExitArrow.pivot.x = this.objExitArrow.width * .5;
				this.objExitArrow.pivot.y = this.objExitArrow.height * .5;
				//this.objExitArrow.angle = 90;
				var targetAngle = (360 / (2 * Math.PI)) * this.game.math.angleBetween(
					this.objExitArrow.x, this.objExitArrow.y,
					StickyNinjaGlobals.exitdoorOpen.x, StickyNinjaGlobals.exitdoorOpen.y) + 90;
		
				//if(targetAngle < 0)
						//targetAngle += 360;
		
						//console.log("targetAngle : "+targetAngle);
						this.objExitArrow.angle = targetAngle;
						if(targetAngle>120 && targetAngle<150){
							this.objExitArrow.x = this.objExitArrow.x - 5;
							this.objExitArrow.y = this.objExitArrow.y + 15;
						}else if(targetAngle >149 && targetAngle <200){
							this.objExitArrow.x = this.objExitArrow.x - 25;
							this.objExitArrow.y = this.objExitArrow.y+8;
						}
						else if(targetAngle >199 && targetAngle <260){
							this.objExitArrow.x = this.objExitArrow.x - 36;
							this.objExitArrow.y = this.objExitArrow.y;
						}
						else if(targetAngle >259){
							this.objExitArrow.x = this.objExitArrow.x - 38;
							this.objExitArrow.y = this.objExitArrow.y-22;
						}
			}

			/*if (this.enemy_tickmark) {
				this.enemy_tickmark.x = this.humanPlayer.body.x -370;
				this.enemy_tickmark.y = this.humanPlayer.body.y +210;	
				
				
			}*/


		}

		if (StickyNinjaGlobals.triggerExitDoor == 2) {
			if (!this.tween1) {
				StickyNinjaGlobals.triggerExitDoor = 3;
				var dir = 1;
				this.humanPlayer.body.angle = 0;
				this.humanPlayer.body.x = exitDoorWidth - 5;
				this.humanPlayer.body.y = exitDoorHeight + 5;


				this.objExitArrowIcon.visible = false;
				this.objExitArrow.visible = false;
				//this.enemy_tickmark.visible = false;

				this.humanPlayer.body.velocity.x = -0;
				this.humanPlayer.body.velocity.y = -0;
				this.humanPlayer.body.gravityScale = 0;
				this.humanPlayer.animations.stop();
				this.humanPlayer.loadTexture('playerExitAnim', 0, false);
				this.humanPlayer.body.angle = 0;
				this.humanPlayer.angle = 0;

				//this.game.sfxExitEnter.play();
				this.humanPlayer.animations.play('playerExitAnim', 2, true);
				//this.humanPlayer.animations.play('playerExitAnim');
				this.humanPlayer.body.angle = 0;
				this.humanPlayer.angle = 0;
				//console.log("boddddddddddddddddddddddd:" + this.humanPlayer.body.sprite.key);
				if (StickyNinjaGlobals.soundOn) {
					this.game.sfxExitEnter.play();
				}
				//exitAnim.onComplete.add(function(){
				this.tween1 = this.game.add.tween(this.humanPlayer.scale).to({ x: 0, y: 0 }, 3000, Phaser.Easing.InOut, true);
				this.tween1.onComplete.add(function () {

					this.humanPlayer.loadTexture('playerExitAnim', 0, false);
					this.humanPlayer.body.angle = 0;
					this.humanPlayer.angle = 0;
					this.humanPlayer.animations.play('playerExitAnim', 2, true);
					//this.humanPlayer.animations.play('playerExitAnim');
					this.levelCompletedFlag++;
					//this.humanPlayer.body.sensor = true;                 
					this.humanPlayer.body.angle = 0;
					this.humanPlayer.angle = 0;
					//body1.destroy();
					//this.game.state.start("play");
					var cDay = getDay();
					var cLevel = getLevel();
					updateJumps(cDay, cLevel, jumps);
					goldCountText.setText("1000");

					updateTotalScore(score + 1000);
					updateScore(cDay, cLevel, score);
					updateDay(cDay);
					updateLevel(cLevel);

					if (cLevel < 5) {
						cDay = cDay - 1;
					}
					updateCompleted(cDay, cLevel);
					window.StickyNinjaMission.state.menu.openResultScreen('levelComplete');
				}, this);
				//}, this);
			}
		}

	},
	showExitArrow: function () {
		console.log("showExitArrow");
		this.objExitArrowIcon.visible = true;
		this.objExitArrow.visible = true;

		this.objExitArrow.alpha = 0;
		var tween1 = gameGlobal.add.tween(this.objExitArrow).to({ alpha: 1 }, 100, Phaser.Easing.Linear.None, true, 0, 1000, true);

		this.objExitArrowIcon.alpha = 0;
		var tween1 = gameGlobal.add.tween(this.objExitArrowIcon).to({ alpha: 1 }, 100, Phaser.Easing.Linear.None, true, 0, 1000, true);
	},


	configureCallbacks: function () {
	},

	shutdown: function () {
	}
};