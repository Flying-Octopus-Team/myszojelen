extends Enemy


func _ready() -> void:
	move_animation_name = "drive"
	animation_player.play(move_animation_name)
