if (obj_GameManager.inGame)
{
	draw_self()

	surface_set_target(darkenSurf)
		draw_clear(c_white)
		draw_circle_color(x-targetX+off,y-targetY+off,150,c_black,c_white,0)
	surface_reset_target()
	gpu_set_blendmode(bm_subtract)
	draw_set_alpha(.2)
	draw_surface(darkenSurf,targetX - off,targetY - off)
	draw_set_alpha(1)
	gpu_set_blendmode(bm_normal)
	
	//Names
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_font(fntName)
	var _spriteHeight = sprite_get_height(sAmogus);
	gpu_set_tex_filter(true)
	//usernam = "RekŠrek"
	draw_text_transformed(x, y - _spriteHeight * 0.5 - 5, username, 0.2, 0.2, 0);
	gpu_set_tex_filter(false)
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	//Draw Interaction Text
	if (interactableInRange != noone)
	{
		draw_set_halign(fa_center);
		draw_set_font(fntName)
		var _spriteHeight = sprite_get_height(spr_ButtonTest);
		draw_text_transformed_colour(interactableInRange.x, interactableInRange.y + _spriteHeight * 0.5 + 10,
									 "Press E to interact", 0.2, 0.2, 0, c_white, c_white, c_white, c_white, 1);
		draw_set_valign(fa_top);
	}
}
