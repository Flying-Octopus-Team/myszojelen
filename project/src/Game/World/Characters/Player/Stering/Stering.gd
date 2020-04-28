extends Node

onready var player = get_parent()

var stering_type : int = 0


func _ready() -> void:
	for c in get_children():
		c.player = player


func steer(delta:float) -> void:
	for c in get_children():
		if not c.enabled:
			continue
		
		if c.steer(delta):
			get_tree().set_input_as_handled()
			return
