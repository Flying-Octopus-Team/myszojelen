extends TextureButton

export var steering_string: String = "none"

func handle_on_focus_entered() -> void:
	set_scale(Vector2(1.3, 1.3))

func handle_on_focus_exited() -> void:
	set_scale(Vector2.ONE)

func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.press:
		$"../../../../".on_popup_button_pressed(steering_string)

func _pressed():
	$"../../../../".on_popup_button_pressed(steering_string)
