//Interpolate Between Original && Target Position
x = lerp(originalX, targetX, positionUpdateTimer / POSITION_UPDATE);
y = lerp(originalY, targetY, positionUpdateTimer / POSITION_UPDATE);
positionUpdateTimer ++;
/*
if (positionUpdateTimer == 2)
	positionUpdateTimer = 0;*/
