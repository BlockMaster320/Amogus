//Set the Interactable Struct
if (interactableStruct == noone)
{
	interactableStruct = new Interactable(type);
	
	if (type = interactable.vent) global.ventPositions[array_length(global.ventPositions)] = [x,y]
	if (type = interactable.lights) array_push(global.lightPositions,self)
	/*if (type >= 0 and type <= 4) usable = true//irandom(1)
	if (usable) array_push(global.activeTasks,self)*/
}