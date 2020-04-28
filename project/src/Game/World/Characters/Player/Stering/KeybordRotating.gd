extends SteringBaseScript


func steer(delta:float) -> bool:
	if Input.is_action_just_pressed("ui_left"):
		player._rotate(-1)
		return true

	elif Input.is_action_just_pressed("ui_right"):
		player._rotate(1)
		return true
	
	elif Input.is_action_pressed("ui_up"):
		return true
	
	return false
