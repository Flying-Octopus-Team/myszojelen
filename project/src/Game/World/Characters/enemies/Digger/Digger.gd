extends Enemy

var hited_times : int


func _ready() -> void:
	move_animation_name = "drive"
	animation_player.play(move_animation_name)


func hit() -> void:
	hited_times += 1
	
	if hited_times == 1:
		_show_fumes()
	elif hited_times == 3:
		die()


func _show_fumes() -> void:
	$Pivot/FumesParticlesBack.emitting = true
	$Pivot/FumesParticlesFront.emitting = true


func die() -> void:
	queue_free()
