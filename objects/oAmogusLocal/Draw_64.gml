#region Text
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fntName)
var _spriteHeight = sprite_get_height(sAmogus);
draw_set_color(c_white)	//BREAINDEAD

var nameOffX = (x - camX) * (windowW / guiW)
var nameOffY = (y - camY - 20) * (windowH / guiH)
var textSize = windowH / guiH / 10
draw_text_transformed(nameOffX, nameOffY, username, textSize, textSize, 0);
	
surface_set_target(textSurf)
	draw_clear_alpha(c_black,0)
	var tX = (camX - off)
	var tY = (camY - off)
	var wW = windowW
	var wH = windowH
	draw_surface_stretched_ext(lightSurf,(targetX - camX) * (windowW / guiW) - off,(targetY - camY) * (windowH / guiH) - off,windowW + off * 2,windowH + off * 2,c_black,1)
	gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_src_alpha)
	with (obj_AmogusClient)
	{
		nameOffX = (x - tX) * (wW / guiW)
		nameOffY = (y - tY) * (wH / guiH)
		draw_text_transformed(nameOffX, nameOffY, username, textSize, textSize, 0);
		//draw_text_transformed(100, 100, username, 1, 1, 0);
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	surface_reset_target()

gpu_set_blendmode(bm_normal)
draw_set_color(c_white)

shader_set(shIsText)
draw_surface(textSurf,0,0)
shader_reset()
#endregion

//Tasky ach jo
function movable()
{
	
}

if (interactableObject != noone)
{
	switch (interactableObject.type)
	{
		case interactable.emergencyButton:
		{
			//Send Message to Start a Meeting to All Clients
			if (obj_GameManager.serverSide)
			{
				var _serverBuffer = obj_Server.serverBuffer;
				message_game_meeting(_serverBuffer, clientId);
				with (obj_AmogusClient)
					network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
				
				transition(menu.meeting, noone, true);
			}
			
			//Send Message to Start a Meeting to the Server
			else if (obj_GameManager.serverSide == false)
			{
				var _clientBuffer = obj_Client.clientBuffer;
				message_game_meeting(_clientBuffer, clientId);
				network_send_packet(obj_Client.client, _clientBuffer, buffer_tell(_clientBuffer));
			}
			
			interactableObject = noone;
			interactableStruct = noone;
		}
		break;
	}
}