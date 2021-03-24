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

		draw_set_halign(fa_center);
		draw_set_valign(fa_bottom);
		draw_text_transformed_colour(_guiWidth * 0.5, _buttonY, "Username", 1, 1, 0, c_white, c_white, c_white, c_white, 1);
		text_field(_buttonX, _buttonY, _buttonWidth, _buttonHeight, true, 0);
		_buttonSpacing += _buttonHeight + 35;

		draw_set_halign(fa_center);
		draw_set_valign(fa_bottom);
		draw_text_transformed_colour(_guiWidth * 0.5, _buttonY + _buttonSpacing * 1, "IP Adress", 1, 1, 0, c_white, c_white, c_white, c_white, 1);
		text_field(_buttonX, _buttonY + _buttonSpacing, _buttonWidth, _buttonHeight, true, 1);
		_buttonSpacing += _buttonHeight + 10;
		if button(_buttonX, _buttonY + _buttonSpacing, _buttonWidth, _buttonHeight, "Join Game", true)
		{
			instance_create_layer(0, 0, "Managers", obj_Client);
			menuState = menu.lobby;
		}

		_buttonSpacing += _buttonHeight + 30;
		if button(_buttonX, _buttonY + _buttonSpacing, _buttonWidth, _buttonHeight, "Create Game", true)
		{
			instance_create_layer(0, 0, "Managers", obj_Server);
			var _amogusLocal = instance_create_layer(0, 0, "Amogus", oAmogusLocal);
			with (_amogusLocal)
			{
				clientId = obj_Server.clientIdCount ++;
				username = other.textFieldArray[0];
			}
			menuState = menu.lobby; 
		}
	}
	break;
	
	case menu.lobby:
	{
		
		
		
	}
	break;
}