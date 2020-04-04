extends Enemy


func _ready() -> void:
	move_animation_name = "drive"
	animation_player.play(move_animation_name)


func hit() -> void:
	.hit()
	
	if hp == 2:
		$Pivot/FumesParticlesBack.emitting = true
	elif hp == 1:
		$Pivot/FumesParticlesFront.emitting = true
