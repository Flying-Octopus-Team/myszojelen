extends SteeringBaseScript

const ONE_EIGHTH_PI = PI / 8.0

export var joy_sensinitivy := 0.5 


func steer(delta:float) -> void:
	var requested_direction = _get_axis_from_joy()
	
	if requested_direction == -1:
		return
	
	if (requested_direction != player.facing):
		player._rotate_to(requested_direction)
		var animation_timer = Timer.new()
		animation_timer.set_wait_time(wait_time_after_rotate)
		animation_timer.autostart = true
		yield(animation_timer, "timeout")
	player.move(player.get_forward_dir())
	


func _get_axis_from_joy() -> int:
	var joy_vec := Vector2.ZERO
	
	if touchscreen_layer.visible:
		joy_vec = touchscreen_layer.get_joy_vec()
	
	if Input.get_connected_joypads().size() > 0:
		var joypad_vec = Vector2(
			Input.get_joy_axis(0, JOY_AXIS_0),
			Input.get_joy_axis(0, JOY_AXIS_1)
		)
		
		if joypad_vec.length_squared() > joy_vec.length_squared():
			joy_vec = joypad_vec
	
	if joy_vec.length() < joy_sensinitivy:
		return -1
	
	var joy_angle = joy_vec.angle()
	
	if joy_angle < ONE_EIGHTH_PI and joy_angle > -ONE_EIGHTH_PI:
		return Character.Facing.RIGHT
	elif joy_angle > -3*ONE_EIGHTH_PI and joy_angle < -ONE_EIGHTH_PI:
		return Character.Facing.TOP_RIGHT
	elif joy_angle > -5*ONE_EIGHTH_PI and joy_angle < -3*ONE_EIGHTH_PI:
		return Character.Facing.TOP
	elif joy_angle > -7*ONE_EIGHTH_PI and joy_angle < -5*ONE_EIGHTH_PI:
		return Character.Facing.TOP_LEFT
	elif joy_angle > ONE_EIGHTH_PI and joy_angle < 3*ONE_EIGHTH_PI:
		return Character.Facing.BOTTOM_RIGHT
	elif joy_angle > 3*ONE_EIGHTH_PI and joy_angle < 5*ONE_EIGHTH_PI:
		return Character.Facing.BOTTOM
	elif joy_angle > 5*ONE_EIGHTH_PI and joy_angle < 7*ONE_EIGHTH_PI:
		return Character.Facing.BOTTOM_LEFT
	else:
		return Character.Facing.LEFT
	
	return -1
