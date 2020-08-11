extends TextureButton


func _ready() -> void:
	self.pressed = Settings.music_volume > Settings.NO_VOLUME


func _on_toggled(button_pressed:bool) -> void:
	if button_pressed:
		Settings.music_volume = Settings.FULL_VOLUME 
	else:
		Settings.music_volume = Settings.NO_VOLUME
