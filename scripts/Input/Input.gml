function MovementInput(enabled)	{
	if (enabled)
	{
		left =	keyboard_check(ord("A")) or keyboard_check(vk_left)
		right = keyboard_check(ord("D")) or keyboard_check(vk_right)
		down =	keyboard_check(ord("S")) or keyboard_check(vk_down)
		up =	keyboard_check(ord("W")) or keyboard_check(vk_up)
	
		buttonInteract = keyboard_check_pressed(ord("E"));
	}
	else
	{
		left =	0
		right =	0
		down =	0
		up =	0
	
		buttonInteract = 0
	}
}

function UIinput(enabled)	{
	if (enabled)
	{
		mX = mouse_x
		mY = mouse_y
		LMBpress =		mouse_check_button_pressed(mb_left)
		LMBrelease =	mouse_check_button_released(mb_left)
		LMB =			mouse_check_button(mb_left)
	
		exitUI =		keyboard_check_pressed(ord("E")) or keyboard_check_pressed(vk_escape) or keyboard_check_pressed(vk_enter)
	}
	else
	{
		mX = 0
		mY = 0
		LMBpress = 0
		LMBrelease = 0
		LMB = 0
		exitUI = 0
	}
}