extends "res://src/MainMenu/SettingsScreen.gd"

func _ready():
	$MainSettings/BackBtnContainer/BackBtn.connect("pressed", self, "_hide_screen")

func _hide_screen() -> void:
	get_tree().paused = false
	$"../../".hide()

func show_screen() -> void:
	$MainSettings.master_volume_slider.value = Settings.master_volume
	$MainSettings.audio_effects_slider.value = Settings.audio_effects_volume

	$SteeringSettings.update_controls_menu()

	get_tree().paused = true
	$"../../".show()
	show()
