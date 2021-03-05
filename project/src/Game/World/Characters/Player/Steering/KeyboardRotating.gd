extends SteeringBaseScript

func steer(delta:float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		player._rotate(-1)

	elif Input.is_action_just_pressed("ui_right"):
		player._rotate(1)
		
	elif Input.is_action_just_pressed("ui_up"):
		player.move(player.get_forward_dir())
