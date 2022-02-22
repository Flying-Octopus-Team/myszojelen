extends Button


func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.left or action == GUISteering.gui_actions.right:
		return
	
	emit_signal("pressed")
	get_parent().create_delay(1.1)
