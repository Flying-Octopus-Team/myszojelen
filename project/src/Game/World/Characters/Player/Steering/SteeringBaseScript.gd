extends Node
class_name SteeringBaseScript

var player : Character

var touchscreen_layer

export var texture : Resource = load("res://assets/Steering/wsad1_placeholder.png")

export var wait_time_after_rotate := 0.2 
onready var _time_after_rotate := wait_time_after_rotate

export var enabled := true


func _ready() -> void:
	yield(get_parent(), "ready")
	touchscreen_layer = player.get_node("TouchScreenSteering")


# To override
# Returns true if handles input, otherwise false
func steer(delta:float) -> bool:
	return false
