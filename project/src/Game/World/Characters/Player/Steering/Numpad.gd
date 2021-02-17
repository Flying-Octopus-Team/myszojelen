extends SteeringBaseScript

func _get_direction() -> int:
	
	if (Input.is_action_pressed("move_up_left") 
		or (Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"))):
		return Character.Facing.TOP_LEFT
	elif (Input.is_action_pressed("move_up_right")
		or (Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"))):
		return Character.Facing.TOP_RIGHT
	elif (Input.is_action_pressed("move_down_left")
		or (Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"))):
		return Character.Facing.BOTTOM_LEFT
	elif (Input.is_action_pressed("move_down_right") 
		or (Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"))):
		return Character.Facing.BOTTOM_RIGHT
	elif (Input.is_action_pressed("ui_up")):
		return Character.Facing.TOP
	elif (Input.is_action_pressed("ui_down")):
		return Character.Facing.BOTTOM
	elif (Input.is_action_pressed("ui_left")):
		return Character.Facing.LEFT
	elif (Input.is_action_pressed("ui_right")):
		return Character.Facing.RIGHT
		
	return -1

func steer(delta: float) -> void:
	
	var requested_direction = _get_direction()
	
	if (requested_direction == -1):
		return
		
	if (requested_direction != player.facing):
		player._rotate_to(requested_direction)
		var animation_timer = Timer.new()
		animation_timer.set_wait_time(wait_time_after_rotate)
		animation_timer.start()
		yield(animation_timer, "timeout")
		
	player.move(player.get_forward_dir())
