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
