extends SteeringBaseScript

func _get_direction() -> int:
	
	if (Input.is_action_pressed("move_up_left") 
		or (Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"))):
		return facing_enum.TOP_LEFT
	elif (Input.is_action_pressed("move_up_right")
		or (Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"))):
		return facing_enum.TOP_RIGHT
	elif (Input.is_action_pressed("move_down_left")
		or (Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"))):
		return facing_enum.BOTTOM_LEFT
	elif (Input.is_action_pressed("move_down_right") 
		or (Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"))):
		return facing_enum.BOTTOM_RIGHT
	elif (Input.is_action_pressed("ui_up")):
		return facing_enum.TOP
	elif (Input.is_action_pressed("ui_down")):
		return facing_enum.BOTTOM
	elif (Input.is_action_pressed("ui_left")):
		return facing_enum.LEFT
	elif (Input.is_action_pressed("ui_right")):
		return facing_enum.RIGHT
		
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
