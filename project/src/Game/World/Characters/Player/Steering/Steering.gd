extends Node

onready var player = get_parent()

var steering_type : int = 0
var steering_texture : Resource

onready var SteeringDict : Dictionary = {
	"4Directions" : get_node("4Directions"),
	"8Directions" : get_node("8Directions"),
	"VirtualPad": get_node("Joystick8Directions"),
	"ManualPad": get_node("Joystick8Directions"),
	"Rotating": get_node("Rotating")
}

var SteeringDictKey : String = "WSAD1NoRot"

func _ready() -> void:
	for c in get_children():
		c.player = player
	


func steer(delta:float) -> void:
	$"../SteeringInfoCanvas/SteeringInfo".texture = steering_texture
	SteeringDict[SteeringDictKey].steer(delta)

func ChangeSteering(new_steering_key, new_steering_texture) -> void:
	SteeringDictKey = new_steering_key
	steering_texture = new_steering_texture
	$"../TouchScreenSteering".set_visible(SteeringDictKey == "VirtualPad")
