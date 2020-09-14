extends TextureButton


func _init() -> void:
	pressed = !Settings.muted


func _ready() -> void:
	Settings.connect("muted_changed", self, "_on_muted_changed")


func _on_muted_changed(muted) -> void:
	pressed = !muted


func _on_toggled(button_pressed:bool) -> void:
	Settings.set_muted(!button_pressed)
