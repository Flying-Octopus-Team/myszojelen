extends Character
class_name Enemy

export var cut_speed_modifier : float = 1.0

export var hp : int = 1

export var fade_out_time := 1.0
onready var fade_out_tween : Tween = $FadeOutTween

onready var next_move_timer : Timer = $NextMoveTimer

onready var tree_cutting_sound : AudioStreamPlayer = $TreeCuttingSound

enum State { IDLE, WALK, CUTTING }
var state : int = State.WALK setget set_state

var cut_tree : WorldObject = null

var path_to_tree = []
var targetted_tree : Vector2

func _ready():
	next_move_timer.wait_time = 1 / move_speed
	fade_out_tween.connect("tween_all_completed", self, "_on_fade_out_completed")

	$TreeCuttingSound.set_volume_db(linear2db(Settings.audio_effects_volume))


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
				var move_success = _go_to_tree()
				if not move_success:
					path_to_tree = get_path_to_closest_tree_world_pos()
			else:
				cut_tree = tile_map.get_node(tile_map.get_world_object_from_map_pos(tree_pos).tilemap_path)
				cut_tree.connect("cut", self, "_on_cut_tree_cut")
				set_state(State.CUTTING)
				_on_NextMoveTimer_timeout()
		State.CUTTING:
			_cut_tree()


func _get_nearest_tree_map_position():
	var pos_on_map = tile_map.world_to_map(position)
	
	var points_relative = _get_relative_positions(pos_on_map)
	
	for point_relative in points_relative:
		var cell : int = tile_map.get_cellv(point_relative)
		if cell == tile_map.TREE_ID:
			return point_relative
	
	return null


func _go_to_tree() -> bool:
	if	path_to_tree.size() < 1:
		return false
	
	var target_pos = tile_map.request_move_world_pos(self, path_to_tree[0])
	if target_pos == null:
		return false

	set_facing_base_on_target_position(target_pos)
	move_to(target_pos)

	path_to_tree.pop_front()
	return true


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


func _get_relative_positions(position) -> PoolVector2Array:
	return PoolVector2Array([
		Vector2(position.x + 1, position.y),
		Vector2(position.x - 1, position.y),
		Vector2(position.x, position.y + 1),
		Vector2(position.x, position.y - 1)
	])

func get_path_to_closest_tree_world_pos() -> Array:
	var trees = _get_trees_array()

	var map_position = tile_map.world_to_map(position)
	_add_position_in_astar()

	var closest_path : Array = []
	var first_iteration := true
	
	for tree in trees:
		
		var points_relative = _get_relative_positions(tree)
		
		for point_relative in points_relative:
			var path_to_tree = tile_map.astar_node.find_path(map_position, point_relative)
			
			if path_to_tree.size() > 0 and (first_iteration or path_to_tree.size() < closest_path.size()):
				closest_path = path_to_tree
				targetted_tree = tree
				first_iteration = false
	
	_remove_position_in_astar()

	closest_path.pop_front()
	return closest_path


func _get_trees_array() -> Array:
	if tile_map.get_cellv(targetted_tree) != tile_map.TREE_ID:
		return tile_map.get_used_cells_by_id_in_map_range(tile_map.TREE_ID)
	else: 
		return [targetted_tree]


func _add_position_in_astar() -> void:
	var map_position = tile_map.world_to_map(position)
	var this_astar_index = tile_map.astar_node.calculate_point_index(map_position)

	tile_map.astar_node.add_point(this_astar_index, Vector3(map_position.x, map_position.y, 0.0))
	tile_map.astar_node.update_walkable_point(tile_map.world_to_map(position))

func _remove_position_in_astar() -> void:
	var map_position = tile_map.world_to_map(position)
	var this_astar_index = tile_map.astar_node.calculate_point_index(map_position)

	tile_map.astar_node.update_walkable_point(map_position, false)
	tile_map.astar_node.remove_point(this_astar_index)

func _cut_tree():

	if tree_cutting_sound.get_volume_db() != linear2db(Settings.audio_effects_volume):
		tree_cutting_sound.set_volume_db(linear2db(Settings.audio_effects_volume))

	var tree_map_pos = tile_map.world_to_map(cut_tree.position)
	
	var expected_facing = get_expected_facint_based_on_target_map_position(tree_map_pos)
	if facing != expected_facing:
		_rotate_to(expected_facing)
	
	tile_map.cut_tree(tree_map_pos, cut_speed_modifier)
	
	tree_cutting_sound.play()


func _on_cut_tree_cut() -> void:
	set_state(State.WALK)


func hit() -> void:
	hp -= 1
	
	if hp <= 0:
		die()


func die() -> void:
	set_state(State.IDLE)
	
	if cut_tree:
		cut_tree.stop_cutting()
	
	type = Type.EMPTY
	tile_map.set_cellv(tile_map.world_to_map(position), tile_map.EMPTY_TILE)
	tile_map.get_world_object_from_map_pos(tile_map.world_to_map(position)).type = WorldObject.Type.EMPTY
	
	if previous_position != null:
		tile_map.set_cellv(tile_map.world_to_map(previous_position), tile_map.EMPTY_TILE)
		previous_position = null
	
	_die()
	
	tile_map.on_enemy_died()


# To override
func _die() -> void:
	fade_out_tween.interpolate_property(self, "modulate", null, Color(1.0, 1.0, 1.0, 0.0), fade_out_time)
	fade_out_tween.start()


func _on_fade_out_completed() -> void:
	queue_free()
