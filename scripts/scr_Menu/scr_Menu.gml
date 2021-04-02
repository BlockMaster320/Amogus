/// Function drawing a table of connected amoguses.
function draw_amogus_table(_x, _y, _meeting)
{
	//Set Draw Properties
	draw_set_font(fnt_Menu);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	var _textHeight = string_height("Ap");	//approximation of average text height
	
	//Set Amogus Info Size
	var _infoWidth = 300;
	var _infoHeight = 120;
	var _infoSpacingX = 30;
	var _infoSpacingY = 20;
	var _textPadding = 10;
	
	var _everyoneVoted = true;
	
	//Draw Amoguses Info Table
	for (var _i = 0; _i < instance_number(obj_Amogus); _i ++)
	{
		var _amogus = instance_find(obj_Amogus, _i);
		var _isAlive = _amogus.isAlive;
		var _infoX = _x + _infoSpacingX - (_infoSpacingX * 2 + _infoWidth) * (_i % 2 == 0);
		var _infoY = _y + (_infoHeight + _infoSpacingY) * (_i div 2);
		
		draw_rectangle_colour(_infoX, _infoY, _infoX + _infoWidth, _infoY + _infoHeight,
								c_dkgrey, c_dkgrey, c_dkgrey, c_dkgrey, false);
		
		draw_text_transformed_colour(_infoX + _textPadding, _infoY + _textPadding, _amogus.username,
										1, 1, 0, c_white, c_white, c_white, c_white, 1);
		
		//Emergeny Meeting Voting
		if (_meeting)
		{
			if (!_amogus.hasVoted && _isAlive)
				_everyoneVoted = false;
			
			//Set Voting Button Properties
			var _buttonWidth = 75;
			var _buttonHeight = 45;
			var _buttonX = _infoX + _infoWidth - _buttonWidth - _textPadding;
			var _buttonY = _infoY + _infoHeight - _buttonHeight - _textPadding;
			
			//Vote for a Amogus
			if (_isAlive)
			{
				var _isAbled = oAmogusLocal.isAlive;
				if (button(_buttonX, _buttonY, _buttonWidth, _buttonHeight, "Vote", buttonType.vote, _isAbled)
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
					draw_text_transformed_colour(_infoX + _textPadding, _infoY + _textPadding * 2 + _textHeight, "VOTED",
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
function warning(_warningType)
{
	with (obj_Menu)
	{
		warningType = _warningType;
		warningProgress = 1;
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
			return 4 * 60;
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
	if (_impostorCount == 0)
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
	obj_Menu.thrownOutAmogus = noone;
	
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

function ExitMenu(taskCompleted_)
{
	inMenu = false
	if (taskCompleted_)
	{
		var type = interactableObject.interactableStruct.type
		interactableObject.interactableStruct = noone
		interactableObject.interactableStruct = new Interactable(type)
		taskCompleted = false
	}
	interactableObject.amogus = noone;
	interactableObject = noone
	interactableStruct = noone;
}
