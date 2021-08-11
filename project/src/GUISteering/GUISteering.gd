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

var steering_dict_key : String = "4Directions"

var steering_dict : Dictionary = {
	"4Directions": GUI4Directions.new(),
	"8Directions": GUI8Directions.new(),
	"VirtualPad": GUIJoystick.new(),
	"Pad": GUIJoystick.new(),
	"Rotations": GUI4Directions.new(),
	"none": GUI4Directions.new()
}

func get_action(event) -> int:

	var action : int = steering_dict["Pad"].get_action(event, gui_actions)
	if action == gui_actions.none:
		action = steering_dict[steering_dict_key].get_action(event, gui_actions)

	return action
