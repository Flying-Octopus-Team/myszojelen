extends MarginContainer

var current_steering_type : String
var path_to_current_steering_type : String

func change_steering(steering_name, parent_name) -> void :
	if !path_to_current_steering_type.empty():
		get_node(path_to_current_steering_type).downscale()
	path_to_current_steering_type = "ScrollContainer/GridContainer/%s/%s" % [parent_name, steering_name]
	current_steering_type = steering_name
	get_node(path_to_current_steering_type).upscale()
	var NextLevelBtn = get_node("../ContinueBtn")
	NextLevelBtn.disabled = false


func reset() -> void:
	if !path_to_current_steering_type.empty():
		get_node(path_to_current_steering_type).downscale()
