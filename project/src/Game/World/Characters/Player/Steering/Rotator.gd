extends baseSteeringScript

func steer(delta:float) -> void:
	if Input.is_action_just_pressed("rotate_left"):
		player._rotate(-1)

	elif Input.is_action_just_pressed("rotate_right"):
		player._rotate(1)
