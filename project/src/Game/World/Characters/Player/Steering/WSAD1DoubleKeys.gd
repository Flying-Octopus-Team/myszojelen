extends SteeringBaseScript

var _direction_actions = {
	"up": [ "ui_up", "ui_right" ],
	"down": [ "ui_down", "ui_left" ],
	"left": [ "ui_up", "ui_left" ],
	"right": [ "ui_down", "ui_right" ]
}

var force_move := false

func _get_direction() -> int:
	
	if _want_move_to_dir("up"):
		force_move = Input.is_action_just_pressed("ui_up")
		return Character.Facing.TOP_RIGHT
	
	elif _want_move_to_dir("down"):
		force_move = Input.is_action_just_pressed("ui_down")
		return Character.Facing.BOTTOM_LEFT
	
	elif _want_move_to_dir("left"):
		force_move = Input.is_action_just_pressed("ui_left")
		return Character.Facing.TOP_LEFT
	
	elif _want_move_to_dir("right"):
		force_move = Input.is_action_just_pressed("ui_right")
		return Character.Facing.BOTTOM_RIGHT
		
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

func _want_move_to_dir(dir:String) -> bool:
	return (
		Input.is_action_pressed(_direction_actions[dir][0]) and
		Input.is_action_pressed(_direction_actions[dir][1])
	)
