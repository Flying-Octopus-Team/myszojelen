extends SteringBaseScript

const HALF_PI = PI / 2.0

export var joy_sensinitivy := 0.5 


func steer(delta:float) -> bool:
	var requested_direction = _get_axis_from_joy()
	
	if requested_direction == -1:
		return false
	
	if requested_direction != player.facing:
		player._rotate_to(requested_direction)
		_time_after_rotate = 0.0
	
	elif _time_after_rotate >= wait_time_after_rotate:
		player.move(player.get_forward_dir())
	
	else:
		_time_after_rotate += delta
	
	return true


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
	
	if joy_angle < 0 and joy_angle > -HALF_PI:
		return Character.Facing.TOP_RIGHT
	elif joy_angle < -HALF_PI and joy_angle > -PI:
		return Character.Facing.TOP_LEFT
	elif joy_angle > 0 and joy_angle < HALF_PI:
		return Character.Facing.BOTTOM_RIGHT
	elif joy_angle > HALF_PI and joy_angle < PI:
		return Character.Facing.BOTTOM_LEFT
	
	return -1
