function message_amogus_create(_buffer, _clientId, _nameId, _headId, _bodyId)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.amogusCreate);
	buffer_write(_buffer, buffer_u8, _clientId);
	/*buffer_write(_buffer, buffer_string, _username);*/
	buffer_write(_buffer, buffer_u8, _nameId);
	buffer_write(_buffer, buffer_u8, _headId);
	buffer_write(_buffer, buffer_u8, _bodyId);
}

function message_game_start(_buffer, _impostorId, _continuation)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.gameStart);
	buffer_write(_buffer, buffer_s8, _impostorId);
	buffer_write(_buffer, buffer_bool, _continuation);
}

function message_game_end(_buffer, _winnerSide)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.gameEnd);
	buffer_write(_buffer, buffer_bool, _winnerSide);	//0 - crewmates, 1 - impostors
}

function message_game_meeting(_buffer, _clientId, _isReport)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.gameMeeting);
	buffer_write(_buffer, buffer_u8, _clientId);
	buffer_write(_buffer, buffer_bool, _isReport);
}

function message_vote(_buffer, _voterId, _votedId)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.vote);
	buffer_write(_buffer, buffer_u8, _voterId);
	buffer_write(_buffer, buffer_u8, _votedId);
}

function message_throwOut(_buffer, thrownOutAmogusId)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.throwOut);
	buffer_write(_buffer, buffer_s8, thrownOutAmogusId);
}

function message_position(_buffer, _clientId, _x, _y)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.position);
	buffer_write(_buffer, buffer_u8, _clientId);
	buffer_write(_buffer, buffer_u16, _x);
	buffer_write(_buffer, buffer_u16, _y);
}

function message_kill(_buffer, _clientId, _interactableId)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.kill);
	buffer_write(_buffer, buffer_u8, _clientId);
	buffer_write(_buffer, buffer_u8, _interactableId);
}

function message_lights(_buffer, _clientId, _interactableId)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.kill);
	buffer_write(_buffer, buffer_u8, _clientId);
	buffer_write(_buffer, buffer_u8, _interactableId);
}

/*
function message_interactable_state(_buffer, _interactableId, _state)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.position);
	buffer_write(_buffer, buffer_u8, _interactableId);
	buffer_write(_buffer, buffer_bool, _state);	//0 - not occupied, 1 - occupied
}*/

/*
function message_connect(_buffer, _clientId, _username)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.amogusCreate);
	buffer_write(_buffer, buffer_u8, _clientId);
	buffer_write(_buffer, buffer_string, _username);
}*/
