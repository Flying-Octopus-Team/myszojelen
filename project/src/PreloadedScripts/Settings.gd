extends Node

const SETTINGS_FILE_PATH := "user://settings.json"

const MAX_VOLUME := 0.0
const MIN_VOLUME := -80.0

signal audio_effects_volume_changed(value)

var master_volume := 1.0 setget set_master_volume

var audio_effects_volume : float = 1.0 setget set_audio_effects_volume

enum Language_enum {english, polish}

var language : int = Language_enum.english setget set_language

func _init() -> void:
	_load_from_file()


func _load_from_file() -> void:
	var file := File.new()
	
	if file.file_exists(SETTINGS_FILE_PATH):
		file.open(SETTINGS_FILE_PATH, File.READ)
		var str_file_content := file.get_as_text()
		file.close()

		if str_file_content:
			var settings_dict = JSON.parse(str_file_content).result
			
			if settings_dict:

				if settings_dict.has("master_volume"):
					master_volume = settings_dict["master_volume"]
				
				if settings_dict.has("audio_effects"):
					set_audio_effects_volume(settings_dict["audio_effects"], false)

				if settings_dict.has("language"):
					language = settings_dict["language"]
				
				
	
	MusicPlayer.set_volume(master_volume)

func set_master_volume(value: float, needs_save : bool = true) -> void:
	master_volume = value
	if needs_save: _save_to_file()

func set_audio_effects_volume(value: float, needs_save : bool = true) -> void:
	audio_effects_volume = value
	emit_signal("audio_effects_volume_changed", audio_effects_volume)
	if needs_save: _save_to_file()

func set_language(value: int) -> void:
	language = value
	_save_to_file()

func _save_to_file() -> void:
	var file := File.new()
	file.open(SETTINGS_FILE_PATH, File.WRITE)
	
	var dict_to_save := {
		"master_volume": master_volume,
		"audio_effects": audio_effects_volume,
		"level": GameSave.get_level(),
		"language": language
	}
	
	var str_dict := JSON.print(dict_to_save)
	file.store_string(str_dict)
	
	file.close()
	
