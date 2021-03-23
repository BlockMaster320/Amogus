//Create a Client && Connect It to the Server
client = network_create_socket(network_socket_tcp);
var _connection = network_connect(client, "127.0.0.1", 6510);
if (_connection < 0) show_message("Connection failed.");

//Create a Client Buffer
clientBuffer = buffer_create(256, buffer_grow, 1);

//Create a Map of Clients
clientMap = ds_map_create();
