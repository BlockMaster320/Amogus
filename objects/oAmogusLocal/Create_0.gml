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

//Networking
clientSocket = noone;
clientId = noone;
username = noone;

gameStartSetup = true;
isImpostor = false;
alarm[0] = POSITION_UPDATE;

#region Resize screen
application_surface_draw_enable(false)
global.monitorW = window_get_width()
global.monitorH = window_get_height()
#endregion

//Interactables
interactableObject = noone;
interactableStruct = noone;
interactionCooldown = false;