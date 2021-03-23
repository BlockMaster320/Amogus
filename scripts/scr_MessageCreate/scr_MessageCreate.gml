function message_amogus_create(_buffer, _clientId, _username)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.amogusCreate);
	buffer_write(_buffer, buffer_u8, _clientId);
	buffer_write(_buffer, buffer_string, _username);
}

/*
function message_connect(_buffer, _clientId, _username)
{
	buffer_seek(_buffer, buffer_seek_start, 0);
	buffer_write(_buffer, buffer_u8, messages.amogusCreate);
	buffer_write(_buffer, buffer_u8, _clientId);
	buffer_write(_buffer, buffer_string, _username);
}*/