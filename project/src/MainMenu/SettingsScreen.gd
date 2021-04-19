extends MarginContainer

onready var master_volume_slider : HSlider = find_node("MasterVolumeSlider")


func _ready():
	master_volume_slider.value = Settings.master_volume
	
	master_volume_slider.connect("value_changed", MusicPlayer, "set_volume")
