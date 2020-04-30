extends SteringBaseScript


func steer(delta:float) -> bool:
	if Input.is_action_just_pressed("rotate_left"):
		player._rotate(-1)
		return true

	elif Input.is_action_just_pressed("rotate_right"):
		player._rotate(1)
		return true
	
	return false
