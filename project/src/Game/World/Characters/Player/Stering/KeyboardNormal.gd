extends SteringBaseScript


func steer(delta:float) -> bool:
	var requested_direction : int = -1
	var force_move := false
	var facing = player.facing
	
	var Facing = Character.Facing
	
	if _want_move_to_dir("up"):
		force_move = Input.is_action_just_pressed("ui_up")
		requested_direction = Facing.TOP_RIGHT
	
	elif _want_move_to_dir("down"):
		force_move = Input.is_action_just_pressed("ui_down")
		requested_direction = Facing.BOTTOM_LEFT
	
	elif _want_move_to_dir("left"):
		force_move = Input.is_action_just_pressed("ui_left")
		requested_direction = Character.Facing.TOP_LEFT
	
	elif _want_move_to_dir("right"):
		force_move = Input.is_action_just_pressed("ui_right")
		requested_direction = Facing.BOTTOM_RIGHT
	
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


func _want_move_to_dir(dir:String) -> bool:
	return Input.is_action_pressed("ui_" + dir)
