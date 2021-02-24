extends MarginContainer

signal steering_set
var steering_type : String
var steering_texture : Resource

func set_steering(steering_name, steering_texture_normal) -> void:
	steering_type = steering_name
	steering_texture = steering_texture_normal
	emit_signal("steering_set")
	get_tree().paused = false
