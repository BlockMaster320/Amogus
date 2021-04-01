//Get Network Message Properties
var _type = async_load[? "type"];
var _id = async_load[? "id"];

//Handle the Network Message
switch (_type)
{
	case network_type_connect:
	{
		//Get Connected Client's Data
		var _socket = async_load[? "socket"];
		var _clientId = clientIdCount ++;
		var _amogusClient = instance_create_layer(0, 0, "Amogus", obj_AmogusClient);
		with (_amogusClient)
		{
			clientSocket = _socket;
			clientId = _clientId;
		}
		clientMap[? _socket] = _amogusClient;
		clientIdMap[? _clientId] = _amogusClient;
		
		//Send Connected Client Its clientId
		buffer_seek(serverBuffer, buffer_seek_start, 0);
		buffer_write(serverBuffer, buffer_u8, messages.connect);
		buffer_write(serverBuffer, buffer_u8, _clientId);
		network_send_packet(_socket, serverBuffer, buffer_tell(serverBuffer));
		
		//Send Message to Create all the Amoguses on the Connected Client's Side
		with (obj_Amogus)
		{
			if (clientSocket != _socket)
			{
				message_amogus_create(other.serverBuffer, clientId, username, headId, bodyId);
				network_send_packet(_socket, other.serverBuffer, buffer_tell(other.serverBuffer));
			}
		}
	}
	break;
	
	case network_type_disconnect:	//disconnect a client in case of closing the game not using the in-game quit button
	{
		var _socket = async_load[? "socket"];
		ds_map_delete(clientMap, _socket);
	}
	break;

	case network_type_data:
	{
		var _buffer = async_load[? "buffer"];
		message_receive_server(_id, _buffer);
	}
	break;
}
