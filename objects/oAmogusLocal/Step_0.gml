MovementInput(!inMenu);
UIinput(inMenu)

//ez
rW = room_width
rH = room_height

if (obj_GameManager.inGame)
{
	alarm[1] = 20;
	//Set Up Tasks
	if (taskSetup)
	{

		taskSetup = false;
	}
	
	//Set the Tile Map
	if (gameStartSetup)
	{
		tilemap = layer_tilemap_get_id("Walls");
		camera_set_view_size(cam, guiW, guiH);
	}
	
	//Movement
	if (interactableObject == noone && obj_Menu.menuState == noone)
	{
		hsp = (right - left) * spd
		vsp = (down - up) * spd

		#region Kolize
		if (isAlive)
		{
			var bboxSide
			if (hsp > 0) bboxSide = bbox_right; else bboxSide = bbox_left
			if (tilemap_get_at_pixel(tilemap,bboxSide + round(hsp),bbox_top) != 0 or
				tilemap_get_at_pixel(tilemap,bboxSide + round(hsp),bbox_bottom) != 0)
			{
				if (hsp > 0) x = x - (bbox_right % TL_SIZE) + TL_SIZE - 1
				else x = x - (bbox_left % TL_SIZE)
				hsp = 0
			}
			x += hsp


			if (vsp > 0) bboxSide = bbox_bottom; else bboxSide = bbox_top
			if (tilemap_get_at_pixel(tilemap,bbox_left,bboxSide + round(vsp)) != 0 or
				tilemap_get_at_pixel(tilemap,bbox_right,bboxSide + round(vsp)) != 0)
			{
				if (vsp > 0) y = y - (bbox_bottom % TL_SIZE) + TL_SIZE - 1
				else y = y - (bbox_top % TL_SIZE)
				vsp = 0
			}
			y += vsp
		}
		else
		{
			x += hsp
			y += vsp
		}
	}
	#endregion
	
	#region Camera
	if (camState = CAMERA.followPlayer)
	{
		targetX = clamp(x - (guiW/2),0,rW - guiW)
		targetY = clamp(y - (guiH/2),0,rH - guiH)
	}
    
	camX = lerp(camX,targetX,.15)
	camY = lerp(camY,targetY,.15)

	camera_set_view_pos(cam,camX,camY)
	#endregion
	
	//Search for Interactables
	if (interactableObject == noone && isAlive)
	{
		interactableInRange = noone;
		var nearestInteractable = instance_nearest(x,y,obj_Interactable)
		var canInteract = false
		if (!isImpostor)
		{
			if (nearestInteractable.usable or (nearestInteractable.type >= 5 and nearestInteractable.type <= 7) or (nearestInteractable.type = interactable.lights and !global.lightsOn)) canInteract = true
		}
		if (isImpostor and nearestInteractable.type >= 5 and nearestInteractable.type <= 9) canInteract = true
		
		if (point_distance(x, y, nearestInteractable.x, nearestInteractable.y) < nearestInteractable.interactableStruct.distance && nearestInteractable.amogus == noone and canInteract)
		{
			interactableInRange = nearestInteractable;
			if (buttonInteract)
			{
				audio_play_sound(sndButton,0,0)
				interactableObject = nearestInteractable;
				interactableStruct = nearestInteractable.interactableStruct;
				interactableObject.amogus = self;
				inMenu = true
					
				//Interact "create" event
				switch (interactableObject.type)
				{
					case interactable.camera:
						camState = CAMERA.onCam
						camX = interactableStruct.camPosX
						camY = interactableStruct.camPosY
						targetX = camX
						targetY = camY
						break
					case interactable.wires:
						wiresSurf = surface_create(windowW,windowH)
						surface_set_target(wiresSurf)
							draw_clear_alpha(c_black,0)
						surface_reset_target()
						break
						
					case interactable.vent:
						//Send Message to Change Amogus's Alpha
						if (obj_GameManager.serverSide)
						{
							var _serverBuffer = obj_Server.serverBuffer;
							message_amogus_alpha(_serverBuffer, clientId, 0);
							with (obj_AmogusClient)
								network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
						}
						else
						{
							var _clientBuffer = obj_Client.clientBuffer;
							message_amogus_alpha(_clientBuffer, clientId, 0);
							network_send_packet(obj_Client.client, _clientBuffer, buffer_tell(_clientBuffer));
							
						}
						playerAlpha = 0
						break
						
					/*case interactable.shooter:
						pSys = part_system_create()
					
						p = part_type_create()
						
						part_type_life(p,20,40)
						part_type_color2(p,c_red,c_white)
						part_type_size(p,windowToGui*0.5,windowToGui,-0.01,0)
						part_type_gravity(p,0.1,90)
						part_type_speed(p,1,2,0,0)
						break*/
				}
			}
		}
	}
}