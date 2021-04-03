function Interactable(_type) constructor
{
	type = _type;
	sprite = spr_ButtonTest;
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
					switchPositions[i,j] = [(xOff * j) - (xOff * collCount / 2), (yOff * i) - (yOff * rowCount / 2), false]	//x, y, active
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
		
		case interactable.vent:
		{
			//ventPositions
		}
		break
		
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
			sliderLength = 160
			for (var i = sliderCount-1; i >= 0; i--)
			{
			    sliderPositions[i] = [0,(yOff * i) - (yOff * (sliderCount - 1) / 2),false]	//x, y, active
				handlePositions[i] = [choose(-sliderLength / 2,sliderLength / 2),(yOff * i) - (yOff * (sliderCount - 1) / 2),false]
			}
		}
		break
	}
}