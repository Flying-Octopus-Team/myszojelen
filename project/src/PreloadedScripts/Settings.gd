extends Node

const FULL_VOLUME := 0.0
const NO_VOLUME := -100.0

var music_volume := 0.0 setget set_music_volume


func set_music_volume(vol:float) -> void:
	music_volume = vol
	AudioServer.set_bus_volume_db(0, vol)
