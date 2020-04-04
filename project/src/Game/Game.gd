extends Node

signal game_over
signal level_won
signal end_of_levels

export var fade_color : Color

onready var world : Node2D = $World
onready var interface : CanvasLayer = $Interface
onready var fade_layer = $FadeLayer

var trees_left : int


func _ready() -> void:
	world.connect("tree_cutted", self, "_on_tree_cutted")
	world.connect("level_won", self, "_on_level_won")
	connect("game_over", interface, "_on_game_over")
	connect("level_won", interface, "_on_level_won")
	connect("end_of_levels", interface, "_on_end_of_levels")
	
	_prepare_trees_left()
	
	_start()


func _start() -> void:
	get_tree().paused = true
	
	fade_layer.fade_in(fade_color)
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


func _on_level_won() -> void:
	print("Level won")
	_fade("_next_level")


func _next_level() -> void:
	world.clear_level()
	world.next_level()
	_prepare_trees_left()


func _on_end_of_levels() -> void:
	print("END OF THE GAME")
	_fade("_finish_game")


func _finish_game() -> void:
	world.clear_level()
	emit_signal("end_of_levels")


func _fade(callback:String) -> void:
	get_tree().paused = true
	
	fade_layer.fade_out(fade_color)
	yield(fade_layer, "faded_out")
	
	call(callback)
	
	fade_layer.fade_in(fade_color)
	yield(fade_layer, "faded_in")
	
	get_tree().paused = false
