extends TextureButton

export var steering_string: String = "none"


func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.press:
		find_parent("MenuButton").on_popup_button_pressed(steering_string)

func _pressed():
	find_parent("MenuButton").on_popup_button_pressed(steering_string)
