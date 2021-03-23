#region Camera
targetX = clamp(oAmogus.x - (guiW/2),0,rW - guiW)
targetY = clamp(oAmogus.y - (guiH/2),0,rH - guiH)
        
x = lerp(x,targetX,.15)
y = lerp(y,targetY,.15)

camera_set_view_pos(cam,x,y)
#endregion