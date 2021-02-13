extends Node
class_name SteeringBaseScript

var player : Character

var touchscreen_layer

export var texture : Resource

export var wait_time_after_rotate := 0.2 
onready var _time_after_rotate := wait_time_after_rotate

var facing_enum

func _ready() -> void:
	yield(get_parent(), "ready")
	touchscreen_layer = player.get_node("TouchScreenSteering")
	facing_enum = player.Facing


# To override
# Returns direction of player's movement
func _get_direction() -> int:
	return -1

# To override
# Moves player in set direction
func steer(delta:float) -> void:
	return
