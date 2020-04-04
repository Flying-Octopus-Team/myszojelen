extends Node

signal game_over

onready var world : Node2D = $World
onready var interface : CanvasLayer = $Interface
onready var fade_layer = $FadeLayer

var trees_left : int


func _ready() -> void:
	world.connect("tree_cutted", self, "_on_tree_cutted")
	connect("game_over", interface, "_on_game_over")
	call_deferred("_prepare_trees_left")
	
	fade_layer.fade_in(Color.black)
	
	get_tree().paused = true
	
	yield(fade_layer, "faded_in")
	
	get_tree().paused = false


func _prepare_trees_left() -> void:
	trees_left = world.count_trees()
	interface.set_trees_left(trees_left)


func _on_tree_cutted() -> void:
	trees_left -= 1
	interface.set_trees_left(trees_left)
	
	if trees_left <= 0:
		emit_signal("game_over")
