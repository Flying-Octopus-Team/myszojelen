extends MarginContainer

onready var master_volume_slider : HSlider = $VBoxContainer/MasterVolume/MasterVolumeSlider
onready var audio_effects_slider : HSlider = $VBoxContainer/SoundEffects/SoundEffectsSlider

func _ready():
	master_volume_slider.value = Settings.master_volume
	audio_effects_slider.value = Settings.audio_effects_volume
	
	master_volume_slider.connect("value_changed", MusicPlayer, "set_volume")
	master_volume_slider.connect("value_changed", Settings, "set_master_volume")

	audio_effects_slider.connect("value_changed", Settings, "set_audio_effects_volume")
