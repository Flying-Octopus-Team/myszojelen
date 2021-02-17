extends SteeringBaseScript

var force_move : bool = false

func _get_direction() -> int:
	
	if Input.is_action_pressed("move_up_left"):
		force_move = Input.is_action_just_pressed("move_up_left")
		return Character.Facing.TOP_LEFT
	
	elif Input.is_action_pressed("move_down_right"):
		force_move = Input.is_action_just_pressed("move_down_right")
		return Character.Facing.BOTTOM_RIGHT
	
	elif Input.is_action_pressed("move_bottom_left"):
		force_move = Input.is_action_just_pressed("move_bottom_left")
		return Character.Facing.BOTTOM_LEFT
	
	elif Input.is_action_pressed("move_up_right"):
		force_move = Input.is_action_just_pressed("move_up_right")
		return Character.Facing.TOP_RIGHT
		
	return -1

func steer(delta:float) -> void:
	var requested_direction : int = _get_direction()
	
	if requested_direction == -1:
		return
		
	if requested_direction != player.facing:
		player._rotate_to(requested_direction)
		_time_after_rotate = 0.0
	elif ((force_move and player.facing == requested_direction) 
		or _time_after_rotate >= wait_time_after_rotate):
		player.move(player.get_forward_dir())
	else:
		_time_after_rotate += delta
