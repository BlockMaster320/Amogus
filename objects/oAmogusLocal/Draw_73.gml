if (obj_GameManager.inGame)
{
	surface_set_target(lightSurf)
	//draw_clear()
	//gpu_set_blendmode_ext(bm_dest_color, bm_inv_src_alpha)
	gpu_set_blendmode_ext(bm_dest_alpha,bm_inv_src_alpha)
	var tX = targetX - off
	var tY = targetY - off
	with (obj_AmogusClient)
	{
		draw_sprite(sAmogus,image_index,x-tX,y-tY)
	}

	gpu_set_blendmode(bm_normal)
	surface_reset_target()
	
	shader_set(shAlpha)
	draw_surface(lightSurf,targetX-off,targetY-off)
	shader_reset()
	
	draw_self()


	surface_set_target(darkenSurf)
		draw_clear(c_white)
		draw_circle_color(x-targetX+off,y-targetY+off,150,c_black,c_white,0)
		//draw_surface(lightSurf,targetX+off,targetY+off)
	surface_reset_target()
	gpu_set_blendmode(bm_subtract)
	draw_set_alpha(.2)
	draw_surface(darkenSurf,targetX - off,targetY - off)
	draw_set_alpha(1)
	gpu_set_blendmode(bm_normal)
	
	
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
