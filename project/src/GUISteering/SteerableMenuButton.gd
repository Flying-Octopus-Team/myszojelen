extends Button

var gui_steering = GUISteering.new()

signal id_pressed

func handle_on_focus_entered() -> void:
	set_scale(Vector2(1.3, 1.3))

func handle_on_focus_exited() -> void:
	set_scale(Vector2.ONE)

func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.press:
		$PopupPanel.popup_centered()
		$PopupPanel/FocusableVBoxContainer.grab_focus()

func on_popup_button_pressed(steering_string: String) -> void:
	emit_signal("id_pressed", steering_string)

	$PopupPanel.hide()
	$"../".grab_focus()
