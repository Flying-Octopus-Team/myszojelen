extends Node

onready var player = get_parent()

var stering_type : int = 0


func _ready() -> void:
	for c in get_children():
		c.player = player


func steer(delta:float) -> void:
	for c in get_children():
		c.steer(delta)
