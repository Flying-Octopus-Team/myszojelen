extends HSlider

func handle_on_focus_entered() -> void:
	set_scale(Vector2(1.3, 1.3))

func handle_on_focus_exited() -> void:
	set_scale(Vector2.ONE)

func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.left:
		set_value(max(get_min(), get_value()-0.01))
	elif action == GUISteering.gui_actions.right:
		set_value(min(get_max(), get_value()+0.01))
