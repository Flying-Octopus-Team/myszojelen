extends SteeringBaseScript

func _get_direction() -> int:
	
	if _if_player_pressed_action("4directions_up"):
		return Character.Facing.TOP_RIGHT
	elif _if_player_pressed_action("4directions_down"):
		return Character.Facing.BOTTOM_LEFT
	elif _if_player_pressed_action("4directions_left"):
		return Character.Facing.TOP_LEFT
	elif _if_player_pressed_action("4directions_right"):
		return Character.Facing.BOTTOM_RIGHT
		
	return Character.Facing.NULL


func _if_player_pressed_action(action: String) -> bool:
	return Input.is_action_pressed(action) and not InputMap.get_action_list(action).empty()


func steer(delta: float) -> void:
	var requested_direction : int  = _get_direction()
		
	if (requested_direction == Character.Facing.NULL):
		return
		
	if (requested_direction != player.facing):
		player._rotate_to(requested_direction)
		var animation_timer = Timer.new()
		animation_timer.set_wait_time(wait_time_after_rotate)
		animation_timer.autostart = true
		yield(animation_timer, "timeout")
	player.move(player.get_forward_dir())
