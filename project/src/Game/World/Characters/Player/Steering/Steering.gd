extends Node

onready var player = get_parent()

var steering_type : int = 0
var steering_texture : Resource

onready var SteeringDict : Dictionary = {
	"WSAD1NoRot" : get_node("WSAD1NoRotation"),
	"WSAD1Rot" : get_node("WSAD1Rotation"),
	"WSAD2NoRot" : get_node("WSAD2NoRotation"),
	"WSAD2Rot" : get_node("WSAD2Rotation"),
	"IOJKNoRot" : get_node("IOJKNoRotation"),
	"IOJKRot" : get_node("IOJKRotation"),
	"Numpad" : get_node("Numpad"),
	"VirtualPad": get_node("Joystick8Directions"),
	"ManualPad": get_node("Joystick8Directions"),
	"KeyboardRotating": get_node("KeyboardRotating")
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
