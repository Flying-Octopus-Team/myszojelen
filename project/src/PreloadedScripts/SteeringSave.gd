extends Node

const CONFIG_FILE = "user://input.cfg"
const DEFAULT_CONFIG_FILE = "user://default_input.cfg"
const INPUT_ACTIONS = ["rotation_left", "rotation_right", "rotation_up", "4directions_left", "4directions_up", "4directions_right", "4directions_down", "8directions_up", "8directions_up_left", "8directions_up_right", "8directions_left", "8directions_right", "8directions_down", "8directions_down_left", "8directions_down_right", "shot_pad", "shot_keyboard"]

const GAME_VERSION = 1.3

var steering_type : String = "none" setget set_steering_type
var config_file : ConfigFile

func _init() -> void:
	_load_input()


func _load_input() -> void:

	_create_default_file_if_needed()

	config_file = ConfigFile.new()

	var err = config_file.load(CONFIG_FILE)
	if err == OK:
		_load_from_file()
	else:
		save_input()


func _create_default_file_if_needed() -> void:
	config_file = ConfigFile.new()

	var err = config_file.load(DEFAULT_CONFIG_FILE)

	if err != OK:
		save_input(DEFAULT_CONFIG_FILE)


func _load_from_file() -> void:

	if not _check_version():
		return

	for action in config_file.get_section_keys("steering"):
		InputMap.action_erase_event(action, InputMap.get_action_list(action)[0])

		_set_action_to_keybind(action)

	steering_type = config_file.get_value("steering_type", "name")


func _check_version() -> bool:
	var version = config_file.get_value("version", "value", 1.0)
	
	if version != GAME_VERSION:
		reset_file()
		return false

	return true


func _set_action_to_keybind(action) -> void:
	if config_file.get_value("steering", action) == "":
		return

	var action_value : String = config_file.get_value("steering", action)

	if action_value.begins_with("InputEventJoypadButton"):
		InputMap.action_add_event(action, _parse_input_joypadbutton_from_string(action_value))
	else:
		var scancode = OS.find_scancode_from_string(config_file.get_value("steering", action))

		var event = InputEventKey.new()
		event.scancode = scancode

		InputMap.action_add_event(action, event)


func _parse_input_joypadbutton_from_string(value: String) -> InputEventJoypadButton:
	value = value.trim_prefix("InputEventJoypadButton :")

	var properties : PoolStringArray = value.split(", ")

	var event : InputEventJoypadButton = InputEventJoypadButton.new()
	for property in properties:
		var property_array : PoolStringArray = property.split("=")

		event.set_indexed(property_array[0], int(property_array[1]))

	return event

func save_input(save_file_name: String = CONFIG_FILE) -> void:
	for action in INPUT_ACTIONS:
		_save_action_to_file(action)
	
	config_file.set_value("steering_type", "name", steering_type)
	config_file.set_value("version", "value", GAME_VERSION)

	config_file.save(save_file_name)


func reset_file() -> void:
	var directory = Directory.new()

	directory.remove(CONFIG_FILE)

	config_file = ConfigFile.new()

	var err = config_file.load(DEFAULT_CONFIG_FILE)
	if err == OK:
		_load_from_file()

	save_input()
	get_tree().reload_current_scene()



func _save_action_to_file(action: String) -> void:
	var action_list = InputMap.get_action_list(action)
	if not action_list.empty():
		var action_event = action_list[0]

		if action_event is InputEventJoypadButton:
			config_file.set_value("steering", action, action_event.as_text())
		else:
			var scancode = OS.get_scancode_string(action_event.scancode)
			config_file.set_value("steering", action, scancode)
	else:
		config_file.set_value("steering", action, "")


func set_steering_type(value: String) -> void:
	steering_type = value
	save_input()
