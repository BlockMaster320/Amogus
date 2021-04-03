if (type == interactable.body)
{
	/*draw_sprite(sAmogus, 0, x - sprite_get_width(sAmogus) * 0.5, y - sprite_get_width(sAmogus) * 0.5);*/
	draw_sprite_ext(spr_Blood, 0, x + 11, y + 7, 1, 1, 0, c_white, 1); 
	draw_sprite_ext(spr_Body, interactableStruct.bodyId * 3, x, y, 1, 1, - 90, c_white, 1); 
	draw_sprite_ext(spr_Head, interactableStruct.headId, x, y, 1, 1, - 90, c_white, 1); 
}
	
else
{
	var _sprite = interactableStruct.sprite;
	draw_sprite(_sprite, 0, x - sprite_get_width(_sprite) * 0.5, y - sprite_get_width(_sprite) * 0.5);
}
