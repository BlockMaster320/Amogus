/// Function storing names of avatar head IDs.
function id_get_head(_id)
{
	static headArray = ["Amogus Classic", "Imposter", "Cursed Imposter", "Homer", "Chad", "Trollge"];
	return headArray[_id];
}

/// Function storing names of avatar named IDs.
function id_get_name(_id)
{
	static nameArray = ["Ondra", "Q-ba", "Jahim", "Katt", "OkMan", "A Adam", "Vojta", "Tomas","Johi"];
	return nameArray[_id];
}

function get_pitch_lick(_index)
{
	var _pitchArray = [1, 1.125, 1.185, 1.3, 1.125, 0.888, 1];
	return _pitchArray[_index];
}
