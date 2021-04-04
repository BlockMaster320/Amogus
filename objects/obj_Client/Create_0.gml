//Create a Client && Connect It to the Server
client = network_create_socket(network_socket_tcp);
var _serverIp = obj_Menu.textFieldArray[1];
var _connection = network_connect(client, _serverIp, 6510);
if (_connection < 0) show_message("Connection failed.");

//Create a Client Buffer
clientBuffer = buffer_create(256, buffer_grow, 1);

//Create a Map of Clients
clientMap = ds_map_create();
clientIdMap = ds_map_create();
