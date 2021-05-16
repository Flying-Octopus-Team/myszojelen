extends Node

const CONFIG_FILE = "user://input.cfg"
const INPUT_ACTIONS = ["rotation_left", "rotation_right", "rotation_up", "4directions_left", "4directions_up", "4directions_right", "4directions_down", "8directions_up", "8directions_up_left", "8directions_up_right", "8directions_left", "8directions_right", "8directions_down", "8directions_down_left", "8directions_down_right"]

var steering_type : String = "none" setget set_steering_type
var config_file : ConfigFile

func _init() -> void:
	_load_input()


func _load_input() -> void:
	config_file = ConfigFile.new()

	var err = config_file.load(CONFIG_FILE)
	if err == OK:
		for action in config_file.get_section_keys("steering"):
			InputMap.action_erase_event(action, InputMap.get_action_list(action)[0])
			if config_file.get_value("steering", action) == "":
				continue

			var scancode = OS.find_scancode_from_string(config_file.get_value("steering", action))

			var event = InputEventKey.new()
			event.scancode = scancode

			InputMap.action_add_event(action, event)

		steering_type = config_file.get_value("steering_type", "name")
	else:
		save_input()


func save_input() -> void:
	for action in INPUT_ACTIONS:
		var action_list = InputMap.get_action_list(action)
		if not action_list.empty():
			var action_event = action_list[0]

			var scancode = OS.get_scancode_string(action_event.scancode)
			config_file.set_value("steering", action, scancode)
		else:
			config_file.set_value("steering", action, "")
	
	config_file.set_value("steering_type", "name", steering_type)
	config_file.save(CONFIG_FILE)


func set_steering_type(value: String) -> void:
	steering_type = value
	save_input()
