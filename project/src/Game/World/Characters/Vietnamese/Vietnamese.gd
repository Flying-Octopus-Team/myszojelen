extends Character

export var time_to_next_move := 0.5

onready var next_move_timer : Timer = $NextMoveTimer


func _ready() -> void:
	randomize()
	next_move_timer.wait_time = time_to_next_move + rand_range(-0.2, 0.2)
	next_move_timer.start()


func _on_NextMoveTimer_timeout():
	var tree_pos = _nearest_tree_position()
	
	if tree_pos == null:
		_walk_to_tree()
	else:
		_cut_tree(tree_pos)
	
	next_move_timer.wait_time = time_to_next_move + rand_range(-0.2, 0.2)


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
#		set_process(false)
		move_to(target_pos)
		
#		yield(pivot_move_tween, "tween_all_completed")
#		set_process(true)


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
	tile_map.cut_tree(tree_map_pos)

