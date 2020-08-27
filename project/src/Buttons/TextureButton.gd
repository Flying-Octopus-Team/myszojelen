extends TextureButton

export var upscale_on_hover := false
export var downscale_on_press := false


func _ready() -> void:
	connect("mouse_entered", $HoverSound, "play")
	connect("button_down", $ClickSound, "play")
	
	rect_pivot_offset = rect_size * 0.5
	
	if upscale_on_hover:
		connect("mouse_entered", self, "_upscale")
		connect("mouse_exited", self, "_reset_scale")
	
	if downscale_on_press:
		connect("button_down", self, "_downscale")
		
		var reset_method : String
		
		if upscale_on_hover:
			reset_method = "_upscale"  
		else:
			reset_method = "_reset_scale"
	
		connect("button_up", self, reset_method)


func _upscale() -> void:
	rect_scale = Vector2(1.05, 1.05)


func _downscale() -> void:
	rect_scale = Vector2(0.95, 0.95)


func _reset_scale() -> void:
	rect_scale = Vector2.ONE
