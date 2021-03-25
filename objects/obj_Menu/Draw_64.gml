//Set Draw Properties
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
		if button(_buttonX, _buttonY + _buttonSpacing, _buttonWidth, _buttonHeight, "Join Game", true)
		{
			instance_create_layer(0, 0, "Managers", obj_Client);
			obj_GameManager.serverSide = false;
			menuState = menu.lobby;
		}
		
		//Create a Server
		_buttonSpacing += _buttonHeight + 30;
		if button(_buttonX, _buttonY + _buttonSpacing, _buttonWidth, _buttonHeight, "Create Game", true)
		{
			instance_create_layer(0, 0, "Managers", obj_Server);
			obj_GameManager.serverSide = true;
			menuState = menu.lobby; 
			
			var _amogusLocal = instance_create_layer(0, 0, "Amogus", oAmogusLocal);
			with (_amogusLocal)
			{
				clientId = obj_Server.clientIdCount ++;
				username = other.textFieldArray[0];
			}
		}
	}
	break;
	
	case menu.lobby:
	{
		//Set Amogus Info Size
		var _infoWidth = 200;
		var _infoHeight = 75;
		var _infoSpacingX = 30;
		var _infoSpacingY = 20;
		var _textPadding = 10;
		
		//Draw Amoguses' Info Tables
		for (var _i = 0; _i < instance_number(obj_Amogus); _i ++)
		{
			var _amogus = instance_find(obj_Amogus, _i);
			var _infoX = _guiWidth * 0.5 + _infoSpacingX - (_infoSpacingX * 2 + _infoWidth) * (_i % 2 == 0);
			var _infoY = 100 + (_infoHeight + _infoSpacingY) * (_i div 2);
			
			draw_rectangle_colour(_infoX, _infoY, _infoX + _infoWidth, _infoY + _infoHeight,
								  c_dkgrey, c_dkgrey, c_dkgrey, c_dkgrey, false);
			
			draw_text_transformed_colour(_infoX + _textPadding, _infoY + _textPadding, _amogus.username,
										  1, 1, 0, c_white, c_white, c_white, c_white, 1);
		}
		
		//Draw Start the Game Button
		var _buttonX = _guiWidth * 0.5 - _buttonWidth * 0.5;
		var _buttonY = _guiHeight * 0.65;
		var _isAbled = obj_GameManager.serverSide;
		if button(_buttonX, _buttonY, _buttonWidth, _buttonHeight, "Start the game", _isAbled)
		{
			//Set Up the Game
			obj_GameManager.inGame = true;
			menuState = noone;
			room_goto(rm_Game);
			
			with (oAmogusLocal)
			{
				
				
			}
			
			//Set the Impostor
			var _impostorInstance = irandom(instance_number(obj_Amogus));
			var _amogusSus = instance_find(obj_Amogus, _impostorInstance);
			with (_amogusSus)
			{
				isImpostor = true;
				
			}
			
			//Send the Game Start Message to All Clients
			with (obj_AmogusClient)
			{
				var _serverBuffer = obj_Server.serverBuffer;
				message_game_start(_serverBuffer, _amogusSus.clientId);
				network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
			}
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
}
