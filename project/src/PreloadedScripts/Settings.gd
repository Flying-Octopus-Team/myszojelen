extends Node

const SETTINGS_FILE_PATH := "user://settings.json"

const MAX_VOLUME := 0.0
const MIN_VOLUME := -70.0

# Value between 0 - 1
var master_volume := 0.8

func _init() -> void:
	_load_from_file()


func _load_from_file() -> void:
	var file := File.new()
	var needs_save := true
	
	if file.file_exists(SETTINGS_FILE_PATH):
		file.open(SETTINGS_FILE_PATH, File.READ)
		var str_file_content := file.get_as_text()
		file.close()

		if str_file_content:
			var settings_dict = JSON.parse(str_file_content).result
			
			if settings_dict:
				if settings_dict.has("master_volume"):
					master_volume = settings_dict["master_volume"]
				
				needs_save = false
	
	MusicPlayer.set_volume(master_volume)
	
	if needs_save:
		_save_to_file()

func _save_to_file() -> void:
	var file := File.new()
	file.open(SETTINGS_FILE_PATH, File.WRITE)
	
	var dict_to_save := {
		"master_volume": master_volume,
		"level": GameSave.get_level()
	}
	
	var str_dict := JSON.print(dict_to_save)
	file.store_string(str_dict)
	
	file.close()
	
