#region Camera
camX = 0
camY = 0

cam = view_camera[0]

targetX = 0
targetY = 0

rW = room_width
rH = room_height

#macro guiW 320
#macro guiH 180

camera_set_view_size(cam,guiW,guiH)
#endregion

spd = 1
hsp = 0
vsp = 0

tilemap = noone
/*tilemap = layer_tilemap_get_id("Walls")*/

#macro off 10
lightSurf = surface_create(guiW + off*2,guiH + off*2)
darkenSurf = surface_create(guiW + off*2,guiH + off*2)

#region Resize screen
application_surface_draw_enable(false)
monitorW = window_get_width()
monitorH = window_get_height()
#endregion

//Interactables
interactableObject = noone;
interactableStruct = noone;
interactableInRange = noone;

//Amogus Properties
isAlive = true;
isImpostor = false;
avatarId = 0;

//Networking
clientSocket = noone;
clientId = noone;
username = noone;

gameStartSetup = true;
alarm[0] = POSITION_UPDATE;

//Meeting
hasVoted = false;
voteArray = [];	//array storing IDs of aoguses who voted for the amogus
