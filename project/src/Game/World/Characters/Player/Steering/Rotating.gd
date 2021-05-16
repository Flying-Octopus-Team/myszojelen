extends SteeringBaseScript

func steer(delta:float) -> void:
	if Input.is_action_just_pressed("rotation_left") and not InputMap.get_action_list("rotation_left").empty():
		player._rotate(-1)

	elif Input.is_action_just_pressed("rotation_right") and not InputMap.get_action_list("rotation_right").empty():
		player._rotate(1)
		
	elif Input.is_action_just_pressed("rotation_up") and not InputMap.get_action_list("rotation_up").empty():
		player.move(player.get_forward_dir())
