extends TileMap

signal tree_cut
signal enemy_killed

const EMPTY_TILE = -1
const TREE_ID = 0
const FENCE_UP_ID = 1
const FENCE_DOWN_ID = 2

export(Vector2) var map_size = Vector2(11, 11)
onready var astar_node = PathFinding.new(self, map_size)

onready var obstacles = get_used_cells()

var world_objects : Node

export var tex_100 : Texture
export var tex_101 : Texture


func _ready():
	call_deferred("_tile_map_to_world")


func _tile_map_to_world() -> void:
	var all_tiles = get_used_cells()
	
	var scenes : Dictionary = {
		0: load("res://src/Game/World/Objects/Tree/Tree.tscn")
	}
	
	tile_set.tile_set_texture(TREE_ID, tex_100)
	
	if not 100 in tile_set.get_tiles_ids():
		tile_set.create_tile(100)
		tile_set.tile_set_texture(100, tex_100)
		tile_set.create_tile(101)
		tile_set.tile_set_texture(101, tex_101)
		
	for character in get_children():
		var obj: WorldObject = WorldObject.new()

		obj.position = character.position
		obj.type = character.type
		obj.tilemap_path = character.get_path()
		
		world_objects.add_child(obj)
	
	for tile_pos in all_tiles:
		var id = get_cell(tile_pos.x, tile_pos.y)
		
		if id >= 100: # Some WorldObject
			continue
		
		var obj : WorldObject = WorldObject.new()
		
		if id == TREE_ID:
			obj.type = TREE_ID
			
			var new_tree : WorldObject = scenes[id].instance()
			new_tree.position = map_to_world(tile_pos)
			
			add_child(new_tree)
			obj.tilemap_path = new_tree.get_path()
		
		obj.position = map_to_world(tile_pos)
		
		world_objects.add_child(obj)

func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	return _try_to_move(pawn, cell_start, cell_target)


func request_move_to(pawn, cell_target):
	var cell_start = world_to_map(pawn.position)
	return _try_to_move(pawn, cell_start, cell_target)


func request_move_world_pos(pawn, world_pos):
	var cell_start = world_to_map(pawn.position)
	var cell_target = world_to_map(world_pos)
	return _try_to_move(pawn, cell_start, cell_target)


func _try_to_move(pawn, cell_start, cell_target):
	var cell_target_type = get_cellv(cell_target)
	
	if cell_target_type == EMPTY_TILE:
		return map_to_world(cell_target)
	
	return null


func _update_pawn_position(pawn, cell_start, cell_target) -> Vector2:
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, EMPTY_TILE)
	return map_to_world(cell_target)


func get_used_cells_by_id_in_map_range(id) -> Array:
	var cells = []
	
	for y in range(map_size.y):
		for x in range(map_size.x):
			var cell = get_cell(x, y)
			if cell == id:
				cells.push_back(Vector2(x, y))
	
	return cells


# Returns false when tree was cut
func cut_tree(tree_map_pos:Vector2, cut_speed_modifier: float) -> bool:
	var tree = get_world_object_from_map_pos(tree_map_pos)
	if tree == null or tree.type != TREE_ID:
		print("No tree on ", tree_map_pos)
		return false
	
	if not get_node(tree.tilemap_path).cut(cut_speed_modifier):
		set_cellv(tree_map_pos, EMPTY_TILE)
		obstacles.erase(tree_map_pos)
		var point_index = astar_node.calculate_point_index(tree_map_pos)
		astar_node.add_point(point_index, Vector3(tree_map_pos.x, tree_map_pos.y, 0.0))
		astar_node.update_walkable_point(tree_map_pos)
		emit_signal("tree_cut")
		return false
	
	return true


func get_world_object_from_map_pos(map_pos:Vector2) -> WorldObject: 
	var obj : WorldObject
	obj = _get_world_object_from_map_pos_in_container(map_pos, world_objects)
	
	return obj


func _get_world_object_from_map_pos_in_container(map_pos:Vector2, container:Node) -> WorldObject:
	for obj in container.get_children():
		if not obj is WorldObject:
			continue
		
		if obj.type != obj.Type.EMPTY:
			if world_to_map(obj.position) == map_pos:
				return obj
	
	return null

func on_enemy_died() -> void:
	emit_signal("enemy_killed")
