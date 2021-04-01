//Networking
clientSocket = noone;
clientId = noone;
username = noone;

//Amogus Properties
isAlive = true;
isImpostor = false;
headId = 0;
bodyId = 0;

//Animation
sideFacing = 1;	//-1 - left, 1 - right
animationProgress = 0;

//Meeting
hasVoted = false;
voteArray = [];	//array storing IDs of aoguses who voted for the amogus

//Movement
originalX = x;
originalY = y;
targetX = x;
targetY = y;
positionUpdateTimer = 0;
