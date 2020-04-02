extends Character

onready var next_move_timer : Timer = $NextMoveTimer

var cutted_tree : WorldObject = null


func _ready() -> void:
	move_animation_name = "drive"
	yield(get_parent().get_parent(), "ready")


func _on_NextMoveTimer_timeout():
	var tree_pos = _nearest_tree_position()
	
	if tree_pos == null:
		_walk_to_tree()
	else:
		_cut_tree(tree_pos)


func _nearest_tree_position():
	var pos_on_map = tile_map.world_to_map(position)
	
	var points_relative = PoolVector2Array([
		Vector2(pos_on_map.x + 1, pos_on_map.y),
		Vector2(pos_on_map.x - 1, pos_on_map.y),
		Vector2(pos_on_map.x, pos_on_map.y + 1),
		Vector2(pos_on_map.x, pos_on_map.y - 1)])
	
	for point_relative in points_relative:
		var cell : int = tile_map.get_cellv(point_relative)
		if cell == tile_map.TREE_ID:
			return point_relative
	
	return null


func _walk_to_tree() -> void:
	var path_to_target_tree = get_path_to_closest_tree_world_pos()
	
	if path_to_target_tree.size() < 2:
		return
	
	var target_pos = tile_map.request_move_world_pos(self, path_to_target_tree[1])
	if target_pos != null:
		set_facing_base_on_target_position(target_pos)
		move_to(target_pos)


func set_facing_base_on_target_position(target_position:Vector2) -> void:
	var target_on_map = tile_map.world_to_map(target_position)
	facing = get_expected_facint_based_on_target_map_position(target_on_map)
	update_texture()


func get_expected_facint_based_on_target_map_position(target_map_pos:Vector2) -> int:
	var pos_on_map = tile_map.world_to_map(position)
	var direction = target_map_pos - pos_on_map
	
	if direction.x > 0:
		return Facing.BOTTOM_RIGHT
	elif direction.x < 0:
		return Facing.TOP_LEFT
	elif direction.y > 0:
		return Facing.BOTTOM_LEFT
	else:
		return Facing.TOP_RIGHT


func get_path_to_closest_tree_world_pos() -> Array:
	var trees = tile_map.get_used_cells_by_id_in_map_range(tile_map.TREE_ID)
	
	if trees.empty():
		return []
	
	var closest_path : Array = []
	var first_iteration := true
	
	for i in range(0, trees.size()):
		var tree = trees[i] 
		
		var points_relative = PoolVector2Array([
			Vector2(tree.x + 1, tree.y),
			Vector2(tree.x - 1, tree.y),
			Vector2(tree.x, tree.y + 1),
			Vector2(tree.x, tree.y - 1)])
		
		for point_relative in points_relative:
			var near_tree_world_pos = tile_map.map_to_world(point_relative)
			var path_to_tree = tile_map.find_path(position, near_tree_world_pos)
			
			if first_iteration or path_to_tree.size() < closest_path.size():
				closest_path = path_to_tree
				first_iteration = false
	
	return closest_path


func _cut_tree(tree_map_pos:Vector2) -> void:
	cutted_tree = tile_map.cut_tree(tree_map_pos)
	var expected_facing = get_expected_facint_based_on_target_map_position(tree_map_pos)
	if facing != expected_facing:
		_rotate_to(expected_facing)
