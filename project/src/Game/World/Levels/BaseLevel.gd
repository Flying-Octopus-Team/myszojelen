extends Node2D
class_name BaseLevel

signal tree_cut
signal level_won

onready var map : TileMap = $Map
onready var world_objects : YSort = $WorldObjects

var enemies_left : int


func _ready() -> void:
	var characters = get_tree().get_nodes_in_group("character")
	
	map.world_objects = world_objects
	
	for c in characters:
		c.tile_map = map
		c.world_objects = world_objects
		c.setup_map()
		
		if c is Enemy:
			enemies_left += 1
	
	map.connect("tree_cut", self, "_on_tree_cut")
	map.connect("enemy_killed", self, "_on_ememy_killed")

	var walkable_cells_list = map.astar_add_walkable_cells(map.obstacles)
	map.astar_connect_walkable_cells(walkable_cells_list)

func _on_tree_cut() -> void:
	emit_signal("tree_cut")


func _on_ememy_killed() -> void:
	enemies_left -= 1
	
	if enemies_left <= 0:
		emit_signal("level_won")


func count_trees() -> int:
	var trees_arr : Array = map.get_used_cells_by_id_in_map_range(map.TREE_ID)
	var trees_count := trees_arr.size()
	return trees_count
