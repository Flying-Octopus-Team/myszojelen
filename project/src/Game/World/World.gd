extends Node

signal tree_cutted
signal level_won
signal end_of_levels

signal steering_chosen

export(Array, PackedScene) var LevelScenes

var level : BaseLevel = null
var current_level = -1

signal world_ready

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
	yield(self, "steering_chosen")
	emit_signal("world_ready")


func clear_level() -> void:
	if level:
		level.free()


func reset_level() -> void:
	_prepare_current_level()
	yield(self, "steering_chosen")
	emit_signal("world_ready")


func _prepare_current_level() -> void:
	clear_level()
	
	$"../Interface/SteeringScreen".show()
	yield(get_node("../Interface/SteeringScreen/ContinueBtn"), "pressed")
	$"../Interface/SteeringScreen".hide()
	
	level = LevelScenes[current_level].instance()
	level.connect("tree_cutted", self, "emit_signal", ["tree_cutted"])
	level.connect("level_won", self, "_on_level_won")
	add_child(level)
	$"../Interface/Control/HUD".show()
	
	var Steering = $"../Interface/SteeringScreen/SteeringContainer".current_steering_type
	level.find_node("Steering").ChangeSteering(Steering)
	
	emit_signal("steering_chosen")


func count_trees() -> int:
	return level.count_trees()
