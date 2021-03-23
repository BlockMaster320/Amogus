/// Function handling a message from client.
function message_receive_server(_socket, _buffer)
{
	var _message = buffer_read(_buffer, buffer_u8);
	var _amogusClient = clientMap[? _socket];
	switch (_message)
	{
		case messages.connect:
		{
			
			
		}
		
		case messages.position:
		{
			
			
		}
		break;
	}
}

/// Function handling a message from server.
function message_receive_client(_socket, _buffer)
{
	var _message = buffer_read(_buffer, buffer_u8);
	switch (_message)
	{
		case messages.connect:
		{
			var _clientId = buffer_read(_buffer, buffer_u8);
			var _username = obj_Menu.textFieldArray[0];
			var _amogusLocal = instance_create_layer(0, 0, "Amogus", obj_AmogusLocal);
			with (_amogusLocal)
			{
				clientId = _clientId;
				username = _username;
			}
			
			buffer_seek(clientBuffer, buffer_seek_start, 0);
			buffer_write(clientBuffer, buffer_u8, messages.connect);
			buffer_write(clientBuffer, buffer_string, _username);
			network_send_packet(client, clientBuffer, buffer_tell(clientBuffer));
		}
		break;
		
		case messages.position:
		{
			
			
		}
		break;
	}
}