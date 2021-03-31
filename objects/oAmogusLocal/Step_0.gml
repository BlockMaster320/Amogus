if (obj_GameManager.inGame)
{
	//Set the Tile Map
	if (gameStartSetup)
	{
		tilemap = layer_tilemap_get_id("Walls");
		//layer_shader(layer_get_id("Walls"),shVignete)
		
		camera_set_view_size(cam, guiW, guiH);
	}
	
	//Movement
	MovementInput();
	if (interactableObject == noone && obj_Menu.menuState == noone)
	{
		hsp = (right - left) * spd
		vsp = (down - up) * spd

		#region Kolize
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
	#endregion
	
	#region Camera
	targetX = clamp(x - (guiW/2),0,rW - guiW)
	targetY = clamp(y - (guiH/2),0,rH - guiH)
        
	camX = lerp(camX,targetX,.15)
	camY = lerp(camY,targetY,.15)

	camera_set_view_pos(cam,camX,camY)
	#endregion
	
	//Search for Interactables
	MovementInput();
	if (interactableObject == noone /*&& !isImpostor*/)
	{
		interactableInRange = noone;
		with (obj_Interactable)
		{
			if (amogus == noone && point_distance(x, y, other.x, other.y) < interactableStruct.distance)
			{
				other.interactableInRange = self;
				if (other.buttonInteract)
				{
					other.interactableObject = self;
					other.interactableStruct = interactableStruct;
					amogus = other;
				}
			}
		}
	}
	
	//Exit an Interactable
	else if (interactableObject != noone && buttonInteract)
	{
			interactableObject.amogus = noone;
			interactableObject = noone;
			interactableStruct = noone;
	}
}
