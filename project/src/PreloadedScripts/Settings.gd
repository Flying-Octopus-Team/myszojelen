extends Node

signal muted_changed(muted)
signal master_volume_changed(master_volume)

const SETTINGS_FILE_PATH := "user://settings.json"

const MAX_VOLUME := 0.0
const MIN_VOLUME := -70.0

# Value between 0 - 1
var master_volume := 0.8 setget set_master_volume
var muted := false setget set_muted

var level : int = -1 setget set_level

func _init() -> void:
	_load_from_file()


func _load_from_file() -> void:
	var file := File.new()
	var needs_save := true
	
	if file.file_exists(SETTINGS_FILE_PATH):
		file.open(SETTINGS_FILE_PATH, File.READ)
		var str_file_content := file.get_as_text()
		
		if str_file_content:
			var settings_dict = JSON.parse(str_file_content).result
			
			if settings_dict:
				if settings_dict.has("master_volume"):
					master_volume = settings_dict["master_volume"]
				if settings_dict.has("level"):
					level = settings_dict["level"]
				
				needs_save = false
	
	set_master_volume(master_volume, true, false)
	
	if needs_save:
		_save_to_file()


# Takes value between 0 and 1 (0 means min volume, 1 mens max volume)
func set_master_volume(val:float, override_muted:bool=true, save:bool=true) -> void:
	var previous_master_volume := master_volume
	master_volume = val
	
	_update_master_bus_volume()
	
	if previous_master_volume != master_volume:
		emit_signal("master_volume_changed", master_volume)
	
	if override_muted:
		var was_muted := muted
		muted = master_volume <= 0.0
		
		if was_muted != muted:
			emit_signal("muted_changed", muted)
	
	if save:
		_save_to_file()


func set_muted(m:bool) -> void:
	var was_muted := muted
	
	muted = m
	
	if muted:
		AudioServer.set_bus_volume_db(0, MIN_VOLUME)
	else:
		_update_master_bus_volume()
	
	if was_muted != muted:
		emit_signal("muted_changed", muted)


func _update_master_bus_volume() -> void:
	var volume : float = master_volume * (MAX_VOLUME - MIN_VOLUME) + MIN_VOLUME
	AudioServer.set_bus_volume_db(0, volume)

func set_level(value: int, save: bool = true) -> void:
	level = value
	
	if save:
		_save_to_file()

func _save_to_file() -> void:
	var file := File.new()
	file.open(SETTINGS_FILE_PATH, File.WRITE)
	
	var dict_to_save := {
		"master_volume": master_volume,
		"level": level
	}
	
	var str_dict := JSON.print(dict_to_save)
	file.store_string(str_dict)
	
	file.close()
	
