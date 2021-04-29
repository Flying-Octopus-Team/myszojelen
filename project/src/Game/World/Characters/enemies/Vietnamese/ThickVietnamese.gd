extends Vietnamese

onready var hop_particles = $Pivot/HopParticles


func _ready() -> void:
	cutting_animation = {
		Facing.TOP_LEFT: "thick_cutting_up",
		Facing.TOP_RIGHT: "thick_cutting_up",
		Facing.BOTTOM_RIGHT: "thick_cutting_down",
		Facing.BOTTOM_LEFT: "thick_cutting_down"
	} 
	connect("move_end", self, "_emit_hop_particles")


func _emit_hop_particles() -> void:
	hop_particles.emitting = true


# Don't rand textures
func _rand_textures() -> void:
	pass

func _die() -> void:
	var position_map = tile_map.world_to_map(position)
	var point_index = tile_map.calculate_point_index(position_map)
	tile_map.astar_node.add_point(point_index, Vector3(position_map.x, position_map.y, 0.0))
	tile_map.astar_update_walkable_point(position_map)

	._die()
