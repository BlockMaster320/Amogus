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
	kill,
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

enum warningType
{
	meeting,
	body
}

#macro CURSOR_BLINK_SPEED 25
#macro TRANSITION_SPEED 0.014
#macro WARNING_SPEED 0.012
#macro NAME_NUMBER 8
enum NAME
{
	Ondra,
	Kuba,
	Jahim,
	Katt,
	OkMan,
	Adam,
	Vojta,
	Tom
}

//Amogus
#macro TL_SIZE 16
#macro windowToGui window_get_width() / guiW
#macro guiToWindow guiW / window_get_width()
#macro KILL_RANGE 50

//Interactable
enum interactable
{
	emergencyButton,
	camera,
	lights,
	wires,
	vent,
	shooter,
	sliderCatch,
	body
}
