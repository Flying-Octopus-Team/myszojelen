extends SteringBaseScript


func steer(delta:float) -> void:
	var requested_direction : int = -1
	var force_move := false
	var facing = player.facing
	
	var Facing = Character.Facing
	
	if Input.is_action_just_pressed("rotate_left"):
		player._rotate(-1)
	
	elif Input.is_action_just_pressed("rotate_right"):
		player._rotate(1)
	
	if Input.is_key_pressed(KEY_CONTROL):
		return
	
	if Input.is_action_pressed("ui_up"):
		force_move = Input.is_action_just_pressed("ui_up") and facing == Facing.TOP_RIGHT
		requested_direction = Facing.TOP_RIGHT
	
	elif Input.is_action_pressed("ui_down"):
		force_move = Input.is_action_just_pressed("ui_down") and facing == Facing.BOTTOM_LEFT
		requested_direction = Facing.BOTTOM_LEFT
	
	elif Input.is_action_pressed("ui_left"):
		force_move = Input.is_action_just_pressed("ui_left") and facing == Facing.TOP_LEFT
		requested_direction = Character.Facing.TOP_LEFT
	
	elif Input.is_action_pressed("ui_right"):
		force_move = Input.is_action_just_pressed("ui_right") and facing == Facing.BOTTOM_RIGHT
		requested_direction = Facing.BOTTOM_RIGHT
	
	if requested_direction > -1:
		if requested_direction != facing:
			player._rotate_to(requested_direction)
			_time_after_rotate = 0.0
		elif force_move or _time_after_rotate >= wait_time_after_rotate:
			player.move(player.get_forward_dir())
		else:
			_time_after_rotate += delta
