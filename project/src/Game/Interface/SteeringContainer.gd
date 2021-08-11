extends FocusableContainer

signal steering_set

func set_steering(steering_name, steering_texture_normal) -> void:
	SteeringSave.set_steering_type(steering_name)

	get_tree().paused = false
	emit_signal("steering_set")
