extends SteeringBaseScript


func steer(delta:float) -> bool:
	var requested_direction : int = -1
	var force_move := false
	var facing = player.facing
	
	var Facing = Character.Facing
	
	if Input.is_action_pressed("move_up_left"):
		force_move = Input.is_action_just_pressed("move_up_left")
		requested_direction = Facing.TOP_LEFT
	
	elif Input.is_action_pressed("move_down_right"):
		force_move = Input.is_action_just_pressed("move_down_right")
		requested_direction = Facing.BOTTOM_RIGHT
	
	elif Input.is_action_pressed("move_bottom_left"):
		force_move = Input.is_action_just_pressed("move_bottom_left")
		requested_direction = Character.Facing.BOTTOM_LEFT
	
	elif Input.is_action_pressed("move_up_right"):
		force_move = Input.is_action_just_pressed("move_up_right")
		requested_direction = Facing.TOP_RIGHT
	
	if requested_direction > -1:
		if requested_direction != facing:
			player._rotate_to(requested_direction)
			_time_after_rotate = 0.0
			return true
		elif ((force_move and facing == requested_direction) 
			or _time_after_rotate >= wait_time_after_rotate):
			player.move(player.get_forward_dir())
			return true
		else:
			_time_after_rotate += delta
	
	return false
