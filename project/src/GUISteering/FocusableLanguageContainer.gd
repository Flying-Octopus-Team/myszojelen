extends MarginContainer


func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.left:
		$English.emit_signal("pressed")
	elif action == GUISteering.gui_actions.right:
		$Polish.emit_signal("pressed")
