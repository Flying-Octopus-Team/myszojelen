extends "res://src/MainMenu/SettingsScreen.gd"

func _ready():
	._ready()

	$VBoxContainer/BackBtn.connect("pressed", self, "_hide_screen")

func _hide_screen() -> void:
	get_tree().paused = false
	$"../../".hide()

func show_screen() -> void:
	master_volume_slider.value = Settings.master_volume
	audio_effects_slider.value = Settings.audio_effects_volume

	get_tree().paused = true
	$"../../".show()
