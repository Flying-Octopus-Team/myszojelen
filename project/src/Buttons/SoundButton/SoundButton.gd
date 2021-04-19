extends TextureButton


func _init() -> void:
	return #pressed = !Settings.muted


func _ready() -> void:
	return #Settings.connect("muted_changed", self, "_on_muted_changed")


func _on_muted_changed(muted) -> void:
	return #pressed = !muted


func _on_toggled(button_pressed:bool) -> void:
	return #Settings.set_muted(!button_pressed)
