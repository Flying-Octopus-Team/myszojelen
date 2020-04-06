extends TextureButton


func _ready() -> void:
	connect("mouse_entered", $HoverSound, "play")
	connect("button_down", $ClickSound, "play")
