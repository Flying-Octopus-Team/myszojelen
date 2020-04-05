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
