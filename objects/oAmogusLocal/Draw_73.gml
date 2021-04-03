if (obj_GameManager.inGame)
{
	surface_set_target(lightSurf)
	//draw_clear()
	//gpu_set_blendmode_ext(bm_dest_color, bm_inv_src_alpha)
	if (camState = CAMERA.followPlayer) gpu_set_blendmode_ext(bm_dest_alpha,bm_inv_src_alpha)
	var tX = targetX - off
	var tY = targetY - off
	with (obj_AmogusClient)
	{
		//Animate && Draw the Amogus
		var _speed = other.animationSpeed;
		var _frame = 0;
		if (animationProgress div (2 * _speed)) _frame = 1;
		if (animationProgress div (5 * _speed)) _frame = 0;
		if (animationProgress div (7 * _speed)) _frame = 2;
		animationProgress = (animationProgress + 1) % (10 * _speed);
		
		var _hsp = targetX - originalX;
		var _vsp = targetY - originalY;
		if (_hsp != 0)
			sideFacing = sign(_hsp);
		else if (_vsp == 0)
			animationProgress = 0;
	
		var _jumpOffset = 0;
		if (_frame == 1) _jumpOffset = 5;
		else if (_frame == 2) _jumpOffset = 3;
		draw_sprite_ext(spr_Body, bodyId * 3 + _frame, x - tX, y - tY - _jumpOffset, sideFacing, 1, 0, c_white, 1);
		draw_sprite_ext(spr_Head, headId, x - tX, y - tY - _jumpOffset, sideFacing, 1, 0, c_white, 1);
	}

	gpu_set_blendmode(bm_normal)
	surface_reset_target()
	
	shader_set(shAlpha)
	draw_surface(lightSurf,targetX-off,targetY-off)
	shader_reset()
	
	//Animate && Draw the Amogus
	var _speed = animationSpeed;
	var _frame = 0;
	if (animationProgress div (2 * _speed)) _frame = 1;
	if (animationProgress div (5 * _speed)) _frame = 0;
	if (animationProgress div (7 * _speed)) _frame = 2;
	animationProgress = (animationProgress + 1) % (10 * _speed);
	
	if (hsp != 0)
		sideFacing = sign(hsp);
	else if (vsp == 0)
		animationProgress = 0;
	
	var _jumpOffset = 0;
	if (_frame == 1) _jumpOffset = 5;
	else if (_frame == 2) _jumpOffset = 3;
	draw_sprite_ext(spr_Body, bodyId * 3 + _frame, x, y - _jumpOffset, sideFacing, 1, 0, c_white, playerAlpha);
	draw_sprite_ext(spr_Head, headId, x, y - _jumpOffset, sideFacing, 1, 0, c_white, playerAlpha);
	
	if (camState = CAMERA.followPlayer)
	{
		surface_set_target(darkenSurf)
			draw_clear(c_gray)
			draw_circle_color(x-targetX+off,y-targetY+off,150,c_black,c_gray,0)
			//draw_surface(lightSurf,targetX+off,targetY+off)
		surface_reset_target()
		gpu_set_blendmode(bm_subtract)
		if (global.lightsOn) draw_set_alpha(.05)
		else draw_set_alpha(.5)
		draw_surface(darkenSurf,targetX - off,targetY - off)
		draw_set_alpha(1)
		gpu_set_blendmode(bm_normal)
	}
	
	
	//Draw Interaction Text
	if (interactableInRange != noone)
	{
		draw_set_halign(fa_center);
		draw_set_font(fntTextUI)
		var _spriteHeight = sprite_get_height(spr_ButtonTest);
		draw_text_transformed_colour(interactableInRange.x, interactableInRange.y + _spriteHeight * 0.5 + 10,
									 "Press E to interact", 0.15, 0.15, 0, c_white, c_white, c_white, c_white, 1);
		draw_set_valign(fa_top);
	}
}
