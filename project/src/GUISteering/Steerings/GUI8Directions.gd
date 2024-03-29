extends GUIBaseSteeringScript

class_name GUI8Directions

func get_action(event, gui_enum) -> int:
	if not event is InputEventKey:
		return gui_enum.none
	
	if _if_player_pressed_action("8directions_up", event):
		return gui_enum.up
	elif _if_player_pressed_action("8directions_down", event):
		return gui_enum.down
	elif _if_player_pressed_action("8directions_left", event):
		return gui_enum.left
	elif _if_player_pressed_action("8directions_right", event):
		return gui_enum.right
	elif _if_player_pressed_action("shot_keyboard", event):
		return gui_enum.press
		
	return gui_enum.none


func _if_player_pressed_action(action: String, event: InputEventKey) -> bool:
	return not InputMap.get_action_list(action).empty() and InputMap.get_action_list(action)[0].scancode == event.scancode


func is_action_pressed(action: String) -> bool:
	return not InputMap.get_action_list(action).empty() and Input.is_action_pressed(action)
