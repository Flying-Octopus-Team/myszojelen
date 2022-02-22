extends Node

class_name GUIBaseSteeringScript

func get_action(event, gui_enum) -> int:
	return gui_enum.none

func is_action_pressed(action: String) -> bool:
	return false
