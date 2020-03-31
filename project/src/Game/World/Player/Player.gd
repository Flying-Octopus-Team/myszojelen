extends Character


func _unhandled_key_input(event) -> void:
	if event.is_action_pressed("ui_up"):
		move(get_forward_dir())
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_left"):
		_rotate(-1)
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_right"):
		_rotate(1)
		get_tree().set_input_as_handled()
