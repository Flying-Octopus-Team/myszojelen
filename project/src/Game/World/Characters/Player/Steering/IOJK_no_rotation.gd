extends SteeringBaseScript

func steer(delta: float) -> bool:
	var requested_direction : int  = -1
	var facing_enum = Character.Facing
	
	if (Input.is_action_pressed("move_up_right")):
		requested_direction = facing_enum.TOP_RIGHT
	elif (Input.is_action_pressed("move_down_left")):
		requested_direction = facing_enum.BOTTOM_LEFT
	elif (Input.is_action_pressed("move_up_left")):
		requested_direction = facing_enum.TOP_LEFT
	elif (Input.is_action_pressed("move_down_right")):
		requested_direction = facing_enum.BOTTOM_RIGHT
		
	if (requested_direction > -1):
		if (requested_direction != player.facing):
			player._rotate_to(requested_direction)
			var t = Timer.new()
			t.set_wait_time(wait_time_after_rotate)
			t.start()
			yield(t, "timeout")
		player.move(player.get_forward_dir())
		return true
	return false
