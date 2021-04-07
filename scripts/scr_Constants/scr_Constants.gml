//Networking
enum messages	//values representing types of network messages
{
	connect,
	amogusCreate,
	amogusAlpha,
	gameStart,
	gameEnd,
	gameMeeting,
	vote,
	throwOut,
	kill,
	taskProgress,
	lights,
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
	body,
	class
}

#macro CURSOR_BLINK_SPEED 25
#macro TRANSITION_SPEED 0.014
#macro WARNING_SPEED 0.012
#macro NAME_NUMBER 9

enum NAME
{
	Ondra,
	Kuba,
	Jahim,
	Katt,
	OkMan,
	Adam,
	Vojta,
	Tom,
	Johi
}

//Amogus
#macro TL_SIZE 16
#macro windowToGui window_get_width() / guiW
#macro guiToWindow guiW / window_get_width()
#macro KILL_RANGE 50
#macro TASKS_PER_AMOGUS 5

//Interactable
enum interactable
{
	shooter,			//Tasks
	sliderCatch,
	simonSays,
	wires,
	sliderWait,
	emergencyButton,	//Non tasks
	body,
	camera,
	lights,				//Impostrorr
	vent
}
