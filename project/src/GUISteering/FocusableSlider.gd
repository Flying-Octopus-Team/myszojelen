extends TextureRect

onready var slider : HSlider = get_child(0)

func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.left:
		slider.set_value(max(slider.get_min(), slider.get_value()-0.01))
	elif action == GUISteering.gui_actions.right:
		slider.set_value(min(slider.get_max(), slider.get_value()+0.01))
