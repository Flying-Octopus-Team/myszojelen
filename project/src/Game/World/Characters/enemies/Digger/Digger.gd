extends Enemy

export var buried_up_texture : Texture
export var buried_down_texture : Texture


func _ready() -> void:
	move_animation_name = "drive"
	animation_player.play(move_animation_name)


func hit() -> void:
	.hit()
	
	if hp == 2:
		$Pivot/FumesParticlesBack.emitting = true
	elif hp == 1:
		$Pivot/FumesParticlesFront.emitting = true


func _die() -> void:
	# Unallow walking through
	# Leaving `type` set to Type.EMPTY allows shooting through
	tile_map.set_cellv(tile_map.world_to_map(position), Type.ENEMY)
	
	_change_texture_to_burried()
	animation_player.stop()


func _change_texture_to_burried() -> void:
	var new_texture : Texture
	
	match facing:
		Facing.TOP_LEFT, Facing.TOP_RIGHT:
			new_texture = buried_up_texture
		
		Facing.BOTTOM_LEFT, Facing.BOTTOM_RIGHT:
			new_texture = buried_down_texture
	
	sprite.texture = buried_up_texture
