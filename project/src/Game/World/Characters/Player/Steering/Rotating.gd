extends SteeringBaseScript

const ROTATE_LEFT = -1
const ROTATE_RIGHT = 1

func _if_player_pressed_action(action: String) -> bool:
	return Input.is_action_pressed(action) and not InputMap.get_action_list(action).empty()

func steer(delta:float) -> void:
	if _if_player_pressed_action("rotation_left"):
		player._rotate(ROTATE_LEFT)

	elif _if_player_pressed_action("rotation_right"):
		player._rotate(ROTATE_RIGHT)
		
	elif _if_player_pressed_action("rotation_up"):
		player.move(player.get_forward_dir())
