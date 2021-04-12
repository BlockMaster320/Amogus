#region Resize screen
application_surface_draw_enable(false)
windowW = window_get_width()
windowH = window_get_height()
#endregion

#region Camera
camX = 0
camY = 0

cam = view_camera[0]

targetX = 0
targetY = 0

#macro guiW 320
#macro guiH 180

camera_set_view_size(cam,guiW,guiH)

enum CAMERA
{
	followPlayer,
	onCam
}
camState = CAMERA.followPlayer
#endregion

spd = 1
hsp = 0
vsp = 0
tilemap = noone
/*tilemap = layer_tilemap_get_id("Walls")*/

#macro off 10
lightSurf = surface_create(guiW + off*2,guiH + off*2)
darkenSurf = surface_create(guiW + off*2,guiH + off*2)
textSurf = surface_create(windowW,windowH)

//Interactables
interactableObject = noone;
interactableStruct = noone;
interactableInRange = noone;

killTimer = KILL_COOLDOWN;
inMenu = false;
taskCompleted = false;
taskSetup = true;

global.lightsOn = true
global.activeTasks = array_create(0)
global.ventPositions = array_create(0)
global.lightPositions = array_create(0)

playerAlpha = 1

//Amogus Properties
isAlive = true;
isImpostor = false;
headId = 0;
bodyId = 0;

//Animation
sideFacing = 1;	//-1 - left, 1 - right
animationProgress = 0;
animationSpeed = 4;	//higher => slower

//Networking
clientSocket = noone;
clientId = noone;
nameId = 0;

gameStartSetup = true;
alarm[0] = POSITION_UPDATE;

//Meeting
hasVoted = false;
voteArray = [];	//array storing IDs of aoguses who voted for the amogus

//Set Task Surface
surfaceUI = noone;
surfaceText = noone;
guiToUI = guiW / display_get_gui_width();
