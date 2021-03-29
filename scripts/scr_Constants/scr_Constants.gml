//Networking
enum messages	//values representing types of network messages
{
	connect,
	amogusCreate,
	gameStart,
	gameEnd,
	gameMeeting,
	vote,
	throwOut,
	position
}
#macro POSITION_UPDATE 3

//Menu
enum menu
{
	mainMenu,
	lobby,
	meeting,
	throwOut,
	gameEnd
}

enum buttonType
{
	menu,
	vote
}

#macro CURSOR_BLINK_SPEED 25
#macro TRANSITION_SPEED 0.014

//Amogus
#macro TL_SIZE 16

//Interactable
enum interactable
{
	emergencyButton,
	taskSUSUSS
}
