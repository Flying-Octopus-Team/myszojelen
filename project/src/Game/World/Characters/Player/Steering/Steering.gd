extends Node

onready var player = get_parent()

var steering_type : int = 0

onready var SteeringDict : Dictionary = {
	"WSAD1_norot" : get_node("WSAD1_no_rotation"),
	"WSAD1_rot" : get_node("WSAD1_rotation"),
	"WSAD2_norot" : get_node("WSAD2_no_rotation"),
	"WSAD2_rot" : get_node("WSAD2_rotation"),
	"IOJK_norot" : get_node("IOJK_no_rotation"),
	"IOJK_rot" : get_node("IOJK_rotation"),
	"Numpad" : get_node("Numpad")
}

var SteeringDictKey : String

func _ready() -> void:
	for c in get_children():
		c.player = player
	


func steer(delta:float) -> void:
	get_parent().find_node("SteeringInfo").texture = SteeringDict[SteeringDictKey].texture
	SteeringDict[SteeringDictKey].steer(delta)

func ChangeSteering(new_steering_key) -> void:
	SteeringDictKey = new_steering_key
