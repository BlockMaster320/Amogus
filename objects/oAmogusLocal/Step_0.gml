if (obj_GameManager.inGame)
{
	MovementInput()

	/*var move = (right - left != 0) or (up - down != 0)
	var dir = point_direction(0,0,right - left,down - up)		//NEFUN
	hsp = lengthdir_x(move * spd,dir)							//GUJE
	vsp = lengthdir_y(move * spd,dir)*/

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
	#endregion
}