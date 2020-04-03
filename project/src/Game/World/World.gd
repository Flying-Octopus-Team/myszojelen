extends Node

signal tree_cutted

export(PackedScene) var LevelScene

var level : BaseLevel


func _ready() -> void:
	level = LevelScene.instance()
	level.connect("tree_cutted", self, "emit_signal", ["tree_cutted"])
	add_child(level)


func count_trees() -> int:
	return level.count_trees()
