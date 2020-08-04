extends TileMap

signal tree_cutted
signal enemy_killed

const EMPTY_TILE = -1
const TREE_ID = 0
const FENCE_UP_ID = 1
const FENCE_DOWN_ID = 2

# You can only create an AStar node from code, not from the Scene tab
onready var astar_node = AStar.new()
# The Tilemap node doesn't have clear bounds so we're defining the map's limits here
export(Vector2) var map_size = Vector2(11, 11)

# The path start and end variables use setter methods
# You can find them at the bottom of the script
var path_start_position = Vector2() setget _set_path_start_position
var path_end_position = Vector2() setget _set_path_end_position

var _point_path = []

onready var obstacles = get_used_cells()
onready var _half_cell_size = Vector2()

var world_objects : Node
var back_fences : Node
var front_fences : Node

export var tex_100 : Texture
export var tex_101 : Texture


func _ready():
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells(walkable_cells_list)
	call_deferred("_tile_map_to_world")


func _tile_map_to_world() -> void:
	var all_tiles = get_used_cells()
	
	var scenes : Dictionary = {
		0: load("res://src/Game/World/Objects/Tree/Tree.tscn")
	}
	
	if not 100 in tile_set.get_tiles_ids():
		tile_set.create_tile(100)
		tile_set.tile_set_texture(100, tex_100)
		tile_set.create_tile(101)
		tile_set.tile_set_texture(101, tex_101)
	
	for tile_pos in all_tiles:
		var id = get_cell(tile_pos.x, tile_pos.y)
		
		if id >= 100: # Some WorldObject
			continue
		
		var obj : WorldObject
		
		if id == TREE_ID:
			obj = scenes[id].instance()
		else:
			obj = WorldObject.new()
			var sprite = Sprite.new()
			sprite.texture = tile_set.tile_get_texture(id)
			sprite.centered = false
			sprite.offset = tile_set.tile_get_texture_offset(id)
			sprite.offset.x = -sprite.texture.get_width() * 0.5
			sprite.flip_h = is_cell_x_flipped(tile_pos.x, tile_pos.y)
			obj.add_child(sprite)
		
		obj.position = map_to_world(tile_pos)
		
		if id == FENCE_UP_ID:
			front_fences.add_child(obj)
		elif id == FENCE_DOWN_ID:
			back_fences.add_child(obj)
		else:
			world_objects.add_child(obj)


# Loops through all cells within the map's bounds and
# adds all points to the astar_node, except the obstacles
func astar_add_walkable_cells(obstacles = []):
	var points_array = []
	for y in range(map_size.y):
		for x in range(map_size.x):
			var point = Vector2(x, y)
			if point in obstacles:
				continue

			points_array.append(point)
			# The AStar class references points with indices
			# Using a function to calculate the index from a point's coordinates
			# ensures we always get the same index with the same input point
			var point_index = calculate_point_index(point)
			# AStar works for both 2d and 3d, so we have to convert the point
			# coordinates from and to Vector3s
			astar_node.add_point(point_index, Vector3(point.x, point.y, 0.0))
	return points_array


# Once you added all points to the AStar node, you've got to connect them
# The points don't have to be on a grid: you can use this class
# to create walkable graphs however you'd like
# It's a little harder to code at first, but works for 2d, 3d,
# orthogonal grids, hex grids, tower defense games...
func astar_connect_walkable_cells(points_array):
	for point in points_array:
		astar_connect_walkable_point(point)


func astar_connect_walkable_point(point) -> void:
	var point_index = calculate_point_index(point)
	# For every cell in the map, we check the one to the top, right.
	# left and bottom of it. If it's in the map and not an obstalce,
	# We connect the current point with it
	var points_relative = PoolVector2Array([
		Vector2(point.x + 1, point.y),
		Vector2(point.x - 1, point.y),
		Vector2(point.x, point.y + 1),
		Vector2(point.x, point.y - 1)])
	for point_relative in points_relative:
		var point_relative_index = calculate_point_index(point_relative)

		if is_outside_map_bounds(point_relative):
			continue
		if not astar_node.has_point(point_relative_index):
			continue
		# Note the 3rd argument. It tells the astar_node that we want the
		# connection to be bilateral: from point A to B and B to A
		# If you set this value to false, it becomes a one-way path
		# As we loop through all points we can set it to false
		astar_node.connect_points(point_index, point_relative_index, false)


# This is a variation of the method above
# It connects cells horizontally, vertically AND diagonally
func astar_connect_walkable_cells_diagonal(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		for local_y in range(3):
			for local_x in range(3):
				var point_relative = Vector2(point.x + local_x - 1, point.y + local_y - 1)
				var point_relative_index = calculate_point_index(point_relative)

				if point_relative == point or is_outside_map_bounds(point_relative):
					continue
				if not astar_node.has_point(point_relative_index):
					continue
				astar_node.connect_points(point_index, point_relative_index, true)


func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func calculate_point_index(point):
	return point.x + map_size.x * point.y


func find_path(world_start, world_end):
	self.path_start_position = world_to_map(world_start)
	self.path_end_position = world_to_map(world_end)
	_recalculate_path()
	var path_world = []
	for point in _point_path:
		var point_world = map_to_world(Vector2(point.x, point.y)) + _half_cell_size
		path_world.append(point_world)
	return path_world


func _recalculate_path():
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	# This method gives us an array of points. Note you need the start and end
	# points' indices as input
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)


# Setters for the start and end path values.
func _set_path_start_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	path_start_position = value


func _set_path_end_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	path_end_position = value


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
#		return _update_pawn_position(pawn, cell_start, cell_target)
	
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


# Returns false when tree was cutted
func cut_tree(tree_map_pos:Vector2, cut_speed_modifier: float) -> bool:
	var tree = get_world_object_from_map_pos(tree_map_pos)
	if tree == null or tree.type != TREE_ID:
		print("No tree on ", tree_map_pos)
		return false
	
	if not tree.cut(cut_speed_modifier):
		set_cellv(tree_map_pos, EMPTY_TILE)
		obstacles.erase(tree_map_pos)
		var point_index = calculate_point_index(tree_map_pos)
		astar_node.add_point(point_index, Vector3(tree_map_pos.x, tree_map_pos.y, 0.0))
		astar_connect_walkable_point(tree_map_pos)
		emit_signal("tree_cutted")
		return false
	
	return true


func get_world_object_from_map_pos(map_pos:Vector2) -> WorldObject: 
	var obj : WorldObject
	obj = _get_world_object_from_map_pos_in_container(map_pos, world_objects)
	
	if obj != null:
		return obj
	
	obj = _get_world_object_from_map_pos_in_container(map_pos, back_fences)
	
	if obj != null:
		return obj
	
	obj = _get_world_object_from_map_pos_in_container(map_pos, front_fences)
	
	if obj != null:
		return obj
	
	return null


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
