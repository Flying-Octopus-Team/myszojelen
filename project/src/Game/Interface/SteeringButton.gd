extends TextureButton

func _ready() -> void:
	connect("pressed", $"../../../", "set_steering", [self.name, self.texture_normal])
		
func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.left or action == GUISteering.gui_actions.right:
		return

	emit_signal("pressed")
