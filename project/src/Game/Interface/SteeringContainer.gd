extends MarginContainer

signal steering_set
var steering_type : String

func set_steering(steering_name) -> void:
	steering_type = steering_name
	emit_signal("steering_set")
	get_tree().paused = false
