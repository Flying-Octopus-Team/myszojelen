extends MarginContainer

onready var master_volume_slider : HSlider = $VBoxContainer/MasterVolume/MasterVolumeSlider
onready var audio_effects_slider : HSlider = $VBoxContainer/SoundEffects/SoundEffectsSlider

onready var steering_btn : TextureButton = $VBoxContainer/SteeringBtn

onready var language_en_button : TextureButton = $VBoxContainer/Language/English
onready var language_pl_button : TextureButton = $VBoxContainer/Language/Polish

func _ready():
	
	_set_values()
	_connect_signals()


func _set_values() -> void:
	master_volume_slider.value = Settings.master_volume
	audio_effects_slider.value = Settings.audio_effects_volume

	_match_language()


func _connect_signals() -> void:
	master_volume_slider.connect("value_changed", MusicPlayer, "set_volume")
	master_volume_slider.connect("value_changed", Settings, "set_master_volume")

	audio_effects_slider.connect("value_changed", Settings, "set_audio_effects_volume")
	language_en_button.connect("pressed", self, "_set_language", [Settings.Language_enum.english])
	language_pl_button.connect("pressed", self, "_set_language", [Settings.Language_enum.polish])

	steering_btn.connect("pressed", self, "_show_steering_screen")	


func _show_steering_screen() -> void:
	$SteeringSettings.show()
	$VBoxContainer.hide()
  

func _set_language(language: int) -> void:
	Settings.set_language(language)

	_match_language()


func _match_language() -> void:
	match Settings.language:
		Settings.Language_enum.english:
			language_en_button.pressed = true
			language_pl_button.pressed = false
			TranslationServer.set_locale("en")

		Settings.Language_enum.polish:
			language_en_button.pressed = false
			language_pl_button.pressed = true
			TranslationServer.set_locale("pl")
