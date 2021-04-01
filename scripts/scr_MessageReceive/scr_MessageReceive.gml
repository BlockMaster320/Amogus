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
			var _headId = buffer_read(_buffer, buffer_u8);
			var _bodyId = buffer_read(_buffer, buffer_u8);
			with(_amogusClient)
			{
				username = _username;
				headId = _headId;
				bodyId = _bodyId;
			}
				
			//Send Message to Create the Amogus on Other Clients' Sides
			message_amogus_create(serverBuffer, _amogusClient.clientId, _amogusClient.username, _amogusClient.headId, _amogusClient.bodyId);
			with (obj_AmogusClient)
			{
				if (clientSocket != _socket)
					network_send_packet(clientSocket, other.serverBuffer, buffer_tell(other.serverBuffer));
			}
		}
		break;
		
		case messages.gameMeeting:
		{
			//Send a Message to Start a Meeting to All Clients
			var _clientId = buffer_read(_buffer, buffer_u8);	//amogus who started the meetin - can be use later
			message_game_meeting(serverBuffer, _clientId);
			with (obj_AmogusClient)
				network_send_packet(clientSocket, other.serverBuffer, buffer_tell(other.serverBuffer));
			
			 transition(menu.meeting, noone, true);
		}
		break;
		
		case messages.vote:
		{
			var _voterId = buffer_read(_buffer, buffer_u8);
			var _votedId = buffer_read(_buffer, buffer_u8);
			
			//Set the Voter's hasVoted to true && Add the Voter to Voted's voteArray
			with (clientIdMap[? _voterId])
				hasVoted = true;
			with (clientIdMap[? _votedId])
				array_push(voteArray, _voterId);
			
			//Send the Message to All Amoguses
			message_vote(serverBuffer, _voterId, _votedId);
			with (obj_AmogusClient)
				network_send_packet(clientSocket, other.serverBuffer, buffer_tell(other.serverBuffer));
		}
		break;
		
		case messages.position:	//update position of amogus
		{
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
			
			//Send Message to Update Amogus's Position to All the Clients
			message_position(serverBuffer, _clientId, _x, _y);
			with (obj_AmogusClient)
			{
				if (clientSocket != _socket)
					network_send_packet(clientSocket, other.serverBuffer, buffer_tell(other.serverBuffer));
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
				headId = obj_Menu.selectedHeadId;
				bodyId = obj_Menu.selectedBodyId;
			}
			clientIdMap[? _clientId] = _amogusLocal;
			
			buffer_seek(clientBuffer, buffer_seek_start, 0);
			buffer_write(clientBuffer, buffer_u8, messages.connect);
			buffer_write(clientBuffer, buffer_string, _amogusLocal.username);
			buffer_write(clientBuffer, buffer_u8, _amogusLocal.headId);
			buffer_write(clientBuffer, buffer_u8, _amogusLocal.bodyId);
			network_send_packet(client, clientBuffer, buffer_tell(clientBuffer));
		}
		break;
		
		case messages.gameMeeting:	//start a meeting
		{
			warning(warningType.meeting);
			transition(menu.meeting, noone, true);
			var _clientId = buffer_read(_buffer, buffer_u8);	//amogus who started the meeting - can be use later
		}
		break;
		
		case messages.vote:
		{
			var _voterId = buffer_read(_buffer, buffer_u8);
			var _votedId = buffer_read(_buffer, buffer_u8);
			
			//Set the Voter's hasVoted to true && Add the Voter to Voted's voteArray
			with (clientIdMap[? _voterId])
				hasVoted = true;
			with (clientIdMap[? _votedId])
				array_push(voteArray, _voterId);
		}
		break;
		
		case messages.throwOut:	//throw out voted amogus
		{
			var _throwOutAmogusId = buffer_read(_buffer, buffer_s8);
			if (_throwOutAmogusId == noone)
				obj_Menu.thrownOutAmogus = noone;
			else
				obj_Menu.thrownOutAmogus = clientIdMap[? _throwOutAmogusId];
			transition(menu.throwOut, noone, false);
		}
		break;
		
		case messages.amogusCreate:	//create amogusClient
		{
			var _clientId = buffer_read(_buffer, buffer_u8);
			var _username = buffer_read(_buffer, buffer_string);
			var _headId = buffer_read(_buffer, buffer_u8);
			var _bodyId = buffer_read(_buffer, buffer_u8);
			
			var _amogusClient = instance_create_layer(0, 0, "Amogus", obj_AmogusClient);
			with (_amogusClient)
			{
				clientSocket = _socket;
				clientId = _clientId;
				username = _username;
				
				headId = _headId;
				bodyId = _bodyId;
			}
			clientMap[? _socket] = _amogusClient;
			clientIdMap[? _clientId] = _amogusClient;
		}
		break;
		
		case messages.gameStart:	//start the game
		{
			var _impostorId = buffer_read(_buffer, buffer_s8);
			var _continuation = buffer_read(_buffer, buffer_bool);
			
			if (!_continuation)
			{
				//Set the Impostor
				var _amogusImpostor = clientIdMap[? _impostorId];
				_amogusImpostor.isImpostor = true;
			
				//Start the Game
				var _transitionFunction = function() {obj_GameManager.inGame = true; room_goto(rm_Game);};
				transition(noone, _transitionFunction, true);
			}
			else
				transition(noone, noone, true);
			
			game_setup();
				
		}
		break;
		
		case messages.gameEnd:	//end the game
		{
			var _winnerSide = buffer_read(_buffer, buffer_bool);
			transition(menu.gameEnd, noone, true); 
			obj_Menu.winnerSide = _winnerSide;
		}
		break;
		
		case messages.position:
		{
			var _clientId = buffer_read(_buffer, buffer_u8);
			var _x = buffer_read(_buffer, buffer_u16);
			var _y = buffer_read(_buffer, buffer_u16);
			
			var _amogusClient = clientIdMap[? _clientId];
			if (is_undefined(_amogusClient))
				break;
			
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