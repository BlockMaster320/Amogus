var _taskArray = [];
with (obj_Interactable)
	if (type < 5) array_push(_taskArray, self);
	
repeat (TASKS_PER_AMOGUS)
{
	var _index =  irandom_range(0, array_length(_taskArray) - 1);
	var _task = _taskArray[_index];
	with (_task)
	{
		usable = true;
		array_push(global.activeTasks, self);
	}
	array_delete(_taskArray, _index, 1);
}