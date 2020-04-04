extends Node

signal tree_cutted
signal level_won
signal end_of_levels

export(Array, PackedScene) var LevelScenes

var level : BaseLevel
var current_level = -1

var fade_layer


func _ready() -> void:
	next_level()


func _on_level_won() -> void:
	emit_signal("level_won")


func clear_level() -> void:
	level.free()


func next_level() -> void:
	current_level += 1
	
	if current_level >= LevelScenes.size():
		emit_signal("end_of_levels")
		return
	
	level = LevelScenes[current_level].instance()
	level.connect("tree_cutted", self, "emit_signal", ["tree_cutted"])
	level.connect("level_won", self, "emit_signal", ["level_won"])
	add_child(level)


func count_trees() -> int:
	return level.count_trees()
