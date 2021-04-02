function Interactable(_type) constructor
{
	type = _type;
	sprite = spr_ButtonTest;
	distance = 30;
	switch (_type)
	{
		case interactable.wires:
		{
			xOff = 50
			yOff = 15
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
	}
}