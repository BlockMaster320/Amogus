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
}