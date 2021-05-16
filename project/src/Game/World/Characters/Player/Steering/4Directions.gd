extends SteeringBaseScript

func _get_direction() -> int:
	
	if (Input.is_action_pressed("4directions_up") and not InputMap.get_action_list("4directions_up").empty()):
		return Character.Facing.TOP_RIGHT
	elif (Input.is_action_pressed("4directions_down") and not InputMap.get_action_list("4directions_down").empty()):
		return Character.Facing.BOTTOM_LEFT
	elif (Input.is_action_pressed("4directions_left") and not InputMap.get_action_list("4directions_left").empty()):
		return Character.Facing.TOP_LEFT
	elif (Input.is_action_pressed("4directions_right") and not InputMap.get_action_list("4directions_right").empty()):
		return Character.Facing.BOTTOM_RIGHT
		
	return -1

func steer(delta: float) -> void:
	var requested_direction : int  = _get_direction()
		
	if (requested_direction == -1):
		return
		
	if (requested_direction != player.facing):
		player._rotate_to(requested_direction)
		var animation_timer = Timer.new()
		animation_timer.set_wait_time(wait_time_after_rotate)
		animation_timer.autostart = true
		yield(animation_timer, "timeout")
	player.move(player.get_forward_dir())
