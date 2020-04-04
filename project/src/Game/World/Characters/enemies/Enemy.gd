extends Character
class_name Enemy

export var cutting_speed : int = 1

export var hp : int = 1

onready var next_move_timer : Timer = $NextMoveTimer

enum State { IDLE, WALK, CUTTING }
var state : int = State.WALK setget set_state

var cutted_tree : WorldObject = null


func set_state(s:int) -> void:
	var previous_state = state
	state = s
	_on_state_changed(previous_state)


func _on_state_changed(previous_state:int) -> void:
	pass


func _on_NextMoveTimer_timeout():
	match state:
		State.IDLE:
			pass
		State.WALK:
			if previous_position != null:
				tile_map.set_cellv(tile_map.world_to_map(previous_position), tile_map.EMPTY_TILE)
				previous_position = null
				
			var tree_pos = _get_nearest_tree_map_position()
			if tree_pos == null:
				_go_to_tree()
			else:
				cutted_tree = tile_map.get_world_object_from_map_pos(tree_pos)
				cutted_tree.connect("cutted", self, "_on_cutted_tree_cutted")
				set_state(State.CUTTING)
				_on_NextMoveTimer_timeout()
		State.CUTTING:
			_cut_tree()


func _get_nearest_tree_map_position():
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


func _go_to_tree() -> void:
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
			
			if path_to_tree.size() > 0 and (first_iteration or path_to_tree.size() < closest_path.size()):
				closest_path = path_to_tree
				first_iteration = false
	
	return closest_path


func _cut_tree():
	var tree_map_pos = tile_map.world_to_map(cutted_tree.position)
	
	var expected_facing = get_expected_facint_based_on_target_map_position(tree_map_pos)
	if facing != expected_facing:
		_rotate_to(expected_facing)
	
	tile_map.cut_tree(tree_map_pos, cutting_speed)


func _on_cutted_tree_cutted() -> void:
	set_state(State.WALK)


func hit() -> void:
	hp -= 1
	
	if hp <= 0:
		die()


func die() -> void:
	set_state(State.IDLE)
	
	if cutted_tree:
		cutted_tree.stop_cutting()
	
	type = Type.EMPTY
	tile_map.set_cellv(tile_map.world_to_map(position), tile_map.EMPTY_TILE)
	
	if previous_position != null:
		tile_map.set_cellv(tile_map.world_to_map(previous_position), tile_map.EMPTY_TILE)
		previous_position = null
	
	_die()
	
	tile_map.on_enemy_died()


# To override
func _die() -> void:
	queue_free()
