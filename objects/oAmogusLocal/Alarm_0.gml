if (obj_GameManager.inGame)
{
	if (obj_GameManager.serverSide)
	{
		var _serverBuffer = obj_Server.serverBuffer;
		message_position(_serverBuffer, clientId, x, y);
		with (obj_AmogusClient)
			network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
	}
	
	else
	{
		var _clientBuffer = obj_Client.clientBuffer;
		message_position(_clientBuffer, clientId, x, y);
		network_send_packet(obj_Client.client, _clientBuffer, buffer_tell(_clientBuffer));
	}
}
alarm[0] = POSITION_UPDATE;
