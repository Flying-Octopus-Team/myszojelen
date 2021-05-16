extends SteeringBaseScript

func _get_direction() -> int:
	
	if (Input.is_action_pressed("8directions_up_left") and not InputMap.get_action_list("8directions_up_left").empty()):
		return Character.Facing.TOP_LEFT
	elif (Input.is_action_pressed("8directions_up_right") and not InputMap.get_action_list("8directions_up_right").empty()):
		return Character.Facing.TOP_RIGHT
	elif (Input.is_action_pressed("8directions_down_left") and not InputMap.get_action_list("8directions_down_left").empty()):
		return Character.Facing.BOTTOM_LEFT
	elif (Input.is_action_pressed("8directions_down_right") and not InputMap.get_action_list("8directions_down_right").empty()):
		return Character.Facing.BOTTOM_RIGHT
	elif (Input.is_action_pressed("8directions_up") and not InputMap.get_action_list("8directions_up").empty()):
		return Character.Facing.TOP
	elif (Input.is_action_pressed("8directions_down") and not InputMap.get_action_list("8directions_down").empty()):
		return Character.Facing.BOTTOM
	elif (Input.is_action_pressed("8directions_left") and not InputMap.get_action_list("8directions_left").empty()):
		return Character.Facing.LEFT
	elif (Input.is_action_pressed("8directions_right") and not InputMap.get_action_list("8directions_right").empty()):
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
		animation_timer.autostart = true
		yield(animation_timer, "timeout")
		
	player.move(player.get_forward_dir())
