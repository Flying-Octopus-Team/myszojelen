extends "res://src/MainMenu/SettingsScreen.gd"

func _ready():
	$MainSettings/HBoxContainer/BackBtnContainer/BackBtn.connect("pressed", self, "hide")

func hide():
	.hide()
	$"../PauseScreen".show()

func show():
	$MainSettings.master_volume_slider.value = Settings.master_volume
	$MainSettings.audio_effects_slider.value = Settings.audio_effects_volume

	$SteeringSettings.update_controls_menu()

	.show()
