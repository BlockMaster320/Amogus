/// Function for drawing && interacting with a button.

function button(_x, _y, _width, _height, _text, _type, _isAbled)
{
	//Set Return Value
	var _returnValue = false;
	
	//Set Button Area Size
	var _x1 = _x;
	var _y1 = _y;
	var _x2 = _x + _width;
	var _y2 = _y + _height;
	
	var _colour1 = (_type == buttonType.menu) ? c_dkgrey : c_grey;
	var _colour2 = (_type == buttonType.menu) ? c_grey : c_ltgrey;
	
	//Check Wheter the Button is Clickable
	if (_isAbled)
	{
		//Check Wheter the Button is Selected
		var _mouseWindowX = window_mouse_get_x();
		var _mouseWindowY = window_mouse_get_y();
		if (point_in_rectangle(_mouseWindowX, _mouseWindowY, _x1, _y1, _x2, _y2) && obj_Menu.transitionProgress < 0.5)
		{
			draw_rectangle_colour(_x1, _y1, _x2, _y2, _colour2, _colour2, _colour2, _colour2, false);	//draw selected button
			if (mouse_check_button_pressed(mb_left))
				_returnValue = true;
		}
		else
			draw_rectangle_colour(_x1, _y1, _x2, _y2, _colour1, _colour1, _colour1, _colour1, false);	//draw not selected button
	}
	else
	{
		draw_set_alpha(0.5);
		draw_rectangle_colour(_x1, _y1, _x2, _y2, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);	//draw not abled button
		draw_set_alpha(1);
	}

	//Draw the Button Text
	var _textAlpha = (_isAbled) ? 1 : 0.5;
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var _textX = _x1 + (_x2 - _x1) * 0.5;
	var _textY = _y1 + (_y2 - _y1) * 0.5;
	draw_text_transformed_colour(_textX, _textY, _text, 1, 1, 0, c_white, c_white, c_white, c_white, _textAlpha);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	return _returnValue;
}

/// Function highlighting a button.
function button_highlight(_x1, _y1, _x2, _y2)
{
	draw_rectangle_colour(_x1, _y1, _x2, _y2, c_white, c_white, c_white, c_white, true);
	draw_set_alpha(0.3);
	draw_rectangle_colour(_x1, _y1, _x2, _y2, c_white, c_white, c_white, c_white, false);
	draw_set_alpha(1);
}

/// Function drawing an arrow button.
function arrow_button(_x, _y, _direction, _isAbled, _scale)
{
	//Set Return Value
	var _returnValue = false;
	
	//Set Position of the Rectangle Representing Arrow's Hitbox
	var _arrowWidth = sprite_get_width(spr_Arrow);
	var _arrowHeight = sprite_get_height(spr_Arrow);
	var _rectangleX1 = _x + lengthdir_x(_arrowWidth * _scale * 0.5, _direction + 90);
	var _rectangleY1 = _y + lengthdir_y(_arrowHeight * _scale * 0.5, _direction + 90);
	var _rectangleX2 =_x - lengthdir_x(_arrowWidth * _scale * 0.5, _direction + 90) + 
					  lengthdir_x(_arrowWidth * _scale, _direction);
	var _rectangleY2 = _y - lengthdir_y(_arrowHeight * _scale * 0.5, _direction + 90) -
					lengthdir_y(_arrowHeight * _scale, _direction);
	
	var _scaleX = (_direction == 0 || _direction == 90) ? 1 : - 1;
	var _drawDirection = (_direction == 90 || _direction == 270) ? 270 : 0;
	
	//Check Wheter the Arrow is Clickable
	if (_isAbled)
	{
		//Get Cursor's Position
		var _mouseWindowX = window_mouse_get_x();
		var _mouseWindowY = window_mouse_get_y();
		
		//Order the Rectangle's Position Points So They Can Be Used For Collision Checking
		var _rectangleLeftX = min(_rectangleX1, _rectangleX2);
		var _rectangleTopY = min(_rectangleY1, _rectangleY2);
		var _rectangleRightX = max(_rectangleX1, _rectangleX2);
		var _rectangleBottomY = max(_rectangleY1, _rectangleY2);
		
		//Check Wheter the Button is Selected
		if (point_in_rectangle(_mouseWindowX, _mouseWindowY, _rectangleLeftX, _rectangleTopY, _rectangleRightX, _rectangleBottomY))
		{
			draw_sprite_ext(spr_Arrow, 1, _x, _y, _scaleX * _scale, _scale, _drawDirection, c_white, 1)	//draw selected arrow
			if (mouse_check_button_pressed(mb_left))
				_returnValue = true;
		}
		else
			draw_sprite_ext(spr_Arrow, 0, _x, _y, _scaleX * _scale, _scale, _drawDirection, c_white, 1)	//draw not selected arrow
	}
	else
		draw_sprite_ext(spr_Arrow, 0, _x, _y, _scaleX * _scale, _scale, _drawDirection, c_grey, 1)	//draw not abled arrow
	
	return _returnValue;
}


/// Function for drawing && interacting with a text field.
/// variables needed: textField, textFieldArray, textCursorPosition, charSet
function text_field(_x, _y, _width, _height, _isAbled, _index)
{
	//Set Button Area Size
	var _x1 = _x;
	var _y1 = _y;
	var _x2 = _x + _width;
	var _y2 = _y + _height;
	
	//Check Wheter the Field is Clickable
	if (_isAbled)
	{
		//Set the Text Field to Active on Mouse Button Click
		if (mouse_check_button_pressed(mb_left))
		{
			//Check Wheter the Button is Selected
			var _mouseWindowX = window_mouse_get_x();
			var _mouseWindowY = window_mouse_get_y();
			if (point_in_rectangle(_mouseWindowX, _mouseWindowY, _x1, _y1, _x2, _y2))
			{
				//Set the Active Text Field
				textField = _index;
				keyboard_lastchar = "";
				
				//Set the Cursor Properties
				textCursorPosition = string_length(textFieldArray[_index]);
				textCursorIsVisible = true;
				alarm[0] = CURSOR_BLINK_SPEED;
			}
			else	//deactivate the text field when clicking outside the text field
				text_field_deactivate(_index, _x2 - _x1);
		}
		
		//Draw the Text Field
		draw_rectangle_colour(_x1, _y1, _x2, _y2, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);	//the text field box
		var _textY = _y1 + (_y2 - _y1) * 0.5;	//set the text Y origin
		
		//Update the String if the Text Field is Active
		var _string = (textField == _index) ? textFieldArray[_index] : textFieldPassiveArray[_index];
		var _stringPart = _string;/*string_copy(_string, textEdgeLeft + 1, textEdgeRight - textEdgeLeft);*/	//text functions are counting from 1 (that's why there's "+ 1" in many functions)
		var _textAlpha = 1;
		if (textField == _index)
		{
			//Update the String According to the Input
			_string = string_input(_string, charSet);
			var _stringPart = string_copy(_string, textEdgeLeft + 1, textEdgeRight - textEdgeLeft);
			textFieldArray[_index] = _string;
			
			//Update the Text Cursor Position
			if (keyboard_check_pressed(vk_right))
				textCursorPosition ++;
			if (keyboard_check_pressed(vk_left))
				textCursorPosition --;
			textCursorPosition = clamp(textCursorPosition, 0, string_length(_string));
		
			
			//Update the Text Edges
			var _textFieldWidth = _x2 - _x1;
			if (string_width(_string) > _textFieldWidth - 5)
			{
				//Set the Right Edge to the Cursor's Position on the First Text Edge Update
				if (textEdgeRight == 99)
					textEdgeRight = string_length(_string) - 1;
				
				//Update the Left Edge if the Cursor Exceeds the Right Edge
				if (textCursorPosition > textEdgeRight)
				{
					textEdgeRight = textCursorPosition;
					while (true)
					{
						textEdgeLeft ++;
						var _stringUpdate = string_copy(_string, textEdgeLeft + 1, textEdgeRight - textEdgeLeft);
						if (string_width(_stringUpdate) <= _textFieldWidth - 5)
							break;
					}
				}
				
				//Update the Right Edge if the Cursor Exceeds the Left Edge
				if (textCursorPosition < textEdgeLeft)
				{
					textEdgeLeft = textCursorPosition;
					while (true)
					{
						textEdgeRight --;
						var _stringUpdate = string_copy(_string, textEdgeLeft + 1, textEdgeRight - textEdgeLeft);
						if (string_width(_stringUpdate) <= _textFieldWidth - 5)
							break;
					}
				}
			}
			
			//Draw the Text Cursor
			_stringPart = string_copy(_string, textEdgeLeft + 1, textEdgeRight - textEdgeLeft);
			var _stringCursor = string_copy(_stringPart, 0, textCursorPosition - textEdgeLeft);
			var _textWidth = string_width(_stringCursor);
			var _textHeight = string_height("A");
			var _textCursorX = _x1 + 5 + _textWidth;
			var _textCursorY1 = _textY + _textHeight * 0.5;
			var _textCursorY2 = _textY - _textHeight * 0.5;
			draw_set_alpha(textCursorIsVisible);
			draw_line_width_colour(_textCursorX, _textCursorY1, _textCursorX, _textCursorY2, 1, c_white, c_white);
			draw_set_alpha(1);
			
			//Deactivate the Text Field on Enter Key Press
			if (keyboard_check_pressed(vk_enter))
				text_field_deactivate(_index, _x2 - _x1);
		}
		else _textAlpha = 0.5;
		
		//Draw the Text
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_text_transformed_colour(_x1 + 5, _textY, _stringPart, 1, 1, 0, c_white, c_white, c_white, c_white, _textAlpha);	//draw the string
		draw_set_valign(fa_top);
	}
	else
	{
		draw_set_alpha(0.5);
		draw_rectangle_colour(_x1, _y1, _x2, _y2, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);	//draw not abled text field box
		draw_set_alpha(1);
	}
}

/// Function for deactivating a text field.
/// variables needed: textFieldArray, textFieldPassiveArray, textField, 
///	textCursorPosition, textEdgeLeft, textEdgeRight
function text_field_deactivate(_index, _textFieldWidth)
{
	//Get the Part of the String That Fits Into the Text Field
	var _stringPart = textFieldArray[_index];
	var _endPosition = string_length(_stringPart);
	while (string_width(_stringPart) > _textFieldWidth - 5)
	{
		_endPosition --;
		_stringPart = string_copy(_stringPart, 1, _endPosition);
	}
	textFieldPassiveArray[_index] = _stringPart;
	
	//Reset Text Field Variables
	if (textField == _index)
	{
		textField = noone;
		textCursorPosition = 0;
		textEdgeLeft = 0;
		textEdgeRight = 99;
	}
}
