//Create a Server
server = network_create_server(network_socket_tcp, 6510, 10);
if (server < 0) show_message("Failed to create a server.");

//Create a Server Buffer
serverBuffer = buffer_create(256, buffer_grow, 1);

//Create a Map of Clients
clientIdCount = 0;
clientMap = ds_map_create();
