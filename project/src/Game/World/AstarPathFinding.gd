extends AStar

class_name PathFinding

var tile_map : TileMap
var map_size: Vector2
var _point_path = []

func _init(tile_map: TileMap, map_size: Vector2):
	self.tile_map = tile_map
	self.map_size = map_size

# Loops through all cells within the map's bounds and
# adds all points to the astar_node, except the obstacles
func add_walkable_cells(obstacles = []):
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
			add_point(point_index, Vector3(point.x, point.y, 0.0))
	return points_array


# Once you added all points to the AStar node, you've got to connect them
# The points don't have to be on a grid: you can use this class
# to create walkable graphs however you'd like
# It's a little harder to code at first, but works for 2d, 3d,
# orthogonal grids, hex grids, tower defense games...
func connect_walkable_cells(points_array):
	for point in points_array:
		update_walkable_point(point)


func update_walkable_point(point, connect_points: bool = true) -> void:
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
		if not has_point(point_relative_index):
			continue
		# Note the 3rd argument. It tells the astar_node that we want the
		# connection to be bilateral: from point A to B and B to A
		# If you set this value to false, it becomes a one-way path
		# As we loop through all points we can set it to false
		if connect_points:
			connect_points(point_index, point_relative_index, true)
		else:
			disconnect_points(point_index, point_relative_index, true)

			
func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y

	
func calculate_point_index(point):
	return point.x + map_size.x * point.y


func find_path(world_start, world_end):
	_recalculate_path(world_start, world_end)
	var path_world = []
	for point in _point_path:
		var point_world = tile_map.map_to_world(Vector2(point.x, point.y))# + _half_cell_size
		path_world.append(point_world)
	return path_world


func _recalculate_path(map_start, map_end):
	var start_point_index = calculate_point_index(map_start)
	var end_point_index = calculate_point_index(map_end)
	# This method gives us an array of points. Note you need the start and end
	# points' indices as input
	_point_path = get_point_path(start_point_index, end_point_index)
