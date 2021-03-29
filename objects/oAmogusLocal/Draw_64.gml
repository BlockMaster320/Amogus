//Tasky ach jo
function movable()
{
	
}

if (interactableObject != noone)
{
	switch (interactableObject.type)
	{
		case interactable.emergencyButton:
		{
			//Send Message to Start a Meeting to All Clients
			if (obj_GameManager.serverSide)
			{
				var _serverBuffer = obj_Server.serverBuffer;
				message_game_meeting(_serverBuffer, clientId);
				with (obj_AmogusClient)
					network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
				
				transition(menu.meeting, noone, true);
			}
			
			//Send Message to Start a Meeting to the Server
			else if (obj_GameManager.serverSide == false)
			{
				var _clientBuffer = obj_Client.clientBuffer;
				message_game_meeting(_clientBuffer, clientId);
				network_send_packet(obj_Client.client, _clientBuffer, buffer_tell(_clientBuffer));
			}
			
			interactableObject = noone;
			interactableStruct = noone;
		}
		break;
	}
}