function MovementInput()	{
	if (keyboard_check_pressed(ord("R"))) game_restart()
	if (keyboard_check_pressed(vk_escape)) game_end()

	left = keyboard_check(ord("A")) or keyboard_check(vk_left)
	right = keyboard_check(ord("D")) or keyboard_check(vk_right)
	down = keyboard_check(ord("S")) or keyboard_check(vk_down)
	up = keyboard_check(ord("W")) or keyboard_check(vk_up)
}

function UIinput()	{
	mX = mouse_x
	mY = mouse_y
	LMBpress = mouse_check_button_pressed(mb_left)
	LMBrelease = mouse_check_button_released(mb_left)
	LMB = mouse_check_button(mb_left)
}