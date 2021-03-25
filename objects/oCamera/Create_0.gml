#region Resize screen
//application_surface_draw_enable(false)
monitorW = window_get_width()
monitorH = window_get_height()
#endregion

#region Camera
x = 0
y = 0

cam = view_camera[0]

targetX = 0
targetY = 0

rW = room_width
rH = room_height

#macro guiW 320
#macro guiH 180

camera_set_view_size(cam,guiW,guiH)
#endregion