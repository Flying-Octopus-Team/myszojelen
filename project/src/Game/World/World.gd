extends Node

signal tree_cut
signal level_won
signal end_of_levels

export(Array, PackedScene) var LevelScenes

var level : BaseLevel = null


func _on_level_won() -> void:
	if GameSave.get_level() >= LevelScenes.size()-1: # The last level
		emit_signal("end_of_levels")
		return
	
	emit_signal("level_won")


func next_level() -> void:
	_prepare_current_level()


func clear_level() -> void:
	if level:
		level.free()


func reset_level() -> void:
	_prepare_current_level()


func _prepare_current_level() -> void:
	clear_level()
	
	level = LevelScenes[GameSave.get_level()].instance()
	level.connect("tree_cut", self, "emit_signal", ["tree_cut"])
  
	level.connect("level_won", self, "_on_level_won")
	add_child(level)
	$"../Interface/Control/HUD".show()
	
	$"../Interface/SteeringScreen".show()
	yield(get_node("../Interface/SteeringScreen/SteeringContainer"), "steering_set")
	$"../Interface/SteeringScreen".hide()
	
	var Steering = $"../Interface/SteeringScreen/SteeringContainer".steering_type
	var Steering_texture =$"../Interface/SteeringScreen/SteeringContainer".steering_texture
	level.find_node("Steering").ChangeSteering(Steering, Steering_texture)


func count_trees() -> int:
	return level.count_trees()
