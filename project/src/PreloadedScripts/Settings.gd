extends Node

signal muted_changed(muted)
signal master_volume_changed(master_volume)

const MAX_VOLUME := 0.0
const MIN_VOLUME := -70.0

# Value between 0 - 1
var master_volume := 0.5 setget set_master_volume_range
var muted := false setget set_muted


func _ready() -> void:
	_update_master_bus_volume()
	call_deferred("_load_settings")


func _load_settings() -> void:
	set_master_volume_range(master_volume, true)


# Takes value between 0 and 1 (0 means min volume, 1 mens max volume)
func set_master_volume_range(val:float, force_notification:bool=false) -> void:
	var previous_master_volume := master_volume
	master_volume = val
	
	if val == 0.0:
		pass
	
	_update_master_bus_volume()
	
	if previous_master_volume != master_volume or force_notification:
		emit_signal("master_volume_changed", master_volume)
	
	var was_muted := muted
	muted = master_volume <= 0.0
	
	if was_muted != muted or force_notification:
		emit_signal("muted_changed", muted)


func set_muted(m:bool, force_notification:bool=false) -> void:
	var was_muted := muted
	
	muted = m
	
	if muted:
		AudioServer.set_bus_volume_db(0, MIN_VOLUME)
	else:
		_update_master_bus_volume()
	
	if was_muted != muted or force_notification:
		emit_signal("muted_changed", muted)


func _update_master_bus_volume() -> void:
	var volume : float = master_volume * (MAX_VOLUME - MIN_VOLUME) + MIN_VOLUME
	AudioServer.set_bus_volume_db(0, volume)
