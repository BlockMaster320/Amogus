//Pre draw
if (window_get_width() != 0)
{
	global.monitorW = window_get_width()
	global.monitorH = window_get_height()
}
Xoffset = 0
Yoffset = 0
surface_resize(application_surface,global.monitorW,global.monitorH)