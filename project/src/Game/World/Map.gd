extends TileMap

const EMPTY_TILE = -1


func _ready():
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)


func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)


func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
	
	if cell_target_type == EMPTY_TILE:
		return update_pawn_position(pawn, cell_start, cell_target)
	
	return null


func update_pawn_position(pawn, cell_start, cell_target) -> Vector2:
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, EMPTY_TILE)
	return map_to_world(cell_target)
