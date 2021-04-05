/// Function handling a message from client.
function message_receive_server(_socket, _buffer)
{
	var _message = buffer_read(_buffer, buffer_u8);
	var _amogusClient = clientMap[? _socket];
	switch (_message)
	{
		case messages.connect:
		{
			var _nameId = buffer_read(_buffer, buffer_u8);
			var _headId = buffer_read(_buffer, buffer_u8);
			var _bodyId = buffer_read(_buffer, buffer_u8);
			with(_amogusClient)
			{
				nameId = _nameId;
				headId = _headId;
				bodyId = _bodyId;
			}
				
			//Send Message to Create the Amogus on Other Clients' Sides
			message_amogus_create(serverBuffer, _amogusClient.clientId, _amogusClient.nameId, _amogusClient.headId, _amogusClient.bodyId);
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
			var _clientId = buffer_read(_buffer, buffer_u8);	//amogus who started the meeting - used later
			var _isReport = buffer_read(_buffer, buffer_u8);
			message_game_meeting(serverBuffer, _clientId, _isReport);
			with (obj_AmogusClient)
				network_send_packet(clientSocket, other.serverBuffer, buffer_tell(other.serverBuffer));
			
			if (_isReport) warning(warningType.body, 1);
			else warning(warningType.meeting, 1);
			transition(menu.meeting, noone, true);
			obj_Menu.caller = clientIdMap[? _clientId].nameId
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
		
		case messages.kill:	//kill an amogus
		{
			var _clientId = buffer_read(_buffer, buffer_u8);
			var _amogus = clientIdMap[?_clientId];
			
			var _interactableId = obj_GameManager.interactableIdCount ++;
			message_kill(serverBuffer, _clientId, _interactableId)
			with (obj_AmogusClient)
				network_send_packet(clientSocket, other.serverBuffer, buffer_tell(other.serverBuffer));
							
			_amogus.isAlive = false;
			var _body = instance_create_layer(_amogus.x, _amogus.y, "Interactables", obj_Interactable);
			with (_body)
			{
				type = interactable.body;
				interactableId = _interactableId;
				interactableStruct = new Interactable(interactable.body);
				interactableStruct.clientId = _amogus.clientId;
				interactableStruct.headId = _amogus.headId;
				interactableStruct.bodyId = _amogus.bodyId;
			}
			
			check_game_end();	//check for game end
			
			var impostorName
			with (obj_AmogusClient)
			{
				if (isImpostor) impostorName = nameId
			}
			if (_amogus.clientId == oAmogusLocal.clientId) Died(impostorName)
		}
		break;
		
		case messages.amogusAlpha:	//change amogus's alpha
		{
			var _clientId = buffer_read(_buffer, buffer_u8);
			var _alpha = buffer_read(_buffer, buffer_u8);
			
			message_amogus_alpha(serverBuffer, _clientId, _alpha);
			with (obj_AmogusClient)
				network_send_packet(clientSocket, other.serverBuffer, buffer_tell(other.serverBuffer));
			
			var _amogusClient = clientIdMap[? _clientId];
			_amogusClient.playerAlpha = _alpha;
		}
		break;
		
		case messages.taskProgress:	//change the taks progress
		{
			var _taskProgress = buffer_read(_buffer, buffer_s8);
			obj_Menu.taskProgress += _taskProgress;
			
			message_task_progress(serverBuffer, _taskProgress);
			with (obj_AmogusClient)
				network_send_packet(clientSocket, other.serverBuffer, buffer_tell(other.serverBuffer));
			
			check_game_end();	//check for game end
		}
		break;
		
		case messages.lights:	//change the light switches
		{
			var _i = buffer_read(_buffer, buffer_u8);
			var _j = buffer_read(_buffer, buffer_u8);
			
			/*show_debug_message("kekk");*/
			message_lights(serverBuffer, _i, _j);
			with (obj_AmogusClient)
			{
				network_send_packet(clientSocket, other.serverBuffer, buffer_tell(other.serverBuffer));
				/*show_debug_message(clientSocket);*/
			}
			
			var _lightsOn = true;
			with (obj_Interactable)
			{
				if (type == interactable.lights)
				{
					var rowCount = interactableStruct.rowCount;
					var collCount = interactableStruct.collCount;
					interactableStruct.switchPositions[_i, _j] = !interactableStruct.switchPositions[_i, _j];
					for (var i = 0; i < rowCount; i++)
					{
						for (var j = 0; j < collCount; j++)
						{
							if (interactableStruct.switchPositions[i, j])
								_lightsOn = false;
						}
					}
				}
			}
			global.lightsOn = _lightsOn;
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
			var _amogusLocal = instance_create_layer(0, 0, "Amogus", oAmogusLocal);
			with (_amogusLocal)
			{
				clientId = _clientId;
				nameId = obj_Menu.selectedNameId;
				headId = obj_Menu.selectedHeadId;
				bodyId = obj_Menu.selectedBodyId;
			}
			clientIdMap[? _clientId] = _amogusLocal;
			
			buffer_seek(clientBuffer, buffer_seek_start, 0);
			buffer_write(clientBuffer, buffer_u8, messages.connect);
			buffer_write(clientBuffer, buffer_u8, _amogusLocal.nameId);
			buffer_write(clientBuffer, buffer_u8, _amogusLocal.headId);
			buffer_write(clientBuffer, buffer_u8, _amogusLocal.bodyId);
			network_send_packet(client, clientBuffer, buffer_tell(clientBuffer));
		}
		break;
		
		case messages.gameMeeting:	//start a meeting
		{
			var _clientId = buffer_read(_buffer, buffer_u8);	//amogus who started the meeting - used later
			var _isReport = buffer_read(_buffer, buffer_u8);
			
			if (_isReport) warning(warningType.body, 1);
			else warning(warningType.meeting, 1);
			transition(menu.meeting, noone, true);
			
			obj_Menu.caller = clientIdMap[? _clientId].nameId
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
		
		case messages.kill:
		{
			var _clientId = buffer_read(_buffer, buffer_u8);
			var _interactableId = buffer_read(_buffer, buffer_u8);
			var _amogus = clientIdMap[?_clientId];
							
			_amogus.isAlive = false;
			var _body = instance_create_layer(_amogus.x, _amogus.y, "Interactables", obj_Interactable);
			with (_body)
			{
				type = interactable.body;
				interactableId = _interactableId;
				interactableStruct = new Interactable(interactable.body);
				interactableStruct.clientId = _amogus.clientId;
				interactableStruct.headId = _amogus.headId;
				interactableStruct.bodyId = _amogus.bodyId;
			}
			
			var impostorName
			with (obj_AmogusClient)
			{
				if (isImpostor) impostorName = nameId
			}
			//show_debug_message(amogusclient)
			//if (_amogus == oAmogusLocal) Died(impostorName)
			if (_amogus.clientId == oAmogusLocal.clientId) Died(impostorName)
		}
		break;
		
		case messages.lights:	//change the light switches
		{
			var _i = buffer_read(_buffer, buffer_u8);
			var _j = buffer_read(_buffer, buffer_u8);
			/*show_debug_message("yop");*/
			var _lightsOn = true;
			with (obj_Interactable)
			{
				if (type == interactable.lights)
				{
					var rowCount = interactableStruct.rowCount;
					var collCount = interactableStruct.collCount;
					interactableStruct.switchPositions[_i, _j] = !interactableStruct.switchPositions[_i, _j];
					for (var i = 0; i < rowCount; i++)
					{
						for (var j = 0; j < collCount; j++)
						{
							if (interactableStruct.switchPositions[i, j])
								_lightsOn = false;
						}
					}
				}
			}
			global.lightsOn = _lightsOn;
		}
		break;
		
		case messages.amogusCreate:	//create amogusClient
		{
			var _clientId = buffer_read(_buffer, buffer_u8);
			var _nameId = buffer_read(_buffer, buffer_u8);
			var _headId = buffer_read(_buffer, buffer_u8);
			var _bodyId = buffer_read(_buffer, buffer_u8);
			
			var _amogusClient = instance_create_layer(0, 0, "Amogus", obj_AmogusClient);
			with (_amogusClient)
			{
				clientSocket = _socket;
				clientId = _clientId;
				nameId = _nameId;
				
				headId = _headId;
				bodyId = _bodyId;
			}
			clientMap[? _socket] = _amogusClient;
			clientIdMap[? _clientId] = _amogusClient;
		}
		break;
		
		case messages.amogusAlpha:	//change amogus's alpha
		{
			var _clientId = buffer_read(_buffer, buffer_u8);
			var _alpha = buffer_read(_buffer, buffer_u8);
			
			var _amogusClient = clientIdMap[? _clientId];
			_amogusClient.playerAlpha = _alpha;
		}
		break;
		
		case messages.taskProgress:	//change the taks progress
		{
			var _taskProgress = buffer_read(_buffer, buffer_s8);
			obj_Menu.taskProgress += _taskProgress;
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
			
			obj_Menu.tasksNeeded = ds_map_size(clientIdMap) * TASKS_PER_AMOGUS;
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