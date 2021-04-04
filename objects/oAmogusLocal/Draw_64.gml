#region Text
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fntName)
draw_set_color(c_white)	//BREAINDEAD

var nameOffX = (x - camX) * windowToGui
var nameOffY = (y - camY - 20) * windowToGui
var textSize = windowToGui / 10
var _name = id_get_name(nameId);
draw_text_transformed_color(nameOffX, nameOffY + 10, _name, textSize, textSize, 0,c_white,c_white,c_white,c_white,playerAlpha);

surface_set_target(textSurf)
	draw_clear_alpha(c_black,0)
	var tX = (camX - off)
	var tY = (camY - off)
	var wW = windowW
	var wH = windowH
	var offGui = off * windowToGui
	draw_surface_stretched_ext(lightSurf,(targetX - camX) * windowToGui - offGui,(targetY - camY) * windowToGui - offGui,windowW + offGui * 2,windowH + offGui * 2,c_black,1)
	if (camState = CAMERA.followPlayer and isAlive) gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_src_alpha)
	with (obj_AmogusClient)
	{
		if (isAlive && playerAlpha > 0)
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

//Interactable local vars
var mouseX = device_mouse_x_to_gui(0)
var mouseY = device_mouse_y_to_gui(0)

if (interactableObject != noone && isAlive)
{
	if (LMBpress) audio_play_sound(sndButton,0,0)
	
	switch (interactableObject.type)
	{
		case interactable.emergencyButton:
		{
			obj_Menu.caller = nameId
			
			//Send Message to Start a Meeting to All Clients
			if (obj_GameManager.serverSide)
			{
				var _serverBuffer = obj_Server.serverBuffer;
				message_game_meeting(_serverBuffer, clientId, false);
				with (obj_AmogusClient)
					network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
				
				warning(warningType.meeting, 1);
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
			obj_Menu.caller = nameId
			
			//Send Message to Start a Meeting to All Clients
			if (obj_GameManager.serverSide)
			{
				var _serverBuffer = obj_Server.serverBuffer;
				message_game_meeting(_serverBuffer, clientId, true);
				with (obj_AmogusClient)
					network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
				
				warning(warningType.body, 1);
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
				ResetCameraPos()
				ExitMenu(false)
			}
		}
		break;
		
		case interactable.lights:
		{
			draw_sprite_stretched(sWires,0,0,0,windowW,windowH)
			var rowCount = interactableStruct.rowCount
			var collCount = interactableStruct.collCount
			var offSwitches = 0
			var xOff = 40
			var yOff = 30
			for (var i = 0; i < rowCount; i++)
			{
				for (var j = 0; j < collCount; j++)
				{
					var pos = interactableStruct.switchPositions[i,j]
					var xx = ((xOff * j) - (xOff * collCount / 2)) * windowToGui + (windowW / 2) - windowToGui
					var yy = ((yOff * i) - (yOff * rowCount / 2)) * windowToGui + (windowH / 2) - windowToGui
					
					var offset = interactableStruct.clickOffset
					if (LMBpress and point_in_rectangle(mouseX,mouseY,xx - offset,yy - offset,xx + 20 * windowToGui + offset,yy + 20 * windowToGui + offset))
					{
						/*interactableStruct.switchPositions[i,j][2] = !interactableStruct.switchPositions[i,j][2]*/
						//Send Message to Change the Ligth Switches
						if (obj_GameManager.serverSide)
						{
							var _serverBuffer = obj_Server.serverBuffer;
							message_lights(_serverBuffer, i, j);
							with (obj_AmogusClient)
								network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
							
							with (obj_Interactable)
							{
								if (type == interactable.lights)
									interactableStruct.switchPositions[i, j] = !interactableStruct.switchPositions[i,j]
							}
						}
						else
						{
							var _clientBuffer = obj_Client.clientBuffer;
							message_lights(_clientBuffer, i, j);
							with (obj_AmogusClient)
								network_send_packet(clientSocket, _clientBuffer, buffer_tell(_clientBuffer));
						}
					}
					
					draw_sprite_stretched(sSwitch,pos,xx,yy,20 * windowToGui,20 * windowToGui)
					if (pos = true) offSwitches++
				}
			}
			if (offSwitches > 0) global.lightsOn = false
			else global.lightsOn = true
			
			if (exitUI) ExitMenu(false)
		}
		break
		
		case interactable.wires:
		{
			draw_sprite_stretched(sWires,0,0,0,windowW,windowH)
			
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
				audio_play_sound(sndButton,0,0)
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
					
					audio_play_sound(sndSucces,0,0)
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
		
		case interactable.vent:
		{
			var minDistance = 30
			var maxDistance = 400
			//Closest dir
			var dir//, dirCorrected, correctedClosestDir
			var mouseDir = point_direction(x,y,mouse_x,mouse_y)
			var closestDir = infinity
			for (var i = 0; i < array_length(global.ventPositions); i++)
			{
				var distToVent = point_distance(x,y,global.ventPositions[i][0],global.ventPositions[i][1])
				if (distToVent > minDistance and distToVent < maxDistance)
				{
					dir = point_direction(x,y,global.ventPositions[i][0],global.ventPositions[i][1])
					if (is_infinity(closestDir)) closestDir = dir
					/*dirCorrected = dir - ((dir div 180) * (dir % 180) * 2)
					correctedClosestDir = closestDir - ((closestDir div 180) * (closestDir % 180) * 2)
					if (abs(mouseDir - correctedClosestDir) > abs(mouseDir - dirCorrected)) closestDir = dir*/
					if (abs(angle_difference(mouseDir,dir)) < abs(angle_difference(mouseDir,closestDir))) closestDir = dir
				}
			}
			
			for (var i = 0; i < array_length(global.ventPositions); i++)
			{
				var distToVent = point_distance(x,y,global.ventPositions[i][0],global.ventPositions[i][1])
				if (distToVent > minDistance and distToVent < maxDistance)
				{
					var alpha = 0.5
					var scale = 0.5 * windowToGui
				
					dir = point_direction(x,y,global.ventPositions[i][0],global.ventPositions[i][1])
					if (dir == closestDir)
					{
						alpha = 1
						scale *= 1.5
						if (LMBpress)
						{
							x = global.ventPositions[i][0]
							y = global.ventPositions[i][1]
							ResetCameraPos()
						}
					}
					
					var offset = 50
					var xx = (x - camX + lengthdir_x(offset,dir)) * windowToGui
					var yy = (y - camY + lengthdir_y(offset,dir)) * windowToGui
					//draw_sprite_general(sArrow,0,0,0,20 * windowToGui,20 * windowToGui,xx,yy,1,1,dir,c_white,c_white,c_white,c_white,1)
					draw_sprite_ext(sArrow,0,xx,yy,scale,scale,dir-90,c_white,alpha)
				}
			}
			
			if (exitUI)
			{
				playerAlpha = 1
				ExitMenu(false)
			}
		}
		break
		
		case interactable.shooter:
		{
			draw_sprite_stretched(sWires,0,0,0,windowW,windowH)
			draw_sprite_stretched(sCrosshair,0,mouseX - 10 * windowToGui,mouseY - 10 * windowToGui,20 * windowToGui, 20 * windowToGui)
			
			var xx = interactableStruct.targetPositionX * windowToGui + windowW / 2
			var yy = interactableStruct.targetPositionY * windowToGui + windowH / 2
			
			var offset = 10
			if (LMBpress && point_in_rectangle(mouseX,mouseY,xx - 10 * windowToGui,yy - 10 * windowToGui,xx + 10 * windowToGui,yy + 10 * windowToGui))
			{
				audio_play_sound(sndSucces,0,0)
				interactableStruct.succesfulShots++
				interactableStruct.resetCooldown = -1
			}
			
			//draw_rectangle(xx - 10 * windowToGui,yy - 10 * windowToGui,xx + 10 * windowToGui,yy + 10 * windowToGui,0)
			draw_sprite_stretched(sTarget,0,xx - 7.5 * windowToGui,yy - 7.5 * windowToGui,15 * windowToGui, 15 * windowToGui)
			
			interactableStruct.resetCooldown--
			if (interactableStruct.resetCooldown < 0)
			{
				var xRandomRange = interactableStruct.xRandomRange
				var yRandomRange = interactableStruct.yRandomRange
				interactableStruct.targetPositionX = irandom_range(-xRandomRange,xRandomRange)
				interactableStruct.targetPositionY = irandom_range(-yRandomRange,yRandomRange)
				interactableStruct.resetCooldown = interactableStruct.resetCooldownDef
			}
			
			var shotsRemaining = interactableStruct.minimumShots - interactableStruct.succesfulShots
			var scale = 0.2 * windowToGui
			draw_set_halign(fa_center)
			draw_set_font(fntTextUI)
			draw_text_transformed(windowW / 2,windowH / 5, "Shoot " + string(shotsRemaining + 1) + " more targets",scale,scale,0)
			
			if (interactableStruct.succesfulShots > interactableStruct.minimumShots)
			{
				taskCompleted = true
				exitUI = true
			}
			
			if (exitUI)
			{
				ExitMenu(taskCompleted)
			}
		}
		break
		
		case interactable.sliderCatch:
		{
			draw_sprite_stretched(sWires,0,0,0,windowW,windowH)
			var sliderCount = interactableStruct.sliderCount
			var sliderLengthCrop = interactableStruct.sliderLengthCrop / 2
			var offset, width, sliderCompleted
			var slidersCompleted = 0
			
			for (var i = 0; i < sliderCount; i++)
			{
				offset = 3 * windowToGui	//3 pixely
				var targetPositions = interactableStruct.targetPositions[i]
				width = targetPositions[2]
				var xx = targetPositions[0] * windowToGui + windowW / 2 - width * windowToGui
				var yy = targetPositions[1] * windowToGui + windowH / 2
				
				var sliderX = interactableStruct.sliderPositions[i][0] * windowToGui + windowW / 2
				var sliderY = interactableStruct.sliderPositions[i][1] * windowToGui + windowH / 2
				var handleX = interactableStruct.handlePositions[i][0] * windowToGui + windowW / 2
				var handleY = interactableStruct.handlePositions[i][1] * windowToGui + windowH / 2
				
				var rX1 = xx - offset * width
				var rY1 = yy - offset
				var rX2 = xx + offset * width
				var rY2 = yy + offset + windowToGui
				var cayoteOffset = 8 * windowToGui
				
				if (interactableStruct.activeSliderId == i)
				{
					interactableStruct.handlePositions[i][0] += interactableStruct.handlePositions[i][3]
					var targetHit = point_in_rectangle(handleX,handleY,rX1 - cayoteOffset,rY1,rX2 + cayoteOffset,rY2)
					if (LMBpress)
					{
						LMBpress = false
						if (targetHit)
						{
							audio_play_sound(sndSucces,0,0)
							interactableStruct.handlePositions[i][2] = true
							interactableStruct.activeSliderId++
						}
						else interactableStruct.handlePositions[i][0] = infinity * -sign(interactableStruct.handlePositions[i][3])
					}
					if (abs(interactableStruct.handlePositions[i][0]) > abs(sliderLengthCrop))
					{
						for (var j = 0; j <= interactableStruct.activeSliderId; j++)
						{
							interactableStruct.handlePositions[j][0] = sliderLengthCrop * -sign(interactableStruct.handlePositions[j][3])
							interactableStruct.handlePositions[j][2] = false
						}
						interactableStruct.activeSliderId = 0
					}
				}
				draw_sprite_stretched(sSlider,0,sliderX - 128 * windowToGui / 2,sliderY - 16 * windowToGui / 2,128 * windowToGui,16 * windowToGui)
				
				sliderCompleted = interactableStruct.handlePositions[i][2]	//Proč tenhle řádek rozbíjí všechno?
				if (sliderCompleted = false) draw_set_color(c_red)
				else draw_set_color(c_green)
				draw_set_alpha(0.4)
				draw_rectangle(rX1,rY1,rX2,rY2,0)
				draw_set_alpha(1)
				
				draw_sprite_stretched(sHandle,sliderCompleted,handleX - 20 * windowToGui / 2,handleY - 20 * windowToGui / 2,20 * windowToGui,20 * windowToGui)
				slidersCompleted += sliderCompleted
			}
			
			if (slidersCompleted = sliderCount)
			{
				taskCompleted = true
				exitUI = true
			}
			
			if (exitUI)
			{
				ExitMenu(taskCompleted)
			}
		}
		break
	}
}

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
						Killed(_amogusNearest.nameId)
						
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
							
							check_game_end();	//check for game end
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
