extends MarginContainer

var current_steering_type : String

func change_steering(steering_name) -> void :
	if !current_steering_type.empty():
		find_node(current_steering_type).downscale()
	current_steering_type = steering_name
	find_node(current_steering_type).upscale()
	var NextLevelBtn = get_parent().find_node("ContinueBtn")
	NextLevelBtn.disabled = false


func reset() -> void:
	if !current_steering_type.empty():
		find_node(current_steering_type).downscale()
