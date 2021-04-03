extends Node

const SETTINGS_FILE_PATH := "user://settings.json"

var level: int = -1 setget set_level, get_level

func _init():
	_load_level()

func _load_level() -> void:
	var file = File.new()

	if file.file_exists(SETTINGS_FILE_PATH):
		file.open(SETTINGS_FILE_PATH, File.READ)
		var str_file_content : String = file.get_as_text()
		
		if str_file_content:
			var settings_dict = JSON.parse(str_file_content).result
			
			if settings_dict:
				if settings_dict.has("level"):
					level = settings_dict["level"]

func _save_level() -> void:

	var save_dictionary : Dictionary = _load_save_dictionary()

	var file := File.new()
	file.open(SETTINGS_FILE_PATH, File.WRITE)
	
	save_dictionary["level"] = level
	
	var str_dict := JSON.print(save_dictionary)
	file.store_string(str_dict)
	
	file.close()

func _load_save_dictionary() -> Dictionary:
	var file = File.new()

	if file.file_exists(SETTINGS_FILE_PATH):
		file.open(SETTINGS_FILE_PATH, File.READ)
		var str_file_content : String = file.get_as_text()
		
		if str_file_content:
			return JSON.parse(str_file_content).result
	return {}

func set_level(value: int) -> void:
	level = value
	_save_level()

func get_level() -> int:
	return level

func next_level() -> void:
	set_level(level+1)
	