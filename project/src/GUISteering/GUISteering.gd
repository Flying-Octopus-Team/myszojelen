extends Node

class_name GUISteering

enum gui_actions {
	up,
	left,
	right,
	down,
	press,
	none
}

var default_steering : GUI4Directions = GUI4Directions.new()
var alternative_steering : GUI8Directions = GUI8Directions.new()
var pad : GUIJoystick = GUIJoystick.new()

func get_action(event) -> int:

	var action : int = pad.get_action(event, gui_actions)
	if action == gui_actions.none:
		if SteeringSave.steering_type == "8Directions":
			action = alternative_steering.get_action(event, gui_actions)
		else:
			action = default_steering.get_action(event, gui_actions)

	return action


func is_pause_pressed() -> bool:
	var pressed : bool = pad.is_action_pressed("pad_pause")
	if not pressed:
		if SteeringSave.steering_type == "8Directions":
			pressed = alternative_steering.is_action_pressed("8directions_pause")
		else:
			pressed = default_steering.is_action_pressed("4directions_pause")

	return pressed

