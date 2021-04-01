#region Text
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fntName)
var _spriteHeight = sprite_get_height(sAmogus);
draw_set_color(c_white)	//BREAINDEAD

var nameOffX = (x - camX) * (windowW / guiW)
var nameOffY = (y - camY - 20) * (windowH / guiH)
var textSize = windowH / guiH / 10
draw_text_transformed(nameOffX, nameOffY + 10, username, textSize, textSize, 0);
	
surface_set_target(textSurf)
	draw_clear_alpha(c_black,0)
	var tX = (camX - off)
	var tY = (camY - off)
	var wW = windowW
	var wH = windowH
	var offGui = off * (windowH / guiH)
	draw_surface_stretched_ext(lightSurf,(targetX - camX) * (windowW / guiW) - offGui,(targetY - camY) * (windowH / guiH) - offGui,windowW + offGui * 2,windowH + offGui * 2,c_black,1)
	if (camState = CAMERA.followPlayer) gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_src_alpha)
	with (obj_AmogusClient)
	{
		var offX = 10
		var offY = 25
		if (other.tilemap != noone && tilemap_get_at_pixel(other.tilemap,x - offX, y - offY)) offY = -8
		nameOffX = (x - tX - offX) * (wW / guiW)
		nameOffY = (y - tY - offY) * (wH / guiH)
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
				
				warning(warningType.meeting);
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
	
		case interactable.camera:
		{
			draw_sprite_stretched(sCameraView,0,0,0,windowW,windowH)
			if (exitUI)
			{
				camState = CAMERA.followPlayer
				camX = clamp(x - (guiW/2),0,rW - guiW)
				camY = clamp(y - (guiH/2),0,rH - guiH)
				ExitMenu()
			}
		}
		break;
	}
}