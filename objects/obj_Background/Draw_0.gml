//Drwa the Game Background
if (obj_GameManager.inGame)
{
	if (!surface_exists(surfaceSpace)) 
		surfaceSpace = surface_create(guiW, guiH);
	
	surface_set_target(surfaceSpace);
	draw_clear_alpha(c_black, 0);
	draw_sprite(spr_Space, 0, 0, 0);
	draw_sprite(spr_Space, 0, sprite_get_width(spr_Space), 0);
	surface_reset_target();
	draw_surface(surfaceSpace, oAmogusLocal.camX,  oAmogusLocal.camY);
}
