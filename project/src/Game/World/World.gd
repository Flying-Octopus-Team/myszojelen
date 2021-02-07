extends Node

signal tree_cutted
signal level_won
signal end_of_levels

export(Array, PackedScene) var LevelScenes

var level : BaseLevel = null
var current_level = -1


func reset() -> void:
	current_level = -1


func _on_level_won() -> void:
	if current_level >= LevelScenes.size()-1: # The last level
		emit_signal("end_of_levels")
		return
	
	emit_signal("level_won")


func next_level() -> void:
	current_level += 1
	_prepare_current_level()


func clear_level() -> void:
	if level:
		level.free()


func reset_level() -> void:
	_prepare_current_level()


func _prepare_current_level() -> void:
	clear_level()
	level = LevelScenes[current_level].instance()
	level.connect("tree_cutted", self, "emit_signal", ["tree_cutted"])
	level.connect("level_won", self, "_on_level_won")
	add_child(level)
	get_node("../Interface/").find_node("HUD").visible = true
	var Steering = get_node("../Interface/").find_node("SteeringContainer").current_steering_type
	level.find_node("Steering").ChangeSteering(Steering)


func count_trees() -> int:
	return level.count_trees()
