function message_amogus_create(_buffer, _clientId, _username)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.amogusCreate);
	buffer_write(_buffer, buffer_u8, _clientId);
	buffer_write(_buffer, buffer_string, _username);
}

function message_game_start(_buffer, _impostorId)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.gameStart);
	buffer_write(_buffer, buffer_u8, _impostorId);
}

function message_position(_buffer, _clientId, _x, _y)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.position);
	buffer_write(_buffer, buffer_u8, _clientId);
	buffer_write(_buffer, buffer_u16, _x);
	buffer_write(_buffer, buffer_u16, _y);
}

/*
function message_connect(_buffer, _clientId, _username)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.amogusCreate);
	buffer_write(_buffer, buffer_u8, _clientId);
	buffer_write(_buffer, buffer_string, _username);
}*/
