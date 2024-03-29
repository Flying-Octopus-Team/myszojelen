extends Node
class_name SteeringBaseScript

var player : Character

var touchscreen_layer

export var wait_time_after_rotate := 0.2 
onready var _time_after_rotate := wait_time_after_rotate

func _ready() -> void:
	yield(get_parent(), "ready")
	touchscreen_layer = player.get_node("TouchScreenSteering")


# To override
# Returns direction of player's movement
func _get_direction() -> int:
	return -1

# To override
# Moves player in set direction
func steer(delta:float) -> void:
	return


func _pause_game() -> void:
	var interface = find_parent("Game").get_node("Interface")
	if interface.get_node("Settings/TextureRect/PauseScreen").should_handle_input and interface.current_screen == interface.Screen.NONE:
		interface.get_node("Control/HUD/PauseBtn").emit_signal("pressed")
