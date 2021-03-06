extends Node

onready var player = get_parent()

var steering_type : int = 0
var steering_texture : Resource

onready var SteeringDict : Dictionary = {
	"4Directions" : get_node("4Directions"),
	"8Directions" : get_node("8Directions"),
	"VirtualPad": get_node("Joystick8Directions"),
	"Pad": get_node("Joystick8Directions"),
	"Rotations": get_node("Rotating")
}

var SteeringDictKey : String = "4Directions"

func _ready() -> void:
	for c in get_children():
		c.player = player
	


func steer(delta:float) -> void:
	change_steering()
	SteeringDict[SteeringDictKey].steer(delta)

func change_steering() -> void:
	SteeringDictKey = SteeringSave.steering_type
	$"../TouchScreenSteering".set_visible(SteeringDictKey == "VirtualPad")
