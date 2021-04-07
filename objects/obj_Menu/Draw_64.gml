//Set Draw Properties
draw_set_font(fnt_Menu1);
var _guiWidth = display_get_gui_width();
var _guiHeight = display_get_gui_height();
var _headerScale = 1.1;

//Set Button Size
var _buttonWidth = _guiWidth * 0.15;
var _buttonHeight = _guiHeight * 0.10;
var _buttonSpacing = 0;

var _fieldWidth = _guiWidth * 0.15;
var _fieldHeight = _guiHeight * 0.08;
/*
var _buttonWidth = 205;
var _buttonHeight = 78;
var _buttonSpacing = 0;

var _fieldWidth = 205;
var _fieldHeight = 61;*/

//Switch to Fullscreen
if (keyboard_check_pressed(ord("F")))
{
	window_set_fullscreen(!window_get_fullscreen());
	alarm[1] = 10;
}

//Create Surfaces
if (!surface_exists(surfaceText))
	surfaceText = surface_create(_guiWidth, _guiHeight);
if (!surface_exists(surfaceUI))
	surfaceUI = surface_create(guiW, guiH);
if (!surface_exists(surfaceUISmall))
	surfaceUISmall = surface_create(guiW, guiH);

surface_set_target(surfaceText);
draw_clear_alpha(c_black, 0);
surface_reset_target();
surface_set_target(surfaceUI);
draw_clear_alpha(c_black, 0);
surface_reset_target();
surface_set_target(surfaceUISmall);
draw_clear_alpha(c_black, 0);
surface_reset_target();
surface_set_target(surfaceText);

switch (menuState)
{
	case menu.mainMenu:
	{
		//Draw Menu Text Fields && Buttons
		var _buttonX = _guiWidth * 0.5 - _buttonWidth * 0.5;
		var _buttonY = _guiHeight * 0.5;
		_arrowSpacing = 75;
		
		//Draw Game Logo
		surface_reset_target();
		surface_set_target(surfaceUI);
		draw_sprite(spr_Logo, 0, guiW * 0.5, guiH * 0.05);
		
		//Draw Middle Panel
		var _panelOffset = _guiWidth * 0.07;
		var _panelX = _buttonX - _panelOffset;
		var _panelY = _buttonY - 50;
		draw_sprite_stretched(spr_Panel, 0, _panelX * guiToUI, _panelY * guiToUI, (_buttonWidth + _panelOffset * 2) * guiToUI, (_guiHeight - _panelY)  * guiToUI);
		surface_reset_target();
		surface_set_target(surfaceText);
		
		//Name Selection
		draw_set_halign(fa_center);
		draw_set_valign(fa_bottom);
		draw_text_transformed_colour(_guiWidth * 0.5, _buttonY, "USERNAME", _headerScale, _headerScale, 0, c_white, c_white, c_white, c_white, 1);
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		var _name = id_get_name(selectedNameId);
		draw_set_font(fnt_Menu2);
		draw_text_transformed_colour(_guiWidth * 0.5, _buttonY + 20, _name, 1, 1, 0, c_white, c_white, c_white, c_white, 1);
		
		if arrow_button(_guiWidth * 0.5 + _arrowSpacing, _buttonY + 20, 0, true, 2)
			selectedNameId ++;
		if arrow_button(_guiWidth * 0.5 - _arrowSpacing, _buttonY + 20, 180, true, 2)
			selectedNameId --;
		selectedNameId = wrap(selectedNameId, 0, NAME_NUMBER);
		/*text_field(_buttonX, _buttonY, _buttonWidth, _buttonHeight, true, 0);*/
		_buttonSpacing += _buttonHeight + 10;
		
		//Join an Existing Server
		draw_set_halign(fa_center);
		draw_set_valign(fa_bottom);
		draw_set_font(fnt_Menu1);
		draw_text_transformed_colour(_guiWidth * 0.5, _buttonY + _buttonSpacing * 1, "IP ADRESS", _headerScale, _headerScale, 0, c_white, c_white, c_white, c_white, 1);
		text_field(_buttonX, _buttonY + _buttonSpacing, _fieldWidth, _fieldHeight, true, 1);
		_buttonSpacing += _buttonHeight + 0;
		if (button(_buttonX, _buttonY + _buttonSpacing, _buttonWidth, _buttonHeight, "JOIN GAME", buttonType.menu, true, false))
		{
			instance_create_layer(0, 0, "Managers", obj_Client);
			obj_GameManager.serverSide = false;
			transition(menu.lobby, noone, true);
		}
		
		//Create a Server
		_buttonSpacing += _buttonHeight + 30;
		if (button(_buttonX, _buttonY + _buttonSpacing, _buttonWidth, _buttonHeight, "CREATE GAME", buttonType.menu, true, false))
		{
			instance_create_layer(0, 0, "Managers", obj_Server);
			obj_GameManager.serverSide = true;
			transition(menu.lobby, noone, true);
			
			var _amogusLocal = instance_create_layer(0, 0, "Amogus", oAmogusLocal);
			with (_amogusLocal)
			{
				clientId = obj_Server.clientIdCount ++;
				/*username = other.textFieldArray[0];*/
				nameId = other.selectedNameId;
				headId = other.selectedHeadId;
				bodyId = other.selectedBodyId;
			}
			obj_Server.clientIdMap[? _amogusLocal.clientId] = _amogusLocal;
		}
		
		//Avatar Selection
		var _selectionX = _guiWidth * 0.18;
		var _selectionY = _guiHeight * 0.5;
		var _selectionSpacing = 0;
		var _arrowSpacing = 120;
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(fnt_Menu1);
		draw_text_transformed_colour(_selectionX, _selectionY, "CUSTOMIZE YOUR AMOGUS",
									 _headerScale, _headerScale, 0, c_white, c_white, c_white, c_white, 1);
		_selectionSpacing += 35;
		
		draw_set_font(fnt_Menu2);
		var _headName = id_get_head(selectedHeadId);	//head selection
		draw_text_transformed_colour(_selectionX, _selectionY + _selectionSpacing, _headName,
									 1, 1, 0, c_white, c_white, c_white, c_white, 1);
		if arrow_button(_selectionX - _arrowSpacing, _selectionY + _selectionSpacing, 180, true, 2)
			selectedHeadId --;
		if arrow_button(_selectionX + _arrowSpacing, _selectionY + _selectionSpacing, 0, true, 2)
			selectedHeadId ++;
		selectedHeadId = wrap(selectedHeadId, 0, sprite_get_number(spr_Head));
		
		_selectionSpacing += 150;	//body selection
		if arrow_button(_selectionX - _arrowSpacing, _selectionY + _selectionSpacing, 180, true, 2)
			selectedBodyId --;
		if arrow_button(_selectionX + _arrowSpacing, _selectionY + _selectionSpacing, 0, true, 2)
			selectedBodyId ++;
		selectedBodyId = wrap(selectedBodyId, 0, sprite_get_number(spr_Body) div 3);
		
		draw_sprite_ext(spr_Body, selectedBodyId * 3, _selectionX + 10, _selectionY + _selectionSpacing + 25,
						7, 7, 0, c_white, 1);
		draw_sprite_ext(spr_Head, selectedHeadId, _selectionX + 10, _selectionY + _selectionSpacing + 25,
						7, 7, 0, c_white, 1);
		
		surface_reset_target();
		surface_set_target(surfaceUI);
		var _cylinderWidth = sprite_get_width(spr_AmogusSelection);
		var _cylinderY = _selectionY + _selectionSpacing + 40;
		draw_sprite_stretched(spr_AmogusSelection, 0, _selectionX * guiToUI, _cylinderY * guiToUI, _cylinderWidth, (_guiHeight - _cylinderY) * guiToUI);	//draw not selected button
		
		//Draw Game Info
		draw_set_halign(fa_right);
		draw_set_valign(fa_bottom);
		draw_text_transformed_colour(_guiWidth - 5, _guiHeight - 5, "Amogus v. b.1.0\nHyperCubic Studio 2021",
									 0.5, 0.5, 0, c_white, c_white, c_white, c_white, 1);
		
		//Play Music
		if (transitionProgress < 0.05 && !audio_is_playing(snd_MusicEarrape) && !audio_is_playing(snd_RickRoll))
			audio_play_sound(snd_MusicEarrape, 0, false);
	}
	break;
	
	case menu.lobby:
	{
		//Stop the Music
		audio_stop_sound(snd_MusicEarrape);
		/*audio_stop_sound(snd_RickRoll);*/
		
		//Draw Amoguses Info Table
		draw_amogus_table(_guiWidth * 0.5, 100, false);
		
		//Draw Start the Game Button
		_buttonWidth += 10;
		var _buttonX = _guiWidth * 0.5 - _buttonWidth * 0.5;
		var _buttonY = _guiHeight * 0.65;
		var _isAbled = obj_GameManager.serverSide;
		if (button(_buttonX, _buttonY, _buttonWidth, _buttonHeight, "START THE GAME", buttonType.menu, _isAbled, false))
		{
			//Start the Game
			var _transitionFunction = function() {obj_GameManager.inGame = true; room_goto(rm_Game); game_setup();};
			transition(noone, _transitionFunction, true);
			tasksNeeded = (ds_map_size(obj_Server.clientIdMap) - impostors) * TASKS_PER_AMOGUS;
			
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
		}
		
		//Rick Roll hehehe
		var _buttonX = _guiWidth * 0.9 - _buttonWidth * 0.5;
		var _buttonY = _guiHeight * 0.9 - _buttonHeight * 0.5;
		if (button(_buttonX, _buttonY, _buttonWidth, _buttonHeight, "DON'T CLICK", buttonType.menu, true, false))
		{
			audio_stop_sound(snd_MusicEarrape);
			audio_play_sound(snd_RickRoll, 0, false);
		}
		surface_reset_target();
		surface_set_target(surfaceText);
		
		//Draw Waiting for Amoguses Text
		if (!_isAbled)
		{
			var _text = "Waiting for amoguses";
			var _textDots = "";
			repeat (floor(current_time * 0.005) % 4)
				_textDots += ".";
			
			draw_set_font(fnt_Menu2);
			draw_text_transformed_colour(_guiWidth * 0.5 - string_width(_text) * 0.5, _buttonY + _buttonHeight + 15, _text + _textDots,
										 1, 1, 0, c_white, c_white, c_white, c_white, 1);
		}
	}
	break;
	
	case noone:
	{
		if (audio_is_playing(snd_RickRoll))
			audio_stop_sound(snd_RickRoll);
		
		if (classWarning && transitionProgress <= 0)
		{
			warning(warningType.class, 0.5);
			classWarning = false;
		}
		
		surface_reset_target();
		surface_set_target(surfaceUISmall);
		var _barWidth = _guiWidth * 0.2;
		var _barHeight = _guiHeight * 0.13;
		var _barX = _guiWidth * 0.5 - _barWidth;
		var _barY = _guiHeight * 0.05;
		var _barProgress = taskProgress / tasksNeeded;
		draw_sprite_stretched(spr_Bar, 0, _barX * guiToUI, _barY * guiToUI, (_barWidth * 2) * guiToUI, _barHeight * guiToUI);
		draw_sprite_stretched(spr_BarProgress, 0, _barX * guiToUI + 3, _barY * guiToUI + 3, (_barWidth * 2 * _barProgress) * guiToUI - 6, _barHeight * guiToUI - 8);
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
		if (menuStatePrev != menu.throwOut) Ejected(thrownOutAmogus.nameId)
		
		draw_sprite_stretched(spr_BackgroundSpace, 0, 0, 0, _guiWidth, _guiHeight);
		var _menuStateTimer = get_menuState_timer(menu.throwOut);
		var _menuProgress = _menuStateTimer - menuStateTimer;
		
		//Draw Thrown Out Amogus
		if (thrownOutAmogus != noone)
		{
			draw_sprite_ext(spr_Body, thrownOutAmogus.bodyId * 3, _menuProgress * 3, _guiHeight * 0.5, 5, 5, _menuProgress * 2, c_white, 1);
			draw_sprite_ext(spr_Head, thrownOutAmogus.headId, _menuProgress * 3, _guiHeight * 0.5, 5, 5, _menuProgress * 2, c_white, 1);
		}
		
		//Draw Voted Amogus Text
		var _text = "No amogus has been voted out."
		if (thrownOutAmogus != noone)
		{
			var _name = id_get_name(thrownOutAmogus.nameId);
			if (thrownOutAmogus.isImpostor)
				_text = string(_name) + " was an IMPOSTOR."
			else
				_text = string(_name) + " wasn't an IMPOSTOR... retards."
		}
		var _count = floor(string_length(_text) * clamp((_menuProgress / _menuStateTimer) * 2.3, 0, 1));
		var _textPart = string_copy(_text, 0, _count);
		
		draw_set_halign(fa_center);
		draw_set_font(fntTextUI);
		draw_text_transformed_colour(_guiWidth * 0.5, _guiHeight * 0.8, _textPart, 1, 1, 0,
										c_white, c_white, c_white, c_white, 1);
		
		if (menuStateTimer <= 40 && transitionProgress <= 0 && obj_GameManager.serverSide)
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
menuStatePrev = menuState

//Set Cursor Sprite
if (buttonIsSelected)
	window_set_cursor(cr_handpoint);
else
	window_set_cursor(cr_default);

//Draw the Surfaces
surface_reset_target();
draw_surface_stretched(surfaceUI, 0, 0, _guiWidth, _guiHeight);
draw_surface_stretched(surfaceUISmall, _guiWidth * 0.5 - (guiW * 3) * 0.5, 0, guiW * 3, guiH * 3);
draw_surface(surfaceText, 0, 0);

//Draw a Warning
if (warningProgress > 0)
{
	var _progress = clamp(warningProgress * 2, 0, 1);
	var _curveChannel = animcurve_get_channel(ac_Transition, 0);
	var _curveValue = animcurve_channel_evaluate(_curveChannel, _progress);
	var _scale = _curveValue;
	
	switch (warningType)
	{
		case warningType.meeting:
		{
			if (!meetingSoundPlayed) EmergencyMeeting(caller)
			meetingSoundPlayed = true
			draw_sprite_ext(spr_Meeting, 0, _guiWidth * 0.5, _guiHeight * 0.5, 4 * _scale, 4 * _scale, 0, c_white, 1);
		}
		break;
		
		case warningType.body:
		{
			if (!meetingSoundPlayed) EmergencyMeeting(caller)
			meetingSoundPlayed = true
			draw_sprite_ext(spr_BodyReport, 0, _guiWidth * 0.5, _guiHeight * 0.5, 4 * _scale, 4 * _scale, 0, c_white, 1);
		}
		break;
		
		case warningType.class:
		{
			var _alpha = clamp((1 - warningProgress) * 2, 0, 0.4);
			if (warningProgress < 0.4)
				_alpha =  clamp(warningProgress * 3, 0, 0.4);
			draw_set_alpha(_alpha);
			draw_rectangle_colour(0, 0, _guiWidth, _guiHeight, c_black, c_black, c_black, c_black, false);
			draw_set_alpha(1);
			
			var _text = "You are ";
			var _colour = c_white;
			if (oAmogusLocal.isImpostor)
			{
				_text += "IMPOSTOR.";
				_colour = c_red;
			}
			else
				_text += "CREWMATE.";
			
			draw_set_font(fnt_Menu1);
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			_alpha = clamp((1 - warningProgress) * 2, 0, 1);
			if (warningProgress < 0.4)
				_alpha = warningProgress * 3;
			draw_text_transformed_colour(_guiWidth * 0.5, _guiHeight * 0.5, _text, 3, 3, 0, _colour, _colour, _colour, _colour, _alpha);
		}
		break;
	}
	
	warningProgress -= WARNING_SPEED * warningSpeed;
}

//Transition Between 2 Menu States
if (transitionProgress > 0 && warningProgress <= 0)
{
	if (transitionProgress > 0.5)
		var _progress = 1 - (transitionProgress * 2 - 1);
	else
		var _progress = transitionProgress * 2;
	
	draw_set_alpha(_progress);
	draw_rectangle_colour(0, 0, _guiWidth, _guiHeight, c_black, c_black, c_black, c_black, false);
	draw_set_alpha(1);
	
	if (transitionClosing)
	{
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
	
			var _x1 = _point1X + lengthdir_x(_guiWidth, _angle + 90);
			var _y1 = _point1Y + lengthdir_y(_guiWidth, _angle + 90);
			var _x2 = _point1X + lengthdir_x(_guiWidth, _angle - 90);
			var _y2 = _point1Y + lengthdir_y(_guiWidth, _angle - 90);
			var _x3 = _point2X + lengthdir_x(_guiWidth, _angle + 90);
			var _y3 = _point2Y + lengthdir_y(_guiWidth, _angle + 90);
			var _x4 = _point2X + lengthdir_x(_guiWidth, _angle - 90);
			var _y4 = _point2Y + lengthdir_y(_guiWidth, _angle - 90);
	
			draw_triangle_color(_x1, _y1, _x2, _y2, _x3, _y3, c_dkgray, c_dkgray, c_dkgray, false);
			draw_triangle_color(_x4, _y4, _x2, _y2, _x3, _y3, c_dkgray, c_dkgray, c_dkgray, false);
		
			_flip = true;
		}
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
