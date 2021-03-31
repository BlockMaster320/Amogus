
function id_get_avatar(_id)
{
	static Red =
	{
		name : "Amogus Red",
		body : 0
	};

	static Blue =
	{
		name : "Amogus Blue",
		body : 1
	};

	static Green =
	{
		name : "Amogus Green",
		body : 2
	};
	
	switch (_id)
	{
		case 0:
			return Red;
			break;
		case 1:
			return Blue;
			break;
		case 2:
			return Green;
			break;
	}
}
