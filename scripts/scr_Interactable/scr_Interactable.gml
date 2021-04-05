function Interactable(_type) constructor
{
	type = _type;
	/*sprite = spr_ButtonTest;*/
	distance = 30;
	switch (_type)
	{
		case interactable.lights:
		{
			var xOff = 40
			var yOff = 30
			rowCount = 3
			collCount = 2
			clickOffset = 5
			for (var i = rowCount-1; i >= 0; i--)
			{
				for (var j = collCount-1; j >= 0; j--)
				{
					switchPositions[i,j] = false	//x, y, active
				}
			}
		}
		break
		
		case interactable.wires:
		{
			var xOff = 50
			var yOff = 15
			wireCount = irandom_range(2,6)	//+1
			wireRadius = 4
			for (var i = wireCount; i > -1; i--)
			{
			    wirePositions[i] = [-xOff,(yOff * i) - (yOff * wireCount / 2),i,false]	//x, y, id, active
			    goalPositions[i] = [xOff,(yOff * i) - (yOff * wireCount / 2),i]
			}
			selectedWire = noone
			selectedWireID = noone
			completedWires = 0
			
			//Reorder goals
			var iterations = 20
			for (var i = 0; i < iterations; i++)
			{
				var source = irandom_range(0,wireCount)
				var goal = irandom_range(0,wireCount)
				var sourcePosX = goalPositions[source][0]
				var sourcePosY = goalPositions[source][1]
				goalPositions[source][0] = goalPositions[goal][0]
				goalPositions[source][1] = goalPositions[goal][1]
				goalPositions[goal][0] = sourcePosX
				goalPositions[goal][1] = sourcePosY
			}
			//show_debug_message(wirePositions)
		}
		break;
		
		case interactable.shooter:
		{
			xRandomRange = 50
			yRandomRange = 30
			targetPositionX = irandom_range(-50,50)
			targetPositionY = irandom_range(-30,30)
			resetCooldownDef = 30
			resetCooldown = resetCooldownDef
			succesfulShots = 0
			minimumShots = irandom_range(6,15)
		}
		break
		
		case interactable.sliderCatch:
		{
			yOff = 20
			sliderCount = irandom_range(2,6)
			//sliderLength = 160
			sliderLengthCrop = 110
			activeSliderId = 0
			for (var i = sliderCount-1; i >= 0; i--)
			{
				var yy = (yOff * i) - (yOff * (sliderCount - 1) / 2)
				var startX = choose(-sliderLengthCrop / 2,sliderLengthCrop / 2)
			    sliderPositions[i] = [0,yy]	//x, y
				handlePositions[i] = [startX,yy,false,irandom_range(1,4) * -sign(startX)]	//x, y, completed, speed
				targetPositions[i] = [irandom_range(-startX * 0.7,startX * 0.5),yy,random_range(4,7)]	//x, y, sizeX
			}
		}
		break
		
		case interactable.simonSays:
		{
			buttonColumns = 3;
			buttonNumber = 7;
			buttonOrderArray = [];
			for (var _i = 0; _i < buttonNumber; _i ++)
				buttonOrderArray[_i] = irandom_range(0, sqr(buttonColumns) - 1);
			
			progress = 0;
			state = 0;	//0 - button show, 1 - button clicking, 2 - wrong button signal
			showTime = 25;
			timer = showTime;
			
			clickIndex = 0;
			showIndex = 0;
		}
		break;
		
		case interactable.body:
		{
			clientId = noone;
			headId = 0;
			bodyId = 0;
		}
		break;
	}
}
