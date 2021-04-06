/// Function drawing a table of connected amoguses.
function draw_amogus_table(_x, _y, _meeting)
{
	//Set Draw Properties
	var _guiWidth = display_get_gui_width();
	var _guiHeight = display_get_gui_height();
	draw_set_font(fnt_Menu2);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	var _textHeight = string_height("Ap");	//approximation of average text height
	
	//Set Amogus Info Size
	var _infoWidth = 300;
	var _infoHeight = 120;
	var _infoSpacingX = 30;
	var _infoSpacingY = 20;
	var _textPadding = 20;
	
	//Draw Middle Panel
	var _panelOffset = _guiWidth * 0.07;
	var _panelX1 = _x - _infoSpacingX - _infoWidth - _panelOffset;
	var _panelY1 = _y - 50;
	var _panelWidth = _infoSpacingX * 2 + _infoWidth * 2 + _panelOffset * 2;
	var _panelHeight = _guiHeight - _panelY1;
	surface_reset_target();
	surface_set_target(surfaceUI);
	draw_sprite_stretched(spr_Panel, 0, _panelX1 * guiToUI, _panelY1 * guiToUI, _panelWidth * guiToUI, _panelHeight  * guiToUI);
	
	var _everyoneVoted = true;
	
	//Draw Amoguses Info Table
	for (var _i = 0; _i < instance_number(obj_Amogus); _i ++)
	{
		var _amogus = instance_find(obj_Amogus, _i);
		var _isAlive = _amogus.isAlive;
		var _infoX = _x + _infoSpacingX - (_infoSpacingX * 2 + _infoWidth) * (_i % 2 == 0);
		var _infoY = _y + (_infoHeight + _infoSpacingY) * (_i div 2);

		surface_reset_target();
		surface_set_target(surfaceUI);
		draw_sprite_stretched(spr_TextField, 0, _infoX * guiToUI, _infoY * guiToUI, _infoWidth * guiToUI, _infoHeight * guiToUI)
		/*draw_rectangle_colour(_infoX, _infoY, _infoX + _infoWidth, _infoY + _infoHeight,
								c_dkgrey, c_dkgrey, c_dkgrey, c_dkgrey, false);*/
		
		var _name = id_get_name(_amogus.nameId);
		
		surface_reset_target();
		surface_set_target(surfaceText);
		draw_set_halign(fa_right);
		draw_set_font(fnt_Menu2);
		/*
		var _spriteScale = 6;
		var _guiToSprite = (sprite_get_width(spr_Body) * _spriteScale) / guiToUI;*/
		
		draw_text_transformed_colour(_infoX + _infoWidth - _textPadding, _infoY + _textPadding, _name,
									 1, 1, 0, c_white, c_white, c_white, c_white, 1);
		draw_sprite_part_ext(spr_Body, _amogus.bodyId * 3, 4, 0, 500, 21, _infoX + 7, _infoY - 20, 6, 6, c_white, 1);
		draw_sprite_ext(spr_Head, _amogus.headId, _infoX + 62, _infoY + 78, 6, 6, 0, c_white, 1);
		
		//Emergeny Meeting Voting
		if (_meeting)
		{
			if (!_amogus.hasVoted && _isAlive)
				_everyoneVoted = false;
			
			//Set Voting Button Properties
			var _buttonWidth = 80;
			var _buttonHeight = 50;
			var _buttonX = _infoX + _infoWidth - _buttonWidth - _textPadding;
			var _buttonY = _infoY + _infoHeight - _buttonHeight - _textPadding;
			
			//Vote for a Amogus
			if (_isAlive)
			{
				var _isAbled = oAmogusLocal.isAlive;
				if (button(_buttonX, _buttonY, _buttonWidth, _buttonHeight, "SUS", buttonType.vote, _isAbled, true)
					&& !oAmogusLocal.hasVoted)
				{
					var _voterId =  oAmogusLocal.clientId;
					oAmogusLocal.hasVoted = true;
				
					//Send Message to All Amoguses
					if (obj_GameManager.serverSide)
					{
						with (_amogus)
							array_push(voteArray, _voterId);
					
						var _serverBuffer = obj_Server.serverBuffer;
						message_vote(_serverBuffer, _voterId, _amogus.clientId);
						with (obj_AmogusClient)
							network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
					}
				
					//Send Message to the Server
					else if (obj_GameManager.serverSide == false)
					{
						var _clientBuffer = obj_Client.clientBuffer;
						message_vote(_clientBuffer, _voterId, _amogus.clientId);
						network_send_packet(obj_Client.client, _clientBuffer, buffer_tell(_clientBuffer));
					}
				}
			
				if (_amogus.hasVoted)
				{
					draw_set_halign(fa_center);
					draw_text_transformed_colour(_infoX + _infoWidth * 0.5, _infoY + _textPadding * 2 + _textHeight, "VOTED",
												 1, 1, 0, c_red, c_red, c_red, c_red, 1);
				}
			}
		}
	}
	
	//Throw Out Amogus With the Most Number of Votes
	if ((_everyoneVoted || menuStateTimer == 0) && _meeting && obj_GameManager.serverSide && transitionMenu != menu.throwOut)
	{
		var _amogusGone = noone;
		var _sameNumberOfVotes = false;
		with (obj_Amogus)
		{
			if (_amogusGone == noone)
				_amogusGone = self;
			else if (array_length(voteArray) == array_length(_amogusGone.voteArray))
				_sameNumberOfVotes = true;
			else if (array_length(voteArray) > array_length(_amogusGone.voteArray))
			{
				_amogusGone = self;
				_sameNumberOfVotes = false;
			}
		}
		
		if (!_sameNumberOfVotes)	//don't throw out anyone when there're more amoguses with the same number of votes
		{
			thrownOutAmogus = _amogusGone;
			thrownOutAmogus.isAlive = false;
		}
		transition(menu.throwOut, noone, false);
		 
		//Send Message to Throw Out Voted Amogus to All Amoguses
		var _serverBuffer = obj_Server.serverBuffer;
		var _thrownOutAmogusId = (thrownOutAmogus == noone) ? noone : thrownOutAmogus.clientId;
		message_throwOut(_serverBuffer, _thrownOutAmogusId);
		with (obj_AmogusClient)
		network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
	}
}

/// Function triggering a transition between 2 menu states.
function transition(transitionMenuState, _transitionFunction, _closing)
{
	with (obj_Menu)
	{/*
		if (_smooth)
		{*/
			transitionProgress = 1;
			transitionMenu = transitionMenuState;
			transitionFunction = _transitionFunction;
			transitionClosing = _closing;
		/*}
		else
		{
			menuState = transitionMenuState;
			menuStateTimer = get_menuState_timer(menuState);
			if (_transitionFunction != noone)
				_transitionFunction();
		}*/
	}
}

/// Function triggering a warning.
function warning(_warningType, _warningSpeed)
{
	with (obj_Menu)
	{
		warningType = _warningType;
		warningProgress = 1;
		warningSpeed = _warningSpeed;
	}
}

/// Function returning menuStateTimer Value for a Given Menu State
function get_menuState_timer(_menuState)
{
	switch (_menuState)
	{
		case menu.meeting:
			return 30 * 60;
			break;
		case menu.throwOut:
			return 6 * 60;
			break;
		default:
			return 0;
			break;
	}
}

/// Function checking wheter one of the sides won the game.
function check_game_end()
{
	var _crewmateCount = 0;
	var _impostorCount = 0;
	
	with (obj_Amogus)
	{
		if (isAlive)
		{
			if (isImpostor)
				_impostorCount ++;
			else
				_crewmateCount ++;
		}
	}
	
	var _winnerSide = noone;
	if (_impostorCount == 0 || obj_Menu.taskProgress == obj_Menu.tasksNeeded)
		_winnerSide = 0;
	else if (_crewmateCount <= _impostorCount)
		_winnerSide = 1;
	
	if (_winnerSide != noone)
	{
		transition(menu.gameEnd, noone, true); 
		obj_Menu.winnerSide = _winnerSide
		
		var _serverBuffer = obj_Server.serverBuffer;
		message_game_end(_serverBuffer, _winnerSide);
		with (obj_AmogusClient)
			network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
		
		return true;
	}
	else
		return false;
}

/// Function setting up the game at start || continuation of the game.
function game_setup()
{
	array_delete(global.activeTasks,0,array_length(global.activeTasks)+1)
	
	with (oAmogusLocal)
	{
		x = obj_Menu.spawnX + lengthdir_x(random(30), random(360));
		y = obj_Menu.spawnY + lengthdir_y(random(30), random(360));
		
		hasVoted = false;
		voteArray = [];
		
		interactableObject = noone;
		interactableStruct = noone;
		interactableInRange = noone;
	}
	
	with (obj_Menu)
	{
		thrownOutAmogus = noone;
		meetingSoundPlayed = false
		caller = noone
	}
	
	/*
	var _serverBuffer = obj_Server.serverBuffer;
	with (obj_AmogusClient)
	{
		var _x = obj_Menu.spawnX + lengthdir_x(random(30), random(360));
		var _y = obj_Menu.spawnY + lengthdir_y(random(30), random(360));
		message_position(_serverBuffer, clientId, _x, _y);
		network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
	}*/
}


function ExitMenu(_taskCompleted)
{
	///@arg deleteMemory
	inMenu = false
	if (_taskCompleted)
	{
		audio_play_sound(sndTaskCompleted,0,0)
		var type = interactableObject.interactableStruct.type
		interactableObject.interactableStruct = noone
		interactableObject.interactableStruct = new Interactable(type)
		taskCompleted = false
		
		/*if (obj_GameManager.serverSide)
		{
			obj_Menu.taskProgress ++;
			var _serverBuffer = obj_Server.serverBuffer;
			message_task_progress(_serverBuffer, 1);
			with (obj_AmogusClient)
				network_send_packet(clientSocket, _serverBuffer, buffer_tell(_serverBuffer));
			
			check_game_end();	//check for game end
		}
		else
		{
			var _clientBuffer = obj_Client.clientBuffer;
			message_task_progress(_clientBuffer, 1);
			network_send_packet(obj_Client.client, _clientBuffer, buffer_tell(_clientBuffer));
		}*/
	}
	else audio_play_sound(sndSucces,0,0)
	interactableObject.amogus = noone;
	interactableObject = noone
	interactableStruct = noone;
}

function ResetCameraPos()
{
	camX = clamp(x - (guiW/2),0,rW - guiW)
	camY = clamp(y - (guiH/2),0,rH - guiH)
}
