//Menu State
menuState = menu.mainMenu;
menuStateTimer = 0;

selectedNameId = 0;
selectedHeadId = 0;
selectedBodyId = 0;

buttonIsSelected = false;

//Text Fields
charSet = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_-/.,&0123456789";
textField = noone;
textFieldArray = array_create(9, "");
textFieldArray[0] = "Lorem Ipsum";
textFieldArray[1] = "127.0.0.1";
textFieldPassiveArray = array_create(9, "");	//stores part of the string that's shown when the text field isn't activated
/*for (var _i = 0; _i < array_length(textFieldArray); _i ++)	//fill the textFileArray with empty strings
	textFieldArray[_i] = "";*/
textCursorPosition = 0;
textEdgeLeft = 0;	//counting from 0
textEdgeRight = 99;	//counting from 0; just some random larger number
textCursorIsVisible = true;
alarm[0] = CURSOR_BLINK_SPEED;	//alarm that makes the textCursor blink

//Game Settings
/*impostors = 1;*/

//Set Surfaces
surfaceText = noone;
surfaceUI = noone;

guiToUI = guiW / display_get_gui_width();

//Transition
transitionProgress = 0.5;
transitionClosing = false;
transitionMenu = menu.mainMenu;
transitionFunction = noone;

//Warning
warningProgress = 0;
warningType = noone;

//Meeting
thrownOutAmogus = noone;

//Game
spawnX = 550;
spawnY = 150;
winnerSide = noone;
