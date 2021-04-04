//Set the Interactable Struct
if (interactableStruct == noone)
{
	if (type = interactable.vent) global.ventPositions[array_length(global.ventPositions)] = [x,y]
	interactableStruct = new Interactable(type);
}
