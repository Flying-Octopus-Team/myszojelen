extends Node
class_name SteringBaseScript

var player : Character

var touchscreen_layer

export var wait_time_after_rotate := 0.2 
onready var _time_after_rotate := wait_time_after_rotate


func _ready() -> void:
	yield(get_parent(), "ready")
	touchscreen_layer = player.get_node("TouchScreenStering")


# To override
func steer(delta:float) -> void:
	pass
