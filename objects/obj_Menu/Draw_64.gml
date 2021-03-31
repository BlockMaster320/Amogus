//Set Draw Properties
draw_set_font(fnt_Menu);
var _guiWidth = display_get_gui_width();
var _guiHeight = display_get_gui_height();

//Set Button Size
var _buttonWidth = 150;
var _buttonHeight = 45;
var _buttonSpacing = 0;

switch (menuState)
{
	case menu.mainMenu:
	{
		//Draw Menu Text Fields && Buttons
		var _buttonX = _guiWidth * 0.5 - _buttonWidth * 0.5;
		var _buttonY = _guiHeight * 0.5;
		
		//Username Text Field
		draw_set_halign(fa_center);
		draw_set_valign(fa_bottom);
		draw_text_transformed_colour(_guiWidth * 0.5, _buttonY, "Username", 1, 1, 0, c_white, c_white, c_white, c_white, 1);
		text_field(_buttonX, _buttonY, _buttonWidth, _buttonHeight, true, 0);
		_buttonSpacing += _buttonHeight + 35;

		//Join an Existing Server
		draw_set_halign(fa_center);
		draw_set_valign(fa_bottom);
		draw_text_transformed_colour(_guiWidth * 0.5, _buttonY + _buttonSpacing * 1, "IP Adress", 1, 1, 0, c_white, c_white, c_white, c_white, 1);
		text_field(_buttonX, _buttonY + _buttonSpacing, _buttonWidth, _buttonHeight, true, 1);
		_buttonSpacing += _buttonHeight + 10;
		if (button(_buttonX, _buttonY + _buttonSpacing, _buttonWidth, _buttonHeight, "Join Game", buttonType.menu, true))
		{
			instance_create_layer(0, 0, "Managers", obj_Client);
			obj_GameManager.serverSide = false;
			transition(menu.lobby, noone, true);
		}
		
		//Create a Server
		_buttonSpacing += _buttonHeight + 30;
		if (button(_buttonX, _buttonY + _buttonSpacing, _buttonWidth, _buttonHeight, "Create Game", buttonType.menu, true))
		{
			instance_create_layer(0, 0, "Managers", obj_Server);
			obj_GameManager.serverSide = true;
			transition(menu.lobby, noone, true);
			
			var _amogusLocal = instance_create_layer(0, 0, "Amogus", oAmogusLocal);
			with (_amogusLocal)
			{
				clientId = obj_Server.clientIdCount ++;
				username = other.textFieldArray[0];
			}
			obj_Server.clientIdMap[? _amogusLocal.clientId] = _amogusLocal;
		}
	}
	break;
	
	case menu.lobby:
	{
		//Draw Amoguses Info Table
		draw_amogus_table(_guiWidth * 0.5, 100, false);
		
		//Draw Start the Game Button
		var _buttonX = _guiWidth * 0.5 - _buttonWidth * 0.5;
		var _buttonY = _guiHeight * 0.65;
		var _isAbled = obj_GameManager.serverSide;
		if (button(_buttonX, _buttonY, _buttonWidth, _buttonHeight, "Start the game", buttonType.menu, _isAbled))
		{
			//Start the Game
			var _transitionFunction = function() {obj_GameManager.inGame = true; room_goto(rm_Game);};
			transition(noone, _transitionFunction, true);
			game_setup();
			
			with (oAmogusLocal)
			{
				
				
			}
			
			//Set the Impostor
			var _impostorInstance = irandom(instance_number(obj_Amogus) - 1);
			var _impostor = instance_find(obj_Amogus, _impostorInstance);
			/*show_debug_message(instance_find(obj_Amogus, _impostorInstance));
			show_debug_message(instance_find(obj_AmogusClient, _impostorInstance));
			show_debug_message(instance_find(oAmogusLocal, _impostorInstance));*/
			with (_impostor)
				isImpostor = true;
			
			//Send the Game Start Message to All Clients
			with (obj_AmogusClient)
			{
				var _serverBuffer = obj_Server.serverBuffer;
				message_game_start(_serverBuffer, _impostor.clientId, false);
				network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
			}
			
			//Set Up the Game
			game_setup()
		}
		
		//Draw Waiting for Amoguses Text
		if (!_isAbled)
		{
			var _text = "Waiting for amoguses";
			var _textDots = "";
			repeat (floor(current_time * 0.005) % 4)
				_textDots += ".";
			
			draw_text_transformed_colour(_guiWidth * 0.5 - string_width(_text) * 0.5, _buttonY + _buttonHeight + 15, _text + _textDots,
										 1, 1, 0, c_white, c_white, c_white, c_white, 1);
		}
	}
	break;
	
	case menu.meeting:
	{
		//Amogus Info Table
		draw_amogus_table(_guiWidth * 0.5, 100, true);
		
		//Draw Meeting Timer
		var _secondsLeft = round(menuStateTimer / 60);
		var _meetingTimer = get_menuState_timer(menu.meeting);
		var _timerX = 100;
		var _timerY = _guiHeight - 100;
		
		draw_circle_sector(_timerX, _timerY, 45, menuStateTimer / _meetingTimer, 30, c_dkgrey);
		draw_set_font(fntTextUI);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text_transformed_colour(_timerX, _timerY, _secondsLeft,
									 1, 1, 0, c_white, c_white, c_white, c_white, 1);
	}
	break;
	
	case menu.throwOut:
	{
		draw_sprite_stretched(spr_BackgroundSpace, 0, 0, 0, _guiWidth, _guiHeight);
		var _text = "No amogus has been voted out."
		if (thrownOutAmogus != noone)
		{
			if (thrownOutAmogus.isImpostor)
				_text = string(thrownOutAmogus.username) + " was an IMPOSTOR."
			else
				_text = string(thrownOutAmogus.username) + " wasn't an IMPOSTOR... retards."
		}
		
		draw_set_halign(fa_center);
		draw_set_font(fntTextUI);
		draw_text_transformed_colour(_guiWidth * 0.5, _guiHeight * 0.8, _text, 1, 1, 0,
										c_white, c_white, c_white, c_white, 1);
		
		if (menuStateTimer <= 0 && transitionProgress <= 0 && obj_GameManager.serverSide)
		{
			if (!check_game_end())
			{
				//Send the Game Start Message to All Clients
				with (obj_AmogusClient)
				{
					var _serverBuffer = obj_Server.serverBuffer;
					message_game_start(_serverBuffer, noone, true);
					network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
				}
				
				transition(noone, noone, true);
				game_setup();
			}
		}
	}
	break;
	
	case menu.gameEnd:
	{
		var _text = "Crewmates won the game.";
		if (winnerSide == 1)
			_text = "Impostors won the game.";
		
		draw_rectangle_colour(0, 0, _guiWidth, _guiHeight, c_black, c_black, c_black, c_black, false);
		draw_set_font(fntTextUI)
		draw_set_halign(fa_center);
		draw_text_transformed_colour(_guiWidth * 0.5, _guiHeight * 0.6, _text, 1, 1, 0,
									 c_white, c_white, c_white, c_white, 1);
	}
	break;
}

//Transition Between 2 Menu States
if (transitionProgress > 0)
{
	if (transitionProgress > 0.5)
		var _progress = 1 - (transitionProgress * 2 - 1);
	else
		var _progress = transitionProgress * 2;
	
	var _curveChannel = animcurve_get_channel(ac_Transition, 0);
	var _curveValue = animcurve_channel_evaluate(_curveChannel, _progress);
	_progress = _curveValue;
	/*_progress = - 1.01 * sqr(_progress - 1) + 1.01;*/
	
	var _diagonalLength = sqrt(sqr(_guiWidth * 0.5) + sqr(_guiHeight * 0.5));
	var _transitionLength = _diagonalLength * _progress;
	var _flip = false;
	
	repeat (2)
	{
		var _angle = darcsin((_guiHeight * 0.5) / _diagonalLength) + 180 * _flip;
	
		var _point1X = _guiWidth * 0.5 + lengthdir_x(_diagonalLength, _angle);
		var _point1Y = _guiHeight * 0.5 + lengthdir_y(_diagonalLength, _angle);
		var _point2X = _guiWidth * 0.5 + lengthdir_x(_diagonalLength - _transitionLength, _angle);
		var _point2Y = _guiHeight * 0.5 + lengthdir_y(_diagonalLength - _transitionLength, _angle);
	
		var _x1 = _point1X + lengthdir_x(700, _angle + 90);
		var _y1 = _point1Y + lengthdir_y(700, _angle + 90);
		var _x2 = _point1X + lengthdir_x(700, _angle - 90);
		var _y2 = _point1Y + lengthdir_y(700, _angle - 90);
		var _x3 = _point2X + lengthdir_x(700, _angle + 90);
		var _y3 = _point2Y + lengthdir_y(700, _angle + 90);
		var _x4 = _point2X + lengthdir_x(700, _angle - 90);
		var _y4 = _point2Y + lengthdir_y(700, _angle - 90);
	
		draw_triangle_color(_x1, _y1, _x2, _y2, _x3, _y3, c_dkgray, c_dkgray, c_dkgray, false);
		draw_triangle_color(_x4, _y4, _x2, _y2, _x3, _y3, c_dkgray, c_dkgray, c_dkgray, false);
		
		_flip = true;
	}
	
	if (transitionProgress < 0.5 && menuState != transitionMenu)
	{
		menuState = transitionMenu;
		menuStateTimer = get_menuState_timer(menuState);
		if (transitionFunction != noone)
			transitionFunction();
	}
	
	transitionProgress -= TRANSITION_SPEED;
}

//Decrease menuStateTimer
if (menuStateTimer > 0)
	menuStateTimer --;
