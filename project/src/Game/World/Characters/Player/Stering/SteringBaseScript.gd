extends Node
class_name SteringBaseScript

var player : Character

var touchscreen_layer


func _ready() -> void:
	yield(get_parent(), "ready")
	touchscreen_layer = player.get_node("TouchScreenStering")


# To override
func steer(delta:float) -> void:
	pass
