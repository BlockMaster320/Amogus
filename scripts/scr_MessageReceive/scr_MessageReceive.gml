/// Function handling a message from client.
function message_receive_server(_socket, _buffer)
{
	var _message = buffer_read(_buffer, buffer_u8);
	var _amogusClient = clientMap[? _socket];
	switch (_message)
	{
		case messages.connect:
		{
			var _username = buffer_read(_buffer, buffer_string);
			with(_amogusClient)
				username = _username;
				
			//Send Message to Create the Amogus on Other Clients' Sides
			message_amogus_create(serverBuffer, _amogusClient.clientId, _amogusClient.username);
			with (obj_AmogusClient)
			{
				if (clientSocket != _socket)
					network_send_packet(clientSocket, other.serverBuffer, buffer_tell(other.serverBuffer));
			}
		}
		break;
		
		case messages.position:	//update position of amogus
		{
			//Send Message to Update Amogus's Position to All the Clients
			with (obj_AmogusClient)
			{
				if (clientSocket != _socket)
					network_send_packet(clientSocket, serverBuffer, buffer_tell(serverBuffer));
			}
			
			//Update the Amogus's Local Position
			var _clientId = buffer_read(_buffer, buffer_u8);
			var _x = buffer_read(_buffer, buffer_u16);
			var _y = buffer_read(_buffer, buffer_u16);
			
			var _amogusClient = clientMap[?_clientId];
			with (_amogusClient)
			{
				originalX = x;
				originalY = y;
				targetX = _x;
				targetY = _y;
				positionUpdateTimer = 0;
			}
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
			var _amogusLocal = instance_create_layer(0, 0, "Amogus", oAmogusLocal);
			with (_amogusLocal)
			{
				clientId = _clientId;
				username = _username;
			}
			clientIdMap[? _clientId] = _amogusLocal;
			
			buffer_seek(clientBuffer, buffer_seek_start, 0);
			buffer_write(clientBuffer, buffer_u8, messages.connect);
			buffer_write(clientBuffer, buffer_string, _username);
			network_send_packet(client, clientBuffer, buffer_tell(clientBuffer));
		}
		break;
		
		case messages.amogusCreate:	//create amogusClient
		{
			var _clientId = buffer_read(_buffer, buffer_u8);
			var _username = buffer_read(_buffer, buffer_string);
			
			var _amogusClient = instance_create_layer(0, 0, "Amogus", obj_AmogusClient);
			with (_amogusClient)
			{
				clientSocket = _socket;
				clientId = _clientId;
				username = _username;
			}
			clientMap[? _socket] = _amogusClient;
			clientIdMap[? _clientId] = _amogusClient;
		}
		break;
		
		case messages.gameStart:	//start the game
		{
			//Set Up the Game
			obj_GameManager.inGame = true;
			obj_Menu.menuState = noone;
			room_goto(rm_Game);
			
			//Set the Impostor
			var _impostorId = buffer_read(_buffer, buffer_u8);
			show_debug_message(_impostorId);
			var _amogusImpostor = clientIdMap[? _impostorId];
			_amogusImpostor.isImpostor = true;
		}
		break;
		
		case messages.position:
		{
			var _clientId = buffer_read(_buffer, buffer_u8);
			var _x = buffer_read(_buffer, buffer_u16);
			var _y = buffer_read(_buffer, buffer_u16);
			
			var _amogusClient = clientMap[? _clientId];
			with (_amogusClient)
			{
				originalX = x;
				originalY = y;
				targetX = _x;
				targetY = _y;
				positionUpdateTimer = 0;
			}
		}
		break;
	}
}