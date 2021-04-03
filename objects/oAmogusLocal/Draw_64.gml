#region Text
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fntName)
draw_set_color(c_white)	//BREAINDEAD

var nameOffX = (x - camX) * windowToGui
var nameOffY = (y - camY - 20) * windowToGui
var textSize = windowToGui / 10
var _name = id_get_name(nameId);
draw_text_transformed(nameOffX, nameOffY + 10, _name, textSize, textSize, 0);
	
surface_set_target(textSurf)
	draw_clear_alpha(c_black,0)
	var tX = (camX - off)
	var tY = (camY - off)
	var wW = windowW
	var wH = windowH
	var offGui = off * windowToGui
	draw_surface_stretched_ext(lightSurf,(targetX - camX) * windowToGui - offGui,(targetY - camY) * windowToGui - offGui,windowW + offGui * 2,windowH + offGui * 2,c_black,1)
	if (camState = CAMERA.followPlayer) gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_src_alpha)
	with (obj_AmogusClient)
	{
		if (isAlive)
		{
			var offX = 10
			var offY = 28
			if (other.tilemap != noone && tilemap_get_at_pixel(other.tilemap,x, y - offY) && other.camState = CAMERA.followPlayer) offY = -8
			nameOffX = (x - tX - offX) * windowToGui
			nameOffY = (y - tY - offY) * windowToGui
			var _name = id_get_name(nameId);
			draw_text_transformed(nameOffX, nameOffY, _name, textSize, textSize, 0);
			//draw_text_transformed(100, 100, _name, 1, 1, 0);
		}
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

if (interactableObject != noone && isAlive)
{
	switch (interactableObject.type)
	{
		case interactable.emergencyButton:
		{
			//Send Message to Start a Meeting to All Clients
			if (obj_GameManager.serverSide)
			{
				var _serverBuffer = obj_Server.serverBuffer;
				message_game_meeting(_serverBuffer, clientId, false);
				with (obj_AmogusClient)
					network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
				
				warning(warningType.meeting);
				transition(menu.meeting, noone, true);
			}
			
			//Send Message to Start a Meeting to the Server
			else if (obj_GameManager.serverSide == false)
			{
				var _clientBuffer = obj_Client.clientBuffer;
				message_game_meeting(_clientBuffer, clientId, false);
				network_send_packet(obj_Client.client, _clientBuffer, buffer_tell(_clientBuffer));
			}
			
			interactableObject = noone;
			interactableStruct = noone;
		}
		break;
		
		case interactable.body:
		{
			//Send Message to Start a Meeting to All Clients
			if (obj_GameManager.serverSide)
			{
				var _serverBuffer = obj_Server.serverBuffer;
				message_game_meeting(_serverBuffer, clientId, true);
				with (obj_AmogusClient)
					network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
				
				warning(warningType.body);
				transition(menu.meeting, noone, true);
			}
			
			//Send Message to Start a Meeting to the Server
			else if (obj_GameManager.serverSide == false)
			{
				var _clientBuffer = obj_Client.clientBuffer;
				message_game_meeting(_clientBuffer, clientId, true);
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
		
		case interactable.wires:
		{
			draw_sprite_stretched(sWires,0,0,0,windowW,windowH)
			
			//vars
			var mouseX = device_mouse_x_to_gui(0)
			var mouseY = device_mouse_y_to_gui(0)
			
			var wireCount = interactableStruct.wireCount
			var wireRadius = interactableStruct.wireRadius
			var wirePositions = interactableStruct.wirePositions
			var goalPositions = interactableStruct.goalPositions
			var hueOffset = 40
			var offset = wireRadius * windowToGui
			
			//Rendering
			for (var i = 0; i < wireCount+1; i++)
			{
				draw_set_color(make_color_hsv(i * hueOffset,150,255))
				var pos = wirePositions[i]
				var xx = pos[0] * windowToGui + (windowW / 2)
				var yy = pos[1] * windowToGui + (windowH / 2)
			    draw_rectangle(xx - offset,yy - offset,xx + offset,yy + offset,0)
				draw_sprite_stretched(sWireSocket,0,xx - offset - windowToGui,yy - offset - windowToGui,10 * windowToGui,10 * windowToGui)
			}
			for (var i = 0; i < wireCount+1; i++)
			{
				draw_set_color(make_color_hsv(i * hueOffset,150,255))
				var pos = goalPositions[i]
				var xx = pos[0] * windowToGui + (windowW / 2)
				var yy = pos[1] * windowToGui + (windowH / 2)
			    draw_rectangle(xx - offset,yy - offset,xx + offset,yy + offset,0)
				draw_sprite_stretched(sWireSocket,0,xx - offset - windowToGui,yy - offset - windowToGui,10 * windowToGui,10 * windowToGui)
			}
			
			//Interaction
			if (LMBpress)
			{
				var nearestWire = noone
				var smallestDist = infinity
				var dist = infinity
				for (var i = 0; i < wireCount+1; i++)
				{
				    dist = min(smallestDist, point_distance(mouseX,mouseY,wirePositions[i][0] * windowToGui + (windowH / 2),wirePositions[i][1] * windowToGui + (windowH / 2)))
					if (dist < smallestDist && !wirePositions[i][3])
					{
						nearestWire = wirePositions[i]
						smallestDist = dist
						interactableStruct.selectedWireID = i
					}
				}
				interactableStruct.selectedWire = nearestWire
			}
			
			if (LMB)
			{
				draw_set_color(make_color_hsv(interactableStruct.selectedWireID * hueOffset,150,255))
				draw_rectangle(mouseX - offset,mouseY - offset,mouseX + offset,mouseY + offset,0)
				
				var selectedWire = interactableStruct.selectedWire
				var wireX = selectedWire[0] * windowToGui + (windowW / 2)
				var wireY = selectedWire[1] * windowToGui + (windowH / 2)
				draw_primitive_begin(pr_trianglefan)
					draw_vertex(wireX,wireY - offset)
					draw_vertex(mouseX,mouseY - offset)
					draw_vertex(mouseX,mouseY + offset)
					draw_vertex(wireX,wireY + offset)
				draw_primitive_end()
				
				draw_sprite_stretched(sWireSocket,0,mouseX - offset - windowToGui,mouseY - offset - windowToGui,10 * windowToGui,10 * windowToGui)
			}
			
			if (!surface_exists(wiresSurf)) wiresSurf = surface_create(windowW,windowH)
			
			if (LMBrelease)
			{
				var nearestGoal = noone
				var smallestDist = infinity
				var dist = infinity
				for (var i = 0; i < wireCount+1; i++)
				{
				    dist = min(smallestDist, point_distance(mouseX,mouseY,goalPositions[i][0] * windowToGui + (windowH / 2),goalPositions[i][1] * windowToGui + (windowH / 2)))
					if (dist < smallestDist)
					{
						nearestGoal = goalPositions[i]
						smallestDist = dist
					}
				}
				var selectedWire = interactableStruct.selectedWire
				var wireX = selectedWire[0] * windowToGui + (windowW / 2)
				var wireY = selectedWire[1] * windowToGui + (windowH / 2)
				var goalX = nearestGoal[0] * windowToGui + (windowW / 2)
				var goalY = nearestGoal[1] * windowToGui + (windowH / 2)
				var maxDist = 50
				if (nearestGoal[2] = selectedWire[2] && point_distance(mouseX,mouseY,goalX,goalY) < maxDist * windowToGui)
				{
					draw_set_color(make_color_hsv(interactableStruct.selectedWireID * hueOffset,150,255))
					surface_set_target(wiresSurf)
						offset -= windowToGui	//Correction to account for sWireSocket
						draw_primitive_begin(pr_trianglefan)
							draw_vertex(wireX,wireY - offset)
							draw_vertex(goalX,goalY - offset)
							draw_vertex(goalX,goalY + offset)
							draw_vertex(wireX,wireY + offset)
						draw_primitive_end()
					surface_reset_target()
					interactableStruct.completedWires++
					interactableStruct.wirePositions[interactableStruct.selectedWireID][3] = true
				}
			}
			
			draw_surface(wiresSurf,0,0)
			
			if (interactableStruct.completedWires > wireCount)
			{
				exitUI = true
				taskCompleted = true
			}
			
			if (exitUI)
			{
				surface_free(wiresSurf)
				interactableStruct.completedWires = 0
				for (var i = 0; i < wireCount+1; i++)
				{
					interactableStruct.wirePositions[i][3] = false
				}
				ExitMenu(taskCompleted)
			}
		}
		break;
	}
}

if (interactableInRange != noone)
	show_debug_message(interactableInRange.type);

if (obj_GameManager.inGame)
{
	//Get GUI Properties
	var _guiWidth = display_get_gui_width();
	var _guiHeight = display_get_gui_height();
	
	var _mouseX = window_mouse_get_x();
	var _mouseY = window_mouse_get_y();

	//Killing
	if (isAlive && isImpostor)
	{
		var _ableToKill = false;
		var _killButtonSelected = false;
		var _amogusNearest = instance_nearest(x, y, obj_AmogusClient);
		if (_amogusNearest != noone && !_amogusNearest.isImpostor && _amogusNearest.isAlive)
		{
			if (point_distance(x, y, _amogusNearest.x, _amogusNearest.y) < KILL_RANGE)
			{
				_ableToKill = true;
				if (point_in_rectangle(_mouseX, _mouseY, _guiWidth * 0.55, _guiHeight * 0.72, _guiWidth * 0.77, _guiHeight))
				{
					_killButtonSelected = true;
					if (mouse_check_button_pressed(mb_left))
					{
						//Send Message to Kill the Amogus
						if (obj_GameManager.serverSide)
						{
							var _interactableId = obj_GameManager.interactableIdCount ++;
							var _serverBuffer = obj_Server.serverBuffer;
							message_kill(_serverBuffer, _amogusNearest.clientId, _interactableId)
							with (obj_AmogusClient)
								network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
							
							_amogusNearest.isAlive = false;
							var _body = instance_create_layer(_amogusNearest.x, _amogusNearest.y, "Interactables", obj_Interactable);
							with (_body)
							{
								type = interactable.body;
								interactableId = _interactableId;
								interactableStruct = new Interactable(interactable.body);
								interactableStruct.clientId = _amogusNearest.clientId;
								interactableStruct.headId = _amogusNearest.headId;
								interactableStruct.bodyId = _amogusNearest.bodyId;
							}
						}
						
						else
						{
							var _clientBuffer = obj_Client.clientBuffer;
							buffer_seek(_clientBuffer, buffer_seek_start, 0);
							buffer_write(_clientBuffer, buffer_u8, messages.kill);
							buffer_write(_clientBuffer, buffer_u8, _amogusNearest.clientId);
							
							network_send_packet(obj_Client.client, _clientBuffer, buffer_tell(_clientBuffer));
						}
					}
				}
			}
		}
		
		var _colour = (_ableToKill) ? c_white : c_grey;
		draw_sprite_ext(spr_Kill, _killButtonSelected, _guiWidth * 0.8, _guiHeight, 3, 3, 0, _colour, 1);
		if (_killButtonSelected)
			obj_Menu.buttonIsSelected = true;
	}
	
	//Body Reporting
	if (isAlive)
	{
		var _ableToReport = false;
		var _reportButtonSelected = false;
		if (interactableInRange != noone && interactableInRange.type = interactable.body)
		{
			_ableToReport = true;
			if (point_in_rectangle(_mouseX, _mouseY, _guiWidth * 0.77, _guiHeight * 0.72, _guiWidth, _guiHeight))
			{
				_reportButtonSelected = true;
				if (mouse_check_button_pressed(mb_left))
				{
					interactableObject = interactableInRange;
					interactableStruct = interactableInRange.interactableStruct;
					interactableObject.amogus = self;
					inMenu = true
				}
			}
		}
		
		var _colour = (_ableToReport) ? c_white : c_grey;
		draw_sprite_ext(spr_Report, _reportButtonSelected, _guiWidth, _guiHeight, 3, 3, 0, _colour, 1);
		if (_reportButtonSelected)
			obj_Menu.buttonIsSelected = true;
	}
}
