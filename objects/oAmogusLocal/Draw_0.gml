//Draw Amogus
if (obj_GameManager.inGame)
{
	/*draw_text_transformed_colour(100, 100, username, 1, 1, 0, c_white, c_white, c_white, c_white, 1);*/
	
	#region Light
	if (!surface_exists(lightSurf)) lightSurf = surface_create(guiW + off*2,guiH + off*2)
	if (!surface_exists(darkenSurf)) darkenSurf = surface_create(guiW + off*2,guiH + off*2)
	
	/*var realX = x
	var realY = y
	x = mouse_x
	y = mouse_y*/
	
	var surfOffX = targetX - off
	var surfOffY = targetY - off
	
	surface_set_target(lightSurf)
		draw_clear_alpha(c_black,0)
		
		//draw_circle_color(x-targetX,y-targetY,100,c_grey,c_black,0)
		draw_sprite(sLight,0,x-surfOffX,y-surfOffY)
		
		#region Shadows
		draw_set_color(c_white)
		gpu_set_blendmode(bm_subtract)
		for (var i = -7; i < 7; i++)
		{
		    for (var j = -6; j < 6; j++)
			{
				var plX = x - targetX + off
				var plY = y - targetY + off
				var xx = x + (i * TL_SIZE)
				var yy = y + (j * TL_SIZE)
				xx -= (xx % TL_SIZE) //- (TL_SIZE / 2)	//Odsazené = vlevo nahoře tilu
				yy -= (yy % TL_SIZE) //- (TL_SIZE / 2)	//Neodsazené = center
				if (tilemap_get_at_pixel(tilemap,xx,yy))
				{
					xx -= targetX - off
					yy -= targetY - off
					//draw_circle(xx,yy,5,0)
					var tile = TL_SIZE
					
					var bbLeft = xx
					var bbRight = xx + tile
					var bbTop = yy
					var bbBott = yy + tile
					var shadowLength = (guiW - point_distance(xx,yy,bbLeft+8,bbRight+8)) * .7
					var x2 = bbLeft +	lengthdir_x(shadowLength,point_direction(plX,plY,bbLeft,bbTop))
					var y2 = bbTop +	lengthdir_y(shadowLength,point_direction(plX,plY,bbLeft,bbTop))
					var x3 = bbRight +	lengthdir_x(shadowLength,point_direction(plX,plY,bbRight,bbBott))
					var y3 = bbBott +	lengthdir_y(shadowLength,point_direction(plX,plY,bbRight,bbBott))
													
					var x4 = bbRight +	lengthdir_x(shadowLength,point_direction(plX,plY,bbRight,bbTop))
					var y4 = bbTop +	lengthdir_y(shadowLength,point_direction(plX,plY,bbRight,bbTop))
					var x5 = bbLeft +	lengthdir_x(shadowLength,point_direction(plX,plY,bbLeft,bbBott))
					var y5 = bbBott +	lengthdir_y(shadowLength,point_direction(plX,plY,bbLeft,bbBott))
					
					draw_primitive_begin(pr_trianglefan)
					draw_vertex(bbLeft,bbTop)
					draw_vertex(x2,y2)
					draw_vertex(x3,y3)
					draw_vertex(bbRight,bbBott)
					
					draw_vertex(bbRight,bbTop)
					draw_vertex(x4,y4)
					draw_vertex(x5,y5)
					draw_vertex(bbLeft,bbBott)
					draw_primitive_end()
				}
			}
		}
		#endregion
	surface_reset_target()
	
	
	/*gpu_set_blendmode(bm_add)
	draw_surface(lightSurf,targetX,targetY)
	gpu_set_blendmode(bm_normal)*/
	
	gpu_set_blendmode(bm_add)
	draw_set_alpha(0.4)
	draw_surface(lightSurf,targetX-off,targetY-off)
	draw_set_alpha(1)
	//gpu_set_blendmode(bm_normal)
	
	surface_set_target(lightSurf)
	//draw_clear()
	gpu_set_blendmode_ext(bm_dest_color, bm_inv_src_alpha)
	//gpu_set_blendmode_ext(bm_dest_alpha,bm_inv_src_alpha)
	//shader_set(shAlphaDist)
	var tX = targetX
	var tY = targetY
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_font(fntName)
	draw_set_colour(c_red);
	var _spriteHeight = sprite_get_height(sAmogus);
	/*gpu_set_tex_filter(true)*/
	with (obj_AmogusClient)
	{
		//shader_set_uniform_f(other.u_dist,point_distance(x,y,other.x,other.y))
		draw_sprite(sAmogus,image_index,x-tX + off,y-tY + off)
		gpu_set_tex_filter(true)
		draw_text_transformed(x - tX + off, y - tY + off - _spriteHeight * 0.5 - 5, username, 0.2, 0.2, 0);
		gpu_set_tex_filter(!true)
	}
	//shader_reset()
	gpu_set_blendmode(bm_normal)
	surface_reset_target()
	
	shader_set(shAlpha)
	draw_surface(lightSurf,targetX-off,targetY-off)
	shader_reset()
	
	
	/*x = realX
	y = realY*/
	#endregion
}
