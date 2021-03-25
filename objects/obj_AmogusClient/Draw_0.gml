//Draw Amogus
if (obj_GameManager.inGame)
{
	draw_self();
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	var _spriteHeight = sprite_get_height(sAmogus);
	draw_text_transformed_colour(x, y - _spriteHeight * 0.5 - 10, username, 1, 1, 0, c_white, c_white, c_white, c_white, 1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}
