extends Node2D


func _ready() -> void:
	$YSort/Player.tile_map = $Map
	_tile_map_to_world()
	$Map.hide()


func _tile_map_to_world() -> void:
	var map : TileMap = $Map
	
	var all_tiles = map.get_used_cells()
	
	for tile_pos in all_tiles:
		var sprite = Sprite.new()
		var id = map.get_cell(tile_pos.x, tile_pos.y)
		sprite.texture = map.tile_set.tile_get_texture(id)
		sprite.position = map.map_to_world(tile_pos)
		$YSort.add_child(sprite)
