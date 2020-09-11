extends MarginContainer

onready var master_volume_slider : HSlider = find_node("MasterVolumeSlider")


func _ready():
	master_volume_slider.connect("value_changed", Settings, "set_master_volume_range")
	Settings.connect("master_volume_changed", master_volume_slider, "set_value")
