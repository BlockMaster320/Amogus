if (camState = CAMERA.onCam)
{
	shader_set(shOnCam)
	draw_surface_ext(application_surface,0,0,1,1,0,c_white,1);
	shader_reset()
}
else draw_surface_ext(application_surface,0,0,1,1,0,c_white,1);

